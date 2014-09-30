package art.ciclope.managana.data {
	
	// FLASH PACKAGES
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.InterfaceAddress;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	import flash.net.ServerSocket;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.Socket;
	import flash.system.System;
	import flash.utils.ByteArray;
	
	// CICLOPE CLASSES
	import art.ciclope.staticfunctions.StringFunctions;
	import art.ciclope.event.RemoteTCPEvent;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * RemoteTCPData create a TCP server for remote controls.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class RemoteTCPData extends EventDispatcher {
		
		// VARIABLES
		
		private var _id:String;					// the remote id
		private var _key:String;				// the remote access key
		private var _port:String;				// the connect port
		private var _server:ServerSocket;		// the server
		private var _reader:ReaderServer;		// a reference to the reader server
		private var _clients:Array;				// information about connected clients
		
		/**
		 * RemoteTCPData constructor.
		 * @param	reader	a reference to the reader server
		 */
		public function RemoteTCPData(reader:ReaderServer = null) {
			this._reader = reader;
			this._clients = new Array();
		}
		
		// READ-ONLY VALUES
		
		/**
		 * Is the server bound to a listening port?
		 */
		public function get isBound():Boolean {
			if (this._server != null) return (this._server.bound);
				else return (false);
		}
		
		/**
		 * Is the server mode available?
		 */
		public function get serverAvailable():Boolean {
			return (ServerSocket.isSupported);
		}
		
		/**
		 * The number of connected clients.
		 */
		public function get clients():uint {
			return (this._clients.length);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Set the reader server.
		 * @param	reader	the current reader server
		 */
		public function setReader(reader:ReaderServer):void {
			this._reader = reader;
		}
		
		/**
		 * Start the TCP server.
		 * @param	port	the port to listen to
		 * @param	id	the remote id
		 * @param	key	the remote connection key
		 * @return	true if the server can be started, false otherwise
		 */
		public function startServer(port:String, id:String, key:String):Boolean {
			// try to start the server
			if (ServerSocket.isSupported) {
				// get data
				this._id = id;
				this._key = key;
				this._port = port;
				// check local network addresses
				var localIP:Array = new Array;
				if (NetworkInfo.isSupported) {
					var netInterfaces:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
					if (netInterfaces && netInterfaces.length > 0) {
						for each (var i:NetworkInterface in netInterfaces) {
							if (i.active) {
								var addresses:Vector.<InterfaceAddress> = i.addresses;
								for each (var j:InterfaceAddress in addresses) {
									if (j.address.length > 4) localIP.push(j.address);
								}
							}
						}
					}
				}
				// start tcp server
				var ret:Boolean = false;
				try {
					this._server = new ServerSocket();
					this._server.addEventListener(ServerSocketConnectEvent.CONNECT, onClient);
					this._server.bind(int(port));
					this._server.listen();
					// write ip to the server
					if (this._reader != null) this._reader.registerTCP(this._port, this._id, this._key, localIP.join("|"));
					ret = true;
				} catch (e:Error) {	}
				return (ret);
			} else {
				return (false);
			}
		}
		
		/**
		 * Release resources used by the object.
		 */
		public function kill():void {
			this._reader = null;
			this._id = null;
			this._key = null;
			this._port = null;
			if (this._server != null) {
				if (this._server.bound) this._server.close();
				this._server = null;
			}
			while (this._clients.length > 0) {
				this._clients[0].removeEventListener(ProgressEvent.SOCKET_DATA, onClientSocketData);
				this._clients[0].removeEventListener(Event.CLOSE, onClientSocketClose);
				this._clients.shift();
			}
			this._clients = null;
		}
		
		/**
		 * Send a xml formatted message to a client or all connected clients.
		 * @param	message	the message to send
		 * @param	client	the client to send to - leave null to send to all connected clients
		 */
		public function sendToClient(message:String, client:Socket = null):void {
			message = '<?xml version="1.0" encoding="utf-8" ?><data><error>0</error>' + StringFunctions.cdataXML('id', this._id) + message + '</data>';
			if (client != null) {
				client.writeUTFBytes(message);
				client.flush();
			} else {
				for (var index:uint = 0; index < this._clients.length; index++) {
					this._clients[index].writeUTFBytes(message);
					this._clients[index].flush();
				}
			}
		}
		
		// PRIVATE METHODS
		
		/**
		 * A new client is trying to connect.
		 */
		private function onClient(evt:ServerSocketConnectEvent):void {
			var client:Socket = evt.socket;
			client.addEventListener(ProgressEvent.SOCKET_DATA, onClientSocketData);
			client.addEventListener(Event.CLOSE, onClientSocketClose);
			this._clients.push(client);
			// welcome the client
			client.writeUTFBytes('<?xml version="1.0" encoding="utf-8" ?><data><error>0</error><event>hello</event>' + StringFunctions.cdataXML('id', this._id) + '</data>');
			client.flush();
		}
		
		/**
		 * Data received from a connected client.
		 */
		private function onClientSocketData(evt:ProgressEvent):void {
			if (evt.target is Socket) {
				var client:Socket = evt.target as Socket;
				var buffer:ByteArray = new ByteArray();
				client.readBytes(buffer, 0, client.bytesAvailable);
				// parse the received message
				var recArray:Array = buffer.toString().split('<?xml version="1.0" encoding="utf-8" ?>');
				for (var index:uint = 0; index < recArray.length; index++) {
					if (recArray[index] != "") this.parseTCPMessage(buffer.toString(), client);
				}
			}
		}
		
		/**
		 * Parse a message receives from connected clients or server.
		 * @param	message	the message, expected on Managana TCP exchange xml format
		 * @param	client	the connected cliente that sent the message
		 */
		private function parseTCPMessage(message:String, client:Socket):void {
			try {
				var data:XML = new XML(message);
				// is the security key provided and correct?
				if (data.child("key").length() > 0) {
					if (String(data.key) == this._key) {
						// is an action defined?
						if (data.child("ac").length() > 0) {
							// check action
							var params:Object = new Object();
							params.command = String(data.ac);
							switch (String(data.ac)) {
								case "remoteTarget":
									params.pX = Number(data.pX);
									params.pY = Number(data.pY);
									break;
								case "remoteNavigate":
								case "remoteCustom":
								case "remoteOnScreen":
									params.reference = String(data.reference);
									break;
								case "remoteOnList":
									params.reference = String(data.reference);
									params.com = String(data.com);
									break;
								case "remoteOpen":
									params.reference = String(data.reference);
									params.data = String(data.pdata);
									break;
								case "remoteOnVote":
								case "remoteOnGuideVote":
									params.num = uint(data.num);
									break;
								case "remoteOnSound":
									params.reference = String(data.reference);
									params.volume = Number(data.volume);
									break;
								case "remoteOnZoom":
									params.reference = String(data.reference);
									params.zpX = Number(data.zpX);
									params.zpY = Number(data.zpY);
									break;
							}
							// warn listeners
							this.dispatchEvent(new RemoteTCPEvent(RemoteTCPEvent.ACTION, client, String(data.ac), params));
						}
					}
				}
				System.disposeXML(data);
			} catch (e:Error) { }
		}
		
		/**
		 * A client closed the connection.
		 */
		private function onClientSocketClose(evt:Event):void {
			if (evt.target is Socket) {
				var client:Socket = evt.target as Socket;
				client.removeEventListener(ProgressEvent.SOCKET_DATA, onClientSocketData);
				client.removeEventListener(Event.CLOSE, onClientSocketClose);
				// remove client from current ones
				for (var index:uint = 0; index < this._clients.length; index++) {
					if (this._clients[index] == client) this._clients.splice(index, 1);
				}
			}
		}
		
	}

}
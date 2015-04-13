package art.ciclope.net {
	
	// FLASH PACKAGES
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.ServerSocket;
	import flash.events.Event;
	import flash.net.Socket;
	import flash.events.ServerSocketConnectEvent;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	import flash.net.NetworkInterface;
	import flash.net.NetworkInfo;
	
	// CICLOPE CLASSES
	import art.ciclope.event.TCPDataEvent;
	
	// EVENTS
	
	/**
     * A message was just received from a connected client.
     */
    [Event( name = "RECEIVED", type = "art.ciclope.event.TCPDataEvent" )]
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * TCPServer creates TCP server and also provides useful functions to retrieve network addresses.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class TCPServer extends EventDispatcher {
		
		// PRIVATE VARIABLES
		
		protected var _server:ServerSocket;			// the server socket for connection
		protected var _port:uint;					// the server port for listening
		protected var _ready:Boolean;				// is the server ready?
		protected var _clients:Vector.<Socket>;		// the connected clients
		
		/**
		 * TCPServer constructor.
		 */
		public function TCPServer(target:flash.events.IEventDispatcher=null) {
			super(target);
			this._ready = false;
			this._clients = new Vector.<Socket>();
		}
		
		// READ-ONLY VALUES
		
		/**
		 * Is the TCP server ready?
		 */
		public function get ready():Boolean {
			return (this._ready);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Start the TCP server.
		 * @param	port	the port to listen to
		 */
		public function start(port:uint):void {
			this._port = port;
			try {
				this._server = new ServerSocket();
				this._server.addEventListener(Event.CONNECT, onSocketConnect);
				this._server.bind(this._port);
				this._server.listen();
				this._ready = true;
			} catch (e:Error) {
				this._ready = false;
			}
		}
		
		/**
		 * Get a single client index on list.
		 * @param	client	the client socket reference
		 * @return	the client index on list (-1 if not found)
		 */
		public function clientIndex(client:Socket):int {
			var found:int = -1;
			for (var i:uint = 0; i < this._clients.length; i++) {
				if (this._clients[i] == client) found = i;
			}
			return (found);
		}
		
		/**
		 * Terminate a client connection.
		 * @param	client	the client to close
		 * @return	true if the client is found and terminated, false otherwise
		 */
		public function kickClient(client:Socket):Boolean {
			var id:int = this.clientIndex(client);
			if (id < 0) {
				return (false);
			} else {
				this._clients.splice(id, 1);
				try {
					client.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
					client.close();
				} catch (e:Error) { }
				return (true);
			}
		}
		
		/**
		 * Terminate all current clients connections.
		 */
		public function kickAll():void {
			while (this._clients.length > 0) {
				try {
					this._clients[0].removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
					this._clients[0].close();
				} catch (e:Error) { }
				this._clients.shift();
			}
		}
		
		/**
		 * Send a message to a single connected client based on its index on clients list.
		 * @param	message	the message to send
		 * @param	num	the client number
		 * @return	true if the client is found and message sent, false otherwise
		 */
		public function sendToClientNum(message:String, num:uint):Boolean {
			if (this._clients[num] != null) {
				this._clients[num].writeUTFBytes(message);
				this._clients[num].flush();
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Send a message to a connected client base on its socket reference.
		 * @param	message	the message to send
		 * @param	client	the client socket reference
		 * @return	true if the client is found and message sent, false otherwise
		 */
		public function sendToClient(message:String, client:Socket):Boolean {
			return (this.sendToClientNum(message, this.clientIndex(client)));
		}
		
		/**
		 * Send a message to all connected clients.
		 * @param	message	the message to send
		 */
		public function sendToAll(message:String):void {
			for (var i:uint = 0; i < this._clients.length; i++) {
				this.sendToClientNum(message, i);
			}
		}
		
		/**
		 * Send a message to all connected clients but one.
		 * @param	message	the message to send
		 * @param	avoid	the socket reference of the client to avoid
		 */
		public function sendToAllBut(message:String, avoid:Socket):void {
			for (var i:uint = 0; i < this._clients.length; i++) {
				if (this._clients[i] != avoid) this.sendToClientNum(message, i);
			}
		}
		
		/**
		 * Send a message to all connected clients but one, referenced by its index number on clients list.
		 * @param	message	the message to send
		 * @param	num	the index number of the client to avoid
		 */
		public function sendToAllButNum(message:String, num:uint):void {
			for (var i:uint = 0; i < this._clients.length; i++) {
				if (i != num) this.sendToClientNum(message, i);
			}
		}
		
		// PRIVATE METHODS
		
		/**
		 * A new client just connected.
		 */
		private function onSocketConnect(evt:ServerSocketConnectEvent):void {
			var socket:Socket = evt.socket;
			if (this.clientIndex(socket) < 0) {
				this._clients.push(socket);
			} else {
				if (socket.hasEventListener(ProgressEvent.SOCKET_DATA)) {
					try {
						socket.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
					} catch (e:Error) { }
				}
				this._clients[this.clientIndex(socket)] = socket;
			}
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
		}
		
		/**
		 * New data received from a connected client.
		 */
		private function onSocketData(evt:ProgressEvent):void {
			var socket:Socket = evt.target as Socket;
			var bytes:ByteArray = new ByteArray();
			socket.readBytes(bytes);
			var received:String = '' + bytes;
			var json:Object = JSON.parse(received);
			socket.writeUTFBytes(JSON.stringify(json) + "\n");
			socket.flush();
			this.dispatchEvent(new TCPDataEvent(TCPDataEvent.RECEIVED, socket, ('' + bytes)));
		}
		
		// STATIC READ-ONLY VALUES
		
		/**
		 * All network addresses currently available on running device.
		 */
		static public function get allServerAddr():Vector.<String> {
			var ips:Vector.<String> = new Vector.<String>();
			var list:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
			for (var i:uint = 0; i < list.length; i++) {
				for (var j:uint = 0; j < list[i].addresses.length; j++) {
					ips.push(list[i].addresses[j].address);
				}
			}
			return (ips);
		}
		
		/**
		 * Currently-used IPV4 server address.
		 */
		static public function get serverActiveIPv4():Vector.<String> {
			var ips:Vector.<String> = new Vector.<String>();
			var list:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
			for (var i:uint = 0; i < list.length; i++) {
				if (list[i].active) {
					for (var j:uint = 0; j < list[i].addresses.length; j++) {
						if (list[i].addresses[j].ipVersion == 'IPv4') {
							if ((list[i].addresses[j].address != '127.0.0.1') && (list[i].addresses[j].address != 'localhost')) {
								ips.push(list[i].addresses[j].address);
							}
						}
					}
				}
			}
			return (ips);
		}
		
		/**
		 * Best guess for IPV4 server address.
		 */
		static public function get ipv4():String {
			if (TCPServer.serverActiveIPv4.length > 0) {
				return (TCPServer.serverActiveIPv4[0]);
			} else {
				return ('localhost');
			}
		}
		
		/**
		 * Currently-used IPV6 server address.
		 */
		static public function get serverActiveIPv6():Vector.<String> {
			var ips:Vector.<String> = new Vector.<String>();
			var list:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
			for (var i:uint = 0; i < list.length; i++) {
				if (list[i].active) {
					for (var j:uint = 0; j < list[i].addresses.length; j++) {
						if (list[i].addresses[j].ipVersion == 'IPv6') {
							if (list[i].addresses[j].address != '::1') {
								ips.push(list[i].addresses[j].address);
							}
						}
					}
				}
			}
			return (ips);
		}
		
		/**
		 * Best guess for IPV6 server address.
		 */
		static public function get ipv6():String {
			if (TCPServer.serverActiveIPv6.length > 0) {
				return (TCPServer.serverActiveIPv6[0]);
			} else {
				return ('localhost');
			}
		}
		
		
	}

}
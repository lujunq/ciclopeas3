package art.ciclope.net {
	
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
	
	import art.ciclope.event.TCPDataEvent;
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class TCPServer extends EventDispatcher {
		
		protected var _server:ServerSocket;			// the server socket for connection
		protected var _port:uint;						// the server port for listening
		protected var _ready:Boolean;					// is the server ready?
		protected var _clients:Vector.<Socket>;		// the connected clients
		
		public function TCPServer(target:flash.events.IEventDispatcher=null) {
			super(target);
			this._ready = false;
			this._clients = new Vector.<Socket>();
		}
		
		// READ-ONLY VALUES
		
		public function get ready():Boolean {
			return (this._ready);
		}
		
		public function get allServerAddr():Vector.<String> {
			var ips:Vector.<String> = new Vector.<String>();
			var list:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
			for (var i:uint = 0; i < list.length; i++) {
				for (var j:uint = 0; j < list[i].addresses.length; j++) {
					ips.push(list[i].addresses[j].address);
				}
			}
			return (ips);
		}
		
		public function get serverActiveIPv4():Vector.<String> {
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
		
		public function get serverActiveIPv6():Vector.<String> {
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
		
		// PUBLIC METHODS
		
		public function start(port:uint):void {
			
			trace ("tcp start at", port);
			
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
		
		public function clientIndex(client:Socket):int {
			var found:int = -1;
			for (var i:uint = 0; i < this._clients.length; i++) {
				if (this._clients[i] == client) found = i;
			}
			return (found);
		}
		
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
		
		public function kickAll():void {
			while (this._clients.length > 0) {
				try {
					this._clients[0].removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
					this._clients[0].close();
				} catch (e:Error) { }
				this._clients.shift();
			}
		}
	
		public function sendToClientNum(message:String, num:uint):Boolean {
			if (this._clients[num] != null) {
				this._clients[num].writeUTFBytes(message);
				this._clients[num].flush();
				return (true);
			} else {
				return (false);
			}
		}
		
		public function sendToClient(message:String, client:Socket):Boolean {
			return (this.sendToClientNum(message, this.clientIndex(client)));
		}
		
		public function sendToAll(message:String):void {
			for (var i:uint = 0; i < this._clients.length; i++) {
				this.sendToClientNum(message, i);
			}
		}
		
		public function sendToAllBut(message:String, avoid:Socket):void {
			for (var i:uint = 0; i < this._clients.length; i++) {
				if (this._clients[i] != avoid) this.sendToClientNum(message, i);
			}
		}
		
		public function sendToAllButNum(message:String, num:uint):void {
			for (var i:uint = 0; i < this._clients.length; i++) {
				if (i != num) this.sendToClientNum(message, i);
			}
		}
		
		// PRIVATE METHODS
		
		private function onSocketConnect(evt:ServerSocketConnectEvent):void {
			
			trace ('on socket connect');
			
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
			
			//var bArray:ByteArray = new ByteArray();
			//bArray.writeUTFBytes("mensgem aqui\n");
			//bArray.position = 0;
			//socket.writeUTF("mensgem aqui\0");
			//socket.writeInt(23);
			//socket.flush();
			//socket.writeUTF("mensagem aqui\r");
		}
		
		private function onSocketData(evt:ProgressEvent):void {
			var socket:Socket = evt.target as Socket;
			var bytes:ByteArray = new ByteArray();
			socket.readBytes(bytes);
			
			var received:String = '' + bytes;
			//if (received.substr(0, 1) == '$') received = received.substr(1);
			
			//bytes.clear();
			//bytes.writeUTFBytes(received);
			
			//var oscPacket:OSCPacket = new OSCPacket(bytes);
			//var oscMessage:OSCMessage = new OSCMessage(bytes);
			
			var json:Object = JSON.parse(received);
			
			trace ("tcp data", JSON.stringify(json));
			
			//var returnMsg:OSCMessage = new OSCMessage();
			//returnMsg.address = '/testing';
			//returnMsg.addArgument('i', 1024);
			//returnMsg.addArgument('f', 6.02);
			//returnMsg.addArgument('s', 'um texto aqui');
			
			socket.writeUTFBytes(JSON.stringify(json) + "\n");
			socket.flush();
			
			this.dispatchEvent(new TCPDataEvent(TCPDataEvent.RECEIVED, socket, ('' + bytes)));
		}
		
	}

}
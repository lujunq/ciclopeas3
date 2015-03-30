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
	public class JSONTCPServer extends TCPServer {
		
		public function JSONTCPServer() {
			super();
		}
		
		// PUBLIC METHODS
		
		public function sendJSONToClientNum(message:Object, num:uint):Boolean {
			if (this._clients[num] != null) {
				this._clients[num].writeUTFBytes(JSON.stringify(message));
				this._clients[num].flush();
				return (true);
			} else {
				return (false);
			}
		}
		
		public function sendJSONToClient(message:Object, client:Socket):Boolean {
			return (this.sendToClientNum(JSON.stringify(message), this.clientIndex(client)));
		}
		
		public function sendJSONToAll(message:Object):void {
			for (var i:uint = 0; i < this._clients.length; i++) {
				this.sendToClientNum(JSON.stringify(message), i);
			}
		}
		
		public function sendJSONToAllBut(message:Object, avoid:Socket):void {
			for (var i:uint = 0; i < this._clients.length; i++) {
				if (this._clients[i] != avoid) this.sendToClientNum(JSON.stringify(message), i);
			}
		}
		
		public function sendJSONToAllButNum(message:Object, num:uint):void {
			for (var i:uint = 0; i < this._clients.length; i++) {
				if (i != num) this.sendToClientNum(JSON.stringify(message), i);
			}
		}
		
	}

}
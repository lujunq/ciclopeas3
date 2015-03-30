package art.ciclope.net {
	
	import art.ciclope.event.TCPDataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.Socket;
	
	import com.childoftv.websockets.WebSocketServer;
	import com.childoftv.websockets.events.ServerEvent;
	import com.childoftv.websockets.events.ClientEvent;
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class WebSocketsServer extends EventDispatcher {
		
		private var _address:String;
		private var _port:uint;
		private var _webSocket:WebSocketServer;
		private var _ready:Boolean;
		
		public function WebSocketsServer(target:flash.events.IEventDispatcher=null) {
			super(target);
			this._ready = false;
			this._webSocket = new WebSocketServer();
			this._webSocket.addEventListener(ServerEvent.SERVER_BOUND_SUCCESS, handleServerIsReady);
			this._webSocket.addEventListener(ClientEvent.CLIENT_CONNECT_EVENT, handleClientConnect);
			this._webSocket.addEventListener(ClientEvent.CLIENT_MESSAGE_EVENT, handleClientMessage);
			this._webSocket.addEventListener(ClientEvent.CLIENT_DISCONNECT_EVENT, handleClientDisconnect);
		}
		
		// READ-ONLY VALUES
		
		public function get ready():Boolean {
			return (this._ready);
		}
		
		public function get serverAddress():String {
			if (this._ready) {
				return ('ws://' + this._address + ':' + this._port);
			} else {
				return ('');
			}
		}
		
		// PUBLIC METHODS
		
		public function bind(address:String, port:uint):void {
			this._address = address;
			this._port = port;
			this._ready = false;
			this._webSocket.attemptBind(port, address);
		}
		
		// PRIVATE METHODS
		
		private function handleClientDisconnect(evt:ClientEvent):void {
			
		}
		
		private function handleClientConnect(evt:ClientEvent):void {
			
		}
		
		private function handleClientMessage(evt:ClientEvent):void {
			this.dispatchEvent(new TCPDataEvent(TCPDataEvent.RECEIVED, evt.socket, evt.msg));
		}
		
		private function handleServerIsReady(e:ServerEvent):void {
			this._ready = true;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}

}
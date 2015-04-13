package art.ciclope.net {
	
	// FLASH PACKAGES
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.Socket;
	
	// CICLOPE CLASSES
	import art.ciclope.event.WebsocketEvent;
	
	// WEBSOCKET SERVER
	import com.childoftv.websockets.WebSocketServer;
	import com.childoftv.websockets.events.ServerEvent;
	import com.childoftv.websockets.events.ClientEvent;
	
	// EVENTS
	
	/**
     * A new client is connected.
     */
    [Event( name = "NEWCLIENT", type = "art.ciclope.event.WebsocketEvent" )]
	/**
     * A client closed connection.
     */
    [Event( name = "CLIENTCLOSE", type = "art.ciclope.event.WebsocketEvent" )]
	/**
     * A message was just received from a connected client.
     */
    [Event( name = "RECEIVED", type = "art.ciclope.event.WebsocketEvent" )]
	/**
     * The server became ready.
     */
    [Event( name = "COMPLETE", type = "flash.events.Event" )]
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * WebSocketsServer creates a server capable of listening to connections made from browsers using websockets / javascript.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class WebSocketsServer extends EventDispatcher {
		
		// PRIVATE VARIABLES
		
		private var _address:String;				// the server address
		private var _port:uint;						// the port to listen to
		private var _webSocket:WebSocketServer;		// the websockets server itself
		private var _ready:Boolean;					// is the server ready?
		
		/**
		 * WebSocketsServer constructor.
		 */
		public function WebSocketsServer(target:flash.events.IEventDispatcher=null) {
			super(target);
			this._ready = false;
			this._webSocket = new WebSocketServer();
			this._webSocket.addEventListener(ServerEvent.SERVER_BOUND_SUCCESS, handleServerIsReady);
			this._webSocket.addEventListener(ClientEvent.CLIENT_CONNECT_EVENT, handleClientConnect);
			this._webSocket.addEventListener(ClientEvent.CLIENT_MESSAGE_EVENT, handleClientMessage);
			this._webSocket.addEventListener(ClientEvent.CLIENT_DISCONNECT_EVENT, handleClientDisconnect);
			
			Main.addDebug('websocket server starting');
		}
		
		// READ-ONLY VALUES
		
		/**
		 * Is the server ready?
		 */
		public function get ready():Boolean {
			return (this._ready);
		}
		
		/**
		 * Best guess for server current ipv4 address (including port).
		 */
		public function get ipv4Address():String {
			if (this._ready) {
				return ('ws://' + TCPServer.ipv4 + ':' + this._port);
			} else {
				return ('');
			}
		}
		
		/**
		 * Best guess for server current ipv6 address (including port).
		 */
		public function get ipv6Address():String {
			if (this._ready) {
				return ('ws://' + TCPServer.ipv6 + ':' + this._port);
			} else {
				return ('');
			}
		}
		
		// PUBLIC METHODS
		
		/**
		 * Create the server.
		 * @param	address	the server address
		 * @param	port	the port to listen to
		 */
		public function bind(address:String, port:uint):void {
			this._address = address;
			this._port = port;
			this._ready = false;
			this._webSocket.attemptBind(port, address);
			
			Main.addDebug('try websocket server at ' + address + ' and ' + port);
		}
		
		// PRIVATE METHODS
		
		/**
		 * A client just disconnected.
		 */
		private function handleClientDisconnect(evt:ClientEvent):void {
			this.dispatchEvent(new WebsocketEvent(WebsocketEvent.CLIENTCLOSE, evt.socket));
		}
		
		/**
		 * A client just connected.
		 */
		private function handleClientConnect(evt:ClientEvent):void {
			this.dispatchEvent(new WebsocketEvent(WebsocketEvent.NEWCLIENT, evt.socket));
		}
		
		/**
		 * Received a message from a connected client.
		 */
		private function handleClientMessage(evt:ClientEvent):void {
			this.dispatchEvent(new WebsocketEvent(WebsocketEvent.RECEIVED, evt.socket, evt.msg));
		}
		
		/**
		 * The server became ready.
		 */
		private function handleServerIsReady(e:ServerEvent):void {
			this._ready = true;
			this.dispatchEvent(new Event(Event.COMPLETE));
			
			Main.addDebug('websocket ready');
		}
		
	}

}
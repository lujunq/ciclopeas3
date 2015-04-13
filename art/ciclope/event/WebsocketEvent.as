package art.ciclope.event {
	
	// FLASH PACKAGES
	import flash.events.Event;
	import flash.net.Socket;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * WebsocketEvent create events for websocket remote connections.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class WebsocketEvent extends Event {
		
		// STATIC CONSTANTS
		
		/**
		 * New client connection.
		 */
		public static var NEWCLIENT:String = "NEWCLIENT";
		
		/**
		 * A client just disconnected.
		 */
		public static var CLIENTCLOSE:String = "CLIENTCLOSE";
		
		/**
		 * New message available from a connected client.
		 */
		public static var RECEIVED:String = "RECEIVED";
		
		// VARIABLES
		
		/**
		 * The connected client reference.
		 */
		public var client:Socket;
		
		/**
		 * The received message.
		 */
		public var message:String;
		
		/**
		 * WebsocketEvent constructor.
		 * @param	type	event type
		 * @param	cclient	the connected client reference
		 * @param	cmsg	the received message
		 */
		public function WebsocketEvent(type:String, cclient:Socket, cmsg:String = '', bubbles:Boolean = false, cancelable:Boolean = false) { 
			this.client = cclient;
			this.message = cmsg;
			super(type, bubbles, cancelable);
		}
		
		// READ-ONLY VALUES
		
		/**
		 * An object with received message parsed as a JSON object.
		 */
		public function get messageData():Object {
			var mdata:Object;
			try {
				mdata = JSON.parse(this.message);
			} catch (e:Error) { }
			return (mdata);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Clone the event.
		 * @return	a clone of the current event
		 */
		public override function clone():Event { 
			return new WebsocketEvent(type, client, message, bubbles, cancelable);
		} 
		
		/**
		 * Get a string representation of current event.
		 * @return	a string representation of current event 
		 */
		public override function toString():String { 
			return formatToString("WebsocketEvent", "type", "message", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}
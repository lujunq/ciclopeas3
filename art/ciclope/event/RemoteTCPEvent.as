package art.ciclope.event {
	
	// FLASH PACKAGES
	import flash.events.Event;
	import flash.net.Socket;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * RemoteTCPEvent create events for TCP remote connections.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class RemoteTCPEvent extends Event {
		
		// STATIC CONSTANTS
		
		/**
		 * New action command available.
		 */
		public static var ACTION:String = "ACTION";
		
		// VARIABLES
		
		/**
		 * The connected client reference.
		 */
		public var client:Socket;
		
		/**
		 * The command action.
		 */
		public var action:String;
		
		/**
		 * Command action parameters.
		 */
		public var params:Object;
		
		/**
		 * RemoteTCPEvent constructor.
		 * @param	type	event type
		 * @param	cclient	the connected client reference
		 * @param	caction	the action to take
		 * @param	cparams	action parameters, if any
		 */
		public function RemoteTCPEvent(type:String, cclient:Socket, caction:String, cparams:Object = null, bubbles:Boolean = false, cancelable:Boolean = false) { 
			this.client = cclient;
			this.action = caction;
			this.params = cparams;
			super(type, bubbles, cancelable);
		} 
		
		/**
		 * Clone the event.
		 * @return	a clone of the current event
		 */
		public override function clone():Event { 
			return new RemoteTCPEvent(type, client, action, params, bubbles, cancelable);
		} 
		
		/**
		 * Get a string representation of current event.
		 * @return	a string representation of current event 
		 */
		public override function toString():String { 
			return formatToString("RemoteTCPEvent", "type", "action", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}
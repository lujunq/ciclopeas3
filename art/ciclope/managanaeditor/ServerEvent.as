package art.ciclope.managanaeditor {
	
	// FLASH PACKAGES
	import flash.events.Event;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * ServerEvent provides event information for Managana server communitcation with the editor.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class ServerEvent extends Event {
		
		// STATIC CONSTANTS
		
		/**
		 * The server response is OK and ready to process.
		 */
		public static const SERVER_OK:String = "SERVER_OK";
		/**
		 * The server script called could not be accessed.
		 */
		public static const SERVER_NOTFOUND:String = "SERVER_NOTFOUND";
		/**
		 * The server response is not formatted as expected (must be XML-formatted with at least an "error" child).
		 */
		public static const SERVER_CONTENT:String = "SERVER_CONTENT";
		/**
		 * The server response did not match the expected agent ID.
		 */
		public static const SERVER_AGENT:String = "SERVER_AGENT";
		/**
		 * The server response returned an error.
		 */
		public static const SERVER_ERROR:String = "SERVER_ERROR";
		
		
		// VARIABLES
		
		/**
		 * Reference for event return (usually dispatcher object).
		 */
		public var reference:*;
		
		/**
		 * ServerEvent constructor.
		 * @param	type	the event type
		 * @param	ref	reference for event return (usually dispatcher object)
		 * @param	bubbles	Determines whether the Event object participates in the bubbling stage of the event flow.
		 * @param	cancelable	Determines whether the Event object can be canceled.
		 */
		public function ServerEvent(type:String, ref:* = null, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			this.reference = ref;
		} 
		
		/**
		 * Event clone.
		 * @return	a clone of current event
		 */
		public override function clone():Event { 
			return new ServerEvent(type, bubbles, cancelable);
		} 
		
		/**
		 * String representation of the event.
		 * @return	a string representation
		 */
		public override function toString():String { 
			return formatToString("ServerEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}
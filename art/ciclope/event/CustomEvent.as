package art.ciclope.event {
	
	// FLASH PACKAGES
	import flash.events.Event;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * CustomEvent create a multi-purpose event with a custom paramenter always sent as a String but that can be parsed according to its type.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class CustomEvent extends Event {
		
		// CONSTANT DEFINITIONS
		
		/**
		 * An event with a String custom parameter.
		 */
		public static const CUSTOM_STRING:String = "CUSTOM_STRING";
		/**
		 * An event with a Number custom parameter.
		 */
		public static const CUSTOM_NUMBER:String = "CUSTOM_NUMBER";
		/**
		 * An event with an uint custom parameter.
		 */
		public static const CUSTOM_UINT:String = "CUSTOM_UINT";
		/**
		 * An event with an int custom parameter.
		 */
		public static const CUSTOM_INT:String = "CUSTOM_INT";
		
		// VARIABLES
		
		private var _custom:String;		// custom event parameter
		
		/**
		 * CustomEvent constructor.
		 * @param	type	event type (the way the custom parameter can be parsed)
		 * @param	custom	the custom parameter
		 * @param	bubbles	Determines whether the Event object participates in the bubbling stage of the event flow.
		 * @param	cancelable	Determines whether the Event object can be canceled.
		 */
		public function CustomEvent(type:String, custom:String = "", bubbles:Boolean = false, cancelable:Boolean = false) { 
			this._custom = custom;
			super(type, bubbles, cancelable);
		}
		
		// READ-ONLY VALUES
		
		/**
		 * The event custom parameter.
		 */
		public function get custom():String {
			return (this._custom);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Duplicate an instance of this event.
		 */
		public override function clone():Event { 
			return new Message(type, this._custom, bubbles, cancelable);
		} 

		/**
		 * Return a string containing all properties of the event.
		 */
		public override function toString():String { 
			return formatToString("Message", "type", "custom", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}
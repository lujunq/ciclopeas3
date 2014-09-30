package art.ciclope.event {
		
	// FLASH PACKAGES
	import flash.events.Event;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * LeapDataEvent create events for Leap Motion device interactions.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class LeapDataEvent extends Event {
		
		// STATIC CONSTANTS
		
		/**
		 * Leap Motion controller initialized.
		 */
		public static const LEAP_INIT:String = "LEAP_INIT";
		
		/**
		 * Leap Motion controller disconnected.
		 */
		public static const LEAP_DISCONNECT:String = "LEAP_DISCONNECT";
		
		/**
		 * Leap Motion controller connected.
		 */
		public static const LEAP_CONNECT:String = "LEAP_CONNECT";
		
		/**
		 * Leap Motion controller exit.
		 */
		public static const LEAP_EXIT:String = "LEAP_EXIT";
		
		/**
		 * Leap Motion was just calibrated.
		 */
		public static const LEAP_CALIBRATE:String = "LEAP_CALIBRATE";
		
		/**
		 * Leap Motion controller new frame available.
		 */
		public static const LEAP_FRAME:String = "LEAP_FRAME";
		
		/**
		 * Gesture type: key tap.
		 */
		public static const TYPE_KEY_TAP:String = "TYPE_KEY_TAP";
		
		/**
		 * Gesture type: screen tap.
		 */
		public static const TYPE_SCREEN_TAP:String = "TYPE_SCREEN_TAP";
		
		/**
		 * Gesture type: circle.
		 */
		public static const TYPE_CIRCLE:String = "TYPE_CIRCLE";
		
		/**
		 * Gesture type: swipe to next X.
		 */
		public static const TYPE_SWIPE_NEXTX:String = "TYPE_SWIPE_NEXTX";
		
		/**
		 * Gesture type: swipe to next Y.
		 */
		public static const TYPE_SWIPE_NEXTY:String = "TYPE_SWIPE_NEXTY";
		
		/**
		 * Gesture type: swipe to next Z.
		 */
		public static const TYPE_SWIPE_NEXTZ:String = "TYPE_SWIPE_NEXTZ";
		
		/**
		 * Gesture type: swipe to previous X.
		 */
		public static const TYPE_SWIPE_PREVX:String = "TYPE_SWIPE_PREVX";
		
		/**
		 * Gesture type: swipe to previous Y.
		 */
		public static const TYPE_SWIPE_PREVY:String = "TYPE_SWIPE_PREVY";
		
		/**
		 * Gesture type: swipe to previous Z.
		 */
		public static const TYPE_SWIPE_PREVZ:String = "TYPE_SWIPE_PREVZ";
		
		// VARIABLES
		
		/**
		 * The gesture id.
		 */
		public var id:Number;
		
		/**
		 * LeapDataEvent constructor.
		 * @param	type	te event type
		 * @param	id	the gesture id
		 */
		public function LeapDataEvent(type:String, id:Number = 0, bubbles:Boolean = false, cancelable:Boolean = false) { 
			this.id = id;
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Clone the event.
		 */
		public override function clone():Event { 
			return new LeapDataEvent(type, this.id, bubbles, cancelable);
		} 
		
		/**
		 * String representation of the event.
		 */
		public override function toString():String { 
			return formatToString("LeapDataEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}
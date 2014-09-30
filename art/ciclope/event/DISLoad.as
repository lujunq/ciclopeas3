package art.ciclope.event {
	
	// FLASH PACKAGES
	import flash.events.Event;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * DISLoad provides events for dis folder loading.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class DISLoad extends Event {
		
		// CONSTANT DEFINITIONS
		
		/**
		 * Community data is ready.
		 */
		public static const COMMUNITY_OK:String = "COMMUNITY_OK";
		/**
		 * Community data load error.
		 */
		public static const COMMUNITY_ERROR:String = "COMMUNITY_ERROR";
		/**
		 * Community data load start.
		 */
		public static const COMMUNITY_LOAD:String = "COMMUNITY_LOAD";
		/**
		 * Stream data is ready.
		 */
		public static const STREAM_OK:String = "STREAM_OK";
		/**
		 * Stream data load error.
		 */
		public static const STREAM_ERROR:String = "STREAM_ERROR";
		/**
		 * Stream data load start.
		 */
		public static const STREAM_LOAD:String = "STREAM_LOAD";
		/**
		 * Playlist data is ready.
		 */
		public static const PLAYLIST_OK:String = "PLAYLIST_OK";
		/**
		 * Playlist data load error.
		 */
		public static const PLAYLIST_ERROR:String = "PLAYLIST_ERROR";
		/**
		 * A keyframe finished to load (on keyframe open tween end).
		 */
		public static const KEYFRAME_LOAD:String = "KEYFRAME_LOAD";
		
		// VARIABLES
		
		private var _target:*;	// the event target
		
		/**
		 * DISLoad constructor.
		 * @param	type	event type
		 * @param	target	event target
		 * @param	bubbles	Determines whether the Event object participates in the bubbling stage of the event flow.
		 * @param	cancelable	Determines whether the Event object can be canceled.
		 */
		public function DISLoad(type:String, target:*, bubbles:Boolean = false, cancelable:Boolean = false) { 
			this._target = target;
			super(type, bubbles, cancelable);
		}
		
		// READ-ONLY VALUES
		
		/**
		 * The event target loader.
		 */
		public function get loader():* {
			return (this._target);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Duplicate an instance of this event.
		 */
		public override function clone():Event { 
			return new DISLoad(type, target, bubbles, cancelable);
		} 

		/**
		 * Return a string containing all properties of the event.
		 */
		public override function toString():String { 
			return formatToString("DISLoad", "type", "target", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}
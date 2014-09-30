package art.ciclope.managana.feeds {
	
	// FLASH PACKAGES
	import flash.events.Event;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * FeedEvent provides events for handling external feed downloads.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class FeedEvent extends Event {
		
		// PUBLIC CONSTANTS
		
		/**
		 * A feed is ready to use.
		 */
		public static const FEED_READY:String = "FEED_READY";
		
		/**
		 * A feed load failed.
		 */
		public static const FEED_ERROR:String = "FEED_ERROR";
		
		/**
		 * A feed post data is available to use.
		 */
		public static const DATA_READY:String = "DATA_READY";
		
		// VARIABLES
		
		private var _feedType:String;		// the feed type
		private var _feedName:String;		// the feed name
		
		/**
		 * FeedEvent constructor.
		 * @param	type	The type of the event.
		 * @param	feedName	The exteranl feed name.
		 * @param	feedType	The external feed type.
		 * @param	bubbles	Determines whether the Event object participates in the bubbling stage of the event flow.
		 * @param	cancelable	Determines whether the Event object can be canceled.
		 */
		public function FeedEvent(type:String, feedName:String, feedType:String, bubbles:Boolean = false, cancelable:Boolean = false) { 
			this._feedType = feedType;
			this._feedName = feedName;
			super(type, bubbles, cancelable);
		}
		
		// READ-ONLY VALUES
		
		/**
		 * The feed name.
		 */
		public function get feedName():String {
			return (this._feedName);
		}
		
		/**
		 * The feed type.
		 */
		public function get feedType():String {
			return (this._feedType);
		}
		
	}
	
}
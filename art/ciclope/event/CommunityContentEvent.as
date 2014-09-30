package art.ciclope.event {
	
	// FLASH PACKAGES
	import flash.events.Event;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * CommunityContentEvent create events for Managana content management.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class CommunityContentEvent extends Event {
		
		// CONSTANT DEFINITIONS
		
		/**
		 * Content list available.
		 */
		public static const LIST_AVAILABLE:String = "LIST_AVAILABLE";
		
		/**
		 * Community information request.
		 */
		public static const GET_INFO:String = "GET_INFO";
		
		/**
		 * Community information available.
		 */
		public static const INFO_READY:String = "INFO_READY";
		
		/**
		 * Community information fetch error.
		 */
		public static const INFO_ERROR:String = "INFO_ERROR";
		
		/**
		 * A new file download completed.
		 */
		public static const DOWNLOAD_ITEM:String = "DOWNLOAD_ITEM";
		
		/**
		 * All requested files were downloaded.
		 */
		public static const DOWNLOAD_ALL:String = "DOWNLOAD_ALL";
		
		/**
		 * A download was automatically started.
		 */
		public static const DOWNLOAD_START:String = "DOWNLOAD_START";
		
		/**
		 * A download was stopped.
		 */
		public static const DOWNLOAD_STOP:String = "DOWNLOAD_STOP";
		
		/**
		 * An update is available for an offline content.
		 */
		public static const UPDATE_AVAILABLE:String = "UPDATE_AVAILABLE";
		
		
		// PUBLIC VARIABLES
		
		/**
		 * Message returned by the reader server.
		 */
		public var message:String = "";
		
		/**
		 * ReaderServerEvent constructor.
		 * @param	type	event type
		 * @param	message	any string message that should be sent
		 * @param	bubbles	Determines whether the Event object participates in the bubbling stage of the event flow.
		 * @param	cancelable	Determines whether the Event object can be canceled.
		 */
		public function CommunityContentEvent(type:String, message:String = "", bubbles:Boolean = false, cancelable:Boolean = false) {
			// creating event
			this.message = message;
			super(type, bubbles, cancelable);
		}
		
	}

}
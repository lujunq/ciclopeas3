package art.ciclope.event {
	
	// FLASH PACKAGES
	import flash.events.Event;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * ReaderServerEvent create events for Managana reader server class.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class ReaderServerEvent extends Event {
		
		// CONSTANT DEFINITIONS
		
		/**
		 * System info received.
		 */
		public static const SYSTEM_INFO:String = "SYSTEM_INFO";
		/**
		 * No system information available: lack on Internet connection?
		 */
		public static const NOSYSTEM:String = "NOSYSTEM";
		/**
		 * Community info received.
		 */
		public static const COMMUNITY_INFO:String = "COMMUNITY_INFO";
		/**
		 * Stream info received.
		 */
		public static const STREAM_INFO:String = "STREAM_INFO";
		/**
		 * Stream rate data available.
		 */
		public static const STREAM_RATE:String = "STREAM_RATE";
		/**
		 * Error on reader communication.
		 */
		public static const READER_ERROR:String = "READER_ERROR";
		/**
		 * Reader server message just arrived.
		 */
		public static const READER_MESSAGE:String = "READER_MESSAGE";
		/**
		 * A community list is available.
		 */
		public static const COMMUNITY_LIST:String = "COMMUNITY_LIST";
		/**
		 * A stream list is available.
		 */
		public static const STREAM_LIST:String = "STREAM_LIST";
		/**
		 * A valid public key for remote control is available.
		 */
		public static const VALID_PKEY:String = "VALID_PKEY";
		/**
		 * User variable data was successfully saved on server.
		 */
		public static const DATA_SAVED:String = "DATA_SAVED";
		/**
		 * User variable data was successfully loaded from server.
		 */
		public static const DATA_LOADED:String = "DATA_LOADED";
		/**
		 * Community variable data was successfully loaded from server.
		 */
		public static const COMDATA_LOADED:String = "COMDATA_LOADED";
		/**
		 * Search results data available.
		 */
		public static const SEARCHRESULTS:String = "SEARCHRESULTS";
		/**
		 * An user had just log in.
		 */
		public static const USERLOGIN:String = "USERLOGIN";
		/**
		 * The user logged out.
		 */
		public static const USERLOGOUT:String = "USERLOGOUT";
		/**
		 * Notes/bookmarks sync data received.
		 */
		public static const NOTESYNC:String = "NOTESYNC";
		/**
		 * Offline information received.
		 */
		public static const OFFLINEINFO:String = "OFFLINEINFO";
		/**
		 * Offline information error.
		 */
		public static const OFFLINEERROR:String = "OFFLINEERROR";
		
		
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
		public function ReaderServerEvent(type:String, message:String = "", bubbles:Boolean = false, cancelable:Boolean = false) {
			// creating event
			this.message = message;
			super(type, bubbles, cancelable);
		}
		
	}

}
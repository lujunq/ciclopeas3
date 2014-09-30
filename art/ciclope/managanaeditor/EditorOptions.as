package art.ciclope.managanaeditor {
	
	// CICLOPE CLASSES
	import art.ciclope.staticfunctions.StringFunctions;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * EditorOptions holds information about the Managana editor configuration.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class EditorOptions {
		
		// STATIC VARIABLES
		
		/**
		 * Expected agent ID on server responses.
		 */
		public static var agent:String;
		/**
		 * Path to the server scripts.
		 */
		public static var path:String;
		/**
		 * Prefix used by script files.
		 */
		public static var prefix:String;
		/**
		 * File extension used by server
		 */
		public static var extension:String;
		/**
		 * Request method to use in server interaction.
		 */
		public static var method:String;
		/**
		 * Folder on server to save published communities.
		 */
		public static var cfolder:String;
		/**
		 * Share url.
		 */
		public static var shareurl:String;
		/**
		 * Feed fetch url.
		 */
		public static var feedurl:String;
		/**
		 * Maximum file upload size.
		 */
		public static var uploadMax:uint = 2;
		
	}

}
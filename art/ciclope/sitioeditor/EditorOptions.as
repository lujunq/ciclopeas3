package art.ciclope.sitioeditor {
	
	// CICLOPE CLASSES
	import art.ciclope.staticfunctions.StringFunctions;
	
	/**
	 * ...
	 * @author Lucas Junqueira
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
		
	}

}
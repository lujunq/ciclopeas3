package art.ciclope.managana.data {
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * DISLoadProtocol provides constants for community load protocol settings.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class DISLoadProtocol {
		
		// STATIC CONSTANTS
		
		/**
		 * HTTP protocol (loaded from web).
		 */
		public static const PROTOCOL_HTTP:String = "PROTOCOL_HTTP";
		/**
		 * APP protocol (loaded from app-packaged data).
		 */
		public static const PROTOCOL_APP:String = "PROTOCOL_APP";
		/**
		 * FILE protocol (loaded from downloaded data).
		 */
		public static const PROTOCOL_FILE:String = "PROTOCOL_FILE";
		/**
		 * UNKNOWN protocol (unknown loading origin).
		 */
		public static const PROTOCOL_UNKNOWN:String = "PROTOCOL_UNKNOWN";
		
		// STATIC METHODS
		
		/**
		 * Get the community loaded protocol from dis folder url.
		 * @param	url	the dis folder url
		 * @return	the loaded community protocol according to DISLoadProtocol constants
		 */
		public static function getProtocol(url:String):String {
			var check:Array = url.split(':');
			if (check.length > 1) {
				switch (String(check[0]).toLowerCase()) {
					case 'http':
						return (DISLoadProtocol.PROTOCOL_HTTP);
						break;
					case 'app':
						return (DISLoadProtocol.PROTOCOL_APP);
						break;
					case 'file':
						return (DISLoadProtocol.PROTOCOL_FILE);
						break;
					default:
						return (DISLoadProtocol.PROTOCOL_UNKNOWN);
						break;
				}
			} else {
				return (DISLoadProtocol.PROTOCOL_UNKNOWN);
			}
		}
		
	}

}
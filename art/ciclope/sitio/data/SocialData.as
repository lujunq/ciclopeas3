package art.ciclope.sitio.data {
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public final class SocialData {
		
		// VARIABLES
		
		private var _type:String;		// the social connection type
		private var _url:String;		// the social connection url
		private var _method:String;		// the social connection access method
		
		/**
		 * Create a new SocialData object.
		 * @param	type	the social connection type
		 * @param	url	the social connection url
		 * @param	method	the social connection access method
		 */
		public function SocialData(type:String, url:String, method:String) {
			this._type = type;
			this._url = url;
			this._method = method;
		}
		
		/**
		 * The social connection type.
		 */
		public function get type():String {
			return(this._type);
		}
		
		/**
		 * The social connection url.
		 */
		public function get url():String {
			return (this._url);
		}
		
		/**
		 * The social connection access method.
		 */
		public function get method():String {
			return (this._method);
		}
		
		/**
		 * Release memory used by this object.
		 */
		public final function kill():void {
			this._type = null;
			this._url = null;
			this._method = null;
		}
		
	}

}
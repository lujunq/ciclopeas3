package art.ciclope.sitio.data {
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public final class AuthorData {
		
		// VARIABLES
		
		private var _name:String;		// the author name
		private var _id:String;			// the author identifier
		
		/**
		 * Create a new AuthorData object.
		 * @param	name	the author name
		 * @param	id	the author identifier
		 */
		public function AuthorData(name:String, id:String) {
			this._name = name;
			this._id = id;
		}
		
		/**
		 * The author name.
		 */
		public function get name():String {
			return(this._name);
		}
		
		/**
		 * The author identifier.
		 */
		public function get id():String {
			return (this._id);
		}
		
		/**
		 * Release memory used by this object.
		 */
		public final function kill():void {
			this._name = null;
			this._id = null;
		}
		
	}

}
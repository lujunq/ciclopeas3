package art.ciclope.sitio.data {
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public final class FontData {
		
		// VARIABLES
		
		private var _name:String;		// the plugin name
		private var _id:String;			// the plugin identifier
		
		/**
		 * Create a new FontData object.
		 * @param	name	the font name
		 * @param	id	the font identifier
		 */
		public function FontData(name:String, id:String) {
			this._name = name;
			this._id = id;
		}
		
		/**
		 * The font name.
		 */
		public function get name():String {
			return (this._name);
		}
		
		/**
		 * The font identifier.
		 */
		public function get id():String {
			return (this._id);
		}
		
		/**
		 * Release memory used by object.
		 */
		public final function kill():void {
			this._name = null;
			this._id = null;
		}
		
	}

}
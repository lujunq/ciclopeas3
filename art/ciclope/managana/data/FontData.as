package art.ciclope.managana.data {
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * FontData holds information about fonts.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public final class FontData {
		
		// VARIABLES
		
		private var _name:String;		// the plugin name
		private var _id:String;			// the plugin identifier
		
		/**
		 * FontData constructor.
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
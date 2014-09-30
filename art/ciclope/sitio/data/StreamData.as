package art.ciclope.sitio.data {
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public final class StreamData {
		
		// VARIABLES
		
		private var _name:String;			// the stream name
		private var _id:String;				// the stream identifier
		private var _type:String;			// multi-purpose type identitier
		private var _excerpt:String;		// stream about excerpt
		private var _icon:String;			// stream icon url
		
		/**
		 * Create a new StreamData object.
		 * @param	name	the stream name
		 * @param	id	the stream identifier
		 * @param	type	a multi-purpose type identifier
		 * @param	excerpt	the stream about excerpt
		 * @param	icon	the stream icon url
		 */
		public function StreamData(name:String, id:String, type:String = "", excerpt:String = "", icon:String = "") {
			this._name = name;
			this._id = id;
			this._type = type;
			this._excerpt = excerpt;
			this._icon = icon;
		}
		
		/**
		 * The stream name.
		 */
		public function get name():String {
			return (this._name);
		}
		
		/**
		 * The stream identifier.
		 */
		public function get id():String {
			return (this._id);
		}
		
		/**
		 * A multi-purpose stream type identifier.
		 */
		public function get type():String {
			return (this._type);
		}
		
		/**
		 * The stream about excerpt.
		 */
		public function get excerpt():String {
			return (this._excerpt);
		}
		
		/**
		 * The stream icon url.
		 */
		public function get icon():String {
			return (this._icon);
		}
		
		/**
		 * Release memory used by this object.
		 */
		public final function kill():void {
			this._name = null;
			this._id = null;
			this._type = null;
			this._excerpt = null;
			this._icon = null;
		}
		
	}

}
package art.ciclope.sitio.data {
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public final class CategoryData {
		
		// VARIABLES
		
		private var _name:String;		// the category name
		private var _id:String;			// the category identifier
		
		/**
		 * Create a new CategoryData object.
		 * @param	name	the category name
		 * @param	id	the category identifier
		 */
		public function CategoryData(name:String, id:String) {
			this._name = name;
			this._id = id;
		}
		
		/**
		 * The category name.
		 */
		public function get name():String {
			return(this._name);
		}
		
		/**
		 * The category identifier.
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
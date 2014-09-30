package art.ciclope.managana.data {
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * CategoryData holds information about stream categories.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public final class CategoryData {
		
		// VARIABLES
		
		private var _name:String;		// the category name
		private var _id:String;			// the category identifier
		
		/**
		 * CategoryData constructor.
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
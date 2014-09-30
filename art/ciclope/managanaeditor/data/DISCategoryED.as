package art.ciclope.managanaeditor.data {
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * DISAuthorED provides information about stream categories for Managana editor.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class DISCategoryED {
		
		// PUBLIC VARIABLES
		
		/**
		 * Category name.
		 */
		public var name:String = "";
		/**
		 * Category id.
		 */
		public var id:String = "";
		
		/**
		 * DISCategoryED constructor.
		 * @param	name	category name
		 * @param	id	category id
		 */
		public function DISCategoryED(name:String, id:String) {
			this.name = name;
			this.id = id;
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			this.name = null;
			this.id = null;
		}
		
	}

}
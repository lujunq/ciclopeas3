package art.ciclope.sitioeditor.data {
	
	/**
	 * ...
	 * @author Lucas Junqueira
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
package art.ciclope.sitioeditor.data {
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class DISAuthorED {
		
		// PUBLIC VARIABLES
		
		/**
		 * Author name.
		 */
		public var name:String = "";
		/**
		 * Author id.
		 */
		public var id:String = "";
		
		public function DISAuthorED() {
			
		}
		
		// PUBLIC METHODS
		
		/**
		 * Clear information about the author.
		 */
		public function clear():void {
			name = "";
			id = "";
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
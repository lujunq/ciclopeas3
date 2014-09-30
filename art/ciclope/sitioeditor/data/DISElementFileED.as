package art.ciclope.sitioeditor.data {
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class DISElementFileED {
		
		// VARIABLES
		
		/**
		 * File format.
		 */
		public var format:String = "";
		/**
		 * File language.
		 */
		public var lang:String = "";
		/**
		 * Is file path absolute?
		 */
		public var absolute:Boolean = false;
		/**
		 * File path.
		 */
		public var path:String = "";
		
		public function DISElementFileED(path:String = "", format:String = "", lang:String = "", absolute:Boolean = false) {
			this.path = path;
			this.format = format;
			this.lang = lang;
			this.absolute = absolute;
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			this.path = null;
			this.format = null;
			this.lang = null;
		}
		
	}

}
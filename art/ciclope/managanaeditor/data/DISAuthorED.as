package art.ciclope.managanaeditor.data {
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * DISAuthorED provides information about authors for Managana editor.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
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
		
		/**
		 * DISAuthorED constructor.
		 */
		public function DISAuthorED() {	}
		
		// READ-ONLY VALUES
		
		/**
		 * An exact copy of current author data.
		 */
		public function get clone():DISAuthorED {
			var ret:DISAuthorED = new DISAuthorED();
			ret.name = this.name;
			ret.id = this.id;
			return(ret);
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
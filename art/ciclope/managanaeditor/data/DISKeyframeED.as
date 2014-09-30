package art.ciclope.managanaeditor.data {
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * DISKeyframeED provides information about stream keyframes for Managana editor.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class DISKeyframeED {
		
		// VARIABLES
		
		/**
		 * Keyframe instances.
		 */
		public var instance:Array = new Array();
		
		/**
		 * Progress code for keyframe open.
		 */
		public var codeIn:String = "";
		
		/**
		 * Progress code for keyframe exit.
		 */
		public var codeOut:String = "";
		
		/**
		 * DISKeyframeED constructor.
		 */
		public function DISKeyframeED() { }
		
		// READ-ONLY VALUES
		
		/**
		 * An exact copy of current object.
		 */
		public function get clone():DISKeyframeED {
			var clone:DISKeyframeED = new DISKeyframeED();
			for (var index:String in this.instance) {
				clone.instance[index] = this.instance[index].clone;
			}
			clone.codeIn = this.codeIn;
			clone.codeOut = this.codeOut;
			return (clone);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			for (var index:String in this.instance) {
				this.instance[index].kill();
				delete(this.instance[index]);
			}
			this.codeIn = null;
			this.codeOut = null;
		}
	}

}
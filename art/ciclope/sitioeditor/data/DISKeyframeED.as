package art.ciclope.sitioeditor.data {
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class DISKeyframeED {
		
		// VARIABLES
		
		/**
		 * Keyframe instances.
		 */
		public var instance:Array = new Array();
		
		public function DISKeyframeED() {
			
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
		}
	}

}
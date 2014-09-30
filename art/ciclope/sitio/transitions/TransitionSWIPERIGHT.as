package art.ciclope.sitio.transitions {
	
	// CICLOPE CLASSES
	import art.ciclope.sitio.SitioImage;
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class TransitionSWIPERIGHT {
		
		// PUBLIC VARIABLES
		
		/**
		 * Community screen width.
		 */
		public var width:Number;
		/**
		 * Community screen height.
		 */
		public var height:Number;
		
		public function TransitionSWIPERIGHT(width:Number, height:Number) {
			this.width = width;
			this.height = height;
		}
		
		/**
		 * Enter screen transition set.
		 * @param	image	the image to apply transition
		 */
		public function setIN(image:SitioImage):void {
			image.x = -0.5 * this.width;
			image.rotationY = -90;
		}
		
		/**
		 * Exit screen transition set.
		 * @param	image	the image to apply transition
		 */
		public function setOUT(image:SitioImage):void {
			image.toX = 1.5 * this.width;
			image.toRY = 90;
		}
		
		/**
		 * Release memory used by object.
		 */
		public function kill():void {
			// do nothing
		}
		
	}

}
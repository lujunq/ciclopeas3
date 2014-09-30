package art.ciclope.sitio.transitions {
	
	// CICLOPE CLASSES
	import art.ciclope.sitio.SitioImage;
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class TransitionCENTER {
		
		// PUBLIC VARIABLES
		
		/**
		 * Community screen width.
		 */
		public var width:Number;
		/**
		 * Community screen height.
		 */
		public var height:Number;
		
		public function TransitionCENTER(width:Number, height:Number) {
			this.width = width;
			this.height = height;
		}
		
		/**
		 * Enter screen transition set.
		 * @param	image	the image to apply transition
		 */
		public function setIN(image:SitioImage):void {
			image.width = 1;
			image.height = 1;
			image.x = this.width / 2;
			image.y = this.height / 2;
			image.z = 0;
		}
		
		/**
		 * Exit screen transition set.
		 * @param	image	the image to apply transition
		 */
		public function setOUT(image:SitioImage):void {
			image.toWidth = 1;
			image.toHeight = 1;
			image.toX = this.width / 2;
			image.toY = this.height / 2;
			image.toZ = 0;
		}
		
		/**
		 * Release memory used by object.
		 */
		public function kill():void {
			// do nothing
		}
		
	}

}
package art.ciclope.managana.transitions {
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaImage;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * TransitionCENTER provides methods for enabling dis folder streams transitions from the screen center.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
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
		
		/**
		 * TransitionCENTER constructor.
		 * @param	width	the dis folder community width
		 * @param	height	the dis folder community height
		 */
		public function TransitionCENTER(width:Number, height:Number) {
			this.width = width;
			this.height = height;
		}
		
		/**
		 * Enter screen transition set.
		 * @param	image	the image to apply transition
		 */
		public function setIN(image:ManaganaImage):void {
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
		public function setOUT(image:ManaganaImage):void {
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
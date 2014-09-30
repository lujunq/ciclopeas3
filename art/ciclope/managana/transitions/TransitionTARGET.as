package art.ciclope.managana.transitions {
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaImage;
	import art.ciclope.managana.graphics.Target;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * TransitionTARGET provides methods for enabling dis folder streams transitions from the community target.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class TransitionTARGET {
		
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
		 * The community target.
		 */
		public var target:Target;
		
		/**
		 * TransitionTARGET constructor.
		 * @param	width	the dis folder community width
		 * @param	height	the dis folder community height
		 * @param	target	the community target
		 */
		public function TransitionTARGET(width:Number, height:Number, target:Target) {
			this.width = width;
			this.height = height;
			this.target = target;
		}
		
		/**
		 * Enter screen transition set.
		 * @param	image	the image to apply transition
		 */
		public function setIN(image:ManaganaImage):void {
			image.width = 1;
			image.height = 1;
			image.x = this.target.x;
			image.y = this.target.y;
			image.z = 0;
		}
		
		/**
		 * Exit screen transition set.
		 * @param	image	the image to apply transition
		 */
		public function setOUT(image:ManaganaImage):void {
			image.toWidth = 1;
			image.toHeight = 1;
			image.toX = this.target.x;
			image.toY = this.target.y;
			image.toZ = 0;
		}
		
		/**
		 * Release memory used by object.
		 */
		public function kill():void {
			this.target = null;
		}
		
	}

}
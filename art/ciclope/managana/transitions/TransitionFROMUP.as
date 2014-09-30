package art.ciclope.managana.transitions {
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaImage;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * TransitionFROMUP provides methods for enabling dis folder streams transitions from upper border.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class TransitionFROMUP {
		
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
		 * TransitionFROMUP constructor.
		 * @param	width	the dis folder community width
		 * @param	height	the dis folder community height
		 */
		public function TransitionFROMUP(width:Number, height:Number) {
			this.width = width;
			this.height = height;
		}
		
		/**
		 * Enter screen transition set.
		 * @param	image	the image to apply transition
		 */
		public function setIN(image:ManaganaImage):void {
			image.y = -1.2 * image.height;
		}
		
		/**
		 * Exit screen transition set.
		 * @param	image	the image to apply transition
		 */
		public function setOUT(image:ManaganaImage):void {
			image.toY = this.height + (1.2 * image.height);
		}
		
		/**
		 * Release memory used by object.
		 */
		public function kill():void {
			// do nothing
		}
		
	}

}
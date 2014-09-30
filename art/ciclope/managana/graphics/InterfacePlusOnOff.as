package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * InterfacePlusOnOff provides a graphic interface for Managana reader show/hide plus menu button.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class InterfacePlusOnOff extends Sprite {
		
		// PUBLIC VARIABLES
		
		/**
		 * The + sign.
		 */
		public var plus:Sprite;
		/**
		 * The - sign.
		 */
		private var minus:Sprite;
		
		/**
		 * InterfacePlusOnOff constructor.
		 */
		public function InterfacePlusOnOff() {
			this.plus = new ButtonPlus() as Sprite;
			this.addChild(this.plus);
			this.minus = new ButtonMinus() as Sprite;
			this.minus.visible = false;
			this.addChild(this.minus);
			this.buttonMode = true;
			this.useHandCursor = true;
		}
		
		// PUBLIC METHODS
		
		/**
		 * Show/hide plus and minus signs.
		 * @param	to	true: show + and hide -, false: hide + and show -
		 */
		public function showPlus(to:Boolean):void {
			this.plus.visible = to;
			this.minus.visible = !to;
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			this.removeChild(this.minus);
			this.removeChild(this.plus);
			this.minus = null;
			this.plus = null;
		}
		
	}

}
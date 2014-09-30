package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * RateStarButton provides a graphic interface for Managana reader star rating buttons.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class RateStarButton extends Sprite {
		
		// VARIABLES
		
		private var _light:Sprite;		// the light star
		private var _dark:Sprite;		// the dark star
		
		/**
		 * RateStarButton constructor.
		 */
		public function RateStarButton() {
			this._light = new RateStarLight() as Sprite;
			this._light.visible = false;
			this.addChild(this._light);
			this._dark = new RateStarDark() as Sprite;
			this.addChild(this._dark);
			this.buttonMode = true;
			this.useHandCursor = true;
		}
		
		// PROPERTIES
		
		/**
		 * Button star state: light or dark.
		 */
		public function get state():String {
			if (this._light.visible) return ("light");
				else return ("dark");
		}
		public function set state(to:String):void {
			if (to == "light") {
				this._light.visible = true;
				this._dark.visible = false;
			} else {
				this._light.visible = false;
				this._dark.visible = true;
			}
		}
		
		// PUBLIC METHODS
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			this.removeChild(this._light);
			this.removeChild(this._dark);
			this._light = null;
			this._dark = null;
		}
		
	}

}
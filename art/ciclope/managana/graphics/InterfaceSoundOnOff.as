package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * InterfaceSoundOnOff provides a graphic interface for Managana reader mute button.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class InterfaceSoundOnOff extends Sprite {
		
		// VARIABLES
		
		private var _on:Sprite;			// the sound on graphic
		private var _off:Sprite;		// the sound off graphic
		
		/**
		 * InterfaceSoundOnOff constructor.
		 */
		public function InterfaceSoundOnOff() {
			this._on = new ButtonSoundOn() as Sprite;
			this.addChild(this._on);
			this._off = new ButtonSoundOff() as Sprite;
			this._off.visible = false;
			this.addChild(this._off);
			this.buttonMode = true;
			this.useHandCursor = true;
		}
		
		// PROPERTIES
		
		/**
		 * Is sound button on mute state?
		 */
		public function get isMute():Boolean {
			return(this._off.visible);
		}
		public function set isMute(to:Boolean):void {
			this._off.visible = to;
			this._on.visible = !to;
		}
		
		// PUBLIC METHODS
		
		/**
		 * Click on this button.
		 * @return	true if the new state is on, false if it is off
		 */
		public function onClick():Boolean {
			var ret:Boolean = !this._on.visible;
			this._on.visible = !this._on.visible;
			this._off.visible = ! this._off.visible;
			return (ret);
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			this.removeChild(this._off);
			this.removeChild(this._on);
			this._off = null;
			this._on = null;
		}
		
	}

}
package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * InterfacePlayPlause provides a graphic interface for Managana reader play/pause button.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class InterfacePlayPause extends Sprite {
		
		// VARIABLES
		
		private var _play:Sprite;		// the play graphic
		private var _pause:Sprite;		// the pause graphic
		
		/**
		 * InterfacePlayPause constructor.
		 */
		public function InterfacePlayPause() {
			this._play = new ButtonPlay() as Sprite;
			this.addChild(this._play);
			this._play.visible = false;
			this._pause = new ButtonPause() as Sprite;
			this.addChild(this._pause);
			this.buttonMode = true;
			this.useHandCursor = true;
		}
		
		// PROPERTIES
		
		/**
		 * Play button visibility.
		 */
		public function get playVisible():Boolean {
			return (this._play.visible);
		}
		public function set playVisible(to:Boolean):void {
			this._play.visible = to;
			this._pause.visible = !to;
		}
		
		// PUBLIC METHODS
		
		/**
		 * Click on this button.
		 * @return	true if the new state is play, false if it is pause
		 */
		public function onClick():Boolean {
			var ret:Boolean = !this._play.visible;
			this._play.visible = !this._play.visible;
			this._pause.visible = ! this._pause.visible;
			return (ret);
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			this.removeChild(this._pause);
			this.removeChild(this._play);
			this._pause = null;
			this._play = null;
		}
		
	}

}
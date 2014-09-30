package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * WaitingGraphic provides a graphic interface for Managana reader waiting user response.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class WaitingGraphic extends Sprite {
		
		// VARIABLES
		
		private var _graphic:Sprite;		// waiting graphic
		private var _interval:int;			// animation interval
		
		/**
		 * WaitingGraphic constructor.
		 */
		public function WaitingGraphic() {
			this._graphic = new Waiting() as Sprite;
			this.addChild(this._graphic);
			this._graphic.x = -this._graphic.width / 2;
			this._graphic.y = -this._graphic.height / 2;
			this._interval = setInterval(onAnimate, 100);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			clearInterval(this._interval);
			this.removeChild(this._graphic);
			this._graphic = null;
		}
		
		// PRIVATE METHODS
		
		/**
		 * Rotate graphic.
		 */
		private function onAnimate():void {
			this.rotation += 15;
		}
		
	}

}
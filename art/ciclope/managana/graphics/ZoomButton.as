package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaInterface;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * ZoomButton creates an interface for content zoom in/out and reset display.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class ZoomButton extends Sprite {
		
		// VARIABLES
		
		private var _minus:Sprite;			// zoom minus button
		private var _center:Sprite;			// zoom center button
		private var _plus:Sprite;			// zoom plus button
		private var _act:Function;			// function to apply zoom changes - must receive one string argument: "minus", "center" or "plus"
		
		/**
		 * ZoomButton constructor.
		 * @param	act	function to apply zoom changes - must receive one string argument: "minus", "center" or "plus"
		 */
		public function ZoomButton(act:Function) {
			this._minus = new ButtonZoomMinus() as Sprite;
			ManaganaInterface.setSize(this._minus);
			this.addChild(this._minus);
			this._minus.useHandCursor = true;
			this._minus.buttonMode = true;
			this._center = new ButtonZoomCenter() as Sprite;
			ManaganaInterface.setSize(this._center);
			this.addChild(this._center);
			this._center.useHandCursor = true;
			this._center.buttonMode = true;
			this._center.x = this._minus.width;
			this._plus = new ButtonZoomPlus() as Sprite;
			ManaganaInterface.setSize(this._plus);
			this.addChild(this._plus);
			this._plus.useHandCursor = true;
			this._plus.buttonMode = true;
			this._plus.x = this._center.x + this._center.width;
			this._act = act;
			this._minus.addEventListener(MouseEvent.CLICK, onMinus);
			this._center.addEventListener(MouseEvent.CLICK, onCenter);
			this._plus.addEventListener(MouseEvent.CLICK, onPlus);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Release resources used by the object.
		 */
		public function kill():void {
			this.removeChildren();
			this._minus.removeEventListener(MouseEvent.CLICK, onMinus);
			this._center.removeEventListener(MouseEvent.CLICK, onCenter);
			this._plus.removeEventListener(MouseEvent.CLICK, onPlus);
			this._minus = null;
			this._center = null;
			this._plus = null;
			this._act = null;
		}
		
		// PRIVATE METHODS
		
		/**
		 * Click on minus button.
		 */
		private function onMinus(evt:MouseEvent):void {
			if (this._act != null) this._act('minus');
		}
		
		/**
		 * Click on center button.
		 */
		private function onCenter(evt:MouseEvent):void {
			if (this._act != null) this._act('center');
		}
		
		/**
		 * Click on plus button.
		 */
		private function onPlus(evt:MouseEvent):void {
			if (this._act != null) this._act('plus');
		}
		
	}

}
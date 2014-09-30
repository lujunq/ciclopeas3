package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaInterface;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * InterfaceRateButton provides a graphic interface for Managana reader lower rate button.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class InterfaceRateButton extends Sprite {
		
		// VARIABLES
		
		private var _ready:Boolean;			// is the button ready?
		private var _graphic:Sprite;		// the button graphic
		private var _graphic1:Sprite;		// the button graphic rate 1
		private var _graphic2:Sprite;		// the button graphic rate 2
		private var _graphic3:Sprite;		// the button graphic rate 3
		private var _graphic4:Sprite;		// the button graphic rate 4
		private var _graphic5:Sprite;		// the button graphic rate 5
		private var _remote:Boolean;		// is the button used on remote control?
		
		private var _refWidth:Number;
		private var _refHeight:Number;
		
		/**
		 * InterfaceRateButton constructor.
		 * @param	onremote	is the button used on remote control?
		 */
		public function InterfaceRateButton(refWidth:Number, refHeight:Number, onremote:Boolean = false) {
			this._ready = false;
			this._refWidth = refWidth;
			this._refHeight = refHeight;
			this._remote = onremote;
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		/**
		 * Stage became available.
		 */
		private function onStage(evt:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			if (this._remote) {
				this._graphic = new RemoteRateButton() as Sprite;
				this._graphic1 = new RemoteRateButton1() as Sprite;
				this._graphic2 = new RemoteRateButton2() as Sprite;
				this._graphic3 = new RemoteRateButton3() as Sprite;
				this._graphic4 = new RemoteRateButton4() as Sprite;
				this._graphic5 = new RemoteRateButton5() as Sprite;
			} else {
				this._graphic = new RateButton() as Sprite;
				this._graphic1 = new RateButton1() as Sprite;
				this._graphic2 = new RateButton2() as Sprite;
				this._graphic3 = new RateButton3() as Sprite;
				this._graphic4 = new RateButton4() as Sprite;
				this._graphic5 = new RateButton5() as Sprite;
			}
			ManaganaInterface.setSize(this._graphic);
			ManaganaInterface.setSize(this._graphic1);
			ManaganaInterface.setSize(this._graphic2);
			ManaganaInterface.setSize(this._graphic3);
			ManaganaInterface.setSize(this._graphic4);
			ManaganaInterface.setSize(this._graphic5);
			this.addChild(this._graphic);
			this._graphic1.visible = false;
			this.addChild(this._graphic1);
			this._graphic2.visible = false;
			this.addChild(this._graphic2);
			this._graphic3.visible = false;
			this.addChild(this._graphic3);
			this._graphic4.visible = false;
			this.addChild(this._graphic4);
			this._graphic5.visible = false;
			this.addChild(this._graphic5);
			this.useHandCursor = true;
			this.buttonMode = true;
			this._ready = true;
			this.redraw();
		}
		
		// PROPERTIES
		
		/**
		 * The button rate number (0-5).
		 */
		public function get rate():uint {
			var ret:uint = 0;
			if (this._ready) {
				if (this._graphic1.visible) ret = 1;
				if (this._graphic2.visible) ret = 2;
				if (this._graphic3.visible) ret = 3;
				if (this._graphic4.visible) ret = 4;
				if (this._graphic5.visible) ret = 5;
			}
			return(ret);
		}
		public function set rate(to:uint):void {
			if (this._ready) {
				if (to <= 5) {
					this._graphic.visible = (to == 0);
					this._graphic1.visible = (to == 1);
					this._graphic2.visible = (to == 2);
					this._graphic3.visible = (to == 3);
					this._graphic4.visible = (to == 4);
					this._graphic5.visible = (to == 5);
				} else {
					this._graphic.visible = true;
					this._graphic1.visible = this._graphic2.visible = this._graphic3.visible = this._graphic4.visible = this._graphic5.visible = false;
				}
			}
		}
		
		// PUBLIC METHODS
		
		/**
		 * Redraw button.
		 */
		public function redraw(refSize:Point = null):void {
			if (refSize != null) {
				this._refWidth = refSize.x;
				this._refHeight = refSize.y;
			}
			if (this._ready) {
				this.x = this._refWidth - this.width - 5;
				this.y = this._refHeight - this.height - 5;
			}
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			if (this._ready) {
				this.removeChild(this._graphic);
				this._graphic = null;
				this.removeChild(this._graphic1);
				this._graphic1 = null;
				this.removeChild(this._graphic2);
				this._graphic2 = null;
				this.removeChild(this._graphic3);
				this._graphic3 = null;
				this.removeChild(this._graphic4);
				this._graphic4 = null;
				this.removeChild(this._graphic5);
				this._graphic5 = null;
			} else {
				this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			}
		}
		
	}

}
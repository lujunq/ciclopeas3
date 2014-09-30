package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.geom.Point;
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaInterface;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * RateWindow provides a graphic interface for Managana reader rating window.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class RateWindow extends Sprite {
		
		// VARIABLES
		
		private var _ready:Boolean;				// is window ready?
		private var _bg:InterfaceWindow			// window background
		private var _label:TextField;			// window label
		private var _star1:RateStarButton;		// star button 1
		private var _star2:RateStarButton;		// star button 2
		private var _star3:RateStarButton;		// star button 3
		private var _star4:RateStarButton;		// star button 4
		private var _star5:RateStarButton;		// star button 5
		private var _close:Sprite;				// close window button
		
		private var _refWidth:Number;
		private var _refHeight:Number;
		
		// PUBLIC VARIABLES
		
		/**
		 * A function to call while rating.
		 */
		public var onRate:Function;
		
		/**
		 * RateWindow constructor.
		 */
		public function RateWindow(refWidth:Number, refHeight:Number) {
			this._ready = false;
			this._refWidth = refWidth;
			this._refHeight = refHeight;
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		/**
		 * Stage became available.
		 */
		private function onStage(evt:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			this._bg = new InterfaceWindow();
			this._bg.width = ManaganaInterface.newSize(300);
			this._bg.height = ManaganaInterface.newSize(100);
			this.addChild(this._bg);
			this._label = new TextField();
			this._label.defaultTextFormat = new TextFormat("_sans", ManaganaInterface.newSize(16), 0xFFFFFF, true, false, false, null, null, "center");
			this._label.multiline = false;
			this._label.selectable = false;
			this._label.text = "";
			this._label.width = this.width - 20;
			this.addChild(this._label);
			this._star1 = new RateStarButton();
			this._star2 = new RateStarButton();
			this._star3 = new RateStarButton();
			this._star4 = new RateStarButton();
			this._star5 = new RateStarButton();
			ManaganaInterface.setSize(this._star1);
			ManaganaInterface.setSize(this._star2);
			ManaganaInterface.setSize(this._star3);
			ManaganaInterface.setSize(this._star4);
			ManaganaInterface.setSize(this._star5);
			this.addChild(this._star1);
			this.addChild(this._star2);
			this.addChild(this._star3);
			this.addChild(this._star4);
			this.addChild(this._star5);
			this._star1.addEventListener(MouseEvent.CLICK, onStar1);
			this._star2.addEventListener(MouseEvent.CLICK, onStar2);
			this._star3.addEventListener(MouseEvent.CLICK, onStar3);
			this._star4.addEventListener(MouseEvent.CLICK, onStar4);
			this._star5.addEventListener(MouseEvent.CLICK, onStar5);
			this._close = new CloseWindow() as Sprite;
			ManaganaInterface.setSize(this._close);
			this._close.x = this._bg.width - (this._close.width / 2);
			this._close.y = this._bg.y - (this._close.height / 2);
			this._close.buttonMode = true;
			this._close.useHandCursor = true;
			this._close.addEventListener(MouseEvent.CLICK, onClose);
			this.addChild(this._close);
			this._ready = true;
			this.redraw();
		}
		
		// PROPERTIES
		
		/**
		 * The window rate number (0-5).
		 */
		public function get rate():uint {
			var ret:uint = 0;
			if (this._ready) {
				if (this._star1.state == "light") ret = 1;
				if (this._star2.state == "light") ret = 2;
				if (this._star3.state == "light") ret = 3;
				if (this._star4.state == "light") ret = 4;
				if (this._star5.state == "light") ret = 5;
			}
			return(ret);
		}
		public function set rate(to:uint):void {
			if (to <= 5) {
				(to >= 1) ? this._star1.state = "light" : this._star1.state = "dark";
				(to >= 2) ? this._star2.state = "light" : this._star2.state = "dark";
				(to >= 3) ? this._star3.state = "light" : this._star3.state = "dark";
				(to >= 4) ? this._star4.state = "light" : this._star4.state = "dark";
				(to >= 5) ? this._star5.state = "light" : this._star5.state = "dark";
			} else {
				this._star1.state = this._star2.state = this._star3.state = this._star4.state = this._star5.state = "dark";
			}
		}
		
		/**
		 * Window label text.
		 */
		public function get text():String {
			return (this._label.text);
		}
		public function set text(to:String):void {
			this._label.text = to;
		}
		
		// PUBLIC METHODS
		
		/**
		 * Redraw the window.
		 */
		public function redraw(refSize:Point = null):void {
			if (refSize != null) {
				this._refWidth = refSize.x;
				this._refHeight = refSize.y;
			}
			if (this._ready) {
				this._label.x = 10;
				this._label.y = ManaganaInterface.newSize(15);
				var starwidth:Number = (this._star1.width) * 5 + (20 * 4);
				this._star1.x = (this._bg.width - starwidth) / 2;
				this._star2.x = this._star1.x + this._star1.width + 20;
				this._star3.x = this._star2.x + this._star2.width + 20;
				this._star4.x = this._star3.x + this._star3.width + 20;
				this._star5.x = this._star4.x + this._star4.width + 20;
				this._star1.y = this._star2.y = this._star3.y = this._star4.y = this._star5.y = this._bg.height - ManaganaInterface.newSize(15) - this._star1.height;
				this.x = (this._refWidth - this._bg.width) / 2;
				this.y = (this._refHeight - this._bg.height) / 2;
			}
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			if (this._ready) {
				this.removeChild(this._bg);
				this._bg.kill();
				this._bg = null;
				this.removeChild(this._label);
				this._label = null;
				this._star1.removeEventListener(MouseEvent.CLICK, onStar1);
				this._star2.removeEventListener(MouseEvent.CLICK, onStar2);
				this._star3.removeEventListener(MouseEvent.CLICK, onStar3);
				this._star4.removeEventListener(MouseEvent.CLICK, onStar4);
				this._star5.removeEventListener(MouseEvent.CLICK, onStar5);
				this.removeChild(this._star1);
				this._star1.kill();
				this._star1 = null;
				this.removeChild(this._star2);
				this._star2.kill();
				this._star2 = null;
				this.removeChild(this._star3);
				this._star3.kill();
				this._star3 = null;
				this.removeChild(this._star4);
				this._star4.kill();
				this._star4 = null;
				this.removeChild(this._star5);
				this._star5.kill();
				this._star5 = null;
				this.removeChild(this._close);
				this._close.removeEventListener(MouseEvent.CLICK, onClose);
				this._close = null;
			} else {
				this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			}
			this.onRate = null;
		}
		
		// PRIVATE METHODS
		
		/**
		 * Click on first start.
		 */
		private function onStar1(evt:MouseEvent):void {
			this.rate = 1;
			if (this.onRate != null) this.onRate(1);
		}
		
		/**
		 * Click on seocnd start.
		 */
		private function onStar2(evt:MouseEvent):void {
			this.rate = 2;
			if (this.onRate != null) this.onRate(2);
		}
		
		/**
		 * Click on third start.
		 */
		private function onStar3(evt:MouseEvent):void {
			this.rate = 3;
			if (this.onRate != null) this.onRate(3);
		}
		
		/**
		 * Click on fourth start.
		 */
		private function onStar4(evt:MouseEvent):void {
			this.rate = 4;
			if (this.onRate != null) this.onRate(4);
		}
		
		/**
		 * Click on fifth start.
		 */
		private function onStar5(evt:MouseEvent):void {
			this.rate = 5;
			if (this.onRate != null) this.onRate(5);
		}
		
		/**
		 * Close window.
		 */
		private function onClose(evt:MouseEvent):void {
			this.dispatchEvent(new Event(Event.CLOSE));
			this.visible = false;
		}
		
	}

}
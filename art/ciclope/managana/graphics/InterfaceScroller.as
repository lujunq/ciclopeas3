package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * InterfaceScroller provides a graphic interface for Managana reader list scroller.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class InterfaceScroller extends Sprite {
		
		// VARIABLES
		
		private var _top:Sprite;		// scroller top
		private var _bottom:Sprite;		// scroller bottom
		private var _middle:Sprite;		// scroller middle
		private var _button:Sprite;		// scroller button
		private var _mouselock:Number;	// mouse reference for button scroll
		
		/**
		 * InterfaceScroller constructor.
		 */
		public function InterfaceScroller() {
			// prepare graphics
			this._top = new ScrollerTop() as Sprite;
			this._top.x = this._top.y = 0;
			this.addChild(this._top);
			this._middle = new ScrollerMiddle() as Sprite;
			this.addChild(this._middle);
			this._bottom = new ScrollerBottom() as Sprite;
			this.addChild(this._bottom);
			this._button = new ScrollerButton() as Sprite;
			this.addChild(this._button);
			this._button.addEventListener(MouseEvent.MOUSE_DOWN, startButtonDrag);
			this._button.y = 1;
		}
		
		// PROPERTIES
		
		/**
		 * Scroller width (read-only).
		 */
		override public function get width():Number {
			return super.width;
		}
		override public function set width(value:Number):void {
			// do nothing
		}
		
		/**
		 * Scroller height (minimum = 18).
		 */
		override public function get height():Number {
			return super.height;
		}
		override public function set height(value:Number):void {
			if (value < 18) value = 18;
			var holdpos:Number = this.position;
			this._top.x = 0;
			this._top.y = 0;
			this._middle.x = 0;
			this._middle.y = this._top.height;
			this._middle.height = value - this._top.height - this._bottom.height;
			this._bottom.x = 0;
			this._bottom.y = this._middle.y + this._middle.height;
			this.position = holdpos;
		}
		
		/**
		 * Is the scroller enabled?
		 */
		public function get enabled():Boolean {
			return (this._top.alpha < 1);
		}
		public function set enabled(to:Boolean):void {
			if (to) {
				this._top.alpha = this._middle.alpha = this._bottom.alpha = 1;
			} else {
				this._top.alpha = this._middle.alpha = this._bottom.alpha = 0.5;
			}
			this._button.visible = to;
		}
		
		/**
		 * Scroll button position (in %).
		 */
		public function get position():Number {
			return ((this._button.y / (1 + (this.height - 2) - this._button.height)) * 100);
		}
		public function set position(to:Number):void {
			if (to < 0) to = 0;
			if (to > 100) to = 100;
			this._button.y = 1 + (((this.height - 2) - this._button.height) * (to / 100));
		}
		
		// PUBLIC METHODS
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			this.removeChild(this._top);
			this.removeChild(this._middle);
			this.removeChild(this._bottom);
			this.removeChild(this._button);
			this._top = null;
			this._middle = null;
			this._bottom = null;
			this._button.removeEventListener(MouseEvent.MOUSE_DOWN, startButtonDrag);
			this._button = null;
			try {
				if (this.stage.hasEventListener(MouseEvent.MOUSE_UP)) this.stage.removeEventListener(MouseEvent.MOUSE_UP, stopButtonDrag);
				if (this.stage.hasEventListener(MouseEvent.MOUSE_MOVE)) this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, buttonDragging);
			} catch (e:Error) { }
		}
		
		// PRIVATE METHODS
		
		/**
		 * Scroll button start drag.
		 */
		private function startButtonDrag(evt:MouseEvent):void {
			this._mouselock = this.mouseY;
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, buttonDragging);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, stopButtonDrag);
		}
		
		/**
		 * Scroll button dragging.
		 */
		private function buttonDragging(evt:MouseEvent):void {
			if ((this.mouseY > 1) && (this.mouseY < (this.height - 2 - this._button.height))) this._button.y = this.mouseY;
			this._mouselock = this._button.y;
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * Scroll button stop drag.
		 */
		private function stopButtonDrag(evt:MouseEvent):void {
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, buttonDragging);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, stopButtonDrag);
			this._button.y = this._mouselock;
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
	}

}
package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class VerticalFlow extends Sprite {
		
		// CONSTANTS
		
		private const SCROLLSPEED:int = 10;			// component layer scroll speed
		
		// VARIABLES
		
		private var _components:Sprite;				// component layer
		private var _buttonUP:InterfaceWindow;		// up button background
		private var _buttonDOWN:InterfaceWindow;	// down button background
		private var _interval:int;					// scroll interval
		private var _arrowUp:Sprite;				// scroll arrow up
		private var _arrowDown:Sprite;				// scroll arrow down
		
		// PUBLIC VARIABLES
		
		/**
		 * Amount of pixels to separate components.
		 */
		public var spacing:uint;
		
		public function VerticalFlow(spacing:uint = 10) {
			// get data
			this.spacing = spacing;
			// create component layer
			this._components = new Sprite();
			this.addChild(this._components);
			// scroll arrows
			this._arrowUp = new RemoteArrowUp() as Sprite;
			this._arrowUp.alpha = 0.25;
			this.addChild(this._arrowUp);
			this._arrowDown = new RemoteArrowDown() as Sprite;
			this._arrowDown.alpha = 0.25;
			this.addChild(this._arrowDown);
			// create buttons
			this._buttonUP = new InterfaceWindow(false);
			this._buttonUP.alpha = 0.5;
			this.addChild(this._buttonUP);
			this._buttonDOWN = new InterfaceWindow(false);
			this._buttonDOWN.alpha = 0.5;
			this.addChild(this._buttonDOWN);
			// scrolling
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		/**
		 * Add a component to the display flow.
		 * @param	display	a display object to add
		 */
		public function addComponent(display:DisplayObject):void {
			this._components.addChild(display);
		}
		
		/**
		 * Remove a component from the display flow.
		 * @param	display	the display object to remove
		 * @return	true if the object was found and removed, flas otherwise
		 */
		public function removeComponent(display:DisplayObject):Boolean {
			var result:Boolean;
			try {
				this._components.removeChild(display);
				result = true;
			} catch (e:Error) {
				result = false;
			}
			return (result);
		}
		
		/**
		 * Remove all components from the flow.
		 */
		public function clear():void {
			while (this._components.numChildren > 0) this._components.removeChildAt(0);
		}
		
		/**
		 * Redraw the flow component.
		 */
		public function redraw():void {
			// components
			var previous:DisplayObject;
			for (var index:uint = 0; index < this._components.numChildren; index++) {
				var component:DisplayObject = this._components.getChildAt(index) as DisplayObject;
				if (component.visible) {
					if (previous == null) {
						component.y = this.spacing;
					} else {
						component.y = previous.y + previous.height + this.spacing;
					}
					previous = component;
				} else {
					component.y = 0;
				}
			}
			if (this._components.height < this.stage.stageHeight) {
				this._components.y = (this.stage.stageHeight - (this._components.height)) / 2;
			} else {
				this._components.y = 0;
			}
			// buttons
			this._buttonUP.width = this.stage.stageWidth - 160;
			this._buttonUP.height = 80;
			this._buttonUP.x = 80;
			this._buttonUP.y = -this._buttonUP.height / 3;
			this._buttonDOWN.width = this.stage.stageWidth - 160;
			this._buttonDOWN.height = 80;
			this._buttonDOWN.x = 80;
			this._buttonDOWN.y = this.stage.stageHeight - (this._buttonDOWN.height * 2 / 3);
			if (this._components.height < this.stage.stageHeight) {
				this._buttonUP.visible = false;
				this._buttonDOWN.visible = false;
				this._arrowUp.visible = false;
				this._arrowDown.visible = false;
			} else {
				this._buttonUP.visible = true;
				this._buttonDOWN.visible = true;
				this._arrowUp.visible = true;
				this._arrowDown.visible = true;
				this._components.y = this._buttonUP.y + this._buttonUP.height;
			}
			this._arrowUp.x = this._buttonUP.x + ((this._buttonUP.width - this._arrowUp.width) / 2);
			this._arrowUp.y = 0;
			this._arrowDown.x = this._buttonDOWN.x + ((this._buttonDOWN.width - this._arrowDown.width) / 2);
			this._arrowDown.y = this._buttonDOWN.y;
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			while (this._components.numChildren > 0) this._components.removeChildAt(0);
			this.removeChild(this._components);
			this._components = null;
			if (this.stage != null) {
				this._buttonUP.removeEventListener(MouseEvent.MOUSE_DOWN, onUpClick);
				this._buttonDOWN.removeEventListener(MouseEvent.MOUSE_DOWN, onDownClick);
				this.stage.removeEventListener(MouseEvent.MOUSE_UP, onStageUp);
			} else {
				this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			}
			this.removeChild(this._buttonUP);
			this._buttonUP.kill();
			this._buttonUP = null;
			this.removeChild(this._buttonDOWN);
			this._buttonDOWN.kill();
			this._buttonDOWN = null;
			this.removeChild(this._arrowUp);
			this._arrowUp = null;
			this.removeChild(this._arrowDown);
			this._arrowDown = null;
		}
		
		// PRIVATE METHODS
		
		/**
		 * The stage became available.
		 */
		private function onStage(evt:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			this._buttonUP.addEventListener(MouseEvent.MOUSE_DOWN, onUpClick);
			this._buttonDOWN.addEventListener(MouseEvent.MOUSE_DOWN, onDownClick);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onStageUp);
		}
		
		/**
		 * Start scroll up.
		 */
		private function onUpClick(evt:MouseEvent):void {
			this._components.y += SCROLLSPEED;
			this._interval = setInterval(scrollUP, 25);
		}
		
		/**
		 * Start scroll down.
		 */
		private function onDownClick(evt:MouseEvent):void {
			this._components.y -= SCROLLSPEED;
			this._interval = setInterval(scrollDOWN, 25);
		}
		
		/**
		 * Stop scrolling.
		 */
		private function onStageUp(evt:MouseEvent):void {
			clearInterval(this._interval);
		}
		
		/**
		 * Move components up.
		 */
		private function scrollUP():void {
			this._components.y += SCROLLSPEED;
		}
		
		/**
		 * Move components down.
		 */
		private function scrollDOWN():void {
			this._components.y -= SCROLLSPEED;
		}
		
	}

}
package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * ListWindow provides a graphic interface for showing lists.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class ListWindow extends Sprite {
		
		// VARIABLES
		
		private var _ready:Boolean;					// is window ready?
		private var _bg:InterfaceWindow;			// window background
		private var _items:Array;					// item data array
		private var _list:Sprite;					// holder for items
		private var _listMask:Sprite;				// a mask for the items
		private var _scroller:InterfaceScroller;	// item scroller
		private var _scinterval:int;				// scroller interval handler
		private var _close:Sprite;					// close window button
		
		private var _itemselect:ListItem;			// a reference to last item on mouse down
		private var _itemtimeout:int;				// timeout reference for item click
		
		// PUBLIC VARIABLES
		
		/**
		 * Function to call on list item click.
		 */
		public var selectAction:Function;
		
		/**
		 * On redraw, try to cover most of the screen?
		 */
		public var redrawfull:Boolean = false;
		
		/**
		 * ListWindow constructor.
		 */
		public function ListWindow() {
			this._ready = false;
			this._items = new Array();
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		/**
		 * Stage became available.
		 */
		private function onStage(evt:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			// prepare graphics
			this._bg = new InterfaceWindow();
			this.addChild(this._bg);
			this._ready = true;
			this._list = new Sprite();
			this._list.x = this._list.y = 20;
			this.addChild(this._list);
			this._listMask = new Sprite();
			this._listMask.graphics.beginFill(0);
			this._listMask.graphics.drawRect(0, 0, 100, 100);
			this._listMask.graphics.endFill();
			this._listMask.x = this._listMask.y = 20;
			this.addChild(this._listMask);
			this._list.mask = this._listMask;
			this._list.addEventListener(MouseEvent.MOUSE_DOWN, onListDown);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onListUp);
			this._scroller = new InterfaceScroller();
			this._scroller.addEventListener(Event.CHANGE, onScrollChange);
			this.addChild(this._scroller);
			this._close = new CloseWindow() as Sprite;
			this._close.buttonMode = true;
			this._close.useHandCursor = true;
			this._close.addEventListener(MouseEvent.CLICK, onClose);
			this.addChild(this._close);
			this.redraw();
		}
		
		// PUBLIC METHODS
		
		/**
		 * Redraw the window.
		 */
		public function redraw():void {
			if (this.redrawfull) {
				this._bg.width = this.stage.stageWidth - 70;
				this._bg.height = this.stage.stageHeight - 70;
			} else {
				this._bg.width = this.stage.stageWidth / 1.2;
				this._bg.height = this.stage.stageHeight / 1.7;
			}
			this._scroller.x = this._bg.width - this._scroller.width - 20;
			this._scroller.y = this._listMask.y;
			this._listMask.width = this._bg.width - 20 - this._scroller.width - 40;
			this._listMask.height = this._bg.height - 40;
			this._scroller.height = this._listMask.height;
			for (var index:uint = 0; index < this._list.numChildren; index++) {
				try {
					var item:ListItem = this._list.getChildAt(index) as ListItem;
					item.width = this._listMask.width;
					if (index > 0) item.y = this._list.getChildAt(index - 1).y + this._list.getChildAt(index - 1).height;
				} catch (e:Error) {
					// do nothing
				}
			}
			this._list.y = 20;
			this._scroller.enabled = (this._list.height > this._listMask.height);
			this._close.x = this._bg.width - (this._close.width / 2);
			this._close.y = this._bg.y - (this._close.height / 2);
			this.x = (this.stage.stageWidth - this._bg.width) / 2;
			this.y = (this.stage.stageHeight - this._bg.height) / 2;
		}
		
		/**
		 * Add an item to the list.
		 * @param	text	item text
		 * @param	data	item data
		 */
		public function addItem(text:String, data:String):void {
			var item:Array = new Array();
			item["text"] = text;
			item["data"] = data;
			this._items.push(item);
		}
		
		/**
		 * Remove all item information.
		 */
		public function clearItems():void {
			while (this._items.length > 0) {
				var item:Object = this._items[0];
				delete(item["text"]);
				delete(item["data"]);
				this._items.shift();
			}
			this._scroller.enabled = false;
		}
		
		/**
		 * Refresh item list.
		 */
		public function refreshList():void {
			// remove previous item graphics
			this._itemselect = null;
			while (this._list.numChildren > 0) {
				var item:ListItem = this._list.getChildAt(0) as ListItem;
				this._list.removeChild(item);
				item.removeEventListener(MouseEvent.MOUSE_DOWN, onItemDown);
				if (item.hasEventListener(MouseEvent.MOUSE_UP)) item.removeEventListener(MouseEvent.MOUSE_UP, onItemUp);
				item.kill();
				item = null;
			}
			// add current items
			for (var index:uint = 0; index < this._items.length; index++) {
				item = new ListItem(this._items[index]["text"], this._items[index]["data"], this._listMask.width);
				item.addEventListener(MouseEvent.MOUSE_DOWN, onItemDown);
				this._list.addChild(item);
				if (index > 0) item.y = this._list.getChildAt(index - 1).y + this._list.getChildAt(index - 1).height;
				if (index == (this._items.length - 1)) item.separatorVisible = false;
			}
			// scroller
			this._scroller.enabled = (this._list.height > this._listMask.height);
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			if (this._ready) {
				this.removeChild(this._bg);
				this._bg.kill();
				this._bg = null;
				this._list.mask = null;
				this._itemselect = null;
				while (this._list.numChildren > 0) {
					var item:ListItem = this._list.getChildAt(0) as ListItem;
					this._list.removeChild(item);
					item.removeEventListener(MouseEvent.MOUSE_DOWN, onItemDown);
					if (item.hasEventListener(MouseEvent.MOUSE_UP)) item.removeEventListener(MouseEvent.MOUSE_UP, onItemUp);
					item.kill();
					item = null;
				}
				this._list.removeEventListener(MouseEvent.MOUSE_DOWN, onListDown);
				this.stage.removeEventListener(MouseEvent.MOUSE_UP, onListUp);
				this._list = null;
				this.removeChild(this._listMask);
				this._listMask.graphics.clear();
				this._listMask = null;
				this.removeChild(this._scroller);
				this._scroller.removeEventListener(Event.CHANGE, onScrollChange);
				this._scroller.kill();
				this._scroller = null;
				this.removeChild(this._close);
				this._close.removeEventListener(MouseEvent.CLICK, onClose);
				this._close = null;
			} else {
				this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			}
			this.clearItems();
			this.selectAction = null;
			this._items = null;
		}
		
		// PRIVATE METHODS
		
		/**
		 * Start list drag.
		 */
		private function onListDown(evt:MouseEvent):void {
			evt.stopPropagation();
			if (this._list.height > this._listMask.height) {
				this._list.startDrag(false, new Rectangle(20, (20 - (this._list.height - this._listMask.height)), 0, (this._list.height - this._listMask.height)));
				this._scinterval = setInterval(this.setScroller, 100);
			}
		}
		
		/**
		 * Stop list drag.
		 */
		private function onListUp(evt:MouseEvent):void {
			this._list.stopDrag();
			clearInterval(this._scinterval);
			this.setScroller();
		}
		
		/**
		 * Set scroller bar button position.
		 */
		private function setScroller():void {
			if (this._list.height < this._listMask.height) {
				this._scroller.enabled = false;
				this._scroller.position = 0;
			} else {
				this._scroller.position = (this._list.y / (this._listMask.height - this._list.height + this._listMask.y)) * 100;
			}
		}
		
		/**
		 * Scroller value changed.
		 */
		private function onScrollChange(evt:Event):void {
			this._list.y = (this._listMask.height - this._list.height + this._listMask.y) * (this._scroller.position / 100);
		}
		
		/**
		 * Close window.
		 */
		private function onClose(evt:MouseEvent):void {
			this.dispatchEvent(new Event(Event.CLOSE));
			this.visible = false;
		}
		
		/**
		 * User pressed an item.
		 */
		private function onItemDown(evt:MouseEvent):void {
			this._itemselect = evt.target as ListItem;
			this._itemselect.addEventListener(MouseEvent.MOUSE_UP, onItemUp);
			this._itemtimeout = setTimeout(onLongTouch, 200);
		}
		
		/**
		 * User took too long to release the touch, probably scrolling the list.
		 */
		private function onLongTouch():void {
			if (this._itemselect != null) {
				if (this._itemselect.hasEventListener(MouseEvent.MOUSE_UP)) this._itemselect.removeEventListener(MouseEvent.MOUSE_UP, onItemUp);
			}
		}
		
		/**
		 * Click on an item.
		 */
		private function onItemUp(evt:MouseEvent):void {
			clearTimeout(this._itemtimeout);
			if (this._itemselect != null) {
				if (this._itemselect.hasEventListener(MouseEvent.MOUSE_UP)) this._itemselect.removeEventListener(MouseEvent.MOUSE_UP, onItemUp);
				if (this.selectAction != null) this.selectAction(this._itemselect.data);
				this._itemselect = null;
			}
		}
		
	}

}
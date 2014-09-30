package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import flash.geom.Point;
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaInterface;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * CommentWindow provides a graphic interface for showing comments on Managana reader.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class CommentWindow extends Sprite {
		
		// VARIABLES
		
		private var _ready:Boolean;					// is window ready?
		private var _bg:InterfaceWindow;			// window background
		private var _comments:Array;				// comment data array
		private var _list:Sprite;					// holder for comment items
		private var _listMask:Sprite;				// a mask for the comment items
		private var _scroller:InterfaceScroller;	// item scroller
		private var _scinterval:int;				// scroller interval handler
		private var _close:Sprite;					// close window button
		private var _plus:Sprite;					// add comment button
		
		private var _refWidth:Number;
		private var _refHeight:Number;
		
		// PUBLIC VARIABLES
		
		/**
		 * Function to call to create a comment.
		 */
		public var addaction:Function;
		/**
		 * On redraw, try to cover most of the screen?
		 */
		public var redrawfull:Boolean = false;
		
		/**
		 * CommentWindow constructor.
		 */
		public function CommentWindow(refWidth:Number, refHeight:Number) {
			this._ready = false;
			this._refWidth = refWidth;
			this._refHeight = refHeight;
			this._comments = new Array();
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
			ManaganaInterface.setSize(this._close);
			this._close.buttonMode = true;
			this._close.useHandCursor = true;
			this._close.addEventListener(MouseEvent.CLICK, onClose);
			this.addChild(this._close);
			this._plus = new ButtonPlus() as Sprite;
			ManaganaInterface.setSize(this._plus);
			this._plus.addEventListener(MouseEvent.CLICK, onPlus);
			this._plus.useHandCursor = true;
			this._plus.buttonMode = true;
			this.addChild(this._plus);
			this.redraw();
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
			if (this.redrawfull) {
				this._bg.width = this._refWidth - 70;
				this._bg.height = this._refHeight - 70;
			} else {
				this._bg.width = this._refWidth / 1.1;
				this._bg.height = this._refHeight / 1.6;
			}
			this._plus.x = 10;
			this._plus.y = this._bg.height - 10 - this._plus.height;
			this._scroller.x = this._bg.width - this._scroller.width - 20;
			this._scroller.y = this._listMask.y;
			this._listMask.width = this._bg.width - 10 - this._scroller.width - 20;
			this._listMask.height = this._bg.height - 10 - this._plus.height - 10;
			this._scroller.height = this._listMask.height;
			for (var index:uint = 0; index < this._list.numChildren; index++) {
				var item:CommentItem = this._list.getChildAt(index) as CommentItem;
				item.width = this._listMask.width;
				if (index > 0) item.y = this._list.getChildAt(index - 1).y + this._list.getChildAt(index - 1).height;
			}
			this._list.y = 20;
			this._scroller.enabled = (this._list.height > this._listMask.height);
			this._close.x = this._bg.width - (this._close.width / 2);
			this._close.y = this._bg.y - (this._close.height / 2);
			this.x = (this._refWidth - this._bg.width) / 2;
			this.y = ManaganaInterface.windowTop(this._close);
			
			
			/*if (this.redrawfull) {
				this._bg.width = this.stage.stageWidth - 70;
				this._bg.height = this.stage.stageHeight - 70;
			} else {
				this._bg.width = this.stage.stageWidth / 1.1;
				this._bg.height = this.stage.stageHeight / 1.6;
			}
			this._plus.x = 10;
			this._plus.y = this._bg.height - 10 - this._plus.height;
			this._scroller.x = this._bg.width - this._scroller.width - 20;
			this._scroller.y = this._listMask.y;
			this._listMask.width = this._bg.width - 10 - this._scroller.width - 20;
			this._listMask.height = this._bg.height - 10 - this._plus.height - 10;
			this._scroller.height = this._listMask.height;
			for (var index:uint = 0; index < this._list.numChildren; index++) {
				var item:CommentItem = this._list.getChildAt(index) as CommentItem;
				item.width = this._listMask.width;
				if (index > 0) item.y = this._list.getChildAt(index - 1).y + this._list.getChildAt(index - 1).height;
			}
			this._list.y = 20;
			this._scroller.enabled = (this._list.height > this._listMask.height);
			this._close.x = this._bg.width - (this._close.width / 2);
			this._close.y = this._bg.y - (this._close.height / 2);
			this.x = (this.stage.stageWidth - this._bg.width) / 2;
			this.y = ManaganaInterface.windowTop(this._close);*/
		}
		
		/**
		 * Add a comment to the list.
		 * @param	text	comment text
		 * @param	user	comment user name
		 * @param	time	comment time
		 */
		public function addComment(text:String, user:String, time:String):void {
			var comment:Array = new Array();
			comment["text"] = text;
			comment["user"] = user;
			comment["time"] = time;
			this._comments.push(comment);
		}
		
		/**
		 * Remove all comment information.
		 */
		public function clearComments():void {
			while (this._comments.length > 0) {
				var comment:Object = this._comments[0];
				delete(comment["text"]);
				delete(comment["user"]);
				delete(comment["time"]);
				this._comments.shift();
			}
			this._scroller.enabled = false;
		}
		
		/**
		 * Refresh comment list.
		 */
		public function refreshList():void {
			// remove previous item graphics
			var item:CommentItem;
			while (this._list.numChildren > 0) {
				item = this._list.getChildAt(0) as CommentItem;
				this._list.removeChild(item);
				item.kill();
				item = null;
			}
			// add current items
			for (var index:uint = 0; index < this._comments.length; index++) {
				item = new CommentItem(this._comments[index]["text"], this._comments[index]["user"], this._comments[index]["time"], this._listMask.width);
				this._list.addChild(item);
				if (index > 0) item.y = this._list.getChildAt(index - 1).y + this._list.getChildAt(index - 1).height;
				if (index == (this._comments.length - 1)) item.separatorVisible = false;
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
				while (this._list.numChildren > 0) {
					var item:CommentItem = this._list.getChildAt(0) as CommentItem;
					this._list.removeChild(item);
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
				this.removeChild(this._plus);
				this._plus.removeEventListener(MouseEvent.CLICK, onPlus);
				this._plus = null;
			} else {
				this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			}
			this.clearComments();
			this.addaction = null;
			this._comments = null;
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
		 * Open add comment window.
		 */
		private function onPlus(evt:MouseEvent):void {
			if (this.addaction != null) this.addaction();
		}
		
	}

}
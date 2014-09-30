package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	// CICLOPE CLASSES
	import art.ciclope.event.ReaderServerEvent;
	import art.ciclope.managana.data.ReaderServer;
	import art.ciclope.managana.ManaganaPlayer;
	import art.ciclope.managana.data.NoteAndMarkData;
	import art.ciclope.managana.ManaganaInterface;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * NotesAndMarkWindow provides a graphic interface for notes or bookmark management.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class NotesAndMarkWindow extends Sprite {
		
		// VARIABLES
		
		private var _ready:Boolean;						// is window ready?
		private var _bg:InterfaceWindow;				// window background
		private var _input:InterfaceTextInput;			// new note input
		private var _addBT:Sprite;						// add note button
		private var _close:Sprite;						// close window button
		private var _title:TextField;					// window title
		private var _list:Sprite;						// holder for comment items
		private var _listMask:Sprite;					// a mask for the comment items
		private var _scroller:InterfaceScroller;		// item scroller
		private var _scinterval:int;					// scroller interval handler
		private var _lockRedraw:Boolean;				// avoid redraw?
		private var _type:String;						// data type: note or bookmark
		private var _data:NoteAndMarkData;				// recorded data
		private var _reader:ReaderServer;				// a reference for the reader server
		private var _syncBT:Sprite;						// sync button
		private var _waiting:WaitingGraphic;			// waiting graphic for sync operation
		
		private var _refWidth:Number;
		private var _refHeight:Number;
		
		// PUBLIC VARIABLES
		
		/**
		 * A reference for the Managana player.
		 */
		public var managana:ManaganaPlayer;
		
		/**
		 * CommentWindow constructor.
		 */
		public function NotesAndMarkWindow(type:String, refWidth:Number, refHeight:Number, sysFunc:Function = null) {
			this._ready = false;
			this.visible = false;
			this._type = type;
			this._refWidth = refWidth;
			this._refHeight = refHeight;
			this._data = new NoteAndMarkData(type, sysFunc);
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		/**
		 * Stage became available.
		 */
		private function onStage(evt:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			// prepare graphics
			this._lockRedraw = false;
			this._bg = new InterfaceWindow();
			this.addChild(this._bg);
			this._close = new CloseWindow() as Sprite;
			ManaganaInterface.setSize(this._close);
			this._close.buttonMode = true;
			this._close.useHandCursor = true;
			this._close.addEventListener(MouseEvent.CLICK, onClose);
			this.addChild(this._close);
			this._input = new InterfaceTextInput();
			this.addChild(this._input);
			this._input.visible = (this._type == NoteAndMarkData.TYPE_NOTE);
			this._addBT = new ButtonAdd() as Sprite;
			ManaganaInterface.setSize(this._addBT);
			this._addBT.width = this._addBT.height = this._input.height;
			this.addChild(this._addBT);
			this._addBT.buttonMode = true;
			this._addBT.useHandCursor = true;
			this._addBT.addEventListener(MouseEvent.CLICK, onAdd);
			this._title = new TextField();
			this._title.defaultTextFormat = new TextFormat("_sans", ManaganaInterface.newSize(16), 0xFFFFFF, true);
			if (this._type == NoteAndMarkData.TYPE_MARK) this._title.text = "Notes";
				else this._title.text = "Bookmarks";
			this._title.multiline = false;
			this._title.selectable = false;
			this._title.height = this._title.getLineMetrics(0).height + ManaganaInterface.newSize(5);
			this.addChild(this._title);
			this._list = new Sprite();
			this.addChild(this._list);
			this._listMask = new Sprite();
			this._listMask.graphics.beginFill(0);
			this._listMask.graphics.drawRect(0, 0, 100, 100);
			this._listMask.graphics.endFill();
			this.addChild(this._listMask);
			this._list.mask = this._listMask;
			this._list.addEventListener(MouseEvent.MOUSE_DOWN, onListDown);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onListUp);
			this._scroller = new InterfaceScroller();
			this._scroller.addEventListener(Event.CHANGE, onScrollChange);
			this.addChild(this._scroller);
			this._list.visible = this._listMask.visible = this._scroller.visible = true;
			this._syncBT = new ButtonSync() as Sprite;
			ManaganaInterface.setSize(this._syncBT);
			this._syncBT.width = this._syncBT.height = this._input.height;
			this.addChild(this._syncBT);
			this._syncBT.buttonMode = true;
			this._syncBT.useHandCursor = true;
			this._syncBT.addEventListener(MouseEvent.CLICK, onSync);
			this._syncBT.visible = false;
			this._waiting = new WaitingGraphic();
			this._waiting.width = this._waiting.height = this._syncBT.width;
			this.addChild(this._waiting);
			this._waiting.visible = false;
			this._ready = true;
			this.redraw();
			this.refreshList();
		}
		
		// PROPERTIES
		
		/**
		 * A reference to the system reader server object.
		 */
		public function get reader():ReaderServer {
			return (this._reader);
		}
		public function set reader(to:ReaderServer):void {
			if (this._reader != null) {
				this._reader.removeEventListener(ReaderServerEvent.USERLOGIN, onLogin);
				this._reader.removeEventListener(ReaderServerEvent.USERLOGOUT, onLogout);
				this._reader.removeEventListener(ReaderServerEvent.NOTESYNC, onSyncReceived);
			}
			this._reader = to;
			if (to != null) {
				this._reader.addEventListener(ReaderServerEvent.USERLOGIN, onLogin);
				this._reader.addEventListener(ReaderServerEvent.USERLOGOUT, onLogout);
				this._reader.addEventListener(ReaderServerEvent.NOTESYNC, onSyncReceived);
			}
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
			if (!this._lockRedraw) {
				this._bg.width = this._refWidth / 1.1;
				this._bg.height = this._refHeight / 1.6;
				this._close.x = this._bg.width - (this._close.width / 2);
				this._close.y = this._bg.y - (this._close.height / 2);
				this._addBT.y = this._bg.height - this._addBT.height - 20;
				this._addBT.x = this._bg.width - 20 - this._addBT.width;
				if (this._syncBT.visible ) {
					this._syncBT.x = 20;
					this._syncBT.y = this._addBT.y;
					this._waiting.x = this._syncBT.x + (this._waiting.width / 2);
					this._waiting.y = this._syncBT.y + (this._waiting.height / 2);
					this._input.x = this._syncBT.x + this._syncBT.width + 20;
				} else {
					this._input.x = 20;
				}
				this._input.y = this._addBT.y;
				this._input.width = this._bg.width - this._input.x - 40 - this._addBT.width;
				this._title.x = 20;
				this._title.y = 15;
				this._title.width = this._bg.width - 40;
				this._list.x = this._listMask.x = 20;
				this._scroller.x = this._bg.width - 20 - this._scroller.width;
				this._list.y = this._listMask.y = this._scroller.y = this._title.y + this._title.height + 5;
				this._listMask.width = this._bg.width - 20 - this._scroller.width - 25;
				this._listMask.height = this._scroller.height = this._bg.height - this._listMask.y - 40 - this._input.height;
				for (var index:uint = 0; index < this._list.numChildren; index++) {
					var item:NoteAndMarkItem = this._list.getChildAt(index) as NoteAndMarkItem;
					item.width = this._listMask.width;
					if (index > 0) item.y = this._list.getChildAt(index - 1).y + this._list.getChildAt(index - 1).height;
				}
				this._scroller.enabled = (this._list.height > this._listMask.height);
				this.x = (this._refWidth - this._bg.width) / 2;
				this.y = ManaganaInterface.windowTop(this._close);
			}
			this._lockRedraw = false;
		}
		
		/**
		 * Set window text.
		 * @param	title	window title
		 */
		public function setText(title:String):void {
			this._title.text = title;
			this._title.height = this._title.getLineMetrics(0).height + ManaganaInterface.newSize(5);
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			if (this._ready) {
				this.removeChild(this._bg);
				this._bg.kill();
				this._bg = null;
				this.removeChild(this._close);
				this._close.removeEventListener(MouseEvent.CLICK, onClose);
				this._close = null;
				this.removeChild(this._addBT);
				this._addBT.removeEventListener(MouseEvent.CLICK, onAdd);
				this._addBT = null;
				this.removeChild(this._syncBT);
				this._syncBT.removeEventListener(MouseEvent.CLICK, onSync);
				this._syncBT = null;
				this.removeChild(this._waiting);
				this._waiting.kill();
				this._waiting = null;
				this.removeChild(this._input);
				this._input.kill();
				this._input = null;
				this._list = null;
				this.removeChild(this._listMask);
				this._listMask.graphics.clear();
				this._listMask = null;
				this.removeChild(this._scroller);
				this._scroller.removeEventListener(Event.CHANGE, onScrollChange);
				this._scroller.kill();
				this._scroller = null;
				this._data.kill();
				this._data = null;
			} else {
				this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			}
			if (this._reader != null) {
				this._reader.removeEventListener(ReaderServerEvent.USERLOGIN, onLogin);
				this._reader.removeEventListener(ReaderServerEvent.USERLOGOUT, onLogout);
				this._reader.removeEventListener(ReaderServerEvent.NOTESYNC, onSyncReceived);
			}
			this._reader = null;
			this.managana = null;
		}
		
		// PRIVATE METHODS
		
		/**
		 * New user login.
		 */
		private function onLogin(evt:ReaderServerEvent):void {
			this._data.setUser(evt.message);
			this.refreshList();
			this._syncBT.visible = true;
			this.redraw();
		}
		
		/**
		 * User logout.
		 */
		private function onLogout(evt:ReaderServerEvent):void {
			this._data.clearUser();
			this.refreshList();
			this._syncBT.visible = false;
			this.redraw();
		}
		
		/**
		 * Data sync information received.
		 */
		private function onSyncReceived(evt:ReaderServerEvent):void {
			if (this.visible) {
				this._data.saveSync(evt.message);
				this._waiting.visible = false;
				this._syncBT.visible = true;
				this.refreshList();
				this.redraw();
			}
		}
		
		/**
		 * Close window.
		 */
		private function onClose(evt:MouseEvent):void {
			this.dispatchEvent(new Event(Event.CLOSE));
			this.visible = false;
		}
		
		/**
		 * Sync notes/bookmarks with the server.
		 */
		private function onSync(evt:MouseEvent):void {
			// user logged?
			if (this._data.userid != "") {
				// prepare current data to send
				var toSend:String = "";
				var current:Array = this._data.getItems();
				for (var index:uint = 0; index < current.length; index++) {
					toSend += current[index].join("|it|") + "|br|";
				}
				toSend = toSend.substr(0, (toSend.length - 4));
				this._waiting.visible = true;
				this._syncBT.visible = false;
				this._reader.syncNotes(this._data.type, this._data.userid, toSend);
			}
		}
		
		/**
		 * Click on add button.
		 */
		private function onAdd(evt:MouseEvent):void {
			if (this._type == NoteAndMarkData.TYPE_NOTE) {
				this._data.addItem((this.managana.currentCommunityTitle + " » " + this.managana.currentStreamTitle), this._input.text, this.managana.currentStream, this.managana.currentCommunity);
				this._input.text = "";
				this.refreshList();
			} else {
				this._data.addItem((this.managana.currentCommunityTitle + " » " + this.managana.currentStreamTitle), "", this.managana.currentStream, this.managana.currentCommunity);
				this.refreshList();
			}
			// redraw items
			for (var index:uint = 0; index < this._list.numChildren; index++) {
				var item:NoteAndMarkItem = this._list.getChildAt(index) as NoteAndMarkItem;
				item.width = this._listMask.width;
				if (index > 0) item.y = this._list.getChildAt(index - 1).y + this._list.getChildAt(index - 1).height;
			}
		}
		
		/**
		 * Start list drag.
		 */
		private function onListDown(evt:MouseEvent):void {
			evt.stopPropagation();
			if (this._list.height > this._listMask.height) {
				this._list.startDrag(false, new Rectangle(20, (this._listMask.y - (this._list.height - this._listMask.height)), 0, (this._list.height - this._listMask.height)));
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
			this._list.y = this._listMask.y + ((this._listMask.height - this._list.height + this._listMask.y) * (this._scroller.position / 100));
		}
		
		/**
		 * Refresh results list.
		 */
		private function refreshList():void {
			// remove previous item graphics
			var item:NoteAndMarkItem;
			while (this._list.numChildren > 0) {
				item = this._list.getChildAt(0) as NoteAndMarkItem;
				this._list.removeChild(item);
				item.removeEventListener(Event.OPEN, onStreamOpen);
				item.removeEventListener(Event.CLEAR, onItemRemove);
				item.kill();
				item = null;
			}
			// add current items
			var items:Array = this._data.getItems();
			for (var index:uint = 0; index < items.length; index++) {
				item = new NoteAndMarkItem(items[index][0], items[index][1], items[index][2], items[index][3], items[index][4]);
				item.addEventListener(Event.OPEN, onStreamOpen);
				item.addEventListener(Event.CLEAR, onItemRemove);
				this._list.addChild(item);
				if (index > 0) item.y = this._list.getChildAt(index - 1).y + this._list.getChildAt(index - 1).height;
				if (index == (items.length - 1)) item.separatorVisible = false;
				delete (items[index]);
			}
			items = null;
			// scroller
			this._scroller.enabled = (this._list.height > this._listMask.height);
		}
		
		/**
		 * Remove a list item.
		 */
		private function onItemRemove(evt:Event):void {
			var item:NoteAndMarkItem = evt.target as NoteAndMarkItem;
			// remove on server?
			if (this._reader.logged) this._reader.removeNote(this._data.type, this._data.userid, item.id);
			// remove local
			this._data.deleteItem(item.id);
			this.refreshList();
			// redraw items
			for (var index:uint = 0; index < this._list.numChildren; index++) {
				item = this._list.getChildAt(index) as NoteAndMarkItem;
				item.width = this._listMask.width;
				if (index > 0) item.y = this._list.getChildAt(index - 1).y + this._list.getChildAt(index - 1).height;
			}
		}
		
		/**
		 * Click on open stream button.
		 */
		private function onStreamOpen(evt:Event):void {
			if (this.managana != null) {
				var item:NoteAndMarkItem = evt.target as NoteAndMarkItem;
				if (item.community == this.managana.currentCommunity) {
					if (item.stream != this.managana.currentStream) {
						this._lockRedraw = true;
						this.managana.loadStream(item.stream);
					}
				} else {
					this._lockRedraw = true;
					this.managana.startStream = item.stream;
					this.managana.loadCommunity(item.community);
				}
			}
		}
		
	}

}
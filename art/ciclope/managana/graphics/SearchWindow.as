package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import art.ciclope.managana.ManaganaPlayer;
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
	import art.ciclope.managana.ManaganaInterface;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * SearchWindow provides a graphic interface for searching content.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class SearchWindow extends Sprite {
		
		// VARIABLES
		
		private var _ready:Boolean;						// is window ready?
		private var _bg:InterfaceWindow;				// window background
		private var _input:InterfaceTextInput;			// search query input
		private var _searchBT:Sprite;					// search button
		private var _close:Sprite;						// close window button
		private var _all:InterfaceCheckButtonText;		// all communities?
		private var _waiting:WaitingGraphic;			// busy indicator
		private var _noresult:TextField;				// no results message
		
		private var _list:Sprite;						// holder for comment items
		private var _listMask:Sprite;					// a mask for the comment items
		private var _scroller:InterfaceScroller;		// item scroller
		private var _scinterval:int;					// scroller interval handler
		private var _results:Array;						// results information
		private var _lockRedraw:Boolean;				// avoid redraw?
		
		private var _refWidth:Number;
		private var _refHeight:Number;
		
		// PUBLIC VARIABLES
		
		/**
		 * A reference for the reader server.
		 */
		public var reader:ReaderServer;
		
		/**
		 * A reference for the Managana player.
		 */
		public var managana:ManaganaPlayer;
		
		/**
		 * CommentWindow constructor.
		 */
		public function SearchWindow(refWidth:Number, refHeight:Number) {
			this._ready = false;
			this._refWidth = refWidth;
			this._refHeight = refHeight;
			this.visible = false;
			this._results = new Array();
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
			this._searchBT = new ButtonSearch() as Sprite;
			ManaganaInterface.setSize(this._searchBT);
			this._searchBT.width = this._searchBT.height = this._input.height;
			this.addChild(this._searchBT);
			this._searchBT.buttonMode = true;
			this._searchBT.useHandCursor = true;
			this._searchBT.addEventListener(MouseEvent.CLICK, onSearch);
			this._all = new InterfaceCheckButtonText("search on all available communities");
			this._all.enabled = true;
			this.addChild(this._all);
			this._noresult = new TextField();
			this._noresult.defaultTextFormat = new TextFormat("_sans", ManaganaInterface.newSize(16), 0xFFFFFF, true, null, null, null, null, "center");
			this._noresult.text = "no results found";
			this._noresult.multiline = false;
			this._noresult.selectable = false;
			this._noresult.height = this._noresult.getLineMetrics(0).height + ManaganaInterface.newSize(5);
			this._noresult.visible = false;
			this.addChild(this._noresult);
			this._waiting = new WaitingGraphic();
			ManaganaInterface.setSize(this._waiting);
			this._waiting.visible = false;
			this.addChild(this._waiting);
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
			this._list.visible = this._listMask.visible = this._scroller.visible = false;
			this._ready = true;
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
			if (!this._lockRedraw) {
				this._bg.width = this._refWidth / 1.1;
				this._bg.height = this._refHeight / 1.6;
				this._close.x = this._bg.width - (this._close.width / 2);
				this._close.y = this._bg.y - (this._close.height / 2);
				this._searchBT.y = 20;
				this._searchBT.x = this._bg.width - 20 - this._searchBT.width;
				this._input.x = this._input.y = 20;
				this._input.width = this._bg.width - 60 - this._searchBT.width;
				this._all.x = 20;
				this._all.y = this._bg.height - 20 - this._all.height;
				this._all.width = this._bg.width - 40;
				this._waiting.x = (this._bg.width - this._waiting.width) / 2;
				this._waiting.y = (this._bg.height - this._waiting.height) / 2;
				this._noresult.width = this._bg.width - 40;
				this._noresult.x = 20;
				this._noresult.y = (this._bg.height - this._noresult.height) / 2;
				this._list.x = this._listMask.x = 20;
				this._scroller.x = this._bg.width - 20 - this._scroller.width;
				this._list.y = this._listMask.y = this._scroller.y = this._input.y + this._input.height + 20;
				this._listMask.width = this._bg.width - 20 - this._scroller.width - 25;
				if (this._all.visible) {
					this._listMask.height = this._scroller.height = this._bg.height - this._listMask.y - 40 - this._all.height;
				} else {
					this._listMask.height = this._scroller.height = this._bg.height - this._listMask.y - 20;
				}
				for (var index:uint = 0; index < this._list.numChildren; index++) {
					var item:StreamItem = this._list.getChildAt(index) as StreamItem;
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
		 * Set components state.
		 * @param	onall	allow search on all communities?
		 */
		public function setState(onall:Boolean):void {
			this._all.visible = onall;
			if (!onall) this._all.checked = false;
			this.redraw();
		}
		
		/**
		 * Set window text.
		 * @param	noresult	no results message
		 * @param	allComm	allow all communities button label
		 */
		public function setText(noresult:String, allComm:String):void {
			this._all.text = allComm;
			this._noresult.text = noresult;
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
				this.removeChild(this._searchBT);
				this._searchBT.removeEventListener(MouseEvent.CLICK, onSearch);
				this._searchBT = null;
				this.removeChild(this._input);
				this._input.kill();
				this._input = null;
				this.removeChild(this._all);
				this._all.kill();
				this._all = null;
				this.removeChild(this._waiting);
				this._waiting.kill();
				this._waiting = null;
				this.removeChild(this._noresult);
				this._noresult = null;
				this._list = null;
				this.removeChild(this._listMask);
				this._listMask.graphics.clear();
				this._listMask = null;
				this.removeChild(this._scroller);
				this._scroller.removeEventListener(Event.CHANGE, onScrollChange);
				this._scroller.kill();
				this._scroller = null;
			} else {
				this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			}
			this.reader = null;
			while (this._results.length > 0) {
				var result:Object = this._results[0];
				delete(result["title"]);
				delete(result["about"]);
				delete(result["streamID"]);
				delete(result["communityID"]);
				this._results.shift();
			}
			this._results = null;
			this.managana = null;
		}
		
		// PRIVATE METHODS
		
		/**
		 * Close window.
		 */
		private function onClose(evt:MouseEvent):void {
			this.dispatchEvent(new Event(Event.CLOSE));
			this.visible = false;
		}
		
		/**
		 * Click on search button.
		 */
		private function onSearch(evt:MouseEvent):void {
			if (this._input.text != "") {
				var all:String = "false";
				if (this._all.checked) all = "true";
				if (this.reader != null) {
					this._waiting.visible = true;
					this._noresult.visible = false;
					this._list.visible = this._listMask.visible = this._scroller.visible = false;
					this.clearResults();
					this.reader.doSearch(this._input.text, all);
					this.reader.addEventListener(ReaderServerEvent.SEARCHRESULTS, onResults);
					this.reader.addEventListener(ReaderServerEvent.READER_ERROR, onError);
				}
			}
		}
		
		/**
		 * Search results received.
		 */
		private function onResults(evt:ReaderServerEvent):void {
			this._waiting.visible = false;
			if (evt.message == "0") {
				this._noresult.visible = true;
			} else {
				var results:String = '<data>' + evt.message.replace('<title>', '<title><![CDATA[') + '</data>';
				results = results.replace('</title>', ']]></title>');
				results = results.replace('<about>', '<about><![CDATA[');
				results = results.replace('</about>', ']]></about>');
				try {
					var resultsXML:XML = new XML(results);
					for (var index:uint = 0; index < resultsXML.child("result").length(); index++) {
						this.addResult(String(resultsXML.result[index].title), String(resultsXML.result[index].about), String(resultsXML.result[index].stream), String(resultsXML.result[index].community));
					}
					this.refreshList()
					this._list.visible = this._listMask.visible = this._scroller.visible = true;
					this._list.y = this._input.y + this._input.height + 20;
					System.disposeXML(resultsXML);
				} catch (e:Error) {
					this._noresult.visible = true;
					this._list.visible = this._listMask.visible = this._scroller.visible = false;
				}
			}
			if (this.reader != null) {
				this.reader.removeEventListener(ReaderServerEvent.SEARCHRESULTS, onResults);
				this.reader.removeEventListener(ReaderServerEvent.READER_ERROR, onError);
			}
		}
		
		/**
		 * Error while searching.
		 */
		private function onError(evt:ReaderServerEvent):void {
			this._waiting.visible = false;
			this._noresult.visible = false;
			this._list.visible = this._listMask.visible = this._scroller.visible = false;
			if (this.reader != null) {
				this.reader.removeEventListener(ReaderServerEvent.SEARCHRESULTS, onResults);
				this.reader.removeEventListener(ReaderServerEvent.READER_ERROR, onError);
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
		 * Add a result on the list.
		 * @param	title	item title
		 * @param	about	item about
		 * @param	streamID	the stream ID
		 * @param	communityID	the community ID
		 */
		private function addResult(title:String, about:String, streamID:String, communityID:String):void {
			var result:Array = new Array();
			result["title"] = title;
			result["about"] = about;
			result["streamID"] = streamID;
			result["communityID"] = communityID;
			this._results.push(result);
		}
		
		/**
		 * Remove all results information.
		 */
		private function clearResults():void {
			while (this._results.length > 0) {
				var result:Object = this._results[0];
				delete(result["title"]);
				delete(result["about"]);
				delete(result["streamID"]);
				delete(result["communityID"]);
				this._results.shift();
			}
			this._scroller.enabled = false;
			this._list.visible = this._listMask.visible = this._scroller.visible = false;
		}
		
		/**
		 * Refresh results list.
		 */
		private function refreshList():void {
			// remove previous item graphics
			var item:StreamItem;
			while (this._list.numChildren > 0) {
				item = this._list.getChildAt(0) as StreamItem;
				this._list.removeChild(item);
				item.removeEventListener(Event.OPEN, onStreamOpen);
				item.kill();
				item = null;
			}
			// add current items
			for (var index:uint = 0; index < this._results.length; index++) {
				item = new StreamItem(this._results[index]["title"], this._results[index]["about"], this._results[index]["streamID"], this._results[index]["communityID"], this._listMask.width);
				item.addEventListener(Event.OPEN, onStreamOpen);
				this._list.addChild(item);
				if (index > 0) item.y = this._list.getChildAt(index - 1).y + this._list.getChildAt(index - 1).height;
				if (index == (this._results.length - 1)) item.separatorVisible = false;
			}
			// scroller
			this._scroller.enabled = (this._list.height > this._listMask.height);
		}
		
		/**
		 * Click on open stream button.
		 */
		private function onStreamOpen(evt:Event):void {
			if (this.managana != null) {
				var item:StreamItem = evt.target as StreamItem;
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
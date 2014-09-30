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
	import flash.text.TextFieldAutoSize;
	import flash.geom.Point;
	
	// CICLOPE CLASSES
	import art.ciclope.event.ReaderServerEvent;
	import art.ciclope.managana.data.ReaderServer;
	import art.ciclope.managana.ManaganaPlayer;
	import art.ciclope.managana.data.OfflineCommunities;
	import art.ciclope.event.CommunityContentEvent;
	import art.ciclope.managana.ManaganaInterface;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * OfflineWindow provides a graphic interface for offline content management.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class OfflineWindow extends Sprite {
		
		// VARIABLES
		
		private var _ready:Boolean;						// is window ready?
		private var _bg:InterfaceWindow;				// window background
		private var _close:Sprite;						// close window button
		private var _title:TextField;					// window title
		
		private var _offline:OfflineCommunities;		// offline content reference
		
		private var _reader:ReaderServer;				// a reference for the reader server
		private var _syncBT:Sprite;						// sync button
		private var _waiting:WaitingGraphic;			// waiting graphic for sync operation
		
		private var _listLayer:Sprite;					// graphic layer for listings
		private var _list:Sprite;						// holder for comment items
		private var _listMask:Sprite;					// a mask for the comment items
		private var _scroller:InterfaceScroller;		// item scroller
		private var _scinterval:int;					// scroller interval handler
		private var _offText:String;					// text for offline available mark on list
		
		private var _infoLayer:Sprite;					// graphic layer for community information
		private var _infoMsg:TextField;					// information message
		private var _downBT:InterfaceButton;			// button for content download
		private var _retBT:InterfaceButton;				// button for return to list
		private var _infoWaitText:String;				// text for waiting message
		private var _infoFinishText:String;				// text for content info ready
		private var _infoSizeText:String;				// text for content size message
		private var _infoErrorText:String;				// text for content info error
		private var _infoWifiText:String;				// text for wifi warning
		private var _infoDErrorText:String;				// text for dowload start error
		
		private var _downLayer:Sprite;					// graphic layer for download progress information
		private var _downMsg:TextField;					// download message
		private var _closeBT:InterfaceButton;			// close window button
		private var _cancelBT:InterfaceButton;			// cancel download button
		private var _progress:Sprite;					// a progress bar for download
		
		private var _updLayer:Sprite;					// graphic layer for update/delete communities
		private var _updMsg:TextField;					// update/delete information message
		private var _updBT:InterfaceButton;				// button for content update
		private var _updretBT:InterfaceButton;			// button for return to list
		private var _upddelBT:InterfaceButton;			// button for content delete
		private var _updAbout:String;					// text for update/delete about
		private var _updCom:String;						// community id to update
		private var _updTitle:String;					// community title to update
		
		private var _refWidth:Number;
		private var _refHeight:Number;
		
		// PUBLIC VARIABLES
		
		/**
		 * A reference for the Managana player.
		 */
		public var managana:ManaganaPlayer;
		
		/**
		 * Allow community information fetch?
		 */
		public var allowInfo:Boolean;
		
		
		/**
		 * CommentWindow constructor.
		 */
		public function OfflineWindow(refWidth:Number, refHeight:Number) {
			this._ready = false;
			this._refWidth = refWidth;
			this._refHeight = refHeight;
			this.visible = false;
			this.allowInfo = true;
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
			this._close = new CloseWindow() as Sprite;
			ManaganaInterface.setSize(this._close);
			this._close.buttonMode = true;
			this._close.useHandCursor = true;
			this._close.addEventListener(MouseEvent.CLICK, onClose);
			this.addChild(this._close);
			this._title = new TextField();
			this._title.defaultTextFormat = new TextFormat("_sans", ManaganaInterface.newSize(16), 0xFFFFFF, true);
			this._title.text = "Content management";
			this._title.multiline = false;
			this._title.selectable = false;
			this._title.height = this._title.getLineMetrics(0).height + ManaganaInterface.newSize(5);
			this.addChild(this._title);
			
			this._listLayer = new Sprite();
			this.addChild(this._listLayer);
				this._list = new Sprite();
				this._listLayer.addChild(this._list);
				this._listMask = new Sprite();
				this._listMask.graphics.beginFill(0);
				this._listMask.graphics.drawRect(0, 0, 100, 100);
				this._listMask.graphics.endFill();
				this._listLayer.addChild(this._listMask);
				this._list.mask = this._listMask;
				this._list.addEventListener(MouseEvent.MOUSE_DOWN, onListDown);
				this.stage.addEventListener(MouseEvent.MOUSE_UP, onListUp);
				this._scroller = new InterfaceScroller();
				this._scroller.addEventListener(Event.CHANGE, onScrollChange);
				this._listLayer.addChild(this._scroller);
				this._list.visible = this._listMask.visible = this._scroller.visible = true;
				this._offText = "[offline]";
				
			this._infoLayer = new Sprite();
				this._infoMsg = new TextField();
				this._infoMsg.multiline = true;
				this._infoMsg.selectable = false;
				this._infoMsg.wordWrap = true;
				this._infoMsg.autoSize = TextFieldAutoSize.CENTER;
				this._infoMsg.defaultTextFormat = new TextFormat("_sans", ManaganaInterface.newSize(16), 0xFFFFFF, true, null, null, null, null, "center");
				this._infoWaitText = "Getting content information. Please wait...";
				this._waiting = new WaitingGraphic();
				ManaganaInterface.setSize(this._waiting);
				this._waiting.visible = false;
				this._downBT = new InterfaceButton();
				this._downBT.text = "download content for offline access";
				this._downBT.addEventListener(MouseEvent.CLICK, onDownBT);
				this._retBT = new InterfaceButton();
				this._retBT.text = "return to list";
				this._retBT.addEventListener(MouseEvent.CLICK, onRetBT);
				this._infoLayer.addChild(this._infoMsg);
				this._infoLayer.addChild(this._waiting);
				this._infoLayer.addChild(this._downBT);
				this._infoLayer.addChild(this._retBT);
				this._infoFinishText = "content information for";
				this._infoSizeText = "expected download size";
				this._infoErrorText = "Sorry, the information about the selected content is not available.";
				this._infoWifiText = "Before start downloding, please check your web connection. Wi-fi is always preferred since the content size may lead to mobile connection plans charges.";
				this._infoDErrorText = "Error found while downloading the requested content. Please try again.";
			
			this._downLayer = new Sprite();
				this._downMsg = new TextField();
				this._downMsg.multiline = true;
				this._downMsg.selectable = false;
				this._downMsg.wordWrap = true;
				this._downMsg.autoSize = TextFieldAutoSize.CENTER;
				this._downMsg.defaultTextFormat = new TextFormat("_sans", ManaganaInterface.newSize(16), 0xFFFFFF, true, null, null, null, null, "center");
				this._downMsg.text = "Downloading content. Please wait... You may safely close this window and keep using Managana. Your download will continue in background. If you exit Managana the download will be paused and resumed when the application is restarted.";
				this._closeBT = new InterfaceButton();
				this._closeBT.text = "close this download window";
				this._closeBT.addEventListener(MouseEvent.CLICK, onClose);
				this._cancelBT = new InterfaceButton();
				this._cancelBT.text = "cancel the download";
				this._cancelBT.addEventListener(MouseEvent.CLICK, onCancelBT);
				this._progress = new ProgressBarGraphic() as Sprite;
				this._downLayer.addChild(this._downMsg);
				this._downLayer.addChild(this._closeBT);
				this._downLayer.addChild(this._cancelBT);
				this._downLayer.addChild(this._progress);
				
			this._updLayer = new Sprite();
				this._updMsg = new TextField();
				this._updMsg.multiline = true;
				this._updMsg.selectable = false;
				this._updMsg.wordWrap = true;
				this._updMsg.autoSize = TextFieldAutoSize.CENTER;
				this._updMsg.defaultTextFormat = new TextFormat("_sans", ManaganaInterface.newSize(16), 0xFFFFFF, true, null, null, null, null, "center");
				this._updAbout = "You can check updates for this content and also remove it from you offline collection. If you delete it, you'll need to download the entire content again to access it offline.";
				this._updBT = new InterfaceButton();
				this._updBT.text = "check for content updates";
				this._updBT.addEventListener(MouseEvent.CLICK, onUpdBT);
				this._upddelBT = new InterfaceButton();
				this._upddelBT.text = "delete content";
				this._upddelBT.addEventListener(MouseEvent.CLICK, onDelBT);
				this._updretBT = new InterfaceButton();
				this._updretBT.text = "return to list";
				this._updretBT.addEventListener(MouseEvent.CLICK, onRetBT);
				this._updLayer.addChild(this._updMsg);
				this._updLayer.addChild(this._upddelBT);
				this._updLayer.addChild(this._updBT);
				this._updLayer.addChild(this._updretBT);
			
			this._ready = true;
			this.redraw();
		}
		
		// PROPERTIES
		
		/**
		 * A reference to the system reader server object.
		 */
		public function get reader():ReaderServer {
			return (this._reader);
		}
		public function set reader(to:ReaderServer):void {
			this._reader = to;
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
			this._bg.width = this._refWidth / 1.2;
			this._bg.height = this._refHeight / 1.6;
			this._close.x = this._bg.width - (this._close.width / 2);
			this._close.y = this._bg.y - (this._close.height / 2);
			this._title.x = 20;
			this._title.y = 10;
			this._title.width = this._bg.width - 40;
			this._title.height = this._title.getLineMetrics(0).height;
			this._list.x = this._listMask.x = 20;
			this._scroller.x = this._bg.width - 20 - this._scroller.width;
			this._list.y = this._listMask.y = this._scroller.y = this._title.y + this._title.height + 5;
			this._listMask.width = this._bg.width - 20 - this._scroller.width - 25;
			this._listMask.height = this._scroller.height = this._bg.height - this._listMask.y - 20;
			for (var index:uint = 0; index < this._list.numChildren; index++) {
				var item:CommunityContentItem = this._list.getChildAt(index) as CommunityContentItem;
				item.width = this._listMask.width;
				if (index > 0) item.y = this._list.getChildAt(index - 1).y + this._list.getChildAt(index - 1).height;
			}
			this._scroller.enabled = (this._list.height > this._listMask.height);
			
			this._waiting.x = this._bg.width / 2;
			this._waiting.y = this._bg.height - this._waiting.height;
			
			this._retBT.x = 20;
			this._retBT.y = this._bg.height - this._retBT.height - 15;
			this._retBT.width = this._bg.width - 40;
			this._downBT.x = 20;
			this._downBT.y = this._retBT.y - this._downBT.height - 10;
			this._downBT.width = this._bg.width - 40;
			this._infoMsg.width = this._bg.width - 40;
			this._infoMsg.x = 20;
			this._infoMsg.y = (this._title.y + this._title.height) + (((this._downBT.y - (this._title.y + this._title.height)) - this._infoMsg.height) / 2);
			
			this._closeBT.x = 20;
			this._closeBT.y = this._bg.height - this._closeBT.height - 15;
			this._closeBT.width = this._bg.width - 40;
			this._cancelBT.x = 20;
			this._cancelBT.y = this._closeBT.y - this._cancelBT.height - 10;
			this._cancelBT.width = this._bg.width - 40;
			this._progress.y = this._cancelBT.y - this._progress.height - 10;
			this._progress.x = 20;
			this._downMsg.x = 20;
			this._downMsg.width = this._bg.width - 40;
			this._downMsg.y = (this._title.y + this._title.height) + (((this._progress.y - (this._title.y + this._title.height)) - this._downMsg.height) / 2);
			this.setDownProgress();
			
			this._updretBT.x = 20;
			this._updretBT.y = this._bg.height - this._updretBT.height - 15;
			this._updretBT.width = this._bg.width - 40;
			this._updBT.x = 20;
			this._updBT.y = this._updretBT.y - this._updBT.height - 10;
			this._updBT.width = this._bg.width - 40;
			this._upddelBT.x = 20;
			this._upddelBT.y = this._updBT.y - this._upddelBT.height - 10;;
			this._upddelBT.width = this._bg.width - 40;
			this._updMsg.width = this._bg.width - 40;
			this._updMsg.x = 20;
			this._updMsg.y = (this._title.y + this._title.height) + (((this._upddelBT.y - (this._title.y + this._title.height)) - this._updMsg.height) / 2);
			
			this.x = (this._refWidth - this._bg.width) / 2;
			this.y = ManaganaInterface.windowTop(this._close);
		}
		
		/**
		 * Set the download progress bar size.
		 */
		public function setDownProgress():void {
			if (this._offline != null) this._progress.width = (this._bg.width - 40) * (this._offline.amountDownloaded / 100);
		}
		
		/**
		 * Set window text.
		 * @param	title
		 * @param	gettinginfo
		 * @param	mark
		 * @param	downbt
		 * @param	retbt
		 * @param	infofor
		 * @param	size
		 * @param	infoerror
		 * @param	wifi
		 * @param	downerror
		 * @param	downmsg
		 * @param	downclose
		 * @param	downcancel
		 * @param	updabout
		 * @param	updbt
		 * @param	upddel
		 */
		public function setText(title:String, gettinginfo:String, mark:String, downbt:String, retbt:String, infofor:String, size:String, infoerror:String, wifi:String, downerror:String, downmsg:String, downclose:String, downcancel:String, updabout:String, updbt:String, upddel:String):void {
			this._title.text = title;
			this._infoWaitText = gettinginfo;
			this._offText = mark;
			this._downBT.text = downbt;
			this._retBT.text = retbt;
			this._infoFinishText = infofor;
			this._infoSizeText = size;
			this._infoErrorText = infoerror;
			this._infoWifiText = wifi;
			this._infoDErrorText = downerror;
			this._downMsg.text = downmsg;
			this._closeBT.text = downclose;
			this._cancelBT.text = downcancel;
			this._updAbout = updabout;
			this._updBT.text = updbt;
			this._upddelBT.text = upddel;
			this._updretBT.text = retbt;
		}
		
		/**
		 * Set the offline contente reference.
		 * @param	off	the system offline content manager
		 */
		public function setOffline(off:OfflineCommunities):void {
			this._offline = off;
			this._offline.addEventListener(CommunityContentEvent.LIST_AVAILABLE, onListAvailable);
			this._offline.addEventListener(CommunityContentEvent.INFO_READY, onInfoReady);
			this._offline.addEventListener(CommunityContentEvent.INFO_ERROR, onInfoError);
			this._offline.addEventListener(CommunityContentEvent.DOWNLOAD_ITEM, onDownloadItem);
			this._offline.addEventListener(CommunityContentEvent.DOWNLOAD_ALL, onDownloadAll);
			this._offline.addEventListener(CommunityContentEvent.DOWNLOAD_START, onDownloadStart);
			this._offline.addEventListener(CommunityContentEvent.DOWNLOAD_STOP, onDownloadStop);
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			if (this._ready) {
				this.removeChildren();
				this._listLayer.removeChildren();
				this._bg.kill();
				this._bg = null;
				this._close.removeEventListener(MouseEvent.CLICK, onClose);
				this._close = null;
				this._list = null;
				this._listMask.graphics.clear();
				this._listMask = null;
				this._scroller.removeEventListener(Event.CHANGE, onScrollChange);
				this._scroller.kill();
				this._scroller = null;
				this._listLayer = null;
				this._downLayer.removeChildren();
				this._downLayer = null;
				this._downMsg = null;
				this._closeBT.removeEventListener(MouseEvent.CLICK, onClose);
				this._cancelBT.removeEventListener(MouseEvent.CLICK, onCancelBT);
				this._closeBT.kill();
				this._closeBT = null;
				this._cancelBT.kill();
				this._cancelBT = null;
				this._progress = null;
				this._infoLayer.removeChildren();
				this._infoLayer = null;
				this._downBT.removeEventListener(MouseEvent.CLICK, onDownBT);
				this._retBT.removeEventListener(MouseEvent.CLICK, onRetBT);
				this._downBT.kill();
				this._downBT = null;
				this._retBT.kill();
				this._retBT = null;
				this._infoMsg = null;
				this._offText = null;
				this._waiting.kill();
				this._waiting = null;
				this._title = null;
				this._infoDErrorText = null;
				this._infoErrorText = null;
				this._infoFinishText = null;
				this._infoSizeText = null;
				this._infoWaitText = null;
				this._infoWifiText = null;
				this._updLayer.removeChildren();
				this._updLayer = null;
				this._updBT.removeEventListener(MouseEvent.CLICK, onUpdBT);
				this._upddelBT.kill();
				this._upddelBT = null;
				this._upddelBT.removeEventListener(MouseEvent.CLICK, onDelBT);
				this._updretBT.kill();
				this._updretBT = null;
				this._updretBT.removeEventListener(MouseEvent.CLICK, onRetBT);
				this._updretBT.kill();
				this._updretBT = null;
				this._updMsg = null;
				this._updTitle = null;
				this._updCom = null;
			} else {
				this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			}
			if (this._reader != null) {
				
			}
			this._reader = null;
			this.managana = null;
			if (this._offline != null) {
				this._offline.removeEventListener(CommunityContentEvent.LIST_AVAILABLE, onListAvailable);
				this._offline.removeEventListener(CommunityContentEvent.INFO_READY, onInfoReady);
				this._offline.removeEventListener(CommunityContentEvent.INFO_ERROR, onInfoError);
				this._offline.removeEventListener(CommunityContentEvent.DOWNLOAD_ITEM, onDownloadItem);
				this._offline.removeEventListener(CommunityContentEvent.DOWNLOAD_ALL, onDownloadAll);
				this._offline.removeEventListener(CommunityContentEvent.DOWNLOAD_START, onDownloadStart);
				this._offline.removeEventListener(CommunityContentEvent.DOWNLOAD_STOP, onDownloadStop);
				this._offline = null;
			}
		}
		
		// PRIVATE METHODS
	
		/**
		 * A new file was downloaded.
		 */
		private function onDownloadItem(evt:CommunityContentEvent):void {
			this.setDownProgress();
		}
		
		/**
		 * Community download finished.
		 */
		private function onDownloadAll(evt:CommunityContentEvent):void {
			try { this.removeChild(this._infoLayer); } catch (e:Error) { }
			try { this.removeChild(this._downLayer); } catch (e:Error) { }
			try { this.removeChild(this._updLayer); } catch (e:Error) { }
			this.addChild(this._listLayer);
			this.showList();
		}
		
		/**
		 * A download was stopped.
		 */
		private function onDownloadStop(evt:CommunityContentEvent):void {
			try { this.removeChild(this._infoLayer); } catch (e:Error) { }
			try { this.removeChild(this._downLayer); } catch (e:Error) { }
			try { this.removeChild(this._updLayer); } catch (e:Error) { }
			this.addChild(this._listLayer);
			this.showList();
		}
		
		/**
		 * The online and offline content list is available.
		 */
		private function onListAvailable(evt:CommunityContentEvent):void {
			this.showList();
		}
		
		/**
		 * Community information error.
		 */
		private function onInfoError(evt:CommunityContentEvent):void {
			this._waiting.visible = false;
			this._retBT.visible = true;
			this._infoMsg.text = this._infoErrorText;
			this._infoMsg.y = (this._title.y + this._title.height) + (((this._downBT.y - (this._title.y + this._title.height)) - this._infoMsg.height) / 2);
		}
		
		/**
		 * Community information received.
		 */
		private function onInfoReady(evt:CommunityContentEvent):void {
			this._waiting.visible = false;
			this._retBT.visible = true;
			this._downBT.visible = true;
			this._infoMsg.text = this._infoFinishText + " " + this._offline.currentTitle + "\n\n" + this._infoSizeText + ": " + this._offline.downloadSize + "MB" + "\n\n" + this._infoWifiText;
			this._infoMsg.y = (this._title.y + this._title.height) + (((this._downBT.y - (this._title.y + this._title.height)) - this._infoMsg.height) / 2);
		}
		
		/**
		 * Show the communities list.
		 */
		public function showList():void {
			// remove previous item graphics
			var item:CommunityContentItem;
			var index:uint;
			while (this._list.numChildren > 0) {
				item = this._list.getChildAt(0) as CommunityContentItem;
				this._list.removeChild(item);
				item.kill();
				item = null;
			}
			// add items
			for (index = 0; index < this._offline.list.child("community").length(); index++) {
				item = new CommunityContentItem(String(this._offline.list.community[index].id), String(this._offline.list.community[index].update), String(this._offline.list.community[index].state), String(this._offline.list.community[index].title), this._offText, this._listMask.width);
				item.addEventListener(Event.OPEN, onCommunityOpen);
				item.addEventListener(CommunityContentEvent.GET_INFO, onGetInfo);
				this._list.addChild(item);
			}
			// list items position
			for (index = 0; index < this._list.numChildren; index++) {
				item = this._list.getChildAt(index) as CommunityContentItem;
				item.width = this._listMask.width;
				item.y = 0;
				item.separatorVisible = true;
				if (index > 0) item.y = this._list.getChildAt(index - 1).y + this._list.getChildAt(index - 1).height;
				if (index == (this._list.numChildren - 1)) item.separatorVisible = false;
			}
			// scroller
			this._scroller.enabled = (this._list.height > this._listMask.height);
		}
		
		/**
		 * Close window.
		 */
		private function onClose(evt:MouseEvent):void {
			this.dispatchEvent(new Event(Event.CLOSE));
			this.visible = false;
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
		 * Click on open community button.
		 */
		private function onCommunityOpen(evt:Event):void {
			if (this.managana != null) {
				var item:CommunityContentItem = evt.target as CommunityContentItem;
				this.managana.loadCommunity(item.id);
			}
		}
		
		/**
		 * Get community information.
		 */
		private function onGetInfo(evt:CommunityContentEvent):void {
			if (this.allowInfo) {
				var message:Array = evt.message.split("|it|");
				if (message[2] == "online") {
					try { this.removeChild(this._listLayer); } catch (e:Error) { }
					try { this.removeChild(this._downLayer); } catch (e:Error) { }
					try { this.removeChild(this._updLayer); } catch (e:Error) { }
					this.addChild(this._infoLayer);
					this._waiting.visible = true;
					this._downBT.visible = false;
					this._retBT.visible = false;
					this._infoMsg.text = this._infoWaitText;
					this._infoMsg.y = (this._title.y + this._title.height) + (((this._downBT.y - (this._title.y + this._title.height)) - this._infoMsg.height) / 2);
					this._offline.getCommunityInfo(message[0], message[1]);
				} else {
					try { this.removeChild(this._listLayer); } catch (e:Error) { }
					try { this.removeChild(this._downLayer); } catch (e:Error) { }
					try { this.removeChild(this._infoLayer); } catch (e:Error) { }
					this._updCom = message[0];
					this._updTitle = message[1];
					this._updMsg.text = this._updTitle + "\n\n" + this._updAbout;
					this._updMsg.y = (this._title.y + this._title.height) + (((this._upddelBT.y - (this._title.y + this._title.height)) - this._updMsg.height) / 2);
					this.addChild(this._updLayer);
				}
			}
		}
		
		/**
		 * Delete a community.
		 */
		private function onDelBT(evt:MouseEvent):void {
			this._offline.delCommunity(this._updCom);
			try { this.removeChild(this._infoLayer); } catch (e:Error) { }
			try { this.removeChild(this._downLayer); } catch (e:Error) { }
			try { this.removeChild(this._updLayer); } catch (e:Error) { }
			this.addChild(this._listLayer);
			this.showList();
		}
		
		/**
		 * Get community update information.
		 */
		private function onUpdBT(evt:MouseEvent):void {
			try { this.removeChild(this._listLayer); } catch (e:Error) { }
			try { this.removeChild(this._downLayer); } catch (e:Error) { }
			try { this.removeChild(this._updLayer); } catch (e:Error) { }
			this.addChild(this._infoLayer);
			this._waiting.visible = true;
			this._downBT.visible = false;
			this._retBT.visible = false;
			this._infoMsg.text = this._infoWaitText;
			this._infoMsg.y = (this._title.y + this._title.height) + (((this._downBT.y - (this._title.y + this._title.height)) - this._infoMsg.height) / 2);
			this._offline.getCommunityInfo(this._updCom, this._updTitle);
		}
		
		/**
		 * Click on return button.
		 */
		private function onRetBT(evt:MouseEvent):void {
			try { this.removeChild(this._infoLayer); } catch (e:Error) { }
			try { this.removeChild(this._downLayer); } catch (e:Error) { }
			try { this.removeChild(this._updLayer); } catch (e:Error) { }
			this.addChild(this._listLayer);
			this.showList();
		}
		
		/**
		 * Click on download button.
		 */
		private function onDownBT(evt:MouseEvent):void {
			if (this._offline.startDownload()) {
				try { this.removeChild(this._infoLayer); } catch (e:Error) { }
				try { this.removeChild(this._listLayer); } catch (e:Error) { }
				try { this.removeChild(this._updLayer); } catch (e:Error) { }
				this.addChild(this._downLayer);
				this._offline.startDownload();
			} else {
				this._infoMsg.text = this._infoDErrorText;
				this._infoMsg.y = (this._title.y + this._title.height) + (((this._downBT.y - (this._title.y + this._title.height)) - this._infoMsg.height) / 2);
				this._downBT.visible = false;
			}
		}
		
		/**
		 * An automatic community download started.
		 */
		private function onDownloadStart(evt:CommunityContentEvent):void {
			try { this.removeChild(this._infoLayer); } catch (e:Error) { }
			try { this.removeChild(this._listLayer); } catch (e:Error) { }
			try { this.removeChild(this._updLayer); } catch (e:Error) { }
			this.addChild(this._downLayer);
		}
		
		/**
		 * Click on cancel button.
		 */
		private function onCancelBT(evt:MouseEvent):void {
			this._offline.stopDownload();
		}
		
	}

}
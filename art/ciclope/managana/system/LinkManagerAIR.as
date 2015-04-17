package art.ciclope.managana.system {
	
	// FLASH PACKAGES
	import art.ciclope.event.Message;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	
	// CICLOPE CLASSES
	import art.ciclope.managana.graphics.CloseButton;
	import art.ciclope.managana.graphics.BackButton;
	import art.ciclope.managana.graphics.NextButton;
	import art.ciclope.managana.ManaganaInterface;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * LinkManagerAIR extends LinkManager enable external link open on AIR-based playback. It creates an overlay with a simple StageWebview-based browser.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class LinkManagerAIR extends LinkManager {
		
		// VARIABLES
		
		private var _ready:Boolean;			// component ready?
		private var _bg:Shape;				// the background
		private var _white:Shape;			// white background for address
		private var _color:uint;			// background color
		private var _view:StageWebView;		// browser
		private var _close:Sprite;			// close button
		private var _back:Sprite;			// back button
		private var _next:Sprite;			// next button
		private var _addr:TextField;		// url address
		private var _timer:Timer;			// interface feedback timer
		private var _authenticate:Boolean;	// opening link for OpenID/oAuth authentication?
		
		private var _comWidth:uint;			// current community design width
		private var _comHeight:uint;		// current community design height
		
		private var _refWidth:Number = -1;
		private var _refHeight:Number = -1;
		
		/**
		 * LinkManagerAIR constructor.
		 */
		public function LinkManagerAIR(refSize:Point = null) {
			// reference size
			if (refSize != null) {
				this._refWidth = refSize.x;
				this._refHeight = refSize.y;
			}
			// wait for stage
			this._ready = false;
			this._color = 0;
			this.visible = false;
			this._authenticate = false;
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		public function setComSize(w:uint, h:uint):void {
			this._comWidth = w;
			this._comHeight = h;
		}
		
		public function setRefSize(refSize:Point):void {
			this._refWidth = refSize.x;
			this._refHeight = refSize.y;
		}
		
		/**
		 * The stage is available.
		 */
		private function onStage(evt:Event):void {
			if (this._refWidth <= 0) {
				this._refWidth = this.stage.stageWidth;
				this._refHeight = this.stage.stageHeight;
			}
			this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			this.stage.addEventListener(Event.RESIZE, onResize);
			this._ready = true;
			this._bg = new Shape();
			this.addChild(this._bg);
			this.setBGColor(this._color);
			this._close = new CloseButton() as Sprite;
			ManaganaInterface.setSize(this._close);
			this._close.buttonMode = true;
			this._close.useHandCursor = true;
			this._close.addEventListener(MouseEvent.CLICK, onClose);
			this.addChild(this._close);
			this._back = new BackButton() as Sprite;
			ManaganaInterface.setSize(this._back);
			this._back.buttonMode = true;
			this._back.useHandCursor = true;
			this._back.addEventListener(MouseEvent.CLICK, onBack);
			this.addChild(this._back);
			this._next = new NextButton() as Sprite;
			ManaganaInterface.setSize(this._next);
			this._next.buttonMode = true;
			this._next.useHandCursor = true;
			this._next.addEventListener(MouseEvent.CLICK, onNext);
			this.addChild(this._next);
			this._white = new Shape();
			this._white.graphics.beginFill(0xFFFFFF);
			this._white.graphics.drawRect(0, 0, 100, 100);
			this._white.graphics.endFill();
			this.addChild(this._white);
			this._addr = new TextField();
			this._addr.defaultTextFormat = new TextFormat("_sans", ManaganaInterface.newSize(16), 0x000000);
			this._addr.multiline = false;
			this._addr.wordWrap = false;
			this._addr.selectable = true;
			this._addr.needsSoftKeyboard = true;
			this._addr.backgroundColor = 0xFFFFFF;
			this._addr.type = TextFieldType.INPUT;
			this.addChild(this._addr);
			this._view = new StageWebView();
			this._view.addEventListener(ErrorEvent.ERROR, onViewError);
			this.onResize();
			// feedback timer
			this._timer = new Timer(1000);
			this._timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		// PROPERTIES
		
		/**
		 * Component visibility.
		 */
		override public function get visible():Boolean {
			return super.visible;
		}
		override public function set visible(value:Boolean):void {
			super.visible = value;
			if (this._ready) {
				if (value) {
					this._view.stage = this.stage;
					this.onResize();
					this._timer.start();
				} else {
					this._view.stage = null;
					this._view.loadString("");
					this._timer.stop();
				}
			}
		}
		
		// PUBLIC METHODS
		
		/**
		 * Set background color.
		 * @param	to	the new color
		 */
		public function setBGColor(to:uint):void {
			this._color = to;
			if (this._ready) {
				this._bg.scaleX = this._bg.scaleY = 1;
				this._bg.graphics.clear();
				this._bg.graphics.beginFill(to);
				this._bg.graphics.drawRect(0, 0, 100, 100);
				this._bg.graphics.endFill();
				this._bg.width = this._refWidth;
				this._bg.height = this._refHeight;
			}
		}
		
		/**
		 * Open a url.
		 * @param	url	the url to open
		 */
		override public function openURL(url:String, target:String = '_blank'):void {
			this._authenticate = false;
			this._view.loadURL(url);
			this._addr.text = url;
			this.visible = true;
		}
		
		/**
		 * Open a url for OpenID/oAuth authentication.
		 * @param	url	the authentication url
		 * @param	community	the current community
		 * @param	stream	the current stream
		 * @param	caller	the caller app
		 * @param	key	current public presentation key
		 */
		override public function authenticate(url:String, community:String = "", stream:String = "", caller:String = "", key:String = ""):void {
			this._authenticate = true;
			if (caller != "") {
				this._view.loadURL(url + "?from=" + escape(caller) + "&pkey=" + escape(key));
			} else {
				this._view.loadURL(url);
			}
			this._addr.text = url;
			this.visible = true;
		}
		
		/**
		 * Release memory used by the object.
		 */
		override public function kill():void {
			this.removeChild(this._bg);
			this._bg.graphics.clear();
			this._bg = null;
			this.removeChild(this._white);
			this._white.graphics.clear();
			this._white = null;
			this._view.stage = null;
			if (this._view.hasEventListener(ErrorEvent.ERROR)) this._view.removeEventListener(ErrorEvent.ERROR, onViewError);
			this._view.dispose();
			this._view = null;
			this.removeChild(this._close);
			this._close.removeChildren();
			if (this._close.hasEventListener(MouseEvent.CLICK)) this._close.removeEventListener(MouseEvent.CLICK, onClose);
			this._close = null;
			this.removeChild(this._back);
			this._back.removeChildren();
			if (this._back.hasEventListener(MouseEvent.CLICK)) this._back.removeEventListener(MouseEvent.CLICK, onBack);
			this._back = null;
			this.removeChild(this._next);
			this._next.removeChildren();
			if (this._next.hasEventListener(MouseEvent.CLICK)) this._next.removeEventListener(MouseEvent.CLICK, onNext);
			this._next = null;
			this.removeChild(this._addr);
			this._addr = null;
			if (this._timer.running) this._timer.stop();
			this._timer.removeEventListener(TimerEvent.TIMER, onTimer);
			this._timer = null
			super.kill();
		}
		
		// PRIVATE METHODS
		
		/**
		 * Stage redraw.
		 */
		private function onResize(evt:Event = null):void {
			if (this._ready) {
				this.setBGColor(this._color);
				this._close.x = this._refWidth - this._close.width;
				this._close.y = 0;
				this._back.x = 0;
				this._back.y = 0;
				this._next.x = this._back.x + this._back.width;
				this._next.y = 0;
				this._white.width = this._refWidth - this._back.width - this._next.width - this._close.width - 20;
				this._addr.width = this._refWidth - this._back.width - this._next.width - this._close.width - 30;
				this._addr.height = this._addr.getLineMetrics(0).height + ManaganaInterface.newSize(5);
				this._white.height = this._addr.height + 10;
				this._white.x = this._next.x + this._next.width + 10;
				this._white.y = (this._close.height - this._white.height) / 2;
				this._addr.x = this._white.x + 5;
				this._addr.y = this._white.y + 6;
				var maxWidth:Number = this._refWidth - (2 * this._close.width);
				var maxHeight:Number = this._refHeight - (2 * this._close.height);
				var sizeW:Number = maxWidth;
				var sizeH:Number = sizeW * this._comHeight / this._comWidth;
				if (sizeH > maxHeight) {
					sizeH = maxHeight;
					sizeW = sizeH * this._comWidth / this._comHeight;
				}
				var posX:Number = (this._refWidth - sizeW) / 2;
				var posY:Number = (this._refHeight - sizeH) / 2;
				
				trace ('size:', posX, posY, sizeW, sizeH, this._comWidth, this._comHeight);
				
				if (this._view.stage != null) this._view.viewPort = new Rectangle(posX, posY, sizeW, sizeH);
				//if (this._view.stage != null) this._view.viewPort = new Rectangle(0, this._close.height, this._refWidth, (this._refHeight - this._close.height));
			}
		}
		
		/**
		 * Error while opening a url.
		 */
		private function onViewError(evt:ErrorEvent):void {
			// do nothing
			trace ("view error on url", this._addr.text);
		}
		
		/**
		 * Click on close button.
		 */
		private function onClose(evt:MouseEvent):void {
			this.visible = false;
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
		/**
		 * Click on back button.
		 */
		private function onBack(evt:MouseEvent):void {
			if (this._view.isHistoryBackEnabled) this._view.historyBack();
		}
		
		/**
		 * Click on next button.
		 */
		private function onNext(evt:MouseEvent):void {
			if (this._view.isHistoryForwardEnabled) this._view.historyForward();
		}
		
		/**
		 * Update display interface.
		 */
		private function onTimer(evt:TimerEvent = null):void {
			// authentication check
			if (this._authenticate) {
				if (this._view.location.indexOf("authenticateok") >= 0) {
					// authentication ok
					
					//var loginkey:String = String(this._view.location).substr(-32);
					
					var loginurl:Array = String(this._view.location).split('=');
					if (loginurl.length > 1) {
						// confirm authentication
						var loginkey:String = loginurl[loginurl.length - 1];
						this.visible = false;
						this.dispatchEvent(new Message(Message.AUTHOK, { key:loginkey }));
					} else {
						// authentication error
						this.visible = false;
						this.dispatchEvent(new Message(Message.AUTHERROR));
					}
				} else if (this._view.location.indexOf("authenticateerror") >= 0) {
					// authentication error
					this.visible = false;
					this.dispatchEvent(new Message(Message.AUTHERROR));
				}
			}
			this._addr.text = this._view.location;
			if (this._view.isHistoryBackEnabled) this._back.alpha = 1;
				else this._back.alpha = 0.5;
			if (this._view.isHistoryForwardEnabled) this._next.alpha = 1;
				else this._next.alpha = 0.5;
		}
		
	}

}
package art.ciclope.managana.system {
	
	// FLASH PACKAGES
	import art.ciclope.event.Message;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.LocationChangeEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.geom.Point;
	
	// CICLOPE CLASSES
	import art.ciclope.managana.graphics.CloseButton;
	import art.ciclope.managana.ManaganaInterface;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * HTMLBoxAIR extends HTMLBox to create a HTML renderer over the Managana interface on AIR applications.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class HTMLBoxAIR extends HTMLBox {
		
		// VARIABLES
		
		private var _ready:Boolean;			// component ready?
		private var _bg:Shape;				// the background
		private var _color:uint;			// background color
		private var _view:StageWebView;		// browser
		private var _close:Sprite;			// close button
		
		private var _refWidth:Number = -1;
		private var _refHeight:Number = -1;
		
		/**
		 * HTMLBoxAIR constructor.
		 */
		public function HTMLBoxAIR(refSize:Point = null) {
			// reference size
			if (refSize != null) {
				this._refWidth = refSize.x;
				this._refHeight = refSize.y;
			}
			// wait for stage
			this._ready = false;
			this._color = 0;
			this.visible = false;
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
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
			this._close.width = this._close.height = ManaganaInterface.newSize(40);
			this._close.buttonMode = true;
			this._close.useHandCursor = true;
			this._close.addEventListener(MouseEvent.CLICK, onClose);
			this.addChild(this._close);
			this._view = new StageWebView();
			this._view.addEventListener(ErrorEvent.ERROR, onViewError);
			this._view.addEventListener(LocationChangeEvent.LOCATION_CHANGE, onLocationChange);
			this.onResize();
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
					this._view.viewPort = new Rectangle(this._close.width, this._close.height, (this._refWidth - (2 * this._close.width)), (this._refHeight - (2 * this._close.height)));
					this.onResize();
				} else {
					this._view.stage = null;
					this._view.loadString("");
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
		override public function openURL(url:String):void {
			this.pcode = "";
			this._view.loadURL(url);
			this.visible = true;
		}
		
		/**
		 * Release memory used by the object.
		 */
		override public function kill():void {
			this.removeChild(this._bg);
			this._bg.graphics.clear();
			this._bg = null;
			this._view.stage = null;
			if (this._view.hasEventListener(ErrorEvent.ERROR)) this._view.removeEventListener(ErrorEvent.ERROR, onViewError);
			if (this._view.hasEventListener(LocationChangeEvent.LOCATION_CHANGE)) this._view.removeEventListener(LocationChangeEvent.LOCATION_CHANGE, onLocationChange);
			this._view.dispose();
			this._view = null;
			this.removeChild(this._close);
			this._close.removeChildren();
			if (this._close.hasEventListener(MouseEvent.CLICK)) this._close.removeEventListener(MouseEvent.CLICK, onClose);
			this._close = null;
			this.pcode = "";
			super.kill();
		}
		
		// PRIVATE METHODS
		
		/**
		 * Stage redraw.
		 */
		private function onResize(evt:Event = null):void {
			if (this._ready) {
				this.setBGColor(this._color);
				this._close.width = this._close.height = ManaganaInterface.newSize(40);
				if (this._view.stage != null) this._view.viewPort = new Rectangle(this._close.width, this._close.height, (this._refWidth - (2 * this._close.width)), (this._refHeight - (2 * this._close.height)));
				this._close.x = this._close.y = 0;
			}
		}
		
		/**
		 * Error while opening a url.
		 */
		private function onViewError(evt:ErrorEvent):void {
			// do nothing
			trace ("view error on url");
		}
		
		/**
		 * Web view location changed.
		 */
		private function onLocationChange(evt:LocationChangeEvent):void {
			// check for progress code send
			if (this._view.location.indexOf("|MANAGANACLOSE|") >= 0) {
				var codeArray:Array = this._view.location.split("|MANAGANACLOSE|");
				if (codeArray.length >= 2) {
					this.pcode = String(codeArray[1]).replace(/%3E/gi, ">");
					this.onClose(null);
				}
			}
		}
		
		/**
		 * Click on close button.
		 */
		private function onClose(evt:MouseEvent):void {
			this.visible = false;
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
	}

}
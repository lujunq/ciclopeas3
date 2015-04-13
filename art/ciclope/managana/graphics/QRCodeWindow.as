package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	// CICLOPE CLASSES
	import art.ciclope.display.QRCodeDisplay;
	import art.ciclope.managana.ManaganaInterface;
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class QRCodeWindow extends Sprite {
		
		// PRIVATE VARIABLES
		
		private var _qrcode:QRCodeDisplay;			// the qrcode parser and display
		private var _bg:InterfaceWindow;			// the background
		private var _close:Sprite;					// the close button
		private var _text:TextField;				// code display as string
		
		/**
		 * QRCodeWindow constructor.
		 */
		public function QRCodeWindow() {
			super();
			
			this._bg = new InterfaceWindow();
			this.addChild(this._bg);
			
			this._qrcode = new QRCodeDisplay();
			this.addChild(this._qrcode);
			
			this._close = new CloseWindow() as Sprite;
			ManaganaInterface.setSize(this._close);
			this._close.buttonMode = true;
			this._close.useHandCursor = true;
			this._close.addEventListener(MouseEvent.CLICK, onClose);
			this.addChild(this._close);
			
			this._text = new TextField();
			this._text.selectable = false;
			this._text.multiline = true;
			this._text.wordWrap = true;
			this._text.defaultTextFormat = new TextFormat('_sans', 12, 0xFFFFFF, true, null, null, null, null, 'center');
			this._text.text = this.code;
			this.addChild(this._text);
			
			this.code = 'http://www.managana.org/';
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		// GET/SET VALUES
		
		/**
		 * QRCode window width.
		 */
		override public function get width():Number {
			return (this._bg.width);
		}
		override public function set width(value:Number):void {
			this._bg.width = value;
			this._qrcode.width = 4 * value / 5;
			this._qrcode.x = this._bg.x + ((this._bg.width - this._qrcode.width) / 2);
			this._close.x = this._bg.width - (this._close.width / 2);
			this._text.width = 5 * value / 6;
			this._text.x = this._bg.x + ((this._bg.width - this._text.width) / 2);
		}
		
		/**
		 * QRCode window height.
		 */
		override public function get height():Number {
			return (this._bg.height);
		}
		override public function set height(value:Number):void {
			this._bg.height = value * 1.15;
			this._qrcode.height = 4 * value / 5;
			this._qrcode.y = this._bg.y + ((value - this._qrcode.height) / 2);
			this._close.y = this._bg.y - (this._close.height / 2);
			this._text.height = this._bg.height - this._qrcode.y - this._qrcode.height - 5;
			this._text.y = this._qrcode.y + this._qrcode.height + 5;
		}
		
		/**
		 * Encoded string.
		 */
		public function get code():String {
			return (this._qrcode.code);
		}
		public function set code(to:String):void {
			this._qrcode.setCode(to);
			this._text.text = to;
		}
		
		// PUBLIC METHODS
		
		/**
		 * Redraw window interface.
		 * @param	w	stage width
		 * @param	h	stage height
		 */
		public function redraw(w:Number, h:Number):void {
			if (w > h) {
				this.width = this.height = 1 * h / 2;
			} else {
				this.width = this.height = 1 * w / 2;
			}
			this.x = (w - this.width) / 2;
			this.y = (h - this.height) / 2;
		}
		
		/**
		 * Close the qrcode window.
		 */
		public function close():void {
			if (this.stage != null) {
				parent.removeChild(this);
			}
		}
		
		// PRIVATE METHODS
		
		/**
		 * Code display window is visible on stage.
		 */
		private function onAddToStage(evt:Event):void {
			this.redraw(stage.stageWidth, stage.stageHeight);
		}
		
		/**
		 * Click on close button.
		 */
		private function onClose(evt:MouseEvent):void {
			this.close();
		}
	}

}
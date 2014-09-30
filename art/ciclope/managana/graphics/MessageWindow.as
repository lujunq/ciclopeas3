package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaInterface;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * MessageWindow provides a graphic interface for Managana reader message windows.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class MessageWindow extends Sprite {
		
		// VARIABLES
		
		private var _ready:Boolean;					// is window ready?
		private var _bg:InterfaceWindow;			// the window background
		private var _close:Sprite;					// close window button
		private var _about:TextField;				// about account creation
		private var _holdText:String;				// a text to show when the stage becomes available
		private var _showClose:Boolean;				// show the window close button?
		private var _button:InterfaceButton;		// a button to show below the message
		private var _buttonClick:Function;			// a function to call on button click
		
		private var _refWidth:Number;
		private var _refHeight:Number;
		
		/**
		 * MessageWindow constructor.
		 */
		public function MessageWindow(refWidth:Number, refHeight:Number, showClose:Boolean = true) {
			this._ready = false;
			this._holdText = "";
			this._refWidth = refWidth;
			this._refHeight = refHeight;
			this._showClose = showClose;
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		/**
		 * Stage became available.
		 */
		private function onStage(evt:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			if (this._showClose) {
				this._bg = new InterfaceWindow();
				this._bg.width = ManaganaInterface.newSize(435);
				this._bg.height = ManaganaInterface.newSize(300);
				this.addChild(this._bg);
				this._close = new CloseWindow() as Sprite;
				ManaganaInterface.setSize(this._close);
				this._close.x = this._bg.width - (this._close.width / 2);
				this._close.y = this._bg.y - (this._close.height / 2);
				this._close.buttonMode = true;
				this._close.useHandCursor = true;
				this._close.addEventListener(MouseEvent.CLICK, onClose);
				this.addChild(this._close);
			} else {
				this._bg = new InterfaceWindow(false);
				this._bg.width = ManaganaInterface.newSize(450);
				this._bg.height = ManaganaInterface.newSize(300);
				this.addChild(this._bg);
			}
			this._about = new TextField();
			this._about.defaultTextFormat = new TextFormat("_sans", ManaganaInterface.newSize(14), 0xFFFFFF, true);
			this._about.multiline = true;
			this._about.wordWrap = true;
			this._about.selectable = false;
			this._about.autoSize = TextFieldAutoSize.LEFT;
			this._about.x = this._about.y = 20;
			this._about.width = this._bg.width - 40;
			this.addChild(this._about);
			this._button = new InterfaceButton();
			this._button.addEventListener(MouseEvent.CLICK, onButtonClick);
			this._button.visible = false;
			this.addChild(this._button);
			this._ready = true;
			this.redraw();
			if (this._holdText != "") this.setText(this._holdText);
			this._holdText = "";
		}
		
		// PUBLIC METHODS
		
		public function setText(message:String, buttonText:String = "", buttonAction:Function = null):void {
			if (this._ready) {
				this._about.text = message;
				if (buttonText != "") {
					this._button.text = buttonText;
					this._buttonClick = buttonAction;
					this._button.visible = true;
				} else {
					this._button.visible = false;
				}
				this.redraw();
			} else {
				this._holdText = message;
			}
		}
		
		/**
		 * Redraw window.
		 */
		public function redraw(refSize:Point = null):void {
			if (refSize != null) {
				this._refWidth = refSize.x;
				this._refHeight = refSize.y;
			}
			if (this._button.visible) {
				this._button.width = ManaganaInterface.newSize(300);
				this._button.x = (this._bg.width - this._button.width) / 2;
				this._button.y = this._about.y + this._about.height + 15;
				this._bg.height = this._about.height + this._button.height + 50;
			} else {
				this._bg.height = this._about.height + 40;
			}
			this.x = (this._refWidth - this._bg.width) / 2;
			this.y = (this._refHeight - this._bg.height) / 2;
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			if (this._ready) {
				this.removeChild(this._bg);
				this._bg.kill();
				this._bg = null;
				if (this._showClose) {
					this.removeChild(this._close);
					this._close.removeEventListener(MouseEvent.CLICK, onClose);
					this._close = null;
				}
				this.removeChild(this._about);
				this._about = null;
				this.removeChild(this._button);
				this._button.removeEventListener(MouseEvent.CLICK, onButtonClick);
				this._button = null;
			} else {
				this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			}
			this._holdText = null;
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
		 * The window button was clicked.
		 */
		private function onButtonClick(evt:MouseEvent):void {
			if (this._buttonClick != null) this._buttonClick();
		}
		
	}

}
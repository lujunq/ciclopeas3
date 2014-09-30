package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaInterface;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * InterfaceTextInput provides a graphic interface for Managana reader text input field.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class InterfaceTextInput extends Sprite {
		
		// VARIABLES
		
		private var _left:Sprite;		// left component background
		private var _right:Sprite;		// right component background
		private var _middle:Sprite;		// middle component background
		private var _text:TextField;	// input text
		
		/**
		 * InterfaceTextInput constructor.
		 */
		public function InterfaceTextInput() {
			// add background
			this._left = new TextFieldLeft() as Sprite;
			ManaganaInterface.setSize(this._left);
			this.addChild(this._left);
			this._middle = new TextFieldMiddle() as Sprite;
			ManaganaInterface.setSize(this._middle);
			this.addChild(this._middle);
			this._right = new TextFieldRight() as Sprite;
			ManaganaInterface.setSize(this._right);
			this.addChild(this._right);
			this._text = new TextField();
			this._text.defaultTextFormat = new TextFormat("_sans", ManaganaInterface.newSize(20), 0xFFFFFF, true);
			this._text.multiline = false;
			this._text.wordWrap = false;
			this._text.selectable = true;
			this._text.type = TextFieldType.INPUT;
			//this._text.needsSoftKeyboard = true;
			this._text.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			this._text.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			this.addChild(this._text);
		}
		
		// PROPERTIES
		
		/**
		 * Component width.
		 */
		override public function get width():Number {
			return super.width;
		}
		override public function set width(value:Number):void {
			if (value < 30) value = 30;
			this._left.x = 0;
			this._left.y = 0;
			this._middle.x = this._left.width;
			this._middle.y = 0;
			this._middle.width = value - this._left.width - this._right.width;
			this._right.x = this._middle.x + this._middle.width;
			this._right.y = 0;
			this._text.x = 5;
			this._text.y = ManaganaInterface.newSize(5);
			this._text.height = this._middle.height - 10;
			this._text.width = value - 10;
		}
		
		/**
		 * Component height (read-only).
		 */
		override public function get height():Number {
			return (this._middle.height);
		}
		override public function set height(value:Number):void {
			// do nothing
		}
		
		/**
		 * Component text.
		 */
		public function get text():String {
			return (this._text.text);
		}
		public function set text(to:String):void {
			this._text.text = to;
		}
		
		/**
		 * Should text be displayed as a password field?
		 */
		public function get displayAsPassword():Boolean {
			return (this._text.displayAsPassword);
		}
		public function set displayAsPassword(to:Boolean):void {
			this._text.displayAsPassword = to;
		}
		
		// PUBLIC METHODS
		
		/**
		 * Release memmory used by the object.
		 */
		public function kill():void {
			this._text.removeEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			this._text.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			this.removeChild(this._left);
			this.removeChild(this._middle);
			this.removeChild(this._right);
			this.removeChild(this._text);
			this._left = null;
			this._right = null;
			this._middle = null;
			this._text = null;
		}
		
		// PRIVATE METHODS
		
		/**
		 * Text field received focus.
		 */
		private function onFocusIn(evt:FocusEvent):void {
			this.dispatchEvent(evt);
		}
		
		/**
		 * Text field lost focus.
		 */
		private function onFocusOut(evt:FocusEvent):void {
			this.dispatchEvent(evt);
		}
		
	}

}
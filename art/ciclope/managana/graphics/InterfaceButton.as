package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaInterface;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * InterfaceButton provides a graphic interface for Managana reader buttons.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class InterfaceButton extends Sprite {
		
		// VARIABLES
		
		private var _left:Sprite;		// left component background
		private var _right:Sprite;		// right component background
		private var _middle:Sprite;		// middle component background
		private var _text:TextField;	// input text
		
		/**
		 * InterfaceButton constructor.
		 */
		public function InterfaceButton() {
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
			this._text.defaultTextFormat = new TextFormat("_sans", ManaganaInterface.newSize(16), 0xFFFFFF);
			this._text.multiline = false;
			this._text.wordWrap = false;
			this._text.selectable = false;
			this._text.autoSize = TextFieldAutoSize.CENTER;
			this.mouseChildren = false;
			this.buttonMode = true;
			this.useHandCursor = true;
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
			this._text.y = ((this._middle.height - this._text.getLineMetrics(0).height) / 2) - ManaganaInterface.newSize(2);
			this._text.height = this._middle.height - 10;
			this._text.width = value - 10;
		}
		
		/**
		 * Component height (read-only).
		 */
		override public function get height():Number {
			return super.height;
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
			this._text.y = ((this._middle.height - this._text.getLineMetrics(0).height) / 2) - ManaganaInterface.newSize(2);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Release memmory used by the object.
		 */
		public function kill():void {
			this.removeChild(this._left);
			this.removeChild(this._middle);
			this.removeChild(this._right);
			this.removeChild(this._text);
			this._left = null;
			this._right = null;
			this._middle = null;
			this._text = null;
		}
		
	}

}
package art.ciclope.managanaeditor {
	
	// FLASH PACKAGES
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * MessageDisplay creates a simple display to show messages on InstanceDisplay instances.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class MessageDisplay extends Sprite {
		
		// VARIABLES
		
		private var _bg:Shape;				// background shape
		private var _text:TextField;		// about display
		
		/**
		 * MessageDisplay constructor.
		 * @param	text	the text to show
		 */
		public function MessageDisplay(text:String) {
			this._bg = new Shape();
			this._bg.graphics.lineStyle(1, 0x000000, 0.75);
			this._bg.graphics.beginFill(0xCCCCCC, 0.75);
			this._bg.graphics.drawRect(0, 0, 160, 90);
			this._bg.graphics.endFill();
			this.addChild(this._bg);
			this._text = new TextField();
			this._text.textColor = 0x000000;
			this._text.text = text;
			this._text.x = this._text.y = 5;
			this._text.multiline = true;
			this._text.wordWrap = true;
			this.addChild(this._text);
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}
		
		// PROPERTIES
		
		/**
		 * Display width.
		 */
		override public function get width():Number {
			return (this._bg.width);
		}
		override public function set width(value:Number):void {
			this._bg.width = value;
			this._text.width = value - 10;
		}
		
		/**
		 * Display height.
		 */
		override public function get height():Number {
			return (this._bg.height);
		}
		override public function set height(value:Number):void {
			this._bg.height = value;
			this._text.height = value - 10;
		}
		
		/**
		 * Message text.
		 */
		public function get text():String {
			return (this._text.text);
		}
		public function set text(to:String):void {
			this._text.text = to;
		}
		
	}

}
package art.ciclope.managanaeditor {
	
	// FLASH PACKAGES
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * InstanceDisplayWindow creates a tool window to place behind InstanceDisplay objects.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class InstanceDisplayWindow extends Sprite {
		
		// VARIABLES
		
		private var _innerShape:Shape;		// inner color shape
		private var _width:Number;			// set inner shape width
		private var _height:Number;			// set inner shape height
		private var _topShape:Shape;		// top window bar
		private var _topText:TextField;		// top window bar text
		
		public function InstanceDisplayWindow(w:Number = 160, h:Number = 90, name:String = "") {
			// size
			this._width = w;
			this._height = h;
			// inner shape
			this._innerShape = new Shape();
			this.addChild(this._innerShape);
			// top shape
			this._topShape = new Shape();
			this.addChild(this._topShape);
			// window text
			this._topText = new TextField();
			this._topText.defaultTextFormat = new TextFormat("_sans", 10, 0x000000);
			this._topText.alpha = 0.75;
			this._topText.wordWrap = false;
			this._topText.selectable = false;
			this._topText.multiline = false;
			this._topText.text = name;
			this.addChild(this._topText);
			// update window display
			this.updateDisplay();
		}
		
		// PROPERTIES
		
		/**
		 * The window width.
		 */
		override public function get width():Number {
			return (this._width);
		}
		override public function set width(value:Number):void {
			this._width = value;
			this.updateDisplay();
		}
		
		/**
		 * The window height.
		 */
		override public function get height():Number {
			return (this._height);
		}
		override public function set height(value:Number):void {
			this._height = value;
			this.updateDisplay();
		}
		
		// PUBLIC METHODS
		
		/**
		 * Release memeory used by the object.
		 */
		public function kill():void {
			this.removeChild(this._innerShape);
			this._innerShape.graphics.clear();
			this._innerShape = null;
		}
		
		// PRIVATE METHODS
		
		/**
		 * Update window display.
		 */
		private function updateDisplay():void {
			// inner shape
			this._innerShape.graphics.clear();
			this._innerShape.graphics.lineStyle(1, 0, 0.5);
			this._innerShape.graphics.beginFill(0xCCCCCC, 0.5);
			this._innerShape.graphics.drawRect(( -this._width / 2), ( -this._height / 2), this._width, this._height);
			this._innerShape.graphics.endFill();
			// top shape
			this._topShape.graphics.clear();
			this._topShape.graphics.lineStyle(1, 0, 0.5);
			this._topShape.graphics.beginFill(0x999999, 0.75);
			this._topShape.graphics.drawRect(( -this._width / 2), -20, this._width, 20);
			this._topShape.y = -this._height / 2;
			// window title
			this._topText.x = ( -this._width / 2) + 5;
			this._topText.y = ( -this._height / 2) - 17;
			this._topText.width = this._width - 10;
			this._topText.height = 20;
		}
		
	}

}
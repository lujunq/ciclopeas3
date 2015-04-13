package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaInterface;
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class DebugWindow extends Sprite {
		
		// PRIVATE VARIABLES
		
		private var _bg:InterfaceWindow;			// the background
		private var _close:Sprite;					// the close button
		private var _text:TextField;				// output text
		
		/**
		 * DebugWindow constructor.
		 */
		public function DebugWindow() {
			super();
			
			this._bg = new InterfaceWindow();
			this.addChild(this._bg);
			
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
			this._text.defaultTextFormat = new TextFormat('_sans', 12, 0xFFFFFF, true);
			this.addChild(this._text);
			
			var d:Date = new Date();
			this._text.text = "starting output at " + d.fullYear + '/' + (d.month + 1) + '/' + d.day + ' ' + d.hours + ':' + d.minutes + ':' + d.seconds + "\n";
			
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
			this._close.x = this._bg.width - (this._close.width / 2);
			this._text.width = 4 * value / 5;
			this._text.x = (this._bg.width - this._text.width) / 2;
		}
		
		/**
		 * QRCode window height.
		 */
		override public function get height():Number {
			return (this._bg.height);
		}
		override public function set height(value:Number):void {
			this._bg.height = value;
			this._close.y = this._bg.y - (this._close.height / 2);
			this._text.height = 4 * value / 5;
			this._text.y = (this._bg.height - this._text.height) / 2;
		}
		
		// PUBLIC METHODS
		
		/**
		 * Redraw window interface.
		 * @param	w	stage width
		 * @param	h	stage height
		 */
		public function redraw(w:Number, h:Number):void {
			this.height = 3 * h / 4;
			this.width = 3 * w / 4;
			this.x = (w - this.width) / 2;
			this.y = (h - this.height) / 2;
		}
		
		/**
		 * Close the window.
		 */
		public function close():void {
			if (this.stage != null) {
				parent.removeChild(this);
			}
		}
		
		public function out(text:String):void {
			this._text.appendText(text + "\n");
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
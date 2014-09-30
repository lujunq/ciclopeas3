package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import flash.text.TextFormat;
	import flash.geom.Point;
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaInterface;
	
	/**
	 * ...
	 * @author Chokito
	 */
	public class UIWarning extends Sprite {
		
		// VARIABLES
		
		private var _bg:Shape;				// the background shape
		private var _text:TextField;		// the message text
		private var _timeout:int;			// hide timeout
		
		private var _refWidth:Number;
		private var _refHeight:Number;
		
		/**
		 * UIWarning constructor.
		 */
		public function UIWarning(refWidth:Number, refHeight:Number) {
			this._refWidth = refWidth;
			this._refHeight = refHeight;
			// wait for the stage to become available
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		/**
		 * The stage is available.
		 */
		private function onStage(evt:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			// draw graphics
			this._bg = new Shape();
			this._bg.graphics.beginFill(0, 0.5);
			this._bg.graphics.drawRoundRect(0, 0, ManaganaInterface.newSize(240), ManaganaInterface.newSize(25), ManaganaInterface.newSize(5), ManaganaInterface.newSize(5));
			this._bg.graphics.endFill();
			this.addChild(this._bg);
			this._text = new TextField();
			this._text.defaultTextFormat = new TextFormat("_sans", ManaganaInterface.newSize(13), 0xFFFFFF, true, null, null, null, null, "center");
			this._text.width = this._bg.width;
			this._text.text = "post message here";
			this._text.height = this._text.getLineMetrics(0).height + ManaganaInterface.newSize(5);
			this._text.y = ((this._bg.height - this._text.height) / 2) - ManaganaInterface.newSize(2);
			this._text.alpha = 0.8;
			this._text.selectable = false;
			this.addChild(this._text);
			// properties
			this.mouseEnabled = false;
			this.mouseChildren = false;
			this._timeout = -1;
			this.redraw();
			this.visible = false;
		}
		
		/**
		 * Set the warning text.
		 * @param	text	the message
		 */
		public function setText(text:String):void {
			if (this._timeout >= 0) clearTimeout(this._timeout);
			this._text.text = text;
			this._timeout = setTimeout(hideMessage, 2000);
			this.visible = true;
		}
		
		/**
		 * Redraw this display.
		 */
		public function redraw(refSize:Point = null):void {
			if (refSize != null) {
				this._refWidth = refSize.x;
				this._refHeight = refSize.y;
			}
			this.x = (this._refWidth - this.width) / 2;
			this.y = this._refHeight - this.height - 5;
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			this.removeChildren();
			this._bg.graphics.clear();
			this._bg = null;
			this._text = null;
			if (this._timeout >= 0) clearTimeout(this._timeout);
		}
		
		/**
		 * Hide the warning.
		 */
		private function hideMessage():void {
			this.visible = false;
			this._timeout = -1;
		}
		
	}

}
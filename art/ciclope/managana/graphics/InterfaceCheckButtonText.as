package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaInterface;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * InterfaceCheckButtonText provides a graphic interface for Managana reader check buttons with text.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class InterfaceCheckButtonText extends Sprite {
		
		// VARIABLES
		
		private var _uncheck:Sprite;		// unchecked background
		private var _check:Sprite;			// checked background
		private var _label:TextField;		// button label
		private var _enabled:Boolean;		// is button enabled?
		private var _bg:Shape;				// background shape
		
		/**
		 * InterfaceCheckButton constructor.
		 * @param	text	the button text
		 * @param	checked	is the button checked by default?
		 */
		public function InterfaceCheckButtonText(text:String, checked:Boolean = false) {
			this._bg = new Shape();
			this._bg.graphics.beginFill(0, 0);
			this._bg.graphics.drawRect(0, 0, ManaganaInterface.newSize(140), ManaganaInterface.newSize(25));
			this._bg.graphics.endFill();
			this._bg.x = this._bg.y = 0;
			this.addChild(this._bg);
			this._uncheck = new CheckButtonBG() as Sprite;
			ManaganaInterface.setSize(this._uncheck);
			this._uncheck.x = 0;
			this._uncheck.y = 2;
			this._uncheck.visible = !checked;
			this.addChild(this._uncheck);
			this._check = new CheckButtonBGMark() as Sprite;
			ManaganaInterface.setSize(this._check);
			this._check.x = 0;
			this._check.y = 2;
			this._check.visible = checked;
			this.addChild(this._check);
			this._label = new TextField();
			this._label.defaultTextFormat = new TextFormat("_sans", ManaganaInterface.newSize(16), 0xFFFFFF, true);
			this._label.text = text;
			this._label.x = this._check.width + 5;
			this._label.multiline = false;
			this._label.selectable = false;
			this._label.height = this._label.getLineMetrics(0).height + ManaganaInterface.newSize(4);
			this._label.y = ((this._bg.height - this._label.height) / 2) - ManaganaInterface.newSize(3);
			this._enabled = false;
			this.alpha = 0.5;
			this.addChild(this._label);
			this.buttonMode = false;
			this.useHandCursor = false;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		// PROPERTIES
		
		/**
		 * Button width.
		 */
		override public function get width():Number {
			return (this._bg.width);
		}
		override public function set width(value:Number):void {
			this._bg.width = value;
			this._label.width = value - this._label.x - 5;
		}
		
		/**
		 * Button height.
		 */
		override public function get height():Number {
			return (this._check.height + 4);
		}
		override public function set height(value:Number):void {
			// do nothing
		}
		
		/**
		 * Is the button enabled?
		 */
		public function get enabled():Boolean {
			return (this._enabled);
		}
		public function set enabled(to:Boolean):void {
			this._enabled = to;
			to ? this.alpha = 1 : this.alpha = 0.5;
			this.useHandCursor = this.buttonMode = to;
			if (!to) this.checked = false;
		}
		
		/**
		 * Is the button checked?
		 */
		public function get checked():Boolean {
			return (this._check.visible);
		}
		public function set checked(to:Boolean):void {
			this._check.visible = to;
			this._uncheck.visible = !to;
		}
		
		/**
		 * Button label text.
		 */
		public function get text():String {
			return (this._label.text);
		}
		public function set text(to:String):void {
			this._label.text = to;
		}
		
		// PUBLIC METHODS
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			this.removeEventListener(MouseEvent.CLICK, onClick);
			this.removeChild(this._check);
			this.removeChild(this._uncheck);
			this.removeChild(this._label);
			this.removeChild(this._bg);
			this._bg = null;
			this._check = null;
			this._uncheck = null;
			this._label = null;
		}
		
		// PRIVATE METHODS
		
		/**
		 * Check/uncheck button.
		 */
		private function onClick(evt:MouseEvent):void {
			this.checked = !this.checked;
		}
	}

}
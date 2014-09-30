package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaInterface;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * MainButton provides a graphic interface for Managana reader logo button.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class MainButton extends Sprite {
		
		// VARIABLES
		
		private var _left:Sprite;						// left border
		private var _right:Sprite;						// right border
		private var _bg:Sprite;							// bar background
		private var _ready:Boolean;						// is component ready?
		private var _width:Number;						// component width
		private var _height:Number;						// component height
		private var _user:TextField;					// username
		private var _uservisible:Boolean;				// is user name visible?
		
		// PUBLIC VARIABLES
		
		/**
		 * Public remote connection key (will be shown instead of connected user);
		 */
		public var publicKey:String = "";
		
		/**
		 * MainButton constructor.
		 */
		public function MainButton() {
			this._ready = false;
			this._uservisible = false;
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		/**
		 * Stage is available.
		 */
		private function onStage(evt:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			this._left = new MainButtonBorderLeft() as Sprite;
			ManaganaInterface.setSize(this._left);
			this._right = new MainButtonBorderRight() as Sprite;
			ManaganaInterface.setSize(this._right);
			this._bg = new MainButtonBG() as Sprite;
			ManaganaInterface.setSize(this._bg);
			this.addChild(this._left);
			this.addChild(this._right);
			this.addChild(this._bg);
			this._width = ManaganaInterface.newSize(60);
			this._height = this._bg.height;
			this._user = new TextField();
			this._user.multiline = false;
			this._user.wordWrap = false;
			this._user.selectable = false;
			this._user.autoSize = TextFieldAutoSize.LEFT;
			this._user.defaultTextFormat = new TextFormat("_sans", ManaganaInterface.newSize(14), 0xFFFFFF, true);
			this._user.text = "";
			this._user.x = MainButton.minWidth;
			this._user.y = (this._bg.height - this._user.height) / 2;
			this._user.visible = this._uservisible;
			this.addChild(this._user);
			this.mouseEnabled = false;
			this.mouseChildren = false;
			this._ready = true;
			this.redraw();
		}
		
		// STATIC PROPERTIES
		
		/**
		 * Minimum main button width.
		 */
		public static function get minWidth():Number {
			return (ManaganaInterface.newSize(60));
		}
		
		/**
		 * Redraw the component.
		 */
		public function redraw():void {
			if (this._ready) {
				this.width = this._width;
				this._left.x = 0;
				this._bg.x = this._left.x + this._left.width;
				this._right.x = this._bg.x + this._bg.width;
			}
		}
		
		// PROPERTIES
		
		/**
		 * Component width.
		 */
		override public function get width():Number {
			return (this._width);
		}
		override public function set width(value:Number):void {
			if (this._uservisible && this._ready && (this._user.text != "")) {
				this._width = this._user.x + this._user.width + this._right.width;
			} else if (value < MainButton.minWidth) {
				this._width = MainButton.minWidth;
			} else {
				this._width = value;
			}
			if (this._ready) {
				this._bg.width = this._width - this._left.width - this._right.width;
			}
		}
		
		/**
		 * Component height (read-only).
		 */
		override public function get height():Number {
			return (this._height);
		}
		override public function set height(value:Number):void {
			// do nothing
		}
		
		/**
		 * Is user name visible?
		 */
		public function get userVisible():Boolean {
			return (this._uservisible);
		}
		public function set userVisible(to:Boolean):void {
			this._uservisible = to;
			if (this._user != null) this._user.visible = this._uservisible;
			if (to) this.width = this._width;
				else this.width = MainButton.minWidth;
			this.redraw();
		}
		
		/**
		 * The user name.
		 */
		public function get username():String {
			return (this._user.text);
		}
		public function set username(to:String):void {
			if (this.publicKey == "") {
				this._user.text = to;
			} else {
				this._user.text = this.publicKey;
			}
			if (to == "") this._width = MainButton.minWidth;
			this._user.y = (this._bg.height - this._user.height) / 2;
			this.redraw();
		}
		
		// PUBLIC METHODS
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			if (this._ready) {
				this.removeChild(this._left);
				this.removeChild(this._right);
				this.removeChild(this._bg);
				this._right = null;
				this._left = null;
				this._bg = null;
				this.publicKey = null;
			} else {
				this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			}
		}
		
	}

}
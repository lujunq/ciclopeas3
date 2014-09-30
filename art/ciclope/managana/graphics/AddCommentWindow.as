package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.geom.Point;
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaInterface;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * AddCommentWindow provides a graphic interface for adding comments on Managana reader.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class AddCommentWindow extends Sprite {
		
		// VARIABLES
		
		private var _ready:Boolean;					// is window ready?
		private var _bg:InterfaceWindow;			// the window background
		private var _close:Sprite;					// close window button
		private var _about:TextField;				// about account creation
		private var _comment:InterfaceTextInput;	// comment input
		private var _ok:InterfaceButton;			// add comment button
		
		private var _refWidth:Number;
		private var _refHeight:Number;
		
		// PUBLIC VARIABLES
		
		/**
		 * A function to call to add the comment.
		 */
		public var addaction:Function;
		
		/**
		 * AddCommentWindow constructor.
		 */
		public function AddCommentWindow(refWidth:Number, refHeight:Number) {
			this._ready = false;
			this._refWidth = refWidth;
			this._refHeight = refHeight;
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		/**
		 * Stage became available.
		 */
		private function onStage(evt:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			this._bg = new InterfaceWindow();
			this._bg.width = ManaganaInterface.newSize(435);
			this._bg.height = ManaganaInterface.newSize(170);
			this.addChild(this._bg);
			this._close = new CloseWindow() as Sprite;
			ManaganaInterface.setSize(this._close);
			this._close.x = this._bg.width - (this._close.width / 2);
			this._close.y = this._bg.y - (this._close.height / 2);
			this._close.buttonMode = true;
			this._close.useHandCursor = true;
			this._close.addEventListener(MouseEvent.CLICK, onClose);
			this.addChild(this._close);
			this._about = new TextField();
			this._about.defaultTextFormat = new TextFormat("_sans", ManaganaInterface.newSize(14), 0xFFFFFF, true);
			this._about.multiline = true;
			this._about.wordWrap = true;
			this._about.selectable = false;
			this._about.x = this._about.y = 20;
			this._about.width = this._bg.width - 40;
			this._about.height = this._about.getLineMetrics(0).height + ManaganaInterface.newSize(5);
			this.addChild(this._about);
			this._comment = new InterfaceTextInput();
			this._comment.x = 20;
			this._comment.y = (this._bg.height - this._comment.height) / 2;
			this._comment.width = this._bg.width - 40;
			this.addChild(this._comment);
			this._ok = new InterfaceButton();
			this._ok.width = ManaganaInterface.newSize(200);
			this._ok.x = this._bg.width - 20 - this._ok.width;
			this._ok.y = this._bg.height - 20 - this._ok.height;
			this._ok.addEventListener(MouseEvent.CLICK, onAdd);
			this.addChild(this._ok);
			this._ready = true;
			this.redraw();
		}
		
		// PROPERTIES
		
		/**
		 * Comment text.
		 */
		public function get comment():String {
			return (this._comment.text);
		}
		public function set comment(to:String):void {
			this._comment.text = to;
		}
		
		// PUBLIC METHODS
		
		/**
		 * Set the window text.
		 * @param	about	the title text
		 * @param	button	the button text
		 */
		public function setText(about:String, button:String):void {
			this._about.text = about;
			this._ok.text = button;
		}
		
		/**
		 * Redraw window.
		 */
		public function redraw(refSize:Point = null):void {
			if (refSize != null) {
				this._refWidth = refSize.x;
				this._refHeight = refSize.y;
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
				this.removeChild(this._close);
				this._close.removeEventListener(MouseEvent.CLICK, onClose);
				this._close = null;
				this.removeChild(this._about);
				this._about = null;
				this.removeChild(this._comment);
				this._comment.kill();
				this._comment = null;
				this.removeChild(this._ok);
				this._ok.removeEventListener(MouseEvent.CLICK, onAdd);
				this._ok.kill();
				this._ok = null;
			} else {
				this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			}
			this.addaction = null;
		}
		
		// PRIVATE METHODS
		
		/**
		 * Close window.
		 */
		private function onClose(evt:MouseEvent):void {
			this.visible = false;
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
		/**
		 * Add comment.
		 */
		private function onAdd(evt:MouseEvent):void {
			if (this.addaction != null) this.addaction(this._comment.text);
		}
		
	}

}
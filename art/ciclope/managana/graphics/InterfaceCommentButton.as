package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.geom.Point;
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaInterface;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * InterfaceCommentButton provides a graphic interface for Managana reader lower comment button.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class InterfaceCommentButton extends Sprite {
		
		// VARIABLES
		
		private var _ready:Boolean;			// is the button ready?
		private var _graphic:Sprite;		// the button graphic
		private var _bg:Sprite;				// the button background
		private var _total:TextField;		// number of comments display
		private var _remote:Boolean;		// is the button used on remote control?
		
		private var _refWidth:Number;
		private var _refHeight:Number;
		
		/**
		 * InterfaceCommentButton constructor.
		 * @param	onremote	is the button used on remote control?
		 */
		public function InterfaceCommentButton(refWidth:Number, refHeight:Number, onremote:Boolean = false) {
			this._remote = onremote;
			this._refWidth = refWidth;
			this._refHeight = refHeight;
			this._ready = false;
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		/**
		 * Stage became available.
		 */
		private function onStage(evt:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			if (this._remote) {
				this._bg = new RemoteCommentButtonBG() as Sprite;
			} else {
				this._bg = new CommentButtonBG() as Sprite;
			}
			ManaganaInterface.setSize(this._bg);
			this.addChild(this._bg);
			this._graphic = new CommentButton() as Sprite;
			ManaganaInterface.setSize(this._graphic);
			this._graphic.alpha = 0.25;
			this.addChild(this._graphic);
			this._total = new TextField();
			this._total.multiline = false;
			this._total.wordWrap = false;
			this._total.defaultTextFormat = new TextFormat('_sans', ManaganaInterface.newSize(12), 0xFFFFFF, false, false, false, null, null, TextFormatAlign.CENTER);
			this._total.width = this._bg.width - 10;
			this._total.x = 5;
			this._total.text = "0";
			this._total.height = this._total.getLineMetrics(0).height;
			this._total.y = ((this._bg.height - this._total.height) / 2) - ManaganaInterface.newSize(5);
			this._total.visible = false;
			this.addChild(this._total);
			this.useHandCursor = true;
			this.buttonMode = true;
			this.mouseChildren = false;
			this._ready = true;
			this.redraw();
		}
		
		// PUBLIC METHODS
		
		/**
		 * Set total number of comments.
		 * @param	to	the number of comments
		 */
		public function setTotal(to:uint):void {
			this._total.text = String(to);
			if (to != 0) {
				this._total.visible = true;
				this._graphic.alpha = 0.5;
			} else {
				this._total.visible = false;
				this._graphic.alpha = 0.25;
			}
		}
		
		/**
		 * Redraw button.
		 */
		public function redraw(refSize:Point = null):void {
			if (refSize != null) {
				this._refWidth = refSize.x;
				this._refHeight = refSize.y;
			}
			if (this._ready) {
				this.x = 5;
				//this.y = this.stage.stageHeight - this.height - 5;
				this.y = this._refHeight - this.height - 5;
			}
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			if (this._ready) {
				this.removeChild(this._graphic);
				this._graphic = null;
				this.removeChild(this._bg);
				this._bg = null;
				this.removeChild(this._total);
				this._total = null;
			} else {
				this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			}
		}
		
	}

}
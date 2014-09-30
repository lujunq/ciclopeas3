package art.ciclope.managanaeditor {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import mx.core.FlexGlobals;
	import flash.events.MouseEvent;
	
	// CICLOPE CLASSES
	import art.ciclope.managana.graphics.*;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * VoteDisplayED create a sprite for vote position on Managana editor.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class VoteDisplayED extends Sprite {
		
		// VARIABLES
		
		private var _num:uint;					// vote number reference
		private var _dragging:Boolean = false;	// is the display being drag?
		private var _offsetX:Number = 0;		// drag offset x
		private var _offsetY:Number = 0;		// drag offset y
		
		
		/**
		 * VisteDisplay constructor.
		 * @param	num	the vote number
		 */
		public function VoteDisplayED(num:uint) {
			// graphic
			var display:Sprite = new Vote100() as Sprite;
			this.addChild(display);
			// text
			this._num = num;
			var votenum:TextField = new TextField();
			votenum.selectable = false;
			votenum.multiline = false;
			votenum.wordWrap = false;
			votenum.defaultTextFormat = new TextFormat("_sans", 16, 0xFFFFFF, true, null, null, null, null, TextFormatAlign.CENTER);
			votenum.text = String(num);
			votenum.width = display.width;
			votenum.height = 20;
			votenum.x = 0;
			votenum.y = (display.height - votenum.height) / 2;
			this.addChild(votenum);
			// display
			this.mouseChildren = false;
			this.useHandCursor = false;
			this.visible = false;
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		// READ-ONLY VALUES
		
		/**
		 * Vote number reference.
		 */
		public function get num():uint {
			return (this._num);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Display drag stopped.
		 */
		public function dragStop():void {
			if (this._dragging) {
				this._dragging = false;
				this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				FlexGlobals.topLevelApplication.processCommand("voteDrag", this);
			}
		}
		
		// PRIVATE METHODS
		
		/**
		 * Display drag start.
		 */
		private function onMouseDown(evt:MouseEvent):void {
			this._dragging = true;
			this._offsetX = (evt.stageX / FlexGlobals.topLevelApplication.viewScale) - this.x;
			this._offsetY = (evt.stageY / FlexGlobals.topLevelApplication.viewScale) - this.y;
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		/**
		 * Drag object while moving mouse on button down.
		 */
		private function onMouseMove(evt:MouseEvent):void {
			this.x = (evt.stageX / FlexGlobals.topLevelApplication.viewScale) - this._offsetX;
			this.y = (evt.stageY / FlexGlobals.topLevelApplication.viewScale) - this._offsetY;
		}
		
	}

}
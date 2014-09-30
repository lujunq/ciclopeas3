package art.ciclope.mobile {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * MobileSimpleButton provides a simple user interface to be used as button for mobile apps.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class MobileSimpleButton extends Sprite {
		
		// VARIABLES
		
		private var _onclick:Function;
		private var _parameter:*;
		
		/**
		 * MobileSimpleButton constructor.
		 * @param	text	the button text
		 * @param	btwidth	the button width
		 * @param	btheight	the button height
		 * @param	onclick	funtion to call on button click
		 * @param	parameter	a parameter to be sent to the click function
		 * @param	textcolor	the button text color
		 * @param	textfont	the button text font
		 * @param	textsize	the button text size
		 * @param	textbold	if button text bold?
		 * @param	bgcolor	the button background color
		 * @param	bgalpha	the button background alpha
		 */
		public function MobileSimpleButton(text:String, btwidth:uint = 160, btheight:uint = 60, onclick:Function = null, parameter:* = null, textcolor:uint = 0xFFFFFF, textfont:String = "_sans", textsize:uint = 12, textbold:Boolean = true, bgcolor:uint = 0xCCCCCC, bgalpha:Number = 1) {
			// get data
			this._onclick = onclick;
			this._parameter = parameter;
			// draw background
			this.graphics.clear();
			this.graphics.beginFill(bgcolor, bgalpha);
			this.graphics.drawRoundRect(0, 0, btwidth, btheight, 5);
			this.graphics.endFill();
			// draw text
			var intext:TextField = new TextField();
			intext.defaultTextFormat = new TextFormat(textfont, textsize, textcolor, textbold, null, null, null, null, "center");
			intext.text = text;
			intext.width = btwidth;
			intext.selectable = false;
			intext.x = 0;
			intext.y = (btheight - intext.textHeight) / 2;
			this.addChild(intext);
			// action
			this.mouseChildren = false;
			this.buttonMode = true;
			this.useHandCursor = true;
			if (onclick != null) {
				this.addEventListener(MouseEvent.CLICK, onMouseClick);
			}
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			this.removeChildAt(0);
			this.graphics.clear();
			try { this._parameter = null; } catch (e:Error) { }
			if (this._onclick != null) {
				this._onclick = null;
				this.removeEventListener(MouseEvent.CLICK, onMouseClick);
			}
		}
		
		/**
		 * The button was clicked.
		 */
		private function onMouseClick(evt:MouseEvent):void {
			if (this._parameter != null) {
				this._onclick(this._parameter);
			} else {
				this._onclick();
			}
		}
		
	}

}
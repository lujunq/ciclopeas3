package art.ciclope.mobile {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	
	// VECTOR GRAPHICS
	import art.ciclope.resource.BlackCourtain;
	import art.ciclope.resource.WindowBox;
	import art.ciclope.resource.GreenButton;
	import art.ciclope.resource.RedButton;
	import art.ciclope.resource.YellowButton;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * Warn provides a simple warning window meant to mobile applications.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class Warn extends Sprite {
		
		// PRIVATE CONSTANTS
		
		private const BUTTONWIDTH:uint = 100;
		private const BUTTONHEIGHT:uint = 20;
		private const BUTTONTXWIDTH:uint = 80;
		private const BUTTONTXHEIGHT:uint = 20;
		private const BUTTONSPACE:uint = 10;
		
		// VARIABLES
		
		private var _device:MobileDevice;		// device information
		private var _courtain:Sprite;			// courtain background
		private var _box:Sprite;				// message surrounding box
		private var _text:TextField;			// message text output
		private var _okbutton:Sprite;			// ok button
		private var _oktext:TextField;			// text for ok button
		private var _okfunction:Function;		// action for ok button
		private var _cancelbutton:Sprite;		// cancel button
		private var _canceltext:TextField;		// text for cancel button
		private var _cancelfunction:Function;	// action for cancel button
		private var _extrabutton:Sprite;		// extra button
		private var _extratext:TextField;		// text for extra button
		private var _extrafunction:Function;	// action for extra button
		
		/**
		 * Warn constructor.
		 * @param	device	a MobileDevice instance reference
		 * @see	art.ciclope.mobile.MobileDevice
		 */
		public function Warn(device:MobileDevice) {
			// get data
			this._device = device;
			// create graphics
			this._courtain = new BlackCourtain();
			this._courtain.mouseEnabled = false;
			this._courtain.x = this._courtain.y = 0;
			this._courtain.width = this._device.width;
			this._courtain.height = this._device.height;
			this.addChild(this._courtain);
			this._box = new WindowBox();
			this._box.mouseEnabled = false;
			this.addChild(this._box);
			// create text
			this._text = new TextField();
			this._text.mouseEnabled = false;
			this._text.multiline = true;
			this._text.wordWrap = true;
			this._text.embedFonts = false;
			this._text.selectable = false;
			this._text.autoSize = "left";
			this._text.defaultTextFormat = new TextFormat("_sans", 12, 0x000000, true);
			this.addChild(this._text);
			// create ok button
			this._okbutton = new GreenButton();
			this._okbutton.width = BUTTONWIDTH;
			this._okbutton.height = BUTTONHEIGHT;
			this.addChild(this._okbutton);
			this._oktext = new TextField();
			this._oktext.mouseEnabled = false;
			this._oktext.width = BUTTONTXWIDTH;
			this._oktext.selectable = false;
			this._oktext.embedFonts = false;
			this._oktext.defaultTextFormat = new TextFormat("_sans", 12, 0xFFFFFF, true, false, false, null, null, "center");
			this.addChild(this._oktext);
			// create cancel button
			this._cancelbutton = new RedButton();
			this._cancelbutton.width = BUTTONWIDTH;
			this._cancelbutton.height = BUTTONHEIGHT;
			this.addChild(this._cancelbutton);
			this._canceltext = new TextField();
			this._canceltext.mouseEnabled = false;
			this._canceltext.width = BUTTONTXWIDTH;
			this._canceltext.selectable = false;
			this._canceltext.embedFonts = false;
			this._canceltext.defaultTextFormat = new TextFormat("_sans", 12, 0xFFFFFF, true, false, false, null, null, "center");
			this.addChild(this._canceltext);
			// create extra button
			this._extrabutton = new YellowButton();
			this._extrabutton.width = BUTTONWIDTH;
			this._extrabutton.height = BUTTONHEIGHT;
			this.addChild(this._extrabutton);
			this._extratext = new TextField();
			this._extratext.mouseEnabled = false;
			this._extratext.width = BUTTONTXWIDTH;
			this._extratext.selectable = false;
			this._extratext.embedFonts = false;
			this._extratext.defaultTextFormat = new TextFormat("_sans", 12, 0xFFFFFF, true, false, false, null, null, "center");
			this.addChild(this._extratext);
			// assign button actions
			this._okbutton.addEventListener(MouseEvent.CLICK, onOK);
			this._cancelbutton.addEventListener(MouseEvent.CLICK, onCANCEL);
			this._extrabutton.addEventListener(MouseEvent.CLICK, onEXTRA);
		}
		
		/**
		 * Show the warning window.
		 * @param	txt	text to show
		 * @param	oktext	text for ok button (leave blank to hide the green ok button)
		 * @param	okaction	function to run on ok button press
		 * @param	canceltext	text for cancel button (leave blank to hide the red cancel button)
		 * @param	cancelaction	function to run on cancel button press
		 * @param	extratext	text for extra button (leave blank to hide the yellow extra button)
		 * @param	extraaction	function to run on extra button press
		 */
		public function show(txt:String, oktext:String = "", okaction:Function = null, canceltext:String = "", cancelaction:Function = null, extratext:String = "", extraaction:Function = null):void {
			// set and adjust text
			this._text.text = txt;
			this._text.width = 2 * this._device.width / 3;
			if (this._text.width < ((3 * BUTTONWIDTH) + (2 * BUTTONSPACE))) this._text.width = (3 * BUTTONWIDTH) + (2 * BUTTONSPACE);
			this._text.x = (this._device.width - this._text.width) / 2;
			this._box.width = this._text.width + 40;
			// adjust buttons
			var numbuttons:uint = 0;
			if (oktext != "") {
				this._okfunction = okaction;
				this._okbutton.visible = true;
				this._oktext.visible = true;
				this._okbutton.x = this._text.x + this._text.width - BUTTONWIDTH;
				this._oktext.text = oktext;
				this._oktext.x = this._okbutton.x + ((BUTTONWIDTH - BUTTONTXWIDTH) / 2);
				numbuttons++;
			} else {
				this._okbutton.visible = false;
				this._oktext.visible = false;
			}
			if (extratext != "") {
				this._extrafunction = extraaction;
				this._extrabutton.visible = true;
				this._extratext.visible = true;
				this._extrabutton.x = this._text.x + this._text.width - BUTTONWIDTH - (numbuttons * (BUTTONSPACE + BUTTONWIDTH));
				this._extratext.text = extratext;
				this._extratext.x = this._extrabutton.x + ((BUTTONWIDTH - BUTTONTXWIDTH) / 2);
				numbuttons++;
			} else {
				this._extrabutton.visible = false;
				this._extratext.visible = false;
			}
			if (canceltext != "") {
				this._cancelfunction = cancelaction;
				this._cancelbutton.visible = true;
				this._canceltext.visible = true;
				this._cancelbutton.x = this._text.x + this._text.width - BUTTONWIDTH - (numbuttons * (BUTTONSPACE + BUTTONWIDTH));
				this._canceltext.text = canceltext;
				this._canceltext.x = this._cancelbutton.x + ((BUTTONWIDTH - BUTTONTXWIDTH) / 2);
				numbuttons++;
			} else {
				this._cancelbutton.visible = false;
				this._canceltext.visible = false;
			}
			// vertical placement
			if (numbuttons == 0) {
				this._text.y = ((this._device.height - this._text.height) / 2) - 20;
				this._box.height = this._text.textHeight + 40;
			} else {
				this._text.y = ((this._device.height - this._text.height) / 2) - 20 - BUTTONHEIGHT;
				this._box.height = this._text.textHeight + 40 + (2 * BUTTONHEIGHT);
			}
			// place text box
			this._box.x = this._text.x - 20;
			this._box.y = this._text.y - 20;
			// place buttons
			if (numbuttons > 0) {
				this._okbutton.y = this._cancelbutton.y = this._extrabutton.y = this._text.y + this._text.height + (0.5 * BUTTONHEIGHT);
				this._oktext.y = this._canceltext.y = this._extratext.y = this._okbutton.y + ((BUTTONHEIGHT - BUTTONTXHEIGHT) / 2);
			}
		}
		
		/**
		 * Perform OK action.
		 */
		private function onOK(evt:Event):void {
			// save action
			var action:Function = this._okfunction;
			// release actions
			this._okfunction = null;
			this._cancelfunction = null;
			this._extrafunction = null;
			// remove warn window
			parent.removeChild(this);
			// perform action
			if (action != null) action();
		}
		
		/**
		 * Perform CANCEL action.
		 */
		private function onCANCEL(evt:Event):void {
			// save action
			var action:Function = this._cancelfunction;
			// release actions
			this._okfunction = null;
			this._cancelfunction = null;
			this._extrafunction = null;
			// remove warn window
			parent.removeChild(this);
			// perform action
			if (action != null) action();
		}
		
		/**
		 * Perform EXTRA action.
		 */
		private function onEXTRA(evt:Event):void {
			// save action
			var action:Function = this._extrafunction;
			// release actions
			this._okfunction = null;
			this._cancelfunction = null;
			this._extrafunction = null;
			// remove warn window
			parent.removeChild(this);
			// perform action
			if (action != null) action();
		}
		
	}

}
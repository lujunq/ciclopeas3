package art.ciclope.managana.system {
	
	// FLASH PACKAGES
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.display.StageDisplayState;
	import flash.geom.Point;
	
	// CICLOPE CLASSES
	import art.ciclope.managana.graphics.CloseButton;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * HTMLBoxFlashPlayer extends HTMLBox to create a HTML renderer over the Managana interface on flash player.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class HTMLBoxFlashPlayer extends HTMLBox {
		
		// VARIABLES
		
		private var _bg:Shape;				// the background
		private var _close:Sprite;			// close button
		
		// PUBLIC VARIABLES
		
		/**
		 * HTMLBoxFlashPlayer constructor.
		 */
		public function HTMLBoxFlashPlayer(refSize:Point = null) {
			this._bg = new Shape();
			this._bg.graphics.beginFill(0x000000);
			this._bg.graphics.drawRect(0, 0, 100, 100);
			this._bg.graphics.endFill();
			this.addChild(this._bg);
			this._close = new CloseButton() as Sprite;
			this._close.buttonMode = true;
			this._close.useHandCursor = true;
			this._close.addEventListener(MouseEvent.CLICK, onClose);
			this._close.width = this._close.height = 40;
			this.addChild(this._close);
			// assign function for js call
			if (ExternalInterface.available) ExternalInterface.addCallback("ManaganaBoxClose", JSBoxClose);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Open a url.
		 * @param	url	the url to open
		 */
		override public function openURL(url:String):void {
			this.pcode = "";
			this.visible = true;
			if (this.stage.displayState != StageDisplayState.NORMAL) this.stage.displayState = StageDisplayState.NORMAL;
			if (ExternalInterface.available) ExternalInterface.call("showHTMLBox", url);
		}
		
		/**
		 * Function to call for HTML box close.
		 * @param	code	progress code to run after box close
		 */
		private function JSBoxClose(code:String):void {
			// check progress code
			if (code.indexOf("|MANAGANACLOSE|") >= 0) {
				var codeArray:Array = code.split("|MANAGANACLOSE|");
				if (codeArray.length >= 2) {
					this.pcode = String(codeArray[1]).replace(/%3E/gi, ">");
					this.onClose(null);
				}
			}
		}
		
		/**
		 * Click on close button.
		 */
		private function onClose(evt:MouseEvent):void {
			if (ExternalInterface.available) ExternalInterface.call("showManagana");
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
	}

}
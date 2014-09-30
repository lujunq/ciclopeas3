package art.ciclope.mobile {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.display.StageDisplayState;
	import flash.system.Capabilities;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.desktop.NativeApplication;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * MobileAPP extends the standard Sprite class to create base class for a mobile application with common methods required to it. The class is meant to be extended by the initial class of a mobile application.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class MobileAPP extends Sprite {
		
		// VARIABLES
		
		private var _width:Number;				// actual stage width
		private var _height:Number;				// actual stage height
		private var _aspect:String;				// APP start aspect
		private var _desktopfull:Boolean;		// fullscreen while running on desktop machines?
		private var _input:String;				// requested input mode
		private var _indevice:Boolean;			// running on actual device?
		private var _device:MobileDevice;		// device information
		private var _warn:Warn;					// output warning window
		
		/**
		 * MobileAPP constructor.
		 * @param	aspect	app screen aspect
		 * @param	desktopfull	run on full screen if on a personal computer?
		 * @param	inputmode	user input mode
		 */
		public function MobileAPP(aspect:String, desktopfull:Boolean, inputmode:String) {
			// get values
			this._aspect = aspect;
			this._desktopfull = desktopfull;
			this._input = inputmode;
			// wait for stage to become available
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		/**
		 * The stage became available.
		 */
		private function onStage(evt:Event):void {
			// release stage event
			this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			// prepare stage
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, onDeactivate);
			stage.addEventListener(Event.ACTIVATE, onActivate);
			// check for input mode
			if (this._input == MobileDevice.INPUTMULTI) {
				if (Multitouch.supportsGestureEvents) {
					Multitouch.inputMode = MultitouchInputMode.GESTURE;
				} else if (Multitouch.supportsTouchEvents) {
					Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
					this._input = MobileDevice.INPUTTOUCH;
				} else {
					Multitouch.inputMode = MultitouchInputMode.NONE;
					this._input = MobileDevice.INPUTMOUSE;
				}
			} else if (this._input == MobileDevice.INPUTTOUCH) {
				if (Multitouch.supportsTouchEvents) {
					Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
				} else {
					Multitouch.inputMode = MultitouchInputMode.NONE;
					this._input = MobileDevice.INPUTMOUSE;
				}
			}
			// listen to keyboard
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			this.stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			// fullscreen on desktop?
			if (this._desktopfull && !this._indevice) this.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			// check stage size
			if (this.indevice()) {
				this._width = uint(Capabilities.screenResolutionX);
				this._height = uint(Capabilities.screenResolutionY);
			} else {
				this._width = this.stage.stageWidth;
				this._height = this.stage.stageHeight;
			}
			// prepare device information
			this._device = new MobileDevice(this._aspect, this.indevice, this._width, this._height, this._input);
			// prepare warning
			this._warn = new Warn(this._device);
			// start mobile app
			this.start();
		}
		
		/**
		 * Device information reference.
		 */
		public function get device():MobileDevice {
			return (this._device);
		}
		
		/**
		 * Entry point, automatically called when the app is ready to start. Meant to be overriden.
		 */
		public function start():void {
			// do nothing
		}
		
		/**
		 * OnDeactivate is called every time the app is deactivated by OS. Meant to be overriden for custom actions.
		 * @param	evt	standard Event
		 */
		public function onDeactivate(evt:Event):void {
			// do nothing
		}
		
		/**
		 * OnActivate is called every time the app is activated by OS. Meant to be overriden for custom actions.
		 * @param	evt	standard Event
		 */
		public function onActivate(evt:Event):void {
			// do nothing
		}
		
		/**
		 * OnKeyDown is called every time a key is pressed. Meant to be overriden for custom actions.
		 * @param	evt	standard keyboard event
		 */
		public function onKeyDown(evt:KeyboardEvent):void {
			// do nothing
		}
		
		/**
		 * OnKeyUp is called every time a key is released. Meant to be overriden for custom actions.
		 * @param	evt	standard keyboard event
		 */
		public function onKeyUp(evt:KeyboardEvent):void {
			// do nothing
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
		public function showWarn(text:String, oktext:String = "", okaction:Function = null, canceltext:String = "", cancelaction:Function = null, extratext:String = "", extraaction:Function = null):void {
			this._warn.show(text, oktext, okaction, canceltext, cancelaction, extratext, extraaction);
			this.addChild(this._warn);
		}
		
		/**
		 * Running on an actual device?
		 */
		private function indevice():Boolean {
			// check using system manufacturer
			var manufacturer:String = String(Capabilities.manufacturer).toLowerCase();
			var ret:Boolean = false;
			if (manufacturer.search("android") >= 0) ret = true;
			if (manufacturer.search("ios") >= 0) ret = true;
			return (ret);
		}
		
		/**
		 * Internal key down handler.
		 */
		private function keyDown(evt:KeyboardEvent):void {
			// close app on ESC?
			if (this._desktopfull && !this._indevice) {
				if (evt.keyCode == Keyboard.ESCAPE) NativeApplication.nativeApplication.exit();
			}
			// forward event to public listener
			this.onKeyDown(evt);
		}
		
		/**
		 * Internal key up handler.
		 */
		private function keyUp(evt:KeyboardEvent):void {
			// forward event to public listener
			this.onKeyUp(evt);
		}
		
	}

}
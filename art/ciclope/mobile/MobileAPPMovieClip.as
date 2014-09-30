package art.ciclope.mobile {
	
	// FLASH PACKAGES
	import flash.display.MovieClip;
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
	 * MobileAPPMovieClip extends the standard MovieClip class to create base class for a mobile application with common methods required to it. The class is meant to be set as the base class for a Flash fla file.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class MobileAPPMovieClip extends MovieClip {
		
		// VARIABLES
		
		private var _width:Number;				// actual stage width
		private var _height:Number;				// actual stage height
		private var _aspect:String;				// APP start aspect
		private var _desktopfull:Boolean;		// fullscreen while running on desktop machines?
		private var _input:String;				// requested input mode
		private var _indevice:Boolean;			// running on actual device?
		private var _device:MobileDevice;		// device information
		
		/**
		 * MobileAPPMovieClip constructor. 
		 */
		public function MobileAPPMovieClip() { }
		
		/**
		 * Application initialize (mus be called on fla timeline).
		 * @param	aspect	app screen aspect
		 * @param	desktopfull	run in fullscreen if on personal computers?
		 * @param	inputmode	user input mode
		 */
		protected function init(aspect:String, desktopfull:Boolean, inputmode:String):void {
			// get data
			this._aspect = aspect;
			this._desktopfull = desktopfull;
			this._input = inputmode;
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
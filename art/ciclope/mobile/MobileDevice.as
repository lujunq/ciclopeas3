package art.ciclope.mobile {
	
	// FLASH PACKAGES
	import flash.system.Capabilities;
	import flash.ui.Multitouch;
	import flash.events.TransformGestureEvent;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * MobileDevice creates an object capable of providing information about the device the app is running on. Probably the FlexMobileDevice class is a better choice.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 * @see	art.ciclope.mobile.FlexMobileDevice
	 */
	public class MobileDevice {
		
		// CONSTANTS
		
		/**
		 * Stage aspect: landscape.
		 */
		public static const LANDSCAPE:String = "LANDSCAPE";
		/**
		 * Stage aspect: portrait.
		 */
		public static const PORTRAIT:String = "PORTRAIT";
		/**
		 * Input mode: standard mouse click.
		 */
		public static const INPUTMOUSE:String = "INPUTMOUSE";
		/**
		 * Input mode: single touch.
		 */
		public static const INPUTTOUCH:String = "INPUTTOUCH";
		/**
		 * Input mode: multitouch.
		 */
		public static const INPUTMULTI:String = "INPUTMULTI";
		/**
		 * Devise OS: unknown.
		 */
		public static const OSUNKNOWN:String = "OSUNKNOWN";
		/**
		 * Devise OS: windows.
		 */
		public static const OSWINDOWS:String = "OSWINDOWS";
		/**
		 * Devise OS: android.
		 */
		public static const OSANDROID:String = "OSANDROID";
		/**
		 * Devise OS: ios.
		 */
		public static const OSIOS:String = "OSIOS";
		/**
		 * Devise OS: non-anndroid linux (possibly desktop).
		 */
		public static const OSLINUX:String = "OSLINUX";
		/**
		 * Devise OS: macos.
		 */
		public static const OSMACOS:String = "OSMACOS";
		
		// VARIABLES
		
		private var _aspect:String;			// app screen aspect
		private var _indevice:Function;		// running on actual device?
		private var _width:Number;			// stage width
		private var _height:Number;			// stage height
		private var _input:String;			// input mode
		private var _gestures:Array;		// supported gesture events
		
		/**
		 * MobileDevice constructor.
		 * @param	aspect	initial screen aspect
		 * @param	indevice	running on actual device?
		 * @param	dw	app design width
		 * @param	dh	ap design height
		 * @param	input	user input mode
		 */
		public function MobileDevice(aspect:String, indevice:Function, dw:Number, dh:Number, input:String) {	
			// get data
			this._aspect = aspect;
			this._indevice = indevice;
			this._width = dw;
			this._height = dh;
			this._input = input;
			// check for gesture events
			this._gestures = new Array();
			if (this._input == INPUTMULTI) {
				for each (var item:String in Multitouch.supportedGestures) {
					if (item == TransformGestureEvent.GESTURE_PAN)
						this._gestures['pan'] = true;
					else if (item == TransformGestureEvent.GESTURE_ROTATE)
						this._gestures['rotate'] = true;
					else if (item == TransformGestureEvent.GESTURE_SWIPE)
						this._gestures['swipe'] = true;
					else if (item == TransformGestureEvent.GESTURE_ZOOM)
						this._gestures['zoom'] = true;
				}
			} else {
				this._gestures['zoom'] = false;
				this._gestures['pan'] = false;
				this._gestures['rotate'] = false;
				this._gestures['swipe'] = false;
			}
		}
		
		/**
		 * Current screen aspect.
		 */
		public function get aspect():String {
			return (this._aspect);
		}
		
		/**
		 * Running on actual device?
		 */
		public function get indevice():Boolean {
			return (this._indevice());
		}
		
		/**
		 * Stage width.
		 */
		public function get width():Number {
			if (this._aspect == LANDSCAPE) {
				if (this._width > this._height) return(this._width);
					else return(this._height);
			} else {
				if (this._width > this._height) return(this._height);
					else return(this._width);
			}
		}
		
		/**
		 * Stage height.
		 */
		public function get height():Number {
			if (this._aspect == LANDSCAPE) {
				if (this._width > this._height) return(this._height);
					else return(this._width);
			} else {
				if (this._width > this._height) return(this._width);
					else return(this._height);
			}
		}
		
		/**
		 * Player OS.
		 */
		public function get os():String {
			// check using system manufacturer
			var manufacturer:String = String(Capabilities.manufacturer).toLowerCase();
			var ret:String = MobileDevice.OSUNKNOWN;
			if (manufacturer.search("android") >= 0) ret = MobileDevice.OSANDROID;
			if (manufacturer.search("ios") >= 0) ret = MobileDevice.OSIOS;
			if (manufacturer.search("windows") >= 0) ret = MobileDevice.OSWINDOWS;
			if (manufacturer.search("macos") >= 0) ret = MobileDevice.OSMACOS;
			if ((manufacturer.search("linux") >= 0) && (ret != MobileDevice.OSANDROID)) ret = MobileDevice.OSLINUX;
			return (ret);
		}
		
		/**
		 * Screen input mode.
		 */
		public function get inputmode():String {
			return (this._input);
		}
		
		/**
		 * Device supports zoom events?
		 */
		public function get zoom():Boolean {
			return(this._gestures['zoom']);
		}
		
		/**
		 * Device supports pan events?
		 */
		public function get pan():Boolean {
			return(this._gestures['pan']);
		}
		
		/**
		 * Device supports swipe events?
		 */
		public function get swipe():Boolean {
			return(this._gestures['swipe']);
		}
		
		/**
		 * Device supports rotate events?
		 */
		public function get rotate():Boolean {
			return(this._gestures['rotate']);
		}
		
	}

}
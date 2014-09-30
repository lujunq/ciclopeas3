package art.ciclope.mobile {
	
	// FLASH PACKAGES
	import flash.system.Capabilities;
	import flash.display.Stage;
	import flash.display.StageOrientation;
	import flash.display.StageAspectRatio;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.StageOrientationEvent;
	import mx.core.FlexGlobals;
	import flash.events.MouseEvent;
	import flash.utils.*;
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class FlexMobileDevice {
		
		// STATIC CONSTANTS
		
		/**
		 * Device OS: unknown.
		 */
		public static const OSUNKNOWN:String = "OSUNKNOWN";
		/**
		 * Device OS: windows.
		 */
		public static const OSWINDOWS:String = "OSWINDOWS";
		/**
		 * Device OS: android.
		 */
		public static const OSANDROID:String = "OSANDROID";
		/**
		 * Device OS: ios.
		 */
		public static const OSIOS:String = "OSIOS";
		/**
		 * Device OS: non-anndroid linux (possibly desktop).
		 */
		public static const OSLINUX:String = "OSLINUX";
		/**
		 * Device OS: macos.
		 */
		public static const OSMACOS:String = "OSMACOS";
		
		// STATIC VARIABLES/READ-ONLY VALUES
		
		/**
		 * Is user dragging with one finger?
		 */
		public static var dragging:Boolean = false;
		
		/**
		 * Stage aspect to prevent on rotation.
		 */
		public static var preventAspect:String = null;
		
		/**
		 * One finger drag handler (internal).
		 * @private
		 */
		public static var dragHandler:int = 0;
		
		/**
		 * Associative array with functions to call on stage change.
		 */
		public static var stageChange:Array = new Array();
		/**
		 * Stage aspect.
		 */
		public static function get aspect():String {
			if (FlexGlobals.topLevelApplication.stage.stageWidth > FlexGlobals.topLevelApplication.stage.stageHeight) {
				return (StageAspectRatio.LANDSCAPE);
			} else {
				return (StageAspectRatio.PORTRAIT);
			}
		}
		/**
		 * Screen width.
		 */
		public static function get width():Number {
			return (FlexGlobals.topLevelApplication.stage.stageWidth);
		}
		/**
		 * Screen height.
		 */
		public static function get height():Number {
			return (FlexGlobals.topLevelApplication.stage.stageHeight);
		}
		/**
		 * Device operating system (guess).
		 */
		public static function get os():String {
			var manufacturer:String = String(Capabilities.manufacturer).toLowerCase();
			var os:String = FlexMobileDevice.OSUNKNOWN;
			if (manufacturer.search("android") >= 0) os = FlexMobileDevice.OSANDROID;
			if (manufacturer.search("ios") >= 0) os = FlexMobileDevice.OSIOS;
			if (manufacturer.search("windows") >= 0) os = FlexMobileDevice.OSWINDOWS;
			if (manufacturer.search("macos") >= 0) os = FlexMobileDevice.OSMACOS;
			if ((manufacturer.search("linux") >= 0) && (os != FlexMobileDevice.OSANDROID)) os = FlexMobileDevice.OSLINUX;
			return (os);
		}
		/**
		 * Running on an actual device?
		 */
		public static function get indevice():Boolean {
			var manufacturer:String = String(Capabilities.manufacturer).toLowerCase();
			return ((manufacturer.search("android") >= 0) || (manufacturer.search("ios") >= 0));
		}
		/**
		 * The device orientation.
		 */
		public static function get orientation():String {
			return (FlexGlobals.topLevelApplication.stage.orientation);
		}
		
		// STATIC METHODS
		
		/**
		 * Adds a function to stage orientation change event.
		 * @param	action	the function to run on stage orientatcion change (must receive a single StageOrientationEvent parameter)
		 */
		public static function addStageOrientation(action:Function):void {
			FlexGlobals.topLevelApplication.stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, action);
		}
		
		/**
		 * Removes a function from stage orientation change event.
		 * @param	action	a previously add function to stage orientatcion change event
		 */
		public static function removeStageOrientation(action:Function):void {
			FlexGlobals.topLevelApplication.stage.removeEventListener(StageOrientationEvent.ORIENTATION_CHANGE, action);
		}
		
		/**
		 * Write device information using trace.
		 */
		public static function describeTrace():void {
			trace ("Device information");
			trace ("OS: " + FlexMobileDevice.os);
			trace ("running on device? " + FlexMobileDevice.indevice);
			trace ("stage aspect: " + FlexMobileDevice.aspect);
			trace ("device orientation: " + FlexMobileDevice.orientation);
			trace ("screen size: " + FlexMobileDevice.width + "x" + FlexMobileDevice.height);
			trace ("screen x: " + Capabilities.screenResolutionX);
			trace ("screen y: " + Capabilities.screenResolutionY);
		}
		
		/**
		 * Get device information as text.
		 */
		public static function describe():String {
			var ret:String = "Device information<br />";
			ret += "OS: " + FlexMobileDevice.os + "<br />";
			ret += "running on device? " + FlexMobileDevice.indevice + "<br />";
			ret += "stage aspect: " + FlexMobileDevice.aspect + "<br />";
			ret += "device orientation: " + FlexMobileDevice.orientation + "<br />";
			ret += "screen size: " + FlexMobileDevice.width + "x" + FlexMobileDevice.height + "<br />";
			ret += "screen x: " + Capabilities.screenResolutionX  + "<br />";
			ret += "screen y: " + Capabilities.screenResolutionY  + "<br />";
			ret += "stage: " + FlexGlobals.topLevelApplication.stage.stageWidth + "x" + FlexGlobals.topLevelApplication.stage.stageHeight + "<br />";
			return (ret);
		}
		
		/**
		 * Configure mobile app.
		 */
		public static function configure():void {
			// set stage properties
			FlexGlobals.topLevelApplication.stage.align = StageAlign.TOP_LEFT;
			FlexGlobals.topLevelApplication.stage.scaleMode = StageScaleMode.NO_SCALE;
			// check for one finger drag
			FlexGlobals.topLevelApplication.stage.addEventListener(MouseEvent.MOUSE_DOWN, FlexMobileDevice.onMouseDown);
			FlexGlobals.topLevelApplication.stage.addEventListener(MouseEvent.MOUSE_UP, FlexMobileDevice.onMouseUp);
			// check for stage orientation
			FlexGlobals.topLevelApplication.stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGING, FlexMobileDevice.onChanging);
		}
		
		public static function onMouseDown(evt:MouseEvent):void {
			FlexMobileDevice.dragHandler = setTimeout(function():void { FlexMobileDevice.dragging = true; }, 300);
		}
		
		public static function onMouseUp(evt:MouseEvent):void {
			clearTimeout(FlexMobileDevice.dragHandler);
			setTimeout(function():void { FlexMobileDevice.dragging = false; }, 1);
		}
		
		public static function onChanging(evt:StageOrientationEvent):void {
			if (FlexMobileDevice.preventAspect == StageAspectRatio.PORTRAIT) {
				if ((evt.afterOrientation == StageOrientation.DEFAULT) || (evt.afterOrientation == StageOrientation.UPSIDE_DOWN)) {
					evt.preventDefault();
				}
			} else if (FlexMobileDevice.preventAspect == StageAspectRatio.LANDSCAPE) {
				if ((evt.afterOrientation == StageOrientation.ROTATED_LEFT) || (evt.afterOrientation == StageOrientation.ROTATED_RIGHT)) {
					evt.preventDefault();
				}
			}
		}
		

	}

}
package art.ciclope.managana.elements {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * ManaganaWidget creates a basic class to be extended in order to create widgets loadable by the Managana player.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class ManaganaWidget extends Sprite {
		
		// STATIC CONSTANTS
		
		/**
		 * Widget current display state: not visible.
		 */
		public static const DISPLAY_NONE:uint = 0;
		
		/**
		 * Widget current display state: above stream display.
		 */
		public static const DISPLAY_ABOVE:uint = 1;
		
		/**
		 * Widget current display state: below stream display.
		 */
		public static const DISPLAY_BELOW:uint = 2;
		
		/**
		 * Managana player display aspect: landscape.
		 */
		public static const ASPECT_LANDSCAPE:uint = 0;
		
		/**
		 * Managana player display aspect: portrait.
		 */
		public static const ASPECT_PORTRAIT:uint = 1;
		
		// VARIABLES
		
		private var _name:String;									// name given to this widget by Managana player
		private var _display:uint = ManaganaWidget.DISPLAY_NONE;	// current display state according to display constants
		private var _customFunctions:Array = new Array();			// widget's custom functions that doesn't receive parameters
		private var _customFunctionsParam:Array = new Array();		// widget's custom cuntions that receive parameters
		private var _startupFunction:Function;						// function to call on widget load
		private var _displayFunction:Function;						// function to call on widget display change (shown/hidden)
		private var _disposeFunction:Function;						// function to call on widget removal (disposal) from Managana player
		private var _aspectChangeFunction:Function;					// function to call on display aspect (landscape/portrait) change on Managana player
		private var _streamChangeFunction:Function;					// function to call on new stream load
		private var _player:Object;									// a reference to the Managana player object
		
		/**
		 * Widget constructor.
		 */
		public function ManaganaWidget() {
			super();
		}
		
		// READ-ONLY VALUES
		
		/**
		 * Name given to this widget instance by Managana player.
		 */
		protected final function get widgetName():String {
			return (this._name);
		}
		
		/**
		 * Widget's current display state according to display constants.
		 */
		protected final function get displayState():uint {
			return (this._display);
		}
		
		/**
		 * Is the widget currently shown on Managana player?
		 */
		protected final function get isShown():Boolean {
			return (this._display != ManaganaWidget.DISPLAY_NONE);
		}
		
		/**
		 * Current community landscape size in pixels (x and y values).
		 */
		protected final function get landscapeSize():Point {
			return (this._player.currentCommunityLandscapeSize);
		}
		
		/**
		 * Current community portrait size in pixels (x and y values).
		 */
		protected final function get portraitSize():Point {
			return (this._player.currentCommunityPortraitSize);
		}
		
		/**
		 * Current display aspect according to aspect constants.
		 */
		protected final function get displayAspect():uint {
			if (this._player.aspect == 'portrait') return(ManaganaWidget.ASPECT_PORTRAIT);
				else return(ManaganaWidget.ASPECT_LANDSCAPE);
		}
		
		/**
		 * Current community ID.
		 */
		protected final function get community():String {
			return (this._player.currentCommunity);
		}
		
		/**
		 * Current stream ID.
		 */
		protected final function get stream():String {
			return (this._player.currentStream);
		}
		
		/**
		 * A reference to the Managana player object.
		 */
		protected final function get player():Object {
			return (this._player);
		}
		
		// SET-ONLY VALUES
		
		/**
		 * A function to call on widget load - must not receive any parameters.
		 */
		protected final function set startupFunction(to:Function):void {
			this._startupFunction = to;
		}
		
		/**
		 * A function to call on widget display change (shown/hidden) - must not receive any parameters.
		 */
		protected final function set displayFunction(to:Function):void {
			this._displayFunction = to;
		}
		
		/**
		 * A function to call on widget removal (disposal) from Managana player - must not receive any parameters.
		 */
		protected final function set disposeFunction(to:Function):void {
			this._disposeFunction = to;
		}
		
		/**
		 * A function to call on display aspect (landscape/portrait) change on Managana player - must not receive any parameters.
		 */
		protected final function set aspectChangeFunction(to:Function):void {
			this._aspectChangeFunction = to;
		}
		
		/**
		 * A function to call on stream change on Managana player - must not receive any parameters.
		 */
		protected final function set streamChangeFunction(to:Function):void {
			this._streamChangeFunction = to;
		}
		
		// PROTECTED METHODS
		
		/**
		 * Expose a function using the custom methods interface.
		 * @param	name	the name to be used to call the function from Managana
		 * @param	method	a reference to the function
		 * @param	useStringParam	should the function receive a single String parameter?
		 */
		protected final function addCustom(name:String, method:Function, useStringParam:Boolean = false):void {
			if ((name != null) && (name != '') && (method != null)) {
				if (useStringParam) {
					this._customFunctionsParam[name] = method;
				} else {
					this._customFunctions[name] = method;
				}
			}
		}
		
		/**
		 * Send progress code to the Managana player.
		 * @param	pcode	the progress code to run on Managana player
		 * @return	true if the code is well-formated and executed, false otherwise
		 */
		protected final function sendPCode(pcode:String):Boolean {
			return (this._player.pCodeParser.run(pcode));
		}
		
		/**
		 * Hide this widget interface on Managana player.
		 */
		protected final function hideMe():void {
			this.sendPCode('WIDGET->' + this._name + '->hide');
		}
		
		/**
		 * Show this widget interface on Managana player above the stream display.
		 */
		protected final function showMeAbove():void {
			this.sendPCode('WIDGET->' + this._name + '->showAbove');
		}
		
		/**
		 * Show this widget interface on Managana player below the stream display.
		 */
		protected final function showMeBelow():void {
			this.sendPCode('WIDGET->' + this._name + '->showBelow');
		}
		
		// MANAGANA WIDGET INTERFACE PUBLIC METHODS (DO NOT OVERRIDE)
		
		/**
		 * Function called by Managana when the widget is loaded. Do not override.
		 * @param	name	the name given by Managana player to widget instance
		 * @param	managana	a reference to the Managana player object
		 */
		public final function __startup(name:String, managana:Object):void {
			this._name = name;
			this._player = managana;
			if (this._startupFunction != null) this._startupFunction();
		}
		
		/**
		 * Function called by Managana when the widget is add or removed from display. Do not override.
		 * @param	where	new display state according to display constants
		 */
		public final function __display(where:uint):void {
			this._display = where;
			if (this._displayFunction != null) this._displayFunction();
		}
		
		/**
		 * Function called by Managana on display aspect (portrait/landscape) change. Do not override.
		 */
		public final function __aspectChange():void {
			if (this._aspectChangeFunction != null) this._aspectChangeFunction();
		}
		
		/**
		 * Function called by Managana on stream change change. Do not override.
		 */
		public final function __streamChange():void {
			if (this._streamChangeFunction != null) this._streamChangeFunction();
		}
		
		/**
		 * Call a custom function from Managana player. Do not override.
		 * @param	name	the exposed name for the function
		 */
		public final function __callCustom(name:String):void {
			if (this._customFunctions[name] != null) this._customFunctions[name]();
		}
		
		/**
		 * Call a custom function from Managana player, passing a single String parameter. Do not override.
		 * @param	name	the exposed name for the function
		 * @param	param	the String parameter to send to the function
		 */
		public final function __callCustomParam(name:String, param:String):void {
			if (this._customFunctionsParam[name] != null) this._customFunctionsParam[name](param);
		}
		
		/**
		 * Function called by Managana when the widget is unloaded (disposed). Do not override.
		 */
		public final function __dispose():void {
			if (this._disposeFunction != null) this._disposeFunction();
			while (this._customFunctions.length > 0) this._customFunctions.shift();
			while (this._customFunctionsParam.length > 0) this._customFunctionsParam.shift();
			this._customFunctions = null;
			this._customFunctionsParam = null;
			this._name = null;
			this._startupFunction = null;
			this._displayFunction = null;
			this._disposeFunction = null;
			this._aspectChangeFunction = null;
			this._streamChangeFunction = null;
			this._player = null;
		}
		
	}

}
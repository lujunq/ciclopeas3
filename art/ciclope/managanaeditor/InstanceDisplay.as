package art.ciclope.managanaeditor {
	
	// FLASH PACKAGES
	import flash.display.Bitmap;
	import flash.filters.BevelFilter;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.text.StyleSheet;
	import mx.core.FlexGlobals;
	import flash.utils.setTimeout;
	import mx.resources.ResourceManager;
	
	// CICLOPE CLASSES
	import art.ciclope.display.MediaDisplay;
	import art.ciclope.managanaeditor.data.DISInstanceED;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import art.ciclope.managanaeditor.LoadedData;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * InstanceDisplay extends MediaDisplay to show image instances while on Managana Editor.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class InstanceDisplay extends MediaDisplay {
		
		// PUBLIC VARIABLES
		
		/**
		 * The related instance.
		 */
		public var instance:DISInstanceED;
		
		// GRAPHICS
		
		/**
		 * An icon for audio display.
		 */
		[Embed(source="icon/audio-icon.png")]
		private var AudioIcon:Class;
		
		// VARIABLES
		
		private var _dragging:Boolean;					// is the object being dragged?
		private var _dropshadow:DropShadowFilter;		// the dropshadow filter
		private var _bevel:BevelFilter;					// the bevel filter
		private var _blur:BlurFilter;					// the blur filter
		private var _glow:GlowFilter;					// the glow filter
		private var _color:ColorTransform;				// color gain
		private var _offsetX:Number;					// mouse x position on drag start
		private var _offsetY:Number;					// mouse y position on drag stop
		private var _message:MessageDisplay;			// a message to place over "invisible" displays
		private var _window:InstanceDisplayWindow;		// the behind window
		
		// PUBLIC VARIABLES
		
		/**
		 * Display order (for rendering displays on same z value).
		 */
		public var order:uint = 0;
		
		/**
		 * Message to show on not visible instance.
		 */
		public var notVisibleMessage:String = "";
		
		/**
		 * Message to show on no element found.
		 */
		public var noElementMessage:String = "";
		
		/**
		 * InstanceDisplay constrcutor.
		 * @param	instance	the instance reference
		 * @param	notVisible	text to shown when the instance will not be visible while playing
		 * @param	noElement	text to show if no element is found for the instance
		 * @param	style	the current community paragraph text style sheet
		 */
		public function InstanceDisplay(instance:DISInstanceED, notVisible:String, noElement:String, style:StyleSheet) {
			// prepare media display
			this.notVisibleMessage = notVisible;
			this.noElementMessage = noElement;
			super(160, 90, new AudioIcon() as Bitmap);
			// window
			this._window = new InstanceDisplayWindow(instance.width, instance.height, instance.element);
			this._window.visible = false;
			this.bgLayer.addChild(this._window);
			// adjust media display for editor environment
			this.playOnLoad = false;
			this.mouseChildren = false;
			// prepare graphic filters
			this._dropshadow = new DropShadowFilter();
			this._bevel = new BevelFilter();
			this._blur = new BlurFilter();
			this._glow = new GlowFilter();
			this._color = new ColorTransform();
			// invisible message display
			this._message = new MessageDisplay(this.notVisibleMessage);
			this.addChild(this._message);
			// adjust display
			this.instance = instance;
			this.applyInstance();
			// mouse movement
			this._dragging = false;
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.CLICK, onClick);
			// style sheet
			super.setStyle(style);
		}
		
		// PROPERTIES
		
		/**
		 * Display width.
		 */
		override public function get width():Number {
			return (super.width);
		}
		override public function set width(value:Number):void {
			this._message.width = value;
			this._message.x = -value / 2;
			this._window.width = value;
			super.width = value;
		}
		
		/**
		 * Display height.
		 */
		override public function get height():Number {
			return (super.height);
		}
		override public function set height(value:Number):void {
			this._message.height = value;
			this._message.y = -value / 2;
			this._window.height = value;
			super.height = value;
		}
		
		/**
		 * Image visibility (just place a message over it).
		 */
		override public function get visible():Boolean {
			return (!this._message.visible);
		}
		override public function set visible(value:Boolean):void {
			this._message.visible = !value;
			if (!value) this._message.text = this.notVisibleMessage;
		}
		
		/**
		 * Instance shown on editor view?
		 */
		public function get shown():Boolean {
			return (super.visible);
		}
		public function set shown(to:Boolean):void {
			super.visible = to;
		}
		
		/**
		 * Is the instance selected?
		 */
		public function get selected():Boolean {
			return (this._window.visible);
		}
		public function set selected(to:Boolean):void {
			this._window.visible = to;
		}
		
		// PUBLIC METHODS
		
		/**
		 * Set instance to diaplsy no eelement message.
		 */
		public function setNoElement():void {
			this._message.text = this.noElementMessage;
			this._message.visible = true;
		}
		
		/**
		 * Apply related instance properties on display.
		 */
		public function applyInstance():void {
			this.x = this.instance.px;
			this.y = this.instance.py;
			this.z = this.instance.pz;
			this.order = this.instance.order;
			this.width = this.instance.width;
			this.height = this.instance.height;
			this.alpha = this.instance.alpha;
			this.volume = this.instance.volume;
			this.rotationX = this.instance.rx;
			this.rotationY = this.instance.ry;
			this.rotationZ = this.instance.rz;
			this.visible = this.instance.visible;
			this.blendMode = this.instance.blend;
			this.displayMode = this.instance.displayMode;
			this.smoothing = this.instance.smooth;
			this.textBold = this.instance.fontbold;
			this.textItalic = this.instance.fontitalic;
			this.leading = this.instance.leading;
			this.letterSpacing = this.instance.letterSpacing;
			this.maxchars = this.instance.charmax;
			this.textColor = uint(this.instance.fontcolor);
			this.textFont = this.instance.fontface;
			this.textSize = this.instance.fontsize;
			this.textAlign = this.instance.textalign;
			this.applyColor();
			this.applyFilters();
		}
		
		/**
		 * Apply color transformations.
		 */
		public function applyColor():void {
			this._color.redOffset = this.instance.red;
			this._color.greenOffset = this.instance.green;
			this._color.blueOffset = this.instance.blue;
			this._color.alphaMultiplier = this.instance.alpha;
			this.transform.colorTransform = this._color;
		}
		
		/**
		 * Apply selected graphic filters.
		 */
		public function applyFilters():void {
			this._dropshadow.alpha = this.instance.DSFalpha;
			this._dropshadow.angle = this.instance.DSFangle;
			this._dropshadow.blurX = this.instance.DSFblurX;
			this._dropshadow.blurY = this.instance.DSFblurY;
			this._dropshadow.distance = this.instance.DSFdistance;
			this._dropshadow.color = uint(this.instance.DSFcolor);
			this._bevel.angle = this.instance.BVFangle;
			this._bevel.blurX = this.instance.BVFblurX;
			this._bevel.blurY = this.instance.BVFblurY;
			this._bevel.distance = this.instance.BVFdistance;
			this._bevel.highlightAlpha = this.instance.BVFhighlightAlpha;
			this._bevel.shadowAlpha = this.instance.BVFshadowAlpha;
			this._bevel.highlightColor = uint(this.instance.BVFhighlightColor);
			this._bevel.shadowColor = uint(this.instance.BVFshadowColor);
			this._blur.blurX = this.instance.BLFblurX;
			this._blur.blurY = this.instance.BLFblurY;
			this._glow.inner = this.instance.GLFinner;
			this._glow.alpha = this.instance.GLFalpha;
			this._glow.blurX = this.instance.GLFblurX;
			this._glow.blurY = this.instance.GLFblurY;
			this._glow.color = uint(this.instance.GLFcolor);
			this._glow.strength = this.instance.GLFstrength;
			var filters:Array = new Array();
			if (this.instance.DropShadowFilter) filters.push(this._dropshadow);
			if (this.instance.BevelFilter) filters.push(this._bevel);
			if (this.instance.BlurFilter) filters.push(this._blur);
			if (this.instance.GlowFilter) filters.push(this._glow);
			this.filters = filters;
		}
		
		/**
		 * Display drag stopped.
		 */
		public function dragStop():void {
			if (this._dragging) {
				this._dragging = false;
				this.instance.px = this.x;
				this.instance.py = this.y;
				this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}
		}
		
		/**
		 * Release memory used by the object.
		 */
		override public function kill():void {
			this.bgLayer.removeChild(this._window);
			this._window.kill();
			this._window = null;
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.removeEventListener(MouseEvent.CLICK, onClick);
			this.instance = null;
			super.kill();
		}
		
		/**
		 * Display clicked: select it.
		 */
		private function onClick(evt:MouseEvent):void {
			FlexGlobals.topLevelApplication.processCommand("selectImage", this);
		}
		
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
			FlexGlobals.topLevelApplication.processCommand("selectUpdate", this);
		}
		
	}

}
package art.ciclope.sitioeditor {
	
	// FLASH PACKAGES
	import flash.filters.BevelFilter;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import mx.core.FlexGlobals;
	
	// CICLOPE CLASSES
	import art.ciclope.display.MediaDisplay;
	import art.ciclope.sitioeditor.data.DISInstanceED;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import art.ciclope.sitioeditor.LoadedData;
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class InstanceDisplay extends MediaDisplay {
		
		// PUBLIC VARIABLES
		
		/**
		 * The related instance.
		 */
		public var instance:DISInstanceED;
		
		// VARIABLES
		
		private var _dragging:Boolean;					// is the object being dragged?
		private var _dropshadow:DropShadowFilter;		// the dropshadow filter
		private var _bevel:BevelFilter;					// the bevel filter
		private var _blur:BlurFilter;					// the blur filter
		private var _glow:GlowFilter;					// the glow filter
		private var _color:ColorTransform;				// color gain
		
		public function InstanceDisplay(instance:DISInstanceED) {
			// adjust media display for editor environment
			this.playOnLoad = false;
			// prepare graphic filters
			this._dropshadow = new DropShadowFilter();
			this._bevel = new BevelFilter();
			this._blur = new BlurFilter();
			this._glow = new GlowFilter();
			this._color = new ColorTransform();
			// adjust display
			this.instance = instance;
			this.applyInstance();
			// mouse movement
			this._dragging = false;
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Apply related instance properties on display.
		 */
		public function applyInstance():void {
			this.x = this.instance.px;
			this.y = this.instance.py;
			this.z = this.instance.pz;
			this.width = this.instance.width;
			this.height = this.instance.height;
			this.alpha = this.instance.alpha;
			this.volume = this.instance.volume;
			this.rotationX = this.instance.rx;
			this.rotationY = this.instance.ry;
			this.rotationZ = this.instance.rz;
			this.visible = this.instance.visible;
			this.blendMode = this.instance.blend;
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
				this.stopDrag();
				if (this.x != this.getBounds(parent).x) this.x = this.instance.px = this.getBounds(parent).x;
				if (this.y != this.getBounds(parent).y) this.y = this.instance.py = this.getBounds(parent).y;
			}
		}
		
		/**
		 * Release memory used by the object.
		 */
		override public function kill():void {
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.removeEventListener(MouseEvent.CLICK, onClick);
			this.instance = null;
			super.kill();
		}
		
		// EVENT
		
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
			this.startDrag();
		}
		
	}

}
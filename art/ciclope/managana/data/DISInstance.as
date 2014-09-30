package art.ciclope.managana.data {
	
	// FLASH PACKAGES
	import flash.filters.BevelFilter;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	// CICLOPE CLASSES
	import art.ciclope.display.MediaDisplay;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * DISInstance provides information about a keyframe instance on a stream.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class DISInstance {
		
		// VARIABLES
		
		private var _playlist:String;		// the playlist name
		private var _id:String;				// this instance id
		private var _element:String;		// the playlist element to use
		private var _force:Boolean;			// force element change?
		private var _px:int;				// x position
		private var _py:int;				// y position
		private var _pz:int;				// z position
		private var _width:uint;			// width
		private var _height:uint;			// height
		private var _alpha:Number;			// alpha
		private var _play:Boolean;			// start instance playing?
		private var _volume:Number;			// audio volume
		private var _rx:int;				// rotation at x axis
		private var _ry:int;				// rotation at y axis
		private var _rz:int;				// rotation at z axis
		private var _active:Boolean;		// is instance active?
		private var _visible:Boolean;		// visible
		private var _red:uint;				// red gain
		private var _green:uint;			// green gain
		private var _blue:uint;				// blue gain
		private var _blend:String;			// blend mode
		private var _displayMode:String;	// picture display mode: stretch or crop
		private var _smooth:Boolean;		// smooth pictures and videos?
		private var _leading:Object;		// text line leading
		private var _letterSpacing:Object;	// text char spacing
		private var _fontcolor:String;		// font color
		private var _fontbold:Boolean;		// is text bold?
		private var _fontitalic:Boolean;	// is text italic
		private var _fontsize:uint;			// font size
		private var _fontface:String;		// font face name
		private var _textalign:String;		// the text align
		private var _charmax:uint;			// maximum number of chars in text
		private var _transition:String;		// media change transition
		private var _action:String;			// action string
		private var _filters:Array;			// filter array for instance
		
		private var _cssClass:String;		// class for external feeds
		
		// PUBLIC VARIABLES
		
		/**
		 * Display order (for display with same z value).
		 */
		public var order:uint = 0;
		
		/**
		 * DISInstance constructor.
		 * @param	data	the instance xml data reference
		 */
		public function DISInstance(data:XML) {
			// get data
			this._playlist = String(data.@playlist);
			this._id = String(data.@id);
			this._element = String(data.@element);
			this._force = !Boolean(uint(data.@force));
			this._px = int(data.@px);
			this._py = int(data.@py);
			this._pz = int(data.@pz);
			this.order = uint(data.@order);
			this._width = uint(data.@width);
			this._height = uint(data.@height);
			this._rx = int(data.@rx);
			this._ry = int(data.@ry);
			this._rz = int(data.@rz);
			this._alpha = Number(data.@alpha);
			this._volume = Number(data.@volume);
			this._active = Boolean(uint(data.@active));
			this._play = Boolean(uint(data.@play));
			this._visible = Boolean(uint(data.@visible));
			this._red = uint(data.@red);
			this._green = uint(data.@green);
			this._blue = uint(data.@blue);
			this._blend = String(data.@blend);
			this._displayMode = String(data.@crop);
			this._smooth = Boolean(uint(data.@smooth));
			this._leading = int(data.@leading);
			this._letterSpacing = int(data.@spacing);
			this._fontcolor = String(data.@fontcolor);
			this._fontbold = Boolean(uint(data.@bold));
			this._fontitalic = Boolean(uint(data.@italic));
			this._fontsize = uint(data.@fontsize);
			this._fontface = String(data.@font);
			this._charmax = uint(data.@charmax);
			this._transition = String(data.@transition);
			this._action = String(data);
			this._filters = new Array();
			if (Boolean(uint(data.@DropShadowFilter))) {
				var dsFilter:DropShadowFilter = new DropShadowFilter(Number(data.@DSFdistance), Number(data.@DSFangle), uint(data.@DSFcolor), Number(data.@DSFalpha), Number(data.@DSFblurX), Number(data.@DSFblurY));
				this._filters.push(dsFilter);
			}
			if (Boolean(uint(data.@BevelFilter))) {
				var bvFilter:BevelFilter = new BevelFilter(Number(data.@BVFdistance), Number(data.@BVFangle), uint(data.@BVFhighlightColor), Number(data.@BVFhighlightAlpha), uint(data.@BVFshadowColor), Number(data.@BVFshadowAlpha), Number(data.@BVFblurX), Number(data.@BVFblurY));
				this._filters.push(bvFilter);
			}
			if (Boolean(uint(data.@BlurFilter))) {
				var blFilter:BlurFilter = new BlurFilter(Number(data.@BLFblurX), Number(data.@BLFblurY));
				this._filters.push(blFilter);
			}
			if (Boolean(uint(data.@GlowFilter))) {
				var glFilter:GlowFilter = new GlowFilter(uint(data.@GLFcolor), Number(data.@GLFalpha), Number(data.@GLFblurX), Number(data.@GLFblurY), Number(data.@GLFstrength), 1, Boolean(uint(data.@GLFinner)));
				this._filters.push(glFilter);
			}
			// new properties (older Managana files may not have them set)
			if (data.attribute('textalign').length() > 0) {
				this._textalign = String(data.@textalign);
			} else {
				this._textalign = "left";
			}
			if (data.attribute('cssclass').length() > 0) {
				this._cssClass = String(data.@cssclass);
			} else {
				this._cssClass = "";
			}
		}
		
		// READ-ONLY VALUES
		
		/**
		 * Playlist reference identifier.
		 */
		public function get playlist():String {
			return (this._playlist);
		}
		
		/**
		 * Instance identifier.
		 */
		public function get id():String {
			return (this._id);
		}
		
		/**
		 * Playlist element to use.
		 */
		public function get element():String {
			return (this._element);
		}
		
		/**
		 * Blend mode.
		 */
		public function get blend():String {
			return (this._blend);
		}
		
		/**
		 * Instance action string.
		 */
		public function get action():String {
			return (this._action);
		}
		
		/**
		 * Force element change?
		 */
		public function get force():Boolean {
			return (this._force);
		}
		
		/**
		 * Start instance playing?
		 */
		public function get play():Boolean {
			return (this._play);
		}
		
		/**
		 * Is instance active?
		 */
		public function get active():Boolean {
			return (this._active);
		}
		
		/**
		 * Instance visible?
		 */
		public function get visible():Boolean {
			return (this._visible);
		}
		
		/**
		 * X position.
		 */
		public function get x():int {
			return (this._px);
		}
		
		/**
		 * Y position.
		 */
		public function get y():int {
			return (this._py);
		}
		
		/**
		 * Z position.
		 */
		public function get z():int {
			return (this._pz);
		}
		
		/**
		 * Width.
		 */
		public function get width():uint {
			return (this._width);
		}
		
		/**
		 * Height.
		 */
		public function get height():uint {
			return (this._height);
		}
		
		/**
		 * Rotation at X axis.
		 */
		public function get rx():int {
			return (this._rx);
		}
		
		/**
		 * Rotation at Y axis.
		 */
		public function get ry():int {
			return (this._ry);
		}
		
		/**
		 * Rotation at Z axis.
		 */
		public function get rz():int {
			return (this._rz);
		}
		
		/**
		 * Red gain.
		 */
		public function get red():uint {
			return (this._red);
		}
		
		/**
		 * Green gain.
		 */
		public function get green():uint {
			return (this._green);
		}
		
		/**
		 * Blue gain.
		 */
		public function get blue():uint {
			return (this._blue);
		}
		
		/**
		 * Alpha.
		 */
		public function get alpha():Number {
			return (this._alpha);
		}
		
		/**
		 * Audio volume.
		 */
		public function get volume():Number {
			return (this._volume);
		}
		
		/**
		 * Picture display mode (stretch or crop).
		 */
		public function get displayMode():String {
			return(this._displayMode);
		}
		
		/**
		 * Smooth pictures and videos?
		 */
		public function get smooth():Boolean {
			return(this._smooth);
		}
		
		/**
		 * Text line leading.
		 */
		public function get leading():Object {
			return(this._leading);
		}
		
		/**
		 * Text char spacing.
		 */
		public function get letterSpacing():Object {
			return(this._letterSpacing);
		}
		
		/**
		 * Font color.
		 */
		public function get fontColor():uint {
			return(uint(this._fontcolor));
		}
		
		/**
		 * Is text bold?
		 */
		public function get bold():Boolean {
			return(this._fontbold);
		}
		
		/**
		 * Is text italic?
		 */
		public function get italic():Boolean {
			return(this._fontitalic);
		}
		
		/**
		 * Font size.
		 */
		public function get fontSize():uint {
			return(this._fontsize);
		}
		
		/**
		 * Font face name
		 */
		public function get fontFace():String {
			return(this._fontface);
		}
		
		/**
		 * Text alignment.
		 */
		public function get textAlign():String {
			return (this._textalign);
		}
		
		/**
		 * Maximum number of chars in text.
		 */
		public function get maxChars():uint {
			return(this._charmax);
		}
		
		/**
		 * CSS class for external feeds.
		 */
		public function get cssClass():String {
			return (this._cssClass);
		}
		
		/**
		 * Media change transition.
		 */
		public function get transition():String {
			var ret:String = MediaDisplay.TRANSITION_FADE;
			switch (this._transition) {
				case MediaDisplay.TRANSITION_DOWN:
				case MediaDisplay.TRANSITION_FADE:
				case MediaDisplay.TRANSITION_LEFT:
				case MediaDisplay.TRANSITION_NONE:
				case MediaDisplay.TRANSITION_RIGHT:
				case MediaDisplay.TRANSITION_UP:
					ret = this._transition;
					break;
			}
			return (ret);
		}
		
		/**
		 * Graphic filters.
		 */
		public function get filters():Array {
			return (this._filters);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			this._playlist = null;
			this._id = null;
			this._element = null;
			this._blend = null;
			this._displayMode = null;
			this._fontcolor = null;
			this._fontface = null;
			
			while (this._filters.length > 0) {
				this._filters.shift();
			}
			this._filters = null;
			this._textalign = null;
			this._cssClass = null;
		}
		
	}

}

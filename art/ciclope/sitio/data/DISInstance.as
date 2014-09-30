package art.ciclope.sitio.data {
	import flash.filters.BevelFilter;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	/**
	 * ...
	 * @author Lucas Junqueira
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
		private var _rx:uint;				// rotation at x axis
		private var _ry:uint;				// rotation at y axis
		private var _rz:uint;				// rotation at z axis
		private var _active:Boolean;		// is instance active?
		private var _visible:Boolean;		// visible
		private var _red:uint;				// red gain
		private var _green:uint;			// green gain
		private var _blue:uint;				// blue gain
		private var _blend:String;			// blend mode
		private var _action:String;			// action string
		private var _filters:Array;			// filter array for instance
		
		public function DISInstance(data:XML) {
			// get data
			this._playlist = String(data.@playlist);
			this._id = String(data.@id);
			this._element = String(data.@element);
			this._force = Boolean(uint(data.@force));
			this._px = int(data.@px);
			this._py = int(data.@py);
			this._pz = int(data.@pz);
			this._width = uint(data.@width);
			this._height = uint(data.@height);
			this._rx = uint(data.@rx);
			this._ry = uint(data.@ry);
			this._rz = uint(data.@rz);
			this._alpha = Number(data.@alpha);
			this._volume = Number(data.@volume);
			this._active = Boolean(uint(data.@active));
			this._play = Boolean(uint(data.@play));
			this._visible = Boolean(uint(data.@visible));
			this._red = uint(data.@red);
			this._green = uint(data.@green);
			this._blue = uint(data.@blue);
			this._blend = String(data.@blend);
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
		public function get rx():uint {
			return (this._rx);
		}
		
		/**
		 * Rotation at Y axis.
		 */
		public function get ry():uint {
			return (this._ry);
		}
		
		/**
		 * Rotation at Z axis.
		 */
		public function get rz():uint {
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
			while (this._filters.length > 0) {
				this._filters.shift();
			}
			this._filters = null;
		}
		
	}

}

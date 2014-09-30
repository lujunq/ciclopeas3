package art.ciclope.sitio {
	
	// CICLOPE CLASSES
	import art.ciclope.display.MediaDisplay;
	import art.ciclope.event.Playing;
	import art.ciclope.sitio.data.DISElementFile;
	import art.ciclope.sitio.data.DISInstance;
	import art.ciclope.sitio.data.DISPlaylist;
	import art.ciclope.util.ObjectState;
	import art.ciclope.sitio.data.DISFileFormat;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import art.ciclope.display.TextSprite;
	import flash.text.Font;
	import flash.text.StyleSheet;
	import art.ciclope.util.LoadedFile;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class SitioImage extends MediaDisplay {
		
		// STATIC CONSTANTS
		
		/**
		 * The image is appearing.
		 */
		public static const STATE_APPEAR:String = "STATE_APPEAR";
		/**
		 * The image is playing.
		 */
		public static const STATE_PLAY:String = "STATE_PLAY";
		/**
		 * The image is being removed.
		 */
		public static const STATE_REMOVE:String = "STATE_REMOVE";
		
		// VARIABLES
		
		private var _instance:DISInstance;		// image instance definitions
		private var _playlist:DISPlaylist;		// the playlist data
		private var _element:String;			// current playlist element
		private var _options:SitioOptions;		// player configuration
		private var _loadstate:String;			// media file load state
		private var _counter:uint;				// timer count
		private var _playing:Boolean;			// is image on play state?
		private var _color:ColorTransform;		// for color transformations
		private var _currentAction:String;		// current action
		private var _endAction:String;			// action to run on ending
		private var _parser:SitioParser;		// a parser for progress code
		private var _style:StyleSheet;			// CSS StyleSheet for paragraph formatting
		private var _useCache:Boolean;			// use file cache?
		private var _cache:SitioCache;			// cache information
		
		// PUBLIC VARIABLES
		
		/**
		 * Image state.
		 */
		public var state:String;
		/**
		 * Was the playlist information already load?
		 */
		public var loaded:Boolean;
		
		/**
		 * Alpha for tweening.
		 */
		public var toAlpha:Number;
		/**
		 * X for tweening.
		 */
		public var toX:Number;
		/**
		 * Y for tweening.
		 */
		public var toY:Number;
		/**
		 * Z for tweening.
		 */
		public var toZ:Number;
		/**
		 * Rotation X for tweening.
		 */
		public var toRX:Number;
		/**
		 * Rotation Y for tweening.
		 */
		public var toRY:Number;
		/**
		 * Rotation Z for tweening.
		 */
		public var toRZ:Number;
		/**
		 * Width for tweening.
		 */
		public var toWidth:Number;
		/**
		 * Height for tweening.
		 */
		public var toHeight:Number;
		/**
		 * Sound volume for tweening.
		 */
		public var toVolume:Number;
		/**
		 * Red gain for tweening.
		 */
		public var toRed:uint;
		/**
		 * Green gain for tweening.
		 */
		public var toGreen:uint;
		/**
		 * Blue gain for tweening.
		 */
		public var toBlue:uint;
		
		public function SitioImage(instance:DISInstance, options:SitioOptions, parser:SitioParser, usecache:Boolean, cache:SitioCache, style:StyleSheet = null) {
			this._options = options;
			this._instance = instance;
			this.loaded = false;
			this._element = instance.element;
			this.state = SitioImage.STATE_APPEAR;
			this._loadstate = ObjectState.STATE_CLEAN;
			this._counter = 0;
			this._parser = parser;
			this._useCache = usecache;
			this._cache = cache;
			this._style = style;
			super();
			this._playing = instance.play;
			this.playOnLoad = instance.play;
			// adjust display properties
			this.x = this.toX = this._instance.x;
			this.y = this.toY = this._instance.y;
			if (this._instance.z != 0) this.z = this.toZ = this._instance.z;
				else this.toZ = 0;
			if (this._instance.rx != 0) this.rotationX = this.toRX = this._instance.rx;
				else this.toRX = 0;
			if (this._instance.ry != 0) this.rotationY = this.toRY = this._instance.ry;
				else this.toRY = 0;
			if (this._instance.rz != 0) this.rotationZ = this.toRZ = this._instance.rz;
				else this.toRZ = 0;
			this.width = this.toWidth = this._instance.width;
			this.height = this.toHeight = this._instance.height;
			this.alpha = this.toAlpha = this._instance.alpha;
			this.volume = this.toVolume = this._instance.volume;
			this.toRed = this._instance.red;
			this.toGreen = this._instance.green;
			this.toBlue = this._instance.blue;
			this._color = new ColorTransform(1, 1, 1, 1, this._instance.red, this._instance.green, this._instance.blue);
			this.transform.colorTransform = this._color;
			this.visible = this._instance.visible;
			try { this.blendMode = this._instance.blend; } catch (e:Error) { }
			this.filters = this._instance.filters;
			// button actions
			this._currentAction = this._instance.action;
			this._endAction = "";
			this.mouseChildren = false;
			this.buttonMode = true;
			this.useHandCursor = false;
			this.addEventListener(MouseEvent.CLICK, onClick);
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.addEventListener(Playing.MEDIA_END, onMediaEnd);
			this.addEventListener(Playing.MEDIA_LOOP, onMediaEnd);
		}
		
		// READ-ONLY VALUES
		
		/**
		 * The image identifier.
		 */
		public function get id():String {
			return (this._instance.id);
		}
		
		/**
		 * The image playlist identifier.
		 */
		public function get playlistID():String {
			return (this._instance.playlist);
		}
		
		// GET/SET VALUES
		
		/**
		 * The image playlist element shown.
		 */
		public function get element():String {
			return(this._element);
		}
		public function set element(to:String):void {
			if (to != this._element) this.loadFileElement(to);
		}
		
		/**
		 * The image red color gain.
		 */
		public function get red():uint {
			return(this._color.redOffset);
		}
		public function set red(to:uint):void {
			this._color.redOffset = to;
		}
		/**
		 * The image green color gain.
		 */
		public function get green():uint {
			return(this._color.greenOffset);
		}
		public function set green(to:uint):void {
			this._color.greenOffset = to;
		}
		/**
		 * The image blue color gain.
		 */
		public function get blue():uint {
			return(this._color.blueOffset);
		}
		public function set blue(to:uint):void {
			this._color.blueOffset = to;
			// apply all color transformations when the blue component is set
			this.transform.colorTransform = this._color;
		}
		
		// PUBLIC METHODS
		
		/**
		 * release memory used by this object.
		 */
		override public function kill():void {
			this._instance = null;
			this._playlist = null;
			this._element = null;
			this._options = null;
			this._loadstate = null;
			this.state = null;
			this._parser = null;
			this._cache = null;
			this._style = null;
			this.removeEventListener(MouseEvent.CLICK, onClick);
			this.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.removeEventListener(Playing.MEDIA_END, onMediaEnd);
			this.removeEventListener(Playing.MEDIA_LOOP, onMediaEnd);
			super.kill();
		}
		
		/**
		 * Change the instance used by this image.
		 * @param	instance	thew bew instance data
		 */
		public function newInstance(instance:DISInstance):void {
			// playlist change?
			if (this._instance.playlist != instance.playlist) {
				this.loaded = false;
				this._playlist = null;
				this._element = instance.element;
			}
			// get new playlist data
			this._instance = instance;
			// adjust display properties
			if (instance.active) {
				this.toX = this._instance.x;
				this.toY = this._instance.y;
				if (this._instance.z != 0) this.toZ = this._instance.z;
				if (this._instance.rx != 0) this.toRX = this._instance.rx;
				if (this._instance.ry != 0) this.toRY = this._instance.ry;
				if (this._instance.rz != 0) this.toRZ = this._instance.rz;
				this.toWidth = this._instance.width;
				this.toHeight = this._instance.height;
				this.toAlpha = this._instance.alpha;
				this.toVolume = this._instance.volume;
				this.toRed = this._instance.red;
				this.toGreen = this._instance.green;
				this.toBlue = this._instance.blue;
				this._currentAction = this._instance.action;
				// change element?
				if (this._instance.force) {
					// play state
					this._playing = instance.play;
					this.playOnLoad = instance.play;
					if (instance.play) this.play();
						else (this.pause());
					// the element itself
					this.element = this._instance.element;
				}
				// visible?
				this.visible = this._instance.visible;
				// blend mode
				try { this.blendMode = this._instance.blend; } catch (e:Error) { }
				// graphic filters
				this.filters = this._instance.filters;
			}
		}
		
		/**
		 * Apply all tween values to make sure the image is on its desired state.
		 */
		public function endTween():void {
			this.x = this.toX;
			this.y = this.toY;
			if (this.z != this._instance.z) this.z = this.toZ;
			if (this.rotationX != this._instance.rx) this.rotationX = this.toRX;
			if (this.rotationY != this._instance.ry) this.rotationY = this.toRY;
			if (this.rotationZ != this._instance.rz) this.rotationZ = this.toRZ;
			this.width = this.toWidth;
			this.height = this.toHeight;			
			this.volume = this.toVolume;
			this.red = this.toRed;
			this.green = this.toGreen;
			this.blue = this.toBlue;
			this.alpha = this.toAlpha;
		}
		
		/**
		 * Check if recently-loaded playlist contains information about this image.
		 * @param	id	the playlist data
		 */
		public function checkPlaylist(list:DISPlaylist):void {
			if (!this.loaded && (this._instance.playlist == list.id)) {
				this.loaded = true;
				this._playlist = list;
				if (list.state == ObjectState.STATE_LOADOK) {
					this.loadFileElement(this._element);
				} else {
					this.visible = false;
				}
			}
		}
		
		/**
		 * Open the next element on playlist.
		 */
		public function next():void {
			this.loadFileElement(this._playlist.getNextElement(this._element));
		}
		
		/**
		 * Update image timer.
		 */
		public function timerUpdate():void {
			if (this._playing) {
				if (this._playlist != null) {
					this._counter++;
					if (this._counter >= this._playlist.getElement(this._element).time) {
						this._counter = 0;
						if ((this._playlist.getElement(this._element).type != DISFileFormat.MEDIA_VIDEO) && (this._playlist.getElement(this._element).type != DISFileFormat.MEDIA_AUDIO)) {
							if (this._endAction != "") this._parser.run(this._endAction);
							this.next();
						}
					} else {
						this.checkAction(this._counter);
					}
				}
			}
		}
		
		/**
		 * A minimum object with tween information.
		 * @param	time	transition time
		 * @param	transition	transition method
		 * @param	onComplete	function to call on complete
		 * @param	onCompleteParams	parameters to send to complete function
		 * @param	onUpdate	function to call on update
		 * @param	onUpdateParams	parameters to send to update function
		 * @return	an object suited to Caurine Tweener transformation
		 */
		public function tweenObject(time:Number, transition:String = "linear", onComplete:Function = null, onCompleteParams:Array = null, onUpdate:Function = null, onUpdateParams:Array = null):Object {
			var ret:Object = new Object();
			ret.time = time;
			ret.transition = transition;
			if (onComplete != null) {
				ret.onComplete = onComplete;
				if (onCompleteParams != null) ret.onCompleteParams = onCompleteParams;
			}
			if (onUpdate != null) {
				ret.onUpdate = onUpdate;
				if (onUpdateParams != null) ret.onUpdateParams = onUpdateParams;
			}
			if (this.x != this.toX) ret.x = this.toX;
			if (this.y != this.toY) ret.y = this.toY;
			if (this.z != this.toZ) ret.z = this.toZ;
			if (this.rotationX != this.toRX) ret.rotationX = this.toRX;
			if (this.rotationY != this.toRY) ret.rotationY = this.toRY;
			if (this.rotationZ != this.toRZ) ret.rotationZ = this.toRZ;
			if (this.width != this.toWidth) ret.width = this.toWidth;
			if (this.height != this.toHeight) ret.height = this.toHeight;
			if (this.alpha != this.toAlpha) ret.alpha = this.toAlpha;
			if (this.volume != this.toVolume) ret.volume = this.toVolume;
			if ((this.red != this.toRed) || (this.green != this.toGreen) ||  (this.blue != this.toBlue)) {
				ret.red = this.toRed;
				ret.green = this.toGreen;
				ret.blue = this.toBlue;
			}
			return (ret);
		}
		
		// PRIVATE METHODS
		
		/**
		 * Load a media file.
		 * @param	element	the media element identifier
		 * @return	true if media file is found and supported
		 */
		private function loadFileElement(element:String):Boolean {
			if (this._playlist != null) { 
				if (this._playlist.getElement(element) != null) {
					var file:DISElementFile = this._playlist.getElement(element).getFile(this._options.lang, this._options.getPreferred(this._playlist.getElement(element).type));
					if (file.type == "text") {
						var font:Font = SitioFont.getEmbed(file.font, file.fontStyle);
						if (font == null) {
							this.embedOnText = false;
							this.textEmbed = false;
							this.textFont = "_sans";
							this.textBold = ((file.fontStyle == TextSprite.TYPE_BOLD) || (file.fontStyle == TextSprite.TYPE_BOLDITALIC));
							this.textItalic = ((file.fontStyle == TextSprite.TYPE_ITALIC) || (file.fontStyle == TextSprite.TYPE_BOLDITALIC));
							this.textMode = TextSprite.MODE_ARTISTIC;
							this.setText(file.url);
						} else {
							this.embedOnText = true;
							this.textEmbed = true;
							this.textFont = font.fontName;
							this.textBold = ((font.fontStyle == TextSprite.TYPE_BOLD) || (font.fontStyle == TextSprite.TYPE_BOLDITALIC));
							this.textItalic = ((font.fontStyle == TextSprite.TYPE_ITALIC) || (font.fontStyle == TextSprite.TYPE_BOLDITALIC));
							this.textMode = TextSprite.MODE_ARTISTIC;
							this.setText(file.url);
						}
						this._element = element;
						this._loadstate = ObjectState.STATE_LOADOK;
						this._counter = 0;
						this.checkAction(0);
						this._endAction = this._playlist.getElement(element).endAction.code;
						return (true);
					} else if (file.type == "paragraph") {
						this.setStyle(this._style);
						this.textMode = TextSprite.MODE_PARAGRAPH;
						this.setHTMLText(file.url);
						this._element = element;
						this._loadstate = ObjectState.STATE_LOADOK;
						this._counter = 0;
						this.checkAction(0);
						this._endAction = this._playlist.getElement(element).endAction.code;
						return (true);
					} else if (this._options.isSupported(file.type, file.format)) {
						if (this._useCache) {
							if (this._cache.cached(file.type, file.name)) {
								file.setURL(this._cache.folder + "/" + file.type + "/" + file.name);
							}
						}
						this.loadFile(file.url);
						this._element = element;
						this._loadstate = ObjectState.STATE_LOADOK;
						this._counter = 0;
						this.checkAction(0);
						this._endAction = this._playlist.getElement(element).endAction.code;
						return(true);
					} else {
						this._loadstate = ObjectState.STATE_LOADERROR;
						this.visible = false;
						return (false);
					}
				} else {
					return(false);
				}
			} else {
				return (false);
			}
		}
		
		/**
		 * Check for a playlist timed action.
		 * @param	time	the time in seconds
		 */
		private function checkAction(time:uint):void {
			if (this._instance.action == "") {
				if (this._playlist.getElement(element).getAction(time) != null) {
					if (this._playlist.getElement(element).getAction(time).type == "button") {
						this._currentAction = this._playlist.getElement(element).getAction(time).code;
					} else if (this._playlist.getElement(element).getAction(time).type == "do") {
						trace ("do: " + this._playlist.getElement(element).getAction(time).code);
					}
				}
			}
		}
		
		/**
		 * Action on click.
		 */
		private function onClick(evt:MouseEvent):void {
			if (this._currentAction != "") {
				this._parser.run(this._currentAction);
			}
		}
		
		/**
		 * Mouse highlight on.
		 */
		private function onMouseOver(evt:MouseEvent):void {
			if (this._currentAction != "") this.useHandCursor = true;
		}
		
		/**
		 * Mouse highlight off.
		 */
		private function onMouseOut(evt:MouseEvent):void {
			this.useHandCursor = false;
		}
		
		/**
		 * A video or an audio finished playing.
		 */
		private function onMediaEnd(evt:Playing):void {
			if (this._endAction != "") {
				this._parser.run(this._endAction);
			}
		}
		
	}

}
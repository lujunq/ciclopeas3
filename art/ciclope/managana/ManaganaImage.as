package art.ciclope.managana {
	
	// FLASH PACKAGES
	import art.ciclope.event.Loading;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.filters.GradientGlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.text.Font;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	
	// CICLOPE CLASSES
	import art.ciclope.display.MediaDisplay;
	import art.ciclope.event.Playing;
	import art.ciclope.managana.data.DISElementFile;
	import art.ciclope.managana.data.DISInstance;
	import art.ciclope.managana.data.DISPlaylist;
	import art.ciclope.util.ObjectState;
	import art.ciclope.managana.data.DISFileFormat;
	import art.ciclope.display.TextSprite;
	import art.ciclope.managana.feeds.FeedEvent;
	import art.ciclope.managana.feeds.FeedData;
	import art.ciclope.staticfunctions.StringFunctions;
	import art.ciclope.util.LoadedFile;
	import art.ciclope.util.MediaDefinitions;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * ManaganaImage extends MediaDisplay enabling image instance display on Managana player.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class ManaganaImage extends MediaDisplay {
		
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
		private var _options:ManaganaOptions;		// player configuration
		private var _loadstate:String;			// media file load state
		private var _counter:uint;				// timer count
		private var _playing:Boolean;			// is image on play state?
		private var _color:ColorTransform;		// for color transformations
		private var _currentAction:String;		// current action
		private var _endAction:String;			// action to run on ending
		private var _parser:ManaganaParser;		// a parser for progress code
		private var _style:StyleSheet;			// CSS StyleSheet for paragraph formatting
		private var _useCache:Boolean;			// use file cache?
		private var _cache:ManaganaCache;		// cache information
		private var _feeds:ManaganaFeed;		// loaded feed reference	
		private var _webcam:Boolean;			// is image showing a webcam input?
		private var _force:Array;				// forced image properties
		private var _filters:Array;				// image filters before mouse over
		private var _usehighlight:Boolean;		// use glow highlight on mouse over?
		private var _highlight:uint;			// mouse over highlight color
		private var _tween:Object;				// tween object
		private var _mouseover:Boolean;			// is the mouse over the image?
		private var _waitend:uint;				// checking for media end (safety for slower devices)
		private var _lastTime:Number;			// last media time checked (bug for slower devices pausing video playback at the beginning)
		
		
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
		/**
		 * Display order for tweening.
		 */
		public var toOrder:uint = 0;
		
		/**
		 * ManaganaImage constructor.
		 * @param	instance	the instance reference
		 * @param	options	options for Managana player
		 * @param	parser	the progress code parser reference
		 * @param	usecache	use cached playlist information?
		 * @param	cache	cache manager reference
		 * @param	feeds	external feeds manager reference
		 * @param	usehighlight	use highlight on image mouse over?
		 * @param	highlightcolor	the highlight color
		 * @param	style	stylesheet reference for text display
		 */
		public function ManaganaImage(instance:DISInstance, options:ManaganaOptions, parser:ManaganaParser, usecache:Boolean, cache:ManaganaCache, feeds:ManaganaFeed, usehighlight:Boolean, highlightcolor:uint, style:StyleSheet = null) {
			this._options = options;
			this._instance = instance;
			this._tween = new Object();
			this.loaded = false;
			this._element = instance.element;
			this.state = ManaganaImage.STATE_APPEAR;
			this._loadstate = ObjectState.STATE_CLEAN;
			this._counter = 0;
			this._parser = parser;
			this._useCache = usecache;
			this._cache = cache;
			this._feeds = feeds;
			this._usehighlight = usehighlight;
			this._highlight = highlightcolor;
			this._style = style;
			this._filters = new Array();
			this._mouseover = false;
			this._lastTime = 0;
			super();
			this._playing = instance.play;
			this.playOnLoad = instance.play;
			this._webcam = false;
			this._waitend = 0;
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
			this.order = this.toOrder = this._instance.order;
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
			this.smoothing = this._instance.smooth;
			this.displayMode = this._instance.displayMode;
			this.textFont = this._instance.fontFace;
			this.textSize = this._instance.fontSize;
			this.letterSpacing = this._instance.letterSpacing;
			this.leading = this._instance.leading;
			this.textBold = this._instance.bold;
			this.textItalic = this._instance.italic;
			this.maxchars = this._instance.maxChars;
			this.textColor = this._instance.fontColor;
			this.textAlign = this._instance.textAlign;
			this.subtitleEmbed = true;
			if ((this.textAlign == null) || (this.textAlign == 'null')) this.textAlign = "left";
			this.subtitleTextFormat = new TextFormat(this.textFont, this.textSize, this.textColor, this.textBold, this.textItalic, null, null, null, this.textAlign, null, null, null, this.leading);
			this.transition = this._instance.transition;
			this.filters = this._instance.filters;
			// button actions
			this._currentAction = this._instance.action;
			this._endAction = "";
			this.mouseChildren = false;
			this.buttonMode = true;
			//this.useHandCursor = false;
			this.addEventListener(MouseEvent.CLICK, onClick);
			//this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			//this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.addEventListener(Playing.MEDIA_PROGRESS, onMediaUpdate);
			this.addEventListener(Playing.MEDIA_END, onMediaEnd);
			this.addEventListener(Playing.MEDIA_LOOP, onMediaEnd);
			this.addEventListener(Loading.START, onMediaStart);
			// forced properties
			this._force = new Array();
			// look for media change animation finish
			this.addEventListener(Loading.TRANSITION_END, onMediaTransitionEnd);
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
		
		/**
		 * Instance current progress code.
		 */
		public function get progressCode():String {
			return (this._currentAction);
		}
		
		/**
		 * Do the instance has a current action?
		 */
		public function get hasAction():Boolean {
			return (this._currentAction != "");
		}
		
		/**
		 * Image position according to global coordinates.
		 */
		public function get globalPosition():Point {
			return (localToGlobal(new Point(this.x, this.y)));
		}
		
		/**
		 * Image current time (seconds).
		 */
		public function get imageTime():uint {
			if (this._counter >= this.imageTotalTime) {
				return (this.imageTotalTime);
			} else {
				return (this._counter);
			}
		}
		
		/**
		 * Image total time (seconds).
		 */
		public function get imageTotalTime():uint {
			if (this.currentFile == null) {
				return (0);
			} else {
				if (this._playlist != null) {
					if ((this.loadedType != LoadedFile.TYPE_AUDIO) && (this.loadedType != LoadedFile.TYPE_VIDEO)) {
						// element defined time
						if (this._playlist.getElement(this._element) != null) {
							return(this._playlist.getElement(this._element).time);
						} else {
							return (0);
						}
					} else {
						// media time
						return (uint(Math.ceil(this.totalTime)));
					}
				} else {
					return (0);
				}
			}
		}
		
		/**
		 * Is the image on mouse over state?
		 */
		public function get mouseOver():Boolean {
			return (this._mouseover);
		}
		
		// GET/SET VALUES
		
		/**
		 * The image playlist element shown.
		 */
		public function get element():String {
			return(this._element);
		}
		public function set element(to:String):void {
			if (to != this._element) {
				this.loadFileElement(to);
			}
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
		
		/**
		 * Image order (for displays with the same z value).
		 */
		public function get order():Number {
			return (this._instance.order);
		}
		public function set order(to:Number):void {
			this._instance.order = uint(Math.round(to));
		}
		
		// PUBLIC METHODS
		
		/**
		 * Play media.
		 * @param	time	time position to play (-1 for current)
		 * @param	bycode	action requested by progress code?
		 */
		override public function play(time:int = -1, bycode:Boolean = false):void {
			if (this._instance.id != null) {
				// action requested by progress code and media is still loading? start playing after media load complete.
				if (bycode && this.loading) {
					this.addEventListener(Loading.CONTENT_CHANGED, onContentChanged);
				} else {
					// strart playing right now
					super.play(time);
					this._playing = true;
				}
			}
		}
		
		/**
		 * Pause media.
		 */
		override public function pause():void {
			this._playing = false;
			super.pause();
		}
		
		/**
		 * Stop media.
		 */
		override public function stop():void {
			this._playing = false;
			this._counter = 0;
			super.stop();
		}
		
		/**
		 * Jump to a playback time at loaded media.
		 * @param	to	the desired time
		 */
		override public function seek(to:uint):void {
			this._counter = to;
			super.seek(to);
		}
		
		/**
		 * Release memory used by this object.
		 */
		override public function kill():void {
			// waiting for feeds?
			if (this._feeds.hasEventListener(FeedEvent.FEED_READY)) {
				try {
					this._feeds.removeEventListener(FeedEvent.FEED_READY, onFeedReady);
					this._feeds.removeEventListener(FeedEvent.FEED_ERROR, onFeedError);
				} catch (e:Error) { }
			}
			if (this._playlist != null) if (this._playlist.getElement(this._element) != null) {
				var file:DISElementFile = this._playlist.getElement(this._element).getFile(this._options.lang, this._options.getPreferred(this._playlist.getElement(this._element).type));
				var feedData:FeedData;
				if (String(uint(file.url)) == file.url) feedData = this._feeds.getPost(file.feedType, file.feed, uint(file.url));
				if (feedData != null) if (feedData.hasEventListener(FeedEvent.DATA_READY)) {
					try {
						feedData.removeEventListener(FeedEvent.DATA_READY, onFeedData);
					} catch (e:Error) { }
				}
			}
			// clear object
			this.stop();
			this._instance = null;
			this._playlist = null;
			this._element = null;
			this._options = null;
			this._loadstate = null;
			this.state = null;
			this._parser = null;
			this._cache = null;
			this._feeds = null;
			this._style = null;
			this.unforceAll();
			this._force = null;
			while (this._filters.length > 0) this._filters.shift();
			this._filters = null;
			this.removeEventListener(MouseEvent.CLICK, onClick);
			//this.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			//this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.removeEventListener(Playing.MEDIA_PROGRESS, onMediaUpdate);
			this.removeEventListener(Playing.MEDIA_END, onMediaEnd);
			this.removeEventListener(Playing.MEDIA_LOOP, onMediaEnd);
			this.removeEventListener(Loading.START, onMediaStart);
			if (this.hasEventListener(Loading.CONTENT_CHANGED)) this.removeEventListener(Loading.CONTENT_CHANGED, onContentChanged);
			super.kill();
		}
		
		/**
		 * Use the image display to show the system webcam input.
		 */
		public function showWebcam():void {
			this._webcam = true;
			this.loadWebcam();
		}
		
		/**
		 * Return the image display from the webcam to its previous element.
		 */
		public function clearWebcam():void {
			this._webcam = false;
			this.loadFileElement(this._element);
		}
		
		/**
		 * Toggle subtitle display.
		 */
		public function toggleSubtitle():void {
			this.subtitleVisible = !this.subtitleVisible;
		}
		
		/**
		 * Set the current progress code for the image.
		 * @param	to	the new progress code associated with the image instance
		 */
		public function setCode(to:String):void {
			this._currentAction = to;
		}
		
		/**
		 * Change the instance used by this image.
		 * @param	instance	thew new instance data
		 */
		public function newInstance(instance:DISInstance):void {
			// is it a new instance element?
			var newIE:Boolean = true;
			//if (this._instance.element == instance.element) newIE = false;
			if (this._element == instance.element) newIE = false;
			// playlist change?
			if ((this._playlist != null) && (instance != null) && (this._playlist.id != instance.playlist)) {
				this.loaded = false;
				this._playlist = null;
				this._element = instance.element;
				newIE = true;
			}
			// get new playlist data
			this._instance = instance;
			// adjust display properties
			if (instance.active) {
				this.toX = this._instance.x;
				this.toY = this._instance.y;
				if (this._instance.z != this.toZ) this.toZ = this._instance.z;
				if (this._instance.rx != this.toRX) this.toRX = this._instance.rx;
				if (this._instance.ry != this.toRY) this.toRY = this._instance.ry;
				if (this._instance.rz != this.toRZ) this.toRZ = this._instance.rz;
				this.toOrder = this._instance.order;
				this.toWidth = this._instance.width;
				this.toHeight = this._instance.height;
				this.toAlpha = this._instance.alpha;
				this.toVolume = this._instance.volume;
				this.toRed = this._instance.red;
				this.toGreen = this._instance.green;
				this.toBlue = this._instance.blue;
				//if (newIE) this._currentAction = this._instance.action;
				// play state
				if (newIE) this._playing = instance.play;
				this.playOnLoad = instance.play;
				// element
				if (this._force["url"] == null) {
					if (this._force["element"] != null) this.element = this._force["element"];
						else if (this._instance.force) {
							this.element = this._instance.element;
						}
				}
				this._currentAction = this._instance.action;
				if (this._currentAction == "") this.checkAction(0);
				// visible?
				if (this._force["visible"] == null) this.visible = this._instance.visible;
				// blend mode
				if (this._force["blend"] == null) try { this.blendMode = this._instance.blend; } catch (e:Error) { }
				this.smoothing = this._instance.smooth;
				this.displayMode = this._instance.displayMode;
				this.textFont = this._instance.fontFace;
				this.textSize = this._instance.fontSize;
				this.letterSpacing = this._instance.letterSpacing;
				this.leading = this._instance.leading;
				this.textBold = this._instance.bold;
				this.textItalic = this._instance.italic;
				this.maxchars = this._instance.maxChars;
				this.textColor = this._instance.fontColor;
				this.textAlign = this._instance.textAlign;
				this.subtitleEmbed = true;
				this.subtitleTextFormat = new TextFormat(this.textFont, this.textSize, this.textColor, this.textBold, this.textItalic, null, null, null, this.textAlign, null, null, null, this.leading);
				this.transition = this._instance.transition;
				// graphic filters
				this.filters = this._instance.filters;
				if (this._mouseover) this.onMouseOver(null);
			}
		}
		
		/**
		 * Apply all tween values to make sure the image is on its desired state.
		 */
		public function endTween():void {
			for (var index:String in this._tween) {
				if ((index != "transition") && (index != "time") && (index != "onComplete") && (index != "onCompleteParams") && (index != "onUpdate") && (index != "onUpdateParams")) {
					if (this[index] != null) this[index] = this._tween[index];
				}
				if (this.rotationX != 0) if (this.rotationX > 359) this.rotationX -= 360;
				if (this.rotationY != 0) if (this.rotationY > 359) this.rotationY -= 360;
				if (this.rotationZ != 0) if (this.rotationZ > 359) this.rotationZ -= 360;
				delete (this._tween[index]);
			}
		}
		
		/**
		 * Check if recently-loaded playlist contains information about this image.
		 * @param	id	the playlist data
		 */
		public function checkPlaylist(list:DISPlaylist):void {
			if (this._instance.playlist == list.id) {
				if (this._playlist == null) {
					this.loaded = true;
					this._playlist = list;
					if (list.state == ObjectState.STATE_LOADOK) {
						this.loadFileElement(this._element);
					} else {
						this.visible = false;
					}
				}
			}
		}
		
		/**
		 * Open the next element on playlist.
		 */
		public function next():void {
			if (this._force["element"] != null) delete(this._force["element"]);
			if (this._instance.action == "") {
				this._currentAction = "";
			}
			if (!this._webcam) {
				this.loadFileElement(this._playlist.getNextElement(this._element));
				this._force["element"] = this._element;
			}
		}
		
		/**
		 * Open the previous element on playlist.
		 */
		public function previous():void {
			if (this._force["element"] != null) delete(this._force["element"]);
			if (this._instance.action == "") {
				this._currentAction = "";
			}
			if (!this._webcam) {
				this.loadFileElement(this._playlist.getPreviousElement(this._element));
				this._force["element"] = this._element;
			}
		}
		
		
		/**
		 * Force an image property (over instace definitions).
		 * @param	prop	the property to force
		 * @param	value	the value to use
		 */
		public function force(prop:String, value:*):void {
			if (this._force[prop] != null) delete (this._force[prop]);
			switch (prop) {
				case "element": this.element = String(value); break;
				case "url": this.loadFile(String(value)); break;
				case "blend": try { this.blendMode = String(value); } catch (e:Error) { } break;
				case "visible": this.visible = Boolean(value);
			}
			this._force[prop] = value;
		}
		
		/**
		 * Clear a forced property and let image use instance definitions.
		 * @param	prop	the property to unforce
		 */
		public function unforce(prop:String):void {
			if (this._force[prop] != null) delete (this._force[prop]);
		}
		
		/**
		 * Clear all force properties.
		 */
		public function unforceAll():void {
			for (var index:String in this._force) {
				delete (this._force[index]);
			}
		}
		
		/**
		 * Update image timer.
		 */
		public function timerUpdate():void {
			if ((this._playing) && (!this._webcam)) {
				if (this._playlist != null) {
					if ((this.loadedType != LoadedFile.TYPE_AUDIO) && (this.loadedType != LoadedFile.TYPE_VIDEO)) {
						/*if (this.currentFile != null)*/ this._counter++;
						if ((this._playlist.getElement(this._element) != null) && (this._counter >= this._playlist.getElement(this._element).time)) {
							this._counter = 0;
							if (this._endAction != "") {
								this._parser.run(this._endAction);
							}
							this._endAction = "";
							/*if (this._instance.force) {
								// keep the same element
								this._counter = 0;
							} else {*/
								// check for end behavior
								if (this._force["loop"] != null) {
									this._counter = 0;
									this.play();
								} else {
									switch (this._playlist.getElement(this._element).atend) {
										case "stop":
											this._counter = 0;
											this.stop();
											break;
										case "loop":
											this._counter = 0;
											this.play();
											break;
										default: // next
											/*if (this._force["element"] != null) {
												this._counter = 0;
												this.play();
											} else {*/
												this.next();
											//}
											break;
									}
								}
							//}
							// warn listeners
							this.dispatchEvent(new Playing(Playing.MEDIA_END, this, this._instance.id, this.loadedType, this.totalTime, this.totalTime));
						} else {
							this.checkAction(this._counter);
						}
					} else {
						if (this._counter > (this.totalTime - 1)) {
							this._waitend++;
							if (this._waitend > 3) {
								this._counter++;
								this.onMediaUpdate(null);
							}
						}
						// slow systems bug
						if ((this._playing) && (this.loadedType == LoadedFile.TYPE_VIDEO)) {
							if (this._lastTime == this.currentTime) {
								this.play();
							}
							this._lastTime = this.currentTime;
						}
					}
				}
			}
		}
		
		/**
		 * A minimum object with tween information.
		 * @param	time	transition time
		 * @param	distortion	tween distortion
		 * @param	transition	transition method
		 * @param	onComplete	function to call on complete
		 * @param	onCompleteParams	parameters to send to complete function
		 * @param	onUpdate	function to call on update
		 * @param	onUpdateParams	parameters to send to update function
		 * @return	an object suited to Caurine Tweener transformation
		 */
		public function tweenObject(time:Number, distortion:uint = 0, transition:String = "linear", onComplete:Function = null, onCompleteParams:Array = null, onUpdate:Function = null, onUpdateParams:Array = null):Object {
			for (var index:String in this._tween) {
				delete(this._tween[index]);
			}
			this._tween = new Object();
			this._tween.time = time;
			this._tween.transition = transition;
			if (onComplete != null) {
				this._tween.onComplete = onComplete;
				if (onCompleteParams != null) this._tween.onCompleteParams = onCompleteParams;
			}
			if (onUpdate != null) {
				this._tween.onUpdate = onUpdate;
				if (onUpdateParams != null) this._tween.onUpdateParams = onUpdateParams;
			}
			if (this.x != this.toX) this._tween.x = this.toX;
			if (this.y != this.toY) this._tween.y = this.toY;
			if (this.z != this.toZ) this._tween.z = this.toZ;
			if (this.order != this.toOrder) this._tween.order = this.toOrder;
			if (this.rotationX != this.toRX) {
				if (this.toRX < this.rotationX) this.toRX += 360;
				this._tween.rotationX = this.toRX;
			}
			if (this.rotationY != this.toRY) {
				if (this.toRY < this.rotationY) this.toRY += 360;
				this._tween.rotationY = this.toRY;
			}
			if (this.rotationZ != this.toRZ) {
				if (this.toRZ < this.rotationZ) this.toRZ += 360;
				this._tween.rotationZ = this.toRZ;
			}
			if (this.width != this.toWidth) this._tween.width = this.toWidth;
			if (this.height != this.toHeight) this._tween.height = this.toHeight;
			if (this.alpha != this.toAlpha) this._tween.alpha = this.toAlpha;
			if (this.volume != this.toVolume) this._tween.volume = this.toVolume;
			if ((this.red != this.toRed) || (this.green != this.toGreen) ||  (this.blue != this.toBlue)) {
				this._tween.red = this.toRed;
				this._tween.green = this.toGreen;
				this._tween.blue = this.toBlue;
			}
			// distortion
			if (distortion > 0) {
				if (this._tween.x != null) this._tween.x += (distortion * (Math.random() - 0.5) * 4);
					else this._tween.x = this.x + (distortion * (Math.random() - 0.5) * 4);
				if (this._tween.y != null) this._tween.y += (distortion * (Math.random() - 0.5) * 4);
					else this._tween.y = this.y + (distortion * (Math.random() - 0.5) * 4);
				if (this._tween.width != null) this._tween.width += (distortion * (Math.random() - 0.5) * 4);
					else this._tween.width = this.width + (distortion * (Math.random() - 0.5) * 4);
				if (this._tween.height != null) this._tween.height += (distortion * (Math.random() - 0.5) * 4);
					else this._tween.height = this.height + (distortion * (Math.random() - 0.5) * 4);
				var colordist:uint = uint(Math.round(distortion * Math.random() * 10));
				if (this._tween.red != null) this._tween.red += colordist;
					else this._tween.red = this.red + colordist;
				colordist = uint(Math.round(distortion * Math.random() * 10));
				if (this._tween.green != null) this._tween.green += colordist;
					else this._tween.green = this.green + colordist;
				colordist = uint(Math.round(distortion * Math.random() * 10));
				if (this._tween.blue != null) this._tween.blue += colordist;
					else this._tween.blue = this.blue + colordist;
				if (this._tween.red > 255) this._tween.red = 255;
				if (this._tween.green > 255) this._tween.green = 255;
				if (this._tween.blue > 255) this._tween.blue = 255;
			}
			// forced properties
			for (var iforce:String in this._force) {
				switch (iforce) {
					case "x": this._tween.x = int(this._force[iforce]); break;
					case "y": this._tween.y = int(this._force[iforce]); break;
					case "z": this._tween.z = int(this._force[iforce]); break;
					case "order": this._tween.order = int(this._force[iforce]); break;
					case "rx": this._tween.rotationX = int(this._force[iforce]); break;
					case "ry": this._tween.rotationY = int(this._force[iforce]); break;
					case "rz": this._tween.rotationZ = int(this._force[iforce]); break;
					case "width": this._tween.width = int(this._force[iforce]); break;
					case "height": this._tween.height = int(this._force[iforce]); break;
					case "alpha": this._tween.alpha = Number(this._force[iforce]); break;
					case "volume": this._tween.volume = int(this._force[iforce]); break;
					case "red": this._tween.red = int(this._force[iforce]); break;
					case "green": this._tween.green = int(this._force[iforce]); break;
					case "blue": this._tween.blue = int(this._force[iforce]); break;
				}
			}
			return (this._tween);
		}
		
		// PRIVATE METHODS
		
		/**
		 * Load a media file.
		 * @param	element	the media element identifier
		 * @return	true if media file is found and supported
		 */
		private function loadFileElement(element:String):Boolean {
			if (this._instance.action == "") {
				this._currentAction = "";
			}
			if (this._force["element"] == null) {
				if ((this._playlist != null) && (!this._webcam)) { 
					if (this._playlist.getElement(element) != null) {
						this._mouseover = false;
						var file:DISElementFile = this._playlist.getElement(element).getFile(this._options.lang, this._options.getPreferred(this._playlist.getElement(element).type));
						// waiting for feeds?
						if (this._feeds.hasEventListener(FeedEvent.FEED_READY)) {
							try {
								this._feeds.removeEventListener(FeedEvent.FEED_READY, onFeedReady);
								this._feeds.removeEventListener(FeedEvent.FEED_ERROR, onFeedError);
							} catch (e:Error) { }
						}
						var feedData:FeedData;
						if (String(uint(file.url)) == file.url) feedData = this._feeds.getPost(file.feedType, file.feed, uint(file.url));
						if (feedData != null) if (feedData.hasEventListener(FeedEvent.DATA_READY)) {
							try {
								feedData.removeEventListener(FeedEvent.DATA_READY, onFeedData);
							} catch (e:Error) { }
						}
						// check file type
						var font:Font;
						var fontStyle:String;
						if (file.type == "text") {
							this.mouseChildren = false;
							this.textMode = TextSprite.MODE_ARTISTIC;
							fontStyle = TextSprite.TYPE_REGULAR;
							if ((this.textBold) && (this.textItalic)) fontStyle = TextSprite.TYPE_BOLDITALIC;
								else if (this.textBold) fontStyle = TextSprite.TYPE_BOLD;
								else if (this.textItalic) fontStyle = TextSprite.TYPE_ITALIC;
							font = ManaganaFont.getEmbed(this.textFont, fontStyle);
							if (font == null) {
								this.embedOnText = false;
								this.textEmbed = false;
								this.textFont = "_sans";
							} else {
								this.embedOnText = true;
								this.textEmbed = true;
							}
							if (file.feed == "") {
								// load the text provided by the playlist
								this.setText(file.url);
							} else {
								// check for the given feed
								if (this._feeds.isFeed(file.feedType, file.feed)) {
									// is the feed ready?
									if (this._feeds.isReady(file.feedType, file.feed)) {
										if (Number(file.url) < this._feeds.length(file.feedType, file.feed)) {
											feedData = this._feeds.getPost(file.feedType, file.feed, uint(file.url));
											if (feedData != null) {
												if (feedData.ready) {
													this.setText(feedData.getField(file.field));
												} else {
													// wait for the feed data to become available
													feedData.addEventListener(FeedEvent.DATA_READY, onFeedData);
												}
											}
										}
									} else {
										this._feeds.addEventListener(FeedEvent.FEED_READY, onFeedReady);
										this._feeds.addEventListener(FeedEvent.FEED_ERROR, onFeedError);
									}
								}
							}
							this._element = element;
							this._loadstate = ObjectState.STATE_LOADOK;
							this._counter = 0;
							this.checkAction(0);
							this._endAction = this._playlist.getElement(element).endAction.code;
							this.textScrollV = 0;
							return (true);
						} else if (file.type == "paragraph") {
							this.mouseChildren = false;
							this.setStyle(this._style);
							this.textMode = TextSprite.MODE_PARAGRAPH;
							fontStyle = TextSprite.TYPE_REGULAR;
							var pattern:RegExp = /href="http:/gi;
							var theText:String;
							if ((this.textBold) && (this.textItalic)) fontStyle = TextSprite.TYPE_BOLDITALIC;
								else if (this.textBold) fontStyle = TextSprite.TYPE_BOLD;
								else if (this.textItalic) fontStyle = TextSprite.TYPE_ITALIC;
							font = ManaganaFont.getEmbed(this.textFont, fontStyle);
							if (font == null) {
								this.embedOnText = false;
								this.textEmbed = false;
								this.textFont = "_sans";
							} else {
								this.embedOnText = true;
								this.textEmbed = true;
							}
							this._element = element;
							this._loadstate = ObjectState.STATE_LOADOK;
							this._counter = 0;
							this.checkAction(0);
							this._endAction = this._playlist.getElement(element).endAction.code;
							if (file.feed == "") {
								// load the text provided by the playlist
								if (file.format == "html") {
									theText = file.url.replace(pattern, 'href="event:http:');
									this.mouseChildren = (theText.indexOf('href="event') >= 0);
									this.setHTMLText(theText);
								} else {
									this.setText(file.url);
								}
							} else {
								// check for the given feed
								if (this._feeds.isFeed(file.feedType, file.feed)) {
									// if the feed ready?
									if (this._feeds.isReady(file.feedType, file.feed)) {
										if (Number(file.url) < this._feeds.length(file.feedType, file.feed)) {
											feedData = this._feeds.getPost(file.feedType, file.feed, uint(file.url));
											if (feedData != null) {
												if (feedData.ready) {
													theText = feedData.getField(file.field).replace(pattern, 'href="event:http:');
													this.mouseChildren = (theText.indexOf('href="event') >= 0);
													if (this._instance.cssClass != "") this.setHTMLText('<span class="' + this._instance.cssClass + '">' + theText + '</span>');
														else this.setHTMLText(theText);
												} else {
													// wait for the feed data to become available
													feedData.addEventListener(FeedEvent.DATA_READY, onFeedData);
												}
											}
										}
									} else {
										this._feeds.addEventListener(FeedEvent.FEED_READY, onFeedReady);
										this._feeds.addEventListener(FeedEvent.FEED_ERROR, onFeedError);
									}
								}
							}
							this.textScrollV = 0;
							return (true);
						} else if (this._options.isSupported(file.type, file.format)) {
							this.mouseChildren = false;
							if (this._useCache) {
								if (this._cache.cached(file.type, file.name)) {
									file.setURL(this._cache.folder + "/" + file.type + "/" + file.name);
								}
							}
							this._element = element;
							this._loadstate = ObjectState.STATE_LOADOK;
							this._counter = 0;
							this.checkAction(0);
							this._endAction = this._playlist.getElement(element).endAction.code;
							if (file.feed == "") {
								// load the file provided by the playlist
								try {
									this.loadFile(file.url);
								} catch (e:Error) { /* iOS error? */ }
							} else {
								// check for the given feed
								if (this._feeds.isFeed(file.feedType, file.feed)) {
									// if the feed ready?
									if (this._feeds.isReady(file.feedType, file.feed)) {
										if (Number(file.url) < this._feeds.length(file.feedType, file.feed)) {
											feedData = this._feeds.getPost(file.feedType, file.feed, uint(file.url));
											if (feedData != null) {
												if (feedData.ready) {
													this.loadFile(feedData.getField(file.field));
												} else {
													// wait for the feed data to become available
													feedData.addEventListener(FeedEvent.DATA_READY, onFeedData);
												}
											}
										}
									} else {
										this._feeds.addEventListener(FeedEvent.FEED_READY, onFeedReady);
										this._feeds.addEventListener(FeedEvent.FEED_ERROR, onFeedError);
									}
								}
							}
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
				if ((this._playlist != null) && (this.element != null) && (this._instance != null) && (this._instance.id != null)) {
					if ((this._playlist.getElement(element) != null) && (this._playlist.getElement(element).getAction(time) != null)) {
						if (this._playlist.getElement(element).getAction(time).type == "button") {
							this._currentAction = this._playlist.getElement(element).getAction(time).code;
						} else if (this._playlist.getElement(element).getAction(time).type == "do") {
							if (this.state != ManaganaImage.STATE_REMOVE) {
								this._parser.run(this._playlist.getElement(element).getAction(time).code);
							}
						}
					}
				}
				if ((this.loadedType == LoadedFile.TYPE_FLASH) || (this.loadedType == LoadedFile.TYPE_PICTURE) ||(this.loadedType == LoadedFile.TYPE_UNKNOWN)) {
					if (this._currentAction == "") {
						this.mouseChildren = true;
						this.useHandCursor = false;
					} else {
						this.mouseChildren = false;
						this.useHandCursor = true;
					}
				}
			} else {
				this.mouseChildren = false;
				this.useHandCursor = true;
			}
		}
		
		/**
		 * Action on click.
		 */
		public function onClick(evt:MouseEvent = null):void {
			if (this._currentAction != "") {
				this._parser.run(this._currentAction);
				this.useHandCursor = false;
				if ((this._filters != null) && (this._filters.length > 0)) {
					var tempFilters:Array = new Array();
					while (this._filters.length > 0) tempFilters.push(this._filters.shift());
					this.filters = tempFilters;
				} else {
					this.filters = null;
				}
			}
		}
		
		/**
		 * Mouse highlight on.
		 */
		public function onMouseOver(evt:MouseEvent = null):void {
			if (this._currentAction != "") {
				var tempFilters:Array = new Array();
				while (this._filters.length > 0) this._filters.shift();
				if (this._usehighlight) tempFilters.push(new GlowFilter(this._highlight));
				for (var index:uint = 0; index < this.filters.length; index++) {
					this._filters.push(this.filters[index]);
					tempFilters.push(this.filters[index]);
				}
				if (tempFilters.length > 0) this.filters = tempFilters;
			}
			this._mouseover = true;
		}
		
		/**
		 * Mouse highlight off.
		 */
		public function onMouseOut(evt:MouseEvent = null):void {
			if (this._currentAction != "") {
				this.useHandCursor = false;
				if (this._filters.length > 0) {
					var tempFilters:Array = new Array();
					while (this._filters.length > 0) tempFilters.push(this._filters.shift());
					this.filters = tempFilters;
				} else {
					this.filters = null;
				}
			}
			this._mouseover = false;
		}
		
		/**
		 * A media file is about to begin playing.
		 */
		private function onMediaStart(evt:Loading):void {
			this._waitend = 0;
			this._counter = 0;
			if (this.playOnLoad) {
				this.play();
			} else {
				this.pause();
			}
		}
		
		/**
		 * A video or audio updated play status.
		 */
		private function onMediaUpdate(evt:Playing):void {
			if (this._playing) {
				var counter:uint = Math.ceil(this.currentTime);
				while (this._counter < counter) {
					if (this.currentFile != null)  this._counter++;
					this.checkAction(this._counter);
				}
				if (this._playlist != null) if (this._playlist.getElement(this._element).type != "audio") if (this.imageTotalTime > 0) if (this._counter >= this.imageTotalTime) {
					this._counter = 0;
					if (this._endAction != "") {
						this._parser.run(this._endAction);
					}
					// check for end behavior
					if (this._force["loop"] != null) {
						this._counter = 0;
						this.seek(0);
						this.play();
					} else {
						switch (this._playlist.getElement(this._element).atend) {
							case "stop":
								this._counter = 0;
								this.stop();
								break;
							case "loop":
								this._counter = 0;
								this.seek(0);
								this.play();
								break;
							default: // next
								this.next();
								break;
						}
					}
					// warn listeners
					this.dispatchEvent(new Playing(Playing.MEDIA_END, this, this._instance.id, this.loadedType, this.totalTime, this.totalTime));
				}
			}
		}
		
		/**
		 * A video or an audio finished playing.
		 */
		private function onMediaEnd(evt:Playing):void {
			if (this._playlist.getElement(this._element).type == "audio") {
				this._counter = 0;
				if (this._endAction != "") {
					this._parser.run(this._endAction);
				}
				// check for end behavior
				if (this._force["loop"] != null) {
					this._counter = 0;
					this.seek(0);
					this.play();
				} else {
					switch (this._playlist.getElement(this._element).atend) {
						case "stop":
							this._counter = 0;
							this.stop();
							break;
						case "loop":
							this._counter = 0;
							this.seek(0);
							this.play(0);
							break;
						default: // next
							this.next();
							break;
					}
				}
			}
		}
		
		/**
		 * An expected feed failed to load.
		 */
		private function onFeedError(evt:FeedEvent):void {
			var file:DISElementFile = this._playlist.getElement(this._element).getFile(this._options.lang, this._options.getPreferred(this._playlist.getElement(this._element).type));
			if ((evt.feedName == file.feed) && (evt.feedType == file.feedType)) {
				this.removeEventListener(FeedEvent.FEED_READY, onFeedReady);
				this.removeEventListener(FeedEvent.FEED_ERROR, onFeedError);
			}
		}
		
		/**
		 * An expected feed is ready to use.
		 */
		private function onFeedReady(evt:FeedEvent):void {
			var file:DISElementFile = this._playlist.getElement(this._element).getFile(this._options.lang, this._options.getPreferred(this._playlist.getElement(this._element).type));
			if ((evt.feedName == file.feed) && (evt.feedType == file.feedType)) {
				this.removeEventListener(FeedEvent.FEED_READY, onFeedReady);
				this.removeEventListener(FeedEvent.FEED_ERROR, onFeedError);
				// check for post number
				if (Number(file.url) < this._feeds.length(evt.feedType, evt.feedName)) {
					var feedData:FeedData = this._feeds.getPost(evt.feedType, evt.feedName, uint(file.url));
					if (feedData != null) {
						if (feedData.ready) {
							if (file.type == "text") {
								this.setText(StringFunctions.stripTags((feedData.getField(file.field))));
							} else if (file.type == "paragraph") {
								var pattern:RegExp = /href="http:/gi;
								var theText:String;
								theText = feedData.getField(file.field).replace(pattern, 'href="event:http:');
								this.mouseChildren = (theText.indexOf('href="event') >= 0);
								if (this._instance.cssClass != "") this.setHTMLText('<span class="' + this._instance.cssClass + '">' + theText + '</span>');
									else this.setHTMLText(theText);
							} else {
								this.loadFile(feedData.getField(file.field));
							}
						} else {
							// wait for the feed data to become available
							feedData.addEventListener(FeedEvent.DATA_READY, onFeedData);
						}
					}
				}
			}
		}
		
		/**
		 * Data about a feed post is available.
		 */
		private function onFeedData(evt:FeedEvent):void {
			var file:DISElementFile = this._playlist.getElement(this._element).getFile(this._options.lang, this._options.getPreferred(this._playlist.getElement(this._element).type));
			if ((evt.feedName == file.feed) && (evt.feedType == file.feedType)) {
				var feedData:FeedData = this._feeds.getPost(evt.feedType, evt.feedName, uint(file.url));
				if (feedData != null) {
					if (file.type == "text") {
						this.setText(StringFunctions.stripTags((feedData.getField(file.field))));
					} else if (file.type == "paragraph") {
						var pattern:RegExp = /href="http:/gi;
						var theText:String;
						theText = feedData.getField(file.field).replace(pattern, 'href="event:http:');
						this.mouseChildren = (theText.indexOf('href="event') >= 0);
						if (this._instance.cssClass != "") this.setHTMLText('<span class="' + this._instance.cssClass + '">' + theText + '</span>');
							else this.setHTMLText(theText);
					} else {
						this.loadFile(feedData.getField(file.field));
					}
					feedData.removeEventListener(FeedEvent.DATA_READY, onFeedData);
				}
			}
		}
		
		/**
		 * The media transition inside the image finished.
		 */
		private function onMediaTransitionEnd(evt:Loading):void {
			if (this._playing) {
				this.play();
			}
		}
		
		/**
		 * A content waiting to play was just loaded.
		 */
		private function onContentChanged(evt:Loading):void {
			super.play(0);
			this._playing = true;
			this.removeEventListener(Loading.CONTENT_CHANGED, onContentChanged);
		}
		
	}

}
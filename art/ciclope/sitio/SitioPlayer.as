package art.ciclope.sitio {
	
	// FLASH PACKAGES
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.system.System;
	import flash.text.StyleSheet;
	import flash.utils.setInterval;
	
	// CICLOPE CLASSES
	import art.ciclope.event.DISLoad;
	import art.ciclope.sitio.data.DISCommunity;
	import art.ciclope.staticfunctions.DisplayFunctions;
	import art.ciclope.util.ObjectState;
	import art.ciclope.sitio.data.DISInstance;
	import art.ciclope.sitio.data.DISStream;
	import art.ciclope.sitio.data.StreamData;
	import art.ciclope.sitio.transitions.*;
	import art.ciclope.event.Message;
	import art.ciclope.data.TextCache;
	import art.ciclope.display.MediaDisplay;
	import art.ciclope.event.Loading;
	import art.ciclope.util.LoadedFile;
	
	// CAURINA
	import caurina.transitions.Tweener;
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class SitioPlayer extends Sprite {
		
		// VARIABLES
		
		private var _options:SitioOptions;			// player configuration
		private var _community:DISCommunity;		// the DIS community to load data
		private var _width:uint;					// player window width
		private var _height:uint;					// player window height
		private var _originalW:Number;				// player original width
		private var _originalH:Number;				// player original height
		private var _content:Sprite;				// display content
		private var _mask:Shape;					// content mask
		private var _bg:Shape;						// player background
		private var _streamData:Array;				// an array of stream data
		private var _streamSprite:Array;			// an array of stream display containers
		private var _streamImage:Array;				// images used on streams
		private var _currKeyframe:Array;			// the current keyframe
		private var _timer:Timer;					// player timer
		private var _tweentime:Array;				// time for tweens
		private var _tweenmethod:Array;				// method for tweening
		private var _parser:SitioParser;			// parser for progress code
		private var _fonts:SitioFont;				// buint-in fonts
		private var _transitions:Array;				// stream transition animations
		private var _useCache:Boolean;				// use a cache folder?
		private var _cache:SitioCache;				// file cache information
		
		// PUBLIC VARIABLES
		
		/**
		 * CSS StyleSheet for paragraph text rendering.
		 */
		public var textStyle:StyleSheet;
		/**
		 * A stream transition name to use instead the default one. Leave blank or null to use the stream-defined transition.
		 */
		public var transition:String;
		/**
		 * Media transition type.
		 */
		public var mediaTransition:String = MediaDisplay.TRANSITION_FADE;
		/**
		 * Should media background be transparent?
		 */
		public var mediaBGTransparent:Boolean = true;
		/**
		 * Color for media background.
		 */
		public var mediaBGColor:uint = 0x000000;
		/**
		 * Alpha for media background.
		 */
		public var mediaBGAlpha:Number = 1.0;
		/**
		 * Background sprite class for picture media (while loading).
		 */
		public var mediaBGPicture:Class;
		/**
		 * Background sprite class for audio media (while loading).
		 */
		public var mediaBGAudio:Class;
		/**
		 * Background sprite class for video media (while loading).
		 */
		public var mediaBGVideo:Class;
		/**
		 * Stream animation speed to use. Leave 0 to use stream default.
		 */
		public var speed:uint = 0;
		/**
		 * Use embed fonts?
		 */
		public var textEmbed:Boolean = false;
		/**
		 * Automatically switch to device fonts while loading HTML text?
		 */
		public var textDeviceOnHTML:Boolean = true;
		/**
		 * Automatically switch to embed fonts on plain text?
		 */
		public var textEmbedOnPlain:Boolean = false;
		
		public function SitioPlayer(options:SitioOptions = null, width:uint = 160, height:uint = 90, bgcolor:uint = 0, bgalpha:Number = 0.0) {
			// get data
			this._originalW = width;
			this._originalH = height;
			// options
			if (options == null) {
				this._options = new SitioOptions();
			} else {
				this._options = options;
			}
			// fonts
			this._fonts = new SitioFont();
			// prepare data
			this._community = new DISCommunity();
			this._community.addEventListener(DISLoad.COMMUNITY_OK, onCommunityOK);
			this._community.addEventListener(DISLoad.COMMUNITY_ERROR, onCommunityERROR);
			this._community.addEventListener(DISLoad.STREAM_OK, onStreamOK);
			this._community.addEventListener(DISLoad.STREAM_ERROR, onStreamERROR);
			this._community.addEventListener(DISLoad.PLAYLIST_OK, onPlaylistOK);
			this._community.addEventListener(DISLoad.PLAYLIST_ERROR, onPlaylistERROR);
			// graphic container and mask
			this._content = new Sprite();
			this.addChild(this._content);
			this._mask = new Shape();
			this._mask.graphics.beginFill(0);
			this._mask.graphics.drawRect(0, 0, width, height);
			this._mask.graphics.endFill();
			this.addChild(this._mask);
			this._content.x = this._mask.x = -width / 2;
			this._content.y = this._mask.y = -height / 2;
			this._content.mask = this._mask;
			// background
			this._bg = new Shape();
			this._bg.graphics.beginFill(bgcolor);
			this._bg.graphics.drawRect(0, 0, width, height);
			this._bg.graphics.endFill();
			this._bg.alpha = bgalpha;
			this._content.addChild(this._bg);
			// streams
			this._currKeyframe = new Array();
			this._streamData = new Array();
			this._streamSprite = new Array();
			this._streamSprite[DISStream.LEVEL_MAIN] = new Sprite();
			this._streamSprite[DISStream.LEVEL_UP] = new Sprite();
			this._streamSprite[DISStream.LEVEL_DOWN] = new Sprite();
			this._content.addChild(this._streamSprite[DISStream.LEVEL_MAIN]);
			this._content.addChild(this._streamSprite[DISStream.LEVEL_UP]);
			this._content.addChild(this._streamSprite[DISStream.LEVEL_DOWN]);
			this._streamImage = new Array();
			this._streamImage[DISStream.LEVEL_MAIN] = new Array();
			this._streamImage[DISStream.LEVEL_UP] = new Array();
			this._streamImage[DISStream.LEVEL_DOWN] = new Array();
			// transitions
			this.transition = "";
			this._transitions = new Array();
			this._transitions["center"] = new TransitionCENTER(width, height);
			this._transitions["swipeleft"] = new TransitionSWIPELEFT(width, height);
			this._transitions["swiperight"] = new TransitionSWIPERIGHT(width, height);
			this._transitions["swipeup"] = new TransitionSWIPEUP(width, height);
			this._transitions["swipedown"] = new TransitionSWIPEDOWN(width, height);
			this._transitions["fromleft"] = new TransitionFROMLEFT(width, height);
			this._transitions["fromright"] = new TransitionFROMRIGHT(width, height);
			this._transitions["fromup"] = new TransitionFROMUP(width, height);
			this._transitions["fromdown"] = new TransitionFROMDOWN(width, height);
			// size
			this._width = width;
			this._height = height;
			// parser
			this._parser = new SitioParser(this);
			// timer
			this._timer = new Timer(1000);
			this._timer.addEventListener(TimerEvent.TIMER, onTimer);
			this._timer.start();
			// tweens
			this._tweentime = new Array();
			this._tweentime[DISStream.LEVEL_MAIN] = 1;
			this._tweentime[DISStream.LEVEL_UP] = 1;
			this._tweentime[DISStream.LEVEL_DOWN] = 1;
			this._tweenmethod = new Array();
			this._tweenmethod[DISStream.LEVEL_MAIN] = "linear";
			this._tweenmethod[DISStream.LEVEL_UP] = "linear";
			this._tweenmethod[DISStream.LEVEL_DOWN] = "linear";
			// cache
			this._useCache = false;
			this._cache = new SitioCache();
			this._cache.addEventListener(Loading.QUEUE_END, onCacheQueue);
		}
		
		// READ-ONLY VALUES
		
		/**
		 * The loaded stream ID.
		 */
		public function get currentStream():String {
			return (this._streamData[DISStream.LEVEL_MAIN].id);
		}
		
		/**
		 * Community home stream ID.
		 */
		public function get home():String {
			return (this._community.home.id);
		}
		
		// GET/SET VALUES
		
		/**
		 * Player window width.
		 */
		override public function get width():Number {
			return (this._width);
		}
		override public function set width(value:Number):void {
			this._width = uint(value);
			//super.width = width;
			//this._content.x = this._mask.x = -value / 2;
			//this._content.width = this._mask.width = value;
			//this._content.x = this._mask.x = -value / 2;
			//this.scaleX = this._width / this._originalW;
			this._content.scaleX = this._mask.scaleX = this._width / this._originalW;
			this._content.x = this._mask.x = -value / 2;
		}
		
		/**
		 * Player window height.
		 */
		override public function get height():Number {
			return (this._height);
		}
		override public function set height(value:Number):void {
			this._height = uint(value);
			//super.height = height;
			//this._content.y = this._mask.y = -value / 2;
			//this._content.height = this._mask.height = value;
			//this._content.y = this._mask.y = -value / 2;
			//this.scaleY = this._height / this._originalH;
			this._content.scaleY = this._mask.scaleY = this._height / this._originalH;
			this._content.y = this._mask.y = -value / 2;
			//this._content.y = this._mask.y = (-value / 2) / this.scaleY;
		}
		
		/**
		 * Player configuration.
		 */
		public function get options():SitioOptions {
			return (this._options);
		}
		public function set options(to:SitioOptions):void {
			this._options.kill();
			this._options = to;
		}
		
		// PUBLIC METHODS
		
		/**
		 * Set cache properties.
		 * @param	cache	cache folder name
		 * @param	cachedata	first cache configuration
		 */
		public function setCache(cache:String, cachedata:String = null):void {
			this._useCache = true;
			this._cache.setCache(cache, cachedata);
		}
		
		/**
		 * Release memory used by this object.
		 */
		public function kill():void {
			this.textStyle = null;
			this._options.kill();
			this._options = null;
			while (this._content.numChildren > 0) this._content.removeChildAt(0);
			this.removeChild(this._content);
			this._content = null;
			this._mask.graphics.clear();
			this.removeChild(this._mask);
			this._mask = null;
			this._bg.graphics.clear();
			this.removeChild(this._bg);
			this._bg = null;
			for (var istr:String in this._streamData) {
				this._streamData[istr].kill();
				delete(this._streamData[istr]);
			}
			this._streamData = null;
			for (istr in this._streamSprite) {
				while (this._streamSprite[istr].numChildren > 0) this._streamSprite.removeChildAt(0);
				this.removeChild(this._streamSprite[istr]);
				delete(this._streamSprite[istr]);
			}
			this._streamSprite = null;
			for (istr in this._streamImage) {
				this.stopTweens(istr);
				this._streamImage[istr].kill();
				delete(this._streamImage[istr]);
			}
			this._streamImage = null;
			for (istr in this._currKeyframe) {
				delete(this._currKeyframe[istr]);
			}
			this._currKeyframe = null;
			for (istr in this._tweentime) {
				delete(this._tweentime[istr]);
			}
			this._tweentime = null;
			for (istr in this._tweenmethod) {
				delete(this._tweenmethod[istr]);
			}
			this._tweenmethod = null;
			for (istr in this._transitions) {
				this._transitions[istr].kill();
				delete(this._transitions[istr]);
			}
			this._transitions = null;
			this._timer.stop();
			this._timer.removeEventListener(TimerEvent.TIMER, onTimer);
			this._timer = null;
			this._parser.kill();
			this._parser = null;
			this._community.kill();
			this._community = null;
			// a lot of data was released, try to force gc
			System.gc();
		}
		
		/**
		 * Load a community data.
		 * @param	path	the path to the community DIS folder
		 */
		public function loadCommunity(path:String):void {
			this._community.load(path);
		}
		
		/**
		 * Pause current stream playback.
		 */
		public function pause():void {
			var image:SitioImage;
			for each (image in this._streamImage[DISStream.LEVEL_MAIN]) {
				if (Tweener.isTweening(image)) Tweener.pauseTweens(image);
			}
			for each (image in this._streamImage[DISStream.LEVEL_UP]) {
				if (Tweener.isTweening(image)) Tweener.pauseTweens(image);
			}
			for each (image in this._streamImage[DISStream.LEVEL_DOWN]) {
				if (Tweener.isTweening(image)) Tweener.pauseTweens(image);
			}
		}
		
		/**
		 * Play/resume current stream playback.
		 */
		public function play():void {
			var image:SitioImage;
			for each (image in this._streamImage[DISStream.LEVEL_MAIN]) {
				if (Tweener.isTweening(image)) Tweener.resumeTweens(image);
			}
			for each (image in this._streamImage[DISStream.LEVEL_UP]) {
				if (Tweener.isTweening(image)) Tweener.resumeTweens(image);
			}
			for each (image in this._streamImage[DISStream.LEVEL_DOWN]) {
				if (Tweener.isTweening(image)) Tweener.resumeTweens(image);
			}
		}
		
		/**
		 * Load a stream.
		 * @param	id	the stream identifier.
		 */
		public function loadStream(id:String):void {
			this._community.loadStream(id, this._cache.streamCacheData(id));
		}
		
		/**
		 * Run a progress code on loaded stream.
		 * @param	code	the progress code to run
		 * @return	true if the code is valid and was run, false otherwise
		 */
		public function run(code:String):Boolean {
			return(this._parser.run(code));
		}
		
		/**
		 * Send a message to all assigned listeners.
		 * @param	message	the message to send
		 */
		public function send(message:Object):void {
			this.dispatchEvent(new Message(Message.SITIO_MESSAGE, message));
		}
		
		/**
		 * Add a stream to cache download.
		 * @param	id	the id of the stream to cache
		 */
		public function streamCache(id:String):void {
			this._cache.addStream(id);
		}
		
		/**
		 * Add a playlist to cache download.
		 * @param	id	the id of the playlist to cache
		 */
		public function playlistCache(id:String):void {
			this._cache.addPlaylist(id);
		}
		
		// EVENTS
		
		/**
		 * Community loaded.
		 */
		private function onCommunityOK(evt:DISLoad):void {
			// correct content scale
			this._mask.scaleX = this._mask.scaleY = this._content.scaleX = this._content.scaleY = 1;
			this._mask.graphics.beginFill(0);
			this._mask.graphics.drawRect(0, 0, this._community.screenwidth, this._community.screenheight);
			this._mask.graphics.endFill();
			// adjust bg color and alpha
			this._bg.graphics.clear();
			this._bg.graphics.beginFill(this._community.bgcolor);
			this._bg.graphics.drawRect(0, 0, this._community.screenwidth, this._community.screenheight);
			this._bg.graphics.endFill();
			this._bg.alpha = this._community.bgalpha;
			// resize
			this._originalW = this._community.screenwidth;
			this._originalH = this._community.screenheight;
			this.width = this._width;
			this.height = this._height;
			// update transitions
			for (var istr:String in this._transitions) {
				this._transitions[istr].width = this._community.screenwidth;
				this._transitions[istr].height = this._community.screenheight;
			}
			// load home stream
			if (this._community.home.id != "") this.loadStream(this._community.home.id);
			// update cache
			this._cache.community = this._community;
			this._cache.clear();
			this._useCache = false;
			// warn listeners
			this.dispatchEvent(new DISLoad(DISLoad.COMMUNITY_OK, this._community));
		}
		
		/**
		 * Community load error.
		 */
		private function onCommunityERROR(evt:DISLoad):void {
			this.dispatchEvent(new DISLoad(DISLoad.COMMUNITY_ERROR, this._community));
		}
		
		/**
		 * Stream load ok.
		 */
		private function onStreamOK(evt:DISLoad):void {
			var istr:String;
			var index:uint;
			var images:Array;
			var container:Sprite;
			// save stream data for reference
			this._streamData[evt.loader.level] = evt.loader;
			// adjust tweens
			this._tweentime[evt.loader.level] = evt.loader.speed;
			this._tweenmethod[evt.loader.level] = evt.loader.tweening;
			// load keyframe
			this.loadKeyframe(0, evt.loader.level);
			// start animation
			this.stopTweens(evt.loader.level);
			this.startTweens(evt.loader.level);
			// warn listeners
			this.dispatchEvent(new DISLoad(DISLoad.STREAM_OK, this._streamData[evt.loader.level]));
		}
		
		/**
		 * Load a stream keyframe.
		 * @param	num	keyframe number
		 * @param	level	stream level
		 */
		private function loadKeyframe(num:uint, level:String):void {
			var istr:String;
			var index:uint;
			// set transition to use
			var toUse:String = this._streamData[level].fade;
			if (this.transition == null) {
				toUse = this._streamData[level].fade;
			} else if (this.transition != "") {
				toUse = this.transition;
			}
			// mark previous images to be removed
			for (istr in this._streamImage[level]) {
				this._streamImage[level][istr].state = SitioImage.STATE_REMOVE;
			}
			// check image properties
			if (this._streamData[level].keyframes[num] != null) {
				if (this._streamData[level].keyframes[num].instances.length > 0) {
					for (index = 0; index < this._streamData[level].keyframes[num].instances.length; index++) {
						var instance:DISInstance = this._streamData[level].keyframes[num].instances[index];
						if (this._streamImage[level][instance.id] == null) {
							// new images
							this._streamImage[level][instance.id] = new SitioImage(instance, this._options, this._parser, this._useCache, this._cache, this.textStyle);
							this._streamImage[level][instance.id].setBackground(this.mediaBGTransparent, this.mediaBGColor, this.mediaBGAlpha, this.mediaBGPicture, this.mediaBGAudio, this.mediaBGVideo);
							this._streamImage[level][instance.id].transition = this.mediaTransition;
							this._streamImage[level][instance.id].textEmbed = this.textEmbed;
							this._streamImage[level][instance.id].deviceOnHtml = this.textDeviceOnHTML;
							this._streamImage[level][instance.id].embedOnText = this.textEmbedOnPlain;
							this._streamSprite[level].addChild(this._streamImage[level][instance.id]);
							if (this._community.playlists[instance.playlist] != null) {
								if ((this._community.playlists[instance.playlist].state == ObjectState.STATE_LOADOK) || (this._community.playlists[instance.playlist].state == ObjectState.STATE_LOADERROR)) {
									this._streamImage[level][instance.id].checkPlaylist(this._community.playlists[instance.playlist]);
								}
							}
							// set in transition
							if (this._transitions[toUse] != null) {
								this._transitions[toUse].setIN(this._streamImage[level][instance.id]);
							} else {
								// simply fade
								this._streamImage[level][instance.id].alpha = 0;
							}
							this._streamImage[level][instance.id].volume = 0;
						} else {
							// current images
							this._streamImage[level][instance.id].state = SitioImage.STATE_PLAY;
							this._streamImage[level][instance.id].newInstance(instance);
							// re-assign playlist data?
							if (this._community.playlists[instance.playlist] != null) {
								if ((this._community.playlists[instance.playlist].state == ObjectState.STATE_LOADOK) || (this._community.playlists[instance.playlist].state == ObjectState.STATE_LOADERROR)) {
									this._streamImage[level][instance.id].checkPlaylist(this._community.playlists[instance.playlist]);
								}
							}
							
						}
					}
				}
			}
			
			// set animation for images to be removed
			for (istr in this._streamImage[level]) {
				if (this._streamImage[level][istr].state == SitioImage.STATE_REMOVE) {
					if (this._transitions[toUse] != null) {
						this._transitions[toUse].setOUT(this._streamImage[level][istr]);
					} else {
						// simply fade
						this._streamImage[level][istr].toAlpha = 0;
					}
					this._streamImage[level][istr].toVolume = 0;
				}
			}
			
			// sey current keyframe
			this._currKeyframe[level] = num;
		}
		
		/**
		 * Stop any tweens running on selected images.
		 * @param	level	stream level
		 */
		private function stopTweens(level:String):void {
			var image:SitioImage;
			for each (image in this._streamImage[level]) {
				if (Tweener.isTweening(image)) {
					Tweener.removeTweens(image);
					image.endTween();
				}
			}
		}
		
		/**
		 * Start tweens for selected images.
		 * @param	level	stream level
		 */
		private function startTweens(level:String):void {
			var image:SitioImage;
			var found:Boolean = false;
			for each (image in this._streamImage[level]) {
				if (!found) {
					//Tweener.addTween(image, { x: image.toX, y: image.toY, z: image.toZ, rotationX: image.toRX, rotationY: image.toRY, rotationZ: image.toRZ, width: image.toWidth, height: image.toHeight, alpha: image.toAlpha, volume: image.toVolume, red: image.toRed, green: image.toGreen, blue: image.toBlue, time: this._tweentime[level], transition: this._tweenmethod[level], onComplete:streamTweenFinish, onCompleteParams:[level], onUpdate:streamTweenUpdate, onUpdateParams:[level] } );
					if (this.speed > 0) {
						Tweener.addTween(image, image.tweenObject(this.speed, this._tweenmethod[level], streamTweenFinish, [level], streamTweenUpdate, [level]));
					} else {
						Tweener.addTween(image, image.tweenObject(this._tweentime[level], this._tweenmethod[level], streamTweenFinish, [level], streamTweenUpdate, [level]));
					}
					found = true;
				} else {
					//Tweener.addTween(image, { x: image.toX, y: image.toY, z: image.toZ, rotationX: image.toRX, rotationY: image.toRY, rotationZ: image.toRZ, width: image.toWidth, height: image.toHeight, alpha: image.toAlpha, volume: image.toVolume, red: image.toRed, green: image.toGreen, blue: image.toBlue, time: this._tweentime[level], transition: this._tweenmethod[level] } );
					if (this.speed > 0) {
						Tweener.addTween(image, image.tweenObject(this.speed, this._tweenmethod[level]));
					} else {
						Tweener.addTween(image, image.tweenObject(this._tweentime[level], this._tweenmethod[level]));
					}
				}
			}
		}
		
		/**
		 * The keyframe tween was updated.
		 * @param	level	stream level
		 */
		private function streamTweenUpdate(level:String):void {
			// adjust z order
			DisplayFunctions.zSort(this._streamSprite[level]);
		}
		
		/**
		 * The keyframe tween finished.
		 * @param	level	stream level
		 */
		private function streamTweenFinish(level:String):void {
			// warn listeners
			this.dispatchEvent(new DISLoad(DISLoad.KEYFRAME_LOAD, this._streamData[level].keyframes[this._currKeyframe[level]]));
			// stop any tweens at this stream level
			this.stopTweens(level);
			// remove any images not present on keyframe
			for (var istr:String in this._streamImage[level]) {
				if (this._streamImage[level][istr].state == SitioImage.STATE_REMOVE) {
					this._streamSprite[level].removeChild(this._streamImage[level][istr]);
					this._streamImage[level][istr].kill();
					delete(this._streamImage[level][istr]);
				}
			}
			// check for the number of keyframes
			if ((this._streamData[level].keyframes.length > 1) || (this._streamData[level].entropy > 0) || (this._streamData[level].distortion > 0)) {
				// check next keyframe
				var num:int = this._currKeyframe[level] + 1;
				if (num >= this._streamData[level].keyframes.length) num = 0;
				// load keyframe
				this.loadKeyframe(num, level);
				// play tweens
				this.startTweens(level);
			}
		}
		
		/**
		 * Stream load error.
		 */
		private function onStreamERROR(evt:DISLoad):void {
			// warn listeners
			this.dispatchEvent(new DISLoad(DISLoad.STREAM_OK, evt.loader));
		}
		
		/**
		 * Playlist data available
		 */
		private function onPlaylistOK(evt:DISLoad):void {
			// check if images need playlist data
			var image:SitioImage;
			for each (image in this._streamImage[DISStream.LEVEL_MAIN]) image.checkPlaylist(evt.loader);
			for each (image in this._streamImage[DISStream.LEVEL_UP]) image.checkPlaylist(evt.loader);
			for each (image in this._streamImage[DISStream.LEVEL_DOWN]) image.checkPlaylist(evt.loader);
			// warn listeners
			this.dispatchEvent(new DISLoad(DISLoad.PLAYLIST_OK, evt.loader));
		}
		
		/**
		 * Playlist load error.
		 */
		private function onPlaylistERROR(evt:DISLoad):void {
			this.dispatchEvent(new DISLoad(DISLoad.PLAYLIST_ERROR, evt.loader));
		}
		
		/**
		 * Cache system finished a download queue.
		 */
		private function onCacheQueue(evt:Loading):void {
			this.dispatchEvent(new Loading(Loading.QUEUE_END, evt.target, evt.fileName));
		}
		
		/**
		 * Player timer count.
		 */
		private function onTimer(evt:TimerEvent):void {
			// warn every active image about timer
			var image:SitioImage;
			for each (image in this._streamImage[DISStream.LEVEL_MAIN]) image.timerUpdate();
			for each (image in this._streamImage[DISStream.LEVEL_UP]) image.timerUpdate();
			for each (image in this._streamImage[DISStream.LEVEL_DOWN]) image.timerUpdate();
		}
		
		/**
		 * Sort all imagens according to z value.
		 */
		private function zSort():void {
			DisplayFunctions.zSort(this._streamSprite[DISStream.LEVEL_MAIN]);
			DisplayFunctions.zSort(this._streamSprite[DISStream.LEVEL_UP]);
			DisplayFunctions.zSort(this._streamSprite[DISStream.LEVEL_DOWN]);
		}
		
	}

}
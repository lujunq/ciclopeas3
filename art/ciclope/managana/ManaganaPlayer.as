package art.ciclope.managana {
	
	// FLASH PACKAGES
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.media.SoundTransform;
	import flash.printing.PrintJobOptions;
	import flash.printing.PrintJobOrientation;
	import flash.utils.Timer;
	import flash.system.System;
	import flash.text.StyleSheet;
	import flash.utils.setInterval;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.TextEvent;
	import flash.ui.Mouse;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.printing.PrintJob;
	
	// CICLOPE CLASSES
	import art.ciclope.event.DISLoad;
	import art.ciclope.managana.data.DISCommunity;
	import art.ciclope.staticfunctions.DisplayFunctions;
	import art.ciclope.util.ObjectState;
	import art.ciclope.managana.data.DISInstance;
	import art.ciclope.managana.data.DISStream;
	import art.ciclope.managana.data.StreamData;
	import art.ciclope.managana.transitions.*;
	import art.ciclope.event.Message;
	import art.ciclope.data.TextCache;
	import art.ciclope.display.MediaDisplay;
	import art.ciclope.event.Loading;
	import art.ciclope.managana.data.DISFileFormat;
	import art.ciclope.staticfunctions.StringFunctions;
	import art.ciclope.managana.graphics.VoteDisplay;
	import art.ciclope.event.CustomEvent;
	import art.ciclope.event.Playing;
	import art.ciclope.managana.graphics.Target;
	import art.ciclope.managana.data.HistoryData;
	
	// CAURINA
	import caurina.transitions.Tweener;
	
	// EVENTS
	
	/**
     * The player aks to open an url on the browser.
     */
    [Event( name = "OPENURL", type = "art.ciclope.event.Message" )]
    /**
     * Sharing on Facebook is requested.
     */
    [Event( name = "SHARE_FACEBOOK", type = "art.ciclope.event.Message" )]
    /**
     * Sharing on Twitter is requested.
     */
    [Event( name = "SHARE_TWITTER", type = "art.ciclope.event.Message" )]
    /**
     * Sharing on Google+ is requested.
     */
    [Event( name = "SHARE_GPLUS", type = "art.ciclope.event.Message" )]
    /**
     * A custom message is available.
     */
    [Event( name = "MESSAGE", type = "art.ciclope.event.Message" )]
    /**
     * The playback was paused.
     */
    [Event( name = "MEDIA_PAUSE", type = "art.ciclope.event.Playing" )]
    /**
     * The playback resumed playing.
     */
    [Event( name = "MEDIA_PLAY", type = "art.ciclope.event.Playing" )]
    /**
     * A dis folder community was correctly loaded.
     */
    [Event( name = "COMMUNITY_OK", type = "art.ciclope.event.DISLoad" )]
    /**
     * A dis folder community load failed.
     */
    [Event( name = "COMMUNITY_ERROR", type = "art.ciclope.event.DISLoad" )]
    /**
     * A dis folder community started to load.
     */
    [Event( name = "COMMUNITY_LOAD", type = "art.ciclope.event.DISLoad" )]
    /**
     * A dis folder stream was correctly loaded.
     */
    [Event( name = "STREAM_OK", type = "art.ciclope.event.DISLoad" )]
    /**
     * A dis folder stream started to load.
     */
    [Event( name = "STREAM_LOAD", type = "art.ciclope.event.DISLoad" )]
    /**
     * A dis folder stream keyframe was played.
     */
    [Event( name = "KEYFRAME_LOAD", type = "art.ciclope.event.DISLoad" )]
    /**
     * A dis folder stream failed to load.
     */
    [Event( name = "STREAM_ERROR", type = "art.ciclope.event.DISLoad" )]
    /**
     * A dis folder playlist was correctly loaded.
     */
    [Event( name = "PLAYLIST_OK", type = "art.ciclope.event.DISLoad" )]
    /**
     * A dis folder playlist was failed to load.
     */
    [Event( name = "PLAYLIST_ERROR", type = "art.ciclope.event.DISLoad" )]
    /**
     * The cache queue was completely downloaded.
     */
    [Event( name = "QUEUE_END", type = "art.ciclope.event.Loading" )]
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * ManaganaPlayer creates a player capable of loading and playing dis folder contents.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class ManaganaPlayer extends Sprite {
		
		// VARIABLES
		
		private var _options:ManaganaOptions;		// player configuration
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
		private var _parser:ManaganaParser;			// parser for progress code
		private var _fonts:ManaganaFont;			// buint-in fonts
		private var _transitions:Array;				// stream transition animations
		private var _useCache:Boolean;				// use a cache folder?
		private var _cache:ManaganaCache;			// file cache information
		private var _feeds:ManaganaFeed;			// external feed information
		private var _holdvolume:Number;				// sound volume to exchange on mute operation
		private var _feedurl:String;				// the url to look for external feeds
		private var _playing:Boolean;				// is current stream playing?
		private var _counter:uint;					// stream time counter
		private var _loading:Boolean;				// is player loading a stream?
		private var _keyfcount:uint;				// number of played keyframes
		private var _votes:Array;					// stream vote displays
		private var _voteLayer:Sprite;				// stream vote display layer
		private var _totalVotes:uint;				// total number of votes received by the current stream
		private var _voted:Boolean;					// did the current stream received a vote on current session?
		private var _endOfStream:Boolean;			// is the stream end time reached (for vote checking)
		private var _lastVote:uint;					// the last recorded vote
		private var _hasVote:Boolean;				// did the stream actually receive votes?
		private var _target:Target;					// the target
		private var _allowKeyboard:Boolean;			// allow keyboard interactions?
		private var _history:Array;					// navigation history
		private var _historyStep:uint;				// navigation history step
		private var _type:String;					// player type
		
		// STATIC CONSTANTS
		
		/**
		 * Managana player internal version number.
		 */
		public static const VERSION:uint = 5;	// 1.5.0
		
		/**
		 * Player type: unknown.
		 */
		public static const TYPE_UNKNOWN:String = "unknown";
		/**
		 * Player type: web (flash player).
		 */
		public static const TYPE_WEB:String = "web";
		/**
		 * Player type: mobile.
		 */
		public static const TYPE_MOBILE:String = "mobile";
		/**
		 * Player type: desktop.
		 */
		public static const TYPE_DESKTOP:String = "desktop";
		/**
		 * Player type: showtime.
		 */
		public static const TYPE_SHOWTIME:String = "showtime";
		
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
		/**
		 * An url for stream sharing on social networks.
		 */
		public var shareurl:String = "";
		/**
		 * An initial stream to load when a community is ready, instead the home.
		 */
		public var startStream:String = "";
		/**
		 * The server url.
		 */
		public var serverurl:String = "";
		/**
		 * A keyframe number to force on next keyframe change (leave < 0 to follow standard stream flow).
		 */
		public var nextKeyframe:int = -1;
		/**
		 * Is an user logged?
		 */
		public var usrLogged:Boolean = false;
		/**
		 * A function to check for alternative (local) communities path.
		 */
		public var checkPath:Function;
		/**
		 * A function to save and load user variables on disk.
		 */
		public var localUserData:Function;
		/**
		 * A function to send messages to the associated ManaganaInterface object.
		 */
		public var interfaceMessage:Function;
		/**
		 * Allow content printing?
		 */
		public var allowPrinting:Boolean = true;
		/**
		 * Allow content drag?
		 */
		public var allowDrag:Boolean = true;
		
		/**
		 * ManaganaPlayer constructor.
		 * @param	options	initialization options
		 * @param	width	initial player width
		 * @param	height	initial player height
		 * @param	aspect	initial player aspect (landscape or portrait)
		 * @param	bgcolor	initial background color
		 * @param	bgalpha	initial background alpha
		 * @param	bozo1	not used (for compatibility purposes)
		 * @param	bozo2	not used (for compatibility purposes)
		 * @param	allowKeyboard	allow keyboard interaction for voting and navigation?
		 * @param	externalFont	load external fonts
		 * @param	type	the player type
		 */
		public function ManaganaPlayer(options:ManaganaOptions = null, width:uint = 160, height:uint = 90, aspect:String = "landscape", bgcolor:uint = 0, bgalpha:Number = 0.0, bozo1:Boolean = false, bozo2:String = "", allowKeyboard:Boolean = true, externalFont:Boolean = false, type:String = ManaganaPlayer.TYPE_UNKNOWN) {
			// get data
			this._originalW = width;
			this._originalH = height;
			this._allowKeyboard = allowKeyboard;
			this._type = type;
			// check for aspect ratio
			if (aspect == "portrait") {
				if (width > height) {
					width = this._originalH;
					height = this._originalW;
				}
			} else {
				if (width < height) {
					width = this._originalH;
					height = this._originalW;
				}
			}
			this._originalW = width;
			this._originalH = height;
			// options
			if (options == null) {
				this._options = new ManaganaOptions();
				this._options.setStandard();
			} else {
				this._options = options;
			}
			// mute
			this._holdvolume = 0;
			// fonts
			this._fonts = new ManaganaFont();
			if (externalFont) {
				var fontLoader:URLLoader = new URLLoader();
				fontLoader.addEventListener(Event.COMPLETE, onFontComplete);
				fontLoader.addEventListener(IOErrorEvent.IO_ERROR, onFontError);
				fontLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onFontError);
				fontLoader.load(new URLRequest("font/font.xml"));
			}
			// parser
			this._parser = new ManaganaParser(this);
			// prepare data
			this._community = new DISCommunity(this._parser.run, this.getImage);
			this._community.addEventListener(DISLoad.COMMUNITY_OK, onCommunityOK);
			this._community.addEventListener(DISLoad.COMMUNITY_ERROR, onCommunityERROR);
			this._community.addEventListener(DISLoad.STREAM_OK, onStreamOK);
			this._community.addEventListener(DISLoad.STREAM_ERROR, onStreamERROR);
			this._community.addEventListener(DISLoad.PLAYLIST_OK, onPlaylistOK);
			this._community.addEventListener(DISLoad.PLAYLIST_ERROR, onPlaylistERROR);
			this._community.addEventListener(DISLoad.COMMUNITY_LOAD, onCommunityLoad);
			this._community.addEventListener(DISLoad.STREAM_LOAD, onStreamLoad);
			this._community.aspect = aspect;
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
			this._content.addChild(this._streamSprite[DISStream.LEVEL_UP]);
			this._content.addChild(this._streamSprite[DISStream.LEVEL_MAIN]);
			this._content.addChild(this._streamSprite[DISStream.LEVEL_DOWN]);
			this._streamImage = new Array();
			this._streamImage[DISStream.LEVEL_MAIN] = new Array();
			this._streamImage[DISStream.LEVEL_UP] = new Array();
			this._streamImage[DISStream.LEVEL_DOWN] = new Array();
			// vote displays
			this._totalVotes = 0;
			this._endOfStream = false;
			this._lastVote = 0;
			this._hasVote = false;
			this._voteLayer = new Sprite();
			this._content.addChild(this._voteLayer);
			this._votes = new Array();
			var voteGraphics:Array = new Array();
			voteGraphics['0'] = "";
			voteGraphics['10'] = "";
			voteGraphics['20'] = "";
			voteGraphics['30'] = "";
			voteGraphics['40'] = "";
			voteGraphics['50'] = "";
			voteGraphics['60'] = "";
			voteGraphics['70'] = "";
			voteGraphics['80'] = "";
			voteGraphics['90'] = "";
			voteGraphics['100'] = "";
			for (var ivote:uint = 1; ivote <= 9; ivote++) {
				var voteDisplay:VoteDisplay = new VoteDisplay(ivote, voteGraphics);
				this._votes.push(voteDisplay);
				voteDisplay.visible = false;
				voteDisplay.addEventListener(CustomEvent.CUSTOM_UINT, onVoteClick);
				this._voteLayer.addChild(voteDisplay);
			}
			this._voted = false;
			// target
			this._target = new Target();
			this._target.visible = false;
			this.targetMode = Target.INTERACTION_MOUSE;
			this._content.addChild(this._target);
			// transitions
			this.transition = "";
			this._transitions = new Array();
			this._transitions["center"] = new TransitionCENTER(width, height);
			this._transitions["none"] = new TransitionNONE(width, height);
			this._transitions["target"] = new TransitionTARGET(width, height, this._target);
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
			this._cache = new ManaganaCache();
			this._cache.addEventListener(Loading.QUEUE_END, onCacheQueue);
			// external feeds
			this._feedurl = "";
			this._feeds = new ManaganaFeed();
			// wait for the stage
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			// counter
			this._loading = true;
			this._keyfcount = 0;
			this._playing = false;
			this._counter = 0;
			// history
			this._history = new Array();
			this._historyStep = 0;
			// css
			this.textStyle = new StyleSheet();
			this.textStyle.parseCSS("body {\n    color: #000000;\n    font-family: Arial, Helvetica, sans-serif;\n    font-size: 16px;\n}\n\na {\n    color: #0000FF;\n    text-decoration: underline;\n}");
		}
		
		// READ-ONLY VALUES
		
		/**
		 * The player type according to the type constants.
		 */
		public function get type():String {
			return (this._type);
		}
		
		/**
		 * The loaded community ID.
		 */
		public function get currentCommunity():String {
			return (this._community.id);
		}
		
		/**
		 * The loaded community title.
		 */
		public function get currentCommunityTitle():String {
			return (this._community.title);
		}
		
		/**
		 * The loaded community background color.
		 */
		public function get currentCommunityBGColor():uint {
			return (this._community.bgcolor);
		}
		
		/**
		 * The loaded stream ID.
		 */
		public function get currentStream():String {
			if (this._streamData[DISStream.LEVEL_MAIN] != null) {
				return (this._streamData[DISStream.LEVEL_MAIN].id);
			} else {
				return ("");
			}
		}
		
		/**
		 * The loaded stream title.
		 */
		public function get currentStreamTitle():String {
			if (this._streamData[DISStream.LEVEL_MAIN] != null) {
				return (this._streamData[DISStream.LEVEL_MAIN].title);
			} else {
				return ("");
			}
		}
		
		/**
		 * The stream to load on connected remote controls.
		 */
		public function get remoteStream():String {
			if (this._streamData[DISStream.LEVEL_MAIN] != null) {
				if (this._streamData[DISStream.LEVEL_MAIN].remoteStreamID != "") {
					return (this._streamData[DISStream.LEVEL_MAIN].remoteStreamID);
				} else {
					return (this.currentStream);
				}
			} else {
				return ("");
			}
		}
		
		/**
		 * About currently loaded stream.
		 */
		public function get currentStreamAbout():String {
			if (this._streamData[DISStream.LEVEL_MAIN] != null) {
				return (this._streamData[DISStream.LEVEL_MAIN].about);
			} else {
				return ("");
			}
		}
		
		/**
		 * The loaded stream category.
		 */
		public function get streamCategory():String {
			if (this._streamData[DISStream.LEVEL_MAIN] != null) {
				return (this._streamData[DISStream.LEVEL_MAIN].category);
			} else {
				return ("");
			}
		}
		
		/**
		 * The loaded stream has at least one next strem assigend to x axis.
		 */
		public function get streamHasXNext():Boolean {
			return(this._streamData[DISStream.LEVEL_MAIN].navigation["xnext"] != "");
		}
		
		/**
		 * The loaded stream has at least one previous strem assigend to x axis.
		 */
		public function get streamHasXPrev():Boolean {
			return(this._streamData[DISStream.LEVEL_MAIN].navigation["xprev"] != "");
		}
		
		/**
		 * The loaded stream has at least one next strem assigend to y axis.
		 */
		public function get streamHasYNext():Boolean {
			return(this._streamData[DISStream.LEVEL_MAIN].navigation["ynext"] != "");
		}
		
		/**
		 * The loaded stream has at least one previous strem assigend to y axis.
		 */
		public function get streamHasYPrev():Boolean {
			return(this._streamData[DISStream.LEVEL_MAIN].navigation["yprev"] != "");
		}
		
		/**
		 * The loaded stream has at least one next strem assigend to z axis.
		 */
		public function get streamHasZNext():Boolean {
			return(this._streamData[DISStream.LEVEL_MAIN].navigation["znext"] != "");
		}
		
		/**
		 * The loaded stream has at least one previous strem assigend to z axis.
		 */
		public function get streamHasZPrev():Boolean {
			return(this._streamData[DISStream.LEVEL_MAIN].navigation["zprev"] != "");
		}
		
		/**
		 * Current stream time.
		 */
		public function get streamTime():uint {
			if (this._streamData[DISStream.LEVEL_MAIN] != null) {
				if (this._streamData[DISStream.LEVEL_MAIN].votetype == "instance") {
					if (this._streamImage[DISStream.LEVEL_MAIN][this._streamData[DISStream.LEVEL_MAIN].votereference] != null) {
						return(this._streamImage[DISStream.LEVEL_MAIN][this._streamData[DISStream.LEVEL_MAIN].votereference].imageTime);
					} else {
						return (this._counter);
					}
				} else {
					return (this._counter);
				}
			} else {
				return (this._counter);
			}
		}
		
		/**
		 * Current stream total time.
		 */
		public function get streamTotalTime():uint {
			if (this._streamData[DISStream.LEVEL_MAIN] != null) {
				if (this._streamData[DISStream.LEVEL_MAIN].votetype == "defined") {
					return (uint(this._streamData[DISStream.LEVEL_MAIN].votereference));
				} else if (this._streamData[DISStream.LEVEL_MAIN].votetype == "instance") {
					if (this._streamImage[DISStream.LEVEL_MAIN][this._streamData[DISStream.LEVEL_MAIN].votereference] != null) {
						return(this._streamImage[DISStream.LEVEL_MAIN][this._streamData[DISStream.LEVEL_MAIN].votereference].imageTotalTime);
					} else {
						return (0);
					}
				} else {
					return (0);
				}
			} else {
				return (0);
			}
		}
		
		/**
		 * Is the content playing?
		 */
		public function get playing():Boolean {
			return (this._playing);
		}
		
		/**
		 * The voting result for last stream (0 if no vote option was selected).
		 */
		public function get streamVote():uint {
			return (this._lastVote);
		}
		
		/**
		 * Save stream voting results for current community?
		 */
		public function get voteRecord():Boolean {
			return (this._community.voteRecord);
		}
		
		/**
		 * Is player loading a stream or community?
		 */
		public function get loading():Boolean {
			return (this._loading);
		}
		
		/**
		 * the number of played keyframes of current stream.
		 */
		public function get keyfcount():uint {
			return (this._keyfcount);
		}
		
		/**
		 * Does the current content use geolocation?
		 */
		public function get geouse():Boolean {
			var ret:Boolean = false;
			if ((this._streamData[DISStream.LEVEL_MAIN] != null) && (this._streamData[DISStream.LEVEL_MAIN].geouse)) ret = true;
			if ((this._streamData[DISStream.LEVEL_UP] != null) && (this._streamData[DISStream.LEVEL_UP].geouse)) ret = true;
			if ((this._streamData[DISStream.LEVEL_DOWN] != null) && (this._streamData[DISStream.LEVEL_DOWN].geouse)) ret = true;
			return (ret);
		}
		
		// PROPERTIES
		
		/**
		 * Current target mode, according to Target class constants.
		 */
		public function get targetMode():String {
			return (this._target.mode);
		}
		public function set targetMode(to:String):void {
			// remove previous content mouse events
			if (this._content.hasEventListener(MouseEvent.ROLL_OVER)) this._content.removeEventListener(MouseEvent.ROLL_OVER, onRollOverContent);
			if (this._content.hasEventListener(MouseEvent.ROLL_OUT)) this._content.removeEventListener(MouseEvent.ROLL_OUT, onRollOutContent);
			if (this._content.hasEventListener(MouseEvent.MOUSE_MOVE)) this._content.removeEventListener(MouseEvent.MOUSE_MOVE, onMoveContent);
			// target visual properties
			Mouse.show();
			this._target.visible = false;
			// check the new target mode
			switch (to) {
				case Target.INTERACTION_MOUSE:
					this._content.addEventListener(MouseEvent.ROLL_OVER, onRollOverContent);
					this._content.addEventListener(MouseEvent.ROLL_OUT, onRollOutContent); 
					this._target.mode = Target.INTERACTION_MOUSE;
					this._target.mouseEnabled = false;
					this._target.mouseChildren = false;
					break;
				case Target.INTERACTION_REMOTE:
					this._target.mode = Target.INTERACTION_REMOTE;
					this._target.mouseEnabled = true;
					this._target.mouseChildren = true;
					break;
				default:
					this._target.mode = Target.INTERACTION_NONE;
					break;
			}
		}
		
		/**
		 * Is the voting graphics visible?
		 */
		public function get voteVisible():Boolean {
			return (this._voteLayer.visible);
		}
		public function set voteVisible(to:Boolean):void {
			this._voteLayer.visible = to;
		}
		
		/**
		 * Player window width.
		 */
		override public function get width():Number {
			return (this._width);
		}
		override public function set width(value:Number):void {
			this._width = uint(value);
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
			this._content.scaleY = this._mask.scaleY = this._height / this._originalH;
			this._content.y = this._mask.y = -value / 2;
		}
		
		/**
		 * Player configuration.
		 */
		public function get options():ManaganaOptions {
			return (this._options);
		}
		public function set options(to:ManaganaOptions):void {
			this._options.kill();
			this._options = to;
		}
		
		/**
		 * The screen aspect ratio.
		 * @see	flash.display.StageAspectRatio
		 */
		public function get aspect():String {
			return (this._community.aspect);
		}
		public function set aspect(to:String):void {
			this._community.aspect = to;
			this.redraw();
			// adjust stream aspect ratio
			try {
				this._streamData[DISStream.LEVEL_MAIN].setAspect(this._community.aspect);
				this._streamData[DISStream.LEVEL_UP].setAspect(this._community.aspect);
				this._streamData[DISStream.LEVEL_DOWN].setAspect(this._community.aspect);
			} catch (e:Error) { }
		}
		
		/**
		 * Lower guide visibility.
		 */
		public function get lowerGuideVisible():Boolean {
			return (this._streamSprite[DISStream.LEVEL_DOWN].visible);
		}
		public function set lowerGuideVisible(to:Boolean):void {
			this._streamSprite[DISStream.LEVEL_DOWN].visible = to;
		}
		
		/**
		 * Upper guide visibility.
		 */
		public function get upperGuideVisible():Boolean {
			return (this._streamSprite[DISStream.LEVEL_UP].visible);
		}
		public function set upperGuideVisible(to:Boolean):void {
			this._streamSprite[DISStream.LEVEL_UP].visible = to;
		}
		
		/**
		 * Main stream layer visibility.
		 */
		public function get mainLayerVisible():Boolean {
			return (this._streamSprite[DISStream.LEVEL_MAIN].visible);
		}
		public function set mainLayerVisible(to:Boolean):void {
			this._streamSprite[DISStream.LEVEL_MAIN].visible = to;
		}
		
		/**
		 * The url to look for external feeds.
		 */
		public function get feedurl():String {
			return (this._feedurl);
		}
		public function set feedurl(to:String):void {
			this._feedurl = to;
			this._feeds.feedurl = to;
		}
		
		/**
		 * Current saved string values as an url-encoded string.
		 */
		public function get strValues():String {
			return (this._parser.strValues);
		}
		public function set strValues(to:String):void {
			this._parser.strValues = to;
		}
		
		/**
		 * Current saved numeric values as an url-encoded string.
		 */
		public function get numValues():String {
			return (this._parser.numValues);
		}
		public function set numValues(to:String):void {
			this._parser.numValues = to;
		}
		
		/**
		 * Current saved community values as an url-encoded string.
		 */
		public function get comValues():String {
			return (this._parser.comValues);
		}
		public function set comValues(to:String):void {
			this._parser.comValues = to;
		}
		
		/**
		 * Allow keyboard interaction?
		 */
		public function get allowKeyboard():Boolean {
			return (this._allowKeyboard);
		}
		public function set allowKeyboard(to:Boolean):void {
			this._allowKeyboard = to;
		}
		
		// READ-ONLY VALUES
		
		/**
		 * The original width of loaded community on current screen aspect.
		 */
		public function get screenwidth():Number {
			return (this._community.screenwidth);
		}
		
		/**
		 * The original height of loaded community on current screen aspect.
		 */
		public function get screenheight():Number {
			return (this._community.screenheight);
		}
		
		/**
		 * Is a community loaded?
		 */
		public function get communityLoaded():Boolean {
			return (this._community.state == ObjectState.STATE_LOADOK);
		}
		
		/**
		 * Current community feeds.
		 */
		public function get feeds():ManaganaFeed {
			return (this._feeds);
		}
		
		/**
		 * Are there history back information?
		 * @return	true if is possible to check the previous stream in history, false otherwise
		 */
		public function get hasHistoryBack():Boolean {
			return (this._historyStep > 0);
		}
		
		/**
		 * Are there history forward information?
		 * @return	true if is possible to check the next stream in history, false otherwise
		 */
		public function get hasHistoryNext():Boolean {
			return (this._historyStep < (this._history.length - 1));
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
		 * Move to previous stream in navigation history.
		 * @return	true if the previous stream is found and loaded
		 */
		public function historyBack():Boolean {
			if (this.hasHistoryBack) {
				this._historyStep -= 2;
				if (this._history[this._historyStep + 1].community == this.currentCommunity) {
					// same community
					this.loadStream(this._history[this._historyStep + 1].stream);
				} else {
					// another community
					this.startStream = this._history[this._historyStep + 1].stream;
					this.loadCommunity(this._history[this._historyStep + 1].community);
				}
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Move to next stream in navigation history.
		 * @return	true if the next stream is found and loaded
		 */
		public function historyNext():Boolean {
			if (this.hasHistoryNext) {
				if (this._history[this._historyStep + 1].community == this.currentCommunity) {
					// same community
					this.loadStream(this._history[this._historyStep + 1].stream);
				} else {
					// another community
					this.startStream = this._history[this._historyStep + 1].stream;
					this.loadCommunity(this._history[this._historyStep + 1].community);
				}
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Get a reference for an image on player. First, looking for an instance on main layer, if not found, on lower layer, then in upper layer.
		 * @param	name	the image instance name
		 * @return	a ManaganaImage reference or null if the instance name is not found
		 */
		public function getImage(name:String):ManaganaImage {
			var ret:ManaganaImage;
			var index:String;
			for (index in this._streamImage[DISStream.LEVEL_MAIN]) {
				if (index == name) ret = this._streamImage[DISStream.LEVEL_MAIN][index];
			}
			if (ret == null) {
				for (index in this._streamImage[DISStream.LEVEL_DOWN]) {
					if (index == name) ret = this._streamImage[DISStream.LEVEL_DOWN][index];
				}
			}
			if (ret == null) {
				for (index in this._streamImage[DISStream.LEVEL_UP]) {
					if (index == name) ret = this._streamImage[DISStream.LEVEL_UP][index];
				}
			}
			return (ret);
		}
		
		/**
		 * Get a list of current image instance names on player main level.
		 * @return	an array of strings with the found instance names
		 */
		public function getImageList():Array {
			var ret:Array = new Array();
			for (var index:String in this._streamImage[DISStream.LEVEL_MAIN]) {
				ret.push(index);
			}
			return (ret);
		}
		
		/**
		 * Is the provided name a registered meta value field?
		 * @param	name	the name to check
		 * @return	true if there is a meta value at current community with the provided name, false otherwise
		 */
		public function isMeta(name:String):Boolean {
			return (this._streamData[DISStream.LEVEL_MAIN].getMeta(name) != null);
		}
		
		/**
		 * Check the current stream value for a meta data field.
		 * @param	name	the meta data field name
		 * @return	the value for the current stream or an empty string if the value is not found
		 */
		public function getMeta(name:String):String {
			if (this.isMeta(name)) return (this._streamData[DISStream.LEVEL_MAIN].getMeta(name));
				else return ("");
		}
		
		/**
		 * Run a custom function progress code.
		 * @param	name	the code name: A, B, C or D
		 */
		public function runCustomFunction(name:String):void {
			if ((name == "A") || (name == "B") || (name == "C") || (name == "D")) {
				if (this._streamData[DISStream.LEVEL_MAIN] != null) this._streamData[DISStream.LEVEL_MAIN].runCustomFunction(name);
			}
		}
		
		/**
		 * Release memory used by this object.
		 */
		public function kill():void {
			this.unload();
			this.textStyle = null;
			this.shareurl = null;
			this._cache.kill();
			this._cache = null;
			this._bg.graphics.clear();
			this._content.removeChild(this._bg);
			this._bg = null;
			this._mask.graphics.clear();
			this.removeChild(this._mask);
			this._mask = null;
			this._content.removeChild(this._voteLayer);
			while (this._votes.length > 0) {
				this._voteLayer.removeChild(this._votes[0]);
				this._votes[0].removeEventListener(CustomEvent.CUSTOM_UINT, onVoteClick);
				this._votes[0].kill();
				this._votes.shift();
			}
			this._voteLayer = null;
			this._votes = null;
			this._content.removeChild(this._target);
			this._target.kill();
			this._target = null;
			for (var istr:String in this._streamData) {
				this._streamData[istr].kill();
				delete(this._streamData[istr]);
			}
			this._streamData = null;
			for (istr in this._streamSprite) {
				while (this._streamSprite[istr].numChildren > 0) this._streamSprite[istr].removeChildAt(0);
				this._content.removeChild(this._streamSprite[istr]);
				delete(this._streamSprite[istr]);
			}
			this._streamSprite = null;
			for (istr in this._streamImage) {
				this.stopTweens(istr);
				for (var imageidx:String in this._streamImage[istr]) {
					this._streamImage[istr][imageidx].removeEventListener(TextEvent.LINK, onTextLink);
					this._streamImage[istr][imageidx].removeEventListener(Playing.MEDIA_END, onInstanceEnd);
					this._streamImage[istr][imageidx].removeEventListener(MouseEvent.MOUSE_OVER, onInstanceOver);
					this._streamImage[istr][imageidx].removeEventListener(MouseEvent.MOUSE_OUT, onInstanceOut);
					this._streamImage[istr][imageidx].removeEventListener(Message.MOUSEOVER, onSelectableMouseOver);
					this._streamImage[istr][imageidx].removeEventListener(Message.MOUSEOUT, onSelectableMouseOut);
					this._streamImage[istr][imageidx].kill();
					delete(this._streamImage[istr][imageidx]);
				}
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
			while (this._content.numChildren > 0) this._content.removeChildAt(0);
			this.removeChild(this._content);
			this._content = null;
			this._transitions = null;
			this._timer.stop();
			this._timer.removeEventListener(TimerEvent.TIMER, onTimer);
			this._timer = null;
			this._parser.kill();
			this._parser = null;
			this._community.removeEventListener(DISLoad.COMMUNITY_OK, onCommunityOK);
			this._community.removeEventListener(DISLoad.COMMUNITY_ERROR, onCommunityERROR);
			this._community.removeEventListener(DISLoad.STREAM_OK, onStreamOK);
			this._community.removeEventListener(DISLoad.STREAM_ERROR, onStreamERROR);
			this._community.removeEventListener(DISLoad.PLAYLIST_OK, onPlaylistOK);
			this._community.removeEventListener(DISLoad.PLAYLIST_ERROR, onPlaylistERROR);
			this._community.removeEventListener(DISLoad.COMMUNITY_LOAD, onCommunityLoad);
			this._community.removeEventListener(DISLoad.STREAM_LOAD, onStreamLoad);
			this._community.kill();
			this._community = null;
			this._options.kill();
			this._options = null;
			if (this.stage != null) {
				this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				this.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			} else {
				this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			}
			this.startStream = null;
			this.serverurl = null;
			while (this._history.length > 0) {
				this._history[0].kill();
				this._history.shift();
			}
			this._history = null;
			this.interfaceMessage = null;
			this._type = null;
			// a lot of data was released, try to force gc
			System.gc();
		}
		
		/**
		 * Load a community data.
		 * @param	path	the path to the community DIS folder
		 * @param	from	community load request origin
		 */
		public function loadCommunity(path:String, from:String = ""):void {
			// check for community full path (local available?)
			var comPath:String = "";
			if (this.checkPath != null) comPath = this.checkPath(path);
			// adjust transition
			if (from == "list") this.transition = this._community.navlist;
			// clear previous data
			if (this._community.state != ObjectState.STATE_CLEAN) this.unload();
			// check final path
			if (comPath == "") {
				comPath = path;
				if (comPath.substr( -4) != ".dis") comPath += ".dis";
				if (comPath.substr(0, 7) != "http://") {
					if (comPath.substr(0, 12) != "./community/") {
						comPath = "./community/" + comPath;
					}
					comPath = this.serverurl + comPath;
				}
			}
			// load community
			if (path != this._community.id) {
				this.transition = "";
				this._community.load(comPath);
				this._playing = false;
				this._counter = 0;
				this._loading = true;
				this._keyfcount = 0;
			}
		}
		
		/**
		 * Unlod the current community.
		 */
		public function unload():void {
			// stop any images
			this.pause();
			for (var index:String in this._streamImage) {
				this.stopTweens(index);
				for (var index2:String in this._streamImage[index]) {
					try {
						this._streamSprite[index].removeChild(this._streamImage[index][index2]);
					} catch (e:Error) {
						// do nothing
					}
					try {
						this._streamImage[index][index2].removeEventListener(TextEvent.LINK, onTextLink);
						this._streamImage[index][index2].removeEventListener(Playing.MEDIA_END, onInstanceEnd);
						this._streamImage[index][index2].removeEventListener(MouseEvent.MOUSE_OVER, onInstanceOver);
						this._streamImage[index][index2].removeEventListener(MouseEvent.MOUSE_OUT, onInstanceOut);
						this._streamImage[index][index2].removeEventListener(Message.MOUSEOVER, onSelectableMouseOver);
						this._streamImage[index][index2].removeEventListener(Message.MOUSEOUT, onSelectableMouseOut);
					} catch (e:Error) {
						// do nothing
					}
					this._streamImage[index][index2].kill();
					delete(this._streamImage[index][index2]);
				}
			}
			// clear cache and feeds
			this._cache.clear();
			this._feeds.clear();
			// clear current community, streams and playlists
			this._community.clear();
			for (index in this._streamData) this._streamData[index].clear();
			this._playing = false;
			// this._counter = 0;
			this._loading = true;
			this._keyfcount = 0;
		}
		
		/**
		 * Mute/unmute sounds.
		 */
		public function toggleMute():void {
			var transform:SoundTransform = new SoundTransform(this._holdvolume);
			this._holdvolume = this.soundTransform.volume;
			this.soundTransform = transform;
		}
		
		/**
		 * Pause current stream playback.
		 */
		public function pause():void {
			var image:ManaganaImage;
			for each (image in this._streamImage[DISStream.LEVEL_MAIN]) {
				if (Tweener.isTweening(image)) Tweener.pauseTweens(image);
				image.pause();
			}
			for each (image in this._streamImage[DISStream.LEVEL_UP]) {
				if (Tweener.isTweening(image)) Tweener.pauseTweens(image);
				image.pause();
			}
			for each (image in this._streamImage[DISStream.LEVEL_DOWN]) {
				if (Tweener.isTweening(image)) Tweener.pauseTweens(image);
				image.pause();
			}
			this.dispatchEvent(new Playing(Playing.MEDIA_PAUSE));
			this._playing = false;
		}
		
		/**
		 * Play/resume current stream playback.
		 */
		public function play():void {
			var image:ManaganaImage;
			for each (image in this._streamImage[DISStream.LEVEL_MAIN]) {
				if (Tweener.isTweening(image)) Tweener.resumeTweens(image);
				image.play();
			}
			for each (image in this._streamImage[DISStream.LEVEL_UP]) {
				if (Tweener.isTweening(image)) Tweener.resumeTweens(image);
				image.play();
			}
			for each (image in this._streamImage[DISStream.LEVEL_DOWN]) {
				if (Tweener.isTweening(image)) Tweener.resumeTweens(image);
				image.play();
			}
			this.dispatchEvent(new Playing(Playing.MEDIA_PLAY));
			this._playing = true;
		}
		
		/**
		 * Load a stream.
		 * @param	id	the stream identifier.
		 * @param	from	stream load request origin
		 */
		public function loadStream(id:String, from:String = ""):void {
			if (from == "list") this.transition = this._community.navlist;
			if (this._streamData[DISStream.LEVEL_MAIN] != null) {
				if (id != this._streamData[DISStream.LEVEL_MAIN].id) {
					this._community.loadStream(id, this._cache.streamCacheData(id));
					this._playing = false;
					this._counter = 0;
					this._loading = true;
					this._keyfcount = 0;
				}
			} else {
				this._community.loadStream(id, this._cache.streamCacheData(id));
				this._playing = false;
				this._counter = 0;
				this._loading = true;
				this._keyfcount = 0;
			}
			
		}
		
		/**
		 * Load the home stream.
		 */
		public function goHome():void {
			this.transition = this._community.navhome;
			this.loadStream(this._community.home.id);
		}
		
		/**
		 * Navigate to a position defined by the loaded main stream.
		 * @param	position	the position to load: xnext, xprev, ynext, yprev, znext or zprev
		 * @return	true if the position is currently assigned by the main stream and can be loaded, false otherwise
		 */
		public function navigateTo(position:String):Boolean {
			var found:Boolean = false;
			var choices:Array;
			switch (position) {
				case "xnext":
					if (this._streamData[DISStream.LEVEL_MAIN].navigation["xnext"] != "") {
						this.transition = this._community.navxnext;
						choices = this._streamData[DISStream.LEVEL_MAIN].navigation["xnext"].split("|");
						if (choices.length == 1) {
							this.loadStream(choices[0]);
							found = true;
						} else if (choices.length > 0) {
							this.loadStream(choices[uint(Math.round(Math.random() * (choices.length - 1)))]);
							found = true;
						}
					}
					break;
				case "xprev":
					if (this._streamData[DISStream.LEVEL_MAIN].navigation["xprev"] != "") {
						this.transition = this._community.navxprev;
						choices = this._streamData[DISStream.LEVEL_MAIN].navigation["xprev"].split("|");
						if (choices.length == 1) {
							this.loadStream(choices[0]);
							found = true;
						} else if (choices.length > 0) {
							this.loadStream(choices[uint(Math.round(Math.random() * (choices.length - 1)))]);
							found = true;
						}
					}
					break;
				case "ynext":
					if (this._streamData[DISStream.LEVEL_MAIN].navigation["ynext"] != "") {
						this.transition = this._community.navynext;
						choices = this._streamData[DISStream.LEVEL_MAIN].navigation["ynext"].split("|");
						if (choices.length == 1) {
							this.loadStream(choices[0]);
							found = true;
						} else if (choices.length > 0) {
							this.loadStream(choices[uint(Math.round(Math.random() * (choices.length - 1)))]);
							found = true;
						}
					}
					break;
				case "yprev":
					if (this._streamData[DISStream.LEVEL_MAIN].navigation["yprev"] != "") {
						this.transition = this._community.navyprev;
						choices = this._streamData[DISStream.LEVEL_MAIN].navigation["yprev"].split("|");
						if (choices.length == 1) {
							this.loadStream(choices[0]);
							found = true;
						} else if (choices.length > 0) {
							this.loadStream(choices[uint(Math.round(Math.random() * (choices.length - 1)))]);
							found = true;
						}
					}
					break;
				case "znext":
					if (this._streamData[DISStream.LEVEL_MAIN].navigation["znext"] != "") {
						this.transition = this._community.navznext;
						choices = this._streamData[DISStream.LEVEL_MAIN].navigation["znext"].split("|");
						if (choices.length == 1) {
							this.loadStream(choices[0]);
							found = true;
						} else if (choices.length > 0) {
							this.loadStream(choices[uint(Math.round(Math.random() * (choices.length - 1)))]);
							found = true;
						}
					}
					break;
				case "zprev":
					if (this._streamData[DISStream.LEVEL_MAIN].navigation["zprev"] != "") {
						this.transition = this._community.navzprev;
						choices = this._streamData[DISStream.LEVEL_MAIN].navigation["zprev"].split("|");
						if (choices.length == 1) {
							this.loadStream(choices[0]);
							found = true;
						} else if (choices.length > 0) {
							this.loadStream(choices[uint(Math.round(Math.random() * (choices.length - 1)))]);
							found = true;
						}
					}
					break;
			}
			return (found);
		}
		
		/**
		 * Add a vote and set the "has vote" flag.
		 * @param	num	the number to add a vote
		 */
		public function addVote(num:uint):void {
			if ((num > 0) && (num < 10)) {
				if (this._votes[num - 1].enabled) {
					this._hasVote = true;
					this._totalVotes++;
					// add current vote
					this._votes[num - 1].setVotes((this._votes[num - 1].numVotes + 1), this._totalVotes);
					// update all votes display
					for (var ivote:uint = 0; ivote < 9; ivote++) {
						this._votes[ivote].setVotes(this._votes[ivote].numVotes, this._totalVotes);
					}
					this._voted = true;
				}
			}
		}
		
		/**
		 * Set the guide vote.
		 * @param	num	the number to select as the guide vote
		 */
		public function setGuideVote(num:uint):void {
			if ((num >= 1) && (num <= 9)) {
				for (var ivote:uint = 0; ivote < this._votes.length; ivote++) {
					if (this._votes[ivote].voteID == num) {
						this._votes[ivote].selected = !this._votes[ivote].selected;
					} else {
						this._votes[ivote].selected = false;
					}
				}
			}
		}
		
		/**
		 * Is a voting option enabled for current stream?
		 * @param	num	the vote number to check
		 * @return	true if the vote option is enabled, false otherwise (also false if the number is 0 or above 9)
		 */
		public function voteEnabled(num:uint):Boolean {
			if ((num > 0) && (num <= 9)) {
				return (this._votes[num - 1].enabled);
			} else {
				return (false);
			}
		}
		
		/**
		 * Set the vote number.
		 * @param	num	the number to set vote
		 * @param	total	the vote number
		 * @param	setHasVote	set the "has vote" flag?
		 */
		public function setVote(num:uint, total:uint, setHasVote:Boolean = false):void {
			if ((num > 0) && (num < 10)) {
				// is vote in use?
				if (this._votes[num - 1].enabled) {
					// set has vote flag?
					if (setHasVote) this._hasVote = true;
					// set requested vote
					this._votes[num - 1].setVotes(total, this._totalVotes);
					// default community/stream vote?
					if (this._streamData[DISStream.LEVEL_MAIN].voteDefault == num) {
						this._votes[num - 1].setVotes((total + 1), this._totalVotes);
					} else if (this._community.voteDeafult == num) {
						this._votes[num - 1].setVotes((total + 1), this._totalVotes);
					}
					// calculate total votes
					this._totalVotes = 0;
					for (var ivote:uint = 0; ivote < 9; ivote++) {
						this._totalVotes += this._votes[ivote].numVotes;
					}
					// update displays
					for (ivote = 0; ivote < 9; ivote++) {
						this._votes[ivote].setVotes(this._votes[ivote].numVotes, this._totalVotes);
					}
				}
			}
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
		 * Get a bitmap data representation of the current display.
		 * @return	the bitmap data for the current diplay
		 */
		public function getBitmapData():BitmapData {
			var data:BitmapData = new BitmapData(this.width, this.height, true, 0x00000000);
			this._target.visible = false;
			data.draw(this, new Matrix(1, 0, 0, 1, (this.width / 2), (this.height / 2)));
			return (data);
		}
		
		/**
		 * Print the current display.
		 * @return	true if print is supported, false otherwise
		 */
		public function print():Boolean {
			if (this.allowPrinting) {
				var ret:Boolean = false;
				if (PrintJob.isSupported) {
					var job:PrintJob = new PrintJob();
					var bitmap:Bitmap = new Bitmap(this.getBitmapData());
					var shape:Shape = new Shape();
					shape.graphics.beginFill(0xFFFFFF);
					shape.graphics.drawRect(0, 0, 100, 100);
					shape.graphics.endFill();
					bitmap.smoothing = true;
					var printsprite:Sprite = new Sprite();
					printsprite.visible = false;
					this.stage.addChild(printsprite);
					printsprite.addChild(shape);
					printsprite.addChild(bitmap);
					if (job.start()) {
						try {
							bitmap.width = 10 * job.pageWidth / 12;
							bitmap.height = 10 * (this.height * job.pageWidth / this.width) / 12;
							if (bitmap.height > (10 * job.pageHeight / 12)) {
								bitmap.height = (10 * job.pageHeight / 12);
								bitmap.width = 10 * (this.width * job.pageHeight / this.height) / 12;
							}
							shape.width = job.pageWidth;
							shape.height = job.pageHeight;
							bitmap.x = (shape.width - bitmap.width) / 2;
							bitmap.y = (shape.height - bitmap.height) / 2;
							job.addPage(printsprite);
							job.send();
							ret = true;
						} catch (e:Error) { }
					}
					this.stage.removeChild(printsprite);
					printsprite.removeChildren();
					shape.graphics.clear();
					bitmap.bitmapData.dispose();
					printsprite = null;
					bitmap = null;
					shape = null;
				}
				return (ret);
			} else {
				return (false);
			}
		}
		
		/**
		 * Send a message to all assigned listeners.
		 * @param	message	the message to send
		 * @param	type	message event type
		 */
		public function send(message:Object, type:String = Message.MESSAGE):void {
			this.dispatchEvent(new Message(type, message));
		}
		
		/**
		 * Add a stream to cache download.
		 * @param	id	the id of the stream to cache
		 * @param	fromCacheFolder	download the stream before adding it to the cache (false) or load it directly from the cache folder (true)?
		 * @param	text	provided text (leave null or empty string to download from community folder or local cache)
		 */
		public function streamCache(id:String, fromCacheFolder:Boolean = false, text:String = ""):void {
			this._cache.addStream(id, fromCacheFolder, text);
		}
		
		/**
		 * Add a playlist to cache download.
		 * @param	id	the id of the playlist to cache
		 * @param	fromCacheFolder	download the playlist before adding it to the cache (false) or load it directly from the cache folder (true)?
		 * @param	text	provided text (leave null or empty string to download from community folder or local cache)
		 */
		public function playlistCache(id:String, fromCacheFolder:Boolean = false, text:String = ""):void {
			this._cache.addPlaylist(id, fromCacheFolder, text);
		}
		
		/**
		 * Set target position.
		 * @param	px	position in x axis from 0 to 100% of the view area
		 * @param	py	position in y axis from 0 to 100% of the view area
		 * @param	show	should target graphic be visible?
		 */
		public function setTarget(px:Number, py:Number, show:Boolean = true):void {
			this._target.x = this._originalW * px / 100;
			this._target.y = this._originalH * py / 100;
			this._target.counter = 0;
			if (this._target.forceHide) this._target.visible = false;
				else this._target.visible = show;
		}
		
		/**
		 * Set current geolocation data.
		 * @param	latitude	current latitude
		 * @param	longitude	current longitude
		 */
		public function setGeodata(latitude:Number, longitude:Number):void {
			// main stream layer
			if (this._streamData[DISStream.LEVEL_MAIN] != null) {
				this._streamData[DISStream.LEVEL_MAIN].setGeodata(latitude, longitude);
			}
			if (this._streamData[DISStream.LEVEL_UP] != null) {
				this._streamData[DISStream.LEVEL_UP].setGeodata(latitude, longitude);
			}
			if (this._streamData[DISStream.LEVEL_DOWN] != null) {
				this._streamData[DISStream.LEVEL_DOWN].setGeodata(latitude, longitude);
			}
		}
		
		/**
		 * Activate target link (if is over a button-loke instance).
		 */
		public function targetAct():void {
			if (this._target.visible) this._target.act();
		}
		
		// PRIVATE METHODS
		
		/**
		 * Redraw the player display considering community parameters.
		 */
		private function redraw():void {
			// correct content scale
			this._mask.scaleX = this._mask.scaleY = this._content.scaleX = this._content.scaleY = 1;
			this._mask.graphics.clear();
			this._mask.graphics.beginFill(0);
			this._mask.graphics.drawRect(0, 0, this._community.screenwidth, this._community.screenheight);
			this._mask.graphics.endFill();
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
		}
		
		/**
		 * Community loaded.
		 */
		private function onCommunityOK(evt:DISLoad):void {
			// redraw content display
			this.redraw();
			// update transitions
			for (var istr:String in this._transitions) {
				this._transitions[istr].width = this._community.screenwidth;
				this._transitions[istr].height = this._community.screenheight;
			}
			// update cache
			this._cache.community = this._community;
			this._cache.clear();
			this._useCache = false;
			// get custom graphics
			var voteGraphics:Array = new Array();
			voteGraphics['0'] = this._community.vote0;
			voteGraphics['10'] = this._community.vote10;
			voteGraphics['20'] = this._community.vote20;
			voteGraphics['30'] = this._community.vote30;
			voteGraphics['40'] = this._community.vote40;
			voteGraphics['50'] = this._community.vote50;
			voteGraphics['60'] = this._community.vote60;
			voteGraphics['70'] = this._community.vote70;
			voteGraphics['80'] = this._community.vote80;
			voteGraphics['90'] = this._community.vote90;
			voteGraphics['100'] = this._community.vote100;
			for (var ivote:uint = 0; ivote < this._votes.length; ivote++ ) {
				this._votes[ivote].setGraphics(voteGraphics);
			}
			this._target.setGraphic(this._community.target);
			this._target.x = this._originalW / 2;
			this._target.y = this._originalH / 2;
			// get external feed information
			this._feeds.clear();
			for (var ifeed:uint = 0; ifeed < this._community.feeds.length; ifeed++) {
				this._feeds.addFeed(this._community.feeds[ifeed].type, StringFunctions.noSpecial(this._community.feeds[ifeed].name), this._community.feeds[ifeed].reference, this._community.id);
			}
			// css
			this.textStyle.parseCSS(this._community.css);
			// load home stream
			if (this.startStream != "") {
				this.loadStream(this.startStream);
				this.startStream = "";
			} else {
				if (this._community.home.id != "") this.loadStream(this._community.home.id);
			}
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
		 * A new community started to load.
		 */
		private function onCommunityLoad(evt:DISLoad):void {
			this.dispatchEvent(new DISLoad(DISLoad.COMMUNITY_LOAD, this._community));
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
			this._streamData[evt.loader.level].setAspect(this._community.aspect);
			// adjust tweens
			this._tweentime[evt.loader.level] = evt.loader.speed;
			this._tweenmethod[evt.loader.level] = evt.loader.tweening;
			// clear all forced sets on images
			for (var imglevel:String in this._streamImage) {
				for (var image:String in this._streamImage[imglevel]) {
					this._streamImage[imglevel][image].unforceAll();
				}
			}
			// load keyframe
			this.loadKeyframe(0, evt.loader.level);
			// start animation
			this.stopTweens(evt.loader.level);
			this.startTweens(evt.loader.level);
			// apply only when loading a stream into the main level
			if (evt.loader.level == DISStream.LEVEL_MAIN) {
				this.play();
				// warn listeners
				this.dispatchEvent(new DISLoad(DISLoad.STREAM_OK, this._streamData[evt.loader.level]));
				this._playing = true;
				this._counter = 0;
				this._keyfcount = 0;
				// clear previous voting
				this._totalVotes = 0;
				this._endOfStream = false;
				this._hasVote = false;
				for (index = 0; index < this._votes.length; index++) {
					this._votes[index].visible = false;
					this._votes[index].selected = false;
					this._votes[index].enabled = false;
					this._votes[index].setVotes(0, this._totalVotes);
				}
				// check current stream vote options
				var voteData:Array = this._streamData[evt.loader.level].voteoptions;
				var votesFound:uint = 0;
				for (index = 0; index < voteData.length; index++) {
					if (voteData[index].action != "") {
						votesFound++;
						this._votes[index].visible = voteData[index].visible;
						this._votes[index].x = voteData[index].px;
						this._votes[index].y = voteData[index].py;
						this._votes[index].enabled = true;
					}
				}
				// no votes to show?
				if (votesFound < 2) {
					for (index = 0; index < this._votes.length; index++) {
						this._votes[index].visible = false;
					}
				}
				// apply default vote
				if (this._streamData[evt.loader.level].voteDefault > 0) {
					if (this._votes[this._streamData[evt.loader.level].voteDefault - 1].enabled) {
						this._totalVotes = 1;
						this._votes[this._streamData[evt.loader.level].voteDefault - 1].setVotes(1, this._totalVotes);
					}
				} else if (this._community.voteDeafult > 0) {
					if (this._votes[this._community.voteDeafult - 1].enabled) {
						this._totalVotes = 1;
						this._votes[this._community.voteDeafult - 1].setVotes(1, this._totalVotes);
					}
				}
				// update history
				if (this._history.length == 0) { // first stream loaded
					this._history.push(new HistoryData(this.currentCommunity, this.currentStream));
					this._historyStep = 0;
				} else if (this._historyStep == (this._history.length - 1)) { // at initial history position
					if (this._history.length >= 10) {
						// remove the last history data
						this._history[0].kill();
						this._history.shift();
					}
					this._history.push(new HistoryData(this.currentCommunity, this.currentStream));
					this._historyStep = (this._history.length - 1);
				} else {
					if ((this._history[this._historyStep + 1].stream == this.currentStream) && (this._history[this._historyStep + 1].community == this.currentCommunity)) {
						// only moving on history record
						this._historyStep++;
					} else {
						// starting new history from current point
						this._history.splice(this._historyStep + 1);
						this._history.push(new HistoryData(this.currentCommunity, this.currentStream));
						this._historyStep++;
					}
				}
				this._voted = false;
			}
		}
		
		/**
		 * A new stream started to load.
		 */
		private function onStreamLoad(evt:DISLoad):void {
			// warn listeners
			this.dispatchEvent(new DISLoad(DISLoad.STREAM_LOAD, evt.loader));
		}
		
		/**
		 * Check for the stream end for voting.
		 */
		private function checkStreamEnd():void {
			if (!this._endOfStream) {
				this._endOfStream = true;
				this._lastVote = 0;
				// only one vote set?
				var found:uint = 0;
				var chosen:int = -1;
				for (var ivote:uint = 0; ivote < this._streamData[DISStream.LEVEL_MAIN].voteoptions.length; ivote++) {
					if (this._streamData[DISStream.LEVEL_MAIN].voteoptions[ivote].action != "") {
						found++;
						chosen = ivote;
					}
				}
				// more than one vote set?
				if (found > 1) {
					chosen = -1;
					// any selected?
					for (ivote = 0; ivote < 9; ivote++) {
						if (this._votes[ivote].selected) {
							chosen = ivote;
							this._hasVote = true;
							this._lastVote = this._votes[ivote].voteID;
						}
					}
					// check for vote numbers
					if (chosen == -1) {
						var numvotes:uint = 0;
						for (ivote = 0; ivote < 9; ivote++) {
							if (this._votes[ivote].numVotes > numvotes) {
								numvotes = this._votes[ivote].numVotes;
								chosen = ivote;
								if (this._hasVote) this._lastVote = this._votes[ivote].voteID;
							}
						}
					}
					// if no vote is chosen until now (no vote received, ever), take one with action to go on
					if (chosen == -1) {
						for (ivote = 0; ivote < this._streamData[DISStream.LEVEL_MAIN].voteoptions.length; ivote++) {
							if (this._streamData[DISStream.LEVEL_MAIN].voteoptions[ivote].action != "") {
								chosen = ivote;
							}
						}
					}
				}
				// perform end of stream action
				if (chosen >= 0) this._parser.run(this._streamData[DISStream.LEVEL_MAIN].voteoptions[chosen].action);
			}
		}
		
		/**
		 * Load a stream keyframe.
		 * @param	num	keyframe number
		 * @param	level	stream level
		 */
		private function loadKeyframe(num:uint, level:String):void {
			var istr:String;
			var index:uint;
			// check the keyframe number to open
			if (level == DISStream.LEVEL_MAIN) {
				if (this.nextKeyframe >= 0) {
					// set the forced next keyframe
					num = this.nextKeyframe;
					this.nextKeyframe = -1;
				}
			}
			// set transition to use
			var toUse:String = this._streamData[level].fade;
			if (this.transition == null) {
				toUse = this._streamData[level].fade;
			} else if (this.transition != "") {
				toUse = this.transition;
			}
			// mark previous images to be removed
			for (istr in this._streamImage[level]) {
				this._streamImage[level][istr].state = ManaganaImage.STATE_REMOVE;
			}
			// check image properties
			if (this._streamData[level].keyframes[num] != null) {
				if (this._streamData[level].keyframes[num].instances.length > 0) {
					for (index = 0; index < this._streamData[level].keyframes[num].instances.length; index++) {
						var instance:DISInstance = this._streamData[level].keyframes[num].instances[index];
						if (this._streamImage[level][instance.id] == null) {
							// new images
							this._streamImage[level][instance.id] = new ManaganaImage(instance, this._options, this._parser, this._useCache, this._cache, this._feeds, this._community.usehighlight, this._community.highlight, this.textStyle);
							this._streamImage[level][instance.id].setBackground(this.mediaBGTransparent, this.mediaBGColor, this.mediaBGAlpha, this.mediaBGPicture, this.mediaBGAudio, this.mediaBGVideo);
							this._streamImage[level][instance.id].textEmbed = this.textEmbed;
							this._streamImage[level][instance.id].deviceOnHtml = this.textDeviceOnHTML;
							this._streamImage[level][instance.id].embedOnText = this.textEmbedOnPlain;
							this._streamImage[level][instance.id].addEventListener(TextEvent.LINK, onTextLink);
							this._streamImage[level][instance.id].addEventListener(Playing.MEDIA_END, onInstanceEnd);
							this._streamImage[level][instance.id].addEventListener(MouseEvent.MOUSE_OVER, onInstanceOver);
							this._streamImage[level][instance.id].addEventListener(MouseEvent.MOUSE_OUT, onInstanceOut);
							this._streamImage[level][instance.id].addEventListener(Message.MOUSEOVER, onSelectableMouseOver);
							this._streamImage[level][instance.id].addEventListener(Message.MOUSEOUT, onSelectableMouseOut);
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
							this._streamImage[level][instance.id].state = ManaganaImage.STATE_PLAY;
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
				if (this._streamImage[level][istr].state == ManaganaImage.STATE_REMOVE) {
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
			// run any keyframe start actions
			try {
				this._parser.run(this._streamData[level].keyframes[num].codeIn);
			} catch (e:Error) { }
			// update keyframe count
			this._keyfcount++;
		}
		
		/**
		 * Stop any tweens running on selected images.
		 * @param	level	stream level
		 */
		private function stopTweens(level:String):void {
			for (var image:String in this._streamImage[level]) {
				if (Tweener.isTweening(this._streamImage[level][image])) {
					Tweener.removeTweens(this._streamImage[level][image]);
					this._streamImage[level][image].endTween();
				}
			}
		}
		
		/**
		 * Start tweens for selected images.
		 * @param	level	stream level
		 */
		private function startTweens(level:String):void {
			var image:ManaganaImage;
			var found:Boolean = false;
			var tweenSpeed:int = int(Math.round(this._tweentime[level] + (this._streamData[level].entropy * (Math.random() - 0.5) * 2)));
			if (tweenSpeed <= 0) tweenSpeed = 1;
			if (this.speed > 0) tweenSpeed = this.speed;
			for each (image in this._streamImage[level]) {
				if (!found) {
					Tweener.addTween(image,  image.tweenObject(tweenSpeed, this._streamData[level].distortion, this._tweenmethod[level], streamTweenFinish, [level], streamTweenUpdate, [level]));
					found = true;
				} else {
					Tweener.addTween(image, image.tweenObject(tweenSpeed, this._streamData[level].distortion, this._tweenmethod[level]));
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
				if (this._streamImage[level][istr].state == ManaganaImage.STATE_REMOVE) {
					this._streamSprite[level].removeChild(this._streamImage[level][istr]);
					this._streamImage[level][istr].removeEventListener(TextEvent.LINK, onTextLink);
					this._streamImage[level][istr].removeEventListener(Playing.MEDIA_END, onInstanceEnd);
					this._streamImage[level][istr].removeEventListener(MouseEvent.MOUSE_OVER, onInstanceOver);
					this._streamImage[level][istr].removeEventListener(MouseEvent.MOUSE_OUT, onInstanceOut);
					this._streamImage[level][istr].removeEventListener(Message.MOUSEOVER, onSelectableMouseOver);
					this._streamImage[level][istr].removeEventListener(Message.MOUSEOUT, onSelectableMouseOut);
					this._streamImage[level][istr].kill();
					delete(this._streamImage[level][istr]);
				}
			}
			// check next keyframe
			var num:int = this._currKeyframe[level] + 1;
			if (num >= this._streamData[level].keyframes.length) num = 0;
			// run any keyframe end actions
			try {
				this._parser.run(this._streamData[level].keyframes[this._currKeyframe[level]].codeOut);
			} catch (e:Error) { }
			// load keyframe
			this.loadKeyframe(num, level);
			// play tweens
			this.startTweens(level);
		}
		
		/**
		 * Stream load error.
		 */
		private function onStreamERROR(evt:DISLoad):void {
			// warn listeners
			this.dispatchEvent(new DISLoad(DISLoad.STREAM_ERROR, evt.loader));
		}
		
		/**
		 * Playlist data available
		 */
		private function onPlaylistOK(evt:DISLoad):void {
			// check if images need playlist data
			var image:ManaganaImage;
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
			var image:ManaganaImage;
			for each (image in this._streamImage[DISStream.LEVEL_MAIN]) {
				image.timerUpdate();
			}
			for each (image in this._streamImage[DISStream.LEVEL_UP]) image.timerUpdate();
			for each (image in this._streamImage[DISStream.LEVEL_DOWN]) image.timerUpdate();
			// update counter
			if (this._playing && (this._streamData[DISStream.LEVEL_MAIN] != null)) {
				// wait for votes to count?
				if (this._streamData[DISStream.LEVEL_MAIN].startAfterVote && !this._voted && (this._streamData[DISStream.LEVEL_MAIN].votetype == "defined")) {
					// do not count
				} else {
					this._counter++;
					// end of stream?
					if ((this.streamTotalTime > 0) && (this.streamTime >= this.streamTotalTime)) this.checkStreamEnd();
				}
			}
			// assume that a stream is loaded when at least one keyframe is played
			if (this._counter >= this._tweentime[DISStream.LEVEL_MAIN]) this._loading = false;
			// check for target over links
			if (this._target.mode == Target.INTERACTION_REMOTE) {
				// check collisions
				if (this._target.visible) {
					var found:Boolean = false;
					// main stream level
					for each (image in this._streamImage[DISStream.LEVEL_MAIN]) {
						if (!found) {
							if (image.hasAction) {
								if (this._target.checkCollision(image)) {
									found = true;
									if (!image.mouseOver) {
										this._target.setImage(image);
										image.onMouseOver();
									}
								} else {
									image.onMouseOut();
								}
							} else {
								image.onMouseOut();
							}
						} else {
							image.onMouseOut();
						}
					}
					// upper stream level
					for each (image in this._streamImage[DISStream.LEVEL_UP]) {
						if (!found) {
							if (image.hasAction) {
								if (this._target.hitTestObject(image)) {
									found = true;
									if (!image.mouseOver) {
										this._target.setImage(image);
										image.onMouseOver();
									}
								} else {
									image.onMouseOut();
								}
							} else {
								image.onMouseOut();
							}
						} else {
							image.onMouseOut();
						}
					}
					// lower stream level
					for each (image in this._streamImage[DISStream.LEVEL_DOWN]) {
						if (!found) {
							if (image.hasAction) {
								if (this._target.hitTestObject(image)) {
									found = true;
									if (!image.mouseOver) {
										this._target.setImage(image);
										image.onMouseOver();
									}
								} else {
									image.onMouseOut();
								}
							} else {
								image.onMouseOut();
							}
						} else {
							image.onMouseOut();
						}
					}
					// no image found?
					if (!found) this._target.setImage(null);
				}
			}
			// update target counter
			this._target.update();
			// update parser
			this._parser.update();
		}
		
		/**
		 * The stage reference became available.
		 */
		private function onStage(evt:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			// listen to keyboard input
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			// listen to mouse wheel
			this.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		/**
		 * User clicked on a vote display.
		 */
		private function onVoteClick(evt:CustomEvent):void {
			for (var ivote:uint = 0; ivote < this._votes.length; ivote++) {
				if (this._votes[ivote].voteID != uint(evt.custom)) this._votes[ivote].selected = false;
			}
		}
		
		/**
		 * A key was pressed on the keyboard.
		 */
		private function onKeyDown(evt:KeyboardEvent):void {
			if (this._allowKeyboard) if (this.visible) switch (evt.keyCode) {
				case Keyboard.RIGHT:
					// check for xnext navigation
					this.navigateTo("xnext");
					break;
				case Keyboard.LEFT:
					// check for xprev navigation
					this.navigateTo("xprev");
					break;
				case Keyboard.UP:
					// check for ynext navigation
					this.navigateTo("ynext");
					break;
				case Keyboard.DOWN:
					// check for yprev navigation
					this.navigateTo("yprev");
					break;
				case Keyboard.PAGE_UP:
					// check for znext navigation
					this.navigateTo("znext");
					break;
				case Keyboard.PAGE_DOWN:
					// check for zprev navigation
					this.navigateTo("zprev");
					break;
				case Keyboard.NUMBER_1:
				case Keyboard.NUMPAD_1:
					this.addVote(1);
					break;
				case Keyboard.NUMBER_2:
				case Keyboard.NUMPAD_2:
					this.addVote(2);
					break;
				case Keyboard.NUMBER_3:
				case Keyboard.NUMPAD_3:
					this.addVote(3);
					break;
				case Keyboard.NUMBER_4:
				case Keyboard.NUMPAD_4:
					this.addVote(4);
					break;
				case Keyboard.NUMBER_5:
				case Keyboard.NUMPAD_5:
					this.addVote(5);
					break;
				case Keyboard.NUMBER_6:
				case Keyboard.NUMPAD_6:
					this.addVote(6);
					break;
				case Keyboard.NUMBER_7:
				case Keyboard.NUMPAD_7:
					this.addVote(7);
					break;
				case Keyboard.NUMBER_8:
				case Keyboard.NUMPAD_8:
					this.addVote(8);
					break;
				case Keyboard.NUMBER_9:
				case Keyboard.NUMPAD_9:
					this.addVote(9);
					break;
				case Keyboard.A:
					this.runCustomFunction('A');
					break;
				case Keyboard.B:
					this.runCustomFunction('B');
					break;
				case Keyboard.C:
					this.runCustomFunction('C');
					break;
				case Keyboard.D:
					this.runCustomFunction('D');
					break;
				case Keyboard.P:
					this.print();
					break;
			}
		}
		
		/**
		 * Listen to mouse wheel changes.
		 */
		private function onMouseWheel(evt:MouseEvent):void {
			if (this.visible) {
				if (evt.delta < 0) {
					this.mouseWheelDown();
				} else if (evt.delta > 0) {
					this.mouseWheelUp();
				}
			}
		}
		
		/**
		 * Mouse wheel moved up.
		 */
		public function mouseWheelUp():void {
			this._streamData[DISStream.LEVEL_MAIN].runMouseWheel('up');
		}
		
		public function mouseWheelDown():void {
			this._streamData[DISStream.LEVEL_MAIN].runMouseWheel('down');
		}
		
		/**
		 * Sort all imagens according to z value.
		 */
		private function zSort():void {
			DisplayFunctions.zSort(this._streamSprite[DISStream.LEVEL_MAIN]);
			DisplayFunctions.zSort(this._streamSprite[DISStream.LEVEL_UP]);
			DisplayFunctions.zSort(this._streamSprite[DISStream.LEVEL_DOWN]);
		}
		
		/**
		 * A link inside a html text was clicked.
		 */
		private function onTextLink(evt:TextEvent):void {
			if (evt.text.substr(0, 4) == 'http') {
				this.dispatchEvent(new Message(Message.OPENURL, { message:"openURL", value:evt.text } ));
			} else {
				this._parser.run(evt.text);
			}
		}
		
		/**
		 * An instance media just finished playing.
		 */
		private function onInstanceEnd(evt:Playing):void {
			// waiting for an image end for stream time?
			if (this._streamData[DISStream.LEVEL_MAIN].votetype == "instance") {
				if (this._streamData[DISStream.LEVEL_MAIN].votereference == evt.fileName) {
					if (this._streamImage[DISStream.LEVEL_MAIN][this._streamData[DISStream.LEVEL_MAIN].votereference] != null) {
						this.checkStreamEnd();
					}
				}
			}
		}
		
		/**
		 * Mouse target moved into content.
		 */
		private function onRollOverContent(evt:MouseEvent):void {
			Mouse.hide();
			if (this._target.forceHide) this._target.visible = false;
				else this._target.visible = true;
			this._content.addEventListener(MouseEvent.MOUSE_MOVE, onMoveContent);
		}
		
		/**
		 * Mouse target moved out of content.
		 */
		private function onRollOutContent(evt:MouseEvent):void {
			Mouse.show();
			this._target.visible = false;
			if (this._content.hasEventListener(MouseEvent.MOUSE_MOVE)) this._content.removeEventListener(MouseEvent.MOUSE_MOVE, onMoveContent);
		}
		
		/**
		 * Mouse target moved inside the content.
		 */
		private function onMoveContent(evt:MouseEvent):void {
			this._target.x = this._content.mouseX;
			this._target.y = this._content.mouseY;
			this._target.counter = 0;
			if (this._target.forceHide) this._target.visible = false;
				else this._target.visible = true;
		}
		
		/**
		 * Mouse moved over an intance.
		 */
		private function onInstanceOver(evt:MouseEvent):void {
			if (this._target.mode == Target.INTERACTION_MOUSE) {
				if (evt.target is ManaganaImage) evt.target.onMouseOver();
			}
		}
		
		/**
		 * Mouse moved out from an instance.
		 */
		private function onInstanceOut(evt:MouseEvent):void {
			if (this._target.mode == Target.INTERACTION_MOUSE) {
				if (evt.target is ManaganaImage) evt.target.onMouseOut();
			}
		}
		
		/**
		 * Font list loaded.
		 */
		private function onFontComplete(evt:Event):void {
			// check and download custom fonts
			var fontLoader:URLLoader = evt.target as URLLoader;
			fontLoader.removeEventListener(Event.COMPLETE, onFontComplete);
			fontLoader.removeEventListener(IOErrorEvent.IO_ERROR, onFontError);
			fontLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onFontError);
			try {
				var fontList:XML = new XML(fontLoader.data);
				for (var index:uint = 0; index < fontList.child("font").length(); index++) {
					var font:Loader = new Loader();
					font.load(new URLRequest("font/" + fontList.font[index].file), new LoaderContext(false, ApplicationDomain.currentDomain, null));
				}
			} catch (e:Error) {
				// do not use custom fonts
			}
		}
		
		/**
		 * Font list not loaded.
		 */
		private function onFontError(evt:Event):void {
			// do not use custom fonts
			var fontLoader:URLLoader = evt.target as URLLoader;
			fontLoader.removeEventListener(Event.COMPLETE, onFontComplete);
			fontLoader.removeEventListener(IOErrorEvent.IO_ERROR, onFontError);
			fontLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onFontError);
		}
		
		/**
		 * Mouse over selcteble text.
		 */
		private function onSelectableMouseOver(evt:Message):void {
			this._target.forceHide = true;
		}
		
		/**
		 * Mouse out selcteble text.
		 */
		private function onSelectableMouseOut(evt:Message):void {
			this._target.forceHide = false;
		}
		
	}

}
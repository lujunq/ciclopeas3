package art.ciclope.display {
	
	// FLASH PACKAGES
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.StyleSheet;
	import flash.events.TextEvent;
	
	// CICLOPE CLASSES
	import art.ciclope.display.SimpleDisplay;
	import art.ciclope.event.Loading;
	import art.ciclope.util.LoadedFile;
	import art.ciclope.util.Placing;
	import art.ciclope.event.Playing;
	import art.ciclope.util.MediaDefinitions;
	import art.ciclope.event.Message;
	
	// CAURINA
	import caurina.transitions.Tweener;
	
	// EVENTS
	
	/**
     * Media play.
     */
    [Event( name = "MEDIA_PLAY", type = "art.ciclope.event.Playing" )]
	/**
     * Media paused.
     */
    [Event( name = "MEDIA_PAUSE", type = "art.ciclope.event.Playing" )]
	/**
     * Media stop.
     */
    [Event( name = "MEDIA_STOP", type = "art.ciclope.event.Playing" )]
	/**
     * Media seek.
     */
    [Event( name = "MEDIA_SEEK", type = "art.ciclope.event.Playing" )]
	/**
     * Media playback progress.
     */
    [Event( name = "MEDIA_PROGRESS", type = "art.ciclope.event.Playing" )]
	/**
     * Media loop.
     */
    [Event( name = "MEDIA_LOOP", type = "art.ciclope.event.Playing" )]
	/**
     * Media stopped at end.
     */
    [Event( name = "MEDIA_END", type = "art.ciclope.event.Playing" )]
	/**
     * Media cuepoint reached.
     */
    [Event( name = "MEDIA_CUE", type = "art.ciclope.event.Playing" )]
	/**
     * Media trannsition start.
     */
    [Event( name = "TRANSITION_START", type = "art.ciclope.event.Loading" )]
	/**
     * Media transition end.
     */
    [Event( name = "TRANSITION_END", type = "art.ciclope.event.Loading" )]
	/**
     * Media download is enough to start playing.
     */
    [Event( name = "FINISHED", type = "art.ciclope.event.Loading" )]
	/**
     * Media download IO error.
     */
    [Event( name = "ERROR_IO", type = "art.ciclope.event.Loading" )]
	/**
     * Media download progress.
     */
    [Event( name = "PROGRESS", type = "art.ciclope.event.Loading" )]
	/**
     * Media unload.
     */
    [Event( name = "UNLOAD", type = "art.ciclope.event.Loading" )]
	/**
     * Media download started.
     */
    [Event( name = "START", type = "art.ciclope.event.Loading" )]
	/**
     * Media download security error.
     */
    [Event( name = "ERROR_SECURITY", type = "art.ciclope.event.Loading" )]
	/**
     * Stream download is complete.
     */
    [Event( name = "STREAM_COMPLETE", type = "art.ciclope.event.Loading" )]
	/**
     * Media download HTTP status.
     */
    [Event( name = "HTTP_STATUS", type = "art.ciclope.event.Loading" )]
	
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * MediaDisplay defines a sprite capable of showing media content (text, picture, flash movie, video, audio, animation - sequence) making transitions while content changes. The display reference point for rotations and position is always placed at the image center.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class MediaDisplay extends Sprite {
		
		// CONSTANTS
		
		/**
		 * Transition type: move up.
		 */
		public static const TRANSITION_UP:String = "TRANSITION_UP";
		/**
		 * Transition type: move right.
		 */
		public static const TRANSITION_RIGHT:String = "TRANSITION_RIGHT";
		/**
		 * Transition type: move down.
		 */
		public static const TRANSITION_DOWN:String = "TRANSITION_DOWN";
		/**
		 * Transition type: move left.
		 */
		public static const TRANSITION_LEFT:String = "TRANSITION_LEFT";
		/**
		 * Transition type: fade.
		 */
		public static const TRANSITION_FADE:String = "TRANSITION_FADE";
		/**
		 * Transition type: none.
		 */
		public static const TRANSITION_NONE:String = "TRANSITION_NONE";
		
		// VARIABLES
		
		/**
		 * The background color.
		 */
		private var _bgColor:uint;
		/**
		 * Is background transparent?
		 */
		private var _transparent:Boolean;
		/**
		 * Current content layer.
		 */
		protected var _currentLayer:uint;
		/**
		 * Is content "tweening"?
		 */
		protected var _tweening:Boolean;
		/**
		 * Transition update time.
		 */
		protected var _update:Number;
		/**
		 * The transition type for the content. Check transition constants.
		 */
		protected var _transition:String;
		/**
		 * Last file load request.
		 */
		private var _lastLoad:String;
		/**
		 * Show playback interface?
		 */
		private var _showInterface:Boolean;
		/**
		 * Force return of 0 when asking for media time?
		 */
		private var _zeroTime:Boolean;
		/**
		 * Is the display loading a file?
		 */
		private var _loading:Boolean;
		
		// SPRITE PROPERTIES
		
		/**
		 * The nominal width of this display.
		 */
		protected var _setWidth:Number;
		/**
		 * The nominal height of this display.
		 */
		protected var _setHeight:Number;
		/**
		 * The nominal x position.
		 */
		private var _setX:Number;
		/**
		 * The nominal y position.
		 */
		private var _setY:Number;
		
		// LAYERS
		
		/**
		 * The background sprite filled with desired color.
		 */
		private var _bg:Sprite;
		/**
		 * A sprite for content-sensitive background (picture).
		 */
		private var _bgpicture:Sprite;
		/**
		 * A sprite for content-sensitive background (audio).
		 */
		private var _bgaudio:Sprite;
		/**
		 * A sprite for content-sensitive background (video).
		 */
		private var _bgvideo:Sprite;
		/**
		 * The media layer with loaded content.
		 */
		private var _media:Sprite;
		/**
		 * The mask for the media layer.
		 */
		private var _mask:Shape;
		/**
		 * Loaded content layers.
		 */
		protected var _content:Array;
		/**
		 * Playback interface for video and audio.
		 */
		private var _interface:PlaybackInterface;
		/**
		 * Media loading background.
		 */
		private var _mediaBG:Sprite;
		
		// PUBLIC VARIABLES
		
		/**
		 * A background layer for multi purpose display.
		 */
		public var bgLayer:Sprite;
		
		// CONSTRUCTOR
		
		/**
		 * MediaDisplay constructor.
		 * @param	width	Display width.
		 * @param	height	Display height.
		 * @param	audioIcon	An icon to show while playing audio only (optional).
		 * @param	transition	The media change animation (see transition constants).
		 * @param	update	The time taken by media change transitions (seconds).
		 * @param	bgcolor	The color of this sprite background.
		 * @param	transparent	Should background be transparent?
		 */
		public function MediaDisplay(width:Number = 160, height:Number = 90, audioIcon:DisplayObject = null, transition:String = MediaDisplay.TRANSITION_FADE, update:Number = 0.5, bgcolor:uint = 0, transparent:Boolean = true) {
			this.cacheAsBitmap = false;
			// setting variables
			this._setWidth = width;
			this._setHeight = height;
			this.x = 0;
			this.y = 0;
			this._update = update;
			this._bgColor = bgcolor;
			this._tweening = false;
			this._transition = transition;
			this._lastLoad = "";
			this._zeroTime = false;
			this._loading = false;
			// background layer
			this.bgLayer = new Sprite();
			this.addChild(this.bgLayer);
			// background sprite
			this._transparent = transparent;
			this._bg = new Sprite();
			this._bg.graphics.beginFill(bgcolor);
			this._bg.graphics.drawRect(0, 0, width, height);
			this._bg.graphics.endFill();
			this._bg.x = -width / 2;
			this._bg.y = -height / 2;
			this._bg.visible = !transparent;
			this.addChild(this._bg);
			// backgound media
			this._mediaBG = new Sprite();
			this.addChild(this._mediaBG);
			// media layer
			this._media = new Sprite();
			this._media.x = -width / 2;
			this._media.y = -height / 2;
			this.addChild(this._media);
			// content layers
			this._content = new Array();
			this._content.push(new SimpleDisplay(width, height, audioIcon)); // layer 0
			this._content.push(new SimpleDisplay(width, height, audioIcon)); // layer 1
			this._currentLayer = 0;
			this._content[1].visible = false;
			this._media.addChild(this._content[0]);
			this._media.addChild(this._content[1]);
			// events of content
			this._content[0].addEventListener(Loading.FINISHED, contentFinished);
			this._content[1].addEventListener(Loading.FINISHED, contentFinished);
			this._content[0].addEventListener(Loading.ERROR_IO, contentIOError);
			this._content[1].addEventListener(Loading.ERROR_IO, contentIOError);
			this._content[0].addEventListener(Loading.PROGRESS, contentProgress);
			this._content[1].addEventListener(Loading.PROGRESS, contentProgress);
			this._content[0].addEventListener(Loading.UNLOAD, contentUnload);
			this._content[1].addEventListener(Loading.UNLOAD, contentUnload);
			this._content[0].addEventListener(Loading.START, contentStart);
			this._content[1].addEventListener(Loading.START, contentStart);
			this._content[0].addEventListener(Loading.ERROR_SECURITY, contentSecurityError);
			this._content[1].addEventListener(Loading.ERROR_SECURITY, contentSecurityError);
			this._content[0].addEventListener(Loading.STREAM_COMPLETE, contentStreamComplete);
			this._content[1].addEventListener(Loading.STREAM_COMPLETE, contentStreamComplete);
			this._content[0].addEventListener(Loading.HTTP_STATUS, contentHttpStatus);
			this._content[1].addEventListener(Loading.HTTP_STATUS, contentHttpStatus);
			this._content[0].addEventListener(Playing.MEDIA_PLAY, contentPlay);
			this._content[1].addEventListener(Playing.MEDIA_PLAY, contentPlay);
			this._content[0].addEventListener(Playing.MEDIA_PAUSE, contentPause);
			this._content[1].addEventListener(Playing.MEDIA_PAUSE, contentPause);
			this._content[0].addEventListener(Playing.MEDIA_STOP, contentStop);
			this._content[1].addEventListener(Playing.MEDIA_STOP, contentStop);
			this._content[0].addEventListener(Playing.MEDIA_SEEK, contentSeek);
			this._content[1].addEventListener(Playing.MEDIA_SEEK, contentSeek);
			this._content[0].addEventListener(Playing.MEDIA_PROGRESS, contentMediaProgress);
			this._content[1].addEventListener(Playing.MEDIA_PROGRESS, contentMediaProgress);
			this._content[0].addEventListener(Playing.MEDIA_LOOP, contentLoop);
			this._content[1].addEventListener(Playing.MEDIA_LOOP, contentLoop);
			this._content[0].addEventListener(Playing.MEDIA_END, contentEnd);
			this._content[1].addEventListener(Playing.MEDIA_END, contentEnd);
			this._content[0].addEventListener(Playing.MEDIA_CUE, contentCue);
			this._content[1].addEventListener(Playing.MEDIA_CUE, contentCue);
			this._content[0].addEventListener(TextEvent.LINK, onLink);
			this._content[1].addEventListener(TextEvent.LINK, onLink);
			this._content[0].addEventListener(Message.MOUSEOVER, onMouseOver);
			this._content[0].addEventListener(Message.MOUSEOUT, onMouseOut);
			this._content[1].addEventListener(Message.MOUSEOVER, onMouseOver);
			this._content[1].addEventListener(Message.MOUSEOUT, onMouseOut);
			this._content[0].mouseEnabled = false;
			this._content[1].mouseEnabled = false;
			// mask sprite
			this._mask = new Shape();
			this._mask.graphics.beginFill(bgcolor);
			this._mask.graphics.drawRect(0, 0, width, height);
			this._mask.graphics.endFill();
			this._mask.x = -width / 2;
			this._mask.y = -height / 2;
			this.addChild(this._mask);
			this._media.mask = this._mask;
			// playback interface
			this._interface = new PlaybackInterface(this.play, this.pause, this.seekPosition);
			this.addChild(this._interface);
			this._interface.checkView(width, height, loadedType);
			this._interface.visible = false;
			this._showInterface = false;
		}
		
		// PROPERTIES
		
		/**
		 * The display x position (upper-left corner).
		 */
		override public function get x():Number { return (this._setX); }
		override public function set x(to:Number):void {
			this._setX = to;
			super.x = to + (this._setWidth / 2);
		}
		
		/**
		 * The display y position (upper-left corner).
		 */
		override public function get y():Number { return (this._setY); }
		override public function set y(to:Number):void {
			this._setY = to;
			super.y = to + (this._setHeight / 2);
		}
		
		/**
		 * The display width, in pixels.
		 */
		override public function get width():Number { return (this._setWidth); }
		override public function set width(value:Number):void {
			// setting reference value
			this._setWidth = value;
			// adjusting background sprite
			//this._bg.width = value;
			//this._bg.x = -value / 2;
			this._mediaBG.width = value;
			this._mediaBG.x = -value / 2;
			// adjusting mask sprite
			this._mask.width = value;
			this._mask.x = -value / 2;
			// adjusting content
			this._media.x = -value / 2;
			this._content[0].width = value;
			this._content[1].width = value;
			this.x = this._setX;
			// playback interface
			this._interface.checkView(this._setWidth, this._setHeight, loadedType);
		}
		
		/**
		 * The display height, in pixels.
		 */
		override public function get height():Number { return (this._setHeight); }
		override public function set height(value:Number):void {
			// setting reference value
			this._setHeight = value;
			// adjusting background sprite
			//this._bg.height = value;
			//this._bg.y = -value / 2;
			this._mediaBG.height = value;
			this._mediaBG.y = -value / 2;
			// adjusting mask sprite
			this._mask.height = value;
			this._mask.y = -value / 2;
			// adjusting content
			this._media.y = -value / 2;
			this._content[0].height = value;
			this._content[1].height = value;
			this.y = this._setY;
			// playback interface
			this._interface.checkView(this._setWidth, this._setHeight, loadedType);
		}
		
		/**
		 * The time taken by media change transitions (seconds).
		 */
		public function get update():Number {
			return (this._update);
		}
		public function set update(to:Number):void {
			this._update = to;
		}
		
		/**
		 * The media change transition animation (check transition constants).
		 */
		public function get transition():String {
			return (this._transition);
		}
		public function set transition(to:String):void {
			this._transition = to;
		}
		
		/**
		 * The text font.
		 */
		public function get textFont():String {
			return (this._content[0].textFont);
		}
		public function set textFont(to:String):void {
			this._content[0].textFont = to;
			this._content[1].textFont = to;
		}
		
		/**
		 * Is text bold?
		 */
		public function get textBold():Boolean {
			return (this._content[0].textBold);
		}
		public function set textBold(to:Boolean):void {
			this._content[0].textBold = to;
			this._content[1].textBold = to;
		}
		
		/**
		 * Is text italic?
		 */
		public function get textItalic():Boolean {
			return (this._content[0].textItalic);
		}
		public function set textItalic(to:Boolean):void {
			this._content[0].textItalic = to;
			this._content[1].textItalic = to;
		}
		
		/**
		 * The text color.
		 */
		public function get textColor():uint {
			return (this._content[0].textColor);
		}
		public function set textColor(to:uint):void {
			this._content[0].textColor = to;
			this._content[1].textColor = to;
		}
		
		/**
		 * The text font size.
		 */
		public function get textSize():uint {
			return (this._content[0].textSize);
		}
		public function set textSize(to:uint):void {
			this._content[0].textSize = to;
			this._content[1].textSize = to;
		}
		
		/**
		 * The text alignment.
		 */
		public function get textAlign():String {
			return (this._content[0].textAlign);
		}
		public function set textAlign(to:String):void {
			this._content[0].textAlign = to;
			this._content[1].textAlign = to;
		}
		
		/**
		 * The standard text line leading.
		 */
		public function get leading():Object {
			return (this._content[0].leading);
		}
		public function set leading(to:Object):void {
			this._content[0].leading = to;
			this._content[1].leading = to;
		}
		
		/**
		 * The standard text letter spacing.
		 */
		public function get letterSpacing():Object {
			return (this._content[0].letterSpacing);
		}
		public function set letterSpacing(to:Object):void {
			this._content[0].letterSpacing = to;
			this._content[1].letterSpacing = to;
		}
		
		/**
		 * Maximum number of chars to show on text.
		 */
		public function get maxchars():uint {
			return (this._content[0].maxchars);
		}
		public function set maxchars(to:uint):void {
			this._content[0].maxchars = to;
			this._content[1].maxchars = to;
		}
		
		/**
		 * Try to use an alternative font or text if the desired embed one is not available?
		 */
		public function get textAlternativeFont():Boolean {
			return (this._content[0].textAlternativeFont);
		}
		public function set textAlternativeFont(to:Boolean):void {
			this._content[0].textAlternativeFont = to;
			this._content[1].textAlternativeFont = to;
		}
		
		/**
		 * Use embed fonts on text? This value may be be constantly changed by the system due to configurations.
		 */
		public function get textEmbed():Boolean {
			return (this._content[0].textEmbed);
		}
		public function set textEmbed(to:Boolean):void {
			this._content[0].textEmbed = to;
			this._content[1].textEmbed = to;
		}
		
		/**
		 * Switch to device fonts while loading a HTML text? (default = true)
		 */
		public function get deviceOnHtml():Boolean {
			return (this._content[0].deviceOnHtml);
		}
		public function set deviceOnHtml(to:Boolean):void {
			this._content[0].deviceOnHtml = to;
			this._content[1].deviceOnHtml = to;
		}
		
		/**
		 * Switch to embed fonts while loading a plain text? (default = true)
		 */
		public function get embedOnText():Boolean {
			return (this._content[0].embedOnText);
		}
		public function set embedOnText(to:Boolean):void {
			this._content[0].embedOnText = to;
			this._content[1].embedOnText = to;
		}
		
		/**
		 * Is the text selectable?
		 */
		public function get textSelectable():Boolean {
			return(this._content[0].textSelectable);
		}
		public function set textSelectable(to:Boolean):void {
			this._content[0].textSelectable = to;
			this._content[1].textSelectable = to;
		}
		
		/**
		 * Vertical position of text (returns NaN if loaded type is not text).
		 */
		public function get textScrollV():int {
			if (this._content[this._currentLayer].loadedType == LoadedFile.TYPE_TEXT) return (this._content[this._currentLayer].textScrollV);
			else return(NaN);
		}
		public function set textScrollV(to:int):void {
			if (this._content[this._currentLayer].loadedType == LoadedFile.TYPE_TEXT) {
				this._content[this._currentLayer].textScrollV = to;
			}
		}
		
		/**
		 * Horizontal position of text (returns NaN if loaded type is not text).
		 */
		public function get textScrollH():int {
			if (this._content[this._currentLayer].loadedType == LoadedFile.TYPE_TEXT) return (this._content[this._currentLayer].textScrollH);
			else return(NaN);
		}
		public function set textScrollH(to:int):void {
			if (this._content[this._currentLayer].loadedType == LoadedFile.TYPE_TEXT) {
				this._content[this._currentLayer].textScrollH = to;
			}
		}
		
		/**
		 * Text display mode: paragraph or artistic. Chenging to artistic mode on device text will not be effective.
		 */
		public function get textMode():String {
			return (this._content[0].textMode);
		}
		public function set textMode(to:String):void {
			this._content[0].textMode = to;
			this._content[1].textMode = to;
		}
		
		/**
		 * Picture display mode: stretch or crop.
		 */
		public function get displayMode():String {
			return (this._content[0].displayMode);
		}
		public function set displayMode(to:String):void {
			this._content[0].displayMode = to;
			this._content[1].displayMode = to;
		}
		
		/**
		 * Start playing media as soon as it is possible? (default = true)
		 */
		public function get playOnLoad():Boolean {
			return (this._content[0].playOnLoad);
		}
		public function set playOnLoad(to:Boolean):void {
			this._content[0].playOnLoad = to;
			this._content[1].playOnLoad = to;
		}
		
		/**
		 * Loop playback media (video and audio)?
		 */
		public function get loop():Boolean {
			return (this._content[0].loop);
		}
		public function set loop(to:Boolean):void {
			this._content[0].loop = to;
			this._content[1].loop = to;
		}
		
		/**
		 * Sets the update interval for media playback. (default is optimized for speed)
		 * @see	art.ciclope.util.MediaDefinitions
		 */
		public function get playbackInterval():uint {
			return (this._content[0].playbackInterval);
		}
		public function set playbackInterval(to:uint):void {
			this._content[0].playbackInterval = to;
			this._content[1].playbackInterval = to;
		}
		
		/**
		 * Buffer size (in % of loaded file) required to start playing stream media (from 2% to 99%). (default = 10%)
		 */
		public function get bufferSize():uint {
			return (this._content[0].bufferSize);
		}
		public function set bufferSize(to:uint):void {
			this._content[0].bufferSize = to;
			this._content[1].bufferSize = to;
		}
		
		/**
		 * Should bitmaps and videos be smoothed on resize? (default = false)
		 */
		public function get smoothing():Boolean {
			return (this._content[0].smoothing);
		}
		public function set smoothing(to:Boolean):void {
			this._content[0].smoothing = to;
			this._content[1].smoothing = to;
		}
		
		/**
		 * The subtitle text format.
		 */
		public function get subtitleTextFormat():TextFormat {
			return (this._content[0].subtitleTextFormat);
		}
		public function set subtitleTextFormat(to:TextFormat):void {
			this._content[0].subtitleTextFormat = to;
			this._content[1].subtitleTextFormat = to;
		}
		
		/**
		 * Use embed fonts in subtitle text?
		 */
		public function get subtitleEmbed():Boolean {
			return (this._content[0].subtitleEmbed);
		}
		public function set subtitleEmbed(to:Boolean):void {
			this._content[0].subtitleEmbed = to;
			this._content[1].subtitleEmbed = to;
		}
		
		/**
		 * Is subtitle text visible?
		 */
		public function get subtitleVisible():Boolean {
			return (this._content[0].subtitleVisible);
		}
		public function set subtitleVisible(to:Boolean):void {
			this._content[0].subtitleVisible = this._content[1].subtitleVisible = to;
		}
		
		/**
		 * Show media playback interface?
		 */
		public function get showInterface():Boolean {
			return (this._showInterface);
		}
		public function set showInterface(to:Boolean):void {
			this._showInterface = to;
			if (this.isStream) this._interface.visible = to;
		}
		
		/**
		 * Is media interface active (receiving mouse clicks)?
		 */
		public function get active():Boolean {
			return (this.mouseChildren);
		}
		public function set active(to:Boolean):void {
			//this.mouseChildren = to;
		}
		
		/**
		 * The playback sound volume.
		 */
		public function get volume():Number {
			return (this._content[0].volume);
		}
		public function set volume(to:Number):void {
			this._content[0].volume = to;
			this._content[1].volume = to;
		}
		
		/**
		 * Is playback sound mute? (default = false)
		 */
		public function get mute():Boolean {
			return (this._content[0].mute);
		}
		public function set mute(to:Boolean):void {
			this._content[0].mute = to;
			this._content[1].mute = to;
		}
		
		/**
		 * The left-to-right panning of the sound, ranging from -1 (full pan left) to 1 (full pan right).
		 */
		public function get soundPan():Number {
			return (this._content[0].soundPan);
		}
		public function set soundPan(to:Number):void {
			this._content[0].soundPan = to;
			this._content[1].soundPan = to;
		}
		
		/**
		 * A value, from 0 (none) to 1 (all), specifying how much of the left input is played in the left speaker.
		 */
		public function get soundLeftToLeft():Number {
			return (this._content[0].soundLeftToLeft);
		}
		public function set soundLeftToLeft(to:Number):void {
			this._content[0].soundLeftToLeft = to;
			this._content[1].soundLeftToLeft = to;
		}
		
		/**
		 * A value, from 0 (none) to 1 (all), specifying how much of the left input is played in the right speaker.
		 */
		public function get soundLeftToRight():Number {
			return (this._content[0].soundLeftToRight);
		}
		public function set soundLeftToRight(to:Number):void {
			this._content[0].soundLeftToRight = to;
			this._content[1].soundLeftToRight = to;
		}
		
		/**
		 * A value, from 0 (none) to 1 (all), specifying how much of the right input is played in the left speaker.
		 */
		public function get soundRightToLeft():Number {
			return (this._content[0].soundRightToLeft);
		}
		public function set soundRightToLeft(to:Number):void {
			this._content[0].soundRightToLeft = to;
			this._content[1].soundRightToLeft = to;
		}
		
		/**
		 * A value, from 0 (none) to 1 (all), specifying how much of the right input is played in the right speaker.
		 */
		public function get soundRightToRight():Number {
			return (this._content[0].soundRightToRight);
		}
		public function set soundRightToRight(to:Number):void {
			this._content[0].soundRightToRight = to;
			this._content[1].soundRightToRight = to;
		}
		
		/**
		 * The animation update frequency in miliseconds.
		 */
		public function get animationUpdate():uint {
			return (this._content[0].animationUpdate);
		}
		public function set animationUpdate(to:uint):void {
			this._content[0].animationUpdate = to;
			this._content[1].animationUpdate = to;
		}
		
		/**
		 * Reposition animation images every time they are redrawn? Useful if you manipulate the images outside this class - leave false otherwise.
		 */
		public function get animationReplaceOnRedraw():Boolean {
			return (this._content[0].animationReplaceOnRedraw);
		}
		public function set animationReplaceOnRedraw(to:Boolean):void {
			this._content[0].animationReplaceOnRedraw = to;
			this._content[1].animationReplaceOnRedraw = to;
		}
		
		// READ-ONLY VALUES
		
		/**
		 * The type of the loaded file.
		 * @see	art.ciclope.util.LoadedFile
		 */
		public function get loadedType():String {
			return (this._content[this._currentLayer].loadedType);
		}
		
		/**
		 * Is the currently loaded file a stream (audio or video)?
		 */
		public function get isStream():Boolean {
			return (LoadedFile.isStream(this._content[this._currentLayer].loadedType));
		}
		
		/**
		 * The media playback state.
		 * @see	art.ciclope.util.MediaDefinitions
		 */
		public function get mediaState():String {
			return (this._content[this._currentLayer].mediaState);
		}
		
		/**
		 * The amount of the file already loaded (in %; always return 100 if media is not of a stream type - audio or video).
		 */
		public function get amountLoaded():uint {
			return (this._content[this._currentLayer].amountLoaded);
		}
		
		/**
		 * Current playback time in seconds. Returns 0 if the file is a picture, Flash movie or text.
		 */
		public function get currentTime():Number {
			if (this._zeroTime) {
				return (0);
			} else if (this._tweening) {
				// tweening? consider the time of the other layer
				return (this._content[this._otherContent].currentTime);
			} else {
				// return the current layer time
				return (this._content[this._currentLayer].currentTime);
			}
		}
		
		/**
		 * Total playback time in seconds. Returns 0 if the file is a picture, Flash movie or text.
		 */
		public function get totalTime():Number {
			if (this._zeroTime) {
				return (0);
			} else if (this._tweening) {
				// tweening? consider the time of the other layer
				return (this._content[this._otherContent].totalTime);
			} else {
				// return the current layer time
				return (this._content[this._currentLayer].totalTime);
			}
		}
		
		/**
		 * The currently loaded file.
		 */
		public function get currentFile():String {
			return (this._content[this._currentLayer].currentFile);
		}
		
		/**
		 * The original width of the loaded file.
		 */
		public function get originalWidth():Number {
			return(this._content[this._currentLayer].originalWidth);
		}
		
		/**
		 * The original height of the loaded file.
		 */
		public function get originalHeight():Number {
			return(this._content[this._currentLayer].originalHeight);
		}
		
		/**
		 * Maximum vertical position of the text.
		 */
		public function get textMaxScrollV():int {
			return (this._content[this._currentLayer].textMaxScrollV);
		}
		
		/**
		 * Maximum horizontal position of the text.
		 */
		public function get textMaxScrollH():int {
			return (this._content[this._currentLayer].textMaxScrollH);
		}
		
		/**
		 * The current text shown (empty string if current content is not a text).
		 */
		public function get currentText():String {
			if (this._content[this._currentLayer].loadedType == LoadedFile.TYPE_TEXT) return (this._content[this._currentLayer].currentText);
			else return ("");
		}
		
		/**
		 * Is there a media file loading?
		 */
		public function get loading():Boolean {
			return (this._loading);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Start loading a file.
		 * @param	path to the file
		 */
		public function loadFile(path:String):void {
			if (path != this._lastLoad) {
				if (this._bgpicture != null) {
					this._bgpicture.visible = false;
					if ((LoadedFile.typeOf(path) == LoadedFile.TYPE_PICTURE) || (LoadedFile.typeOf(path) == LoadedFile.TYPE_FLASH)) {
						this._bgpicture.visible = true;
					}
				}
				if (this._bgaudio != null) {
					this._bgaudio.visible = false;
					if (LoadedFile.typeOf(path) == LoadedFile.TYPE_AUDIO) {
						this._bgaudio.visible = true;
					}
				}
				if (this._bgvideo != null) {
					this._bgvideo.visible = false;
					if (LoadedFile.typeOf(path) == LoadedFile.TYPE_VIDEO) {
						this._bgvideo.visible = true;
					}
				}
				this._lastLoad = path;
				this._loading = true;
				this._bg.visible = !this._transparent;
				this._content[this._currentLayer].active = false;
				this._content[this._otherContent].active = true;
				this._content[this._otherContent].loadFile(path);
				// force time to zero until new media is loaded
				this._zeroTime = true;
			}
		}
		
		/**
		 * Load the system webcam input to the video.
		 */
		public function loadWebcam():void {
			if (this._bgpicture != null) this._bgpicture.visible = false;
			if (this._bgaudio != null) this._bgaudio.visible = false;
			if (this._bgvideo != null) 	this._bgvideo.visible = false;
			this._lastLoad = "webcam";
			//if (this._tweening) this.onTweenEnd(false);
			this._bg.visible = !this._transparent;
			this._content[this._otherContent].loadWebcam();
		}
		
		/**
		 * Set media background display.
		 * @param	transparent	should background be transparent?
		 * @param	color	the color of the background
		 * @param	forpic	a sprite class used for content-sensitive background (for pictures and swf)
		 * @param	foraudio	a sprite class used for content-sensitive background (for audio)
		 * @param	forvideo	a sprite class used for content-sensitive background (for video)
		 */
		public function setBackground(transparent:Boolean, color:uint = 0x000000, alpha:Number = 1, forpic:Class = null, foraudio:Class = null, forvideo:Class = null):void {
			// is bg visible?
			this._transparent = transparent;
			// background color sprite
			this._bgColor = color;
			this._bg.graphics.clear();
			this._bg.graphics.beginFill(this._bgColor, alpha);
			this._bg.graphics.drawRect(0, 0, this.width, this.height);
			this._bg.graphics.endFill();
			this._bg.x = -width / 2;
			this._bg.y = -height / 2;
			this._bg.visible = !transparent;
			// icons for content-sensitive backgrounds
			while (this._mediaBG.numChildren > 0) this._mediaBG.removeChildAt(0);
			if (forpic != null) {
				this._bgpicture = new forpic() as Sprite;
				this._bgpicture.visible = false;
				this._bgpicture.width = this._setWidth;
				this._bgpicture.height = this._setHeight;
				this._mediaBG.addChild(this._bgpicture);
			}
			if (foraudio != null) {
				this._bgaudio = new foraudio() as Sprite;
				this._bgaudio.visible = false;
				this._bgaudio.width = this._setWidth;
				this._bgaudio.height = this._setHeight;
				this._mediaBG.addChild(this._bgaudio);
			}
			if (forvideo != null) {
				this._bgvideo = new forvideo() as Sprite;
				this._bgvideo.visible = false;
				this._bgvideo.width = this._setWidth;
				this._bgvideo.height = this._setHeight;
				this._mediaBG.addChild(this._bgvideo);
			}
		}
		
		/**
		 * Set the content to plain text.
		 * @param	to	The text string.
		 */
		public function setText(to:String):void {
			if (this._content[this._currentLayer].currentText != to) {		
				this._lastLoad = "settext";
				//if (this._tweening) this.onTweenEnd(false);
				this._content[this._otherContent].setText(to);
			}
		}
		
		/**
		 * Set the html content of current text.
		 * @param	to	The html-formatted text.
		 */
		public function setHTMLText(to:String):void {
			if (this._content[this._currentLayer].currentText != to) {	
				this._lastLoad = "settext";
				//if (this._tweening) this.onTweenEnd(false);
				this._content[this._otherContent].setHTMLText(to);
			}
		}
		
		/**
		 * Set CSS formatting to the HTML text.
		 * @param	css	the style sheet to apply
		 */
		public function setStyle(css:StyleSheet):void {
			this._content[0].setStyle(css);
			this._content[1].setStyle(css);
		}
		
		/**
		 * Set the content to an already loaded and ready display object.
		 * @param	to	The display object to show.
		 */
		public function setGraphic(to:DisplayObject):void {
			this._lastLoad = "display";
			//if (this._tweening) this.onTweenEnd(false);
			this._content[this._otherContent].setGraphic(to);
		}
		
		/**
		 * Load a sequence of images into an animation.
		 * @param	urls	An array with image paths (String).
		 * @param	placing	Animaton centre point according to Placing constants.
		 * @param	update	Update interval in miliseconds (default is 83 = 12 fps).
		 * @return	true if the animation can be set, false otherwise (incorrect file types).
		 */
		public function loadAnimation(urls:Array, placing:String = Placing.CENTER, update:uint = 83):Boolean {
			this._lastLoad = "animation";
			//if (this._tweening) this.onTweenEnd(false);
			return (this._content[this._otherContent].loadAnimation(urls, placing, update));
		}
		
		/**
		 * Play a loaded playable media (video, audio or animation).
		 * @param	time	time position to play (-1 for current)
		 * @param	bycode	not used (only for compatibility purposes)
		 */
		public function play(time:int = -1, bycode:Boolean = false):void {
			this._content[this._currentLayer].play(time);
		}
		
		/**
		 * Pause a loaded playable media (video, audio or animation).
		 */
		public function pause():void {
			this._content[this._currentLayer].pause();
		}
		
		/**
		 * Stop a loaded playable media (video, audio or animation).
		 */
		public function stop():void {
			this._content[this._currentLayer].stop();
		}
		
		/**
		 * Seek to a time at a stream media (in seconds).
		 */
		public function seek(to:uint):void {
			this._content[this._currentLayer].seek(to);
		}
		
		/**
		 * Seek to a position (0 to 100%) on current media file.
		 * @param	to	position in percent of file
		 */
		public function seekPosition(to:uint):void {
			this.seek(uint((this.totalTime) * (to / 100)));
		}
		
		/**
		 * Set the subtitle to a defined text. Leave null to use standard file subtitles, if any.
		 * @param	to	the subtitle text to force or null to keep using standard file subtitles
		 */
		public function setSubtitle(to:String):void {
			this._content[0].setSubtitle(to);
			this._content[1].setSubtitle(to);
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			// remove listeners
			this._content[0].removeEventListener(Loading.FINISHED, contentFinished);
			this._content[1].removeEventListener(Loading.FINISHED, contentFinished);
			this._content[0].removeEventListener(Loading.ERROR_IO, contentIOError);
			this._content[1].removeEventListener(Loading.ERROR_IO, contentIOError);
			this._content[0].removeEventListener(Loading.PROGRESS, contentProgress);
			this._content[1].removeEventListener(Loading.PROGRESS, contentProgress);
			this._content[0].removeEventListener(Loading.UNLOAD, contentUnload);
			this._content[1].removeEventListener(Loading.UNLOAD, contentUnload);
			this._content[0].removeEventListener(Loading.START, contentStart);
			this._content[1].removeEventListener(Loading.START, contentStart);
			this._content[0].removeEventListener(Loading.ERROR_SECURITY, contentSecurityError);
			this._content[1].removeEventListener(Loading.ERROR_SECURITY, contentSecurityError);
			this._content[0].removeEventListener(Loading.STREAM_COMPLETE, contentStreamComplete);
			this._content[1].removeEventListener(Loading.STREAM_COMPLETE, contentStreamComplete);
			this._content[0].removeEventListener(Loading.HTTP_STATUS, contentHttpStatus);
			this._content[1].removeEventListener(Loading.HTTP_STATUS, contentHttpStatus);
			this._content[0].removeEventListener(Playing.MEDIA_PLAY, contentPlay);
			this._content[1].removeEventListener(Playing.MEDIA_PLAY, contentPlay);
			this._content[0].removeEventListener(Playing.MEDIA_PAUSE, contentPause);
			this._content[1].removeEventListener(Playing.MEDIA_PAUSE, contentPause);
			this._content[0].removeEventListener(Playing.MEDIA_STOP, contentStop);
			this._content[1].removeEventListener(Playing.MEDIA_STOP, contentStop);
			this._content[0].removeEventListener(Playing.MEDIA_SEEK, contentSeek);
			this._content[1].removeEventListener(Playing.MEDIA_SEEK, contentSeek);
			this._content[0].removeEventListener(Playing.MEDIA_PROGRESS, contentMediaProgress);
			this._content[1].removeEventListener(Playing.MEDIA_PROGRESS, contentMediaProgress);
			this._content[0].removeEventListener(Playing.MEDIA_LOOP, contentLoop);
			this._content[1].removeEventListener(Playing.MEDIA_LOOP, contentLoop);
			this._content[0].removeEventListener(Playing.MEDIA_END, contentEnd);
			this._content[1].removeEventListener(Playing.MEDIA_END, contentEnd);
			this._content[0].removeEventListener(Playing.MEDIA_CUE, contentCue);
			this._content[1].removeEventListener(Playing.MEDIA_CUE, contentCue);
			this._content[0].removeEventListener(TextEvent.LINK, onLink);
			this._content[1].removeEventListener(TextEvent.LINK, onLink);
			this._content[0].removeEventListener(Message.MOUSEOVER, onMouseOver);
			this._content[0].removeEventListener(Message.MOUSEOUT, onMouseOut);
			this._content[1].removeEventListener(Message.MOUSEOVER, onMouseOver);
			this._content[1].removeEventListener(Message.MOUSEOUT, onMouseOut);
			// remove tweens
			Tweener.removeTweens(this._content[0]);
			Tweener.removeTweens(this._content[1]);
			// clearing the displays
			this._media.removeChild(this._content[0]);
			this._media.removeChild(this._content[1]);
			this._content[0].kill();
			this._content[1].kill();
			this._content.shift();
			this._content.shift();
			this._content = null;
			// graphic elements
			this._media.mask = null;
			this.removeChild(this._media);
			this._media = null;
			this.removeChild(this._mask);
			this._mask.graphics.clear();
			this._mask = null;
			this.removeChild(this.bgLayer);
			this.bgLayer.graphics.clear();
			this.bgLayer = null;
			// playback interface
			this._interface.kill();
			this.removeChild(this._interface);
			this._interface = null;
			// background
			this._bg.graphics.clear();
			this.removeChild(this._bg);
			this._bg = null;
			while (this._mediaBG.numChildren > 0) this._mediaBG.removeChildAt(0);
			this.removeChild(this._mediaBG);
			this._mediaBG = null;
			this._bgpicture = null;
			this._bgvideo = null;
			this._bgaudio = null;
			// clear variables
			this._transition = null;
			this._lastLoad = null;
		}
		
		// PRIVATE AND PROTECTED METHODS
		
		/**
		 * The content holder not shown at the moment. (read-only)
		 */
		protected function get _otherContent():uint {
			if (this._currentLayer == 0) return (1);
			else return (0);
		}
		
		/**
		 * Swapping the current content layer.
		 */
		protected function swapCurrent():void {
			if (this._currentLayer == 0) {
				this._currentLayer = 1;
				this._content[0].visible = false;
			} else {
				this._currentLayer = 0;
				this._content[1].visible = false;
			}
			this._loading = false;
			this._zeroTime = false;
			this.dispatchEvent(new Loading(Loading.CONTENT_CHANGED));
		}
		
		/**
		 * Start simplemedia objects exchange considering current transition animation.
		 */
		protected function startTransition():void {
			// show both contents
			this._content[0].visible = true;
			this._content[1].visible = true;
			// assigning transition start
			this._tweening = true;
			// setting up requested transition
			switch (this._transition) {
				case MediaDisplay.TRANSITION_UP:
					this._content[this._otherContent].alpha = 1.0;
					this._content[this._otherContent].width = this._setWidth;
					this._content[this._otherContent].height = this._setHeight;
					this._content[this._otherContent].x = this._content[this._currentLayer].x;
					this._content[this._otherContent].y = this._content[this._currentLayer].y + this._setHeight;
					this._content[this._otherContent].visible = true;
					break;
				case MediaDisplay.TRANSITION_DOWN:
					this._content[this._otherContent].alpha = 1.0;
					this._content[this._otherContent].width = this._setWidth;
					this._content[this._otherContent].height = this._setHeight;
					this._content[this._otherContent].x = this._content[this._currentLayer].x;
					this._content[this._otherContent].y = this._content[this._currentLayer].y - this._setHeight;
					this._content[this._otherContent].visible = true;
					break;
				case MediaDisplay.TRANSITION_RIGHT:
					this._content[this._otherContent].alpha = 1.0;
					this._content[this._otherContent].width = this._setWidth;
					this._content[this._otherContent].height = this._setHeight;
					this._content[this._otherContent].x = this._content[this._currentLayer].x - this._setWidth;
					this._content[this._otherContent].y = this._content[this._currentLayer].y;
					this._content[this._otherContent].visible = true;
					break;
				case MediaDisplay.TRANSITION_LEFT:
					this._content[this._otherContent].alpha = 1.0;
					this._content[this._otherContent].width = this._setWidth;
					this._content[this._otherContent].height = this._setHeight;
					this._content[this._otherContent].x = this._content[this._currentLayer].x + this._setWidth;
					this._content[this._otherContent].y = this._content[this._currentLayer].y;
					this._content[this._otherContent].visible = true;
					break;
				case MediaDisplay.TRANSITION_FADE:
					this._content[this._otherContent].alpha = 0.0;
					this._content[this._otherContent].width = this._setWidth;
					this._content[this._otherContent].height = this._setHeight;
					this._content[this._otherContent].x = this._content[this._currentLayer].x;
					this._content[this._otherContent].y = this._content[this._currentLayer].y;
					this._content[this._otherContent].visible = true;
					break;
				case MediaDisplay.TRANSITION_NONE:
					this._content[this._otherContent].alpha = 1.0;
					this._content[this._otherContent].width = this._setWidth;
					this._content[this._otherContent].height = this._setHeight;
					this._content[this._otherContent].x = this._content[this._currentLayer].x;
					this._content[this._otherContent].y = this._content[this._currentLayer].y;
					this._content[this._otherContent].visible = false;
					break;
			}
			// starting animation
			this._tweening = true;
			// warning listeners
			this.dispatchEvent(new Loading(Loading.TRANSITION_START, this._content[this._otherContent], this._content[this._otherContent].currentFile, this._content[this._otherContent].loadedType));
			switch (this._transition) {
				case MediaDisplay.TRANSITION_UP:
					Tweener.addTween(this._content[this._currentLayer], { y:(this._content[this._currentLayer].y - this._setHeight), time:this._update, onComplete:onTweenEnd } );
					Tweener.addTween(this._content[this._otherContent], { y:this._content[this._currentLayer].y, time:this._update } );
					break;
				case MediaDisplay.TRANSITION_DOWN:
					Tweener.addTween(this._content[this._currentLayer], { y:(this._content[this._currentLayer].y + this._setHeight), time:this._update, onComplete:onTweenEnd } );
					Tweener.addTween(this._content[this._otherContent], { y:this._content[this._currentLayer].y, time:this._update } );
					break;
				case MediaDisplay.TRANSITION_RIGHT:
					Tweener.addTween(this._content[this._currentLayer], { x:(this._content[this._currentLayer].x + this._setWidth), time:this._update, onComplete:onTweenEnd } );
					Tweener.addTween(this._content[this._otherContent], { x:this._content[this._currentLayer].x, time:this._update } );
					break;
				case MediaDisplay.TRANSITION_LEFT:
					Tweener.addTween(this._content[this._currentLayer], { x:(this._content[this._currentLayer].x - this._setWidth), time:this._update, onComplete:onTweenEnd } );
					Tweener.addTween(this._content[this._otherContent], { x:this._content[this._currentLayer].x, time:this._update } );
					break;
				case MediaDisplay.TRANSITION_FADE:
					Tweener.addTween(this._content[this._currentLayer], { alpha:0, time:this._update, onComplete:onTweenEnd } );
					Tweener.addTween(this._content[this._otherContent], { alpha:1, time:this._update } );
					break;
				case MediaDisplay.TRANSITION_NONE:
					this.onTweenEnd();
					break;
			}
		}
		
		/**
		 * A link on text was clicked.
		 */
		private function onLink(evt:TextEvent):void {
			this.dispatchEvent(evt);
			evt.stopPropagation();
		}
		
		/**
		 * Mouse over selectable text.
		 */
		private function onMouseOver(evt:Message):void {
			this.dispatchEvent(new Message(Message.MOUSEOVER));
		}
		
		/**
		 * Mouse out selectable text.
		 */
		private function onMouseOut(evt:Message):void {
			this.dispatchEvent(new Message(Message.MOUSEOUT));
		}
		
		/**
		 * A file is ready to be shown.
		 */
		private function contentFinished(evt:Loading):void {
			// start the content transition
			if (!this._tweening) this.startTransition();
			// media playback?
			if (LoadedFile.isStream(evt.fileType)) {
				this._interface.visible = this._showInterface;
			} else {
				this._interface.visible = false;
			}
			// warn listeners
			if (evt.fileName == this._lastLoad) this.dispatchEvent(new Loading(evt.type, evt.target, evt.fileName, evt.fileType));
		}
		
		/**
		 * A file download failed because of an io error.
		 */
		private function contentIOError(evt:Loading):void {
			// warn listeners
			if (evt.fileName == this._lastLoad) this.dispatchEvent(new Loading(evt.type, evt.target, evt.fileName, evt.fileType));
		}
		
		/**
		 * File download progress.
		 */
		private function contentProgress(evt:Loading):void {
			// warn listeners
			if (evt.fileName == this._lastLoad) this.dispatchEvent(new Loading(evt.type, evt.target, evt.fileName, evt.fileType, evt.bytesLoaded, evt.bytesTotal));
		}
		
		/**
		 * File unload.
		 */
		private function contentUnload(evt:Loading):void {
			// warn listeners
			if (evt.fileName == this._lastLoad) this.dispatchEvent(new Loading(evt.type, evt.target, evt.fileName, evt.fileType));
		}
		
		/**
		 * Start of file.
		 */
		private function contentStart(evt:Loading):void {
			// warn listeners
			if (evt.fileName == this._lastLoad) this.dispatchEvent(new Loading(evt.type, evt.target, evt.fileName, evt.fileType));
		}
		
		/**
		 * File access security error.
		 */
		private function contentSecurityError(evt:Loading):void {
			// warn listeners
			if (evt.fileName == this._lastLoad) this.dispatchEvent(new Loading(evt.type, evt.target, evt.fileName, evt.fileType));
		}
		
		/**
		 * Stream download complete.
		 */
		private function contentStreamComplete(evt:Loading):void {
			// warn listeners
			if (evt.fileName == this._lastLoad) this.dispatchEvent(new Loading(evt.type, evt.target, evt.fileName, evt.fileType, evt.bytesLoaded, evt.bytesTotal));
		}
		
		/**
		 * File HTTP status.
		 */
		private function contentHttpStatus(evt:Loading):void {
			// warn listeners
			if (evt.fileName == this._lastLoad) this.dispatchEvent(new Loading(evt.type, evt.target, evt.fileName, evt.fileType));
		}
		
		/**
		 * File playback play.
		 */
		private function contentPlay(evt:Playing):void {
			// media interface
			this._interface.setButtons(MediaDefinitions.PLAYBACKSTATE_PLAY);
			// warn listeners
			if (evt.fileName == this._lastLoad) this.dispatchEvent(new Playing(evt.type, evt.target, evt.fileName, evt.fileType, evt.currentTime, evt.totalTime));
		}
		
		/**
		 * File playback pause.
		 */
		private function contentPause(evt:Playing):void {
			// media interface
			this._interface.setButtons(MediaDefinitions.PLAYBACKSTATE_PAUSE);
			// warn listeners
			if (evt.fileName == this._lastLoad) this.dispatchEvent(new Playing(evt.type, evt.target, evt.fileName, evt.fileType, evt.currentTime, evt.totalTime));
		}
		
		/**
		 * File playback stop.
		 */
		private function contentStop(evt:Playing):void {
			// media interface
			this._interface.setButtons(MediaDefinitions.PLAYBACKSTATE_STOP);
			// warn listeners
			if (evt.fileName == this._lastLoad) this.dispatchEvent(new Playing(evt.type, evt.target, evt.fileName, evt.fileType, evt.currentTime, evt.totalTime));
		}
		
		/**
		 * File playback seek.
		 */
		private function contentSeek(evt:Playing):void {
			// warn listeners
			if (evt.fileName == this._lastLoad) this.dispatchEvent(new Playing(evt.type, evt.target, evt.fileName, evt.fileType, evt.currentTime, evt.totalTime));
		}
		
		/**
		 * File playback progress.
		 */
		private function contentMediaProgress(evt:Playing):void {
			// update progress bar
			if (this.isStream) this._interface.setProgress(uint(Math.round(evt.currentTime * 100 / evt.totalTime)));
			// warn listeners
			if (evt.fileName == this._lastLoad) this.dispatchEvent(new Playing(evt.type, evt.target, evt.fileName, evt.fileType, evt.currentTime, evt.totalTime));
		}
		
		/**
		 * File playback loop.
		 */
		private function contentLoop(evt:Playing):void {
			// warn listeners
			if (evt.fileName == this._lastLoad) this.dispatchEvent(new Playing(evt.type, evt.target, evt.fileName, evt.fileType, evt.currentTime, evt.totalTime));
		}
		
		/**
		 * File playback end.
		 */
		private function contentEnd(evt:Playing):void {
			// warn listeners
			if (evt.fileName == this._lastLoad) this.dispatchEvent(new Playing(evt.type, evt.target, evt.fileName, evt.fileType, evt.currentTime, evt.totalTime));
		}
		
		/**
		 * File playback cue point.
		 */
		private function contentCue(evt:Playing):void {
			// warn listeners
			if (evt.fileName == this._lastLoad) this.dispatchEvent(new Playing(evt.type, evt.target, evt.fileName, evt.fileType, evt.currentTime, evt.totalTime, evt.cueData));
		}
		
		/**
		 * Finishing content transition tween.
		 */
		protected function onTweenEnd(dispatch:Boolean = true):void {
			this._content[this._currentLayer].stop();
			this.swapCurrent();
			this._tweening = false;
			if (this.loadedType != LoadedFile.TYPE_AUDIO) this._bg.visible = false;
			if (this._bgpicture != null) this._bgpicture.visible = false;
			if (this._bgaudio != null) this._bgaudio.visible = false;
			if (this._bgvideo != null) this._bgvideo.visible = false;
			// adjust display
			this._content[this._currentLayer].x = 0;
			this._content[this._currentLayer].y = 0;
			this._content[this._currentLayer].width = this._setWidth;
			this._content[this._currentLayer].height = this._setHeight;
			this._content[this._otherContent].visible = false;
			this._content[this._currentLayer].visible = true;
			// warning listeners
			if (dispatch) this.dispatchEvent(new Loading(Loading.TRANSITION_END, this._content[this._currentLayer], this._content[this._currentLayer].currentFile, this._content[this._currentLayer].loadedType));
		}
		
	}

}
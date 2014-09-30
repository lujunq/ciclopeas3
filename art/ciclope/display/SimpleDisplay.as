package art.ciclope.display {
	
	// FLASH PACKAGES
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	import flash.text.StyleSheet;
	
	
	// CICLOPE CLASSES
	import art.ciclope.display.AudioSprite;
	import art.ciclope.display.VideoSprite;
	import art.ciclope.display.TextSprite;
	import art.ciclope.display.GraphicSprite;
	import art.ciclope.display.AnimSprite;
	import art.ciclope.event.Loading;
	import art.ciclope.event.Playing;
	import art.ciclope.util.LoadedFile;
	import art.ciclope.util.MediaDefinitions;
	import art.ciclope.util.Placing;
	import art.ciclope.event.Message;
	
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
	 * SimpleDisplay defines a sprite capable of loading and showing media content (text, pictures, flash movies (swf), audio, video and animation - image sequence).
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class SimpleDisplay extends Sprite {
		
		// VARIABLES
		
		/**
		 * File loading right now.
		 */
		private var _filename:String;
		/**
		 * Currently loaded file.
		 */
		private var _currentfile:String;
		/**
		 * The original width of the loaded content.
		 */
		private var _originalWidth:Number;
		/**
		 * The original height of the loaded content.
		 */
		private var _originalHeight:Number;
		/**
		 * The desired width.
		 */
		private var _setWidth:Number;
		/**
		 * The desired height.
		 */
		private var _setHeight:Number;
		/**
		 * The file loaded type.
		 * @see	art.ciclope.util.LoadedFile
		 */
		private var _loadedType:String;
		/**
		 * The current sound volume.
		 */
		private var _soundVolume:Number;
		/**
		 * Is the sound mute?
		 */
		private var _mute:Boolean;
		/**
		 * Sound transformation object.
		 */
		private var _soundTransform:SoundTransform;
		/**
		 * Should bitmaps and videos be smoothed on resize? (default = false)
		 */
		private var _smoothing:Boolean;
		 
		// LAYERS
		
		/**
		 * The display background (for reference).
		 */
		private var _bg:Sprite;
		/**
		 * A container for video files.
		 */
		private var _video:VideoSprite;
		/**
		 * A container for audio files.
		 */
		private var _audio:AudioSprite;
		/**
		 * A container for text.
		 */
		private var _text:TextSprite;
		/**
		 * A container for graphic files.
		 */
		private var _graphic:GraphicSprite;
		/**
		 * A container for animation.
		 */
		private var _anim:AnimSprite;
		/**
		 * Placing information about the animation.
		 */
		private var _animPlace:String;
		/**
		 * A reference to loading layer in use;
		 */
		private var _reference:*;
		
		// CONSTRUCTOR
		
		/**
		 * SimpleDisplay constructor.
		 * @param	width	The display width.
		 * @param	height	The display height.
		 * @param	audioIcon	An icon to show while playing audio only (optional).
		 */
		public function SimpleDisplay(width:Number = 160, height:Number = 90, audioIcon:DisplayObject = null) {
			// creating the background
			this._bg = new Sprite();
			this._bg.graphics.beginFill(0, 0);
			this._bg.graphics.drawRect(0, 0, width, height);
			this._bg.graphics.endFill();
			this.addChild(this._bg);
			// creating the picture layer
			this._graphic = new GraphicSprite(width, height);
			this._graphic.visible = false;
			//this.addChild(this._graphic);
			this._graphic.addEventListener(Loading.FINISHED, initHandlerPicture);
			this._graphic.addEventListener(Loading.HTTP_STATUS, httpStatusHandlerPicture);
			this._graphic.addEventListener(Loading.UNLOAD, unLoadHandlerPicture);
			this._graphic.addEventListener(Loading.ERROR_IO, ioErrorHandlerPicture);
			this._graphic.addEventListener(Loading.PROGRESS, progressHandlerPicture);
			// creating the video layer
			this._video = new VideoSprite(width, height);
			this._video.visible = false;
			this._video.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandlerMedia);
			this._video.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandlerMedia);
			this._video.addEventListener(Event.OPEN, openHandlerMedia);
			this._video.addEventListener(Event.CLOSE, closeHandlerMedia);
			this._video.addEventListener(Event.COMPLETE, completeHandlerMedia);
			this._video.addEventListener(ProgressEvent.PROGRESS, progressHandlerMedia);
			this._video.addEventListener(Loading.STREAM_COMPLETE, streamCompleteHandlerMedia);
			this._video.addEventListener(Playing.MEDIA_PLAY, playHandlerMedia);
			this._video.addEventListener(Playing.MEDIA_STOP, stopHandlerMedia);
			this._video.addEventListener(Playing.MEDIA_PAUSE, pauseHandlerMedia);
			this._video.addEventListener(Playing.MEDIA_SEEK, seekHandlerMedia);
			this._video.addEventListener(Playing.MEDIA_PROGRESS, mediaProgressHandlerMedia);
			this._video.addEventListener(Playing.MEDIA_END, endHandlerMedia);
			this._video.addEventListener(Playing.MEDIA_LOOP, endHandlerMedia);
			this._video.addEventListener(Playing.MEDIA_CUE, cueHandlerMedia);
			//this.addChild(this._video);
			// creating the audio layer
			this._audio = new AudioSprite(width, height, "", audioIcon);
			this._audio.visible = false;
			this._audio.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandlerMedia);
			this._audio.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandlerMedia);
			this._audio.addEventListener(Event.OPEN, openHandlerMedia);
			this._audio.addEventListener(Event.CLOSE, closeHandlerMedia);
			this._audio.addEventListener(Event.COMPLETE, completeHandlerMedia);
			this._audio.addEventListener(ProgressEvent.PROGRESS, progressHandlerMedia);
			this._audio.addEventListener(Loading.STREAM_COMPLETE, streamCompleteHandlerMedia);
			this._audio.addEventListener(Playing.MEDIA_PLAY, playHandlerMedia);
			this._audio.addEventListener(Playing.MEDIA_STOP, stopHandlerMedia);
			this._audio.addEventListener(Playing.MEDIA_PAUSE, pauseHandlerMedia);
			this._audio.addEventListener(Playing.MEDIA_SEEK, seekHandlerMedia);
			this._audio.addEventListener(Playing.MEDIA_PROGRESS, mediaProgressHandlerMedia);
			this._audio.addEventListener(Playing.MEDIA_END, endHandlerMedia);
			this._audio.addEventListener(Playing.MEDIA_LOOP, endHandlerMedia);
			this._audio.addEventListener(Playing.MEDIA_CUE, cueHandlerMedia);
			//this.addChild(this._audio);
			// creating the text layer
			this._text = new TextSprite(width, height);
			this._text.addEventListener(TextEvent.LINK, onLink);
			this._text.letterSpacing = 1.5;
			this._text.visible = false;
			this._text.addEventListener(Event.COMPLETE, completeHandlerText);
            this._text.addEventListener(Event.OPEN, openHandlerText);
            this._text.addEventListener(ProgressEvent.PROGRESS, progressHandlerText);
            this._text.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandlerText);
            this._text.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandlerText);
            this._text.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandlerText);
			this._text.addEventListener(Message.MOUSEOVER, onMouseOver);
			this._text.addEventListener(Message.MOUSEOUT, onMouseOut);
			//this.addChild(this._text);
			// creating the animation layer
			this._anim = new AnimSprite();
			this._anim.visible = false;
			this._anim.addEventListener(Playing.MEDIA_PLAY, playHandlerMedia);
			this._anim.addEventListener(Playing.MEDIA_PAUSE, pauseHandlerMedia);
			//this.addChild(this._anim);
			// setting up
			this._originalWidth = this._originalHeight = 100; // no content loaded yet
			this._setWidth = width;
			this._setHeight = height;
			this._loadedType = LoadedFile.TYPE_NONE;
			this.playOnLoad = true;
			this._soundVolume = 1;
			this._soundTransform = new SoundTransform();
			this._mute = false;
			this.playbackInterval = MediaDefinitions.PLAYBACKUPDATE_SPEED;
			this._reference = null;
			this._smoothing = false;
		}
		
		
		
		
		// PUBLIC METHODS
		
		/**
		 * Load a file. Supported formats: jpg, png, gif, swf, txt, htm, html, php, asp, aspx, cfm, jsp, mp3, flv, f4v, mp4, 3gp (H.264 codec).
		 * @param	path	The path to the file.
		 */
		public function loadFile(path:String):void {
			var theType:String = LoadedFile.typeOf(path);
			switch (theType) {
				case LoadedFile.TYPE_PICTURE:
					this.loadPicture(path);
					break;
				case LoadedFile.TYPE_FLASH:
					this.loadPicture(path);
					break;
				case LoadedFile.TYPE_VIDEO:
					this.loadVideo(path);
					break;
				case LoadedFile.TYPE_AUDIO:
					this.loadAudio(path);
					break;
				case LoadedFile.TYPE_TEXT:
					this.loadText(path);
					break;
			}
		}
		
		/**
		 * Load a picture or flash movie file. Supported formats: jpeg, gif, png, swf.
		 * @param	path	The path to the file.
		 */
		public function loadPicture(path:String):void {
			// sets currently loading file
			this._filename = path;
			this._graphic.load(path);
			this._graphic.width = this._setWidth;
			this._graphic.height = this._setHeight;
			this._reference = this._graphic;
		}
		
		/**
		 * Load a video file. Supported formats: flv, f4v, mp4, 3gp (H.264 codec).
		 * @param	path	The path to the file.
		 */
		public function loadVideo(path:String):void {
			// sets currently loading file
			this._filename = path;
			this._video.load(path);
			this._video.width = this._setWidth;
			this._video.height = this._setHeight;
			this._reference = this._video;
		}
		
		/**
		 * Load the system webcam input to the video.
		 */
		public function loadWebcam():void {
			this._filename = "webcam";
			this._video.showWebcam();
			this._reference = this._video;
			this._loadedType = LoadedFile.TYPE_VIDEO;
			this._graphic.visible = false;
			this._graphic.volume = 0;
			this._video.stop();
			this._audio.visible = false;
			this._audio.stop();
			this._text.visible = false;
			this._anim.visible = false;
			this._video.visible = true;
			this._video.width = this._setWidth;
			this._video.height = this._setHeight;
			this._originalWidth = this._video.originalWidth;
			this._originalHeight = this._video.originalHeight;
			
			while (this.numChildren > 0) this.removeChildAt(0);
			this.addChild(this._bg);
			this.addChild(this._reference);
			
			if (!this._mute) this._video.volume = this._soundVolume;
			this.dispatchEvent(new Loading(Loading.FINISHED, this._reference, this._currentfile, this._loadedType));
		}
		
		/**
		 * Load an audio file. Supported format: mp3.
		 * @param	path	The path to the file.
		 */
		public function loadAudio(path:String):void {
			// sets currently loading file
			this._filename = path;
			this._audio.load(path);
			this._audio.width = this._setWidth;
			this._audio.height = this._setHeight;
			this._reference = this._audio;
		}
		
		/**
		 * Load a text file. Supported formats: txt, htm, html, php, asp, aspx, cfm, jsp.
		 * @param	path	The path to the file.
		 */
		public function loadText(path:String):void {
			// sets currently loading file
			this._filename = path;
			this._text.load(path);
			this._text.width = this._setWidth;
			this._text.height = this._setHeight;
		}
		
		/**
		 * Set the content of current text.
		 * @param	to	The new text string.
		 */
		public function setText(to:String):void {
			this._currentfile = "settext";
			this._graphic.visible = false;
			this._graphic.volume = 0;
			this._video.visible = false;
			this._video.stop();
			this._audio.visible = false;
			this._audio.stop();
			this._anim.visible = false;
			this._text.setText(to);
			this._text.visible = true;
			this._text.width = this._setWidth;
			this._text.height = this._setHeight;
			this._loadedType = LoadedFile.TYPE_TEXT;
			this._originalWidth = this._text.originalWidth;
			this._originalHeight = this._text.originalHeight;
			this._reference = this._text;
			
			while (this.numChildren > 0) this.removeChildAt(0);
			this.addChild(this._bg);
			this.addChild(this._reference);
			
			this.dispatchEvent(new Loading(Loading.FINISHED, this._text, this._currentfile, this._loadedType));
		}
		
		/**
		 * Set the html content of current text.
		 * @param	to	The html-formatted text.
		 */
		public function setHTMLText(to:String):void {
			this._currentfile = "settext";
			this._graphic.visible = false;
			this._graphic.volume = 0;
			this._video.visible = false;
			this._video.stop();
			this._audio.visible = false;
			this._audio.stop();
			this._anim.visible = false;
			this._text.setHTMLText(to);
			this._text.visible = true;
			this._text.width = this._setWidth;
			this._text.height = this._setHeight;
			this._loadedType = LoadedFile.TYPE_TEXT;
			this._originalWidth = this._text.originalWidth;
			this._originalHeight = this._text.originalHeight;
			this._reference = this._text;
			
			while (this.numChildren > 0) this.removeChildAt(0);
			this.addChild(this._bg);
			this.addChild(this._reference);
			
			this.dispatchEvent(new Loading(Loading.FINISHED, this._text, this._currentfile, this._loadedType));
		}
		
		/**
		 * Set CSS formatting to the HTML text.
		 * @param	css	the style sheet to apply
		 */
		public function setStyle(css:StyleSheet):void {
			this._text.setStyle(css);
		}
		
		/**
		 * Set the content to an already loaded and ready display object.
		 * @param	to	The display object to show.
		 */
		public function setGraphic(to:DisplayObject):void {
			this._currentfile = "display";
			this._graphic.visible = true;
			this._video.visible = false;
			this._video.stop();
			this._audio.visible = false;
			this._audio.stop();
			this._text.visible = false;
			this._anim.visible = false;
			this._graphic.setContent(to);
			this._originalWidth = this._graphic.originalWidth;
			this._originalHeight = this._graphic.originalHeight;
			this._graphic.width = this._setWidth;
			this._graphic.height = this._setHeight;
			this._loadedType = LoadedFile.TYPE_OTHER;
			
			this._reference = this._graphic;
			
			while (this.numChildren > 0) this.removeChildAt(0);
			this.addChild(this._bg);
			this.addChild(this._reference);
			
			if ((!this._mute) && (this._loadedType == LoadedFile.TYPE_FLASH)) this._graphic.volume = this._soundVolume;
			// warn listeners
			this.dispatchEvent(new Loading(Loading.FINISHED, this._graphic, "display", LoadedFile.TYPE_PICTURE));
		}
		
		/**
		 * Load a sequence of images into an animation.
		 * @param	urls	An array with image paths (String).
		 * @param	placing	Animaton centre point according to Placing constants.
		 * @param	update	Update interval in miliseconds (default is 83 = 12 fps).
		 * @return	true if the animation can be set, false otherwise (incorrect file types).
		 */
		public function loadAnimation(urls:Array, placing:String = Placing.CENTER, update:uint = 83):Boolean {
			// removing previous animation
			this.removeChild(this._anim);
			this._anim.removeEventListener(Playing.MEDIA_PLAY, playHandlerMedia);
			this._anim.removeEventListener(Playing.MEDIA_PAUSE, pauseHandlerMedia);
			this._anim.kill();
			// creating new animation
			this._anim = new AnimSprite(update);
			this._anim.addEventListener(Playing.MEDIA_PLAY, playHandlerMedia);
			this._anim.addEventListener(Playing.MEDIA_PAUSE, pauseHandlerMedia);
			this._anim.smoothing = this._smoothing;
			var animOK:Boolean = this._anim.loadAnimation("animation", urls, placing);
			if (animOK) {
				// prepare values
				this._currentfile = "animation";
				this._loadedType = LoadedFile.TYPE_ANIMATION;
				this._graphic.visible = false;
				this._graphic.volume = 0;
				this._video.visible = false;
				this._video.stop();
				this._audio.visible = false;
				this._audio.stop();
				this._text.visible = false;
				this._originalWidth = this.width;
				this._originalHeight = this.height;
				this._reference = this._anim;
				
				this._reference = this._anim;
				
				while (this.numChildren > 0) this.removeChildAt(0);
				this.addChild(this._bg);
				this.addChild(this._reference);
				
				// set animation
				this._animPlace = placing;
				this.placeAnimation();
				//this.addChild(this._anim);
				// warn listeners
				this.dispatchEvent(new Loading(Loading.FINISHED, this._reference, this._currentfile, this._loadedType));
			}
			return (animOK);
		}
		
		/**
		 * Play a loaded playable media (video, audio or animation).
		 * @param time	time position to play (-1 for current)
		 */
		public function play(time:int = -1):void {
			if (this._reference) this._reference.play(time);
		}
		
		/**
		 * Pause a loaded playable media (video, audio or animation).
		 */
		public function pause():void {
			if (this._reference) this._reference.pause();
		}
		
		/**
		 * Stop a loaded playable media (video, audio or animation).
		 */
		public function stop():void {
			if (this._reference) this._reference.stop();
		}
		
		/**
		 * Seek to a time at a stream media (in seconds).
		 */
		public function seek(to:uint):void {
			if (this._reference) this._reference.seek(to);
		}
		
		/**
		 * Set the subtitle to a defined text. Leave null to use standard file subtitles, if any.
		 * @param	to	the subtitle text to force or null to keep using standard file subtitles
		 */
		public function setSubtitle(to:String):void {
			this._video.setSubtitle(to);
			this._audio.setSubtitle(to);
		}
		
		/**
		 * Release memory used by this object.
		 */
		public function kill():void {
			// removing visual elements
			while (this.numChildren > 0) this.removeChildAt(0);
			this._graphic.removeEventListener(Loading.FINISHED, initHandlerPicture);
			this._graphic.removeEventListener(Loading.HTTP_STATUS, httpStatusHandlerPicture);
			this._graphic.removeEventListener(Loading.UNLOAD, unLoadHandlerPicture);
			this._graphic.removeEventListener(Loading.ERROR_IO, ioErrorHandlerPicture);
			this._graphic.removeEventListener(Loading.PROGRESS, progressHandlerPicture);
			this._video.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandlerMedia);
			this._video.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandlerMedia);
			this._video.removeEventListener(Event.OPEN, openHandlerMedia);
			this._video.removeEventListener(Event.CLOSE, closeHandlerMedia);
			this._video.removeEventListener(Event.COMPLETE, completeHandlerMedia);
			this._video.removeEventListener(ProgressEvent.PROGRESS, progressHandlerMedia);
			this._video.removeEventListener(Loading.STREAM_COMPLETE, streamCompleteHandlerMedia);
			this._video.removeEventListener(Playing.MEDIA_PLAY, playHandlerMedia);
			this._video.removeEventListener(Playing.MEDIA_STOP, stopHandlerMedia);
			this._video.removeEventListener(Playing.MEDIA_PAUSE, pauseHandlerMedia);
			this._video.removeEventListener(Playing.MEDIA_SEEK, seekHandlerMedia);
			this._video.removeEventListener(Playing.MEDIA_PROGRESS, mediaProgressHandlerMedia);
			this._video.removeEventListener(Playing.MEDIA_END, endHandlerMedia);
			this._video.removeEventListener(Playing.MEDIA_LOOP, endHandlerMedia);
			this._video.removeEventListener(Playing.MEDIA_CUE, cueHandlerMedia);
			this._audio.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandlerMedia);
			this._audio.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandlerMedia);
			this._audio.removeEventListener(Event.OPEN, openHandlerMedia);
			this._audio.removeEventListener(Event.CLOSE, closeHandlerMedia);
			this._audio.removeEventListener(Event.COMPLETE, completeHandlerMedia);
			this._audio.removeEventListener(ProgressEvent.PROGRESS, progressHandlerMedia);
			this._audio.removeEventListener(Loading.STREAM_COMPLETE, streamCompleteHandlerMedia);
			this._audio.removeEventListener(Playing.MEDIA_PLAY, playHandlerMedia);
			this._audio.removeEventListener(Playing.MEDIA_STOP, stopHandlerMedia);
			this._audio.removeEventListener(Playing.MEDIA_PAUSE, pauseHandlerMedia);
			this._audio.removeEventListener(Playing.MEDIA_SEEK, seekHandlerMedia);
			this._audio.removeEventListener(Playing.MEDIA_PROGRESS, mediaProgressHandlerMedia);
			this._audio.removeEventListener(Playing.MEDIA_END, endHandlerMedia);
			this._audio.removeEventListener(Playing.MEDIA_LOOP, endHandlerMedia);
			this._audio.removeEventListener(Playing.MEDIA_CUE, cueHandlerMedia);
			this._text.removeEventListener(Event.COMPLETE, completeHandlerText);
            this._text.removeEventListener(Event.OPEN, openHandlerText);
            this._text.removeEventListener(ProgressEvent.PROGRESS, progressHandlerText);
            this._text.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandlerText);
            this._text.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandlerText);
            this._text.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandlerText);
			this._text.removeEventListener(Message.MOUSEOVER, onMouseOver);
			this._text.removeEventListener(Message.MOUSEOUT, onMouseOut);
			this._text.removeEventListener(TextEvent.LINK, onLink);
			this._anim.removeEventListener(Playing.MEDIA_PLAY, playHandlerMedia);
			this._anim.removeEventListener(Playing.MEDIA_PAUSE, pauseHandlerMedia);
			this._bg.graphics.clear();
			this._video.kill();
			this._graphic.kill();
			this._audio.kill();
			this._text.kill();
			this._anim.kill();
			this._video = null;
			this._audio = null;
			this._graphic = null;
			this._anim = null;
			this._text = null;
			this._bg = null;
			// other variables
			this._filename = null;
			this._currentfile = null;
			this._loadedType = null;
			this._soundTransform = null;
			this._reference = null;
		}
		
		// PROPERTIES
		
		/**
		 * The display width, in pixels.
		 */
		override public function get width():Number { return (this._setWidth); }
		override public function set width(value:Number):void {
			// setting reference value
			this._setWidth = value;
			// adjusting all sprites
			this._bg.width = width;
			if (this._graphic.visible) this._graphic.width = width;
			if (this._video.visible) this._video.width = width;
			if (this._audio.visible) this._audio.width = width;
			if (this._text.visible) this._text.width = width;
			if (this._anim.visible) this._anim.scaleX = this._video.scaleX;
			this.placeAnimation();
		}
		
		/**
		 * The display height, in pixels.
		 */
		override public function get height():Number { return (this._setHeight); }
		override public function set height(value:Number):void {
			// setting reference value
			this._setHeight = value;
			// adjusting all sprites
			this._bg.height = height;
			if (this._graphic.visible) this._graphic.height = height;
			if (this._video.visible) this._video.height = height;
			if (this._audio.visible) this._audio.height = height;
			if (this._text.visible) this._text.height = height;
			if (this._anim.visible) this._anim.scaleY = this._video.scaleY;
			this.placeAnimation();
		}
		
		// READ-ONLY VALUES
		
		/**
		 * The type of the loaded file.
		 * @see	art.ciclope.util.LoadedFile
		 */
		public function get loadedType():String {
			return (this._loadedType);
		}
		
		/**
		 * Is the currently loaded file a stream (audio or video)?
		 */
		public function get isStream():Boolean {
			return (LoadedFile.isStream(this._loadedType));
		}
		
		/**
		 * the currently loaded file.
		 */
		public function get currentFile():String {
			return (this._currentfile);
		}
		
		/**
		 * The media playback state.
		 * @see	art.ciclope.util.MediaDefinitions
		 */
		public function get mediaState():String {
			if (this._reference) return (this._reference.mediaState);
			else return (MediaDefinitions.PLAYBACKSTATE_UNLOAD);
		}
		
		/**
		 * Maximum vertical position of the text.
		 */
		public function get textMaxScrollV():int {
			return (this._text.maxScrollV);
		}
		
		/**
		 * Maximum horizontal position of the text.
		 */
		public function get textMaxScrollH():int {
			return (this._text.maxScrollH);
		}
		
		/**
		 * The current content of text element.
		 */
		public function get currentText():String {
			return (this._text.currentText);
		}
		
		/**
		 * The amount of the file already loaded (in %; always return 100 if media is not of a stream type - audio or video).
		 */
		public function get amountLoaded():uint {
			if (LoadedFile.isStream(this.loadedType)) {
				return (this._reference.amountLoaded);
			} else {
				return (100);
			}
		}
		
		/**
		 * Current playback time in seconds. Returns 0 if the file is a picture, Flash movie or text.
		 */
		public function get currentTime():Number {
			if (LoadedFile.isStream(this.loadedType) || (this.loadedType == LoadedFile.TYPE_ANIMATION)) {
				return (this._reference.currentTime);
			} else {
				return (0);
			}
		}
		
		/**
		 * Total playback time in seconds. Returns 0 if the file is a picture, Flash movie or text.
		 */
		public function get totalTime():Number {
			if (LoadedFile.isStream(this.loadedType) || (this.loadedType == LoadedFile.TYPE_ANIMATION)) {
				return (this._reference.totalTime);
			} else {
				return (0);
			}
		}
		
		/**
		 * Original content width.
		 */
		public function get originalWidth():Number {
			return (this._originalWidth);
		}
		
		/**
		 * Original content height.
		 */
		public function get originalHeight():Number {
			return (this._originalHeight);
		}
		
		// PROPERTIES
		
		/**
		 * Picture display mode: stretch or crop.
		 */
		public function get displayMode():String {
			return (this._graphic.displayMode);
		}
		public function set displayMode(to:String):void {
			this._graphic.displayMode = to;
		}
		
		/**
		 * Start playing media as soon as it is possible? (default = true)
		 */
		public function get playOnLoad():Boolean {
			return (this._video.playOnLoad);
		}
		public function set playOnLoad(to:Boolean):void {
			this._video.playOnLoad = to;
			this._audio.playOnLoad = to;
		}
		
		/**
		 * The playback sound volume.
		 */
		public function get volume():Number {
			return (this._soundVolume);
		}
		public function set volume(to:Number):void {
			if (to < 0) to = 0;
			else if (to > 1) to = 1;
			this._soundVolume = to;
			if (!this._mute) {
				this._soundTransform.volume = to;
				if ((!this._mute) && (this._loadedType == LoadedFile.TYPE_VIDEO)) this._video.volume = to;
				if ((!this._mute) && (this._loadedType == LoadedFile.TYPE_AUDIO)) this._audio.volume = to;
				if ((!this._mute) && (this._loadedType == LoadedFile.TYPE_FLASH)) this._graphic.volume = to;
			}
		}
		
		/**
		 * Is playback sound mute? (default = false)
		 */
		public function get mute():Boolean {
			return (this._mute);
		}
		public function set mute(to:Boolean):void {
			this._mute = to;
			if (this._mute) {
				this._soundTransform.volume = 0;
				this._video.volume = 0;
				this._audio.volume = 0;
				this._graphic.volume = 0;
			} else {
				this._soundTransform.volume = this._soundVolume;
				if (this._loadedType == LoadedFile.TYPE_VIDEO) this._video.volume = this._soundVolume;
				if (this._loadedType == LoadedFile.TYPE_AUDIO) this._audio.volume = this._soundVolume;
				if (this._loadedType == LoadedFile.TYPE_FLASH) this._graphic.volume = this._soundVolume;
			}
		}
		
		public function get active():Boolean {
			return (this._audio.active);
		}
		public function set active(to:Boolean):void {
			this._audio.active = to;
			this._text.active = to;
			this._video.active = to;
			this._graphic.active = to;
		}
		
		/**
		 * The left-to-right panning of the sound, ranging from -1 (full pan left) to 1 (full pan right).
		 */
		public function get soundPan():Number {
			return (this._soundTransform.pan);
		}
		public function set soundPan(to:Number):void {
			if (to > 1) to = 1;
			else if (to < -1) to = -1;
			this._soundTransform.pan = to;
			this._video.soundTransform = this._soundTransform;
			this._audio.soundTransform = this._soundTransform;
			this._graphic.soundTransform = this._soundTransform;
		}
		
		/**
		 * A value, from 0 (none) to 1 (all), specifying how much of the left input is played in the left speaker.
		 */
		public function get soundLeftToLeft():Number {
			return (this._soundTransform.leftToLeft);
		}
		public function set soundLeftToLeft(to:Number):void {
			if (to > 1) to = 1;
			else if (to < 0) to = 0;
			this._soundTransform.leftToLeft = to;
			this._video.soundTransform = this._soundTransform;
			this._audio.soundTransform = this._soundTransform;
			this._graphic.soundTransform = this._soundTransform;
		}
		
		/**
		 * A value, from 0 (none) to 1 (all), specifying how much of the left input is played in the right speaker.
		 */
		public function get soundLeftToRight():Number {
			return (this._soundTransform.leftToRight);
		}
		public function set soundLeftToRight(to:Number):void {
			if (to > 1) to = 1;
			else if (to < 0) to = 0;
			this._soundTransform.leftToRight = to;
			this._video.soundTransform = this._soundTransform;
			this._audio.soundTransform = this._soundTransform;
			this._graphic.soundTransform = this._soundTransform;
		}
		
		/**
		 * A value, from 0 (none) to 1 (all), specifying how much of the right input is played in the left speaker.
		 */
		public function get soundRightToLeft():Number {
			return (this._soundTransform.rightToLeft);
		}
		public function set soundRightToLeft(to:Number):void {
			if (to > 1) to = 1;
			else if (to < 0) to = 0;
			this._soundTransform.rightToLeft = to;
			this._video.soundTransform = this._soundTransform;
			this._audio.soundTransform = this._soundTransform;
			this._graphic.soundTransform = this._soundTransform;
		}
		
		/**
		 * A value, from 0 (none) to 1 (all), specifying how much of the right input is played in the right speaker.
		 */
		public function get soundRightToRight():Number {
			return (this._soundTransform.rightToRight);
		}
		public function set soundRightToRight(to:Number):void {
			if (to > 1) to = 1;
			else if (to < 0) to = 0;
			this._soundTransform.rightToRight = to;
			this._video.soundTransform = this._soundTransform;
			this._audio.soundTransform = this._soundTransform;
			this._graphic.soundTransform = this._soundTransform;
		}
		
		/**
		 * Should bitmaps and videos be smoothed on resize? (default = false)
		 */
		public function get smoothing():Boolean {
			return (this._smoothing);
		}
		public function set smoothing(to:Boolean):void {
			this._smoothing = to;
			this._video.smoothing = to;
			this._graphic.smoothing = to;
			this._audio.smoothing = to;
			this._anim.smoothing = to;
		}
		
		/**
		 * The subtitle text format.
		 */
		public function get subtitleTextFormat():TextFormat {
			return (this._video.subtitleTextFormat);
		}
		public function set subtitleTextFormat(to:TextFormat):void {
			this._video.subtitleTextFormat = to;
			this._audio.subtitleTextFormat = to;
		}
		
		/**
		 * Use embed fonts in subtitle text?
		 */
		public function get subtitleEmbed():Boolean {
			return (this._video.subtitleEmbed);
		}
		public function set subtitleEmbed(to:Boolean):void {
			this._video.subtitleEmbed = to;
			this._audio.subtitleEmbed = to;
		}
		
		/**
		 * Is subtitle text visible?
		 */
		public function get subtitleVisible():Boolean {
			return (this._video.subtitleVisible);
		}
		public function set subtitleVisible(to:Boolean):void {
			this._video.subtitleVisible = this._audio.subtitleVisible = to;
		}
		
		/**
		 * Buffer size (in % of loaded file) required to start playing media (from 2% to 99%). (default = 10%)
		 */
		public function get bufferSize():uint {
			return (this._video.bufferSize);
		}
		public function set bufferSize(to:uint):void {
			if (to >= 100) to = 99; // to avoid bugs
			else if (to < 2) to = 2;
			this._video.bufferSize = to;
			this._audio.bufferSize = to;
		}
		
		/**
		 * The text font.
		 */
		public function get textFont():String {
			return (this._text.font);
		}
		public function set textFont(to:String):void {
			this._text.font = to;
		}
		
		/**
		 * Is text bold?
		 */
		public function get textBold():Boolean {
			return (this._text.bold);
		}
		public function set textBold(to:Boolean):void {
			this._text.bold = to;
		}
		
		/**
		 * Is text italic?
		 */
		public function get textItalic():Boolean {
			return (this._text.italic);
		}
		public function set textItalic(to:Boolean):void {
			this._text.italic = to;
		}
		
		/**
		 * The text alignment.
		 */
		public function get textAlign():String {
			return (this._text.align);
		}
		public function set textAlign(to:String):void {
			this._text.align = to;
		}
		
		/**
		 * The text color.
		 */
		public function get textColor():uint {
			return (this._text.color);
		}
		public function set textColor(to:uint):void {
			this._text.color = to;
		}
		
		/**
		 * The text font size.
		 */
		public function get textSize():uint {
			return (this._text.size);
		}
		public function set textSize(to:uint):void {
			this._text.size = to;
		}
		
		/**
		 * The standard text line leading.
		 */
		public function get leading():Object {
			return (this._text.leading);
		}
		public function set leading(to:Object):void {
			this._text.leading = to;
		}
		
		/**
		 * The standard text letter spacing.
		 */
		public function get letterSpacing():Object {
			return (this._text.letterSpacing);
		}
		public function set letterSpacing(to:Object):void {
			this._text.letterSpacing = to;
		}
		
		/**
		 * Maximum number of chars to show on text.
		 */
		public function get maxchars():uint {
			return (this._text.maxchars);
		}
		public function set maxchars(to:uint):void {
			this._text.maxchars = to;
		}
		
		/**
		 * Try to use an alternative font or text if the desired embed one is not available?
		 */
		public function get textAlternativeFont():Boolean {
			return (this._text.alternativeFont);
		}
		public function set textAlternativeFont(to:Boolean):void {
			this._text.alternativeFont = to;
		}
		
		/**
		 * Use embed fonts on text? This value may be be constantly changed by the system due to configurations.
		 */
		public function get textEmbed():Boolean {
			return (this._text.embed);
		}
		public function set textEmbed(to:Boolean):void {
			this._text.embed = to;
		}
		
		/**
		 * Switch to device fonts while loading a HTML text? (default = true)
		 */
		public function get deviceOnHtml():Boolean {
			return (this._text.deviceOnHtml);
		}
		public function set deviceOnHtml(to:Boolean):void {
			this._text.deviceOnHtml = to;
		}
		
		/**
		 * Switch to embed fonts while loading a plain text? (default = true)
		 */
		public function get embedOnText():Boolean {
			return (this._text.embedOnText);
		}
		public function set embedOnText(to:Boolean):void {
			this._text.embedOnText = to;
		}
		
		/**
		 * Is the text selectable?
		 */
		public function get textSelectable():Boolean {
			return(this._text.selectable);
		}
		public function set textSelectable(to:Boolean):void {
			this._text.selectable = to;
		}
		
		/**
		 * Vertical position of text.
		 */
		public function get textScrollV():int {
			return(this._text.scrollV);
		}
		public function set textScrollV(to:int):void {
			if (to <= this._text.maxScrollV) this._text.scrollV = to;
		}
		
		/**
		 * Horizontal position of text.
		 */
		public function get textScrollH():int {
			return(this._text.scrollH);
		}
		public function set textScrollH(to:int):void {
			if (to <= this._text.maxScrollH) this._text.scrollH = to;
		}
		
		/**
		 * Text display mode: paragraph or artistic. Chenging to artistic mode on device text will not be effective.
		 */
		public function get textMode():String {
			return (this._text.mode);
		}
		public function set textMode(to:String):void {
			this._text.mode = to;
		}
		
		/**
		 * Loop playback media (video and audio)?
		 */
		public function get loop():Boolean {
			return (this._video.loop);
		}
		public function set loop(to:Boolean):void {
			this._video.loop = to;
			this._audio.loop = to;
		}
		
		/**
		 * The update interval for media playback. (default is optimized for speed)
		 * @see	art.ciclope.util.MediaDefinitions
		 */
		public function get playbackInterval():uint {
			return (this._video.playbackInterval);
		}
		public function set playbackInterval(to:uint):void {
			this._video.playbackInterval = to;
			this._audio.playbackInterval = to;
		}
		
		/**
		 * The animation update frequency in miliseconds.
		 */
		public function get animationUpdate():uint {
			return (this._anim.update);
		}
		public function set animationUpdate(to:uint):void {
			this._anim.update = to;
		}
		
		/**
		 * Reposition animation images every time they are redrawn? Useful if you manipulate the images outside this class - leave false otherwise.
		 */
		public function get animationReplaceOnRedraw():Boolean {
			return (this._anim.replaceOnRedraw);
		}
		public function set animationReplaceOnRedraw(to:Boolean):void {
			this._anim.replaceOnRedraw = to;
		}
		
		// PRIVATE METHODS
		
		/**
		 * Place animation sprite.
		 */
		private function placeAnimation():void {
			// place animation
			switch (this._animPlace) {
				case Placing.TOPLEFT:
					this._anim.x = 0;
					this._anim.y = 0;
					break;
				case Placing.TOPCENTER:
					this._anim.x = this._bg.width / 2;
					this._anim.y = 0;
					break;
				case Placing.TOPRIGHT:
					this._anim.x = this._bg.width;
					this._anim.y = 0;
					break;
				case Placing.MIDDLELEFT:
					this._anim.x = 0;
					this._anim.y = this._bg.height / 2;
					break;
				case Placing.CENTER:
					this._anim.x = this._bg.width / 2;
					this._anim.y = this._bg.height / 2;
					break;
				case Placing.MIDDLERIGHT:
					this._anim.x = this._bg.width;
					this._anim.y = this._bg.height / 2;
					break;
				case Placing.BOTTOMLEFT:
					this._anim.x = 0;
					this._anim.y = this._bg.height;
					break;
				case Placing.BOTTOMCENTER:
					this._anim.x = this._bg.width / 2;
					this._anim.y = this._bg.height;
					break;
				case Placing.BOTTOMRIGHT:
					this._anim.x = this._bg.width;
					this._anim.y = this._bg.height;
					break;
			}
		}
		
		/**
		 * Picture load HTTP_STATUS event.
		 */
		private function httpStatusHandlerPicture(evt:Loading):void { 
			this.dispatchEvent(new Loading(evt.type, evt.target, evt.fileName, evt.fileType)); 
		}
		/**
		 * Picture load INIT event.
		 */
		private function initHandlerPicture(evt:Loading):void {
			// sets the file as current
			this._currentfile = this._filename;
			this._graphic.visible = true;
			this._video.visible = false;
			this._video.stop();
			this._audio.visible = false;
			this._audio.stop();
			this._text.visible = false;
			this._anim.visible = false;
			this._originalWidth = this._graphic.originalWidth;
			this._originalHeight = this._graphic.originalHeight;
			this._graphic.width = this._setWidth;
			this._graphic.height = this._setHeight;
			this._loadedType = LoadedFile.typeOf(this._filename);
			
			this._reference = this._graphic;
			while (this.numChildren > 0) this.removeChildAt(0);
			this.addChild(this._bg);
			this.addChild(this._reference);
			
			
			if ((!this._mute) && (this._loadedType == LoadedFile.TYPE_FLASH)) this._graphic.volume = this._soundVolume;
			// warn listeners
			this.dispatchEvent(new Loading(Loading.FINISHED, evt.fileContent, evt.fileName, evt.fileType));
		}
		/**
		 * Picture load IO_ERROR event.
		 */
		private function ioErrorHandlerPicture(evt:Loading):void { this.dispatchEvent(new Loading(Loading.ERROR_IO, evt.fileContent, evt.fileName, evt.fileType)); }
		/**
		 * Picture load PROGRESS event.
		 */
		private function progressHandlerPicture(evt:Loading):void { this.dispatchEvent(new Loading(Loading.PROGRESS, evt.fileContent, evt.fileName, evt.fileType)); }
		/**
		 * Picture load UNLOAD event.
		 */
		private function unLoadHandlerPicture(evt:Loading):void { this.dispatchEvent(new Loading(Loading.UNLOAD, evt.fileContent, evt.fileName, evt.fileType)); }
		
		/**
		 * Media OPEN event.
		 */
		private function openHandlerMedia(evt:Event):void {
			this.dispatchEvent(new Loading(Loading.START, this._reference, this._filename, LoadedFile.typeOf(this._filename)));
		}	
		/**
		 * Media COMPLETE event = media can start play.
		 */
		private function completeHandlerMedia(evt:Event):void {
			this._currentfile = this._filename;
			this._graphic.visible = false;
			this._graphic.volume = 0;
			this._video.visible = false;
			this._video.stop();
			this._audio.visible = false;
			this._audio.stop();
			this._text.visible = false;
			this._anim.visible = false;
			this._loadedType = LoadedFile.typeOf(this._filename);
			if (this._loadedType == LoadedFile.TYPE_VIDEO) {
				this._video.visible = true;
				this._video.width = this._setWidth;
				this._video.height = this._setHeight;
				this._originalWidth = this._video.originalWidth;
				this._originalHeight = this._video.originalHeight;
				if (!this._mute) this._video.volume = this._soundVolume;
				this._reference = this._video;
			} else {
				this._audio.visible = true;
				this._audio.width = this._setWidth;
				this._audio.height = this._setHeight;
				this._originalWidth = this._audio.originalWidth;
				this._originalHeight = this._audio.originalHeight;
				if (!this._mute) this._audio.volume = this._soundVolume;
				this._reference = this._audio;
			}
			
			while (this.numChildren > 0) this.removeChildAt(0);
			this.addChild(this._bg);
			this.addChild(this._reference);
			
			// warn listeners (FINISHED for media files means enough download to start playing).
			this.dispatchEvent(new Loading(Loading.FINISHED, this._reference, this._currentfile, this._loadedType));
		}
		/**
		 * Media CLOSE event.
		 */
		private function closeHandlerMedia(evt:Event):void {
			this.dispatchEvent(new Loading(Loading.UNLOAD, this._reference, this._currentfile, this._loadedType));
		}
		/**
		 * Media load IO_ERROR event.
		 */
		private function ioErrorHandlerMedia(evt:IOErrorEvent):void {
			this.dispatchEvent(new Loading(Loading.ERROR_IO, this._reference, this._filename, LoadedFile.typeOf(this._filename)));
		}
		/**
		 * Media load SECURITY ERROR event.
		 */
		private function securityErrorHandlerMedia(evt:SecurityErrorEvent):void {
			this.dispatchEvent(new Loading(Loading.ERROR_SECURITY, this._reference, this._filename, LoadedFile.typeOf(this._filename)));
		}
		/**
		 * Media load PROGRESS event.
		 */
		private function progressHandlerMedia(evt:ProgressEvent):void {
			this.dispatchEvent(new Loading(Loading.PROGRESS, this._reference, this._currentfile, this._loadedType, evt.bytesLoaded, evt.bytesTotal));
		}
		/**
		 * Media load STREAM COMPLETE event (all data downloaded).
		 */
		private function streamCompleteHandlerMedia(evt:Loading):void {
			this.dispatchEvent(new Loading(Loading.STREAM_COMPLETE, this._reference, this._currentfile, this.loadedType, evt.bytesLoaded, evt.bytesTotal));
		}
		/**
		 * Media playback PLAY event.
		 */
		private function playHandlerMedia(evt:Playing):void {
			this.dispatchEvent(new Playing(Playing.MEDIA_PLAY, this._reference, this._currentfile, this._loadedType, evt.currentTime, evt.totalTime));
		}
		/**
		 * Media playback PAUSE event.
		 */
		private function pauseHandlerMedia(evt:Playing):void {
			this.dispatchEvent(new Playing(Playing.MEDIA_PAUSE, this._reference, this._currentfile, this._loadedType, evt.currentTime, evt.totalTime));
		}
		/**
		 * Media playback STOP event.
		 */
		private function stopHandlerMedia(evt:Playing):void {
			this.dispatchEvent(new Playing(Playing.MEDIA_STOP, this._reference, this._currentfile, this._loadedType, evt.currentTime, evt.totalTime));
		}
		/**
		 * Media playback SEEK event.
		 */
		private function seekHandlerMedia(evt:Playing):void {
			this.dispatchEvent(new Playing(Playing.MEDIA_SEEK, this._reference, this._currentfile, this._loadedType, evt.currentTime, evt.totalTime));
		}
		/**
		 * Media playback PROGRESS event.
		 */
		private function mediaProgressHandlerMedia(evt:Playing):void {
			this.dispatchEvent(new Playing(Playing.MEDIA_PROGRESS, this._reference, this._currentfile, this._loadedType, evt.currentTime, evt.totalTime));
		}
		/**
		 * Media playback END event.
		 */
		private function endHandlerMedia(evt:Playing):void {
			// should loop?
			if (this.loop) {
				// warn listeners about loop
				this.dispatchEvent(new Playing(Playing.MEDIA_LOOP, this._reference, this._currentfile, this._loadedType, evt.currentTime, evt.totalTime));
			} else {
				// warn listeners about media end
				this.dispatchEvent(new Playing(Playing.MEDIA_END, this._reference, this._currentfile, this._loadedType, evt.currentTime, evt.totalTime));
			}
		}
		/**
		 * Media playback CUE POINT event.
		 */
		private function cueHandlerMedia(evt:Playing):void { 
			this.dispatchEvent(new Playing(Playing.MEDIA_CUE, this._reference, this._currentfile, this._loadedType, evt.currentTime, evt.totalTime, evt.cueData));
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
		 * Text load COMPLETE event.
		 */
		private function completeHandlerText(evt:Event):void { 
			this._currentfile = this._filename;
			this._graphic.visible = false;
			this._graphic.volume = 0;
			this._video.visible = false;
			this._video.stop();
			this._audio.visible = false;
			this._audio.stop();
			this._anim.visible = false;
			this._text.visible = true;
			this._text.width = this._setWidth;
			this._text.height = this._setHeight;
			this._loadedType = LoadedFile.TYPE_TEXT;
			this._originalWidth = this._text.originalWidth;
			this._originalHeight = this._text.originalHeight;
			
			this._reference = this._text;
			while (this.numChildren > 0) this.removeChildAt(0);
			this.addChild(this._bg);
			this.addChild(this._reference);
			this.dispatchEvent(new Loading(Loading.FINISHED, this._text, this._currentfile, this._loadedType));
		}
		/**
		 * Text load IO_ERROR event.
		 */
		private function ioErrorHandlerText(evt:IOErrorEvent):void { this.dispatchEvent(new Loading(Loading.ERROR_IO, this._text, this._filename, LoadedFile.typeOf(this._filename))); }
		/**
		 * Text load SECURITY_ERROR event.
		 */
		private function securityErrorHandlerText(evt:SecurityErrorEvent):void { this.dispatchEvent(new Loading(Loading.ERROR_SECURITY, this._text, this._filename, LoadedFile.typeOf(this._filename))); }
		/**
		 * Text load HTTP STATUS event.
		 */
		private function httpStatusHandlerText(evt:Event):void { this.dispatchEvent(new Loading(Loading.HTTP_STATUS, this._text, this._filename, LoadedFile.typeOf(this._filename))); }
		/**
		 * Text load OPEN event.
		 */
		private function openHandlerText(evt:Event):void { this.dispatchEvent(new Loading(Loading.START, this._text, this._filename, LoadedFile.typeOf(this._filename))); }
		/**
		 * Text load PROGRESS event.
		 */
		private function progressHandlerText(evt:ProgressEvent):void { this.dispatchEvent(new Loading(Loading.PROGRESS, this._text, this._filename, LoadedFile.typeOf(this._filename), evt.bytesLoaded, evt.bytesTotal)); }
		
	}

}
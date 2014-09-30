package art.ciclope.display {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.Camera;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.filters.DropShadowFilter;
	import flash.text.Font;
	
	// CICLOPE CLASSES
	import art.ciclope.event.Loading;
	import art.ciclope.event.Playing;
	import art.ciclope.util.LoadedFile;
	import art.ciclope.util.MediaDefinitions;
	import art.ciclope.handle.SubtitleManager;
	
	// EVENTS
	
	/**
     * Video download enough to start playing.
     */
    [Event( name = "COMPLETE", type = "flash.events.Event" )]
	/**
     * Video closed.
     */
    [Event( name = "CLOSE", type = "flash.events.Event" )]
	/**
     * Video file open.
     */
    [Event( name = "OPEN", type = "flash.events.Event" )]
	/**
     * Video file download progress.
     */
    [Event( name = "PROGRESS", type = "flash.events.ProgressEvent" )]
	/**
     * IO Error while loading video.
     */
    [Event( name = "IO_ERROR", type = "flash.events.IOErrorEvent" )]
	/**
     * Security error while loading video.
     */
    [Event( name = "SECURITY_ERROR", type = "flash.events.SecurityErrorEvent" )]
	/**
     * Video starts playing.
     */
    [Event( name = "MEDIA_PLAY", type = "art.ciclope.event.Playing" )]
	/**
     * Video stops playing.
     */
    [Event( name = "MEDIA_STOP", type = "art.ciclope.event.Playing" )]
	/**
     * Video playback pause.
     */
    [Event( name = "MEDIA_PAUSE", type = "art.ciclope.event.Playing" )]
	/**
     * Video playback seek.
     */
    [Event( name = "MEDIA_SEEK", type = "art.ciclope.event.Playing" )]
	/**
     * Video playback loop.
     */
    [Event( name = "MEDIA_LOOP", type = "art.ciclope.event.Playing" )]
	/**
     * Video playback reached end of file.
     */
    [Event( name = "MEDIA_END", type = "art.ciclope.event.Playing" )]
	/**
     * Video cuepoint.
     */
    [Event( name = "MEDIA_CUE", type = "art.ciclope.event.Playing" )]
	/**
     * Video playback progress.
     */
    [Event( name = "MEDIA_PROGRESS", type = "art.ciclope.event.Playing" )]
	/**
     * Media strem download complete.
     */
    [Event( name = "STREAM_COMPLETE", type = "art.ciclope.event.Loading" )]
	
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * VideoSprite creates a simple video player with basic controls for loading and playing media.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class VideoSprite extends Sprite {
		
		// VARIABLES
		
		/**
		 * The video itself.
		 */
		protected var _video:Video;
		/**
		 * Connection data.
		 */
		private var _connection:NetConnection;
		protected var _stream:NetStream;
		/**
		 * The file url.
		 */
		private var _url:String;
		/**
		 * Does sound object have loaded data?
		 */
		private var _loadedData:Boolean;
		/**
		 * Is the stream downloading?
		 */
		private var _loading:Boolean;
		/**
		 * Current playback time.
		 */
		private var _currentTime:Number;
		/**
		 * Total playback time.
		 */
		private var _totalTime:Number;
		/**
		 * Curren playback update interval.
		 */
		private var _updateInterval:uint;
		/**
		 * The timer for managing playback.
		 */
		private var _timer:Timer;
		/**
		 * The media playback state.
		 */
		private var _state:String;
		/**
		 * The amount of data to be loaded after start playing in %. (default = 10)
		 */
		private var _bufferStart:uint;
		/**
		 * The amount of the file that is already loaded.
		 */
		private var _amountLoaded:uint;
		/**
		 * The audio's sound transform object.
		 */
		private var _soundTransform:SoundTransform;
		/**
		 * Time to seek just after play start.
		 */
		private var _seekHold:int;
		/**
		 * A subtitle manager.
		 */
		private var _subtitles:SubtitleManager;
		/**
		 * The subtitle text to show.
		 */
		private var _showsub:TextField;
		/**
		 * A forced subtitle text.
		 */
		private var _subtitleSet:String;
		
		// PUBLIC VARIABLES
		
		/**
		 * Start playing right after enough amount of the file is loaded? (default = true)
		 */
		public var playOnLoad:Boolean;
		/**
		 * Loop media playback?
		 */
		public var loop:Boolean = false;
		
		public var active:Boolean = true;
		
		/**
		 * VideoSprite constructor.
		 * @param	width	Video width.
		 * @param	height	Video height.
		 * @param	file	The file url to load (leave default to create an empty GraphicSprite).
		 */
		public function VideoSprite(width:Number = 160, height:Number = 90, file:String = "") {
			// create video
			this._video = new Video(width, height);
			this.addChild(this._video);
			// prepare connection
			this._loadedData = false;
			this._connection = new NetConnection();
			this._connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			this._connection.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			this._connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			this._connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			this._connection.connect(null);
			// prepare stream
			this._stream = new NetStream(this._connection);
			this._stream.checkPolicyFile = true;
			this._stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			this._stream.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			this._stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			var clientObj:Object = new Object();
			clientObj.onMetaData = this.metadataEvent;
			clientObj.onImageData = this.imagedataEvent;
			clientObj.onPlayStatus = this.playstatusEvent;
			clientObj.onCuePoint = this.cuepointEvent;
			this._stream.client = clientObj;
			this._video.attachNetStream(this._stream);
			// creating subtitle text
			this._showsub = new TextField();
			this.addChild(this._showsub);
			this._showsub.mouseEnabled = false;
			this._showsub.text = "";
			this._showsub.wordWrap = true;
			this._showsub.multiline = true;
			this._showsub.selectable = false;
			this._subtitleSet = null;
			// formatting text. embed font available?
			var fonts:Array = Font.enumerateFonts();
			var format:TextFormat = new TextFormat();
			format.font = "_sans";
			this._showsub.embedFonts = false;
			format.size = 14;
			format.color = 0xFFFF00;
			format.bold = true;
			format.align = "center";
			format.leading = 0;
			this._showsub.defaultTextFormat = format;
			this._showsub.filters = [new DropShadowFilter(1, 45, 0, 1, 2, 2)];
			this._showsub.antiAliasType = "advanced";
			this._showsub.x = 5;
			this._showsub.width = width - 10;
			// initializing
			this._url = "";
			this._loading = false;
			this._loadedData = false;
			this.playbackInterval = MediaDefinitions.PLAYBACKUPDATE_SPEED;
			this._state = MediaDefinitions.PLAYBACKSTATE_UNLOAD;
			this._currentTime = 0;
			this._totalTime = 0;
			this._bufferStart = 1;
			this.playOnLoad = true;
			this._amountLoaded = 0;
			this._soundTransform = new SoundTransform();
			this._stream.soundTransform = this._soundTransform;
			this._seekHold = -1;
			this._subtitles = new SubtitleManager();
			// load file?
			if (file != "") this.load(file);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Load a video file.
		 * @param	url	Path to the video file.
		 */
		public function load(url:String):void {
			this._currentTime = 0;
			this._totalTime = 0;
			this._stream.play(url);
			this._stream.pause();
			this._url = url;
			this._amountLoaded = 0;
			this._loadedData = false;
			this._loading = true;
			this._showsub.text = "";
			if (this._subtitleSet != null) this._showsub.text = this._subtitleSet;
			this._state = MediaDefinitions.PLAYBACKSTATE_UNLOAD;
		}
		
		/**
		 * Close data stream.
		 */
		public function close():void {
			this._currentTime = 0;
			this._totalTime = 0;
			this._stream.close();
			this._url = "";
			this._amountLoaded = 0;
			this._state = MediaDefinitions.PLAYBACKSTATE_UNLOAD;
			this._loadedData = false;
			this._loading = false;
			this._showsub.text = "";
			if (this._subtitleSet != null) this._showsub.text = this._subtitleSet;
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
		/**
		 * Play the loaded video media.
		 * @param	time	The start time of playback (default = current time).
		 * @return	True if a media is loaded and ready to play, false otherwise.
		 */
		public function play(time:int = -1):Boolean {
			if (this._loadedData) {
				this._seekHold = time;
				this._stream.resume();
				this._state = MediaDefinitions.PLAYBACKSTATE_PLAY;
				this.dispatchEvent(new Playing(Playing.MEDIA_PLAY, this._stream, this._url, LoadedFile.TYPE_VIDEO, this._currentTime, this._totalTime));
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Stop playing the video and rewinds it to the beginning of the file.
		 * @return	True if a video is playing or paused and can be stopped, false otherwise.
		 */
		public function stop():Boolean {
			if ((this._state == MediaDefinitions.PLAYBACKSTATE_PLAY) || (this._state == MediaDefinitions.PLAYBACKSTATE_PAUSE)) {
				//this._stream.seek(0);
				this._stream.pause();
				//this._currentTime = 0;
				this._state = MediaDefinitions.PLAYBACKSTATE_STOP;
				this.dispatchEvent(new Playing(Playing.MEDIA_STOP, this._stream, this._url, LoadedFile.TYPE_VIDEO, this._currentTime, this._totalTime));
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Pause the video playback.
		 * @return	True if an audio is playing and can be paused, false otherwise.
		 */
		public function pause():Boolean {
			if (this._state == MediaDefinitions.PLAYBACKSTATE_PLAY) {
				this._stream.pause();
				this._state = MediaDefinitions.PLAYBACKSTATE_PAUSE;
				this.dispatchEvent(new Playing(Playing.MEDIA_PAUSE, this._stream, this._url, LoadedFile.TYPE_VIDEO, this._currentTime, this._totalTime));
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Seek to a position in media file. If the stream is playing, it'll jump to desired position.
		 * @param	to	The desired time, in seconds.
		 * @return	True if the seek can be executed (enough of file loaded), false otherwise.
		 */
		public function seek(to:uint):Boolean {
			if (this._loadedData) {
				// is the desired time already loaded? (best possible guess)
				if (((to * 100) / (this._totalTime)) < this._amountLoaded) {
					this._currentTime = to;
					this._stream.seek(to);
					this._subtitles.restart();
					if (this._state == MediaDefinitions.PLAYBACKSTATE_PLAY) this.play();
					this.dispatchEvent(new Playing(Playing.MEDIA_SEEK, this._stream, this._url, LoadedFile.TYPE_VIDEO, this._currentTime, this._totalTime));
					return (true);
				} else {
					// the desired time was not loaded yet
					return (false);
				}
			} else {
				// no loaded file to seek
				return (false);
			}
		}
		
		/**
		 * Show a webcam input on video.
		 */
		public function showWebcam():void {
			var cam:Camera = Camera.getCamera();
			this._video.attachCamera(cam);
		}
		
		/**
		 * Set the subtitle to a defined text. Leave null to use standard file subtitles, if any.
		 * @param	to	the subtitle text to force or null to keep using standard file subtitles
		 */
		public function setSubtitle(to:String):void {
			this._subtitleSet = to;
			if (to != null) {
				this._showsub.text = to;
				this._showsub.y = this.height - this._showsub.textHeight - 15;
			}
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			// removing events
			try {
				this._timer.removeEventListener(TimerEvent.TIMER, updatePlayback);
				this._connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				this._connection.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				this._connection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				this._connection.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				this._stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				this._stream.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				this._stream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			} catch (e:Error) { }
			// unload any video
			this.close();
			// remove graphics
			this.removeChild(this._video);
			this._video = null;
			// timer
			if (this._timer.running) this._timer.stop();
			this._timer = null;
			// remove all other variables
			this._connection = null;
			this._stream = null;
			this._url = null;
			this._state = null;
			this._soundTransform = null;
			this._subtitleSet = null;
		}
		
		// READ-ONLY VALUES
		
		/**
		 * The media playback state.
		 * @see	art.ciclope.util.MediaDefinitions
		 */
		public function get mediaState():String {
			return (this._state);
		}
		
		/**
		 * The amount of the file already loaded (in %).
		 */
		public function get amountLoaded():uint {
			return (this._amountLoaded);
		}
		
		/**
		 * Original media width.
		 */
		public function get originalWidth():Number {
			return (this._video.videoWidth);
		}
		
		/**
		 * Original media height.
		 */
		public function get originalHeight():Number {
			return (this._video.videoHeight);
		}
		
		/**
		 * Current playback time (seconds).
		 */
		public function get currentTime():Number {
			return (this._currentTime);
		}
		
		/**
		 * Total playback time (seconds).
		 */
		public function get totalTime():Number {
			return (this._totalTime);
		}
		
		/**
		 * The loaded file URL.
		 */
		public function get currentFile():String {
			return (this._url);
		}
		
		// PROPERTIES
		
		/**
		 * The sprite width.
		 */
		override public function get width():Number {
			return (this._video.width);
		}
		override public function set width(to:Number):void {
			this._video.width = to;
			this._showsub.x = 5;
			this._showsub.width = to - 10;
		}
		
		/**
		 * The sprite height.
		 */
		override public function get height():Number {
			return (this._video.height);
		}
		override public function set height(to:Number):void {
			this._video.height = to;
		}
		
		/**
		 * Set the update interval for media playback. (default is optimized for speed)
		 * @see	art.ciclope.util.MediaDefinitions
		 */
		public function get playbackInterval():uint {
			return (this._updateInterval);
		}
		public function set playbackInterval(to:uint):void {
			if ((to != MediaDefinitions.PLAYBACKUPDATE_CONTROL) && (to != MediaDefinitions.PLAYBACKUPDATE_STANDARD) && (to != MediaDefinitions.PLAYBACKUPDATE_ABOVE) && (to != MediaDefinitions.PLAYBACKUPDATE_SPEED)) to = MediaDefinitions.PLAYBACKUPDATE_SPEED;
			this._updateInterval = to;
			if (this._timer != null) this._timer.removeEventListener(TimerEvent.TIMER, updatePlayback);
			this._timer = new Timer(this._updateInterval);
			this._timer.addEventListener(TimerEvent.TIMER, updatePlayback);
			this._timer.start();
		}
		
		/**
		 * Buffer size (in % of loaded file) required to start playing (from 2% to 99%). (default = 10%)
		 */
		public function get bufferSize():uint {
			return (this._bufferStart);
		}
		public function set bufferSize(to:uint):void {
			if (to >= 100) to = 99; // to avoid bugs
			else if (to < 2) to = 2;
			this._bufferStart = to;
		}
		
		/**
		 * Audio volume. (default = 1, maximum)
		 */
		public function get volume():Number {
			return (this._soundTransform.volume);
		}
		public function set volume(to:Number):void {
			// adjusting value
			if (to < 0) to = 0;
			else if (to > 1) to = 1;
			// apply volume to sound transform
			this._soundTransform.volume = to;
			if (this._stream != null) this._stream.soundTransform = this._soundTransform;
		}
		
		/**
		 * Set the audio sound transform object. Notice that the current volume overrides the volume value of the new sound transform. The get value is just a copy, not this object's soundtransform itself.
		 */
		override public function get soundTransform():SoundTransform {
			var ret:SoundTransform = new SoundTransform();
			ret.leftToLeft = this._soundTransform.leftToLeft;
			ret.leftToRight = this._soundTransform.leftToRight;
			ret.pan = this._soundTransform.pan;
			ret.rightToLeft = this._soundTransform.rightToLeft;
			ret.rightToRight = this._soundTransform.rightToRight;
			ret.volume = this._soundTransform.volume;
			return (ret);
		}
		override public function set soundTransform(to:SoundTransform):void {
			// apply all soundtransformproperties except volume
			this._soundTransform.leftToLeft = to.leftToLeft;
			this._soundTransform.leftToRight = to.leftToRight;
			this._soundTransform.pan = to.pan;
			this._soundTransform.rightToLeft = to.rightToLeft;
			this._soundTransform.rightToRight = to.rightToRight;
			// apply new sound transform
			if (this._stream != null) this._stream.soundTransform = this._soundTransform;
		}
		
		/**
		 * Should the video be smoothed (interpolated) on resize? (default = false)
		 */
		public function get smoothing():Boolean {
			return (this._video.smoothing);
		}
		public function set smoothing(to:Boolean):void {
			this._video.smoothing = to;
		}
		
		/**
		 * The subtitle text format.
		 */
		public function get subtitleTextFormat():TextFormat {
			return (this._showsub.defaultTextFormat);
		}
		public function set subtitleTextFormat(to:TextFormat):void {
			this._showsub.setTextFormat(to);
			this._showsub.defaultTextFormat = to;
		}
		
		/**
		 * Use embed fonts in subtitle text?
		 */
		public function get subtitleEmbed():Boolean {
			return (this._showsub.embedFonts);
		}
		public function set subtitleEmbed(to:Boolean):void {
			this._showsub.embedFonts = to;
		}
		
		/**
		 * Is subtitle text visible?
		 */
		public function get subtitleVisible():Boolean {
			return (this._showsub.visible);
		}
		public function set subtitleVisible(to:Boolean):void {
			this._showsub.visible = to;
		}
		
		// PRIVATE METHODS
		
		/**
		 * IO error event.
		 */
		private function ioErrorHandler(evt:IOErrorEvent):void { this.dispatchEvent(evt); }
		/**
		 * Security error event.
		 */
		private function securityErrorHandler(evt:SecurityErrorEvent):void { this.dispatchEvent(evt); }
		/**
		 * Async error event.
		 */
		private function asyncErrorHandler(evt:AsyncErrorEvent):void { /*this.dispatchEvent(evt);*/ }
		/**
		 * Net status event.
		 * @param	evt Event.
		 */
		private function netStatusHandler(event:NetStatusEvent):void {
			switch (event.info.code) {
				case "NetStream.Play.StreamNotFound":
					this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
					break;
				case "NetStream.Play.Start":
					this.dispatchEvent(new Event(Event.OPEN));
					break;
				case "NetStream.Play.Failed":
					this.dispatchEvent(new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR));
					break;
			}
		}
		/**
		 * Playback update.
		 */
		private function updatePlayback(evt:TimerEvent):void {
			// update download status
			if (this._loading) {
				// check amount loaded
				this._amountLoaded = Math.round((this._stream.bytesLoaded * 100) / this._stream.bytesTotal);
				// all file downloaded?
				if (this._amountLoaded >= 100) {
					this.dispatchEvent(new Loading(Loading.STREAM_COMPLETE, this._stream, this._url, LoadedFile.TYPE_VIDEO, this._stream.bytesLoaded, this._stream.bytesTotal));
					this._loading = false;
					this._showsub.text = "";
					if (this._subtitleSet != null) this._showsub.text = this._subtitleSet;
				}
				// check for play status
				if (!this._loadedData) {
					var tocheck:Number = 1024000;
					if ((this._bufferStart * this._stream.bytesTotal / 100) < tocheck) tocheck = this._bufferStart * this._stream.bytesTotal / 100;
					if (this._stream.bytesLoaded >= tocheck) {
						this.dispatchEvent(new Event(Event.COMPLETE));
						this._loadedData = true;
						if (this.playOnLoad) {
							this.play();
						} else {
							this._state = MediaDefinitions.PLAYBACKSTATE_STOP;
							this.dispatchEvent(new Playing(Playing.MEDIA_STOP, this._stream, this._url, LoadedFile.TYPE_VIDEO, this._currentTime, this._totalTime));
						}
						// check for subtitles
						this._subtitles.checkSrt(this._url);
					}
				}
				// dispatch loading event
				this.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, this._stream.bytesLoaded, this._stream.bytesTotal));
			}
			// update play status
			if (this._state == MediaDefinitions.PLAYBACKSTATE_PLAY) {
				if (this._seekHold >= 0) {
					this._stream.seek(this._seekHold);
					this._seekHold = -1;
				}
				this._currentTime = this._stream.time;
				this.dispatchEvent(new Playing(Playing.MEDIA_PROGRESS, this._stream, this._url, LoadedFile.TYPE_VIDEO, this._currentTime, this._totalTime));
				var subNow:String = this._subtitles.checkTime(this._currentTime * 1000);
				if (subNow) {
					if (this._subtitleSet == null) {
						this._showsub.htmlText = subNow;
						if (subNow != "") this._showsub.y = this.height - this._showsub.textHeight - 15;
					}
				}
				
				// all time passed?
				if (Math.ceil(this._currentTime) >= Math.ceil(this._totalTime)) {
					if (this.loop) {
						this._currentTime = 0;
						this._stream.seek(0);
						this._subtitles.restart();
						this._showsub.text = "";
						if (this._subtitleSet != null) this._showsub.text = this._subtitleSet;
						this.dispatchEvent(new Playing(Playing.MEDIA_LOOP, this._stream, this._url, LoadedFile.TYPE_VIDEO, this._currentTime, this._totalTime));
					} else {
						this.stop();
						this._subtitles.restart();
						this._showsub.text = "";
						if (this._subtitleSet != null) this._showsub.text = this._subtitleSet;
						this.dispatchEvent(new Playing(Playing.MEDIA_END, this._stream, this._url, LoadedFile.TYPE_VIDEO, this._currentTime, this._totalTime));
					}
				}
			}
		}
		
		/**
		 * Metadata received.
		 */
		private function metadataEvent(data:Object):void {
			this._totalTime = 0;
			for (var index:String in data) {
				if (index == "duration") this._totalTime = Number(data[index]);
				if ((index == "totalduration") && (this._totalTime == 0)) this._totalTime = Number(data[index]);
			}
		}
		/**
		 * Image data received.
		 */
		private function imagedataEvent(data:Object):void {
			/* do nothing */
		}
		/**
		 * Playstatus data received.
		 */
		private function playstatusEvent(data:Object):void {
			/* do nothing */
		}
		/**
		 * Cuepoint data received.
		 */
		private function cuepointEvent(data:Object):void {
			this.dispatchEvent(new Playing(Playing.MEDIA_CUE, this._stream, this._url, LoadedFile.TYPE_VIDEO, this._currentTime, this._totalTime, data));
		}
		
	}

}
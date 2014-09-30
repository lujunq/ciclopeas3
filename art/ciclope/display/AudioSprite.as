package art.ciclope.display {
	
	// FLASH PACKAGES
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.display.BitmapData;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.Font;
	import flash.filters.DropShadowFilter;
	
	// CICLOPE CLASSES
	import art.ciclope.event.Loading;
	import art.ciclope.event.Playing;
	import art.ciclope.util.LoadedFile;
	import art.ciclope.util.MediaDefinitions;
	import art.ciclope.handle.SubtitleManager;
	
	// EVENTS
	
	/**
     * Sound closed.
     */
    [Event( name = "CLOSE", type = "flash.events.Event" )]
	/**
     * Sound file open.
     */
    [Event( name = "OPEN", type = "flash.events.Event" )]
	/**
     * Sound file download progress.
     */
    [Event( name = "PROGRESS", type = "flash.events.ProgressEvent" )]
	/**
     * IO Error while loading sound.
     */
    [Event( name = "IO_ERROR", type = "flash.events.IOErrorEvent" )]
	/**
     * Sound starts playing.
     */
    [Event( name = "MEDIA_PLAY", type = "art.ciclope.event.Playing" )]
	/**
     * Sound stops playing.
     */
    [Event( name = "MEDIA_STOP", type = "art.ciclope.event.Playing" )]
	/**
     * Sound playback pause.
     */
    [Event( name = "MEDIA_PAUSE", type = "art.ciclope.event.Playing" )]
	/**
     * Sound playback seek.
     */
    [Event( name = "MEDIA_SEEK", type = "art.ciclope.event.Playing" )]
	/**
     * Sound playback loop.
     */
    [Event( name = "MEDIA_LOOP", type = "art.ciclope.event.Playing" )]
	/**
     * Sound playback reached end of file.
     */
    [Event( name = "MEDIA_END", type = "art.ciclope.event.Playing" )]
	/**
     * Sound playback progress.
     */
    [Event( name = "MEDIA_PROGRESS", type = "art.ciclope.event.Playing" )]
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * AudioSprite adds a sprite tha can be used to control the playback of an audio file. The sprite can also include an icon to show on stage.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class AudioSprite extends Sprite {
		
		// VARIABLES
		
		/**
		 * The icon display.
		 */
		private var _icon:Bitmap;
		/**
		 * The sound itself.
		 */
		private var _sound:Sound;
		/**
		 * SoundChannel data.
		 */
		private var _channel:SoundChannel;
		/**
		 * Does sound object have loaded data?
		 */
		private var _loadedData:Boolean;
		/**
		 * Current playback time.
		 */
		private var _currentTime:Number;
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
		/**
		 * The sprite width.
		 */
		private var _setWidth:Number;
		/**
		 * The sprite height.
		 */
		private var _setHeight:Number;
		
		// PUBLIC VARIABLES
		
		/**
		 * Start playing right after enough amount of the file is loaded? (default = true)
		 */
		public var playOnLoad:Boolean;
		/**
		 * Loop media playback?
		 */
		public var loop:Boolean = true;
		
		public var active:Boolean = true;
		
		// CONSTRUCTOR
		
		/**
		 * AudioSprite constructor.
		 * @param	width	image width
		 * @param	height	image height
		 * @param	file	The file url to load (leave default to create an empty AudioSprite).
		 * @param	iconImage	A single frame display object to be used as an icon for this sprite (optional).
		 */
		public function AudioSprite(width:Number = 80, height:Number = 45, file:String = "", iconImage:DisplayObject = null) {
			// create icons
			this._setWidth = width;
			this._setHeight = height;
			var imgCopy:BitmapData;
			if (iconImage != null) {
				iconImage.cacheAsBitmap = true;
				imgCopy = new BitmapData(iconImage.width, iconImage.height);
				imgCopy.draw(iconImage);
				this._icon = new Bitmap(imgCopy);
				this._icon.width = width;
				this._icon.height = height;
				this.addChild(this._icon);
			}
			// prepare sound
			this._loadedData = false;
			this._sound = new Sound();
			this._sound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			this._sound.addEventListener(Event.OPEN, openHandler);
			this._sound.addEventListener(Event.COMPLETE, completeHandler);
			this._sound.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			// creating subtitle text
			this._showsub = new TextField();
			this.addChild(this._showsub);
			this._showsub.text = "";
			this._showsub.wordWrap = true;
			this._showsub.multiline = true;
			this._showsub.selectable = false;
			this._subtitleSet = null;
			// formatting text. embed font available?
			var fonts:Array = Font.enumerateFonts();
			var format:TextFormat = new TextFormat();
			if (fonts.length > 0) {
				format.font = fonts[0];
				this._showsub.embedFonts = true;
			} else {
				format.font = "_sans";
				this._showsub.embedFonts = false;
			}
			format.size = 16;
			format.color = 0xFFFF00;
			format.bold = true;
			format.align = "center";
			format.leading = -5;
			this._showsub.defaultTextFormat = format;
			this._showsub.filters = [new DropShadowFilter(1, 45, 0, 1, 2, 2)];
			this._showsub.antiAliasType = "advanced";
			this._showsub.x = 5;
			this._showsub.width = width - 10;
			// initializing
			this.playbackInterval = MediaDefinitions.PLAYBACKUPDATE_SPEED;
			this._state = MediaDefinitions.PLAYBACKSTATE_UNLOAD;
			this._currentTime = 0;
			this._bufferStart = 10;
			this.playOnLoad = true;
			this._amountLoaded = 0;
			this._soundTransform = new SoundTransform();
			this._subtitles = new SubtitleManager();
			// load file
			if (file != "") this.load(file);
		}
		
		// PUBLIC FUNCTIONS
		
		/**
		 * Add a Sound object as the source.
		 * @param	resource	a Sound object to play
		 */
		public function addSound(resource:Sound):void {
			if (this._sound) {
				this._sound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				this._sound.addEventListener(Event.OPEN, openHandler);
				this._sound.addEventListener(Event.COMPLETE, completeHandler);
				this._sound.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				try { this._sound.close() } catch (e:Error) { }
			}
			this._sound = resource;
			this._sound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			this._sound.addEventListener(Event.OPEN, openHandler);
			this._sound.addEventListener(Event.COMPLETE, completeHandler);
			this._sound.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			this.dispatchEvent(new Event(Event.COMPLETE));
			this._loadedData = true;
			if (this.playOnLoad) {
				this.play(0);
			} else {
				this._state = MediaDefinitions.PLAYBACKSTATE_STOP;
				this.dispatchEvent(new Playing(Playing.MEDIA_STOP, this._channel, this.currentFile, LoadedFile.TYPE_AUDIO, this._currentTime, this.totalTime));
			}
		}
		
		/**
		 * Load an audio file (mp3).
		 * @param	url	Path to the mp3 file.
		 */
		public function load(url:String):void {
			var request:URLRequest = new URLRequest(url);
			if (this._sound != null) {
				try { this._sound.close(); } catch (e:Error) { }
				this._sound.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				this._sound.removeEventListener(Event.OPEN, openHandler);
				this._sound.removeEventListener(Event.COMPLETE, completeHandler);
				this._sound.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
				this._sound = null;
			}
			this._sound = new Sound();
			this._sound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			this._sound.addEventListener(Event.OPEN, openHandler);
			this._sound.addEventListener(Event.COMPLETE, completeHandler);
			this._sound.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			this._loadedData = false;
			this._sound.load(request);
			this._amountLoaded = 0;
			this._state = MediaDefinitions.PLAYBACKSTATE_UNLOAD;
		}
		
		/**
		 * Close data stream.
		 */
		public function close():void {
			try { this._sound.close(); } catch (e:Error) { }
			this._state = MediaDefinitions.PLAYBACKSTATE_UNLOAD;
			this._loadedData = false;
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
		/**
		 * Play the loaded sound media.
		 * @param	time	The start time of playback (default = current time).
		 * @return	True if a media is loaded and ready to play, false otherwise.
		 */
		public function play(time:int = -1, noEvent:Boolean = false):Boolean {
			if (((this._state != MediaDefinitions.PLAYBACKSTATE_PLAY) && this.active) || (time >= 0)) {
				if (this._loadedData) {
					if (time < 0) time = this._currentTime;
					if (this._channel != null) {
						this._channel.removeEventListener(Event.SOUND_COMPLETE, soundComplete);
						this._channel.stop();
						this._channel = null;
					}
					this._channel = this._sound.play(time * 1000);
					this._channel.soundTransform = this._soundTransform;
					this._channel.addEventListener(Event.SOUND_COMPLETE, soundComplete);
					this._state = MediaDefinitions.PLAYBACKSTATE_PLAY;
					if (!noEvent) this.dispatchEvent(new Playing(Playing.MEDIA_PLAY, this._channel, this.currentFile, LoadedFile.TYPE_AUDIO, this._currentTime, this.totalTime));
					return (true);
				} else {
					return (false);
				}
			} else {
				return (false);
			}
		}
		
		/**
		 * Stop playing the audio and rewinds it to the beginning of the file.
		 * @return	True if an audio is playing or paused and can be stopped, false otherwise.
		 */
		public function stop():Boolean {
			if ((this._state == MediaDefinitions.PLAYBACKSTATE_PLAY) || (this._state == MediaDefinitions.PLAYBACKSTATE_PAUSE)) {
				if (this._channel) this._channel.stop();
				this._currentTime = 0;
				this._state = MediaDefinitions.PLAYBACKSTATE_STOP;
				this.dispatchEvent(new Playing(Playing.MEDIA_STOP, this._channel, this.currentFile, LoadedFile.TYPE_AUDIO, this._currentTime, this.totalTime));
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Pause the audio playback.
		 * @return	True if an audio is playing and can be paused, false otherwise.
		 */
		public function pause():Boolean {
			if (this._state == MediaDefinitions.PLAYBACKSTATE_PLAY) {
				this._channel.stop();
				this._state = MediaDefinitions.PLAYBACKSTATE_PAUSE;
				this.dispatchEvent(new Playing(Playing.MEDIA_PAUSE, this._channel, this.currentFile, LoadedFile.TYPE_AUDIO, this._currentTime, this.totalTime));
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
				if (((to * 100) / (this.totalTime)) < this._amountLoaded) {
					this._currentTime = to;
					this._subtitles.restart();
					if (this._state == MediaDefinitions.PLAYBACKSTATE_PLAY) this.play(to, true);
					this.dispatchEvent(new Playing(Playing.MEDIA_SEEK, this._channel, this.currentFile, LoadedFile.TYPE_AUDIO, this._currentTime, this.totalTime));
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
			// clear all listeners
			try {
				this._timer.removeEventListener(TimerEvent.TIMER, updatePlayback);
				this._sound.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				this._sound.removeEventListener(Event.OPEN, openHandler);
				this._sound.removeEventListener(Event.COMPLETE, completeHandler);
				this._sound.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
				this._channel.removeEventListener(Event.SOUND_COMPLETE, soundComplete);
			} catch (e:Error) { }
			// unload
			if (this._channel) this._channel.stop();
			this.close();
			// remove graphics
			if (this._icon) {
				this.removeChild(this._icon);
				this._icon.bitmapData.dispose();
				this._icon = null;
			}
			// timer
			if (this._timer) if (this._timer.running) this._timer.stop();
			this._timer = null;
			// other variables
			this._sound = null;
			this._channel = null;
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
		 * Original media width (constant, for compatibility with VideoSprite).
		 */
		public function get originalWidth():Number {
			return (80);
		}
		
		/**
		 * Original media height (constant, for compatibility with VideoSprite)..
		 */
		public function get originalHeight():Number {
			return (45);
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
			if (this._sound) return (this._sound.length / 1000);
				else return (0);
		}
		
		/**
		 * The loaded file URL.
		 */
		public function get currentFile():String {
			if (this._sound) return (this._sound.url);
				else return (null);
		}
		
		// PROPERTIES
		
		/**
		 * The sprite width.
		 */
		override public function get width():Number {
			return (this._setWidth);
		}
		override public function set width(to:Number):void {
			this._setWidth = to;
			if (this._icon) this._icon.width = to;
			this._showsub.x = 5;
			this._showsub.width = to - 10;
		}
		
		/**
		 * The sprite height.
		 */
		override public function get height():Number {
			return (this._setHeight);
		}
		override public function set height(to:Number):void {
			this._setHeight = to;
			if (this._icon) this._icon.height = to;
		}
		
		/**
		 * Sets the update interval for media playback. (default is optimized for speed)
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
			if (this._channel != null) this._channel.soundTransform = this._soundTransform;
		}
		
		/**
		 * The audio SoundTransform object. Notice that the current volume overrides the volume value of the new sound transform. The get value is just a copy, not this object's soundtransform itself.
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
			if (this._channel != null) this._channel.soundTransform = this._soundTransform;
		}
		
		/**
		 * Smoothing of the diplay icon.
		 */
		public function get smoothing():Boolean {
			if (!this._icon) return (false);
				else return (this._icon.smoothing);
		}
		public function set smoothing(to:Boolean):void {
			if (this._icon) this._icon.smoothing = to;
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
		 * OPEN error event.
		 */
		private function openHandler(evt:Event):void { this.dispatchEvent(evt); }
		/**
		 * COMPLETE error event.
		 */
		private function completeHandler(evt:Event):void { /*this.dispatchEvent(evt);*/ }
		/**
		 * PROGRESS error event.
		 */
		private function progressHandler(evt:ProgressEvent):void {
			// how much of the file was loaded?
			this._amountLoaded = Math.round((evt.bytesLoaded * 100) / evt.bytesTotal);
			// is the required buffer filled?
			if (!this._loadedData) {
				if (this._amountLoaded >= this._bufferStart) {
					this.dispatchEvent(new Event(Event.COMPLETE));
					this._loadedData = true;
					if (this.playOnLoad) {
						this.play(0);
					} else {
						this._state = MediaDefinitions.PLAYBACKSTATE_STOP;
						this.dispatchEvent(new Playing(Playing.MEDIA_STOP, this._channel, this.currentFile, LoadedFile.TYPE_AUDIO, this._currentTime, this.totalTime));
					}
					// check for subtitles
					this._subtitles.checkSrt(this.currentFile);
				}
			}
			this.dispatchEvent(evt);
		}
		/**
		 * Playback update.
		 */
		private function updatePlayback(evt:TimerEvent):void {
			if (this._state == MediaDefinitions.PLAYBACKSTATE_PLAY) {
				this._currentTime = this._channel.position / 1000;
				var subNow:String = this._subtitles.checkTime(this._currentTime * 1000);
				if (subNow) {
					if (this._subtitleSet == null) {
						this._showsub.htmlText = subNow;
						if (subNow != "") this._showsub.y = this.height - this._showsub.textHeight - 15;
					}
				}
				
				this.dispatchEvent(new Playing(Playing.MEDIA_PROGRESS, this._channel, this.currentFile, LoadedFile.TYPE_AUDIO, this._currentTime, this.totalTime));
			}
		}
		/**
		 * Sound playback reaches the end of the file.
		 */
		private function soundComplete(evt:Event):void {
			this._state = MediaDefinitions.PLAYBACKSTATE_STOP;
			if (this.loop) {
				this._currentTime = 0;
				this.play( -1, true);
				this._subtitles.restart();
				if (this._subtitleSet == null) this._showsub.text = "";
				this.dispatchEvent(new Playing(Playing.MEDIA_LOOP, this._channel, this.currentFile, LoadedFile.TYPE_AUDIO, this._currentTime, this.totalTime));
			} else {
				this.stop();
				this._subtitles.restart();
				if (this._subtitleSet == null) this._showsub.text = "";
				this.dispatchEvent(new Playing(Playing.MEDIA_END, this._channel, this.currentFile, LoadedFile.TYPE_AUDIO, this._currentTime, this.totalTime));
			}
		}
		
	}

}
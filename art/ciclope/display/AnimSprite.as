package art.ciclope.display {
	
	// FLASH PACKAGES
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.utils.Timer;
	
	// CICLOPE CLASSES
	import art.ciclope.util.Placing;
	import art.ciclope.handle.MultipleDownload;
	import art.ciclope.util.LoadedFile;
	import art.ciclope.event.Loading;
	import art.ciclope.util.MediaDefinitions;
	import art.ciclope.event.Playing;
	
	// EVENTS
	
	/**
     * Animation starts playing.
     */
    [Event( name = "MEDIA_PLAY", type = "art.ciclope.event.Playing" )]
	/**
     * Animation playback pause.
     */
    [Event( name = "MEDIA_PAUSE", type = "art.ciclope.event.Playing" )]
	/**
     * All requestes picture frames were downloaded.
     */
    [EVENT( name = "QUEUE_END", type = "art.ciclope.event.Loading" )]
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * AnimSprite provides a simple way to load and play a picture sequence as an animation.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class AnimSprite extends Sprite	{
		
		// VARIABLES
		
		/**
		 * The animation frames of current AnimSprite.
		 */
		private var _frame:Array;
		/**
		 * The current animation frame.
		 */
		private var _current:uint;
		/**
		 * Update time count (in miliseconds)
		 */
		private var _update:uint;
		/**
		 * A timer for image update.
		 */
		private var _timer:Timer;
		/**
		 * List of defined animations.
		 */
		private var _animation:Array;
		/**
		 * The current animation name.
		 */
		private var _currentAnimation:String;
		/**
		 * A download manager for external files.
		 */
		private var _downloader:MultipleDownload;
		/**
		 * Is the animation playing?
		 */
		private var _playing:Boolean;
		/**
		 * Smooth bitmap images on resize?
		 */
		private var _smoothing:Boolean;
		/**
		 * Use GPU acceleration?
		 */
		private var _useGPU:Boolean;
		
		// PUBLIC VARIABLES
		
		/**
		 * Forced image width (leave lower than 0 to use original picture width).
		 */
		public var forcedWidth:int = -1;
		/**
		 * Forced image height (leave lower than 0 to use original picture height).
		 */
		public var forcedHeight:int = -1;
		/**
		 * Play animation backwards?
		 */
		public var playbackwards:Boolean = false;
		/**
		 * Reposition images every time they are redrawn? Useful if you manipulate the images outside this class - leave false otherwise.
		 */
		public var replaceOnRedraw:Boolean = false;
		
		public var active:Boolean = true;
		
		/**
		 * AnimSprite constructor.
		 * @param	update	update time count (miliseconds)
		 * @param	forcedWidth	forced image width (leave lower than 0 to use original picture width)
		 * @param	forcedHeight	forced image height (leave lower than 0 to use original picture height)
		 */
		public function AnimSprite(update:uint = 83, forcedWidth:int = -1, forcedHeight:int = -1) {
			// creating the frames
			this._frame = new Array();
			// getting values
			this._update = update;
			this._animation = new Array();
			this._currentAnimation = new String();
			this._smoothing = false;
			this.forcedWidth = forcedWidth;
			this.forcedHeight = forcedHeight;
			this._useGPU = false;
			// preparing downloads
			this._downloader = new MultipleDownload();
			this._downloader.addEventListener(Loading.QUEUE_END, onDownloaderFinished);
			// preparing image update
			this._playing = true;
			this._timer = new Timer(this._update);
			this._timer.addEventListener(TimerEvent.TIMER, timerUpdate);
			this._timer.start();
		}
		
		// READ-ONLY VALUES
		
		/**
		 * The current animation frame.
		 */
		public function get current():uint {
			return (this._current);
		}
		
		/**
		 * The total number of frames of this AnimSprite.
		 */
		public function get total():uint {
			return (this._frame.length);
		}
		
		/**
		 * The name of the current animation.
		 */
		public function get animation():String {
			return (this._currentAnimation);
		}
		
		/**
		 * A list of available animation names.
		 */
		public function get animationList():Array {
			var ret:Array = new Array();
			for (var index:String in this._animation) ret.push(index);
			return (ret);
		}
		
		/**
		 * The media playback state.
		 * @see	art.ciclope.util.MediaDefinitions
		 */
		public function get mediaState():String {
			if (this._playing) return (MediaDefinitions.PLAYBACKSTATE_PLAY);
			else return (MediaDefinitions.PLAYBACKSTATE_PAUSE);
		}
		
		/**
		 * Playback time of current animation in milliseconds (always 0 if the animation has only one frame).
		 */
		public function get currentTime():Number {
			if (this._currentAnimation == "") return (this._update * this._current);
			else return (this._update * (this._current - this._animation[this._currentAnimation].start));
		}
		
		/**
		 * Total playback time in milliseconds of current animation (0 if the animation has only one frame).
		 */
		public function get totalTime():Number {
			if (this._currentAnimation == "") return (this._update * this._frame.length);
			else return (this._update * (this._animation[this._currentAnimation].end - this._animation[this._currentAnimation].start));
		}
 		
		// PROPERTIES
		
		/**
		 * The image animation update frequency in miliseconds.
		 */
		public function get update():uint {
			return (this._update);
		}
		public function set update(to:uint):void {
			this._timer.stop();
			this._timer.removeEventListener(TimerEvent.TIMER, timerUpdate);
			this._timer = null;
			this._update = to;
			this._timer = new Timer(to);
			this._timer.addEventListener(TimerEvent.TIMER, timerUpdate);
			this._timer.start();
		}
		
		/**
		 * Smooth bitmap images on resize?
		 */
		public function get smoothing():Boolean {
			return (this._smoothing);
		}
		public function set smoothing(to:Boolean):void {
			this._smoothing = true;
			for (var index:uint = 0; index < this._frame.length; index++) {
				if (this._frame[index].image is Bitmap) this._frame[index].image.smoothing = this._smoothing;
			}
		}
		
		/**
		 * Use GPU to accelerate bitmaps on mobile devices?
		 */
		public function get useGPU():Boolean {
			return (this._useGPU);
		}
		public function set useGPU(to:Boolean):void {
			this._useGPU = to;
			for (var index:uint = 0; index < this._frame.length; index++) {
				if (to) {
					this._frame[index].image.cacheAsBitmap = true;
					this._frame[index].image.cacheAsBitmapMatrix = new Matrix();
				} else {
					this._frame[index].image.cacheAsBitmap = false;
				}
			}
		}
		
		// PUBLIC METHODS
		
		/**
		 * Adds a frame and returns the id of the new frame.
		 * @param	img	The frame image.
		 * @param	placing	The frame image placing according to "Placing" constants.
		 * @return	The number id of the new frame.
		 * @see	art.ciclope.util.Placing
		 */
		public function addFrame(img:DisplayObject, placing:String = "CENTER"):uint {
			// create frame
			if (img is Bitmap) Bitmap(img).smoothing = this._smoothing;
			var newFrame:Object = new Object();
			newFrame.image = img;
			newFrame.placing = placing;
			if (img.width > 0) this.placeImage(newFrame.image, newFrame.placing);
			// GPU
			if (this._useGPU) {
				newFrame.image.cacheAsBitmap = true;
				newFrame.image.cacheAsBitmapMatrix = new Matrix();
			} else {
				newFrame.image.cacheAsBitmap = false;
			}
			// add frame
			var id:uint = this._frame.push(newFrame) - 1;
			if (id == 0) this.setFrame(0); // draw frame if it is the first one
			return (id);
		}
		
		/**
		 * Adds a new animation reference. If animation name already exists, update it.
		 * @param	start	Start frame number.
		 * @param	end	End frame number.
		 * @param	name	Animation name.
		 */
		public function addAnimation(start:uint, end:uint, name:String):void {
			// creating new animation info object
			var newAnim:Object = new Object();
			newAnim.start = start;
			newAnim.end = end;
			newAnim.name = name;
			// add animation to the list
			this._animation[name] = newAnim;
		}
		
		/**
		 * Sets the current animation name.
		 * @param	to	The animation to use.
		 * @return	True if the animation is found and set, false otherwise.
		 */
		public function setAnimation(to:String):Boolean {
			if ((this._animation[to]) || (to == "")) {
				this._currentAnimation = to;
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Loads a file into an animation frame.
		 * @param	url	The path to the picture or swf file.
		 * @param	placing	The frame image placing according to "Placing" constants.
		 * @return	The number id of the new frame. -1 if the file is of incorrect format and was not add.
		 * @see	art.ciclope.util.Placing
		 */
		public function loadFrame(url:String, placing:String = "CENTER"):int {
			if ((LoadedFile.typeOf(url) == LoadedFile.TYPE_FLASH) || (LoadedFile.typeOf(url) == LoadedFile.TYPE_PICTURE)) {
				// create frame to receive file
				var order:uint = this.addFrame(new Sprite(), placing);
				// set download
				this._downloader.addFile(url, String(order), returnDownload);
				// file add
				return (order);
			} else {
				// incompatible file type
				return (-1);
			}
		}
		
		/**
		 * Loads a sequence of file as an animation.
		 * @param	name	The animation name (must be new - this method won't update an existing animation).
		 * @param	urls	An array with the paths (String) to the files.
		 * @param	placing	The frame image placing according to "Placing" constants.
		 * @return	True if the animation sequence could be set, false otherwise (existing animation name or invalid file types).
		 * @see	art.ciclope.util.Placing
		 */
		public function loadAnimation(name:String, urls:Array, placing:String = "CENTER"):Boolean {
			// only add a new animation (won't update using this method)
			if (this._animation[name]) {
				return (false);
			} else {
				// check for urls
				var urlOK:Boolean = true;
				for (var index:uint = 0; index < urls.length; index++) if (!(LoadedFile.isPicorFlash(urls[index]))) urlOK = false;
				if (urlOK) {
					// add frames
					var start:uint;
					var end:uint;
					for (index = 0; index < urls.length; index++) {
						var pos:uint = this.loadFrame(urls[index], placing);
						if (index == 0) start = pos;
						if (index == (urls.length - 1)) end = pos;
					}
					// set animation name
					this.addAnimation(start, end, name);
				}
				return (urlOK);
			}
		}
		
		/**
		 * Resumes animation playback.
		 * @param time	time position to play (not used, only for compatibility purposes)
		 */
		public function play(time:int = -1):void {
			this._playing = true;
			this.dispatchEvent(new Playing(Playing.MEDIA_PLAY, this, "animation", LoadedFile.TYPE_ANIMATION, this.currentTime, this.totalTime));
		}
		
		/**
		 * Pauses animation playback (same as stop).
		 */
		public function pause():void {
			this._playing = false;
			this.dispatchEvent(new Playing(Playing.MEDIA_PAUSE, this, "animation", LoadedFile.TYPE_ANIMATION, this.currentTime, this.totalTime));
		}
		
		/**
		 * Stops animation playback (same as pause).
		 */
		public function stop():void {
			this._playing = false;
			this.dispatchEvent(new Playing(Playing.MEDIA_PAUSE, this, "animation", LoadedFile.TYPE_ANIMATION, this.currentTime, this.totalTime));
		}
		
		/**
		 * Seek: does nothig. Set only to be compatible with the other sprite classes.
		 * @param	to	anything
		 */
		public function seek(to:*):void {
			// do nothing: only for compatibility.
		}
		
		/**
		 * Opens an animation frame and starts playing.
		 * @param	to	The frame to open.
		 * @return	True if the frame exists, false otherwise.
		 */
		public function gotoAndPlay(to:uint):Boolean {
			if (this.setFrame(to)) {
				this.play();
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Opens an animation frame and stops playing.
		 * @param	to	The frame to open.
		 * @return	True if the frame exists, false otherwise.
		 */
		public function gotoAndStop(to:uint):Boolean {
			if (this.setFrame(to)) {
				this.stop();
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Destroys this object to release memory.
		 */
		public function kill():void {
			// kill downloads
			this._downloader.kill();
			this._downloader = null;
			// release all imagery
			this.clear();
			while (this._frame.length > 0) {
				delete (this._frame[0].image);
				delete (this._frame[0].placing);
				this._frame.shift();
			}
			this._frame = null;
			// release animation data
			for (var index:String in this._animation) {
				delete (this._animation[index].start);
				delete (this._animation[index].end);
				delete (this._animation[index].name);
				delete (this._animation[index]);
			}
			// stop update
			this._timer.stop();
			this._timer.removeEventListener(TimerEvent.TIMER, timerUpdate);
			this._timer = null;
		}
		
		// PRIVATE METHODS
		
		/**
		 * Sets the current frame.
		 * @param	num	The chosen frame.
		 * @return	True if the frame exists and was set, false otherwise.
		 */
		private function setFrame(num:uint):Boolean {
			if (num < this.total) {
				// remove any visible frame
				this.clear();
				// show requested image
				this.addChild(this._frame[num].image);
				if (this.replaceOnRedraw) this.placeImage(this._frame[num].image, this._frame[num].pacing);
				this._current = num;
				// force width and height?
				if (this.forcedWidth >= 0) this._frame[num].image.width = this.forcedWidth;
				if (this.forcedHeight >= 0) this._frame[num].image.height = this.forcedHeight;
				// frame correctly set
				return (true);
			} else {
				// no frame drawn
				return (false);
			}
		}
		
		/**
		 * Removes the current shown image.
		 */
		private function clear():void {
			while (this.numChildren) this.removeChildAt(0);
		}
		
		/**
		 * Place the image according to the point set.
		 * @param	img	The graphic element to position.
		 * @param	placement	The placement accroding to "Placing" constants.
		 * @see	art.ciclope.util.Placing
		 */
		private function placeImage(img:DisplayObject, placement:String):void {
			switch (placement) {
				case Placing.TOPLEFT:
					img.x = 0;
					img.y = 0;
					break;
				case Placing.TOPCENTER:
					img.x = -img.width / 2;
					img.y = 0;
					break;
				case Placing.TOPRIGHT:
					img.x = -img.width;
					img.y = 0;
					break;
				case Placing.MIDDLELEFT:
					img.x = 0;
					img.y = -img.height / 2;
					break;
				case Placing.CENTER:
					img.x = -img.width / 2;
					img.y = -img.height / 2;
					break;
				case Placing.MIDDLERIGHT:
					img.x = -img.width;
					img.y = -img.height / 2;
					break;
				case Placing.BOTTOMLEFT:
					img.x = 0;
					img.y = -img.height;
					break;
				case Placing.BOTTOMCENTER:
					img.x = -img.width / 2;
					img.y = -img.height;
					break;
				case Placing.BOTTOMRIGHT:
					img.x = -img.width;
					img.y = -img.height;
					break;
			}
		}
		
		/**
		 * A file download is complete.
		 * @param	name	Download id (frame number).
		 * @param	img	Image resource.
		 * @param	comment	About the download.
		 * @param	status	Download status.
		 */
		private function returnDownload(name:String, img:Loader, comment:String, status:String):void {
			// file download ok
			if (status == Loading.FINISHED) {
				if (img.content is Bitmap) Bitmap(img.content).smoothing = this._smoothing;
				if (this._current == uint(name)) this.removeChild(this._frame[uint(name)].image);
				delete (this._frame[uint(name)].image);
				this.placeImage(img.content, this._frame[uint(name)].placing);
				this._frame[uint(name)].image = img.content;
				if (this._useGPU) {
					this._frame[uint(name)].image.cacheAsBitmap = true;
					this._frame[uint(name)].image.cacheAsBitmapMatrix = new Matrix();
				} else {
					this._frame[uint(name)].image.cacheAsBitmap = false;
				}
				if (this.forcedWidth >= 0) this._frame[uint(name)].image.width = this.forcedWidth;
				if (this.forcedHeight >= 0) this._frame[uint(name)].image.height = this.forcedHeight;
				if (this._current == uint(name)) this.addChild(this._frame[uint(name)].image);
			}
		}
		
		/**
		 * Updates image in animation.
		 * @param	evt	Timer update.
		 */
		private function timerUpdate(evt:TimerEvent):void {
			// update play?
			if (this._playing) {
				var toUse:int;
				if (this.playbackwards) toUse = this._current - 1;
				else toUse = this._current + 1;
				// no animation set: iterate through all frames
				if (this._currentAnimation == "") {
					if (toUse >= this._frame.length) toUse = 0;
					else if (toUse < 0) toUse = this._frame.length - 1;
				} else {
					// check in animation
					if ((toUse < this._animation[this._currentAnimation].start) || (toUse > this._animation[this._currentAnimation].end)) toUse = this._animation[this._currentAnimation].start;
				}
				// set correct frame
				this.setFrame(toUse);
			}
		}
		
		/**
		 * All requested picture frames were downloaded.
		 */
		private function onDownloaderFinished(evt:Loading):void {
			this.dispatchEvent(new Loading(Loading.QUEUE_END));
		}
		
	}

}
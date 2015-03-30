package art.ciclope.display {
	
	// FLASH PACKAGES
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.media.SoundTransform;
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	// CICLOPE CLASSES
	import art.ciclope.event.Loading;
	import art.ciclope.event.Playing;
	import art.ciclope.util.LoadedFile;
	import art.ciclope.util.MediaDefinitions;
	
	// EVENTS
	
	/**
     * File download finished.
     */
    [Event( name = "FINISHED", type = "art.ciclope.event.Loading" )]
	/**
     * File download HTTP status.
     */
    [Event( name = "HTTP_STATUS", type = "art.ciclope.event.Loading" )]
	/**
     * File unload.
     */
    [Event( name = "UNLOAD", type = "art.ciclope.event.Loading" )]
	/**
     * File download IO error.
     */
    [Event( name = "ERROR_IO", type = "art.ciclope.event.Loading" )]
	/**
     * File download progress.
     */
    [Event( name = "PROGRESS", type = "art.ciclope.event.Loading" )]
	
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * GraphicSprite extends sprite making downloading and showing of external graphic files (picture or swf movies) easier.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class GraphicSprite extends Sprite {
		
		// STATIC CONSTANTS
		
		/**
		 * Display mode: stretch graphic into sprite dimensions.
		 */
		public static const DISPLAY_STRETCH:String = "stretch";
		/**
		 * Display mode: crop graphic to sprite dimensions and hide overflow. 
		 */
		public static const DISPLAY_CROP:String = "crop";
		
		// VARIABLES
		
		/**
		 * The graphic itself.
		 */
		private var _graphic:Loader;
		/**
		 * The file url.
		 */
		private var _url:String;
		/**
		 * The width set.
		 */
		private var _width:Number;
		/**
		 * The height set.
		 */
		private var _height:Number;
		/**
		 * The x position set.
		 */
		private var _x:Number;
		/**
		 * The y position set.
		 */
		private var _y:Number;
		/**
		 * Is the stream downloading?
		 */
		private var _loading:Boolean;
		/**
		 * A sound transform for loaded swf.
		 */
		private var _soundTransform:SoundTransform;
		/**
		 * Should bitmaps be smoothed on resize?
		 */
		private var _smoothing:Boolean;
		/**
		 * A container for internal (not downloaded) display objects add to this sprite.
		 */
		private var _container:Sprite;
		/**
		 * Load graphic using its original size?
		 */
		private var _loadOriginalSize:Boolean;
		/**
		 * Display mode properties. Check display mode constants.
		 */
		private var _displayMode:String = GraphicSprite.DISPLAY_CROP;
		
		/**
		 * Is display active?
		 */
		public var active:Boolean = true;
		
		/**
		 * GraphicSprite constructor.
		 * @param	width	Graphic width.
		 * @param	height	Graphic height.
		 * @param	file	The file url to load (leave default to create an empty GraphicSprite).
		 * @param	useOriginalSize	load graphic using its original size? (ignores width and height parameters of set to true)
		 */
		public function GraphicSprite(width:Number = 160, height:Number = 90, file:String = "", useOriginalSize:Boolean = false) {
			// getting values
			this._width = width;
			this._height = height;
			this._loadOriginalSize = useOriginalSize;
			// setting values
			this._loading = false;
			this._smoothing = true;
			this._soundTransform = new SoundTransform();
			// container
			this._container = new Sprite();
			this.addChild(this._container);
			// preparing
			this._graphic = new Loader();
			this.addChild(this._graphic);
			this._graphic.contentLoaderInfo.addEventListener(Event.INIT, onInit);
			this._graphic.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
			this._graphic.contentLoaderInfo.addEventListener(Event.UNLOAD, onUnload);
			this._graphic.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			this._graphic.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			// load file?
			if (file != "") this.load(file);
		}
		
		// PROPERTIES
		
		/**
		 * Display x position.
		 */
		override public function get x():Number {
			return (this._x);
		}
		override public function set x(value:Number):void {
			this._x = value;
			super.x = value;
		}
		
		/**
		 * Display y position.
		 */
		override public function get y():Number {
			return (this._y);
		}
		override public function set y(value:Number):void {
			this._y = value;
			super.y = value;
		}
		
		/**
		 * The object's width.
		 */
		override public function get width():Number {
			return (this._width);
		}
		override public function set width(to:Number):void {
			this._width = to;
			if (this._url != "") {
				// apply standard DISPLAY_STRETCH display
				this._graphic.width = to;
				this._graphic.x = 0;
				this._container.width = to;
				// check for crop display option
				if (this.displayMode == GraphicSprite.DISPLAY_CROP) {
					this._graphic.scaleY = this._graphic.scaleX;
					if (this._graphic.height < this._height) {
						this._graphic.height = this._height;
						this._graphic.scaleX = this._graphic.scaleY;
					}
					//this._graphic.x = (this._width - this._graphic.width) / 2;
					//this._graphic.y = (this._height - this._graphic.height) / 2;
				}
			}
		}
		
		/**
		 * The object's height.
		 */
		override public function get height():Number {
			return (this._height);
		}
		override public function set height(to:Number):void {
			this._height = to;
			if (this._url != "") {
				// apply standard DISPLAY_STRETCH display
				this._graphic.height = to;
				this._graphic.y = 0;
				this._container.height = to;
				// check for crop display option
				if (this.displayMode == GraphicSprite.DISPLAY_CROP) {
					this._graphic.scaleX = this._graphic.scaleY;
					if (this._graphic.width < this._width) {
						this._graphic.width = this._width;
						this._graphic.scaleY = this._graphic.scaleX;
					}
					//this._graphic.x = (this._width - this._graphic.width) / 2;
					//this._graphic.y = (this._height - this._graphic.height) / 2;
				}
			}
		}
		
		/**
		 * Sound volume for loaded swf files.
		 */
		public function get volume():Number {
			return (this._soundTransform.volume);
		}
		public function set volume(to:Number):void {
			if (to < 0) to = 0;
			else if (to > 1) to = 1;
			this._soundTransform.volume = to;
			if (this._url != "") {
				try { MovieClip(this._graphic.content).soundTransform = this._soundTransform; } catch (e:Error) { }
			}
			this._container.soundTransform = this._soundTransform;
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
			if (this._url != "") try { MovieClip(this._graphic.content).soundTransform = this._soundTransform; } catch (e:Error) { }
			this._container.soundTransform = this._soundTransform;
		}
		
		/**
		 * Loaded picture display mode: should it be cropped or stretched? Check display mode constants.
		 */
		public function get displayMode():String {
			return (this._displayMode);
		}
		public function set displayMode(to:String):void {
			if (to == GraphicSprite.DISPLAY_CROP) this._displayMode = to;
				else this._displayMode = GraphicSprite.DISPLAY_STRETCH;
			this.width = this._width;
			this.height = this._height;
		}
		
		/**
		 * Should bitmaps be smoothed on resize?
		 */
		public function get smoothing():Boolean {
			return (this._smoothing);
		}
		public function set smoothing(to:Boolean):void {
			this._smoothing = to;
			try { if (this._graphic.content is Bitmap) Bitmap(this._graphic.content).smoothing = this._smoothing; } catch (e:Error) { }
			for (var index:uint = 0; index < this._container.numChildren; index++) {
				if (this._container.getChildAt[index] is Bitmap) Bitmap(this._container.getChildAt[index]).smoothing = this._smoothing;
			}
		}
		
		// READ-ONLY VALUES
		
		/**
		 * The media playback state (for compatibility).
		 * @see	art.ciclope.util.MediaDefinitions
		 */
		public function get mediaState():String {
			return (MediaDefinitions.PLAYBACKSTATE_NOTSTREAM);
		}
		
		/**
		 * The original width of the loaded file (will return the set width if nothing is loaded).
		 */
		public function get originalWidth():Number {
			var ret:Number = this._width;
			if ((this._url != "") && (this._url != "display")) {
				try {
					ret = this._graphic.contentLoaderInfo.width;
				} catch (e:Error) {
					ret = this._width;
				}
			}
			return (ret);
		}
		
		/**
		 * The original height of the loaded file (will return the set height if nothing is loaded).
		 */
		public function get originalHeight():Number {
			var ret:Number = this._height;
			if ((this._url != "") && (this._url != "display")) {
				try {
					ret = this._graphic.contentLoaderInfo.height;
				} catch (e:Error) {
					ret = this._height;
				}
			}
			return (ret);
		}
		
		/**
		 * The current file url.
		 */
		public function get currentFile():String {
			return (this._url);
		}
		
		/**
		 * The graphic loader reference.
		 */
		public function get loader():Loader {
			return (this._graphic);
		}
		
		/**
		 * If the content is a bitmap, the loaded BitmapData.
		 */
		public function get bitmapData():BitmapData {
			var bData:BitmapData;
			if (this._graphic != null) {
				if (this._graphic.content != null) {
					if (this._graphic.content is Bitmap) bData = Bitmap(this._graphic.content).bitmapData;
				}
			}
			return (bData);
		}
		
		
		// PUBLIC METHODS
		
		/**
		 * Start loading a picture or a swf movie.
		 * @param	url	The path to the file.
		 */
		public function load(url:String):void {
			if (this._loading == true) {
				// waint for the end of current dowload
			} else {
				// start download
				this._loading = true;
				this._url = url;
				// is swf?
				if (url.substr( -3) == "swf") {
					this._graphic.load(new URLRequest(url), new LoaderContext(false, ApplicationDomain.currentDomain, null));
				} else {
					this._graphic.load(new URLRequest(url));
				}
			}
		}
		
		/**
		 * Set this sprite content to an already loaded display object.
		 * @param	to	The display object to show.
		 */
		public function setContent(to:DisplayObject):void {
			// remove any previous content
			while (this._container.numChildren > 0) {
				var old:DisplayObject = this._container.getChildAt(0);
				if (old is Bitmap) Bitmap(old).bitmapData.dispose();
				this._container.removeChildAt(0);
			}
			// hide loaded file and show internal one
			this._graphic.visible = false;
			this._container.visible = true;
			// add display and adjust it
			this._url = "display";
			this._container.addChild(to);
			this._container.width = this._width;
			this._container.height = this._height;
			for (var index:uint = 0; index < this._container.numChildren; index++) {
				// smoothing
				try { if (this._container.getChildAt[index] is Bitmap) Bitmap(this._container.getChildAt[index]).smoothing = this._smoothing; } catch (e:Error) { }
				// sound
				try { MovieClip(this._container.getChildAt[index]).soundTransform = this._soundTransform; } catch (e:Error) { }
			}
		}
		
		/**
		 * Unload the current graphic file.
		 */
		public function close():void {
			if (this._url != "") {
				this._graphic.unload();
				while (this._container.numChildren > 0) {
					var ingraphic:DisplayObject = this._container.getChildAt(0);
					this._container.removeChild(ingraphic);
					if (ingraphic is Bitmap) Bitmap(ingraphic).bitmapData.dispose();
					ingraphic = null;
				}
				this._url = "";
			}
		}
		
		/**
		 * Set the sprite dimensions back to original loaded content values.
		 */
		public function toOriginalSize():void {
			this.width = this.originalWidth;
			this.height = this.originalHeight;
		}
		
		/**
		 * Play: does nothig. Set only to be compatible with the other sprite classes.
		 * @param time	time position to play (-1 for current)
		 */
		public function play(time:int = -1):void {
			// do nothing: only for compatibility.
		}
		
		/**
		 * Pause: does nothig. Set only to be compatible with the other sprite classes.
		 */
		public function pause():void {
			// do nothing: only for compatibility.
		}
		
		/**
		 * Stop: does nothig. Set only to be compatible with the other sprite classes.
		 */
		public function stop():void {
			// do nothing: only for compatibility.
		}
		
		/**
		 * Seek: does nothig. Set only to be compatible with the other sprite classes.
		 * @param	to	anything
		 */
		public function seek(to:*):void {
			// do nothing: only for compatibility.
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			// clear all listeners
			this._graphic.contentLoaderInfo.removeEventListener(Event.INIT, onInit);
			this._graphic.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
			this._graphic.contentLoaderInfo.removeEventListener(Event.UNLOAD, onUnload);
			this._graphic.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
			this._graphic.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			// unload any graphic loaded
			this.close();
			// remove graphic layers
			this.removeChild(this._container);
			this._container = null;
			this.removeChild(this._graphic);
			this._graphic = null;
			// kill other variables
			this._url = null;
			this._soundTransform = null;
		}
		
		// PRIVATE METHODS
		
		/**
		 * Downloaded image ready.
		 */
		private function onInit(evt:Event):void {
			// remove any previous content
			while (this._container.numChildren > 0) {
				var old:DisplayObject = this._container.getChildAt(0);
				if (old is Bitmap) Bitmap(old).bitmapData.dispose();
				this._container.removeChildAt(0);
			}
			// hide loaded file and show internal one
			this._graphic.visible = true;
			this._container.visible = false;
			// set the downloaded movie size
			if (this._loadOriginalSize) {
				this.toOriginalSize();
			} else {
				this._graphic.width = this._width;
				this._graphic.height = this._height;
			}
			this._loading = false;
			// smoothing
			if (this._graphic.content is Bitmap) Bitmap(this._graphic.content).smoothing = this._smoothing;
			// sound
			try { MovieClip(this._graphic.content).soundTransform = this._soundTransform; } catch (e:Error) { }
			// warn about file download
			this.dispatchEvent(new Loading(Loading.FINISHED, this._graphic, this._url, LoadedFile.typeOf(this._url)));
		}
		
		/**
		 * HttpStatus
		 */
		private function onHttpStatus(evt:HTTPStatusEvent):void {
			// warn listeners
			this.dispatchEvent(new Loading(Loading.HTTP_STATUS, this._graphic, this._url, LoadedFile.typeOf(this._url)));
		}
		
		/**
		 * File uloaded.
		 */
		private function onUnload(evt:Event):void {
			// warn about file download
			this.dispatchEvent(new Loading(Loading.UNLOAD, this._graphic, this._url, LoadedFile.typeOf(this._url)));
		}
		
		/**
		 * File not fount.
		 */
		private function onIoError(evt:IOErrorEvent):void {
			// warn listeners
			this._loading = false;
			this.dispatchEvent(new Loading(Loading.ERROR_IO, this._graphic, this._url, LoadedFile.typeOf(this._url)));
		}
		
		/**
		 * File download progress.
		 */
		private function onProgress(evt:ProgressEvent):void {
			// warn listeners
			this.dispatchEvent(new Loading(Loading.PROGRESS, this._graphic, this._url, LoadedFile.typeOf(this._url), evt.bytesLoaded, evt.bytesTotal));
		}
		
	}

}
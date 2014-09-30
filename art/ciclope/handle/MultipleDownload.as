package art.ciclope.handle {
	
	// FLASH PACKAGES
	import art.ciclope.event.Loading;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.LoaderContext;
	
	// CICLOPE PACKAGES
	import art.ciclope.util.LoadedFile;
	
	// EVENTS
	
	/**
     * Download finished.
     */
    [Event( name = "FINISHED", type = "art.ciclope.event.Loading" )]
	/**
     * Download IO error.
     */
    [Event( name = "ERROR_IO", type = "art.ciclope.event.Loading" )]
	/**
     * Download progress.
     */
    [Event( name = "PROGRESS", type = "art.ciclope.event.Loading" )]
	/**
     * Download security error.
     */
    [Event( name = "ERROR_SECURITY", type = "art.ciclope.event.Loading" )]
	/**
     * Download HTTP status.
     */
    [Event( name = "HTTP_STATUS", type = "art.ciclope.event.Loading" )]
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * MultipleDownload provides a queue for serial downloads of graphical and text files. All files add are put in a row, wainting for the previous one to complete before its download starts.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class MultipleDownload extends EventDispatcher {
		
		// VARIABLES
		
		/**
		 * The download queue.
		 */
		private var _queue:Array;
		/**
		 * Information about current download.
		 */
		private var _current:Object;
		/**
		 * A loader for picture and flash files.
		 */
		private var _picture:Loader;
		/**
		 * A loader for text.
		 */
		private var _text:URLLoader;
		/**
		 * Total number of bytes of current file.
		 */
		private var _total:Number;
		/**
		 * Number of bytes already downloaded.
		 */
		private var _bytes:Number;
		/**
		 * Loader context for policy file.
		 */
		private var _context:LoaderContext;
		
		/**
		 * MultipleDownload constructor.
		 */
		public function MultipleDownload() {
			// preparing
			this._queue = new Array();
			this._current = new Object();
			this.clearCurrent();
			this._total = 0;
			this._bytes = 0;
			// loader for picture/swf
			this._context = new LoaderContext(true);
			this._picture = new Loader();
			this._picture.contentLoaderInfo.addEventListener(Event.INIT, onInit);
			this._picture.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
			this._picture.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			this._picture.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			// loader for text
			this._text = new URLLoader();
			this._text.addEventListener(Event.COMPLETE, onTXComplete);
			this._text.addEventListener(HTTPStatusEvent.HTTP_STATUS, onTXHttpStatus);
			this._text.addEventListener(IOErrorEvent.IO_ERROR, onTXIOError);
			this._text.addEventListener(ProgressEvent.PROGRESS, onTXProgress);
			this._text.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onTXSecurityError);
		}
		
		// READ-ONLY VALUES
		
		/**
		 * The url of the current download.
		 */
		public function get currentURL():String {
			return (this._current.url);
		}
		
		/**
		 * The identifier of the current download.
		 */
		public function get currentName():String {
			return (this._current.name);
		}
		
		/**
		 * The total number of bytes of the current download.
		 */
		public function get totalBytes():Number {
			return (this._total);
		}
		
		/**
		 * The number of bytes already downloaded.
		 */
		public function get currentBytes():Number {
			return (this._bytes);
		}
		
		/**
		 * Amount of file downloaded (0 to 100%).
		 */
		public function get downloaded():uint {
			if (this._total == 0) {
				return (0);
			} else {
				return (uint(Math.round((100 * this._bytes) / this._total)));
			}
		}
		
		// PUBLIC METHODS
		
		/**
		 * Add a new file to the download queue.
		 * @param	url	The path to the file.
		 * @param	name	The download identifier.
		 * @param	action	A function to call when download ends. Must receive four parameters: 1, dowload name, 2, the file data (Loader for picture, String for text), 3, download comment (see LoadedFile comment constants), 4, download status (to check for errors).
		 * @param	variables	Url-formatted variables for script (text) requests.
		 * @param	method	Request method for text files (POST or GET).
		 * @return	True if the file is of a compatible type (picture, flash or text) and was add to the download queue. False otherwise.
		 * @see	art.ciclope.util.LoadedFile
		 */
		public function addFile(url:String, name:String, action:Function, variables:URLVariables = null, method:String = "POST"):Boolean {
			// prepare download
			if ((LoadedFile.typeOf(url) == LoadedFile.TYPE_FLASH) || (LoadedFile.typeOf(url) == LoadedFile.TYPE_PICTURE) || (LoadedFile.typeOf(url) == LoadedFile.TYPE_TEXT)) {
				var down:Object = new Object();
				down.url = url;
				down.name = name;
				down.action = action;
				down.variables = variables;
				down.method = method;
				down.comment = LoadedFile.COMMENT_SINGLE;
				this._queue.push(down);
				// check for downloading
				this.checkDownload();
				// file add to download queue
				return (true);
			} else {
				// file is not of a compatible type
				return (false);
			}
		}
		
		/**
		 * Add a list of files to the download queue.
		 * @param	urls	An array containing the urls (Strings).
		 * @param	name	The download identifier.
		 * @param	action	A function to call when download ends. Must receive four parameters: 1, dowload name, 2, the file data (Loader for picture, String for text), 3, download comment (see LoadedFile comment constants), 4, download status (to check for errors).
		 * @param	variables	Url-formatted variables for script (text) requests.
		 * @param	method	Request method for text files (POST or GET).
		 * @see	art.ciclope.util.LoadedFile
		 */
		public function addList(urls:Array, name:String, action:Function, variables:URLVariables = null, method:String = "POST"):void {
			for (var index:uint = 0; index < urls.length; index++) {
				// check file position in url array
				var comment:String = LoadedFile.COMMENT_MIDDLE;
				if (index == 0) comment = LoadedFile.COMMENT_FIRST;
				else if (index == (urls.length - 1)) comment = LoadedFile.COMMENT_LAST;
				// ading the file
				this.addFile(urls[index], name, action, variables, method);
			}
		}
		
		/**
		 * Realease memory used by the object.
		 */
		public function kill():void {
			// removing events
			this._picture.contentLoaderInfo.removeEventListener(Event.INIT, onInit);
			this._picture.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
			this._picture.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			this._picture.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			this._text.removeEventListener(Event.COMPLETE, onTXComplete);
			this._text.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onTXHttpStatus);
			this._text.removeEventListener(IOErrorEvent.IO_ERROR, onTXIOError);
			this._text.removeEventListener(ProgressEvent.PROGRESS, onTXProgress);
			this._text.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onTXSecurityError);
			// clearing arrays
			while (this._queue.length > 0) this._queue.shift();
			// killing variables
			this._queue = null;
			this._current = null;
			this._picture = null;
			this._text = null;
			this._context = null;
		}
		
		// PRIVATE METHODS
		
		/**
		 * Clear information about current download.
		 */
		private function clearCurrent():void {
			this._current.downloading = false;
			this._current.url = "";
			this._current.name = "";
			this._current.action = null;
			this._current.variables = null;
			this._current.method = "POST";
			this._current.comment = "";
		}
		
		/**
		 * Check the queue for a new download and starts it.
		 */
		private function checkDownload():void {
			if (!this._current.downloading) {
				if (this._queue.length > 0) {
					// setting current download
					this._current.downloading = true;
					this._current.url = this._queue[0].url;
					this._current.name = this._queue[0].name;
					this._current.action = this._queue[0].action;
					this._current.variables = this._queue[0].variables;
					this._current.method = this._queue[0].method;
					this._current.comment = this._queue[0].comment;
					// removing download from the queue
					this._queue.shift();
					// start downloading
					if (LoadedFile.typeOf(this._current.url) == LoadedFile.TYPE_TEXT) {
						var req:URLRequest = new URLRequest(this._current.url);
						req.method = this._current.method;
						if (this._current.variables) req.data = this._current.variables;
						this._text.load(req);
					} else {
						this._picture.load(new URLRequest(this._current.url), this._context);
					}
				} else {
					// all current downloads finished
					this.dispatchEvent(new Loading(Loading.QUEUE_END));
				}
			}
		}
		
		/**
		 * Clear the picture loader and prepares ir for the next download.
		 */
		private function clearPictureLoader():void {
			// remove listeners
			this._picture.contentLoaderInfo.removeEventListener(Event.INIT, onInit);
			this._picture.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
			this._picture.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			this._picture.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			// create a new loader
			this._picture = new Loader();
			this._picture.contentLoaderInfo.addEventListener(Event.INIT, onInit);
			this._picture.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
			this._picture.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			this._picture.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
		}
		
		/**
		 * A picture or flash file download is complete.
		 */
		private function onInit(evt:Event):void {
			// warn requester
			this._current.action(this._current.name, this._picture, this._current.comment, Loading.FINISHED);
			// warn listeners about download end[
			this.dispatchEvent(new Loading(Loading.FINISHED, this._picture, this._current.url, LoadedFile.typeOf(this._current.url)));
			// clear picture loader
			this.clearPictureLoader();
			// clear current file
			this.clearCurrent();
			// check for next file in queue
			this.checkDownload();
		}
		
		/**
		 * Http status on picture download.
		 */
		private function onHttpStatus(evt:HTTPStatusEvent):void {
			// warn listeners about download http status
			this.dispatchEvent(new Loading(Loading.HTTP_STATUS, this._picture, this._current.url, LoadedFile.typeOf(this._current.url)));
		}
		
		/**
		 * IO error on picture download.
		 */
		private function onIOError(evt:IOErrorEvent):void {
			// warn requester
			this._current.action(this._current.name, null, this._current.comment, Loading.ERROR_IO);
			// warn listeners about download error
			this.dispatchEvent(new Loading(Loading.ERROR_IO, this._picture, this._current.url, LoadedFile.typeOf(this._current.url)));
			// clear picture loader
			this.clearPictureLoader();
			// clear current file
			this.clearCurrent();
			// check for next file in queue
			this.checkDownload();
		}
		
		/**
		 * Download progress for picture files.
		 */
		private function onProgress(evt:ProgressEvent):void {
			// warn listeners about download progress
			this.dispatchEvent(new Loading(Loading.PROGRESS, this._picture, this._current.url, LoadedFile.typeOf(this._current.url), evt.bytesLoaded, evt.bytesTotal));
			// update values
			this._total = evt.bytesTotal;
			this._bytes = evt.bytesLoaded;
		}
		
		/**
		 * A text file download is complete.
		 */
		private function onTXComplete(evt:Event):void {
			// warn requester
			this._current.action(this._current.name, new String(this._text.data), this._current.comment, Loading.FINISHED);
			// warn listeners about download end
			this.dispatchEvent(new Loading(Loading.FINISHED, new String(this._text.data), this._current.url, LoadedFile.TYPE_TEXT));
			// clear current file
			this.clearCurrent();
			// check for next file in queue
			this.checkDownload();
		}
		
		/**
		 * Http status on text download.
		 */
		private function onTXHttpStatus(evt:HTTPStatusEvent):void {
			// warn listeners about download http status
			this.dispatchEvent(new Loading(Loading.HTTP_STATUS, this._text.data, this._current.url, LoadedFile.TYPE_TEXT));
		}
		
		/**
		 * IO error on text download.
		 */
		private function onTXIOError(evt:IOErrorEvent):void {
			// warn requester
			this._current.action(this._current.name, null, this._current.comment, Loading.ERROR_IO);
			// warn listeners about download error
			this.dispatchEvent(new Loading(Loading.ERROR_IO, this._text.data, this._current.url, LoadedFile.TYPE_TEXT));
			// clear current file
			this.clearCurrent();
			// check for next file in queue
			this.checkDownload();
		}
		
		/**
		 * Download progress for text files.
		 */
		private function onTXProgress(evt:ProgressEvent):void {
			// warn listeners about download progress
			this.dispatchEvent(new Loading(Loading.PROGRESS, this._text.data, this._current.url, LoadedFile.TYPE_TEXT, evt.bytesLoaded, evt.bytesTotal));
			// update values
			this._total = evt.bytesTotal;
			this._bytes = evt.bytesLoaded;
		}
		
		/**
		 * Security error on text download.
		 */
		private function onTXSecurityError(evt:SecurityErrorEvent):void {
			// warn requester
			this._current.action(this._current.name, null, this._current.comment, Loading.ERROR_SECURITY);
			// warn listeners about download error
			this.dispatchEvent(new Loading(Loading.ERROR_SECURITY, this._text.data, this._current.url, LoadedFile.TYPE_TEXT));
			// clear current file
			this.clearCurrent();
			// check for next file in queue
			this.checkDownload();
		}
	}

}
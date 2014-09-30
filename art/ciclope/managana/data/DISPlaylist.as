package art.ciclope.managana.data {
	
	// FLASH PACKAGES
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.net.URLVariables;
	
	// CICLOPE CLASSES
	import art.ciclope.event.Loading;
	import art.ciclope.event.DISLoad;
	import art.ciclope.util.LoadedFile;
	import art.ciclope.util.ObjectState;
	
	// EVENTS
	
	/**
     * Data download finished.
     */
    [Event( name = "FINISHED", type = "art.ciclope.event.Loading" )]
	/**
     * Error while processing the data downloaded.
     */
    [Event( name = "ERROR_CONTENT", type = "art.ciclope.event.Loading" )]
	/**
     * Data download just started.
     */
    [Event( name = "START", type = "art.ciclope.event.Loading" )]
	/**
     * IO error while loading data.
     */
    [Event( name = "ERROR_IO", type = "art.ciclope.event.Loading" )]
	/**
     * Data download progress.
     */
    [Event( name = "PROGRESS", type = "art.ciclope.event.Loading" )]
	/**
     * Security error while loading data.
     */
    [Event( name = "ERROR_SECURITY", type = "art.ciclope.event.Loading" )]
	/**
     * A playlist data is available.
     */
    [Event( name = "PLAYLIST_OK", type = "art.ciclope.event.DISLoad" )]
	/**
     * A playlist data was not loaded.
     */
    [Event( name = "PLAYLIST_ERROR", type = "art.ciclope.event.DISLoad" )]
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * DISPlaylist provides methods for handling dis playlists.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class DISPlaylist extends EventDispatcher {
		
		// VARIABLES
		
		private var _id:String;				// the playlist identifier
		private var _state:String;			// playlist data state
		private var _path:String;			// path to the DIS folder
		private var _title:String;			// playlist title
		private var _about:String;			// about the playlist
		private var _author:AuthorData;		// information about playlist author
		private var _elements:Array;		// information about playlist elements
		private var _order:Array;			// element order
		
		/**
		 * DISPlaylist constructor.
		 * @param	id	the playlist id
		 * @param	path	the playlist file url
		 * @param	data	if already downloaded, the playlist xml in String format (will not consider the path if provided)
		 */
		public function DISPlaylist(id:String, path:String, data:String = null) {
			// get data
			this._id = id;
			this._path = path;
			this._state = ObjectState.STATE_NOTREADY;
			this._elements = new Array();
			this._order = new Array();
			// data already sent?
			if (data != null) {
				var loadok:Boolean = true;
				try {
					loadok = this.parse(new XML(data));
				} catch (e:Error) {
					loadok = false;
				}
				if (loadok) {
					// file correctly loaded
					this._state = ObjectState.STATE_LOADOK;
					this.dispatchEvent(new Loading(Loading.FINISHED, this, this.fullpath, LoadedFile.TYPE_XML));
					this.dispatchEvent(new DISLoad(DISLoad.PLAYLIST_OK, this));
				} else {
					// loaded file does not meet stream file standards
					this._state = ObjectState.STATE_LOADERROR;
					this.dispatchEvent(new Loading(Loading.ERROR_CONTENT, this, this.fullpath, LoadedFile.TYPE_XML));
					this.dispatchEvent(new DISLoad(DISLoad.PLAYLIST_ERROR, this));
				}
			} else {
				// prepare data loader
				var loader:URLLoader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, onLoaderComplete);
				loader.addEventListener(Event.OPEN, onLoaderOpen);
				loader.addEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError);
				loader.addEventListener(ProgressEvent.PROGRESS, onLoaderProgress);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoaderSecurityError);
				// load playlist data
				var request:URLRequest = new URLRequest(this.fullpath);
				request.method = "GET";
				if (this.fullpath.substr(0, 4) != "file") request.data = new URLVariables("nocache=" + new Date().getTime());
				loader.load(request);				
			}
		}
		
		// READ-ONLY VALUES
		
		/**
		 * The object state.
		 */
		public function get state():String {
			return (this._state);
		}
		
		/**
		 * The playlist identifier.
		 */
		public function get id():String {
			return (this._id);
		}
		
		/**
		 * The playlist title.
		 */
		public function get title():String {
			return (this._title);
		}
		
		/**
		 * About the playlist.
		 */
		public function get about():String {
			return (this._about);
		}
		
		/**
		 * Information about playlist author.
		 */
		public function get author():AuthorData {
			return (this._author);
		}
		
		/**
		 * Full path to playlist file.
		 */
		public function get fullpath():String {
			return (this._path + "playlist/" + this._id + ".xml");
		}
		
		/**
		 * The playlist number of elements.
		 */
		public function get length():uint {
			return (this._order.length);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Get an element reference.
		 * @param	id	the identifier of the element to get
		 */
		public function getElement(id:String):DISElement {
			if (this._elements != null) {
				return (this._elements[id]);
			} else {
				return (null);
			}
		}
		
		/**
		 * Get the identifier of element at desired pomanaganan in elements sequence.
		 * @param	num	the element pomanaganan in sequence
		 * @return	the element identifier
		 */
		public function getElementID(num:uint):String {
			return (this._order[num]);
		}
		
		/**
		 * Get the identifier of the next element on the playlist.
		 * @param	of	the identifier of the element to check for next
		 */
		public function getNextElement(of:String):String {
			var num:uint = this._elements[of].order + 1;
			if (num >= this.length) num = 0;
			return (this._order[num]);
		}
		
		/**
		 * Get the identifier of the previous element on the playlist.
		 * @param	of	the identifier of the element to check for previous
		 */
		public function getPreviousElement(of:String):String {
			var num:int = this._elements[of].order - 1;
			if (num < 0) num = this.length - 1;
			return (this._order[num]);
		}
		
		/**
		 * Release memory used by this object.
		 */
		public function kill():void {
			this._id = null;
			this._title = null;
			this._path = null;
			this._state = null;
			this._about = null;
			if (this._author != null) this._author.kill();
			this._author = null;
			for (var istr:String in this._elements) {
				this._elements[istr].kill();
				delete(this._elements[istr]);
			}
			this._elements = null;
			while (this._order.length > 0) this._order.shift();
			this._order = null;
		}
		
		// PRIVATE METHODS
		
		/**
		 * Remove all listeners set to data loader.
		 */
		private function clearListeners(loader:URLLoader):void {
			loader.removeEventListener(Event.COMPLETE, onLoaderComplete);
			loader.removeEventListener(Event.OPEN, onLoaderOpen);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError);
			loader.removeEventListener(ProgressEvent.PROGRESS, onLoaderProgress);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoaderSecurityError);
		}
		
		/**
		 * Data load finished successfully.
		 */
		private function onLoaderComplete(evt:Event):void {
			var loadok:Boolean = true;
			// is loaded file a valid xml? parse it into playlist data.
			try {
				loadok = this.parse(new XML(URLLoader(evt.target).data));
			} catch (e:Error) {
				loadok = false;
			}
			// warn listeners
			this.clearListeners(URLLoader(evt.target));
			if (loadok) {
				// file correctly loaded
				this._state = ObjectState.STATE_LOADOK;
				this.dispatchEvent(new Loading(Loading.FINISHED, this, this.fullpath, LoadedFile.TYPE_XML));
				this.dispatchEvent(new DISLoad(DISLoad.PLAYLIST_OK, this));
			} else {
				// loaded file does not meet stream file standards
				this._state = ObjectState.STATE_LOADERROR;
				this.dispatchEvent(new Loading(Loading.ERROR_CONTENT, this, this.fullpath, LoadedFile.TYPE_XML));
				this.dispatchEvent(new DISLoad(DISLoad.PLAYLIST_ERROR, this));
			}
		}
		
		/**
		 * Parse playlist xml data.
		 * @param	newxml	xml data about the playlist
		 * @return	True if the xml is a valid playlist data.
		 */
		private function parse(newxml:XML):Boolean {
			var loadok:Boolean = true;
			if ((newxml.child("id").length() == 0) || (newxml.child("meta").length() == 0) || (newxml.child("elements").length() == 0)) {
				loadok = false;
			} else {
				// meta data
				this._id = String(newxml.id[0]);
				this._title = String(newxml.meta[0].title[0]);
				this._about = String(newxml.meta[0].about[0]);
				this._author = new AuthorData(String(newxml.meta[0].author[0]), String(newxml.meta[0].author[0].@id));
				// element sequence
				for (var index:uint = 0; index < newxml.elements[0].child("element").length(); index++) {
					if (newxml.elements[0].element[index].hasOwnProperty('@id') && newxml.elements[0].element[index].hasOwnProperty('@type') && newxml.elements[0].element[index].hasOwnProperty('@time')) {
						this._elements[String(newxml.elements[0].element[index].@id)] = new DISElement(index, String(newxml.elements[0].element[index].@id), String(newxml.elements[0].element[index].@type), String(newxml.elements[0].element[index].@end), uint(newxml.elements[0].element[index].@time), this._path);
						this._order[index] = String(newxml.elements[0].element[index].@id);
						this._elements[String(newxml.elements[0].element[index].@id)].setData(newxml.elements[0].element[index]);
					}
				}
			}
			System.disposeXML(newxml);
			return (loadok);
		}
		
		/**
		 * Data load just begun.
		 */
		private function onLoaderOpen(evt:Event):void {
			this._state = ObjectState.STATE_LOADING;
			this.dispatchEvent(new Loading(Loading.START, this, this.fullpath, LoadedFile.TYPE_XML));
		}
		
		/**
		 * IO error while loading data.
		 */
		private function onLoaderIOError(evt:IOErrorEvent):void {
			this._state = ObjectState.STATE_LOADERROR;
			this.clearListeners(URLLoader(evt.target));
			this.dispatchEvent(new Loading(Loading.ERROR_IO, this, this.fullpath, LoadedFile.TYPE_XML));
			this.dispatchEvent(new DISLoad(DISLoad.PLAYLIST_ERROR, this));
		}
		
		/**
		 * Data download progress.
		 */
		private function onLoaderProgress(evt:ProgressEvent):void {
			this.dispatchEvent(new Loading(Loading.PROGRESS, this, this.fullpath, LoadedFile.TYPE_XML, evt.bytesLoaded, evt.bytesTotal));
		}
		
		/**
		 * Security error while loading data.
		 */
		private function onLoaderSecurityError(evt:SecurityErrorEvent):void {
			this._state = ObjectState.STATE_LOADERROR;
			this.clearListeners(URLLoader(evt.target));
			this.dispatchEvent(new Loading(Loading.ERROR_SECURITY, this, this.fullpath, LoadedFile.TYPE_XML));
			this.dispatchEvent(new DISLoad(DISLoad.PLAYLIST_ERROR, this));
		}
		
	}

}
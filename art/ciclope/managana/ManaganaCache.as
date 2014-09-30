package art.ciclope.managana {
	
	// FLASH PACKAGES
	import flash.events.EventDispatcher;
	import flash.system.System;
	
	// CICLOPE CLASSES
	import art.ciclope.managana.data.DISCommunity;
	import art.ciclope.data.TextCache;
	import art.ciclope.event.Loading;
	
	// EVENTS
	
	/**
     * All files on cache queue were downloaded.
     */
    [Event( name = "QUEUE_END", type = "art.ciclope.event.Loading" )]
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * ManaganaCache is capable of holding text cache information for dis folder streams and playlists.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class ManaganaCache extends EventDispatcher {
		
		// VARIABLES
		
		private var _folder:String;				// cache folder path
		private var _cached:Array;				// list of cached items
		private var _streamQueue:Array;			// stream file load queue
		private var _playlistQueue:Array;		// playlist file load queue
		private var _loadingStream:Boolean;		// is cache loading a stream?
		private var _loadingPlaylist:Boolean;	// is cache loading a playlist?
		
		// PUBLIC VARIABLES
		
		/**
		 * Community reference.
		 */
		public var community:DISCommunity;
		
		/**
		 * ManaganaCache constructor.
		 */
		public function ManaganaCache() {
			this._streamQueue = new Array();
			this._playlistQueue = new Array();
			this._loadingStream = false;
			this._loadingPlaylist = false;
			this._cached = new Array();
			this._cached["picture"] = new Array();
			this._cached["video"] = new Array();
			this._cached["audio"] = new Array();
			this._cached["other"] = new Array();
			this._cached["stream"] = new Array();
		}
		
		/**
		 * Set a cache folder for current DIS.
		 * @param	folder	the cache folder path
		 * @param	files	a xml-formatted string with information about the files found at the cache folder
		 */
		public function setCache(folder:String, files:String = null):void {
			this.clear();
			this._folder = folder;
			if (files != null) {
				try {
					var data:XML = new XML(files);
					var index:uint;
					for (index = 0; index < data.child("picture").length(); index++) {
						this.addPicture(String(data.picture[index]));
					}
					System.disposeXML(data);
				} catch (e:Error) { }
			}
		}
		
		/**
		 * The current DIS cache folder path.
		 */
		public function get folder():String {
			return (this._folder);
		}
		
		/**
		 * Clear current cache.
		 */
		public function clear():void {
			var index:String;
			while (this._cached["audio"].length > 0) this._cached["audio"].shift();
			while (this._cached["picture"].length > 0) this._cached["picture"].shift();
			while (this._cached["video"].length > 0) this._cached["video"].shift();
			while (this._cached["other"].length > 0) this._cached["other"].shift();
			for (index in this._cached["stream"]) {
				this._cached["stream"][index].kill();
				delete(this._cached["stream"][index]);
			}
			this._folder = null;
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			this.clear();
			this._folder = null;
			this.community = null;
			for (var index:String in this._cached) {
				delete (this._cached[index]);
			}
			this._cached = null;
			while (this._streamQueue.length > 0) this._streamQueue.shift();
			this._streamQueue = null;
			while (this._playlistQueue.length > 0) this._playlistQueue.shift();
			this._playlistQueue = null;
		}
		
		/**
		 * Add a picture file to the cache.
		 * @param	file	a picture file name found at the cache folder
		 */
		public function addPicture(file:String):void {
			this._cached["picture"].push(file);
		}
		
		/**
		 * Add an audio file to the cache.
		 * @param	file	an audio file name found at the cache folder
		 */
		public function addAudio(file:String):void {
			this._cached["audio"].push(file);
		}
		
		/**
		 * Add a video file to the cache.
		 * @param	file	a video file name found at the cache folder
		 */
		public function addVideo(file:String):void {
			this._cached["video"].push(file);
		}
		
		/**
		 * Add a file of "other" type to the cache.
		 * @param	file	a file name found at the "other" cache folder
		 */
		public function addOther(file:String):void {
			this._cached["other"].push(file);
		}
		
		/**
		 * Add a stream to the cache.
		 * @param	id	the stream ID to cache
		 * @param	fromCacheFolder	download the stream before adding it to the cache (false) or load it directly from the cache folder (true)?
		 * @param	text	provided text (leave null or empty string to download from community folder or local cache)
		 */
		public function addStream(id:String, fromCacheFolder:Boolean = false, text:String = ""):void {
			if ((text == null) || (text == "")) {
				if (!fromCacheFolder) {
					this._streamQueue.push(new Array(id, (this.community.url + "stream/" + id + ".xml")));
				} else {
					this._streamQueue.push(new Array(id, (this._folder + "stream/" + id + ".xml")));
				}
				if (!this._loadingStream) {
					var textCache:TextCache = new TextCache(this._streamQueue[0][1]);
					textCache.addEventListener(Loading.ERROR, onStreamLoadError);
					textCache.addEventListener(Loading.FINISHED, onStreamLoadOK);
					this._loadingStream = true;
				}
			} else {
				if (this._cached["stream"][id] != null) {
					this._cached["stream"][id].kill();
					delete(this._cached["stream"][id]);
				}
				this._cached["stream"][id] = new TextCache("", "", "post", id, text);
			}
		}
		
		/**
		 * Add a playlist to the cache.
		 * @param	id	the playlist ID to cache
		 * @param	fromCacheFolder	download the playlist before adding it to the cache (false) or load it directly from the cache folder (true)?
		 */
		public function addPlaylist(id:String, fromCacheFolder:Boolean = false, text:String = ""):void {
			if ((text == null) || (text == "")) {
				if (!this.community.isValidPlaylist(id)) {
					if (!fromCacheFolder) {
						this._playlistQueue.push(new Array(id, (this.community.url + "playlist/" + id + ".xml")));
					} else {
						this._playlistQueue.push(new Array(id, (this._folder + "playlist/" + id + ".xml")));
					}
					if (!this._loadingPlaylist) {
						var textCache:TextCache = new TextCache(this._playlistQueue[0][1]);
						textCache.addEventListener(Loading.ERROR, onPlaylistLoadError);
						textCache.addEventListener(Loading.FINISHED, onPlaylistLoadOK);
						this._loadingPlaylist = true;
					}
				}
			} else {
				this.community.addPlaylist(id, text);
			}
		}
		
		/**
		 * Is the file available on cache?
		 * @param	type	the file type: stream, picture, audio, video or other
		 * @param	file	the file name
		 * @return	true if the provided file type/name is currently cached
		 */
		public function cached(type:String, file:String):Boolean {
			return (this._cached[type].indexOf(file) >= 0);
		}
		
		/**
		 * Get a cached stream information.
		 * @param	id	the stream ID to check
		 * @return	a xml-formatted stream information if found on cache, null otherwise
		 */
		public function streamCacheData(id:String):String {
			if (this._cached["stream"][id] != null) {
				if (this._cached["stream"][id].ready) {
					return (this._cached["stream"][id].data);
				} else {
					return (null);
				}
			} else {
				return (null);
			}
		}
		
		/**
		 * Stream failed to load.
		 */
		private function onStreamLoadError(evt:Loading):void {
			evt.target.removeEventListener(Loading.ERROR, onStreamLoadError);
			evt.target.removeEventListener(Loading.FINISHED, onStreamLoadOK);
			evt.target.kill();
			this._streamQueue.shift();
			if (this._streamQueue.length > 0) {
				var textCache:TextCache = new TextCache(this._streamQueue[0][1]);
				textCache.addEventListener(Loading.ERROR, onStreamLoadError);
				textCache.addEventListener(Loading.FINISHED, onStreamLoadOK);
				this._loadingStream = true;
			} else {
				this._loadingStream = false;
				this.dispatchEvent(new Loading(Loading.QUEUE_END, this, "stream"));
			}
		}
		
		/**
		 * Stream correctly loaded.
		 */
		private function onStreamLoadOK(evt:Loading):void {
			evt.target.removeEventListener(Loading.ERROR, onStreamLoadError);
			evt.target.removeEventListener(Loading.FINISHED, onStreamLoadOK);
			if (this._cached["stream"][this._streamQueue[0][0]] != null) {
				this._cached["stream"][this._streamQueue[0][0]].kill();
				delete(this._cached["stream"][this._streamQueue[0][0]]);
			}
			this._cached["stream"][this._streamQueue[0][0]] = evt.target;
			this._streamQueue.shift();
			if (this._streamQueue.length > 0) {
				var textCache:TextCache = new TextCache(this._streamQueue[0][1]);
				textCache.addEventListener(Loading.ERROR, onStreamLoadError);
				textCache.addEventListener(Loading.FINISHED, onStreamLoadOK);
				this._loadingStream = true;
			} else {
				this._loadingStream = false;
				this.dispatchEvent(new Loading(Loading.QUEUE_END, this, "stream"));
			}
		}
		
		/**
		 * Playlist failed to load.
		 */
		private function onPlaylistLoadError(evt:Loading):void {
			evt.target.removeEventListener(Loading.ERROR, onPlaylistLoadError);
			evt.target.removeEventListener(Loading.FINISHED, onPlaylistLoadOK);
			evt.target.kill();
			this._playlistQueue.shift();
			if (this._playlistQueue.length > 0) {
				if (this.community.isValidPlaylist(this._playlistQueue[0][0])) {
					this._playlistQueue.shift();
				}
			}
			if (this._playlistQueue.length > 0) {
				var textCache:TextCache = new TextCache(this._playlistQueue[0][1]);
				textCache.addEventListener(Loading.ERROR, onPlaylistLoadError);
				textCache.addEventListener(Loading.FINISHED, onPlaylistLoadOK);
				this._loadingPlaylist = true;
			} else {
				this._loadingPlaylist = false;
				this.dispatchEvent(new Loading(Loading.QUEUE_END, this, "playlist"));
			}
		}
		
		/**
		 * Playlist load ok.
		 */
		private function onPlaylistLoadOK(evt:Loading):void {
			evt.target.removeEventListener(Loading.ERROR, onPlaylistLoadError);
			evt.target.removeEventListener(Loading.FINISHED, onPlaylistLoadOK);
			this.community.addPlaylist(this._playlistQueue[0][0], evt.target.data);
			this._playlistQueue.shift();
			if (this._playlistQueue.length > 0) {
				if (this.community.isValidPlaylist(this._playlistQueue[0][0])) {
					this._playlistQueue.shift();
				}
			}
			if (this._playlistQueue.length > 0) {
				var textCache:TextCache = new TextCache(this._playlistQueue[0][1]);
				textCache.addEventListener(Loading.ERROR, onPlaylistLoadError);
				textCache.addEventListener(Loading.FINISHED, onPlaylistLoadOK);
				this._loadingPlaylist = true;
			} else {
				this._loadingPlaylist = false;
				this.dispatchEvent(new Loading(Loading.QUEUE_END, this, "playlist"));
			}
		}
		
	}

}
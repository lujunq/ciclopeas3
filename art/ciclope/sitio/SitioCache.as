package art.ciclope.sitio {
	
	// FLASH PACKAGES
	import art.ciclope.sitio.data.DISCommunity;
	import flash.events.EventDispatcher;
	import flash.system.System;
	
	// CICLOPE CLASSES
	import art.ciclope.data.TextCache;
	import art.ciclope.event.Loading;
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class SitioCache extends EventDispatcher {
		
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
		
		public function SitioCache() {
			this._streamQueue = new Array();
			this._playlistQueue = new Array();
			this._loadingStream = false;
			this._loadingPlaylist = false;
			this._cached = new Array();
			this._cached["picture"] = new Array();
			this._cached["stream"] = new Array();
		}
		
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
		
		public function get folder():String {
			return (this._folder);
		}
		
		public function clear():void {
			var index:String;
			while (this._cached["picture"].length > 0) this._cached["picture"].shift();
			for (index in this._cached["stream"]) {
				this._cached["stream"][index].kill();
				delete(this._cached["stream"][index]);
			}
			this._folder = null;
		}
		
		public function addPicture(file:String):void {
			this._cached["picture"].push(file);
		}
		
		public function addStream(id:String, fromCacheFolder:Boolean = false):void {
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
		}
		
		public function addPlaylist(id:String, fromCacheFolder:Boolean = false):void {
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
		}
		
		public function cached(type:String, file:String):Boolean {
			return (this._cached[type].indexOf(file) >= 0);
		}
		
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
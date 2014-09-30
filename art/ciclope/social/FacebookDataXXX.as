package art.ciclope.social {
	
	// FLASH PACKAGES
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.System;
	
	// CICLOPE CLASSES
	import art.ciclope.event.Loading;
	import art.ciclope.util.LoadedFile;
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class FacebookData extends EventDispatcher {
		
		// PUBLIC VARIABLES
		
		/**
		 * Facebook user id.
		 */
		public var account:String = "";
		/**
		 * Facebook rss feed url.
		 */
		public var feed:String = "";
		
		// VARIABLES
		
		private var _loader:URLLoader;		// a loader for rss data
		private var _data:Array;			// data received from facebook
		
		public function FacebookData(account:String, feed:String) {
			this.account = account;
			this.feed = feed;
			this._data = new Array();
			// prepare loader
			this._loader = new URLLoader();
			this._loader.addEventListener(Event.COMPLETE, onComplete);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			this._loader.load(new URLRequest(this.feed + "?user=" + this.account));
		}
		
		// READ-ONLY VALUES
		
		/**
		 * An array of SocialPost objects with currently loaded data.
		 */
		public function get data():Array {
			return (this._data);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Refresh post list.
		 */
		public function refresh():void {
			this._loader.load(new URLRequest(this.feed + "?user=" + this.account));
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			this._loader.removeEventListener(Event.COMPLETE, onComplete);
			this._loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			this._loader = null;
			this.clearData();
			this._data = null;
			this.account = null;
		}
		
		// PRIVATE METHODS
		
		/**
		 * Clear data array.
		 */
		private function clearData():void {
			while (this._data.length > 0) {
				this._data[0].kill();
				this._data.shift();
			}
		}
		
		// EVENTS
		
		/**
		 * Facebook data available.
		 */
		private function onComplete(evt:Event):void {
			try {
				var data:XML = new XML(this._loader.data);
				this.clearData();
				for (var index:uint = 0; index < data.channel.child('item').length(); index++) {
					this._data.push(new SocialPost(String(data.channel.item[index].title), String(data.channel.item[index].description), String(data.channel.item[index].link), SocialPost.SOURCE_FACEBOOK, String(data.channel.item[index].pubDate), String(data.channel.item[index].picture)));
				}
				System.disposeXML(data);
				this.dispatchEvent(new Loading(Loading.FINISHED, this, this.account, LoadedFile.TYPE_XML));
			} catch (e:Error) {
				trace ("xml error: " + this._loader.data);
				this.dispatchEvent(new Loading(Loading.ERROR_CONTENT, this, this.account, LoadedFile.TYPE_XML));
			}
		}
		
		/**
		 * Facebook data load error.
		 */
		private function onError(evt:Event):void {
			trace ("access error");
			this.dispatchEvent(evt);
		}
		
	}

}
package art.ciclope.sitio.data {
	
	// FLASH PACKAGES
	import art.ciclope.event.DISLoad;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.net.URLLoader;
	
	// CICLOPE CLASSES
	import art.ciclope.event.Loading;
	import art.ciclope.util.LoadedFile;
	import art.ciclope.util.ObjectState;
	import art.ciclope.staticfunctions.StringFunctions;
	
	// FXG GRAPHICS
	import art.ciclope.resource.QuestionIcon;
	
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
     * The community data is available.
     */
    [Event( name = "COMMUNITY_OK", type = "art.ciclope.event.DISLoad" )]
	/**
     * The community data was not loaded.
     */
    [Event( name = "COMMUNITY_ERROR", type = "art.ciclope.event.DISLoad" )]
	/**
     * A stream data is available.
     */
    [Event( name = "STREAM_OK", type = "art.ciclope.event.DISLoad" )]
	/**
     * A stream data was not loaded.
     */
    [Event( name = "STREAM_ERROR", type = "art.ciclope.event.DISLoad" )]
	/**
     * A playlist data is available.
     */
    [Event( name = "PLAYLIST_OK", type = "art.ciclope.event.DISLoad" )]
	/**
     * A playlist data was not loaded.
     */
    [Event( name = "PLAYLIST_ERROR", type = "art.ciclope.event.DISLoad" )]
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class DISCommunity extends EventDispatcher {
		
		// VARIABLES
		
		private var _url:String;				// the loaded DIS url
		private var _tryurl:String;				// the DIS url loading
		private var _state:String;				// current object state
		private var _loader:URLLoader;			// a loader for xml data
		private var _title:String;				// community title
		private var _copyleft:String;			// community copyleft
		private var _copyright:String;			// community copyright
		private var _excerpt:String;			// community about excerpt
		private var _about:String;				// community about
		private var _iconurl:String;			// community icon url
		private var _icon:Sprite;				// community icon graphic
		private var _language:String;			// community default language
		private var _iconloader:Loader;			// a loader for icon image
		private var _lastupdate:Date;			// date of last update on community
		private var _categories:Array;			// information about categories
		private var _screenwidth:uint;			// screen width
		private var _screenheight:uint;			// screen height
		private var _usehighlight:Boolean;		// use highlight color on links?
		private var _highlight:uint;			// highlight color
		private var _background:uint;			// background color
		private var _alpha:Number;				// background alpha
		private var _home:StreamData;			// home stream
		private var _plugins:Array;				// information about plugins
		private var _fonts:Array;				// information about fonts
		private var _social:Array;				// information about social connections
		private var _mainstream:DISStream;		// the main stream
		private var _upstream:DISStream;		// the upper layer guide stream
		private var _downstream:DISStream;		// the lower layer guide stream
		private var _playlists:Array;			// information about playlists loaded
		
		public function DISCommunity() {
			// prepare variables
			this._state = ObjectState.STATE_CLEAN;
			this._url = "";
			this._tryurl = "";
			this._loader = new URLLoader();
			this._loader.addEventListener(Event.COMPLETE, onLoaderComplete);
			this._loader.addEventListener(Event.OPEN, onLoaderOpen);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError);
			this._loader.addEventListener(ProgressEvent.PROGRESS, onLoaderProgress);
			this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoaderSecurityError);
			this._icon = new Sprite();
			this._lastupdate = new Date();
			this._categories = new Array();
			this._plugins = new Array();
			this._home = new StreamData("", "");
			this._fonts = new Array();
			this._social = new Array();
			this._playlists = new Array();
			this._iconloader = new Loader();
			this._iconloader.contentLoaderInfo.addEventListener(Event.INIT, onIcon);
			this._iconloader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIconError);
			// clear data
			this.clear();
			// prepare streams
			this._mainstream = new DISStream(DISStream.LEVEL_MAIN, this.addPlaylist);
			this._upstream = new DISStream(DISStream.LEVEL_DOWN, this.addPlaylist);
			this._downstream = new DISStream(DISStream.LEVEL_UP, this.addPlaylist);
			this._mainstream.addEventListener(DISLoad.STREAM_OK, onStreamOK);
			this._upstream.addEventListener(DISLoad.STREAM_OK, onStreamOK);
			this._downstream.addEventListener(DISLoad.STREAM_OK, onStreamOK);
			this._mainstream.addEventListener(DISLoad.STREAM_ERROR, onStreamERROR);
			this._upstream.addEventListener(DISLoad.STREAM_ERROR, onStreamERROR);
			this._downstream.addEventListener(DISLoad.STREAM_ERROR, onStreamERROR);
		}
		
		// READ-ONLY VALUES
		
		/**
		 * Cuttently-loaded DIS url.
		 */
		public function get url():String {
			return (this._url);
		}
		
		/**
		 * The community title.
		 */
		public function get title():String {
			return (this._title);
		}
		
		/**
		 * The community copyleft.
		 */
		public function get copyleft():String {
			return (this._copyleft);
		}
		
		/**
		 * The community copyright.
		 */
		public function get copyright():String {
			return (this._copyright);
		}
		
		/**
		 * The community about excerpt.
		 */
		public function get excerpt():String {
			return (this._excerpt);
		}
		
		/**
		 * The community about.
		 */
		public function get about():String {
			return (this._about);
		}
		
		/**
		 * The community icon url.
		 */
		public function get iconurl():String {
			return (this._iconurl);
		}
		
		/**
		 * The community language.
		 */
		public function get language():String {
			return (this._language);
		}
		
		/**
		 * The community icon graphic.
		 */
		public function get icon():Sprite {
			return(this._icon);
		}
		
		/**
		 * Last update date (time = 0 if no date is provided).
		 */
		public function get lastupdate():Date {
			return(this._lastupdate);
		}
		
		/**
		 * The community design screen width.
		 */
		public function get screenwidth():uint {
			return(this._screenwidth);
		}
		
		/**
		 * The community design screen height.
		 */
		public function get screenheight():uint {
			return(this._screenheight);
		}
		
		/**
		 * Use highlight color on links?
		 */
		public function get usehighlight():Boolean {
			return(this._usehighlight);
		}
		
		/**
		 * The link highlight color.
		 */
		public function get highlight():uint {
			return(this._highlight);
		}
		
		/**
		 * The screen background color.
		 */
		public function get bgcolor():uint {
			return(this._background);
		}
		
		/**
		 * The screen background alpha.
		 */
		public function get bgalpha():Number {
			return(this._alpha);
		}
		
		/**
		 * The initial stream data.
		 */
		public function get home():StreamData {
			return (this._home);
		}
		
		
		/**
		 * An array of CategoryData objects with all community categories information.
		 * @see	art.ciclope.sitio.data.CategoryData
		 */
		public function get categories():Array {
			return (this._categories);
		}
		
		/**
		 * An array of PluginData objects with all community plugins information.
		 * @see	art.ciclope.sitio.data.PluginData
		 */
		public function get plugins():Array {
			return (this._plugins);
		}
		
		/**
		 * An array of FontData objects with all community font information.
		 * @see	art.ciclope.sitio.data.FontData
		 */
		public function get fonts():Array {
			return (this._fonts);
		}
		
		/**
		 * An associative array of SocialData objects with connection information. Index values are: recent, view, share, category, search, vote and comment.
		 * @see	art.ciclope.sitio.data.SocialData
		 */
		public function get social():Array {
			return (this._social);
		}
		
		/**
		 * An associative array of DISPlaylist objects with playlist data.
		 * @see	art.ciclope.sitio.data.DISPlaylist
		 */
		public function get playlists():Array {
			return (this._playlists);
		}
		
		
		// PUBLIC METHODS
		
		/**
		 * Load a DIS community.
		 * @param	url	the DIS community url
		 */
		public function load(url:String):void {
			this._state = ObjectState.STATE_LOADING;
			this._tryurl = StringFunctions.slashURL(url);
			this._loader.load(new URLRequest(this._tryurl + "dis.xml"));
		}
		
		/**
		 * Load a stream into mais level.
		 * @param	id	the stream identifier
		 * @param	cache	text cache with stream content
		 * @return	true if the community can load the stream, false otherwise
		 */
		public function loadStream(id:String, cache:String = null):Boolean {
			if (this._state == ObjectState.STATE_LOADOK) {
				if (this._mainstream.id != id) {
					this._mainstream.load(id, cache);
					return (true);
				} else {
					return (false);
				}
			} else {
				return (false);
			}
		}
		
		/**
		 * Add a playlist information.
		 * @param	id	the identifier of the playlist to add information
		 * @param	data	xml string with playlist content (leave null for automatica download)
		 */
		public function addPlaylist(id:String, data:String = null):void {
			if (this._playlists[id] == null) {
				this._playlists[id] = new DISPlaylist(id, this._url, data);
				this._playlists[id].addEventListener(DISLoad.PLAYLIST_OK, onPlaylistOK);
				this._playlists[id].addEventListener(DISLoad.PLAYLIST_ERROR, onPlaylistERROR);
			}
		}
		
		/**
		 * Is the requested playlist id loaded and valid?
		 * @param	id	the playlist id to check
		 * @return	true if the playlist is already loaded and valid
		 */
		public function isValidPlaylist(id:String):Boolean {
			if (this._playlists[id] == null) {
				return (false);
			} else {
				return (this._playlists[id].state == ObjectState.STATE_LOADOK);
			}
		}
		
		/**
		 * Release memory used by object.
		 */
		public function kill():void {
			this._state = null;
			this._url = null;
			this._tryurl = null;
			this._loader.removeEventListener(Event.COMPLETE, onLoaderComplete);
			this._loader.removeEventListener(Event.OPEN, onLoaderOpen);
			this._loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError);
			this._loader.removeEventListener(ProgressEvent.PROGRESS, onLoaderProgress);
			this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoaderSecurityError);
			this._loader = null;
			this._title = null;
			this._copyleft = null;
			this._copyright = null;
			this._excerpt = null;
			this._about = null;
			this._iconurl = null;
			this._language = null;
			this._lastupdate = null;
			this._home.kill();
			this._home = null;
			while (this._icon.numChildren > 0) {
				var iconchild:DisplayObject = this._icon.getChildAt(0);
				this._icon.removeChild(iconchild);
				if (iconchild is Bitmap) Bitmap(iconchild).bitmapData.dispose();
				iconchild = null;
			}
			this._icon = null;
			while (this._categories.length > 0) {
				this._categories[0].kill();
				this._categories.shift();
			}
			this._categories = null;
			while (this._plugins.length > 0) {
				this._plugins[0].kill();
				this._plugins.shift();
			}
			this._plugins = null;
			while (this._fonts.length > 0) {
				this._fonts[0].kill();
				this._fonts.shift();
			}
			this._fonts = null;
			for (var istr:String in this._social) {
				this._social[istr].kill();
				delete(this._social[istr]);
			}
			this._social = null;
			for (istr in this._playlists) {
				this._playlists[istr].kill();
				delete(this._playlists[istr]);
			}
			this._playlists = null;
			this._iconloader.contentLoaderInfo.removeEventListener(Event.INIT, onIcon);
			this._iconloader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIconError);
			this._iconloader.unloadAndStop();
			this._iconloader = null;
		}
		
		// PRIVATE METHODS
		
		/**
		 * Process a DIS community description.
		 * @param	data	a xml-formatted content with the community description
		 * @param	url	the DIS folder url
		 * @return	true if the xml could be correctly loaded, false otherwise
		 */
		private function process(data:XML, url:String):Boolean {
			// prepare return
			var result:Boolean = true;
			var index:uint;
			// check for meta data
			if ((data.child("meta").length() == 0) || (data.child("categories").length() == 0) || (data.child("screen").length() == 0) || (data.child("home").length() == 0) || (data.child("plugins").length() == 0) || (data.child("fonts").length() == 0) || (data.child("social").length() == 0)) {
				// invalid xml data
				result = false;
			} else {
				// clear previoud DIS data
				this.clear();
				// get meta data
				if (data.meta[0].child("title").length() > 0) this._title = String(data.meta[0].title[0]);
				if (data.meta[0].child("copyleft").length() > 0) this._copyleft = String(data.meta[0].copyleft[0]);
				if (data.meta[0].child("copyright").length() > 0) this._copyright = String(data.meta[0].copyright[0]);
				if (data.meta[0].child("excerpt").length() > 0) this._excerpt = String(data.meta[0].excerpt[0]);
				if (data.meta[0].child("about").length() > 0) this._about = String(data.meta[0].about[0]);
				if (data.meta[0].child("icon").length() > 0) this._iconurl = url + "media/community/picture/" + String(data.meta[0].icon[0]);
				if (data.meta[0].child("lang").length() > 0) this._language = String(data.meta[0].lang[0]);
				if (data.meta[0].child("update").length() > 0) {
					var last:Array = String(data.meta[0].update[0]).split("-");
					if (last.length == 3) this._lastupdate.setFullYear(uint(last[0]), (uint(last[1]) - 1), uint(last[2]));
					last = null;
				}
				// load icon?
				if (this._iconurl != "") this._iconloader.load(new URLRequest(this._iconurl));
				// get screen data
				if (data.screen[0].child("width").length() > 0) this._screenwidth = uint(data.screen[0].width[0]);
				if (data.screen[0].child("height").length() > 0) this._screenheight = uint(data.screen[0].height[0]);
				if (data.screen[0].child("highlight").length() > 0) {
					this._highlight = uint(data.screen[0].highlight[0]);
					if (data.screen[0].highlight[0].hasOwnProperty('@active')) this._usehighlight = Boolean(uint(data.screen[0].highlight[0].@active));
				}
				if (data.screen[0].child("background").length() > 0) this._background = uint(data.screen[0].background[0]);
				if (data.screen[0].child("alpha").length() > 0) this._alpha = Number(data.screen[0].alpha[0]);
				// home
				if (data.home[0].child("stream").length() > 0) {
					if (data.home[0].stream[0].hasOwnProperty('@id')) {
						this._home.kill();
						this._home = new StreamData(String(data.home[0].stream[0]), String(data.home[0].stream[0].@id));
					}
				}
				// categories
				for (index = 0; index < data.categories[0].child("category").length(); index++) {
					if (data.categories[0].category[index].hasOwnProperty('@id')) {
						this._categories.push(new CategoryData(String(data.categories[0].category[index]), String(data.categories[0].category[index].@id)));
					}
				}
				// plugins
				for (index = 0; index < data.plugins[0].child("plugin").length(); index++) {
					if ((data.plugins[0].plugin[index].hasOwnProperty('@id')) && (data.plugins[0].plugin[index].hasOwnProperty('@name'))) {
						this._plugins.push(new PluginData(String(data.plugins[0].plugin[index].@name), String(data.plugins[0].plugin[index].@id), String(data.plugins[0].plugin[index])));
					}
				}
				// fonts
				for (index = 0; index < data.fonts[0].child("font").length(); index++) {
					if (data.fonts[0].font[index].hasOwnProperty('@id')) {
						this._fonts.push(new StreamData(String(data.fonts[0].font[index]), String(data.fonts[0].font[index].@id)));
					}
				}
				// social links
				if (data.social[0].child("recent").length() > 0) {
					this._social['recent'].kill();
					this._social['recent'] = new SocialData('recent', String(data.social[0].recent[0]), String(data.social[0].recent[0].@method));
				}
				if (data.social[0].child("view").length() > 0) {
					this._social['view'].kill();
					this._social['view'] = new SocialData('view', String(data.social[0].view[0]), String(data.social[0].view[0].@method));
				}
				if (data.social[0].child("share").length() > 0) {
					this._social['share'].kill();
					this._social['share'] = new SocialData('share', String(data.social[0].share[0]), String(data.social[0].share[0].@method));
				}
				if (data.social[0].child("category").length() > 0) {
					this._social['category'].kill();
					this._social['category'] = new SocialData('category', String(data.social[0].category[0]), String(data.social[0].category[0].@method));
				}
				if (data.social[0].child("search").length() > 0) {
					this._social['search'].kill();
					this._social['search'] = new SocialData('search', String(data.social[0].search[0]), String(data.social[0].search[0].@method));
				}
				if (data.social[0].child("vote").length() > 0) {
					this._social['vote'].kill();
					this._social['vote'] = new SocialData('vote', String(data.social[0].vote[0]), String(data.social[0].vote[0].@method));
				}
				if (data.social[0].child("comment").length() > 0) {
					this._social['comment'].kill();
					this._social['comment'] = new SocialData('comment', String(data.social[0].comment[0]), String(data.social[0].comment[0].@method));
				}
			}
			// resturn result
			return(result);
		}
		
		/**
		 * Clear object data,
		 */
		private function clear():void {
			this._title = "";
			this._copyleft = "";
			this._copyright = "";
			this._excerpt = "";
			this._about = "";
			this._iconurl = "";
			this._language = "";
			this._screenwidth = 1920;
			this._screenheight = 1080;
			this._usehighlight = false;
			this._highlight = 0;
			this._background = 0;
			this._alpha = 1.0;
			this._lastupdate.setTime(0);
			this._home.kill();
			this._home = new StreamData("", "");
			while (this._categories.length > 0) {
				this._categories[0].kill();
				this._categories.shift();
			}
			while (this._plugins.length > 0) {
				this._plugins[0].kill();
				this._plugins.shift();
			}
			while (this._fonts.length > 0) {
				this._fonts[0].kill();
				this._fonts.shift();
			}
			this.clearSocial();
			for (var istr:String in this._playlists) {
				this._playlists[istr].kill();
				delete(this._playlists[istr]);
			}
			while (this._icon.numChildren > 0) {
				var iconchild:DisplayObject = this._icon.getChildAt(0);
				this._icon.removeChild(iconchild);
				if (iconchild is Bitmap) Bitmap(iconchild).bitmapData.dispose();
				iconchild = null;
			}
			this._icon.addChild(new QuestionIcon() as Sprite);
		}
		
		/**
		 * Clear social link information.
		 */
		private function clearSocial():void {
			// clear any previous information
			for (var istr:String in this._social) {
				this._social[istr].kill();
				delete(this._social[istr]);
			}
			// add empty information
			this._social['recent'] = new SocialData('recent', '', '');
			this._social['view'] = new SocialData('view', '', '');
			this._social['share'] = new SocialData('share', '', '');
			this._social['category'] = new SocialData('category', '', '');
			this._social['search'] = new SocialData('search', '', '');
			this._social['vote'] = new SocialData('vote', '', '');
			this._social['comment'] = new SocialData('comment', '', '');
		}
		
		// EVENTS
		
		/**
		 * The icon image was correctly downloaded.
		 */
		private function onIcon(evt:Event):void {
			// replace icon image
			while (this._icon.numChildren > 0) {
				var iconchild:DisplayObject = this._icon.getChildAt(0);
				this._icon.removeChild(iconchild);
				if (iconchild is Bitmap) Bitmap(iconchild).bitmapData.dispose();
				iconchild = null;
			}
			this._icon.addChild(this._iconloader.content);
		}
		
		/**
		 * The icon image could not be loaded.
		 */
		private function onIconError(evt:IOErrorEvent):void {
			// nothing to do, just keep current question mark
		}
		
		/**
		 * Data load finished successfully.
		 */
		private function onLoaderComplete(evt:Event):void {
			var loadok:Boolean = true;
			// is loaded file a valid xml?
			try {
				var newxml:XML = new XML(this._loader.data);
			} catch (e:Error) {
				loadok = false;
			}
			// try to load community data
			if (loadok) {
				if (this.process(newxml, this._tryurl)) {
					// adjust paths
					this._url = this._tryurl;
				} else {
					// load error
					loadok = false;
				}
				System.disposeXML(newxml);
			}
			// warn listeners
			if (loadok) {
				// prepare streams
				this._url = this._tryurl;
				this._mainstream.path = this._url;
				this._upstream.path = this._url;
				this._downstream.path = this._url;
				// warn listeners
				this._state = ObjectState.STATE_LOADOK;
				this.dispatchEvent(new Loading(Loading.FINISHED, this, this._url, LoadedFile.TYPE_XML));
				this.dispatchEvent(new DISLoad(DISLoad.COMMUNITY_OK, this));
			} else {
				// file loaded is not a valid DIS descriptor
				this._state = ObjectState.STATE_LOADERROR;
				this.dispatchEvent(new Loading(Loading.ERROR_CONTENT, this, this._tryurl, LoadedFile.TYPE_XML));
				this.dispatchEvent(new DISLoad(DISLoad.COMMUNITY_ERROR, this));
			}
		}
		
		/**
		 * Data load just begun.
		 */
		private function onLoaderOpen(evt:Event):void {
			this._state = ObjectState.STATE_LOADING;
			this.dispatchEvent(new Loading(Loading.START, this, this._tryurl, LoadedFile.TYPE_XML));
		}
		
		/**
		 * IO error while loading data.
		 */
		private function onLoaderIOError(evt:IOErrorEvent):void {
			this._state = ObjectState.STATE_LOADERROR;
			this.dispatchEvent(new Loading(Loading.ERROR_IO, this, this._tryurl, LoadedFile.TYPE_XML));
			this.dispatchEvent(new DISLoad(DISLoad.COMMUNITY_ERROR, this));
		}
		
		/**
		 * Data download progress.
		 */
		private function onLoaderProgress(evt:ProgressEvent):void {
			this.dispatchEvent(new Loading(Loading.PROGRESS, this, this._tryurl, LoadedFile.TYPE_XML, evt.bytesLoaded, evt.bytesTotal));
		}
		
		/**
		 * Security error while loading data.
		 */
		private function onLoaderSecurityError(evt:SecurityErrorEvent):void {
			this._state = ObjectState.STATE_LOADERROR;
			this.dispatchEvent(new Loading(Loading.ERROR_SECURITY, this, this._tryurl, LoadedFile.TYPE_XML));
			this.dispatchEvent(new DISLoad(DISLoad.COMMUNITY_ERROR, this));
		}
		
		/**
		 * A stream is loaded.
		 */
		private function onStreamOK(evt:DISLoad):void {
			switch (evt.loader.level) {
				case DISStream.LEVEL_MAIN:
					// check for guide streams
					var foundUP:Boolean = false;
					var foundDOWN:Boolean = false;
					for (var istr:String in evt.loader.guides) {
						if (istr == "up") {
							if (this._upstream.id != evt.loader.guides[istr].id) this._upstream.load(evt.loader.guides[istr].id);
							foundUP = true;
						}
						if (istr == "down") {
							if (this._downstream.id != evt.loader.guides[istr].id) this._downstream.load(evt.loader.guides[istr].id);
							foundDOWN = true;
						}
					}
					if (!foundUP) this._upstream.clean();
					if (!foundDOWN) this._downstream.clean();
					break;
			}
			this.dispatchEvent(new DISLoad(DISLoad.STREAM_OK, evt.loader));
		}
		
		/**
		 * A stream failed to load.
		 */
		private function onStreamERROR(evt:DISLoad):void {
			evt.loader.clean();
		}
		
		/**
		 * A playlist data is available.
		 */
		private function onPlaylistOK(evt:DISLoad):void {
			evt.loader.removeEventListener(DISLoad.PLAYLIST_OK, onPlaylistOK);
			evt.loader.removeEventListener(DISLoad.PLAYLIST_ERROR, onPlaylistERROR);
			this.dispatchEvent(new DISLoad(DISLoad.PLAYLIST_OK, evt.loader));
		}
		
		/**
		 * Playlist data load error.
		 */
		private function onPlaylistERROR(evt:DISLoad):void {
			evt.loader.removeEventListener(DISLoad.PLAYLIST_OK, onPlaylistOK);
			evt.loader.removeEventListener(DISLoad.PLAYLIST_ERROR, onPlaylistERROR);
			this.dispatchEvent(new DISLoad(DISLoad.PLAYLIST_ERROR, evt.loader));
		}
		
	}

}
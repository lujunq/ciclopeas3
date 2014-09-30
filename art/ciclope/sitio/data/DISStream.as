package art.ciclope.sitio.data {
	
	// FLASH PACKAGES
	import art.ciclope.event.DISLoad;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.display.Sprite;
	import flash.net.URLVariables;
	import flash.system.System;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	
	// CICLOPE CLASSES
	import art.ciclope.event.Loading;
	import art.ciclope.event.DISLoad;
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
     * The stream data is available.
     */
    [Event( name = "STREAM_OK", type = "art.ciclope.event.DISLoad" )]
	/**
     * The stream data was not loaded.
     */
    [Event( name = "STREAM_ERROR", type = "art.ciclope.event.DISLoad" )]
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class DISStream extends EventDispatcher {
		
		// STATIC CONSTANTS
		
		/**
		 * Stream show level: main stream.
		 */
		public static const LEVEL_MAIN:String = "LEVEL_MAIN";
		/**
		 * Stream show level: upper guide
		 */
		public static const LEVEL_UP:String = "LEVEL_UP";
		/**
		 * Stream show level: lower guide
		 */
		public static const LEVEL_DOWN:String = "LEVEL_DOWN";
		
		// VARIABLES
		
		private var _level:String;			// stream show level
		private var _id:String;				// the stream identifier
		private var _tryid:String;			// id of stream being loaded
		private var _loader:URLLoader;		// a loader for xml data
		private var _state:String;			// current object state
		private var _path:String;			// path to DIS folder
		private var _title:String;			// stream title
		private var _excerpt:String;		// stream about excerpt
		private var _about:String;			// stream about
		private var _tags:String;			// strem tags
		private var _lastupdate:Date;		// date of last update on community
		private var _iconurl:String;		// stream icon url
		private var _icon:Sprite;			// stream icon graphic
		private var _iconloader:Loader;		// a loader for icon image
		private var _author:AuthorData;		// stream author
		private var _categories:Array;		// all categories this stream belongs
		private var _plugins:Array;			// information about plugins
		private var _guides:Array;			// information about guide streams
		private var _speed:uint;			// animation speed in fps
		private var _tweening:String;		// animation tween method
		private var _fade:String;			// animation fade method
		private var _entropy:uint;			// animation entropy level
		private var _distortion:uint;		// animation distortion level
		private var _target:String;			// instance name of playlist used as target
		private var _usevote:Boolean;		// use voting?
		private var _votetype:String;		// vote ending type: timer or playlist
		private var _votetime:uint;			// timer for voting
		private var _voteshow:String;		// where to show voting bars: "this" for current stream, "up" fo upper guide, "down" for lower guide
		private var _voteoptions:Array;		// an array with all voting options for this stream
		private var _playCall:Function;		// a function to call to download playlist data
		private var _keyframes:Array;		// stream keyframes
		
		/**
		 * Create a new DISStream object.
		 * @param	level	the stream show level
		 * @param	playlistCall	a function to call to download playlist data (must pass playlist id as argument)
		 */
		public function DISStream(level:String, playlistCall:Function) {
			// get data
			this._level = level;
			this._playCall = playlistCall;
			// prepare data
			this._state = ObjectState.STATE_NOTREADY;
			this._lastupdate = new Date();
			this._author = new AuthorData('', '');
			this._icon = new Sprite();
			this._iconloader = new Loader();
			this._iconloader.contentLoaderInfo.addEventListener(Event.INIT, onIcon);
			this._iconloader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIconError);
			this._categories = new Array();
			this._plugins = new Array();
			this._guides = new Array();
			this._voteoptions = new Array();
			this._keyframes = new Array();
			// prepare data loader
			this._loader = new URLLoader();
			this._loader.addEventListener(Event.COMPLETE, onLoaderComplete);
			this._loader.addEventListener(Event.OPEN, onLoaderOpen);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError);
			this._loader.addEventListener(ProgressEvent.PROGRESS, onLoaderProgress);
			this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoaderSecurityError);
		}
		
		// READ-ONLY VALUES
		
		/**
		 * This stream show level.
		 */
		public function get level():String {
			return (this._level);
		}
		
		/**
		 * Current stream identifier.
		 */
		public function get id():String {
			return (this._id);
		}
		
		/**
		 * Object state.
		 */
		public function get state():String {
			return (this._state);
		}
		
		/**
		 * Current stream title.
		 */
		public function get title():String {
			return (this._title);
		}
		
		/**
		 * Current stream about excerpt.
		 */
		public function get excerpt():String {
			return (this._excerpt);
		}
		
		/**
		 * About current stream.
		 */
		public function get about():String {
			return (this._about);
		}
		
		/**
		 * Current stream tags.
		 */
		public function get tags():String {
			return (this._tags);
		}
		
		/**
		 * Last time current stream was updated.
		 */
		public function get lastupdate():Date {
			return (this._lastupdate);
		}
		
		/**
		 * Current stream icon graphic.
		 */
		public function get icon():Sprite {
			return (this._icon);
		}
		
		/**
		 * Current stream author.
		 */
		public function get author():AuthorData {
			return (this._author);
		}
		
		/**
		 * Current stream plugin configurations (array of PluginData objects).
		 * @see	art.ciclope.sitio.data.PluginData
		 */
		public function get plugins():Array {
			return (this._plugins);
		}
		
		/**
		 * Current stream guides (array of StreamData objects).
		 * @see	art.ciclope.sitio.data.StreamData
		 */
		public function get guides():Array {
			return (this._guides);
		}
		
		/**
		 * Current stream categories (array of CategoryData objects).
		 * @see	art.ciclope.sitio.data.CategoryData
		 */
		public function get categories():Array {
			return (this._categories);
		}
		
		/**
		 * Current stream animation speed.
		 */
		public function get speed():uint {
			return (this._speed);
		}
		
		/**
		 * Current stream animation tween method.
		 */
		public function get tweening():String {
			return (this._tweening);
		}
		
		/**
		 * Current stream animation fade method.
		 */
		public function get fade():String {
			return (this._fade);
		}
		
		/**
		 * Current stream animation entropy level.
		 */
		public function get entropy():uint {
			return (this._entropy);
		}
		
		/**
		 * Current stream animation distortion level.
		 */
		public function get distortion():uint {
			return (this._distortion);
		}
		
		/**
		 * Current stream target intance identifier.
		 */
		public function get target():String {
			return (this._target);
		}
		
		/**
		 * Use votes for stream interaction?
		 */
		public function get usevote():Boolean {
			return (this._usevote);
		}
		
		/**
		 * Current strem vote processing type ("timer" or a playlist instance name).
		 */
		public function get votetype():String {
			return (this._votetype);
		}
		
		/**
		 * Show vote bars on this stream, up guide or down guide?
		 */
		public function get voteshow():String {
			return (this._voteshow);
		}
		
		/**
		 * Current stream vote options (array of VoteData objects).
		 * @see	art.ciclope.sitio.data.VoteData
		 */
		public function get voteoptions():Array {
			return (this._voteoptions);
		}
		
		/**
		 * Current stream keyframes (array of DISKeyframe objects).
		 * @see	art.ciclope.sitio.data.DISKeyframe
		 */
		public function get keyframes():Array {
			return (this._keyframes);
		}
		
		// GET/SET VARIABLES
		
		/**
		 * The path to the DIS folder.
		 */
		public function get path():String {
			return (this._path);
		}
		public function set path(to:String):void {
			if (to != "") {
				this._path = StringFunctions.slashURL(to);
				if (this._state == ObjectState.STATE_NOTREADY) this._state = ObjectState.STATE_CLEAN;
			} else {
				this._path = "";
				this._state = ObjectState.STATE_NOTREADY;
			}
		}
		
		// PRIVATE READ-ONLY VALUES
		
		/**
		 * The url to the last loaded stream (completed or not).
		 */
		private function get tryurl():String {
			return (this._path + "stream/" + this._tryid + ".xml");
		}
		
		// PUBLIC METHODS
		
		/**
		 * Load a stream data.
		 * @param	id	the stream identifier
		 * @param	cache	cached stream data
		 * @return	true if the object can try to load, false if it is not ready to load data
		 */
		public function load(id:String, cache:String = null):Boolean {
			if (this._state != ObjectState.STATE_NOTREADY) {
				this._tryid = id;
				var cached:Boolean = false;
				if (cache != null) {
					try {
						var data:XML = new XML(cache);
						this.parseStreamData(data);
						cached = true;
					} catch (e:Error) { }
				}
				if (!cached) {
					var request:URLRequest = new URLRequest(this.tryurl);
					request.method = "GET";
					var now:Date = new Date();
					request.data = new URLVariables("rand=" + now.dateUTC);
					this._loader.load(request);
				}
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Replace stream data with an empty stream and call load listeners.
		 */
		public function clean():void {
			// clear
			this.clear();
			// listeners
			this._state = ObjectState.STATE_LOADOK;
			this.dispatchEvent(new Loading(Loading.FINISHED, this, "", LoadedFile.TYPE_XML));
			this.dispatchEvent(new DISLoad(DISLoad.STREAM_OK, this));
		}
		
		/**
		 * Release memory used by this object.
		 */
		public function kill():void {
			this._title = null;
			this._excerpt = null;
			this._about = null;
			this._iconurl = null;
			this._tags = null;
			this._lastupdate = null;
			this._playCall = null;
			this._author.kill();
			this._author = null;
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
			for (var istr:String in this._guides) {
				this._guides[istr].kill();
				delete(this._guides[istr]);
			}
			this._guides = null;
			this._tweening = null;
			this._fade = null;
			this._target = null;
			this._votetype = null;
			this._voteshow = null;
			for (istr in this._voteoptions) {
				this._voteoptions[istr].kill();
				delete(this._voteoptions[istr]);
			}
			this._voteoptions = null;
			while (this._keyframes.length > 0) {
				this._keyframes[0].kill();
				this._keyframes.shift();
			}
			this._keyframes = null;
			this._state = null;
			this._level = null;
			this._loader.removeEventListener(Event.COMPLETE, onLoaderComplete);
			this._loader.removeEventListener(Event.OPEN, onLoaderOpen);
			this._loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError);
			this._loader.removeEventListener(ProgressEvent.PROGRESS, onLoaderProgress);
			this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoaderSecurityError);
			this._loader = null;
			this._iconloader.contentLoaderInfo.removeEventListener(Event.INIT, onIcon);
			this._iconloader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIconError);
			this._iconloader = null;
		}
		
		// PRIVATE METHODS
		
		/**
		 * Clear current stream to receive data about a new one.
		 */
		private function clear():void {
			this._id = "";
			this._title = "";
			this._excerpt = "";
			this._about = "";
			this._iconurl = "";
			this._tags = "";
			this._lastupdate.setTime(0);
			this._author.kill();
			this._author = new AuthorData('', '');
			while (this._icon.numChildren > 0) {
				var iconchild:DisplayObject = this._icon.getChildAt(0);
				this._icon.removeChild(iconchild);
				if (iconchild is Bitmap) Bitmap(iconchild).bitmapData.dispose();
				iconchild = null;
			}
			this._icon.addChild(new QuestionIcon() as Sprite);
			while (this._categories.length > 0) {
				this._categories[0].kill();
				this._categories.shift();
			}
			while (this._plugins.length > 0) {
				this._plugins[0].kill();
				this._plugins.shift();
			}
			for (var istr:String in this._guides) {
				this._guides[istr].kill();
				delete(this._guides[istr]);
			}
			this._speed = 1;
			this._tweening = "linear";
			this._fade = "fade";
			this._entropy = 0;
			this._distortion = 0;
			this._target = "";
			this._usevote = false;
			this._votetype = "";
			this._voteshow = "";
			this._votetime = 0;
			for (istr in this._voteoptions) {
				this._voteoptions[istr].kill();
				delete(this._voteoptions[istr]);
			}
			while (this._keyframes.length > 0) {
				this._keyframes[0].kill();
				this._keyframes.shift();
			}
		}
		
		// EVENTS
		
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
			if (loadok) {
				this.parseStreamData(newxml);
			} else {
				// loaded file does not meet stream file standards
				this._state = ObjectState.STATE_LOADERROR;
				this.dispatchEvent(new Loading(Loading.ERROR_CONTENT, this, this.tryurl, LoadedFile.TYPE_XML));
				this.dispatchEvent(new DISLoad(DISLoad.STREAM_ERROR, this));
			}
		}
		
		/**
		 * Parse the loaded xml data.
		 * @param	newxml	the stream xml data
		 */
		private function parseStreamData(newxml:XML):void {
			var loadok:Boolean = true;
			if ((newxml.child("id").length() == 0) || (newxml.child("meta").length() == 0) || (newxml.child("categories").length() == 0) || (newxml.child("plugins").length() == 0) || (newxml.child("guides").length() == 0) || (newxml.child("animation").length() == 0) || (newxml.child("voting").length() == 0) || (newxml.child("playlists").length() == 0) || (newxml.child("keyframes").length() == 0)) {
				loadok = false;
			} else {
				// load stream data
				var index:uint;
				this.clear();
				// stream id
				this._id = String(newxml.id[0]);
				// get meta data
				if (newxml.meta[0].child("title").length() > 0) this._title = String(newxml.meta[0].title[0]);
				if (newxml.meta[0].child("excerpt").length() > 0) this._excerpt = String(newxml.meta[0].excerpt[0]);
				if (newxml.meta[0].child("about").length() > 0) this._about = String(newxml.meta[0].about[0]);
				if (newxml.meta[0].child("icon").length() > 0) this._iconurl = this._path + "media/community/picture/" + String(newxml.meta[0].icon[0]);
				if (newxml.meta[0].child("tags").length() > 0) this._tags = String(newxml.meta[0].tags[0]);
				if (newxml.meta[0].child("update").length() > 0) {
					var last:Array = String(newxml.meta[0].update[0]).split("-");
					if (last.length == 3) this._lastupdate.setFullYear(uint(last[0]), (uint(last[1]) - 1), uint(last[2]));
					last = null;
				}
				if (newxml.meta[0].child("author").length() > 0) {
					if (newxml.meta[0].author[0].hasOwnProperty('@id')) {
						this._author.kill();
						this._author = new AuthorData(String(newxml.meta[0].author[0]), String(newxml.meta[0].author[0].@id));
					}
				}
				// load icon?
				if (this._iconurl != "") this._iconloader.load(new URLRequest(this._iconurl));
				// categories
				for (index = 0; index < newxml.categories[0].child("category").length(); index++) {
					if (newxml.categories[0].category[index].hasOwnProperty('@id')) {
						this._categories.push(new CategoryData(String(newxml.categories[0].category[index]), String(newxml.categories[0].category[index].@id)));
					}
				}
				// plugins
				for (index = 0; index < newxml.plugins[0].child("plugin").length(); index++) {
					if ((newxml.plugins[0].plugin[index].hasOwnProperty('@id')) && (newxml.plugins[0].plugin[index].hasOwnProperty('@name'))) {
						this._plugins.push(new PluginData(String(newxml.plugins[0].plugin[index].@name), String(newxml.plugins[0].plugin[index].@id), String(newxml.plugins[0].plugin[index])));
					}
				}
				// guides
				for (index = 0; index < newxml.guides[0].child("stream").length(); index++) {
					if ((newxml.guides[0].stream[index].hasOwnProperty('@id')) && (newxml.guides[0].stream[index].hasOwnProperty('@type'))) {
						if (this._guides[String(newxml.guides[0].stream[index].@type)] == null) {
							this._guides[String(newxml.guides[0].stream[index].@type)] = new StreamData(String(newxml.guides[0].stream[index]), String(newxml.guides[0].stream[index].@id), String(newxml.guides[0].stream[index].@type));
						}
					}
				}
				// animation
				if (newxml.animation[0].child("speed").length() > 0) this._speed = uint(newxml.animation[0].speed[0]);
				if (newxml.animation[0].child("tweening").length() > 0) this._tweening = String(newxml.animation[0].tweening[0]);
				if (newxml.animation[0].child("fade").length() > 0) this._fade = String(newxml.animation[0].fade[0]);
				if (newxml.animation[0].child("entropy").length() > 0) this._entropy = uint(newxml.animation[0].entropy[0]);
				if (newxml.animation[0].child("distortion").length() > 0) this._distortion = uint(newxml.animation[0].distortion[0]);
				if (newxml.animation[0].child("target").length() > 0) this._target = String(newxml.animation[0].target[0]);
				// voting
				if (newxml.voting[0].child("usevote").length() > 0) this._usevote = Boolean(uint(newxml.voting[0].usevote[0]));
				if (newxml.voting[0].child("type").length() > 0) this._votetype = String(newxml.voting[0].type[0]);
				if (newxml.voting[0].child("time").length() > 0) this._votetime = uint(newxml.voting[0].time[0]);
				if (newxml.voting[0].child("show").length() > 0) this._voteshow = String(newxml.voting[0].show[0]);
				if (newxml.voting[0].child("options").length() > 0) {
					if (newxml.voting[0].options[0].child("option").length() > 0) {
						for (index = 0; index < newxml.voting[0].options[0].child("option").length(); index++) {
							if (newxml.voting[0].options[0].option[index].hasOwnProperty('@id')) {
								this._voteoptions[String(newxml.voting[0].options[0].option[index].@id)] = new VoteData(uint(newxml.voting[0].options[0].option[index].@id), String(newxml.voting[0].options[0].option[index]));
							}
						}
					}
				}
				// playlists
				for (index = 0; index < newxml.playlists[0].child("playlist").length(); index++) {
					if (newxml.playlists[0].playlist[index].hasOwnProperty('@id')) {
						this._playCall(String(newxml.playlists[0].playlist[index].@id));
					}
				}
				// keyframes
				for (index = 0; index < newxml.keyframes[0].child("keyframe").length(); index++) {
					var kframe:DISKeyframe = new DISKeyframe(String(newxml.keyframes[0].keyframe[index]));
					if (kframe.state == ObjectState.STATE_LOADOK) {
						this._keyframes.push(kframe);
					} else {
						kframe.kill();
						kframe = null;
					}
				}
			}
			System.disposeXML(newxml);
				
			// warn listeners
			if (loadok) {
				// file correctly loaded
				this._state = ObjectState.STATE_LOADOK;
				this.dispatchEvent(new Loading(Loading.FINISHED, this, this.tryurl, LoadedFile.TYPE_XML));
				this.dispatchEvent(new DISLoad(DISLoad.STREAM_OK, this));
			} else {
				// loaded file does not meet stream file standards
				this._state = ObjectState.STATE_LOADERROR;
				this.dispatchEvent(new Loading(Loading.ERROR_CONTENT, this, this.tryurl, LoadedFile.TYPE_XML));
				this.dispatchEvent(new DISLoad(DISLoad.STREAM_ERROR, this));
			}
		}
		
		/**
		 * Data load just begun.
		 */
		private function onLoaderOpen(evt:Event):void {
			this._state = ObjectState.STATE_LOADING;
			this.dispatchEvent(new Loading(Loading.START, this, this.tryurl, LoadedFile.TYPE_XML));
		}
		
		/**
		 * IO error while loading data.
		 */
		private function onLoaderIOError(evt:IOErrorEvent):void {
			this._state = ObjectState.STATE_LOADERROR;
			this.dispatchEvent(new Loading(Loading.ERROR_IO, this, this.tryurl, LoadedFile.TYPE_XML));
			this.dispatchEvent(new DISLoad(DISLoad.STREAM_ERROR, this));
		}
		
		/**
		 * Data download progress.
		 */
		private function onLoaderProgress(evt:ProgressEvent):void {
			this.dispatchEvent(new Loading(Loading.PROGRESS, this, this.tryurl, LoadedFile.TYPE_XML, evt.bytesLoaded, evt.bytesTotal));
		}
		
		/**
		 * Security error while loading data.
		 */
		private function onLoaderSecurityError(evt:SecurityErrorEvent):void {
			this._state = ObjectState.STATE_LOADERROR;
			this.dispatchEvent(new Loading(Loading.ERROR_SECURITY, this, this.tryurl, LoadedFile.TYPE_XML));
			this.dispatchEvent(new DISLoad(DISLoad.STREAM_ERROR, this));
		}
		
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
		
	}

}
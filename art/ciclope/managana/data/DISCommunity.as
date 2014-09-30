package art.ciclope.managana.data {
	
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
	import flash.net.URLRequestHeader;
	import flash.net.URLVariables;
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
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * DISCommunity provides methos for loading and handling dis community folders.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class DISCommunity extends EventDispatcher {
		
		// VARIABLES
		
		private var _url:String;				// the loaded DIS url
		private var _tryurl:String;				// the DIS url loading
		private var _state:String;				// current object state
		private var _loader:URLLoader;			// a loader for xml data
		private var _id:String;					// community id
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
		private var _screenaspect:String;		// screen aspec: portrait or landscape
		private var _portraitwidth:uint;		// screen width on portrait view
		private var _portraitheight:uint;		// screen height on portrait view
		private var _usehighlight:Boolean;		// use highlight color on links?
		private var _highlight:uint;			// highlight color
		private var _background:uint;			// background color
		private var _alpha:Number;				// background alpha
		private var _home:StreamData;			// home stream
		private var _feeds:Array;				// information about feeds
		private var _mainstream:DISStream;		// the main stream
		private var _upstream:DISStream;		// the upper layer guide stream
		private var _downstream:DISStream;		// the lower layer guide stream
		private var _playlists:Array;			// information about playlists loaded
		private var _voteDefault:uint;			// community default vote for group interaction
		private var _voteRecord:Boolean;		// save stream voting results on server?
		private var _target:String;				// target graphic
		private var _vote0:String;				// 0% vote graphic
		private var _vote10:String;				// 10% vote graphic
		private var _vote20:String;				// 20% vote graphic
		private var _vote30:String;				// 30% vote graphic
		private var _vote40:String;				// 40% vote graphic
		private var _vote50:String;				// 50% vote graphic
		private var _vote60:String;				// 60% vote graphic
		private var _vote70:String;				// 70% vote graphic
		private var _vote80:String;				// 80% vote graphic
		private var _vote90:String;				// 90% vote graphic
		private var _vote100:String;			// 100% vote graphic
		private var _css:String;				// default style sheet for HTML paragraph text
		private var _navxnext:String;			// navigation transition for next X stream
		private var _navxprev:String;			// navigation transition for previous X stream
		private var _navynext:String;			// navigation transition for next Y stream
		private var _navyprev:String;			// navigation transition for previous Y stream
		private var _navznext:String;			// navigation transition for next Z stream
		private var _navzprev:String;			// navigation transition for previous Z stream
		private var _navhome:String;			// navigation transition for home stream
		private var _navlist:String;			// navigation transition for list-selected streams
		
		/**
		 * DISCommunity constructor.
		 * @param	parserRun	a reference for the progress code parser run function
		 * @param	getImage	a reference for the getImage function
		 */
		public function DISCommunity(parserRun:Function, getImage:Function) {
			// prepare variables
			this._state = ObjectState.STATE_CLEAN;
			this._url = "";
			this._tryurl = "";
			this._voteDefault = 2;
			this._voteRecord = true;
			this._loader = new URLLoader();
			this._loader.addEventListener(Event.COMPLETE, onLoaderComplete);
			this._loader.addEventListener(Event.OPEN, onLoaderOpen);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError);
			this._loader.addEventListener(ProgressEvent.PROGRESS, onLoaderProgress);
			this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoaderSecurityError);
			this._icon = new Sprite();
			this._lastupdate = new Date();
			this._categories = new Array();
			this._home = new StreamData("", "");
			this._feeds = new Array();
			this._playlists = new Array();
			this._iconloader = new Loader();
			this._iconloader.contentLoaderInfo.addEventListener(Event.INIT, onIcon);
			this._iconloader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIconError);
			// clear data
			this.clear();
			this._screenaspect = "landscape";
			// prepare streams
			this._mainstream = new DISStream(DISStream.LEVEL_MAIN, this.addPlaylist, parserRun, getImage);
			this._upstream = new DISStream(DISStream.LEVEL_DOWN, this.addPlaylist, parserRun, getImage);
			this._downstream = new DISStream(DISStream.LEVEL_UP, this.addPlaylist, parserRun, getImage);
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
		 * The community ID.
		 */
		public function get id():String {
			return (this._id);
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
		 * The community default vote for group interaction.
		 */
		public function get voteDeafult():uint {
			return (this._voteDefault);
		}
		
		/**
		 * Save stream voting results on server?
		 */
		public function get voteRecord():Boolean {
			return (this._voteRecord);
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
			if (this._state == ObjectState.STATE_LOADOK) {
				if (this._screenaspect == "portrait") return (this._portraitwidth);
					else return(this._screenwidth);
			} else {
				return (0);
			}
		}
		
		/**
		 * The community design screen height.
		 */
		public function get screenheight():uint {
			if (this._state == ObjectState.STATE_LOADOK) {
				if (this._screenaspect == "portrait") return (this._portraitheight);
					else return(this._screenheight);
			} else {
				return (0);
			}
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
		 * @see	art.ciclope.managana.data.CategoryData
		 */
		public function get categories():Array {
			return (this._categories);
		}
		
		/**
		 * An array of FeedData objects with all community external feed information.
		 * @see	art.ciclope.managana.data.FeedData
		 */
		public function get feeds():Array {
			return (this._feeds);
		}
		
		/**
		 * An associative array of DISPlaylist objects with playlist data.
		 * @see	art.ciclope.managana.data.DISPlaylist
		 */
		public function get playlists():Array {
			return (this._playlists);
		}
		
		/**
		 * Community data state.
		 * @see	art.ciclope.util.ObjectState
		 */
		public function get state():String {
			return (this._state);
		}
		
		/**
		 * Community target graphic.
		 */
		public function get target():String {
			return (this._target);
		}
		
		/**
		 * Community 0% vote graphic.
		 */
		public function get vote0():String {
			return (this._vote0);
		}
		
		/**
		 * Community 10% vote graphic.
		 */
		public function get vote10():String {
			return (this._vote10);
		}
		
		/**
		 * Community 20% vote graphic.
		 */
		public function get vote20():String {
			return (this._vote20);
		}
		
		/**
		 * Community 30% vote graphic.
		 */
		public function get vote30():String {
			return (this._vote30);
		}
		
		/**
		 * Community 40% vote graphic.
		 */
		public function get vote40():String {
			return (this._vote40);
		}
		
		/**
		 * Community 50% vote graphic.
		 */
		public function get vote50():String {
			return (this._vote50);
		}
		
		/**
		 * Community 60% vote graphic.
		 */
		public function get vote60():String {
			return (this._vote60);
		}
		
		/**
		 * Community 70% vote graphic.
		 */
		public function get vote70():String {
			return (this._vote70);
		}
		
		/**
		 * Community 80% vote graphic.
		 */
		public function get vote80():String {
			return (this._vote80);
		}
		
		/**
		 * Community 90% vote graphic.
		 */
		public function get vote90():String {
			return (this._vote90);
		}
		
		/**
		 * Community 100% vote graphic.
		 */
		public function get vote100():String {
			return (this._vote100);
		}
		
		/**
		 * Style sheet for HTML paragraph text.
		 */
		public function get css():String {
			return (this._css);
		}
		
		/**
		 * Transition for next stream on X.
		 */
		public function get navxnext():String {
			return (this._navxnext);
		}
		
		/**
		 * Transition for previous stream on X.
		 */
		public function get navxprev():String {
			return (this._navxprev);
		}
		/**
		 * Transition for next stream on Y.
		 */
		public function get navynext():String {
			return (this._navynext);
		}
		
		/**
		 * Transition for previous stream on Y.
		 */
		public function get navyprev():String {
			return (this._navyprev);
		}
		/**
		 * Transition for next stream on Z.
		 */
		public function get navznext():String {
			return (this._navznext);
		}
		
		/**
		 * Transition for previous stream on Z.
		 */
		public function get navzprev():String {
			return (this._navzprev);
		}
		
		/**
		 * Transition for home stream.
		 */
		public function get navhome():String {
			return (this._navhome);
		}
		
		/**
		 * Transition for list-selected streams.
		 */
		public function get navlist():String {
			return (this._navlist);
		}
		
		
		
		// GET-SET VALUES
		
		/**
		 * The screen aspect ratio.
		 * @see	flash.display.StageAspectRatio
		 */
		public function get aspect():String {
			return (this._screenaspect);
		}
		public function set aspect(to:String):void {
			if (to == "portrait") this._screenaspect = to;
				else this._screenaspect = "landscape";
		}
		
		// PUBLIC METHODS
		
		/**
		 * Load a DIS community.
		 * @param	url	the DIS community url
		 */
		public function load(url:String):void {
			url = StringFunctions.slashURL(url);
			if (url != this._url) {
				this.dispatchEvent(new DISLoad(DISLoad.COMMUNITY_LOAD, this));
				this._state = ObjectState.STATE_LOADING;
				this._tryurl = url;
				var request:URLRequest = new URLRequest(this._tryurl + "dis.xml");
				request.method = "GET";
				if (url.substr(0, 4) != "file") {
					request.data = new URLVariables("nocache=" + new Date().getTime());
				}
				this._loader.load(request);
			}
		}
		
		/**
		 * Load a stream into main level.
		 * @param	id	the stream identifier
		 * @param	cache	text cache with stream content
		 * @return	true if the community can load the stream, false otherwise
		 */
		public function loadStream(id:String, cache:String = null):Boolean {
			if (this._state == ObjectState.STATE_LOADOK) {
				if (this._mainstream.id != id) {
					this._mainstream.load(id, cache);
					this.dispatchEvent(new DISLoad(DISLoad.STREAM_LOAD, this._mainstream));
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
		 * Clear object data,
		 */
		public function clear():void {
			this._state = ObjectState.STATE_CLEAN;
			this._id = "";
			this._url = "";
			this._title = "";
			this._copyleft = "";
			this._copyright = "";
			this._excerpt = "";
			this._about = "";
			this._iconurl = "";
			this._language = "";
			this._target = "";
			this._vote0 = "";
			this._vote10 = "";
			this._vote20 = "";
			this._vote30 = "";
			this._vote40 = "";
			this._vote50 = "";
			this._vote60 = "";
			this._vote70 = "";
			this._vote80 = "";
			this._vote90 = "";
			this._vote100 = "";
			this._screenwidth = 1920;
			this._screenheight = 1080;
			this._portraitwidth = 0;
			this._portraitheight = 0;
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
			while (this._feeds.length > 0) {
				this._feeds[0].kill();
				this._feeds.shift();
			}
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
			this._css = "body {\n    color: #000000;\n    font-family: Arial, Helvetica, sans-serif;\n    font-size: 16px;\n}\n\na {\n    color: #0000FF;\n    text-decoration: underline;\n}";
			this._navxnext = "";
			this._navxprev = "";
			this._navynext = "";
			this._navyprev = "";
			this._navznext = "";
			this._navzprev = "";
			this._navhome = "";
			this._navlist = "";
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
			this._id = null;
			this._title = null;
			this._copyleft = null;
			this._copyright = null;
			this._excerpt = null;
			this._about = null;
			this._iconurl = null;
			this._language = null;
			this._lastupdate = null;
			this._screenaspect = null;
			this._target = null;
			this._vote0 = null;
			this._vote10 = null;
			this._vote20 = null;
			this._vote30 = null;
			this._vote40 = null;
			this._vote50 = null;
			this._vote60 = null;
			this._vote70 = null;
			this._vote80 = null;
			this._vote90 = null;
			this._vote100 = null;
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
			while (this._feeds.length > 0) {
				this._feeds[0].kill();
				this._feeds.shift();
			}
			this._feeds = null;
			for (var istr:String in this._playlists) {
				this._playlists[istr].kill();
				delete(this._playlists[istr]);
			}
			this._playlists = null;
			this._iconloader.contentLoaderInfo.removeEventListener(Event.INIT, onIcon);
			this._iconloader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIconError);
			this._iconloader.unloadAndStop();
			this._iconloader = null;
			this._css = null;
			this._navxnext = null;
			this._navxprev = null;
			this._navynext = null;
			this._navyprev = null;
			this._navznext = null;
			this._navzprev = null;
			this._navhome = null;
			this._navlist = null;
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
			if ((data != null) && ((data.child("meta").length() == 0) || (data.child("categories").length() == 0) || (data.child("screen").length() == 0) || (data.child("home").length() == 0))) {
				// invalid xml data
				result = false;
			} else {
				// clear previous DIS data
				this.clear();
				// get meta data
				if (data.meta[0].child("id").length() > 0) this._id = String(data.meta[0].id[0]);
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
				// default vote
				this._voteDefault = 2;
				if (data.child("defaultvote").length() > 0) this._voteDefault = uint(data.defaultvote);
				// voting record
				this._voteRecord = true;
				if (data.child("voterecord").length() > 0) this._voteRecord = (String(data.voterecord) == "1");
				// get screen data
				if (data.screen[0].child("width").length() > 0) this._screenwidth = uint(data.screen[0].width[0]);
				if (data.screen[0].child("height").length() > 0) this._screenheight = uint(data.screen[0].height[0]);
				this._portraitwidth = this._portraitheight = 0;
				if (data.screen[0].child("portrait").length() > 0) {
					if (data.screen[0].portrait[0].child("width").length() > 0) this._portraitwidth = uint(data.screen[0].portrait[0].width[0]);
					if (data.screen[0].portrait[0].child("height").length() > 0) this._portraitheight = uint(data.screen[0].portrait[0].height[0]);
				}
				if (data.screen[0].child("highlight").length() > 0) {
					this._highlight = uint(data.screen[0].highlight[0]);
					if (data.screen[0].highlight[0].hasOwnProperty('@active')) this._usehighlight = Boolean(uint(data.screen[0].highlight[0].@active));
				}
				if (data.screen[0].child("background").length() > 0) this._background = uint(data.screen[0].background[0]);
				if (data.screen[0].child("alpha").length() > 0) this._alpha = Number(data.screen[0].alpha[0]);
				// custom graphics?
				if (data.child("graphics").length() > 0) {
					if (String(data.graphics.target) != "") this._target = url + "media/community/picture/" + String(data.graphics.target);
					if (String(data.graphics.vote0) != "") this._vote0 = url + "media/community/picture/" + String(data.graphics.vote0);
					if (String(data.graphics.vote10) != "") this._vote10 = url + "media/community/picture/" + String(data.graphics.vote10);
					if (String(data.graphics.vote20) != "") this._vote20 = url + "media/community/picture/" + String(data.graphics.vote20);
					if (String(data.graphics.vote30) != "") this._vote30 = url + "media/community/picture/" + String(data.graphics.vote30);
					if (String(data.graphics.vote40) != "") this._vote40 = url + "media/community/picture/" + String(data.graphics.vote40);
					if (String(data.graphics.vote50) != "") this._vote50 = url + "media/community/picture/" + String(data.graphics.vote50);
					if (String(data.graphics.vote60) != "") this._vote60 = url + "media/community/picture/" + String(data.graphics.vote60);
					if (String(data.graphics.vote70) != "") this._vote70 = url + "media/community/picture/" + String(data.graphics.vote70);
					if (String(data.graphics.vote80) != "") this._vote80 = url + "media/community/picture/" + String(data.graphics.vote80);
					if (String(data.graphics.vote90) != "") this._vote90 = url + "media/community/picture/" + String(data.graphics.vote90);
					if (String(data.graphics.vote100) != "") this._vote100 = url + "media/community/picture/" + String(data.graphics.vote100);
				}
				// home
				if (String(data.home[0]) != "") {
					this._home.kill();
					this._home = new StreamData(String(data.home[0]), String(data.home[0]));
				}
				// css
				if (data.child("css").length() > 0) {
					if (String(data.css) != "") this._css = String(data.css);
				}
				// stream navigation transitions
				if (data.child("transition").length() > 0) {
					this._navxnext = String(data.transition[0].xnext);
					this._navxprev = String(data.transition[0].xprev);
					this._navynext = String(data.transition[0].ynext);
					this._navyprev = String(data.transition[0].yprev);
					this._navznext = String(data.transition[0].znext);
					this._navzprev = String(data.transition[0].zprev);
					this._navhome = String(data.transition[0].home);
					this._navlist = String(data.transition[0].list);
				}
				// categories
				for (index = 0; index < data.categories[0].child("category").length(); index++) {
					if (data.categories[0].category[index].hasOwnProperty('@id')) {
						this._categories.push(new CategoryData(String(data.categories[0].category[index]), String(data.categories[0].category[index].@id)));
					}
				}
				// feeds
				for (index = 0; index < data.feeds[0].child("feed").length(); index++) {
					if ((data.feeds[0].feed[index].hasOwnProperty('@reference')) && (data.feeds[0].feed[index].hasOwnProperty('@type'))) {
						this._feeds.push(new FeedData(String(data.feeds[0].feed[index]), String(data.feeds[0].feed[index].@type), String(data.feeds[0].feed[index].@reference)));
					}
				}
			}
			// resturn result
			return(result);
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
			if (evt.loader.state == ObjectState.STATE_LOADOK) {
				switch (evt.loader.level) {
					case DISStream.LEVEL_MAIN:
						// check for guide streams
						var foundUP:Boolean = false;
						var foundDOWN:Boolean = false;
						for (var istr:String in evt.loader.guides) {
							if (istr == "up") {
								if (this._upstream.id != evt.loader.guides[istr].id) {
									this._upstream.load(evt.loader.guides[istr].id);
								}
								foundUP = true;
							}
							if (istr == "down") {
								if (this._downstream.id != evt.loader.guides[istr].id) {
									this._downstream.load(evt.loader.guides[istr].id);
								}
								foundDOWN = true;
							}
						}
						if (!foundUP) {
							this._upstream.clean();
						}
						if (!foundDOWN) {
							this._downstream.clean();
						}
						break;
				}
				this.dispatchEvent(new DISLoad(DISLoad.STREAM_OK, evt.loader));
			}
		}
		
		/**
		 * A stream failed to load.
		 */
		private function onStreamERROR(evt:DISLoad):void {
			// do nothing
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
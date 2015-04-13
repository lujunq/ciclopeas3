package art.ciclope.managana.data {
	
	// FLASH PACKAGES
	import art.ciclope.event.DISLoad;
	import art.ciclope.managana.ManaganaImage;
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
	import art.ciclope.staticfunctions.NumberFunctions;
	
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
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * DISStream provides methos for dis folder streams handling.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
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
		
		private var _level:String;				// stream show level
		private var _id:String;					// the stream identifier
		private var _tryid:String;				// id of stream being loaded
		private var _loader:URLLoader;			// a loader for xml data
		private var _state:String;				// current object state
		private var _path:String;				// path to DIS folder
		private var _title:String;				// stream title
		private var _excerpt:String;			// stream about excerpt
		private var _about:String;				// stream about
		private var _tags:String;				// stream tags
		private var _meta:Array;				// custom meta tags
		private var _lastupdate:Date;			// date of last update on community
		private var _iconurl:String;			// stream icon url
		private var _icon:Sprite;				// stream icon graphic
		private var _iconloader:Loader;			// a loader for icon image
		private var _author:AuthorData;			// stream author
		private var _category:String;			// the category this stream belongs
		private var _guides:Array;				// information about guide streams
		private var _speed:uint;				// animation speed in fps
		private var _tweening:String;			// animation tween method
		private var _fade:String;				// animation fade method
		private var _entropy:uint;				// animation entropy level
		private var _distortion:uint;			// animation distortion level
		private var _target:String;				// instance name of playlist used as target
		private var _votetype:String;			// vote type: infinite, defined or instance
		private var _votereference:String;		// vote time reference: defined time or instance id
		private var _voteoptions:Array;			// an array with all voting options for this stream
		private var _playCall:Function;			// a function to call to download playlist data
		private var _keyframes:Array;			// stream keyframes
		private var _navigation:Array;			// standard stream navigation
		private var _screenaspect:String;		// the current screen aspect
		private var _landscape:String;			// stream ID for landscape display
		private var _portrait:String;			// stream ID for portrait display
		private var _loading:Boolean;			// currently loading a stream?
		private var _parserRun:Function;		// progress code parser run function
		private var _getImage:Function;			// the getImage function
		private var _pcode:String;				// stream initial progress code
		private var _functionA:String;			// custom function A progress code
		private var _functionB:String;			// custom function B progress code
		private var _functionC:String;			// custom function C progress code
		private var _functionD:String;			// custom function D progress code
		private var _mouseWUp:String;			// mouse wheel up function
		private var _mouseWDown:String;			// mouse wheel down function
		private var _voteDefault:uint;			// default vote for public interactions
		private var _startAfterVote:Boolean;	// start stream timer only after first vote?
		private var _remoteStreamID:String;		// a stream to load on remote control when the current one is showing
		private var _geouse:Boolean;			// use geolocation?
		private var _geomap:String;				// map instance
		private var _geotarget:String;			// target instance
		private var _geolattop:Number;			// upper left point latitude
		private var _geolongtop:Number;			// upper left point longitude
		private var _geolatbottom:Number;		// lower right point latitude
		private var _geolongbottom:Number;		// lower right point longitude
		private var _geoXTop:Number;			// mercator x projection for map upper left ponit
		private var _geoYTop:Number;			// mercator y projection for map upper left ponit
		private var _geoXBottom:Number;			// mercator x projection for map lower right ponit
		private var _geoYBottom:Number;			// mercator y projection for map lower right ponit
		private var _geoDeltaX:Number;			// map x point difference
		private var _geoDeltaY:Number;			// map y point difference
		private var _geopoints:Array;			// reference points for geolocation
		private var _lastGeoPoint:int;			// last geolocation reference point reached
		
		/**
		 * DISStream constructor.
		 * @param	level	the stream show level
		 * @param	playlistCall	a function to call to download playlist data (must pass playlist id as argument)
		 * @param	parserRun	a function to call for progress code run
		 * @param	getImage	a function to call while looking for an instance reference
		 */
		public function DISStream(level:String, playlistCall:Function, parserRun:Function, getImage:Function) {
			// get data
			this._level = level;
			this._playCall = playlistCall;
			this._parserRun = parserRun;
			this._getImage = getImage;
			this._voteDefault = 0;		// 0 forces the use of the community set
			this._startAfterVote = false;
			this._remoteStreamID = "";
			// prepare data
			this._state = ObjectState.STATE_NOTREADY;
			this._lastupdate = new Date();
			this._author = new AuthorData('', '');
			this._icon = new Sprite();
			this._iconloader = new Loader();
			this._iconloader.contentLoaderInfo.addEventListener(Event.INIT, onIcon);
			this._iconloader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIconError);
			this._category = "";
			this._meta = new Array();
			this._guides = new Array();
			this._voteoptions = new Array();
			for (var ivote:uint = 1; ivote <= 9; ivote++) {
				this._voteoptions.push(new VoteData(ivote));
			}
			this._keyframes = new Array();
			this._navigation = new Array();
			this._votetype = "infinite";
			this._votereference = "60";
			this._loading = false;
			// geolocation
			this._geouse = false;
			this._geomap = "";
			this._geotarget = "";
			this._geolattop = 0;
			this._geolongtop = 0;
			this._geolatbottom = 0;
			this._geolongbottom = 0;
			this._geoXTop = 0;
			this._geoYTop = 0;
			this._geoXBottom = 0;
			this._geoYBottom = 0;
			this._geoDeltaX = 0;
			this._geoDeltaY = 0;
			this._geopoints = new Array();
			this._lastGeoPoint = -1;
			this._pcode = "";
			this._functionA = "";
			this._functionB = "";
			this._functionC = "";
			this._functionD = "";
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
		 * An alternative stream ID to load on remote control.
		 */
		public function get remoteStreamID():String {
			return (this._remoteStreamID);
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
		 * The default vote for group interactions (0 forces the use of the community set).
		 */
		public function get voteDefault():uint {
			return (this._voteDefault);
		}
		
		/**
		 * Should the stream timer start only after the first vote?
		 */
		public function get startAfterVote():Boolean {
			return (this._startAfterVote);
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
		 * Current stream vote type (infinite, defined or instance).
		 */
		public function get votetype():String {
			return (this._votetype);
		}
		
		/**
		 * Current stream vote reference (defined time or instance id).
		 */
		public function get votereference():String {
			return (this._votereference);
		}
		
		/**
		 * Current stream guides (array of StreamData objects).
		 * @see	art.ciclope.managana.data.StreamData
		 */
		public function get guides():Array {
			return (this._guides);
		}
		
		/**
		 * Stream IDs for navigation: xnext, xprev, ynext, yprev, znext and zprev.
		 */
		public function get navigation():Array {
			return (this._navigation);
		}
		
		/**
		 * Current stream category.
		 */
		public function get category():String {
			return (this._category);
		}
		
		/**
		 * Custom meta data values.
		 */
		public function get meta():Array {
			return (this._meta);
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
		 * Current stream vote options (array of VoteData objects).
		 * @see	art.ciclope.managana.data.VoteData
		 */
		public function get voteoptions():Array {
			return (this._voteoptions);
		}
		
		/**
		 * The number of keyframes of the loaded stream.
		 */
		public function get numKeyframes():uint {
			return (this._keyframes.length);
		}
		
		/**
		 * Current stream keyframes (array of DISKeyframe objects).
		 * @see	art.ciclope.managana.data.DISKeyframe
		 */
		public function get keyframes():Array {
			return (this._keyframes);
		}
		
		/**
		 * Use geolocation on mobile devices?
		 */
		public function get geouse():Boolean {
			return (this._geouse);
		}
		
		/**
		 * Geolocation map instance reference.
		 */
		public function get geomap():String {
			return (this._geomap);
		}
		
		/**
		 * Geolocation target instance reference.
		 */
		public function get geotarget():String {
			return(this._geotarget);
		}
		
		/**
		 * Geolocation map upper left point latitude.
		 */
		public function get geolattop():Number {
			return (this._geolattop);
		}
		
		/**
		 * Geolocation map upper left point longitude.
		 */
		public function get geolongtop():Number {
			return(this._geolongtop);
		}
		
		/**
		 * Geolocation map lower right point latitude.
		 */
		public function get geolatbottom():Number {
			return(this._geolatbottom);
		}
		
		/**
		 * Geolocation map lower right point longitude.
		 */
		public function get geolongbottom():Number {
			return(this._geolongbottom);
		}
		
		/**
		 * Number of geolocation reference points.
		 */
		public function get numGeopoints():uint {
			return(this._geopoints.length);
		}
		
		/**
		 * Stream initial progress code.
		 */
		public function get pcode():String {
			return (this._pcode);
		}
		
		/**
		 * Progress code for custom function A.
		 */
		public function get functionA():String {
			return (this._functionA);
		}
		
		/**
		 * Progress code for custom function B.
		 */
		public function get functionB():String {
			return (this._functionB);
		}
		
		/**
		 * Progress code for custom function C.
		 */
		public function get functionC():String {
			return (this._functionC);
		}
		
		/**
		 * Progress code for custom function D.
		 */
		public function get functionD():String {
			return (this._functionD);
		}
		
		/**
		 * Progress code for mouse wheel up.
		 */
		public function get mouseWUp():String {
				return (this._mouseWUp);
		}
		
		/**
		 * Progress code for mouse wheel down.
		 */
		public function get mouseWDown():String {
				return (this._mouseWDown);
		}
		
		// PROPERTIES
		
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
						if (this._state == ObjectState.STATE_LOADING) this._loader.close();
						var data:XML = new XML(cache);
						this.parseStreamData(data);
						cached = true;
					} catch (e:Error) { }
				}
				if (!cached) {
					this._state = ObjectState.STATE_LOADING;
					var request:URLRequest = new URLRequest(this.tryurl);
					request.method = "GET";
					if (this.tryurl.substr(0, 4) != "file") request.data = new URLVariables("nocache=" + new Date().getTime());
					this._loading = true;
					this._loader.load(request);
				}
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Get a custom meta data value. Return null if the meta data is not set.
		 * @param	name	the meta data name
		 * @return	the meta data value or null if it is not set
		 */
		public function getMeta(name:String):String {
			return (this._meta[name]);
		}
		
		/**
		 * Get a geopoint information.
		 * @param	index	the point index
		 */
		public function getGeopoint(index:uint):GeolocationPoint {
			if (index < this._geopoints.length) {
				return (this._geopoints[index] as GeolocationPoint);
			} else {
				return (null);
			}
		}
		
		/**
		 * Replace stream data with an empty stream and call load listeners.
		 */
		public function clean():void {
			// clear
			this.clear();
			// listeners
			this._state = ObjectState.STATE_CLEAN;
			this.dispatchEvent(new Loading(Loading.FINISHED, this, "", LoadedFile.TYPE_XML));
			this.dispatchEvent(new DISLoad(DISLoad.STREAM_OK, this));
		}
		
		/**
		 * Set the current aspect ratio.
		 * @param	to	the new screen aspect ratio
		 */
		public function setAspect(to:String):void {
			if (to == "portrait") this._screenaspect = to;
				else this._screenaspect = "landscape";
			// is current stream suitable to new screen aspect?
			if (!this._loading) {
				if (this._screenaspect == "landscape") {
					if (this._landscape != this._id) {
						this.load(this._landscape);
					}
				}
				if (this._screenaspect == "portrait") {
					if (this._portrait != this._id) {
						this.load(this._portrait);
					}
				}
			}
		}
		
		/**
		 * Set current geolocation data.
		 * @param	latitude	current latitude
		 * @param	longitude	current longitude
		 */
		public function setGeodata(latitude:Number, longitude:Number):void {
			if (this.geouse) {
				// check points
				if (this.numGeopoints > 0) {
					for (var index:uint = 0; index < this.numGeopoints; index++) {
						if (index != this._lastGeoPoint) {
							if ((latitude >= this._geopoints[index].minlat) && (latitude <= this._geopoints[index].maxlat)) {
								if ((longitude >= this._geopoints[index].minlong) && (longitude <= this._geopoints[index].maxlong)) {
									// reference point reached
									this._lastGeoPoint = index;
									this._parserRun(this._geopoints[index].code);
								}
							}
						}
					}
				}
				// place map target
				if ((this.geomap != "") && (this.geotarget != "")) {
					// calculate mercator projection values for current latitude and longitude
					var pointX:Number = NumberFunctions.mercatorX(longitude);
					var pointY:Number = NumberFunctions.mercatorY(latitude);
					// check point position
					var geoMapObject:ManaganaImage = this._getImage(this.geomap);
					var geoTargetObject:ManaganaImage = this._getImage(this.geotarget);
					if ((geoMapObject != null) && (geoTargetObject != null)) {
						// place target on point position
						var newX:Number = Math.round(geoMapObject.x + (geoMapObject.width * ((pointX - this._geoXTop) / this._geoDeltaX)) - (geoTargetObject.width / 2));
						var newY:Number = Math.round(geoMapObject.y + (geoMapObject.height * ((pointY - this._geoYTop) / this._geoDeltaY)) - (geoTargetObject.height / 2));
						if ((newX > (geoMapObject.x + geoMapObject.width)) || (newX < geoMapObject.x) || (newY > (geoMapObject.y + geoMapObject.height)) || (newY < geoMapObject.y)) {
							// point outside map
							this._parserRun("INSTANCE->" + this.geotarget + "->hide|");
						} else {
							// place point
							this._parserRun("INSTANCE->" + this.geotarget + "->set->x->" + newX + "|");
							this._parserRun("INSTANCE->" + this.geotarget + "->set->y->" + newY + "|");
							this._parserRun("INSTANCE->" + this.geotarget + "->show|");
						}
					} else {
						// try to hide the point target
						this._parserRun("INSTANCE->" + this.geotarget + "->hide|");
					}
				}
			}
		}
		
		/**
		 * Release memory used by this object.
		 */
		public function kill():void {
			this._title = null;
			this._remoteStreamID = null;
			this._excerpt = null;
			this._about = null;
			this._iconurl = null;
			this._tags = null;
			this._lastupdate = null;
			this._playCall = null;
			this._author.kill();
			this._author = null;
			this._portrait = null;
			this._landscape = null;
			this._screenaspect = null;
			this._category = null;
			while (this._icon.numChildren > 0) {
				var iconchild:DisplayObject = this._icon.getChildAt(0);
				this._icon.removeChild(iconchild);
				if (iconchild is Bitmap) Bitmap(iconchild).bitmapData.dispose();
				iconchild = null;
			}
			this._icon = null;
			for (var istr:String in this._guides) {
				this._guides[istr].kill();
				delete(this._guides[istr]);
			}
			this._guides = null;
			for (istr in this._meta) {
				delete(this._meta[istr]);
			}
			this._meta = null;
			for (istr in this._navigation) {
				delete(this._navigation[istr]);
			}
			this._navigation = null;
			this._tweening = null;
			this._fade = null;
			this._target = null;
			this._votetype = null;
			this._votereference = null;
			while (this._voteoptions.length > 0) {
				this._voteoptions[0].kill();
				this._voteoptions.shift();
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
			this._geomap = null;
			this._geotarget = null;
			while (this._geopoints.length > 0) {
				this._geopoints[0].kill();
				this._geopoints.shift();
			}
			this._geopoints = null;
			this._parserRun = null;
			this._getImage = null;
			this._pcode = null;
			this._functionA = null;
			this._functionB = null;
			this._functionC = null;
			this._functionD = null;
			this._mouseWUp = null;
			this._mouseWDown = null;
		}
		
		/**
		 * Clear current stream to receive data about a new one.
		 */
		public function clear():void {
			this._id = "";
			this._title = "";
			this._remoteStreamID = "";
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
			this._category = "";
			for (istr in this._meta) {
				delete(this._meta[istr]);
			}
			for (var istr:String in this._guides) {
				this._guides[istr].kill();
				delete(this._guides[istr]);
			}
			for (istr in this._navigation) {
				delete(this._navigation[istr]);
			}
			this._speed = 1;
			this._tweening = "linear";
			this._fade = "fade";
			this._entropy = 0;
			this._distortion = 0;
			this._target = "";
			this._votetype = "infinite";
			this._votereference = "60";
			for (var ivote:uint = 0; ivote < this._voteoptions.length; ivote++) {
				this._voteoptions[ivote].clear(ivote + 1);
			}
			while (this._keyframes.length > 0) {
				this._keyframes[0].kill();
				this._keyframes.shift();
			}
			this._geouse = false;
			this._geomap = "";
			this._geotarget = "";
			this._geolattop = 0;
			this._geolongtop = 0;
			this._geolatbottom = 0;
			this._geolongbottom = 0;
			this._geoXTop = 0;
			this._geoYTop = 0;
			this._geoXBottom = 0;
			this._geoYBottom = 0;
			this._geoDeltaX = 0;
			this._geoDeltaY = 0;
			while (this._geopoints.length > 0) {
				this._geopoints[0].kill();
				this._geopoints.shift();
			}
			this._lastGeoPoint = -1;
			this._pcode = "";
			this._functionA = "";
			this._functionB = "";
			this._functionC = "";
			this._functionD = "";
			this._mouseWUp = "";
			this._mouseWDown = "";
		}
		
		/**
		 * Run a custom function progress code.
		 * @param	name	the code name: A, B, C or D
		 */
		public function runCustomFunction(name:String):void {
			if (name == "A") this._parserRun(this._functionA);
			else if (name == "B") this._parserRun(this._functionB);
			else if (name == "C") this._parserRun(this._functionC);
			else if (name == "D") this._parserRun(this._functionD);
		}
		
		/**
		 * Run the functionassigned to mouse wheel movement.
		 * @param	to	up or down
		 */
		public function runMouseWheel(to:String):void {
			if (to == "up") this._parserRun(this._mouseWUp);
				else if (to == "down") this._parserRun(this._mouseWDown);
		}
		
		// PRIVATE METHODS
		
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
			if ((newxml.child("id").length() == 0) || (newxml.child("meta").length() == 0) || (newxml.child("guides").length() == 0) || (newxml.child("animation").length() == 0) || (newxml.child("voting").length() == 0) || (newxml.child("playlists").length() == 0) || (newxml.child("keyframes").length() == 0)) {
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
				if (newxml.meta[0].child("category").length() > 0) this._category = String(newxml.meta[0].category[0]);
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
				// alternative remote control stream
				if (newxml.child("remote").length() > 0) {
					this._remoteStreamID = String(newxml.remote[0].alternateid);
				}
				// custom meta tags
				for (var imeta:uint = 0; imeta < newxml.meta[0].child("custom").length(); imeta++) {
					this._meta[String(newxml.meta[0].custom[imeta].metaname[0])] = String(newxml.meta[0].custom[imeta].metavalue[0]);
				}
				// geolocation
				if (newxml.child("geolocation").length() > 0) {
					this._geouse = (String(newxml.geolocation[0].geouse) != "0");
					this._geomap = String(newxml.geolocation[0].geomap);
					this._geotarget = String(newxml.geolocation[0].geotarget);
					this._geolattop = Number(newxml.geolocation[0].geolattop);
					this._geolongtop = Number(newxml.geolocation[0].geolongtop);
					this._geolatbottom = Number(newxml.geolocation[0].geolatbottom);
					this._geolongbottom = Number(newxml.geolocation[0].geolongbottom);
					this._geoXTop = NumberFunctions.mercatorX(this.geolongtop);
					this._geoYTop = NumberFunctions.mercatorY(this.geolattop);
					this._geoXBottom = NumberFunctions.mercatorX(this.geolongbottom);
					this._geoYBottom = NumberFunctions.mercatorY(this.geolatbottom);
					this._geoDeltaX = this._geoXBottom - this._geoXTop;
					this._geoDeltaY = this._geoYBottom - this._geoYTop;
					for (var igeo:uint = 0; igeo < newxml.geolocation[0].child("geopoint").length(); igeo++) {
						this._geopoints.push(new GeolocationPoint(String(newxml.geolocation[0].geopoint[igeo].name), Number(newxml.geolocation[0].geopoint[igeo].latitude), Number(newxml.geolocation[0].geopoint[igeo].longitude), String(newxml.geolocation[0].geopoint[igeo].code)));
					}
				}
				// load icon?
				if (this._iconurl != "") this._iconloader.load(new URLRequest(this._iconurl));
				// initial progress code
				if (newxml.child("code").length() > 0) {
					this._pcode = String(newxml.code[0]);
				}
				// custom functions
				if (newxml.child("functions").length() > 0) {
					this._functionA = String(newxml.functions[0].customa);
					this._functionB = String(newxml.functions[0].customb);
					this._functionC = String(newxml.functions[0].customc);
					this._functionD = String(newxml.functions[0].customd);
				}
				// mouse wheel functions
				if (newxml.child("wheel").length() > 0) {
					this._mouseWUp = String(newxml.wheel[0].up);
					this._mouseWDown = String(newxml.wheel[0].down);
				}
				// screen aspect
				this._landscape = this._portrait = this._id;
				if (newxml.child("aspect").length() > 0) {
					if (newxml.aspect[0].child("landscape").length() > 0) this._landscape = String(newxml.aspect[0].landscape[0]);
					if (newxml.aspect[0].child("portrait").length() > 0) this._portrait = String(newxml.aspect[0].portrait[0]);
				}
				// guides
				for (index = 0; index < newxml.guides[0].child("stream").length(); index++) {
					if ((newxml.guides[0].stream[index].hasOwnProperty('@id')) && (newxml.guides[0].stream[index].hasOwnProperty('@type'))) {
						if (this._guides[String(newxml.guides[0].stream[index].@type)] == null) {
							this._guides[String(newxml.guides[0].stream[index].@type)] = new StreamData(String(newxml.guides[0].stream[index]), String(newxml.guides[0].stream[index].@id), String(newxml.guides[0].stream[index].@type));
						}
					}
				}
				// navigation
				this._navigation["xnext"] = this._navigation["xprev"] = this._navigation["ynext"] = this._navigation["yprev"] = this._navigation["znext"] = this._navigation["zprev"] = new String();
				if (newxml.child("navigation").length() > 0) {
					if (newxml.navigation[0].child("xnext").length() > 0) this._navigation["xnext"] = String(newxml.navigation[0].xnext[0]);
					if (newxml.navigation[0].child("xprev").length() > 0) this._navigation["xprev"] = String(newxml.navigation[0].xprev[0]);
					if (newxml.navigation[0].child("ynext").length() > 0) this._navigation["ynext"] = String(newxml.navigation[0].ynext[0]);
					if (newxml.navigation[0].child("yprev").length() > 0) this._navigation["yprev"] = String(newxml.navigation[0].yprev[0]);
					if (newxml.navigation[0].child("znext").length() > 0) this._navigation["znext"] = String(newxml.navigation[0].znext[0]);
					if (newxml.navigation[0].child("zprev").length() > 0) this._navigation["zprev"] = String(newxml.navigation[0].zprev[0]);
				}
				// animation
				if (newxml.animation[0].child("speed").length() > 0) this._speed = uint(newxml.animation[0].speed[0]);
				if (newxml.animation[0].child("tweening").length() > 0) this._tweening = String(newxml.animation[0].tweening[0]);
				if (newxml.animation[0].child("fade").length() > 0) this._fade = String(newxml.animation[0].fade[0]);
				if (newxml.animation[0].child("entropy").length() > 0) this._entropy = uint(newxml.animation[0].entropy[0]);
				if (newxml.animation[0].child("distortion").length() > 0) this._distortion = uint(newxml.animation[0].distortion[0]);
				if (newxml.animation[0].child("target").length() > 0) this._target = String(newxml.animation[0].target[0]);
				// voting
				if (newxml.voting[0].child("type").length() > 0) this._votetype = String(newxml.voting[0].type[0]);
				if (newxml.voting[0].child("reference").length() > 0) this._votereference = String(newxml.voting[0].reference[0]);
				for (var ivote:uint = 0; ivote < newxml.voting[0].child("option").length(); ivote++) {
					if (this._voteoptions[int(newxml.voting[0].option[ivote].@id) - 1] != null) {
						this._voteoptions[int(newxml.voting[0].option[ivote].@id) - 1].num = int(newxml.voting[0].option[ivote].@id);
						this._voteoptions[int(newxml.voting[0].option[ivote].@id) - 1].px = int(newxml.voting[0].option[ivote].@px);
						this._voteoptions[int(newxml.voting[0].option[ivote].@id) - 1].py = int(newxml.voting[0].option[ivote].@py);
						this._voteoptions[int(newxml.voting[0].option[ivote].@id) - 1].visible = (int(newxml.voting[0].option[ivote].@show) != 0);
						this._voteoptions[int(newxml.voting[0].option[ivote].@id) - 1].action = String(newxml.voting[0].option[ivote]);
					}
				}
				// default vote
				this._voteDefault = 0;
				if (newxml.voting[0].child("defaultvote").length() > 0) this._voteDefault = uint(newxml.voting[0].defaultvote);
				// start after vote
				this._startAfterVote = false;
				if (newxml.voting[0].child("startaftervote").length() > 0) this._startAfterVote = (String(newxml.voting[0].startaftervote) == "1");
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
			
			// is this stream correct for current aspect ratio?
			var streamOK:Boolean = true;
			if (this._screenaspect == "landscape") {
				if (this._landscape != this._id) {
					streamOK = false;
					this.load(this._landscape);
				}
			}
			if (this._screenaspect == "portrait") {
				if (this._portrait != this._id) {
					streamOK = false;
					this.load(this._portrait);
				}
			}
			
			// stream load finished
			this._loading = false;
			
			// warn listeners
			if (streamOK) {
				if (loadok) {
					// file correctly loaded
					this._state = ObjectState.STATE_LOADOK;
					this.dispatchEvent(new Loading(Loading.FINISHED, this, this.tryurl, LoadedFile.TYPE_XML));
					this.dispatchEvent(new DISLoad(DISLoad.STREAM_OK, this));
					// run initial progress code
					this._parserRun(this._pcode);
				} else {
					// loaded file does not meet stream file standards
					this._state = ObjectState.STATE_LOADERROR;
					this.dispatchEvent(new Loading(Loading.ERROR_CONTENT, this, this.tryurl, LoadedFile.TYPE_XML));
					this.dispatchEvent(new DISLoad(DISLoad.STREAM_ERROR, this));
				}
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
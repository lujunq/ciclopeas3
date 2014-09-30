package art.ciclope.managana.data {
	
	// FLASH PACKAGES
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.System;
	
	// CICLOPE CLASSES
	import art.ciclope.staticfunctions.StringFunctions;
	import art.ciclope.event.ReaderServerEvent;
	import art.ciclope.managana.ManaganaPlayer;
	
	// EVENTS
	
	/**
     * Error while accessing the Managana server.
     */
    [Event( name = "READER_ERROR", type = "art.ciclope.event.ReaderServerEvent" )]
	/**
     * A message from the Managana player is available.
     */
    [Event( name = "READER_MESSAGE", type = "art.ciclope.event.ReaderServerEvent" )]
	/**
     * Information about a stream was just downloaded.
     */
    [Event( name = "STREAM_INFO", type = "art.ciclope.event.ReaderServerEvent" )]
	/**
     * A stream rating process was completed.
     */
    [Event( name = "STREAM_RATE", type = "art.ciclope.event.ReaderServerEvent" )]
	/**
     * Information about a community was just downloaded.
     */
    [Event( name = "COMMUNITY_INFO", type = "art.ciclope.event.ReaderServerEvent" )]
	/**
     * Information about the Managana server installation was just downloaded.
     */
    [Event( name = "SYSTEM_INFO", type = "art.ciclope.event.ReaderServerEvent" )]
	/**
     * A list of available communities was received.
     */
    [Event( name = "COMMUNITY_LIST", type = "art.ciclope.event.ReaderServerEvent" )]
	/**
     * A list of available streams os a community was received.
     */
    [Event( name = "STREAM_LIST", type = "art.ciclope.event.ReaderServerEvent" )]
	/**
     * Search results data received.
     */
    [Event( name = "SEARCHRESULTS", type = "art.ciclope.event.ReaderServerEvent" )]
	/**
     * User login.
     */
    [Event( name = "USERLOGIN", type = "art.ciclope.event.ReaderServerEvent" )]
	/**
     * User logout.
     */
    [Event( name = "USERLOGOUT", type = "art.ciclope.event.ReaderServerEvent" )]
	/**
     * Notes/bookmarks sync data received.
     */
    [Event( name = "NOTESYNC", type = "art.ciclope.event.ReaderServerEvent" )]
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * ReaderServer provides a connection to a Managana server to be used while reading content.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class ReaderServer extends EventDispatcher {
		
		// VARIABLES
		
		private var _loader:URLLoader;			// data loader
		private var _loaderExtra:URLLoader;		// data loader for login and stream/community lists
		private var _loaderKey:URLLoader;		// data loader for public key
		private var _loaderData:URLLoader;		// data loader saving and loading variables
		private var _loaderOffline:URLLoader;	// data loader for offline content
		private var _lastAction:String;			// last action requested
		private var _streamrate:uint;			// current stream average rate
		private var _userrate:uint;				// current strem rate by user
		private var _logged:Boolean;			// is an user logged?
		private var _usrlevel:int;				// logged user level
		private var _usrmail:String;			// logged user e-mail
		private var _usrname:String;			// logged user name
		private var _remotekey:String;			// key to remote control access
		private var _ready:Boolean;				// is the reader server ready?

		
		// PUBLIC VARIABLES
		
		/**
		 * Reader server URL.
		 */
		public var url:String = "";
		
		/**
		 * URL for social sharing.
		 */
		public var shareurl:String = "";
		
		/**
		 * URL for external feed fetch.
		 */
		public var feedurl:String = "";
		
		/**
		 * URL for id check.
		 */
		public var idcheckurl:String = "";
		
		/**
		 * Reader server access key.
		 */
		public var key:String = "";
		
		/**
		 * Server script file ending.
		 */
		public var serverEnding:String = ".php";
		
		/**
		 * Server request method.
		 */
		public var serverMethod:String = "post";
		
		/**
		 * Manage user statistics?
		 */
		public var stats:Boolean = true;
		
		/**
		 * Allow stream rating?
		 */
		public var rate:Boolean = true;
		
		/**
		 * Stream comment mode.
		 */
		public var comment:String = "free";
		
		/**
		 * Allow stream sharing?
		 */
		public var share:Boolean = true;
		
		/**
		 * Allow search?
		 */
		public var search:Boolean = true;
		
		/**
		 * Allow search on all communities?
		 */
		public var searchall:Boolean = true;
		
		/**
		 * Enable remote control by default?
		 */
		public var remote:Boolean = true;
		
		/**
		 * Allow offline content?
		 */
		public var offline:Boolean = true;
		
		/**
		 * Adobe Cirrus service key.
		 */
		public var cirrus:String = "";
		
		/**
		 * Loaded community ID.
		 */
		public var comid:String = "";
		
		/**
		 * Loaded community name.
		 */
		public var comname:String = "";
		
		/**
		 * Current stream comments.
		 */
		public var streamComments:Array = new Array();
		
		/**
		 * Current stream initial votes.
		 */
		public var streamVotes:Array = new Array();
		
		/**
		 * The last community list received.
		 */
		public var communityList:XML = new XML();
		
		/**
		 * The last stream list received.
		 */
		public var streamList:XML = new XML();
		
		/**
		 * A valid public key for remote control.
		 */
		public var validPKey:String = "";
		
		/**
		 * Last loaded string user values.
		 */
		public var strValues:String = "";
		
		/**
		 * Last loaded number user values.
		 */
		public var numValues:String = "";
		
		/**
		 * Last loaded community values.
		 */
		public var comValues:String = "";
		
		/**
		 * ReaderServer constructor.
		 * @param	url	the Managana server url
		 * @param	key	the Managana server access key
		 * @param	method	the access method to be used
		 * @param	ending	the server script ending
		 */
		public function ReaderServer(url:String, key:String, method:String = "post", ending:String = ".php") {
			this._ready = false;
			this.url = StringFunctions.slashURL(url) + "reader" + ending;
			this.shareurl = StringFunctions.slashURL(url) + "share" + ending;
			this.feedurl = StringFunctions.slashURL(url) + "feed" + ending;
			//this.idcheckurl = StringFunctions.slashURL(url) + "managanalogin" + ending;
			
			this.idcheckurl = StringFunctions.slashURL(url) + "idcheck" + ending;
			
			this.key = key;
			this.serverEnding = ending;
			this.serverMethod = method;
			this._lastAction = "";
			this._streamrate = 0;
			this._userrate = 0;
			this.clear();
			this._loader = new URLLoader();
			this._loader.addEventListener(Event.COMPLETE, onData);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			this._loaderExtra = new URLLoader();
			this._loaderExtra.addEventListener(Event.COMPLETE, onDataExtra);
			this._loaderExtra.addEventListener(IOErrorEvent.IO_ERROR, onError);
			this._loaderExtra.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			this._loaderKey = new URLLoader();
			this._loaderKey.addEventListener(Event.COMPLETE, onDataKey);
			this._loaderKey.addEventListener(IOErrorEvent.IO_ERROR, onError);
			this._loaderKey.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			this._loaderData = new URLLoader();
			this._loaderData.addEventListener(Event.COMPLETE, onDataVariables);
			this._loaderData.addEventListener(IOErrorEvent.IO_ERROR, onError);
			this._loaderData.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			var request:URLRequest = new URLRequest(this.url);
			request.method = this.serverMethod;
			request.data = new URLVariables("key=" + this.key + "&ac=system&managanaVersion=" + ManaganaPlayer.VERSION);
			this._lastAction = "system";
			this._loader.load(request);
			this._loaderOffline = new URLLoader();
			this._loaderOffline.addEventListener(Event.COMPLETE, onOfflineData);
			this._loaderOffline.addEventListener(IOErrorEvent.IO_ERROR, onOfflineError);
			this._loaderOffline.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onOfflineError);
		}
		
		// READ-ONLY VALUES
		
		/**
		 * Is the reader server ready?
		 */
		public function get ready():Boolean {
			return(this._ready);
		}
		
		/**
		 * Last action called by the server.
		 */
		public function get lastAction():String {
			return(this._lastAction)
		}
		
		/**
		 * Current stream user rate.
		 */
		public function get userrate():uint {
			return (this._userrate);
		}
		
		/**
		 * Is an user logged?
		 */
		public function get logged():Boolean {
			return (this._logged);
		}
		
		/**
		 * Logged user level (-1 if no user is logged).
		 */
		public function get usrlevel():int {
			return (this._usrlevel);
		}
		
		/**
		 * Logged user mail.
		 */
		public function get usrmail():String {
			return (this._usrmail);
		}
		
		/**
		 * Logged user name.
		 */
		public function get usrname():String {
			return (this._usrname);
		}
		
		/**
		 * Key for remote controllers.
		 */
		public function get remotekey():String {
			return (this._remotekey);
		}
		
		/**
		 * Current stream rate.
		 */
		public function get streamrate():uint {
			return (this._streamrate);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Get information about a community from the reader server.
		 * @param	id	the community id
		 */
		public function getCommunity(id:String):void {
			if ((this.url != null) && (this.url != "")) {
				var request:URLRequest = new URLRequest(this.url)
				request.method = this.serverMethod;
				request.data = new URLVariables("community=" + id + "&key=" + this.key + "&ac=info");
				this._lastAction = "info";
				this.clear();
				this._loader.load(request);
			}
		}
		
		/**
		 * Get a stream information.
		 * @param	stream	the stream id
		 * @param	category	the stream category
		 * @param	previous	the previous stream id
		 * @param	previousTime	the time spent on previous stream
		 * @param	previousVote	the previous stream voting result
		 * @param	previousCommunity	the previous stream community
		 */
		public function getStream(stream:String, category:String, previous:String = "", previousTime:uint = 0, previousVote:uint = 0, previousCommunity:String = ""):void {
			if ((this.url != null) && (this.url != "") && (this.comid != "") && (stream != "")) {
				var request:URLRequest = new URLRequest(this.url);
				request.data = new URLVariables("community=" + escape(this.comid) + "&key=" + this.key + "&ac=streaminfo" + "&stream=" + escape(stream) + "&category=" + escape(category) + "&previous=" + escape(previous) + "&time=" + previousTime + "&vote=" + previousVote + "&previouscom=" + escape(previousCommunity));
				request.method = this.serverMethod;
				this._lastAction = "streaminfo";
				this._streamrate = 0;
				this._userrate = 0;
				this._loader.load(request);
			}
		}
		
		/**
		 * Rate a stream.
		 * @param	stream	the stream id
		 * @param	category	the stream category
		 * @param	rate	the rate
		 */
		public function rateStream(stream:String, category:String, rate:uint):void {
			if ((this.url != null) && (this.url != "") && (this.comid != "")) {
				var request:URLRequest = new URLRequest(this.url);
				request.data = new URLVariables("community=" + this.comid + "&key=" + this.key + "&ac=rate" + "&stream=" + stream + "&category=" + category + "&rate=" + rate + "&user=" + escape(this._usrmail));
				request.method = this.serverMethod;
				this._lastAction = "rate";
				this._userrate = rate;
				this._loader.load(request);
			}
		}
		
		/**
		 * Do a search on server,
		 * @param	query	the search parameters
		 * @param	allCommunities	search on all communities?
		 */
		public function doSearch(query:String, allCommunities:String):void {
			if ((this.url != null) && (this.url != "") && (this.comid != "")) {
				var request:URLRequest = new URLRequest(this.url);
				request.data = new URLVariables("community=" + this.comid + "&key=" + this.key + "&ac=search" + "&query=" + escape(query) + "&all=" + allCommunities + "&user=" + escape(this._usrmail));
				request.method = this.serverMethod;
				this._lastAction = "search";
				this._loader.load(request);
			}
		}
		
		/**
		 * Remove a note or bookmark entry from the server.
		 * @param	type	note type: note or mark
		 * @param	user	the note owner
		 * @param	id	the note id
		 */
		public function removeNote(type:String, user:String, id:String):void {
			if ((this.url != null) && (this.url != "") && (this.comid != "")) {
				var request:URLRequest = new URLRequest(this.url);
				request.data = new URLVariables("community=" + this.comid + "&key=" + this.key + "&ac=removenote" + "&type=" + escape(type) + "&user=" + escape(user) + "&id=" + escape(id));
				request.method = this.serverMethod;
				this._lastAction = "removenote";
				this._loader.load(request);
			}
		}
		
		/**
		 *Sync user notes or bookmarks.
		 * @param	type	note type: note or mark
		 * @param	user	the note owner
		 * @param	current	current, local notes
		 */
		public function syncNotes(type:String, user:String, current:String):void {
			if ((this.url != null) && (this.url != "") && (this.comid != "")) {
				var request:URLRequest = new URLRequest(this.url);
				request.data = new URLVariables("community=" + this.comid + "&key=" + this.key + "&ac=syncnotes" + "&type=" + escape(type) + "&user=" + escape(user) + "&current=" + escape(current));
				request.method = this.serverMethod;
				this._lastAction = "syncnotes";
				this._loader.load(request);
			}
		}
		
		/**
		 * Add a comment to a stream.
		 * @param	stream	the stream id
		 * @param	category	the stream category
		 * @param	comment	the comment text
		 */
		public function commentStream(stream:String, category:String, comment:String):Boolean {
			if ((this.url != null) && (this.url != "") && (this.comid != "")) {
				var request:URLRequest = new URLRequest(this.url);
				request.data = new URLVariables("community=" + this.comid + "&key=" + this.key + "&ac=comment" + "&stream=" + stream + "&category=" + category + "&comment=" + escape(comment) + "&user=" + escape(this._usrmail));
				request.method = this.serverMethod;
				this._lastAction = "comment";
				this._loader.load(request);
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Ask for a list of communities available.
		 */
		public function getCommunityList():Boolean {
			if ((this.url != null) && (this.url != "") && (this.comid != "")) {
				var request:URLRequest = new URLRequest(this.url);
				request.data = new URLVariables("community=" + this.comid + "&key=" + this.key + "&ac=communitylist");
				request.method = this.serverMethod;
				this._lastAction = "communitylist";
				this._loaderExtra.load(request);
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Ask for a list of communities available.
		 * @param	com	the community to list
		 */
		public function getStreamList(com:String):Boolean {
			if ((this.url != null) && (this.url != "") && (this.comid != "")) {
				var request:URLRequest = new URLRequest(this.url);
				request.data = new URLVariables("community=" + this.comid + "&key=" + this.key + "&ac=streamlist&listcommunity=" + escape(com));
				request.method = this.serverMethod;
				this._lastAction = "streamlist";
				this._loaderExtra.load(request);
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Query server for login confirmation.
		 * @param	loginkey	login key
		 */
		public function doOpenLogin(loginkey:String):void {
			var request:URLRequest = new URLRequest(this.url);
			request.data = new URLVariables("community=" + this.comid + "&key=" + this.key + "&ac=login&loginkey=" + escape(loginkey));
			request.method = this.serverMethod;
			this._lastAction = "login";
			this._loaderExtra.load(request);
		}
		
		/**
		 * Check if a public key is available and valid.
		 * @param	pkey	the public key to check
		 * @param	password	a password to verify if the public key is reserved
		 */
		public function checkPKey(pkey:String, password:String = ""):void {
			var request:URLRequest = new URLRequest(this.url);
			request.data = new URLVariables("key=" + this.key + "&ac=checkpkey&pkey=" + escape(pkey) + "&password=" + escape(password));
			request.method = this.serverMethod;
			this._lastAction = "checkpkey";
			this._loaderKey.load(request);
		}
		
		/**
		 * Register current remote TCP server on the database.
		 * @param	port	the port to connect
		 * @param	id	the published id
		 * @param	akey	the access key
		 * @param	local	local network ip addresses
		 */
		public function registerTCP(port:String, id:String, akey:String, local:String):void {
			var request:URLRequest = new URLRequest(this.url);
			request.data = new URLVariables("key=" + this.key + "&ac=registertcp&akey=" + escape(akey) + "&id=" + escape(id) + "&port=" + escape(port) + "&local=" + escape(local));
			request.method = this.serverMethod;
			this._lastAction = "registertcp";
			this._loaderKey.load(request);
		}
		
		/**
		 * Save current user variables on server.
		 * @param	user	the user name
		 * @param	community	the community to save
		 * @param	strValues	string values
		 * @param	numValues	number values
		 */
		public function saveData(user:String, community:String, strValues:String, numValues:String):void {
			var request:URLRequest = new URLRequest(this.url);
			request.data = new URLVariables("key=" + this.key + "&ac=savedata&saveUsr=" + escape(user) + "&saveCom=" + escape(community) + "&strValues=" + escape(strValues) + "&numValues=" + escape(numValues));
			request.method = this.serverMethod;
			this._lastAction = "savedata";
			this._loaderData.load(request);
		}
		
		/**
		 * Request current user variables load from server.
		 * @param	user	the user name
		 * @param	community	the community to load from
		 */
		public function loadData(user:String, community:String):void {
			var request:URLRequest = new URLRequest(this.url);
			request.data = new URLVariables("key=" + this.key + "&ac=loaddata&saveUsr=" + escape(user) + "&saveCom=" + escape(community));
			request.method = this.serverMethod;
			this._lastAction = "loaddata";
			this.strValues = "";
			this.numValues = "";
			this._loaderData.load(request);
		}
		
		/**
		 * Request current community variables load from server.
		 * @param	community	the community to load from
		 */
		public function loadComValues(community:String):void {
			var request:URLRequest = new URLRequest(this.url);
			request.data = new URLVariables("key=" + this.key + "&ac=getcomvalues&varCom=" + escape(community));
			request.method = this.serverMethod;
			this._lastAction = "getcomvalues";
			this.strValues = "";
			this.numValues = "";
			this._loaderData.load(request);
		}
		
		/**
		 * Save a community value on server.
		 * @param	community	the community to save
		 * @param	varName	the variable name
		 * @param	varValue	the variable value
		 */
		public function saveComValue(community:String, varName:String, varValue:String):void {
			var request:URLRequest = new URLRequest(this.url);
			request.data = new URLVariables("key=" + this.key + "&ac=savecomvalue&varCom=" + escape(community) + "&varName=" + escape(varName) + "&varValue=" + escape(varValue));
			request.method = this.serverMethod;
			this._lastAction = "savecomvalue";
			this.strValues = "";
			this.numValues = "";
			this._loaderData.load(request);
		}
		
		/**
		 * Change a community value on server.
		 * @param	community	the community to save
		 * @param	varName	the variable name
		 * @param	varValue	the variable value
		 * @param	varAction	the operation
		 */
		public function changeComValue(community:String, varName:String, varValue:String, varAction:String):void {
			var request:URLRequest = new URLRequest(this.url);
			request.data = new URLVariables("key=" + this.key + "&ac=changecomvalue&varCom=" + escape(community) + "&varName=" + escape(varName) + "&varValue=" + escape(varValue) + "&varAction=" + escape(varAction));
			request.method = this.serverMethod;
			this._lastAction = "changecomvalue";
			this.strValues = "";
			this.numValues = "";
			this._loaderData.load(request);
		}
		
		/**
		 * Logout current user.
		 * @return	true if the server can accept the request
		 */
		public function doLogout():Boolean {
			if ((this.url != null) && (this.url != "")) {
				var request:URLRequest = new URLRequest(this.url);
				request.data = new URLVariables("community=" + this.comid + "&key=" + this.key + "&ac=logout");
				request.method = this.serverMethod;
				this._lastAction = "logout";
				this._loaderExtra.load(request);
				this._logged = false;
				this._usrlevel = -1;
				this._usrmail = "";
				this._usrname = "";
				this._remotekey = "";
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Get information about the available communities to download.
		 * @return	true if the server can accept the request
		 */
		public function getAvailableOffline():Boolean {
			if ((this.url != null) && (this.url != "")) {
				var request:URLRequest = new URLRequest(this.url);
				request.data = new URLVariables("community=" + this.comid + "&key=" + this.key + "&ac=availableoffline");
				request.method = this.serverMethod;
				this._lastAction = "availableoffline";
				this._loaderOffline.load(request);
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Get offline information for a community.
		 * @return	true if the server can accept the request
		 */
		public function getOfflineCInfo(com:String):Boolean {
			if ((this.url != null) && (this.url != "")) {
				var request:URLRequest = new URLRequest(this.url);
				request.data = new URLVariables("community=" + this.comid + "&key=" + this.key + "&ac=getofflineinfo&com=" + escape(com));
				request.method = this.serverMethod;
				this._lastAction = "getofflineinfo";
				this._loaderOffline.load(request);
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			this._loader.removeEventListener(Event.COMPLETE, onData);
			this._loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			this._loader = null;
			this._loaderExtra.removeEventListener(Event.COMPLETE, onDataExtra);
			this._loaderExtra.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			this._loaderExtra.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			this._loaderExtra = null;
			this._loaderKey.removeEventListener(Event.COMPLETE, onDataKey);
			this._loaderKey.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			this._loaderKey.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			this._loaderKey = null;
			this._loaderData.removeEventListener(Event.COMPLETE, onDataVariables);
			this._loaderData.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			this._loaderData.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			this._loaderData = null;
			this._loaderOffline.removeEventListener(Event.COMPLETE, onOfflineData);
			this._loaderOffline.removeEventListener(IOErrorEvent.IO_ERROR, onOfflineError);
			this._loaderOffline.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onOfflineError);
			this._loaderOffline = null;
			this._lastAction = null;
			comment = null;
			this.comid = null;
			this.comname = null;
			this.url = null;
			this.key = null;
			this.shareurl = null;
			this.feedurl = null;
			this.idcheckurl = null;
			this.serverEnding = null;
			this.serverMethod = null;
			this._usrmail = null;
			this._usrname = null;
			this._remotekey = null;
			while (this.streamComments.length > 0) {
				this.streamComments[0].name = null;
				this.streamComments[0].date = null;
				this.streamComments[0].comment = null;
				this.streamComments.shift();
			}
			while (this.streamVotes.length > 0) this.streamVotes.shift();
			this.streamVotes = null;
			this.streamComments = null;
			System.disposeXML(this.communityList);
			this.communityList = null;
			System.disposeXML(this.streamList);
			this.streamList = null;
			this.strValues = null;
			this.numValues = null;
			this.comValues = null;
		}
		
		// PRIVATE METHODS
		
		/**
		 * Clear current community information.
		 */
		private function clear():void {
			this.comid = "";
			this.comname = "";
			this._logged = false;
			this._usrlevel = -1;
			this._usrmail = "";
			this._usrname = "";
			this._remotekey = "";
			while (this.streamComments.length > 0) {
				this.streamComments[0].name = null;
				this.streamComments[0].date = null;
				this.streamComments[0].comment = null;
				this.streamComments.shift();
			}
			for (var index:uint = 0; index <= 9; index++) {
				this.streamVotes[index] = 0;
			}
		}
		
		/**
		 * Data received from server.
		 */
		private function onData(evt:Event):void {
			// check for errors
			try {
				var data:XML = new XML(this._loader.data);
				// is there an error?
				if (String(data.error) != "0") {
					this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.READER_ERROR));
				} else {
					switch (String(data.action)) {
						case 'system':
							this._ready = true;
							stats = (String(data.stats) == 'true');
							rate = (String(data.rate) == 'true');
							comment = String(data.comment);
							share = (String(data.share) == 'true');
							search = (String(data.search) == 'true');
							searchall = (String(data.searchall) == 'true');
							remote = (String(data.remote) == 'true');
							offline = (String(data.offline) == 'true');
							cirrus = String(data.cirrus);
							this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.SYSTEM_INFO));
							break;
						case 'info': // community information
							this.comid = String(data.id);
							this.comname = String(data.name);
							this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.COMMUNITY_INFO));
							break;
						case 'streaminfo':
							if (String(data.rate) == "") this._streamrate = 0;
								else this._streamrate = uint(Math.round(Number(data.rate)));
							if (String(data.userrate) == "") this._userrate = 0;
								else this._userrate = uint(Math.round(Number(data.userrate)));
							while (this.streamComments.length > 0) {
								this.streamComments[0].name = null;
								this.streamComments[0].date = null;
								this.streamComments[0].comment = null;
								this.streamComments.shift();
							}
							for (var icmt:uint = 0; icmt < data.comments.child('comment').length(); icmt++) {
								this.streamComments.push({ name: String(data.comments.comment[icmt].@name), date: String(data.comments.comment[icmt].@date), comment: String(data.comments.comment[icmt])});
							}
							for (var ivote:uint = 0; ivote < data.votes.child('vote').length(); ivote++) {
								this.streamVotes[uint(data.votes.vote[ivote].@id)] = uint(data.votes.vote[ivote]);
							}
							this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.STREAM_INFO));
							break;
						case 'rate':
							if (String(data.rate) == "") this._streamrate = 0;
								else this._streamrate = uint(Math.round(Number(data.rate)));
							this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.STREAM_RATE));
							this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.READER_MESSAGE, String(data.message)));
							break;
						case 'comment':
							this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.READER_MESSAGE, String(data.message)));
							break;
						case 'search':
							this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.SEARCHRESULTS, String(data.message)));
							break;
						case 'removenote':
							// do nothing
							break;
						case 'syncnotes':
							this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.NOTESYNC, String(data.message)));
							break;
						default: // no action = unexpected return format
							this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.READER_ERROR));
							break;
					}
					System.disposeXML(data);
				}
			} catch (e:Error) {
				this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.READER_ERROR));
			}
		}
		
		/**
		 * Login data received from server.
		 */
		private function onDataExtra(evt:Event):void {
			// check for errors
			try {
				var data:XML = new XML(this._loaderExtra.data);
				// is there an error?
				if (String(data.error) != "0") {
					this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.READER_ERROR));
				} else {
					switch (String(data.action)) {
						case 'login':
							if (uint(data.result) == 1) {
								this._logged = true;
								this._usrlevel = int(data.level);
								this._usrmail = String(data.mail);
								this._usrname = String(data.name);
								this._remotekey = String(data.remotekey);
								this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.USERLOGIN, this._usrmail));
							} else {
								this._logged = false;
								this._usrlevel = -1;
								this._usrmail = "";
								this._usrname = "";
								this._remotekey = "";
								this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.USERLOGOUT));
							}
							this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.READER_MESSAGE, String(data.message)));
							break;
						case "logout":
							this._logged = false;
							this._usrlevel = -1;
							this._usrmail = "";
							this._usrname = "";
							this._remotekey = "";
							this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.USERLOGOUT));
							this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.READER_MESSAGE, String(data.message)));
							break;
						case "communitylist":
							// save the community list received
							System.disposeXML(this.communityList);
							this.communityList = new XML(data.toXMLString());
							// warn listeners
							this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.COMMUNITY_LIST));
							break;
						case "streamlist":
							// save the community list received
							System.disposeXML(this.streamList);
							this.streamList = new XML(data.toXMLString());
							// warn listeners
							this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.STREAM_LIST));
							break;
						default: // no action = unexpected return format
							this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.READER_ERROR));
							break;
					}
					System.disposeXML(data);
				}
			} catch (e:Error) {
				this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.READER_ERROR));
			}
		}
		
		/**
		 * Public key data received from server.
		 */
		private function onDataKey(evt:Event):void {
			// check for errors
			try {
				var data:XML = new XML(this._loaderKey.data);
				// is there an error?
				if (String(data.error) != "0") {
					this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.READER_ERROR));
				} else {
					switch (String(data.action)) {
						case "checkpkey":
							// get the valid public key
							this.validPKey = String(data.pkey);
							// warn listeners
							this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.VALID_PKEY));
							break;
						case "registertcp":
							// do nothing
							break;
						default: // no action = unexpected return format
							this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.READER_ERROR));
							break;
					}
					System.disposeXML(data);
				}
			} catch (e:Error) {
				this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.READER_ERROR));
			}
		}
		
		/**
		 * Variables data received from server.
		 */
		private function onDataVariables(evt:Event):void {
			// check for errors
			try {
				var data:XML = new XML(this._loaderData.data);
				// is there an error?
				if (String(data.error) != "0") {
					this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.READER_ERROR));
				} else {
					switch (String(data.action)) {
						case "savedata":
							// warn listeners
							this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.DATA_SAVED));
							break;
						case "loaddata":
							// warn listeners
							this.strValues = unescape(String(data.strValues));
							this.numValues = unescape(String(data.numValues));
							this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.DATA_LOADED));
							break;
						case "getcomvalues":
							// warn listeners
							var values:URLVariables = new URLVariables();
							for (var icval:uint = 0; icval < data.child('variable').length(); icval++) {
								values[String(data.variable[icval].name)] = String(data.variable[icval].value);
							}
							this.comValues = values.toString();
							this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.COMDATA_LOADED));
							break;
						case "savecomvalue":
						case "changecomvalue":
							// do nothing
							break;
						default: // no action = unexpected return format
							this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.READER_ERROR));
							break;
					}
					System.disposeXML(data);
				}
			} catch (e:Error) {
				this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.READER_ERROR));
			}
		}
		
		/**
		 * Error while accessing the server.
		 */
		private function onError(evt:Event):void {
			if (this._lastAction == "system") {
				this._ready = false;
				this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.NOSYSTEM));
			} else {
				this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.READER_ERROR));
			}
		}
		
		/**
		 * Offline information received.
		 */
		private function onOfflineData(evt:Event):void {
			// check for errors
			try {
				var data:XML = new XML(this._loaderOffline.data);
				// is there an error?
				if (String(data.error) != "0") {
					this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.OFFLINEERROR));
				} else {
					switch (String(data.action)) {
						case "availableoffline":
						case "getofflineinfo":
							// warn listeners
							this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.OFFLINEINFO, data.toString()));
							break;
						default: // no action = unexpected return format
							this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.OFFLINEERROR));
							break;
					}
					System.disposeXML(data);
				}
			} catch (e:Error) {
				this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.OFFLINEERROR));
			}
		}
		
		/**
		 * Offline request error.
		 */
		private function onOfflineError(evt:Event):void {
			this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.OFFLINEERROR));
		}
		
	}

}
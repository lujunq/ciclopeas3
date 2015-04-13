package art.ciclope.managana {
	
	// FLASH PACKAGES
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	import flash.net.SharedObject;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.StageDisplayState;
	import flash.events.NetStatusEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.NetStream;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.GroupSpecifier;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import flash.system.Capabilities;
	
	// CICLOPE CLASSES
	import art.ciclope.managana.data.ReaderServer;
	import art.ciclope.managana.graphics.*;
	import art.ciclope.event.DISLoad;
	import art.ciclope.event.ReaderServerEvent;
	import art.ciclope.event.Message;
	import art.ciclope.event.Playing;
	import art.ciclope.managana.graphics.MessageWindow;
	import art.ciclope.managana.data.ConnectedRemote;
	import art.ciclope.display.GraphicSprite;
	import art.ciclope.event.Loading;
	import art.ciclope.managana.data.SystemLanguage;
	import art.ciclope.managana.data.NoteAndMarkData;
	import art.ciclope.managana.data.OfflineCommunities;
	import art.ciclope.event.CommunityContentEvent;
	import art.ciclope.event.RemoteTCPEvent;
	import art.ciclope.staticfunctions.StringFunctions;
	import art.ciclope.managana.graphics.QRCodeWindow;
	
	// EVENTS
	
	/**
     * A generic message is available.
     */
    [Event( name = "MESSAGE", type = "art.ciclope.event.Message" )]
	/**
     * An user authentication is requested.
     */
    [Event( name = "AUTHENTICATE", type = "art.ciclope.event.Message" )]
    /**
     * There is information available about the community.
     */
    [Event( name = "COMMUNITY_INFO", type = "art.ciclope.event.ReaderServer" )]
    /**
     * Sharing on Facebook is requested.
     */
    [Event( name = "SHARE_FACEBOOK", type = "art.ciclope.event.Message" )]
    /**
     * Sharing on Twitter is requested.
     */
    [Event( name = "SHARE_TWITTER", type = "art.ciclope.event.Message" )]
    /**
     * Sharing on Google+ is requested.
     */
    [Event( name = "SHARE_GPLUS", type = "art.ciclope.event.Message" )]
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * ManaganaInterface provides an user interface for reading Managana content.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class ManaganaInterface extends Sprite {
		
		// CONSTANTS
		
		private const CONNSTATUS_IDLE:String = "CONNSTATUS_IDLE";				// idle connection status
		private const CONNSTATUS_CONNECTED:String = "CONNSTATUS_CONNECTED";		// connected connection status
		private const CONNSTATUS_LOST:String = "CONNSTATUS_LOST";				// lost connection status
		
		// VARIABLES
		
		private var _ready:Boolean;						// is the interface ready?
		private var _mainButton:MainButton;				// the main button
		private var _bar:InterfaceBar;					// the interface bar
		private var _logo:Sprite;						// the community logo
		private var _player:ManaganaPlayer;				// the Managana player reference
		private var _plusmenu:InterfacePlusMenu;		// the plus menu
		private var _commentbt:InterfaceCommentButton;	// the comment button
		private var _notebt:Sprite;						// the notes button
		private var _zoombt:ZoomButton;					// the zoom button
		private var _commentwnd:CommentWindow;			// the comment window
		private var _ratebt:InterfaceRateButton;		// the rate button
		private var _ratewnd:RateWindow;				// the rate window
		private var _reader:ReaderServer;				// reader server
		private var _messagewnd:MessageWindow;			// the message window
		private var _addcommentwnd:AddCommentWindow;	// add comment window
		private var _searchwnd:SearchWindow;			// search window interface
		private var _noteswnd:NotesAndMarkWindow;		// notes window interface
		private var _offlinewnd:OfflineWindow;			// offline communities interface
		private var _time:TimeButton;					// the time button
		private var _ondevice:Boolean;					// running on a mobile device?
		private var _restartplay:Boolean;				// restart playback after returning from comment, rate or login?
		private var _timer:Timer;						// a timer for clock update
		private var _communitystart:String;				// an initial community to load after system data
		private var _waitsystem:Boolean;				// waiting for system data return?
		private var _previousStream:String;				// the previously loaded stream
		private var _previousTime:uint;					// the time spent on previously loaded stream
		private var _previousCom:String;				// the previous stream community
		private var _playActivate:Boolean;				// resume content play when closing a window?
		private var _forceVisible:Boolean;				// interface visibility
		private var _forceShowTime:Boolean;				// clock visibility
		private var _forceVote:Boolean;					// voting layer visibility
		private var _forceComment:Boolean;				// comment button visibility
		private var _forceRate:Boolean;					// rate button visibility
		private var _forceNote:Boolean;					// notes button visibility
		private var _forceZoom:Boolean;					// zoom buttons visibility
		private var _forceUser:Boolean;					// user name visibility
		private var _showPlay:Boolean;					// show play/pause graphic close to the clock?
		private var _publicRemote:String;				// connect key for public remote service
		private var _publicPass:String;					// password for reserved connect keys
		private var _cirrus:String;						// Adobe Cirrus service key
		private var _remoteGroup:String;				// remote connection group name
		private var _myPeer:String;						// peer id for this player while connected to Adobe Cirrus service
		private var _ncremote:NetConnection;			// Adobe Cirrus connection for remote control (beta)
		private var _outstream:NetStream;				// output stream for Cirrus service
		private var _remoteLoader:URLLoader;			// loader for remote control peer check
		private var _remotes:Array;						// connected remote controllers
		private var _remoteStatus:String;				// current remote connection status
		private var _remoteStatusInterval:int;			// interval for local connection retry
		private var _allowRemote:Boolean;				// allow remote control?
		private var _nclocal:NetConnection;				// connection for local network controllers
		private var _netgroup:NetGroup;					// local connected group
		private var _localStatus:String;				// current local connection status
		private var _localStatusInterval:int;			// interval for local connection retry
		private var _language:SystemLanguage;			// the language strings to use on interface text
		private var _uiwarning:UIWarning;				// user interface warnings
		private var _offline:OfflineCommunities;		// a manager for offline content
		private var _premotestart:Array;				// public remote start info
		private var _tcpRemote:Object;					// tcp remote control manager
		private var _noSystemAtStage:Boolean;			// start with no system info when stage is available?
		
		private var _qrcode:QRCodeWindow;				// the qrcode display window
		
		private var _useHolder:Boolean = false;
		private var _holder:Sprite;
		private var _holderBG:Shape;
		
		// PUBLIC VARIABLES
		
		/**
		 * Prefix for the remote control group.
		 */
		public var remoteGroup:String = "Managana";
		/**
		 * Adobe Cirrus service key (beta).
		 */
		public var cirrusKey:String = "";
		/**
		 * Local network remote controller multicast ip.
		 */
		public var multicastip:String = "225.225.0.1";
		/**
		 * Local network remote controller multicast port.
		 */
		public var multicastport:String = "09876";
		/**
		 * Access key for TCP remote control.
		 */
		public var remoteTcpKey:String = "Managana";
		/**
		 * Port for TCP remote control.
		 */
		public var remoteTcpPort:String = "12123";
		/**
		 * Use a defined position when reseting size/position? (false means screen center)
		 */
		public var positionOnReset:Boolean = false;
		/**
		 * If positionOnReset is true, the X position to place content on reset.
		 */
		public var resetX:int = 0;
		/**
		 * If positionOnReset is true, the Y position to place content on reset.
		 */
		public var resetY:int = 0;
		/**
		 * Show system warning messages?
		 */
		public var showWarningMessages:Boolean = true;
		/**
		 * Allow zoom and position on remote control?
		 */
		public var allowZoomPosition:Boolean = true;
		/**
		 * A system function to handle notes and bookmarks saving.
		 */
		public var systemNotes:Function;
		/**
		 * Keep checking for keyboard activation?
		 */
		public var checkKeyboard:Boolean = true;
		
		// STATIC VARIABLES
		
		/**
		 * Lock extra interface features (content manager and plus menu)?
		 */
		public static var lockExtra:Boolean = false;
		
		/**
		 * ManaganaInterface constructor.
		 * @param	readerurl	the url of the Managana server
		 * @param	readerkey	the access key to the Managana server
		 * @param	readermethod	the server access method
		 * @param	readerending	the server scripts ending
		 * @param	ondevice	is system running on a mobile device?
		 * @param	forceVisible	interface visibility (0 = use server definition, 1= always visible, 2 = always hidden)
		 * @param	forceShowTime	interface visibility (0 = use server definition, 1= always visible, 2 = always hidden)
		 * @param	forceVote	voting layer visibility: (0 = use server definition, 1= always visible, 2 = always hidden)
		 * @param	showPlay	show play/pause graphic close to the clock?
		 * @param	savefunction	a function for offline save content
		 * @param	getfunction	a function for offline get content
		 */
		public function ManaganaInterface(readerurl:String = "", readerkey:String = "", readermethod:String = "post", readerending:String = ".php", ondevice:Boolean = false, forceVisible:Boolean = true, forceShowTime:Boolean = true, forceVote:Boolean = false, showPlay:Boolean = true, forceComment:Boolean = false, forceRate:Boolean = false, forceNotes:Boolean = false, forceZoom:Boolean = false, forceUser:Boolean = false, savefunction:Function = null, getfunction:Function = null, useHolder:Boolean = false, holder:Sprite = null, holderBG:Shape = null) {
			this._noSystemAtStage = false;
			this.visible = false;
			this._premotestart = new Array();
			this._premotestart["id"] = "";
			this._forceVisible = forceVisible;
			this._forceShowTime = forceShowTime;
			this._forceVote = forceVote;
			this._forceComment = forceComment;
			this._forceRate = forceRate;
			this._forceNote = forceNotes;
			this._forceZoom = forceZoom;
			this._forceUser = forceUser;
			this._showPlay = showPlay;
			this._allowRemote = true;
			this._waitsystem = true;
			this._communitystart = "";
			this._previousCom = "";
			this._previousStream = "";
			this._previousTime = 0;
			this._publicRemote = "";
			this._myPeer = "";
			this._remoteStatus = CONNSTATUS_IDLE;
			this._localStatus = CONNSTATUS_IDLE;	
			this._ready = false;
			this._remotes = new Array();
			
			this._useHolder = useHolder;
			this._holder = holder;
			this._holderBG = holderBG;
			
			if (readerurl != "") {
				this._reader = new ReaderServer(readerurl, readerkey, readermethod, readerending);
				this._reader.addEventListener(ReaderServerEvent.READER_ERROR, onReaderError);
				this._reader.addEventListener(ReaderServerEvent.READER_MESSAGE, onReaderMessage);
				this._reader.addEventListener(ReaderServerEvent.SYSTEM_INFO, onSystemInfo);
				this._reader.addEventListener(ReaderServerEvent.NOSYSTEM, noSystem);
				this._reader.addEventListener(ReaderServerEvent.COMMUNITY_INFO, onCommunityInfo);
				this._reader.addEventListener(ReaderServerEvent.STREAM_INFO, onStreamInfo);
				this._reader.addEventListener(ReaderServerEvent.STREAM_RATE, onStreamRate);
				this._reader.addEventListener(ReaderServerEvent.COMMUNITY_LIST, onCommunityList);
				this._reader.addEventListener(ReaderServerEvent.STREAM_LIST, onStreamList);
				this._reader.addEventListener(ReaderServerEvent.VALID_PKEY, onPublicKey);
				this._reader.addEventListener(ReaderServerEvent.DATA_SAVED, onDataSaved);
				this._reader.addEventListener(ReaderServerEvent.DATA_LOADED, onDataLoaded);
				this._reader.addEventListener(ReaderServerEvent.COMDATA_LOADED, onComDataLoaded);
				if ((savefunction != null) && (getfunction != null)) this.setOffline(savefunction, getfunction);
			} else {
				// start with no system information
				if ((savefunction != null) && (getfunction != null)) this.setOffline(savefunction, getfunction);
				//this.noSystem(null);
				this._noSystemAtStage = true;
			}
			this._ondevice = ondevice;
			this._logo = new Sprite();
			var icon:Sprite = new ManaganaLogo() as Sprite;
			this._logo.addChild(icon);
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this._restartplay = true;
			this._timer = new Timer(1000);
			this._timer.addEventListener(TimerEvent.TIMER, onTimer);
			this._timer.start();
			
			// prepare qrcode display
			this._qrcode = new QRCodeWindow();
		}
		
		/**
		 * The stage became available.
		 */
		private function onStage(evt:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			this.x = this.y = 0;
			this._playActivate = true;
			// prepare graphics
			this._mainButton = new MainButton();
			this.addChild(this._mainButton);
			this._bar = new InterfaceBar(this._ondevice);
			this.addChild(this._bar);
			this._bar.visible = false;
			this._bar.player = this._player;
			this._bar.fullclick = this.fullClick;
			this._bar.offlineclick = this.onOfflineClick;
			this._bar.homeclick = this.homeClick;
			this.addChild(this._logo);
			this._logo.addEventListener(MouseEvent.CLICK, onLogoClick);
			this._logo.buttonMode = true;
			this._logo.useHandCursor = true;
			
			this._mainButton.visible = this._forceVisible;
			this._logo.visible = this._forceVisible;
			
			/*if (this._reader == null) {
				if (this._forceVisible) {
					this._mainButton.visible = true;
					this._logo.visible = true;
				} else {
					this._mainButton.visible = false;
					this._logo.visible = false;
				}
			} else {
				
			}*/
			this._mainButton.userVisible = this._forceUser;
			this._time = new TimeButton(this._showPlay);
			this._time.visible = this._forceShowTime;
			this._time.addEventListener(MouseEvent.CLICK, onTimeClick);
			this.addChild(this._time);
			this._plusmenu = new InterfacePlusMenu(this._reader != null);
			this._plusmenu.visible = false;
			this.addChild(this._plusmenu);
			if (this._reader == null) {
				this._forceComment = false;
				this._forceRate = false;
			}
			this._bar.plusmenu = this._plusmenu;
			this._bar.plusmenuToggle = this.togglePlus;
			this._plusmenu.commentclick = this.toggleComment;
			this._plusmenu.rateclick = this.toggleRate;
			this._plusmenu.noteclick = this.toggleNotes;
			this._plusmenu.zoomclick = this.toggleZoom;
			this._plusmenu.timeclick = this.toggleTime;
			this._plusmenu.userclick = this.toggleUsername;
			this._plusmenu.voteclick = this.toggleVote;
			this._plusmenu.remoteclick = this.toggleRemote;
			this._plusmenu.logoutclick = this.doLogout;
			this._plusmenu.loginclick = this.showLogin;
			this._plusmenu.facebookclick = this.onFacebook;
			this._plusmenu.twitterclick = this.onTwitter;
			this._plusmenu.gplusclick = this.onGPlus;
			this._plusmenu.searchclick = this.onOpenSearch;
			this._plusmenu.checkButtons(this._forceRate, this._forceComment, this._forceShowTime, this._forceVote, this._forceZoom, this._forceNote, this._forceUser);
			if (this._useHolder) this._commentbt = new InterfaceCommentButton(this._holderBG.width, this._holderBG.height);
				else this._commentbt = new InterfaceCommentButton(this.stage.stageWidth, this.stage.stageHeight);
			this._commentbt.visible = false;
			this._commentbt.addEventListener(MouseEvent.CLICK, onCommentClick);
			this.addChild(this._commentbt);
			if (this._useHolder) this._commentwnd = new CommentWindow(this._holderBG.width, this._holderBG.height);
				else this._commentwnd = new CommentWindow(this.stage.stageWidth, this.stage.stageHeight);
			this._commentwnd.visible = false;
			this._commentwnd.addaction = this.onAddComment;
			this._commentwnd.addEventListener(Event.CLOSE, onWindowClose);
			this.addChild(this._commentwnd);
			if (this._useHolder) this._ratebt = new InterfaceRateButton(this._holderBG.width, this._holderBG.height);
				else this._ratebt = new InterfaceRateButton(this.stage.stageWidth, this.stage.stageHeight);
			this._ratebt.visible = false;
			this._ratebt.addEventListener(MouseEvent.CLICK, onRateClick);
			this.addChild(this._ratebt);
			if (this._useHolder) this._ratewnd = new RateWindow(this._holderBG.width, this._holderBG.height);
				else this._ratewnd = new RateWindow(this.stage.stageWidth, this.stage.stageHeight);
			this._ratewnd.visible = false;
			this._ratewnd.onRate = this.onRate;
			this._ratewnd.addEventListener(Event.CLOSE, onWindowClose);
			this.addChild(this._ratewnd);
			this._notebt = new NotesButton() as Sprite;
			ManaganaInterface.setSize(this._notebt);
			this._notebt.useHandCursor = true;
			this._notebt.buttonMode = true;
			this._notebt.visible = false;
			this._notebt.addEventListener(MouseEvent.CLICK, onNoteClick);
			this.addChild(this._notebt);
			this._zoombt = new ZoomButton(this.zoomAction);
			this._zoombt.visible = true;
			this.addChild(this._zoombt);
			if (this._useHolder) this._addcommentwnd = new AddCommentWindow(this._holderBG.width, this._holderBG.height);
				else this._addcommentwnd = new AddCommentWindow(this.stage.stageWidth, this.stage.stageHeight);
			this._addcommentwnd.visible = false;
			this._addcommentwnd.addaction = this.onComment;
			this.addChild(this._addcommentwnd);
			if (this._useHolder) this._searchwnd = new SearchWindow(this._holderBG.width, this._holderBG.height);
				else this._searchwnd = new SearchWindow(this.stage.stageWidth, this.stage.stageHeight);
			this._searchwnd.reader = this._reader;
			this._searchwnd.managana = this._player;
			this.addChild(this._searchwnd);
			if (this._useHolder) this._noteswnd = new NotesAndMarkWindow(NoteAndMarkData.TYPE_NOTE, this._holderBG.width, this._holderBG.height, this.systemNotes);
				else this._noteswnd = new NotesAndMarkWindow(NoteAndMarkData.TYPE_NOTE, this.stage.stageWidth, this.stage.stageHeight, this.systemNotes);
			this._noteswnd.reader = this._reader;
			this._noteswnd.managana = this._player;
			this.addChild(this._noteswnd);
			if (this._useHolder) this._offlinewnd = new OfflineWindow(this._holderBG.width, this._holderBG.height);
				else this._offlinewnd = new OfflineWindow(this.stage.stageWidth, this.stage.stageHeight);
			this._offlinewnd.reader = this._reader;
			this._offlinewnd.managana = this._player;
			this.addChild(this._offlinewnd);
			if (this._offline != null) this._offlinewnd.setOffline(this._offline);
			if (this._useHolder) this._messagewnd = new MessageWindow(this._holderBG.width, this._holderBG.height);
				else this._messagewnd = new MessageWindow(this.stage.stageWidth, this.stage.stageHeight);
			this._messagewnd.visible = false;
			this.addChild(this._messagewnd);
			if (this._useHolder) this._uiwarning = new UIWarning(this._holderBG.width, this._holderBG.height);
				else  this._uiwarning = new UIWarning(this.stage.stageWidth, this.stage.stageHeight);
			this.addChild(this._uiwarning);
			// adjust size
			this._ready = true;
			this.redraw();
			// no system info?
			if (this._noSystemAtStage) this.noSystem(null);
		}
		
		// STATIC PROPERTIES
		
		/**
		 * A multiplier for interface assets.
		 */
		public static function get assetScale():Number {
			var scale:Number = 1.0;
			var add:Number = Capabilities.screenDPI - 150;
			while (add > 0) {
				add -= 40;
				scale += 0.1;
			}
			return (scale);
		}
		
		// STATIC FUNCTIONS
		
		/**
		 * Set a graphic asset scale based on screen dpi.
		 * @param	gr	a display object to scale
		 */
		public static function setScale(gr:DisplayObject):void {
			gr.scaleX = gr.scaleY = ManaganaInterface.assetScale;
		}
		
		/**
		 * Top position for interface windows.
		 * @param	closebt	close window button reference, if any
		 */
		public static function windowTop(closebt:DisplayObject = null):Number {
			if (closebt != null) return (ManaganaInterface.newSize(62) + (closebt.height / 2));
				else return (ManaganaInterface.newSize(65));
		}
		
		/**
		 * Set a graphic asset size based on screen dpi.
		 * @param	gr	a display object to scale
		 */
		public static function setSize(gr:DisplayObject):void {
			gr.width = gr.width * ManaganaInterface.assetScale;
			gr.height = gr.height * ManaganaInterface.assetScale;
		}
		
		/**
		 * A new size based on current screen dpi.
		 * @param	original	the original size
		 * @return	size suitable for current screen dpi
		 */
		public static function newSize(original:uint):uint {
			return (uint(Math.round(original * ManaganaInterface.assetScale)));
		}
		
		// READ-ONLY VALUES
		
		/**
		 * Is there any remote control connected?
		 * @return	true if there is at least one remote control connected
		 */
		public function hasRemotes():Boolean {
			if (this._remotes == new Array()) {
				if (this._tcpRemote != null) {
					return (this._tcpRemote.clients != 0);
				} else {
					return (false);
				}
			} else {
				return (true);
			}
		}
		
		// PROPERTIES
		
		/**
		 * The Managana player reference.
		 */
		public function get player():ManaganaPlayer {
			return (this._player);
		}
		public function set player(to:ManaganaPlayer):void {
			// remove previous player
			if (this._player != null) {
				this._player.removeEventListener(DISLoad.COMMUNITY_LOAD, onCommunityLoad);
				this._player.removeEventListener(DISLoad.STREAM_LOAD, onStreamLoad);
				this._player.removeEventListener(DISLoad.COMMUNITY_OK, onCommunityOK);
				this._player.removeEventListener(DISLoad.STREAM_OK, onStreamOK);
				this._player.removeEventListener(DISLoad.COMMUNITY_ERROR, onCommunityERROR);
				this._player.removeEventListener(DISLoad.STREAM_ERROR, onStreamERROR);
				this._player.removeEventListener(Playing.MEDIA_PLAY, onPlay);
				this._player.removeEventListener(Playing.MEDIA_PAUSE, onPause);
				this._player.removeEventListener(Message.SAVEDATA, saveData);
				this._player.removeEventListener(Message.LOADDATA, loadData);
				this._player.removeEventListener(Message.LOADCOMVALUES, loadComValues);
				this._player.removeEventListener(Message.SAVECOMVALUE, saveComValue);
				this._player.removeEventListener(Message.CHANGECOMVALUE, changeComValue);
				this._player.interfaceMessage = null;
			}
			// set new player
			this._player = to;
			this._player.voteVisible = false;
			this._player.addEventListener(DISLoad.COMMUNITY_LOAD, onCommunityLoad);
			this._player.addEventListener(DISLoad.STREAM_LOAD, onStreamLoad);
			this._player.addEventListener(DISLoad.COMMUNITY_OK, onCommunityOK);
			this._player.addEventListener(DISLoad.STREAM_OK, onStreamOK);
			this._player.addEventListener(DISLoad.COMMUNITY_ERROR, onCommunityERROR);
			this._player.addEventListener(DISLoad.STREAM_ERROR, onStreamERROR);
			this._player.addEventListener(Playing.MEDIA_PLAY, onPlay);
			this._player.addEventListener(Playing.MEDIA_PAUSE, onPause);
			this._player.addEventListener(Message.SAVEDATA, saveData);
			this._player.addEventListener(Message.LOADDATA, loadData);
			this._player.addEventListener(Message.LOADCOMVALUES, loadComValues);
			this._player.addEventListener(Message.SAVECOMVALUE, saveComValue);
			this._player.addEventListener(Message.CHANGECOMVALUE, changeComValue);
			this._player.interfaceMessage = this.playerMessage;
			if (this._ready) {
				this._bar.player = this._player;
				this._searchwnd.managana = this._player;
				this._noteswnd.managana = this._player;
				this._offlinewnd.managana = this._player;
			}
		}
		
		// PUBLIC METHODS
		
		public function setTCP(tcp:Object):void {
			this._tcpRemote = tcp;
			this._tcpRemote.setReader(this._reader);
			this._tcpRemote.addEventListener(RemoteTCPEvent.ACTION, onRemoteTCP);
		}
		
		/**
		 * Set the interface logo.
		 * @param	to	a display object to use as logo image or a string with a picture url - leave null for standard Managana logo
		 */
		public function setLogo(to:* = null):void {
			while (this._logo.numChildren > 0) {
				var child:* = this._logo.getChildAt(0);
				this._logo.removeChild(child);
				if (child is Bitmap) Bitmap(child).bitmapData.dispose();
			}
			if (to == null) {
				var icon:Sprite = new ManaganaLogo() as Sprite;
				ManaganaInterface.setSize(icon);
				this._logo.addChild(icon);
			} else if (to is String) {
				var newLogo:GraphicSprite = new GraphicSprite(ManaganaInterface.newSize(60), ManaganaInterface.newSize(60), String(to));
				newLogo.smoothing = true;
				newLogo.addEventListener(Loading.FINISHED, logoLoadOK);
				this._logo.addChild(newLogo);
			} else {
				this._logo.addChild(to as DisplayObject);
			}
			this.redraw();
		}
		
		/**
		 * Close Managana interface.
		 */
		public function closeInterface():void {
			this._plusmenu.visible = false;
			this._bar.showPlus(true);
			this._commentwnd.visible = false;
			this._messagewnd.visible = false;
			this._addcommentwnd.visible = false;
			this._searchwnd.visible = false;
			this._noteswnd.visible = false;
			this._offlinewnd.visible = false;
			this._bar.visible = false;
			this._time.bgVisible = !this._bar.visible;
			this._mainButton.visible = true;
		}
		
		/**
		 * Custom logo size adjust.
		 * @param	evt
		 */
		private function logoLoadOK(evt:Loading):void {
			var newLogo:GraphicSprite = evt.target as GraphicSprite;
			newLogo.removeEventListener(Loading.FINISHED, logoLoadOK);
			this._logo.width = this._logo.height = this._mainButton.height - 4;
			this._logo.x = this._mainButton.x + ((MainButton.minWidth - this._logo.width) / 2);
			this._logo.y = this._mainButton.y + 2;
		}
		
		/**
		 * Start the offline content handling.
		 * @param	savefunction	a function to save data
		 * @param	getfunction	a function to load data
		 */
		public function setOffline(savefunction:Function, getfunction:Function):void {
			this._offline = new OfflineCommunities(savefunction, getfunction, this._reader);
			this._offline.addEventListener(CommunityContentEvent.UPDATE_AVAILABLE, onOfflineUpdate);
			this._offline.addEventListener(CommunityContentEvent.DOWNLOAD_ALL, onDownloadAll);
			if (this._offlinewnd != null) this._offlinewnd.setOffline(this._offline);
		}
		
		/**
		 * Get a translated interface text.
		 * @param	name	the text reference name
		 * @return	the translated text for current language
		 */
		public function getText(name:String):String {
			if (this._language != null) return (this._language.getText(name));
				else return ("");
		}
		
		/**
		 * Check online and offline content download on app resume.
		 */
		public function checkContent():void {
			this._offline.checkContent();
		}
		
		/**
		 * Show the message window.
		 * @param	text	the text to show
		 */
		public function showMessage(text:String):void {
			if (text != "") {
				this._messagewnd.setText(text);
				this._messagewnd.visible = this.showWarningMessages;
				this._ratewnd.visible = false;
				this._commentwnd.visible = false;
				this._plusmenu.visible = false;
				this._addcommentwnd.visible = false;
				this._searchwnd.visible = false;
				this._noteswnd.visible = false;
				this._offlinewnd.visible = false;
				this._bar.showPlus(true);
				this._bar.visible = false;
				this._time.bgVisible = !this._bar.visible;
				this._mainButton.visible = true; 
			}
		}
		
		/**
		 * Redraw the interface.
		 */
		public function redraw():void {
			if (this._ready) {
				this._mainButton.x = this._mainButton.y = 5;
				this._bar.x = this._bar.y = 5;
				this._bar.redraw(MainButton.minWidth);
				this._logo.width = this._logo.height = this._mainButton.height - 4;
				this._logo.x = this._mainButton.x + ((MainButton.minWidth - this._logo.width) / 2);
				this._logo.y = this._mainButton.y + 2;
				this._time.redraw();
				var refSize:Point = new Point(this.stage.stageWidth, this.stage.stageHeight);
				if (this._useHolder) {
					refSize.x = this._holderBG.width;
					refSize.y = this._holderBG.height;
				}
				this._commentbt.redraw(refSize);
				this._commentwnd.redraw(refSize);
				this._ratebt.redraw(refSize);
				this._ratewnd.redraw(refSize);
				this._messagewnd.redraw(refSize);
				this._addcommentwnd.redraw(refSize);
				this._searchwnd.redraw(refSize);
				this._noteswnd.redraw(refSize);
				this._offlinewnd.redraw(refSize);
				this._notebt.y = this._commentbt.y;
				this._zoombt.y = this._ratebt.y;
				if (this._useHolder) {
					this._zoombt.x = this._holderBG.width - this._zoombt.width - 5;
					if (this._ratebt.visible && this._zoombt.visible) this._ratebt.x = ((this._holderBG.width / 3) * 2) - (this._ratebt.width /2);
				} else {
					this._zoombt.x = this.stage.stageWidth - this._zoombt.width - 5;
					if (this._ratebt.visible && this._zoombt.visible) this._ratebt.x = ((this.stage.stageWidth / 3) * 2) - (this._ratebt.width /2);
				}
				this._uiwarning.redraw(refSize);
				this._qrcode.redraw(this.stage.stageWidth, this.stage.stageHeight);
			}
		}
		
		/**
		 * Show the login window.
		 */
		private function showLogin():void {
			if (this._reader != null) {
				this._plusmenu.visible = false;
				this._commentwnd.visible = false;
				this._ratewnd.visible = false;
				this._messagewnd.visible = false;
				this._addcommentwnd.visible = false;
				this._searchwnd.visible = false;
				this._noteswnd.visible = false;
				this._offlinewnd.visible = false;
				this._bar.showPlus(true);
				this._bar.visible = false;
				this._time.bgVisible = !this._bar.visible;
				this._mainButton.visible = true;
				this.dispatchEvent(new Message(Message.AUTHENTICATE, { value:this._reader.idcheckurl } ));
			}
		}
		
		/**
		 * Check server for OpenID/oAuth authentication.
		 * @param	key	login key
		 */
		public function doOpenLogin(loginkey:String):void {
			if (this._reader != null) this._reader.doOpenLogin(loginkey);
		}
		
		/**
		 * Receive messages from the Managana player.
		 * @param	message	the message ID
		 * @param	args	arguments for the message, if required
		 */
		public function playerMessage(message:String, args:Object = null):void {
			switch (message) {
				case "showClock":
					this.toggleTime(true);
					break;
				case "hideClock":
					this.toggleTime(false);
					break;
				case "showRate":
					this.toggleRate(true);
					break;
				case "hideRate":
					this.toggleRate(false);
					break;
				case "showComments":
					this.toggleComment(true);
					break;
				case "hideComments":
					this.toggleComment(false);
					break;
				case "showZoom":
					this.toggleZoom(true);
					break;
				case "hideZoom":
					this.toggleZoom(false);
					break;
				case "showNotes":
					this.toggleNotes(true);
					break;
				case "hideNotes":
					this.toggleNotes(false);
					break;
			}
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			if (this._ready) {
				this.removeChild(this._bar);
				this._bar.kill();
				this._bar = null;
				this.removeChild(this._mainButton);
				this._mainButton.kill();
				this._mainButton = null;
				this.removeChild(this._time);
				this._time.kill();
				this._time = null;
				this._previousStream = null;
				this._previousCom = null;
				while (this._logo.numChildren > 0) {
					var child:* = this._logo.getChildAt(0);
					this._logo.removeChild(child);
					if (child is Bitmap) Bitmap(child).bitmapData.dispose();
				}
				this._logo.removeEventListener(MouseEvent.CLICK, onLogoClick);
				this.removeChild(this._logo);
				this._logo = null;
				this.removeChild(this._plusmenu);
				this._plusmenu.kill();
				this._plusmenu = null;
				this.removeChild(this._commentbt);
				this._commentbt.removeEventListener(MouseEvent.CLICK, onCommentClick);
				this._commentwnd.removeEventListener(Event.CLOSE, onWindowClose);
				this._commentbt.kill();
				this._commentbt = null;
				this.removeChild(this._commentwnd);
				this._commentwnd.kill();
				this._commentwnd = null;
				this.removeChild(this._ratebt);
				this._ratebt.removeEventListener(MouseEvent.CLICK, onRateClick);
				this._ratebt.kill();
				this._ratebt = null;
				this.removeChild(this._ratewnd);
				this._ratewnd.removeEventListener(Event.CLOSE, onWindowClose);
				this._ratewnd.kill();
				this._ratewnd = null;
				this.removeChild(this._messagewnd);
				this._messagewnd.kill();
				this._messagewnd = null;
				this.removeChild(this._addcommentwnd);
				this._addcommentwnd.kill();
				this._addcommentwnd = null;
				this.removeChild(this._searchwnd);
				this._searchwnd.kill();
				this._searchwnd = null;
				this.removeChild(this._noteswnd);
				this._noteswnd.kill();
				this._noteswnd = null;
				this.removeChild(this._offlinewnd);
				this._offlinewnd.kill();
				this._offlinewnd = null;
				this._uiwarning.kill();
				this.removeChild(this._zoombt);
				this._zoombt.kill();
				this._zoombt = null;
			} else {
				this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			}
			if (this._offline != null) {
				this._offline.removeEventListener(CommunityContentEvent.UPDATE_AVAILABLE, onOfflineUpdate);
				this._offline.removeEventListener(CommunityContentEvent.DOWNLOAD_ALL, onDownloadAll);
				this._offline.kill();
				this._offline = null;
			}
			if (this._player != null) {
				this._player.removeEventListener(DISLoad.COMMUNITY_LOAD, onCommunityLoad);
				this._player.removeEventListener(DISLoad.STREAM_LOAD, onStreamLoad);
				this._player.removeEventListener(DISLoad.COMMUNITY_OK, onCommunityOK);
				this._player.removeEventListener(DISLoad.STREAM_OK, onStreamOK);
				this._player.removeEventListener(DISLoad.COMMUNITY_ERROR, onCommunityERROR);
				this._player.removeEventListener(DISLoad.STREAM_ERROR, onStreamERROR);
				this._player.removeEventListener(Playing.MEDIA_PLAY, onPlay);
				this._player.removeEventListener(Playing.MEDIA_PAUSE, onPause);
			}
			this._player = null;
			if (this._reader != null) {
				this._reader.removeEventListener(ReaderServerEvent.READER_ERROR, onReaderError);
				this._reader.removeEventListener(ReaderServerEvent.COMMUNITY_INFO, onCommunityInfo);
				this._reader.removeEventListener(ReaderServerEvent.SYSTEM_INFO, onSystemInfo);
				this._reader.removeEventListener(ReaderServerEvent.NOSYSTEM, noSystem);
				this._reader.removeEventListener(ReaderServerEvent.STREAM_INFO, onStreamInfo);
				this._reader.removeEventListener(ReaderServerEvent.STREAM_RATE, onStreamRate);
				this._reader.removeEventListener(ReaderServerEvent.COMMUNITY_LIST, onCommunityList);
				this._reader.removeEventListener(ReaderServerEvent.STREAM_LIST, onStreamList);
				this._reader.removeEventListener(ReaderServerEvent.VALID_PKEY, onPublicKey);
				this._reader.removeEventListener(ReaderServerEvent.DATA_SAVED, onDataSaved);
				this._reader.removeEventListener(ReaderServerEvent.DATA_LOADED, onDataLoaded);
				this._reader.removeEventListener(ReaderServerEvent.COMDATA_LOADED, onComDataLoaded);
				this._reader.kill();
				this._reader = null;
			}
			this._publicRemote = null;
			this._remoteGroup = null;
			this._myPeer = null;
			this.remoteGroup = null;
			this.cirrusKey = null;
			this.multicastip = null;
			this.multicastport = null;
			this.stopRemote();
			this.stopRemoteLocal();
			this._language.removeEventListener(Event.COMPLETE, onLanguageAvailable);
			this._language.kill();
			this._language = null;
			this._premotestart = null;
		}
		
		/**
		 * Start public remote control.
		 * @param	id	the public connection key
		 * @param	group	connection group name
		 * @param	cirrus	Adobe Cirrus user key
		 * @param	keypass	public remote key password (for reserved ones)
		 */
		public function startPublicRemote(id:String, group:String, cirrus:String, keypass:String = ""):void {
			if (this._reader == null) {
				this._premotestart["id"] = id;
				this._premotestart["group"] = group;
				this._premotestart["keypass"] = keypass;
			} else if (!this._reader.ready) {
				this._premotestart["id"] = id;
				this._premotestart["group"] = group;
				this._premotestart["keypass"] = keypass;
			} else {
				// hold data
				this._publicRemote = id.toLowerCase();
				this._publicPass = keypass;
				this._remoteGroup = group;
				this._cirrus = this._reader.cirrus;
				// is the public remote key and password valid?
				this._reader.checkPKey(this._publicRemote, this._publicPass);
			}
		}
		
		/**
		 * Start remote control over the Internet.
		 */
		public function startPublicRemoteWeb():void {
			// is cirrus key defined?
			if (this._reader.cirrus != "") {
				// start remote control over the web
				this._cirrus = this.cirrusKey = this._reader.cirrus;
				this._ncremote = new NetConnection();
				this._ncremote.addEventListener(NetStatusEvent.NET_STATUS, onNetstatusRemote);
				this._ncremote.client = this;
				this._ncremote.connect("rtmfp://p2p.rtmfp.net/", this._cirrus);
			} else {
				// start just the local remote
				this.startPublicRemoteLocal(this._publicRemote, this._remoteGroup);
			}
		}
		
		/**
		 * Start public remote control connection on the local network.
		 * @param	id	the public connection key
		 * @param	group	connection group name
		 */
		public function startPublicRemoteLocal(id:String, group:String):void {
			// connection data
			this._publicRemote = id.toLowerCase();
			this._remoteGroup = group;
			// start tcp
			if (this._tcpRemote != null) if (!this._tcpRemote.isBound) {
				if (this._reader.logged) this._tcpRemote.startServer(this.remoteTcpPort, this._reader.usrmail, this.remoteTcpKey);
					else this._tcpRemote.startServer(this.remoteTcpPort, this._publicRemote, this.remoteTcpKey);
			}
			// local network
			this._nclocal = new NetConnection();
			this._nclocal.addEventListener(NetStatusEvent.NET_STATUS, onNetstatusLocal);
			this._nclocal.client = this;
			this._nclocal.connect("rtmfp:", "managana");
		}
		
		/**
		 * For netconnection bug.
		 */
		public function onPeerConnect(callerns:NetStream):Boolean {
			//trace ("onpeerconnect");
			callerns.client = this;
			return (true);
		}
		public function startTransmit(arg1:*= null, arg2:*= null):Boolean {
			//trace ("call startransmit", arg1, arg2);
			return(true);
		}
		public function stopTransmit(arg1:*= null, arg2:*= null):Boolean {
			//trace ("call stoptransmit", arg1, arg2);
			return(true);
		}
		
		/**
		 * Stop remote controlling over the internet.
		 */
		public function stopRemote():void {
			if (this._ncremote != null) if (this._ncremote.connected) {
				if (this._outstream != null) {
					this._outstream.close();
					this._outstream.removeEventListener(NetStatusEvent.NET_STATUS, onNetstatusRemote);
					this._outstream = null;
				}
				for (var index:String in this._remotes) this.closeRemote(index);
				this._ncremote.close();
				this._ncremote.removeEventListener(NetStatusEvent.NET_STATUS, onNetstatusRemote);
				this._ncremote = null;
			}
		}
		
		/**
		 * Stop remote controlling on local network.
		 */
		public function stopRemoteLocal():void {
			if (this._nclocal != null) if (this._nclocal.connected) {
				if (this._netgroup != null) {
					this._netgroup.close();
					this._netgroup.removeEventListener(NetStatusEvent.NET_STATUS, onNetstatusLocal);
					this._netgroup = null;
				}
				this._nclocal.close();
				this._nclocal.removeEventListener(NetStatusEvent.NET_STATUS, onNetstatusLocal);
				this._nclocal = null;
			}
		}
		
		/**
		 * Close a connection to a remote control.
		 * @param	peer	the remote peer id
		 */
		public function closeRemote(peer:String):void {
			if (this._reader != null) if (this._remotes[peer] != null) {
				this._remotes[peer].kill();
				delete (this._remotes[peer]);
				// remove remote from database
				var requestremote:URLRequest = new URLRequest(this._reader.url);
				var dataremote:URLVariables = new URLVariables();
				dataremote.key = this._reader.key;
				dataremote.group = this._remoteGroup + "/" + this._publicRemote;
				dataremote.peer = peer;
				dataremote.ac = "playerdeleteremote";
				requestremote.data = dataremote;
				requestremote.method = this._reader.serverMethod;
				this._remoteLoader.load(requestremote);
			}
		}
		
		/**
		 * Move the target.
		 * @param	px	target x position from 0% to 100% of content width
		 * @param	py	target y position from 0% to 100% of content height
		 * @param	visible	should target be visible?
		 */
		public function remoteTarget(px:Number, py:Number, visible:Boolean = true):void {
			if (this._allowRemote) {
				if ((px >= 0) && (px <= 100) && (py >= 0) && (py <= 100)) {
					this._player.setTarget(px, py);
				} else {
					this._player.setTarget(0, 0, false);
				}
			}
			if (!visible) this._player.setTarget(0, 0, false);
		}
		
		/**
		 * User released touch on remote controller.
		 */
		public function remoteRelease():void {
			if (this._allowRemote) {
				this._player.targetAct();
			}
		}
		
		/**
		 * Remote control navigation handler.
		 * @param	ref	navigation reference
		 */
		public function remoteNavigate(ref:String):void {
			if (this._allowRemote) {
				switch (ref) {
					case 'up':
						this._player.navigateTo('ynext');
						break;
					case 'right':
						this._player.navigateTo('xnext');
						break;
					case 'down':
						this._player.navigateTo('yprev');
						break;
					case 'left':
						this._player.navigateTo('xprev');
						break;
					case 'home':
						this._player.goHome();
						break;
					case 'full':
						this.fullClick();
						break;
					case 'play':
						this._player.play();
						break;
					case 'pause':
						this._player.pause();
						break;
				}
			}
		}
		
		/**
		 * Run a custom function.
		 * @param	func	the function to run (A, B, C or D)
		 */
		public function remoteCustom(func:String):void {
			this._player.runCustomFunction(func);
		}
		
		/**
		 * Remote control on screen handler.
		 * @param	ref	component reference
		 */
		public function remoteOnScreen(ref:String):void {
			if ((this._reader != null) && this._allowRemote) {
				switch (ref) {
					case 'logo':
						this._mainButton.visible = !this._mainButton.visible;
						this._logo.visible = this._mainButton.visible;
						break;
					case 'time':
						this.toggleTime(!this._time.visible);
						break;
					case 'comment':
						this.toggleComment(!this._commentbt.visible);
						break;
					case 'rate':
						this.toggleRate(!this._ratebt.visible);
						break;
					case 'notes':
						this.toggleNotes(!this._notebt.visible);
						break;
					case 'zoom':
						this.toggleZoom(!this._zoombt.visible);
						break;
					case 'vote':
						this.toggleVote(!this._player.voteVisible);
						break;
				}
			}
		}
		
		/**
		 * Remote control vote.
		 * @param	num	vote number
		 */
		public function remoteOnVote(num:uint):void {
			if (this._allowRemote) {
				this._player.addVote(num);
			}
		}
		
		/**
		 * Remote control guide vote.
		 * @param	num	vote number
		 */
		public function remoteOnGuideVote(num:uint):void {
			if (this._allowRemote) {
				this._player.setGuideVote(num);
			}
		}
		
		/**
		 * Remote control sound handler.
		 * @param	ref	sound command reference
		 * @param	volume	sound volume level
		 */
		public function remoteOnSound(ref:String, volume:Number = 0):void {
			if (this._allowRemote) {
				switch (ref) {
					case 'mute':
						this._bar.isMute = true;
						SoundMixer.soundTransform = new SoundTransform(0);
						break;
					case 'unmute':
						this._bar.isMute = false;
						SoundMixer.soundTransform = new SoundTransform(1);
						break;
					case 'volume':
						if ((volume >= 0) && (volume <= 1)) {
							SoundMixer.soundTransform = new SoundTransform(volume);
						}
						break;
				}
			}
		}
		
		/**
		 * Remote control zoom and position handler.
		 * @param	ref command reference
		 * @param	zpX	x axis reference
		 * @param	zpY	y axis reference
		 */
		public function remoteOnZoom(ref:String, zpX:Number = 0, zpY:Number = 0):void {
			if (this._allowRemote && this.allowZoomPosition) {
				switch (ref) {
					case 'reset':
						this._player.scaleX = 1;
						this._player.scaleY = 1;
						if (this.positionOnReset) {
							this._player.x = this.resetX;
							this._player.y = this.resetY;
						} else {
							if (this._useHolder) {
								this._player.x = this._holderBG.width / 2;
								this._player.y = this._holderBG.height / 2;
							} else {
								this._player.x = this.stage.stageWidth / 2;
								this._player.y = this.stage.stageHeight / 2;
							}
						}
						break;
					case 'zoom':
						this._player.scaleX = 3 * zpX;
						this._player.scaleY = 3 * zpX;
						break;
					case 'position':
						if (this._useHolder) {
							this._player.x = this._holderBG.width * (zpX - 0.25) * 2;
							this._player.y = this._holderBG.height * (zpY - 0.25) * 2;
						} else {
							this._player.x = this.stage.stageWidth * (zpX - 0.25) * 2;
							this._player.y = this.stage.stageHeight * (zpY - 0.25) * 2;
						}
						break;
				}
			}
		}
		
		/**
		 * Remote control asked for a list of communities or streams.
		 * @param	ref command reference (community or stream)
		 * @param	com	the desired community (in case of stream lists)
		 */
		public function remoteOnList(ref:String, com:String = ""):void {
			if ((this._reader != null) && this._allowRemote) {
				switch (ref) {
					case 'community':
						this._reader.getCommunityList();
						break;
					case 'stream':
						this._reader.getStreamList(com);
						break;
				}
			}
		}
		
		/**
		 * Open a community or a stream.
		 * @param	ref	reference: community or stream
		 * @param	data	the community or stream id
		 */
		public function remoteOpen(ref:String, data:String):void {
			if (this._allowRemote) {
				if (ref == "community") {
					this._player.loadCommunity(data, "list");
				} else {
					this._player.loadStream(data, "list");
				}
			}
		}
		
		/**
		 * Data received from a tcp remote control client.
		 */
		public function onRemoteTCP(evt:RemoteTCPEvent):void {
			var ratenum:int = -1;
			var commentnum:int = -1;
			var index:uint;
			var msg:String;
			switch (evt.action) {
				case 'hello':
					// set target mode
					this._player.targetMode = Target.INTERACTION_REMOTE;
					// send welcome to remote
					if (this._reader.rate) ratenum = this._reader.streamrate;
					if (this._reader.comment != "none") commentnum = this._reader.streamComments.length;
					msg = "<event>welcome</event>";
					msg += StringFunctions.cdataXML("community", this._player.currentCommunityTitle);
					msg += "<comID>" + this._player.currentCommunity + "</comID>";
					msg += "<streamID>" + this._player.currentStream + "</streamID>";
					msg += "<remoteID>" + this._player.remoteStream + "</remoteID>";
					msg += StringFunctions.cdataXML("streamTitle", this._player.currentStreamTitle);
					msg += StringFunctions.cdataXML("streamAbout", this._player.currentStreamAbout);
					msg += "<streamCategory>" + this._player.streamCategory + "</streamCategory>";
					msg += "<ratenum>" + ratenum + "</ratenum>";
					msg += "<commentnum>" + commentnum + "</commentnum>";
					msg += "<streamComments>"
						for (index = 0; index < this._reader.streamComments.length; index++) {
							msg += "<entry>";
							msg += StringFunctions.cdataXML("name", this._reader.streamComments[index].name);
							msg += StringFunctions.cdataXML("date", this._reader.streamComments[index].date);
							msg += StringFunctions.cdataXML("comment", this._reader.streamComments[index].comment);
							msg += "</entry>";
						}
					msg += "</streamComments>";
					msg += "<xnext>" + this._player.streamHasXNext + "</xnext>";
					msg += "<xprev>" + this._player.streamHasXPrev + "</xprev>";
					msg += "<ynext>" + this._player.streamHasYNext + "</ynext>";
					msg += "<yprev>" + this._player.streamHasYPrev + "</yprev>";
					msg += "<v1>" + String(this._player.voteEnabled(1)) + "</v1>";
					msg += "<v2>" + String(this._player.voteEnabled(2)) + "</v2>";
					msg += "<v3>" + String(this._player.voteEnabled(3)) + "</v3>";
					msg += "<v4>" + String(this._player.voteEnabled(4)) + "</v4>";
					msg += "<v5>" + String(this._player.voteEnabled(5)) + "</v5>";
					msg += "<v6>" + String(this._player.voteEnabled(6)) + "</v6>";
					msg += "<v7>" + String(this._player.voteEnabled(7)) + "</v7>";
					msg += "<v8>" + String(this._player.voteEnabled(8)) + "</v8>";
					msg += "<v9>" + String(this._player.voteEnabled(9)) + "</v9>";
					if (this._tcpRemote != null) this._tcpRemote.sendToClient(msg, evt.client);
					break;
				default:
					this.processMessage(evt.params);
					break;
			}
		}
		
		/**
		 * Send a message to connected TCP remote controls.
		 * @param	ac	the action to send
		 */
		public function sendToTCP(ac:String):void {
			if (this._tcpRemote != null) if (this._tcpRemote.clients > 0) {
				var ratenum:int = -1;
				var commentnum:int = -1;
				var msg:String;
				var index:uint;
				switch (ac) {
					case 'sendStream':
						// send stream information to remotes
						if (this._reader.rate) ratenum = this._reader.streamrate;
						if (this._reader.comment != "none") commentnum = this._reader.streamComments.length;
						msg = "<event>streamChange</event>";
						msg += StringFunctions.cdataXML("community", this._player.currentCommunityTitle);
						msg += "<comID>" + this._player.currentCommunity + "</comID>";
						msg += "<streamID>" + this._player.currentStream + "</streamID>";
						msg += "<remoteID>" + this._player.remoteStream + "</remoteID>";
						msg += StringFunctions.cdataXML("streamTitle", this._player.currentStreamTitle);
						msg += StringFunctions.cdataXML("streamAbout", this._player.currentStreamAbout);
						msg += "<streamCategory>" + this._player.streamCategory + "</streamCategory>";
						msg += "<ratenum>" + ratenum + "</ratenum>";
						msg += "<commentnum>" + commentnum + "</commentnum>";
						msg += "<streamComments>"
							for (index = 0; index < this._reader.streamComments.length; index++) {
								msg += "<entry>";
								msg += StringFunctions.cdataXML("name", this._reader.streamComments[index].name);
								msg += StringFunctions.cdataXML("date", this._reader.streamComments[index].date);
								msg += StringFunctions.cdataXML("comment", this._reader.streamComments[index].comment);
								msg += "</entry>";
							}
						msg += "</streamComments>";
						msg += "<xnext>" + this._player.streamHasXNext + "</xnext>";
						msg += "<xprev>" + this._player.streamHasXPrev + "</xprev>";
						msg += "<ynext>" + this._player.streamHasYNext + "</ynext>";
						msg += "<yprev>" + this._player.streamHasYPrev + "</yprev>";
						msg += "<v1>" + String(this._player.voteEnabled(1)) + "</v1>";
						msg += "<v2>" + String(this._player.voteEnabled(2)) + "</v2>";
						msg += "<v3>" + String(this._player.voteEnabled(3)) + "</v3>";
						msg += "<v4>" + String(this._player.voteEnabled(4)) + "</v4>";
						msg += "<v5>" + String(this._player.voteEnabled(5)) + "</v5>";
						msg += "<v6>" + String(this._player.voteEnabled(6)) + "</v6>";
						msg += "<v7>" + String(this._player.voteEnabled(7)) + "</v7>";
						msg += "<v8>" + String(this._player.voteEnabled(8)) + "</v8>";
						msg += "<v9>" + String(this._player.voteEnabled(9)) + "</v9>";
						if (this._tcpRemote != null) this._tcpRemote.sendToClient(msg);
						break;
					case "newCommunityList":
						// send a community list to remotes
						msg = "<event>newCommunityList</event>";
						msg += "<list>";
						for (index = 0; index < this._reader.communityList.child("community").length(); index++) {
							msg += "<community>";
							msg += "<id>" + String(this._reader.communityList.community[index].@id) + "</id>";
							msg += StringFunctions.cdataXML("title", String(this._reader.communityList.community[index]));
							msg += "</community>";
						}
						msg += "</list>";
						if (this._tcpRemote != null) this._tcpRemote.sendToClient(msg);
						break;
					case "newStreamList":
						// send a stream list to remotes
						msg = "<event>newStreamList</event>";
						msg += "<list>";
						for (index = 0; index < this._reader.streamList.child("stream").length(); index++) {
							msg += "<stream>";
							msg += "<id>" + String(this._reader.streamList.stream[index].@id) + "</id>";
							msg += StringFunctions.cdataXML("title", String(this._reader.streamList.stream[index].title));
							msg += StringFunctions.cdataXML("category", String(this._reader.streamList.stream[index].category));
							msg += "</stream>";
						}
						msg += "</list>";
						if (this._tcpRemote != null) this._tcpRemote.sendToClient(msg);
						break;
				}
			}
		}
		
		/**
		 * Process messages received from the remotes.
		 * @param	message	the message object
		 */
		public function processMessage(message:Object):void {
			if (this._reader != null) {
				var ratenum:int = -1;
				var commentnum:int = -1;
				var data:Object = new Object();
				if (this._allowRemote) {
					if (!(message is String)) if (message.command != null) switch (message.command) {
						case 'sendWelcome':
							// set target mode
							this._player.targetMode = Target.INTERACTION_REMOTE;
							// send welcome to remote
							if (this._reader.rate) ratenum = this._reader.streamrate;
							if (this._reader.comment != "none") commentnum = this._reader.streamComments.length;
							data.command = "welcome";
							data.community = this._player.currentCommunityTitle;
							data.comID = this._player.currentCommunity;
							data.streamID = this._player.currentStream;
							data.remoteID = this._player.remoteStream;
							data.streamTitle = this._player.currentStreamTitle;
							data.streamAbout = this._player.currentStreamAbout;
							data.streamCategory = this._player.streamCategory;
							data.ratenum = ratenum;
							data.commentnum = commentnum;
							data.streamComments = this._reader.streamComments;
							data.xnext = this._player.streamHasXNext;
							data.xprev = this._player.streamHasXPrev;
							data.ynext = this._player.streamHasYNext;
							data.yprev = this._player.streamHasYPrev;
							data.v1 = this._player.voteEnabled(1);
							data.v2 = this._player.voteEnabled(2);
							data.v3 = this._player.voteEnabled(3);
							data.v4 = this._player.voteEnabled(4);
							data.v5 = this._player.voteEnabled(5);
							data.v6 = this._player.voteEnabled(6);
							data.v7 = this._player.voteEnabled(7);
							data.v8 = this._player.voteEnabled(8);
							data.v9 = this._player.voteEnabled(9);
							data.rand = Math.random();
							if (this._localStatus == CONNSTATUS_CONNECTED) if (this._netgroup != null) this._netgroup.post(data);
							break;
						case 'sendStream':
							// send stream information to remotes
							if (this._reader.rate) ratenum = this._reader.streamrate;
							if (this._reader.comment != "none") commentnum = this._reader.streamComments.length;
							data.command = "streamChange";
							data.community = this._player.currentCommunityTitle;
							data.comID = this._player.currentCommunity;
							data.streamID = this._player.currentStream;
							data.remoteID = this._player.remoteStream;
							data.streamTitle = this._player.currentStreamTitle;
							data.streamAbout = this._player.currentStreamAbout;
							data.streamCategory = this._player.streamCategory;
							data.ratenum = ratenum;
							data.commentnum = commentnum;
							data.streamComments = this._reader.streamComments;
							data.xnext = this._player.streamHasXNext;
							data.xprev = this._player.streamHasXPrev;
							data.ynext = this._player.streamHasYNext;
							data.yprev = this._player.streamHasYPrev;
							data.v1 = this._player.voteEnabled(1);
							data.v2 = this._player.voteEnabled(2);
							data.v3 = this._player.voteEnabled(3);
							data.v4 = this._player.voteEnabled(4);
							data.v5 = this._player.voteEnabled(5);
							data.v6 = this._player.voteEnabled(6);
							data.v7 = this._player.voteEnabled(7);
							data.v8 = this._player.voteEnabled(8);
							data.v9 = this._player.voteEnabled(9);
							data.rand = Math.random();
							if (this._localStatus == CONNSTATUS_CONNECTED) if (this._netgroup != null) this._netgroup.post(data);
							break;
						case "newCommunityList":
							// send a community list to remotes
							data.command = "newCommunityList";
							data.list = this._reader.communityList;
							data.rand = Math.random();
							if (this._localStatus == CONNSTATUS_CONNECTED) if (this._netgroup != null) this._netgroup.post(data);
							break;
						case "newStreamList":
							// send a stream list to remotes
							data.command = "newStreamList";
							data.list = this._reader.streamList;
							data.rand = Math.random();
							if (this._localStatus == CONNSTATUS_CONNECTED) if (this._netgroup != null) this._netgroup.post(data);
							break;
						case "remoteTarget":
							this.remoteTarget(message.pX, message.pY);
							break;
						case "remoteRelease":
							this.remoteRelease();
							break;
						case "remoteNavigate":
							this.remoteNavigate(message.reference);
							break;
						case "remoteCustom":
							this.remoteCustom(message.reference);
							break;
						case "remoteOnScreen":
							this.remoteOnScreen(message.reference);
							break;
						case "remoteOnList":
							if (message.reference == "stream") this.remoteOnList(message.reference, message.com);
								else this.remoteOnList(message.reference);
							break;
						case "remoteOpen":
							this.remoteOpen(message.reference, message.data);
							break;
						case "remoteOnVote":
							this.remoteOnVote(message.num);
							break;
						case "remoteOnGuideVote":
							this.remoteOnGuideVote(message.num);
							break;
						case "remoteOnSound":
							this.remoteOnSound(message.reference, message.volume);
							break;
						case "remoteOnZoom":
							this.remoteOnZoom(message.reference, message.zpX, message.zpY);
							break;
						case "hello":
							this.processMessage("sendWelcome");
							break;
					}
				}
			}
		}
		
		/**
		 * Send a welcome message to a remote.
		 * @param	peer	the remote peer id
		 */
		public function sendWelcome(peer:String):void {
			if ((this._reader != null) && this._allowRemote) {
				// set target mode
				this._player.targetMode = Target.INTERACTION_REMOTE;
				var ratenum:int = -1;
				if (this._reader.rate) ratenum = this._reader.streamrate;
				var commentnum:int = -1;
				if (this._reader.comment != "none") commentnum = this._reader.streamComments.length;
				this._outstream.send("playerWelcome", peer, this._player.currentCommunityTitle, this._player.currentCommunity, this._player.currentStream, this._player.currentStreamTitle, this._player.currentStreamAbout, this._player.streamCategory, ratenum, commentnum, this._reader.streamComments, this._player.streamHasXNext, this._player.streamHasXPrev, this._player.streamHasYNext, this._player.streamHasYPrev, this._player.voteEnabled(1), this._player.voteEnabled(2), this._player.voteEnabled(3), this._player.voteEnabled(4), this._player.voteEnabled(5), this._player.voteEnabled(6), this._player.voteEnabled(7), this._player.voteEnabled(8), this._player.voteEnabled(9), this._player.remoteStream);
			}
		}
		
		/**
		 * Display a qrcode on screen.
		 * @param	text	the string to be shown as a qrcode
		 */
		public function showQRCode(text:String):void {
			this._qrcode.code = text;
			this.addChild(this._qrcode);
		}
		
		/**
		 * Close the qrcode display interface if it is shown.
		 */
		public function closeQRCode():void {
			this._qrcode.close();
		}
		
		// PRIVATE METHODS
		
		/**
		 * Language text strings are available.
		 */
		private function onLanguageAvailable(evt:Event):void {
			if (this._ratewnd != null) this._ratewnd.text = this._language.getText('RATETEXT');
			if (this._plusmenu != null) this._plusmenu.setText(this._language.getText('LOGINBUTTON'), this._language.getText('LOGOUTBUTTON'));
			if (this._addcommentwnd != null) this._addcommentwnd.setText(this._language.getText('COMMENTTEXT'), this._language.getText('COMMENTBUTTON'));
			if (this._searchwnd != null) this._searchwnd.setText(this._language.getText('SEARCHNORESULTS'), this._language.getText('SEARCHALLCOMMUNITIES'));
			if (this._noteswnd != null) this._noteswnd.setText(this._language.getText('NOTESTITLE'));
			if (this._offlinewnd != null) this._offlinewnd.setText(this._language.getText('OFFLINETITLE'), this._language.getText('OFFLINEGETTINGINFOWAIT'), this._language.getText('OFFLINELISTMARK'), this._language.getText('OFFLINEDOWNBT'), this._language.getText('OFFLINERETBT'), this._language.getText('OFFLINEINFOFOR'), this._language.getText('OFFLINESIZE'), this._language.getText('OFFLINEINFOERROR'), this._language.getText('OFFLINEWIFI'), this._language.getText('OFFLINEDOWNERROR'), this._language.getText('OFFLINEDOWNMSG'), this._language.getText('OFFLINEDOWNCLOSE'), this._language.getText('OFFLINEDOWNCANCEL'), this._language.getText('OFFLINEUPDABOUT'), this._language.getText('OFFLINEUPDBT'), this._language.getText('OFFLINEUPDDEL'));
		}
		
		/**
		 * Save variables for current community.
		 */
		private function saveData(evt:Message):void {
			if ((this._reader != null) && this._reader.logged) {
				// save on server
				this._reader.saveData(this._reader.usrmail, this._player.currentCommunity, this._player.strValues, this._player.numValues);
			} else {
				// save on local storage
				if (this._player.localUserData != null) {
					// use xml on disk
					this._player.localUserData("save", this._player.currentCommunity, this._player.strValues, this._player.numValues);
				} else {
					// use shared object
					var sharedData:SharedObject = SharedObject.getLocal("managana-" + this._player.currentCommunity);
					sharedData.data.strValues = this._player.strValues;
					sharedData.data.numValues = this._player.numValues;
					sharedData.flush();
				}
			}
		}
		
		/**
		 * Load variables assigned for current community.
		 */
		private function loadData(evt:Message):void {
			if ((this._reader != null) && this._reader.logged) {
				// load from server
				this._reader.loadData(this._reader.usrmail, this._player.currentCommunity);
			} else {
				// load from local storage
				if (this._player.localUserData != null) {
					// use xml on disk
					var data:Array = this._player.localUserData("load", this._player.currentCommunity);
					this._player.strValues = data['strValues'];
					this._player.numValues = data['numValues'];
				} else {
					// use shared object
					var sharedData:SharedObject = SharedObject.getLocal("managana-" + this._player.currentCommunity);
					this._player.strValues = sharedData.data.strValues;
					this._player.numValues = sharedData.data.numValues;
				}
			}
		}
		
		/**
		 * Received status from remote network connection (Adobe Cirrus).
		 */
		private function onNetstatusRemote(evt:NetStatusEvent):void {
			if (this._reader != null) switch (evt.info.code) {
				case "NetConnection.Connect.Success":
					// connect to Managana server to register this player id
					this._remoteStatus = CONNSTATUS_CONNECTED;
					this._myPeer = this._ncremote.nearID;
					this._remoteLoader = new URLLoader();
					this._remoteLoader.addEventListener(Event.COMPLETE, onLoaderOK);
					this._remoteLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoaderError);
					this._remoteLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoaderError);
					var request:URLRequest = new URLRequest(this._reader.url);
					var data:URLVariables = new URLVariables();
					data.key = this._reader.key;
					data.peer = this._myPeer;
					data.group = this._remoteGroup + "/" + this._publicRemote;
					data.ac = "playerremote";
					request.data = data;
					request.method = this._reader.serverMethod;
					this._remoteLoader.load(request);
					break;
				case "NetStream.Connect.Rejected":
					// user rejected p2p network
					if (this._ncremote != null) {
						this._ncremote.close();
						this._ncremote = null;
					}
					break;
				case 'NetStream.Connect.Success':
					// a remote control successfully connected or disconnected
					var requestremote:URLRequest = new URLRequest(this._reader.url);
					var dataremote:URLVariables = new URLVariables();
					dataremote.key = this._reader.key;
					dataremote.group = this._remoteGroup + "/" + this._publicRemote;
					dataremote.ac = "playercheckremote";
					requestremote.data = dataremote;
					requestremote.method = this._reader.serverMethod;
					this._remoteLoader.load(requestremote);
					break;
				case 'NetConnection.Connect.NetworkChange':
					if (this._remoteStatus == CONNSTATUS_CONNECTED) {
						// assign connection lost
						this._remoteStatus = CONNSTATUS_LOST;
						this.stopRemote();
						this._remoteStatusInterval = setInterval(this.restartRemote, 10000);
					}
					break;
				case 'NetStream.Publish.Start':
					// start listening on local network
					if (this._localStatus == CONNSTATUS_IDLE) {
						this.startPublicRemoteLocal(this._publicRemote, this._remoteGroup);
					}
					break;
				case 'NetConnection.Connect.Closed':
					// at least try to listen on local network
					if (this._localStatus == CONNSTATUS_IDLE) {
						this.startPublicRemoteLocal(this._publicRemote, this._remoteGroup);
					}
					break;
			}
		}
		
		/**
		 * Try to restabilish remote connection over the internet.
		 */
		private function restartRemote():void {
			if (this._remoteStatus == CONNSTATUS_LOST) {
				this.stopRemote();
				this.startPublicRemote(this._publicRemote, this._remoteGroup, this.cirrusKey);
			} else {
				clearInterval(this._remoteStatusInterval);
			}
		}
		
		/**
		 * Received status from local network connection.
		 */
		private function onNetstatusLocal(evt:NetStatusEvent):void {
			switch (evt.info.code) {
				case "NetConnection.Connect.Success":
					// prepare group
					var groupspec:GroupSpecifier = new GroupSpecifier(this._remoteGroup + "/" + this._publicRemote);
					groupspec.postingEnabled = true;
					groupspec.ipMulticastMemberUpdatesEnabled = true;
					groupspec.addIPMulticastAddress(this.multicastip + ":" + uint(this.multicastport));
					// create group
					this._netgroup = new NetGroup(this._nclocal, groupspec.groupspecWithAuthorizations());
					this._netgroup.addEventListener(NetStatusEvent.NET_STATUS, onNetstatusLocal);
					break;
				case "NetGroup.Posting.Notify":
					this.processMessage(evt.info.message);
					break;
				case 'NetGroup.Neighbor.Connect':
					// player found. send welcome message
					this.processMessage( { command: "sendWelcome" } );
					break;
				case 'NetGroup.Connect.Success':
					this._localStatus = CONNSTATUS_CONNECTED;
					// show the public connection id
					if (this._reader.usrmail == "") {
						this._mainButton.publicKey = this._publicRemote;
						this._mainButton.username = this._publicRemote;
						this._mainButton.userVisible = true;
					} else {
						this._mainButton.userVisible = this._forceVisible;
					}
					break;
				case 'NetGroup.Connect.Rejected':
					this.stopRemote();
					this.stopRemoteLocal();
					this.showMessage(this._language.getText('REMOTENOPEER'));
					break;
				case 'NetConnection.Connect.NetworkChange':
					if (this._localStatus == CONNSTATUS_CONNECTED) {
						// assign connection lost
						this._localStatus = CONNSTATUS_LOST;
						this.stopRemoteLocal();
						this._localStatusInterval = setInterval(this.restartRemoteLocal, 10000);
					}
					break;
			}
		}
		
		/**
		 * Try to restabilish local remote connection.
		 */
		private function restartRemoteLocal():void {
			if (this._localStatus == CONNSTATUS_LOST) {
				this.stopRemoteLocal();
				this.startPublicRemoteLocal(this._publicRemote, this._remoteGroup);
			} else {
				clearInterval(this._localStatusInterval);
			}
		}
		
		/**
		 * Successfull connection to the Managana server.
		 */
		private function onLoaderOK(evt:Event):void {
			if (this._reader != null) {
				this._remoteLoader.removeEventListener(Event.COMPLETE, onLoaderOK);
				this._remoteLoader.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderError);
				this._remoteLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoaderError);
				var data:XML;
				try {
					data = new XML(this._remoteLoader.data);
					if (data.error != "0") {
						this._myPeer = "";
						this._publicRemote = "";
						this._ncremote.close();
					} else {
						// show the public connection id
						if (this._reader.usrmail == "") {
							this._mainButton.publicKey = this._publicRemote;
							this._mainButton.username = this._publicRemote;
							this._mainButton.userVisible = true;
						} else {
							this._mainButton.userVisible = this._forceUser;
						}
						// start output broadcasting
						this._outstream = new NetStream(this._ncremote, NetStream.DIRECT_CONNECTIONS);
						this._outstream.addEventListener(NetStatusEvent.NET_STATUS, onNetstatusRemote);
						this._outstream.client = this;
						this._outstream.publish(this._remoteGroup + "/" + this._publicRemote);
						// wait for remote connections
						this._remoteLoader.addEventListener(Event.COMPLETE, onRemoteOK);
						this._remoteLoader.addEventListener(IOErrorEvent.IO_ERROR, onRemoteError);
						this._remoteLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onRemoteError);
					}
				} catch (e:Error) {
					this._myPeer = "";
					this._publicRemote = "";
					this._ncremote.close();
				}
			}
		}
		
		/**
		 * Error while connecting to Managana server.
		 */
		private function onLoaderError(evt:Event):void {
			this._remoteLoader.removeEventListener(Event.COMPLETE, onLoaderOK);
			this._remoteLoader.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderError);
			this._remoteLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoaderError);
			this._publicRemote = "";
			this._myPeer = "";
			this._ncremote.close();
		}
		
		/**
		 * Just got remote information.
		 */
		private function onRemoteOK(evt:Event):void {
			try {
				var remoteXML:XML = new XML(this._remoteLoader.data);
				for (var index:uint = 0; index < remoteXML.child('remote').length(); index++) {
					if (this._remotes[String(remoteXML.remote[index])] == null) {
						// new remote connected
						this._remotes[String(remoteXML.remote[index])] = new ConnectedRemote(String(remoteXML.remote[index]), this._ncremote, (this._remoteGroup + "/" + this._publicRemote), this);
					}
				}
			} catch (e:Error) {
				// try to load remote data again
				this.onRemoteError(null);
			}
		}
		
		/**
		 * Error while getting remote information.
		 */
		private function onRemoteError(evt:Event):void {
			if (this._reader != null) {
				// try to load remote data again
				var requestremote:URLRequest = new URLRequest(this._reader.url);
				var dataremote:URLVariables = new URLVariables();
				dataremote.key = this._reader.key;
				dataremote.group = this._remoteGroup + "/" + this._publicRemote;
				dataremote.ac = "playercheckremote";
				requestremote.data = dataremote;
				requestremote.method = this._reader.serverMethod;
				this._remoteLoader.load(requestremote);
			}
		}
		
		/**
		 * Hide/show the complete bar.
		 */
		private function onLogoClick(evt:MouseEvent):void {
			this._bar.redraw(MainButton.minWidth);
			this._mainButton.visible = this._bar.visible;
			this._bar.visible = !this._bar.visible;
			if (!this._bar.visible) this._plusmenu.visible = false;
			this._time.bgVisible = !this._bar.visible;
		}
		
		/**
		 * Show/hide the comment button.
		 * @param	to	button visible?
		 */
		private function toggleComment(to:Boolean):void {
			this._commentbt.visible = to;
			// notes position
			if (this._commentbt.visible) {
				if (this._useHolder) {
					this._notebt.x = ((this._holderBG.width / 3) * 1) - (this._notebt.width /2);
				} else {
					this._notebt.x = ((this.stage.stageWidth / 3) * 1) - (this._notebt.width /2);
				}
			} else {
				this._notebt.x = this._commentbt.x;
			}	
			// ui warning
			if (this._commentbt.visible) this._uiwarning.setText(this._language.getText('WARNCOMMENTON'));
				else this._uiwarning.setText(this._language.getText('WARNCOMMENTOFF'));
		}
		
		/**
		 * Show/hide the rate button.
		 * @param	to	button visible?
		 */
		private function toggleRate(to:Boolean):void {
			this._ratebt.visible = to;
			// zoom buttons position
			if (this._ratebt.visible) {
				if (this._useHolder) {
					if (this._zoombt.visible) {
						this._ratebt.x = ((this._holderBG.width / 3) * 2) - (this._ratebt.width /2);
					} else {
						this._ratebt.x = this._holderBG.width - this._ratebt.width - 5;
					}
				} else {
					if (this._zoombt.visible) {
						this._ratebt.x = ((this.stage.stageWidth / 3) * 2) - (this._ratebt.width /2);
					} else {
						this._ratebt.x = this.stage.stageWidth - this._ratebt.width - 5;
					}
				}
			}
			// ui warning
			if (this._ratebt.visible) this._uiwarning.setText(this._language.getText('WARNRATEON'));
				else this._uiwarning.setText(this._language.getText('WARNRATEOFF'));
		}
		
		/**
		 * Show/hide the notes button.
		 * @param	to	button visible?
		 */
		private function toggleNotes(to:Boolean):void {
			this._notebt.visible = to;
			if (this._commentbt.visible) {
				if (this._useHolder) {
					this._notebt.x = ((this._holderBG.width / 3) * 1) - (this._notebt.width / 2);
				} else {
					this._notebt.x = ((this.stage.stageWidth / 3) * 1) - (this._notebt.width / 2);
				}
			} else {
				this._notebt.x = this._commentbt.x;
			}
			// ui warning
			if (this._notebt.visible) this._uiwarning.setText(this._language.getText('WARNNOTEON'));
				else this._uiwarning.setText(this._language.getText('WARNNOTEOFF'));
		}
		
		/**
		 * Show/hide the zoom buttons.
		 * @param	to	button visible?
		 */
		private function toggleZoom(to:Boolean):void {
			this._zoombt.visible = to;
			if (this._useHolder) {
				if (this._zoombt.visible) {
					this._ratebt.x = ((this._holderBG.width / 3) * 2) - (this._ratebt.width /2);
				} else {
					this._ratebt.x = this._holderBG.width - this._ratebt.width - 5;
				}
			} else {
				if (this._zoombt.visible) {
					this._ratebt.x = ((this.stage.stageWidth / 3) * 2) - (this._ratebt.width /2);
				} else {
					this._ratebt.x = this.stage.stageWidth - this._ratebt.width - 5;
				}
			}
			// ui warning
			if (this._zoombt.visible) this._uiwarning.setText(this._language.getText('WARNZOOMON'));
				else this._uiwarning.setText(this._language.getText('WARNZOOMOFF'));
		}
		
		/**
		 * Show/hide the vote graphics.
		 * @param	to	graphics visible?
		 */
		private function toggleVote(to:Boolean):void {
			this._player.voteVisible = this._forceVote = to;
			// ui warning
			if (this._player.voteVisible) this._uiwarning.setText(this._language.getText('WARNVOTEON'));
				else this._uiwarning.setText(this._language.getText('WARNVOTEOFF'));
		}
		
		/**
		 * Allow/disallow remote control.
		 * @param	to	should remotes be allowed?
		 */
		private function toggleRemote(to:Boolean):void {
			this._allowRemote = to;
			// ui warning
			if (this._allowRemote) this._uiwarning.setText(this._language.getText('WARNREMOTEON'));
				else this._uiwarning.setText(this._language.getText('WARNREMOTEOFF'));
				
			// remote
			this.dispatchEvent(new Message(Message.MESSAGE, { "ac":"showRemoteInfo" } ));
		}
		
		/**
		 * Show/hide the time button.
		 * @param	to	button visible?
		 * @param	checkFirst	check clock visibility and toggle (true) or force "to" (false, default)
		 */
		private function toggleTime(to:Boolean, checkFrist:Boolean = false):void {
			if (checkFrist) {
				this._time.visible = !this._time.visible;
			} else {
				this._time.visible = to;
			}
			// ui warning
			if (this._time.visible) this._uiwarning.setText(this._language.getText('WARNCLOCKON'));
				else this._uiwarning.setText(this._language.getText('WARNCLOCKOFF'));
		}
		
		/**
		 * Show/hide the user name.
		 * @param	to	name visible?
		 */
		private function toggleUsername(to:Boolean):void {
			this._mainButton.userVisible = to;
			// ui warning
			if (this._mainButton.userVisible) this._uiwarning.setText(this._language.getText('WARNUSERON'));
				else this._uiwarning.setText(this._language.getText('WARNUSEROFF'));
		}
		
		/**
		 * Click on home button.
		 */
		private function homeClick():void {
			this._player.goHome();
		}
		
		/**
		 * Click on full screen button.
		 */
		private function fullClick():void {
			if (this.stage.displayState == StageDisplayState.NORMAL) this.stage.displayState = StageDisplayState.FULL_SCREEN;
				else this.stage.displayState = StageDisplayState.NORMAL;
			this._plusmenu.visible = false;
			this._bar.showPlus(true);
			this._commentwnd.visible = false;
			this._messagewnd.visible = false;
			this._addcommentwnd.visible = false;
			this._searchwnd.visible = false;
			this._noteswnd.visible = false;
			this._offlinewnd.visible = false;
			this._bar.visible = false;
			this._time.bgVisible = !this._bar.visible;
			this._mainButton.visible = true;
		}
		
		/**
		 * Click on resize button.
		 */
		private function resizeClick():void {
			this._player.scaleX = 1;
			this._player.scaleY = 1;
			if (this.positionOnReset) {
				this._player.x = this.resetX;
				this._player.y = this.resetY;
			} else {
				if (this._useHolder) {
					this._player.x = this._holderBG.width / 2;
					this._player.y = this._holderBG.height / 2;
				} else {
					this._player.x = this.stage.stageWidth / 2;
					this._player.y = this.stage.stageHeight / 2;
				}
			}
		}
		
		/**
		 * Logout the system.
		 */
		private function doLogout():void {
			if (this._reader != null) {
				this._plusmenu.setLogin(!this._reader.doLogout());
				this.stopRemote();
				this.stopRemoteLocal();
			}
		}
		
		/**
		 * Called when the plus menu is shown/hidden.
		 * @param	to	plus menu visibility
		 */
		private function togglePlus(to:Boolean):void {
			if (to) {
				this._ratewnd.visible = false;
				this._commentwnd.visible = false;
				this._messagewnd.visible = false;
				this._addcommentwnd.visible = false;
				this._searchwnd.visible = false;
				this._noteswnd.visible = false;
				this._offlinewnd.visible = false;
			}
		}
		
		/**
		 * Notes button click.
		 */
		private function onNoteClick(evt:MouseEvent):void {
			this._noteswnd.visible = !this._noteswnd.visible;
			if (this._noteswnd.visible) {
				this._plusmenu.visible = false;
				this._bar.showPlus(true);
				this._commentwnd.visible = false;
				this._messagewnd.visible = false;
				this._addcommentwnd.visible = false;
				this._searchwnd.visible = false;
				this._ratewnd.visible = false;
				this._bar.visible = false;
				this._offlinewnd.visible = false;
				this._time.bgVisible = !this._bar.visible;
				this._mainButton.visible = true;
				this._playActivate = this._player.playing;
				this._player.pause();
			} else {
				if (this._playActivate) this._player.play();
			}
		}
		
		/**
		 * Show/hide rate window.
		 */
		private function onRateClick(evt:MouseEvent):void {
			if (this._reader != null) {
				if (this._reader.logged) {
					this._ratewnd.visible = !this._ratewnd.visible;
					if (this._ratewnd.visible) {
						this._plusmenu.visible = false;
						this._bar.showPlus(true);
						this._commentwnd.visible = false;
						this._messagewnd.visible = false;
						this._addcommentwnd.visible = false;
						this._searchwnd.visible = false;
						this._noteswnd.visible = false;
						this._offlinewnd.visible = false;
						this._bar.visible = false;
						this._time.bgVisible = !this._bar.visible;
						this._mainButton.visible = true;
						this._playActivate = this._player.playing;
						this._player.pause();
					} else {
						if (this._playActivate) this._player.play();
					}
				} else {
					this.showMessage(this._language.getText('LOGINREQUIRED'));
				}
			}
		}
		
		/**
		 * Show/hide offline content window.
		 */
		private function onOfflineClick(evt:MouseEvent):void {
			if (!ManaganaInterface.lockExtra) {
				this._offlinewnd.visible = !this._offlinewnd.visible;
				if (this._offlinewnd.visible) {
					this._plusmenu.visible = false;
					this._bar.showPlus(true);
					this._commentwnd.visible = false;
					this._messagewnd.visible = false;
					this._addcommentwnd.visible = false;
					this._searchwnd.visible = false;
					this._noteswnd.visible = false;
					this._ratewnd.visible = false;
					this._bar.visible = false;
					this._time.bgVisible = !this._bar.visible;
					this._mainButton.visible = true;
					this._playActivate = this._player.playing;
					this._player.pause();
				} else {
					if (this._playActivate) this._player.play();
				}
			}
		}
		
		/**
		 * Warn user about updates on offline content.
		 */
		private function onOfflineUpdate(evt:CommunityContentEvent):void {
			this.showMessage(this._language.getText("OFFLINENEWAVAILABLE"));
		}
		
		/**
		 * Warn user about community download finish.
		 */
		private function onDownloadAll(evt:CommunityContentEvent):void {
			this._uiwarning.setText(this._language.getText('WARNOFFLINEOK'));
		}
		
		/**
		 * Show/hide comment window.
		 */
		private function onCommentClick(evt:MouseEvent):void {
			this._commentwnd.visible = !this._commentwnd.visible;
			if (this._commentwnd.visible) {
				this._plusmenu.visible = false;
				this._bar.showPlus(true);
				this._ratewnd.visible = false;
				this._messagewnd.visible = false;
				this._addcommentwnd.visible = false;
				this._searchwnd.visible = false;
				this._noteswnd.visible = false;
				this._offlinewnd.visible = false;
				this._bar.visible = false;
				this._time.bgVisible = !this._bar.visible;
				this._mainButton.visible = true;
				this._playActivate = this._player.playing;
				this._player.pause();
			} else {
				if (this._playActivate) this._player.play();
			}
		}
		
		/**
		 * Resume playback after a window is closed?
		 */
		private function onWindowClose(evt:Event):void {
			if (this._playActivate) this._player.play();
		}
		
		/**
		 * Add a new comment to current stream.
		 */
		private function onAddComment():void {
			if (this._reader != null) {
				if (this._reader.logged) {
					this._plusmenu.visible = false;
					this._bar.showPlus(true);
					this._commentwnd.visible = false;
					this._messagewnd.visible = false;
					this._ratewnd.visible = false;
					this._addcommentwnd.visible = true;
					this._searchwnd.visible = false;
					this._noteswnd.visible = false;
					this._offlinewnd.visible = false;
					this._bar.visible = false;
					this._time.bgVisible = !this._bar.visible;
					this._mainButton.visible = true;
				} else {
					this.showMessage(this._language.getText('LOGINREQUIRED'));
				}
			}
		}
		
		/**
		 * Open search interface.
		 */
		private function onOpenSearch():void {
			if (this._reader != null) {
				this._plusmenu.visible = false;
				this._bar.showPlus(true);
				this._commentwnd.visible = false;
				this._messagewnd.visible = false;
				this._ratewnd.visible = false;
				this._addcommentwnd.visible = false;
				this._searchwnd.visible = true;
				this._noteswnd.visible = false;
				this._offlinewnd.visible = false;
				this._bar.visible = false;
				this._time.bgVisible = !this._bar.visible;
				this._mainButton.visible = true;
			}
		}
		
		/**
		 * Called on stream rating.
		 * @param	num	the assigned rate
		 */
		private function onRate(num:uint):void {
			if (this._reader != null) this._reader.rateStream(this._player.currentStream, this._player.streamCategory, num);
		}
		
		/**
		 * Add a comment to a stream.
		 * @param	text	the comment to add
		 */
		private function onComment(text:String):void {
			if (this._reader != null) {
				if (this._reader.commentStream(this._player.currentStream, this._player.streamCategory, text)) {
					this._time.startWaiting();
				} else {
					this._time.stopWaiting();
				}
				this._addcommentwnd.visible = false;
			}
		}
		
		/**
		 * A new community started to load.
		 */
		private function onCommunityLoad(evt:DISLoad):void {
			this._previousTime = this._player.streamTime;
			if (this._previousTime == 0) this._previousTime = this._player.streamTotalTime;
			try { this._time.startWaiting(); } catch (e:Error) { }
		}
		
		/**
		 * A new community was loaded.
		 */
		private function onCommunityOK(evt:DISLoad):void {
			// check reader information at reader server
			if (this._waitsystem) {
				this._communitystart = this._player.currentCommunity;
			} else {
				if (this._reader != null) this._reader.getCommunity(this._player.currentCommunity);
			}
			this._time.stopWaiting();
		}
		
		/**
		 * A community failed to load.
		 */
		private function onCommunityERROR(evt:DISLoad):void {
			this._time.stopWaiting();
		}
		
		/**
		 * No system information available: lack of web connection?
		 */
		private function noSystem(evt:ReaderServerEvent):void {
			// prepare language
			this._language = new SystemLanguage();
			this._language.addEventListener(Event.COMPLETE, onLanguageAvailable);
			// show the user interface?
			this.visible = true;
			this._mainButton.visible = this._forceVisible;
			this._mainButton.userVisible = this._forceUser;
			this._logo.visible = this._forceVisible;
			this._time.visible = this._forceShowTime;
			// show buttons
			this._ratebt.visible = false;
			this._commentbt.visible = false;
			this._zoombt.visible = this._forceZoom;
			this._notebt.visible = this._forceNote;
			this._notebt.x = this._commentbt.x;
			// adjust plus menu
			this._plusmenu.setState(false, false, false, false, false);
			// adjust search
			this._searchwnd.setState(false);
			// interface text
			this._ratewnd.text = this._language.getText('RATETEXT');
			this._plusmenu.setText(this._language.getText('LOGINBUTTON'), this._language.getText('LOGOUTBUTTON'));
			this._addcommentwnd.setText(this._language.getText('COMMENTTEXT'), this._language.getText('COMMENTBUTTON'));
			this._searchwnd.setText(this._language.getText('SEARCHNORESULTS'), this._language.getText('SEARCHALLCOMMUNITIES'));
			this._noteswnd.setText(this._language.getText('NOTESTITLE'));
			this._offlinewnd.setText(this._language.getText('OFFLINETITLE'), this._language.getText('OFFLINEGETTINGINFOWAIT'), this._language.getText('OFFLINELISTMARK'), this._language.getText('OFFLINEDOWNBT'), this._language.getText('OFFLINERETBT'), this._language.getText('OFFLINEINFOFOR'), this._language.getText('OFFLINESIZE'), this._language.getText('OFFLINEINFOERROR'), this._language.getText('OFFLINEWIFI'), this._language.getText('OFFLINEDOWNERROR'), this._language.getText('OFFLINEDOWNMSG'), this._language.getText('OFFLINEDOWNCLOSE'), this._language.getText('OFFLINEDOWNCANCEL'), this._language.getText('OFFLINEUPDABOUT'), this._language.getText('OFFLINEUPDBT'), this._language.getText('OFFLINEUPDDEL'));
			// player urls
			if (this._player != null) {
				this._player.shareurl = "";
				this._player.feedurl = "";
			}
			// cirrus service
			this.cirrusKey = "";
			// warn listeners
			if (this._offline.hasOffline) {
				this._offlinewnd.showList();
			}
			this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.NOSYSTEM, String(this._offline.hasOffline)));
		}
		
		/**
		 * Warn interface about offline-only access.
		 */
		public function workOffline():void {
			this._bar.allowOffline = true;
			this._plusmenu.toBasic();
			this._offlinewnd.allowInfo = false;
		}
		
		/**
		 * Show offline window on startup for user to choose.
		 */
		public function showOfflineOptions():void {
			this._bar.allowOffline = true;
			this._plusmenu.toBasic();
			this._offlinewnd.allowInfo = false;
			this.onOfflineClick(null);
			this._mainButton.visible = true;
			this._logo.visible = true;
		}
		
		/**
		 * Managana execution halt warning.
		 */
		public function halt():void {
			this._bar.allowOffline = false;
			this.showMessage(this._language.getText("NOWEBERROR"));
			this._mainButton.visible = true;
			this._mainButton.userVisible = false;
			this._logo.visible = false;
			this._time.visible = false;
			this._ratebt.visible = false;
			this._commentbt.visible = false;
			this._zoombt.visible = false;
			this._notebt.visible = false;
		}
		
		/**
		 * Received system information.
		 */
		private function onSystemInfo(evt:ReaderServerEvent):void {
			if (this._reader != null) {
				// language
				this._language = new SystemLanguage();
				this._language.addEventListener(Event.COMPLETE, onLanguageAvailable);
				// show the user interface?
				this.visible = true;
				this._mainButton.visible = this._forceVisible;
				this._mainButton.userVisible = this._forceUser;
				this._logo.visible = this._forceVisible;
				this._time.visible = this._forceShowTime;
				// show buttons
				this._ratebt.visible = this._forceRate;
				this._commentbt.visible = this._forceComment;
				this._zoombt.visible = this._forceZoom;
				this._notebt.visible = this._forceNote;
				
				if (this._useHolder) {
					if (this._ratebt.visible) this._zoombt.x = ((this._holderBG.width / 3) * 2) - (this._zoombt.width /2);
						else this._zoombt.x = this._holderBG.width - this._zoombt.width - 5;
					if (this._commentbt.visible) this._notebt.x = ((this._holderBG.width / 3) * 1) - (this._notebt.width /2);
						else this._notebt.x = this._commentbt.x;
				} else {
					if (this._ratebt.visible) this._zoombt.x = ((this.stage.stageWidth / 3) * 2) - (this._zoombt.width /2);
						else this._zoombt.x = this.stage.stageWidth - this._zoombt.width - 5;
					if (this._commentbt.visible) this._notebt.x = ((this.stage.stageWidth / 3) * 1) - (this._notebt.width /2);
						else this._notebt.x = this._commentbt.x;
				}
				
				
				
				// adjust plus menu
				this._plusmenu.setState(this._reader.rate, (this._reader.comment != 'none'), this._reader.share, this._reader.search, this._reader.remote);
				// adjust search
				this._searchwnd.setState(this._reader.searchall);
				// interface text
				this._ratewnd.text = this._language.getText('RATETEXT');
				this._plusmenu.setText(this._language.getText('LOGINBUTTON'), this._language.getText('LOGOUTBUTTON'));
				this._addcommentwnd.setText(this._language.getText('COMMENTTEXT'), this._language.getText('COMMENTBUTTON'));
				this._searchwnd.setText(this._language.getText('SEARCHNORESULTS'), this._language.getText('SEARCHALLCOMMUNITIES'));
				this._noteswnd.setText(this._language.getText('NOTESTITLE'));
				this._offlinewnd.setText(this._language.getText('OFFLINETITLE'), this._language.getText('OFFLINEGETTINGINFOWAIT'), this._language.getText('OFFLINELISTMARK'), this._language.getText('OFFLINEDOWNBT'), this._language.getText('OFFLINERETBT'), this._language.getText('OFFLINEINFOFOR'), this._language.getText('OFFLINESIZE'), this._language.getText('OFFLINEINFOERROR'), this._language.getText('OFFLINEWIFI'), this._language.getText('OFFLINEDOWNERROR'), this._language.getText('OFFLINEDOWNMSG'), this._language.getText('OFFLINEDOWNCLOSE'), this._language.getText('OFFLINEDOWNCANCEL'), this._language.getText('OFFLINEUPDABOUT'), this._language.getText('OFFLINEUPDBT'), this._language.getText('OFFLINEUPDDEL'));
				// player urls
				this._player.shareurl = this._reader.shareurl;
				this._player.feedurl = this._reader.feedurl;
				// cirrus service
				this.cirrusKey = this._reader.cirrus;
				// offline access?
				this._bar.allowOffline = this._reader.offline;
				// public remote?
				if (this._premotestart["id"] != "") this.startPublicRemote(this._premotestart["id"], this._premotestart["group"], this._reader.cirrus, this._premotestart["keypass"]);
				// all done, communities can be loaded
				this._waitsystem = false;
				if (this._communitystart != "") {
					this._reader.getCommunity(this._communitystart);
					this._communitystart = "";
				}
				this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.SYSTEM_INFO));
			}
		}
		
		
		/**
		 * Reader server returned community information.
		 */
		private function onCommunityInfo(evt:ReaderServerEvent):void {
			if (this._reader != null) {
				// check information of current stream (home)
				this._reader.getStream(this._player.currentStream, this._player.streamCategory, this._previousStream, this._previousTime, this._player.streamVote, this._previousCom);
				// warn listeners
				this.dispatchEvent(new ReaderServerEvent(ReaderServerEvent.COMMUNITY_INFO));
			}
		}
		
		/**
		 * A new stream started to load.
		 */
		private function onStreamLoad(evt:DISLoad):void {
			if (this._previousTime == 0) {
				this._previousTime = this._player.streamTime;
				if (this._previousTime == 0) this._previousTime = this._player.streamTotalTime;
			}
			this._time.startWaiting();
			this._player.voteVisible = this._forceVote;
		}
		
		/**
		 * A new stream was loaded.
		 */
		private function onStreamOK(evt:DISLoad):void {
			this._commentwnd.clearComments();
			this._commentwnd.refreshList();
			this._ratebt.rate = 0;
			this._ratewnd.rate = 0;
			if (this._reader != null) this._reader.getStream(this._player.currentStream, this._player.streamCategory, this._previousStream, this._previousTime, this._player.streamVote, this._previousCom);
			this._time.stopWaiting();
		}
		
		/**
		 * A straem failed to load.
		 */
		private function onStreamERROR(evt:DISLoad):void {
			this._time.stopWaiting();
		}
		
		/**
		 * Reader server returned stream information.
		 */
		private function onStreamInfo(evt:ReaderServerEvent):void {
			if (this._reader != null) {
				// rate
				this._ratebt.rate = this._reader.streamrate;
				this._ratewnd.rate = this._reader.userrate;
				// comments
				this._commentwnd.clearComments();
				for (var index:uint = 0; index < this._reader.streamComments.length; index++) {
					this._commentwnd.addComment(this._reader.streamComments[index].comment, this._reader.streamComments[index].name, this._reader.streamComments[index].date);
				}
				this._commentwnd.refreshList();
				this._commentbt.setTotal(this._reader.streamComments.length);
				// votes
				if (this._player.voteRecord) for (index = 1; index <= 9; index++) {
					this._player.setVote(index, this._reader.streamVotes[index]);
				}
				this._player.voteVisible = this._forceVote;
				// any remote connected?
				if (this._remotes != new Array()) {
					var ratenum:int = -1;
					if (this._reader.rate) ratenum = this._reader.streamrate;
					var commentnum:int = -1;
					if (this._reader.comment != "none") commentnum = this._reader.streamComments.length;
					if (this._outstream != null) this._outstream.send("playerStreamChange", this._player.currentCommunityTitle, this._player.currentCommunity, this._player.currentStream, this._player.currentStreamTitle, this._player.currentStreamAbout, this._player.streamCategory, ratenum, commentnum, this._reader.streamComments, this._player.streamHasXNext, this._player.streamHasXPrev, this._player.streamHasYNext, this._player.streamHasYPrev, this._player.voteEnabled(1), this._player.voteEnabled(2), this._player.voteEnabled(3), this._player.voteEnabled(4), this._player.voteEnabled(5), this._player.voteEnabled(6), this._player.voteEnabled(7), this._player.voteEnabled(8), this._player.voteEnabled(9), this._player.remoteStream);
					if (this._netgroup != null) this.processMessage( { command: "sendStream" } );
					this.sendToTCP("sendStream");
				}
				// save stream info as "previous"
				this._previousStream = this._player.currentStream;
				this._previousCom = this._player.currentCommunity;
				this._previousTime = 0;
			}
		}
		
		/**
		 * Stream rate changed.
		 */
		private function onStreamRate(evt:ReaderServerEvent):void {
			if (this._reader != null) this._ratebt.rate = this._reader.streamrate;
		}
		
		/**
		 * Last server interaction returned an error.
		 */
		private function onReaderError(evt:ReaderServerEvent):void {
			this.noSystem(null);
		}
		
		/**
		 * A message was received from the server.
		 */
		private function onReaderMessage(evt:ReaderServerEvent):void {
			if (this._reader != null) {
				// check reader action
				switch (this._reader.lastAction) {
					case "comment":
						this._uiwarning.setText(this._language.getText("WARNCOMMENTADD"));
						break;
					case "rate":
						this._uiwarning.setText(this._language.getText("WARNRATEADD"));
						break;
					case "login":
						this._uiwarning.setText(this._language.getText("WARNLOGIN"));
						break;
					case "logout":
						this._uiwarning.setText(this._language.getText("WARNLOGOUT"));
						break;
				}
				// check for login
				this._plusmenu.setLogin(this._reader.logged);
				this._player.usrLogged = this._reader.logged;
				if (this._reader.logged) {
					this._mainButton.username = this._reader.usrmail;
					// start accepting remote controllers?
					if (this._publicRemote == "") {
						this.startPublicRemote(this._reader.remotekey, this.remoteGroup, this.cirrusKey);
					}
				} else {
					this._mainButton.username = "";
					this.stopRemote();
					this.stopRemoteLocal();
				}
				// check comment
				if (this._reader.lastAction == "comment") {
					if (this._reader.comment == "free") {
						this._commentwnd.addComment(this._addcommentwnd.comment, this._reader.usrname, "");
						this._commentwnd.refreshList();
						this._commentbt.setTotal(this._reader.streamComments.length);
					}
				}
				// hide waiting animation
				this._time.stopWaiting();
			}
		}
		
		/**
		 * Facebook button click.
		 */
		private function onFacebook():void {
			if (this._reader != null) if (this._reader.shareurl != "") {
				var shareURL:String = "http://www.facebook.com/sharer.php?t=" + escape(this._reader.comname) + "&u=" + escape(this._reader.shareurl + "?c=" + this._player.currentCommunity + "&s=" + this._player.currentStream);
				this.dispatchEvent(new Message(Message.SHARE_FACEBOOK, { value:shareURL, community:this._player.currentCommunity, stream:this._player.currentStream, share:this._reader.shareurl } ));
			}
		}
		
		/**
		 * Twitter button click.
		 */
		private function onTwitter():void {
			if (this._reader != null) if (this._reader.shareurl != "") {
				var shareURL:String = "https://twitter.com/intent/tweet?text=" + encodeURI(this._player.currentCommunityTitle + ": " + this._player.currentStreamTitle) + "&url=" + escape(this._reader.shareurl + "?c=" + this._player.currentCommunity + "&s=" + this._player.currentStream);
				this.dispatchEvent(new Message(Message.SHARE_TWITTER, { value:shareURL, community:this._player.currentCommunity, stream:this._player.currentStream, share:this._reader.shareurl } ));
			}
		}
		
		/**
		 * Google plus button click.
		 */
		private function onGPlus():void {
			if (this._reader != null) if (this._reader.shareurl != "") {
				var shareURL:String = "https://plus.google.com/share?url=" + escape(this._reader.shareurl + "?c=" + this._player.currentCommunity + "&s=" + this._player.currentStream);
				this.dispatchEvent(new Message(Message.SHARE_GPLUS, { value:shareURL, community:this._player.currentCommunity, stream:this._player.currentStream, share:this._reader.shareurl } ));
			}
		}
		
		/**
		 * Player playback started.
		 */
		private function onPlay(evt:Playing):void {
			this._time.playVisible = false;
		}
		
		/**
		 * Player playback paused.
		 */
		private function onPause(evt:Playing):void {
			this._time.playVisible = true;
		}
		
		/**
		 * Click on time button.
		 */
		private function onTimeClick(evt:MouseEvent):void {
			if (this._player.playing) this._player.pause();
				else (this._player.play());
			/*if (this._bar.playVisible) this._player.play();
				else (this._player.pause());*/
		}
		
		/**
		 * Timer update.
		 */
		private function onTimer(evt:TimerEvent):void {
			this._time.setTime(this._player.streamTime, this._player.streamTotalTime);
			// check for block keyboard
			if (this.checkKeyboard) {
				if (this._commentwnd.visible || this._searchwnd.visible || this._noteswnd.visible) this._player.allowKeyboard = false;
					else this._player.allowKeyboard = true;
			}
			// checking for drag lock
			if (this._commentwnd.visible || this._searchwnd.visible || this._noteswnd.visible || this._offlinewnd.visible) this._player.allowDrag = false;
				else this._player.allowDrag = true;
		}
		
		/**
		 * A new community list is available.
		 */
		private function onCommunityList(evt:ReaderServerEvent):void {
			// any remote connected?
			if (this._reader != null) if (this._remotes != new Array()) {
				if (this._outstream != null) this._outstream.send("newCommunityList", this._reader.communityList);
				if (this._netgroup != null) this.processMessage( { command: "newCommunityList" } );
				this.sendToTCP('newCommunityList');
			}
		}
		
		/**
		 * A new stream list is available.
		 */
		private function onStreamList(evt:ReaderServerEvent):void {
			// any remote connected?
			if (this._reader != null) if (this._remotes != new Array()) {
				if (this._outstream != null) this._outstream.send("newStreamList", this._reader.streamList);
				if (this._netgroup != null) this.processMessage( { command: "newStreamList" } );
				this.sendToTCP('newStreamList');
			}
		}
		
		/**
		 * The server returned a valid public key to use for remote control.
		 */
		private function onPublicKey(evt:ReaderServerEvent):void {
			if (this._reader != null) if (this._reader.validPKey != "") {
				this._publicRemote = this._reader.validPKey;
				this.startPublicRemoteWeb();
			}
		}
		
		/**
		 * Action function for the zoom buttons.
		 * @param	ac	the action: "minus", "center" or "plus"
		 */
		private function zoomAction(ac:String):void {
			switch (ac) {
				case 'minus':
					if (this._player.scaleX > 0.3) {
						this._player.scaleX = this._player.scaleY = (this._player.scaleX - 0.1);
					}
					break;
				case 'plus':
					if (this._player.scaleX < 3) {
						this._player.scaleX = this._player.scaleY = (this._player.scaleX + 0.1);
					}
					break;
				case 'center':
					this._player.scaleX = this._player.scaleY = 1;
					if (this._useHolder) {
						this._player.x = this._holderBG.width / 2;
						this._player.y = this._holderBG.height / 2;
					} else {
						this._player.x = this.stage.stageWidth / 2;
						this._player.y = this.stage.stageHeight / 2;
					}
					break;
			}
		}
		
		/**
		 * User data was successfully saved on server.
		 */
		private function onDataSaved(evt:ReaderServerEvent):void {
			// do nothing
		}
		
		/**
		 * User data was successfully loaded from server.
		 */
		private function onDataLoaded(evt:ReaderServerEvent):void {
			if (this._reader != null) {
				// get retrieved data
				this._player.strValues = this._reader.strValues;
				this._player.numValues = this._reader.numValues;
			}
		}
		
		/**
		 * Request community values data load.
		 */
		private function loadComValues(evt:Message):void {
			if (this._reader != null) this._reader.loadComValues(this._player.currentCommunity);
		}
		
		/**
		 * Community data values were successfully loaded from server.
		 */
		private function onComDataLoaded(evt:ReaderServerEvent):void {
			// get retrieved data
			if (this._reader != null) this._player.comValues = this._reader.comValues;
		}
		
		/**
		 * Request community value data save.
		 */
		private function saveComValue(evt:Message):void {
			if (this._reader != null) this._reader.saveComValue(this._player.currentCommunity, String(evt.param.varName), String(evt.param.varValue));
		}
		
		/**
		 * Request comunity value data change.
		 */
		private function changeComValue(evt:Message):void {
			if (this._reader != null) this._reader.changeComValue(this._player.currentCommunity, String(evt.param.varName), String(evt.param.varValue), String(evt.param.varAction));
		}
		
	}

}
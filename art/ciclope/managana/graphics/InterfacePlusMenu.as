package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.StageDisplayState;
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaInterface;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * InterfacePlusMenu provides a graphic interface for Managana reader plus menu.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class InterfacePlusMenu extends Sprite {
		
		// VARIABLES
		
		private var _ready:Boolean;							// is the menu ready?
		private var _bg:InterfaceWindow;					// the menu background
		private var _timebutton:InterfaceCheckButton;		// the toggle time button
		private var _comment:InterfaceCheckButton;			// the toggle comment button
		private var _rate:InterfaceCheckButton;				// the toggle rate button
		private var _username:InterfaceCheckButton;			// the toggle user name button
		private var _votebutton:InterfaceCheckButton;		// the toggle voting graphics button
		private var _zoom:InterfaceCheckButton;				// the toggle zoom button
		private var _notes:InterfaceCheckButton;			// the toggle notes button
		private var _remotebutton:InterfaceCheckButton;		// the allow remote button
		private var _login:InterfaceButton;					// the login button
		private var _logout:InterfaceButton;				// the logout button
		private var _facebook:Sprite;						// facebook share button
		private var _twitter:Sprite;						// twitter share button
		private var _gplus:Sprite;							// google plus share button
		private var _search:Sprite;							// button for search
		private var _web:Boolean;							// is web (server information) available?
		private var _rateEnable:Boolean;					// enable rate button?
		private var _commentEnable:Boolean;					// enable comment button?
		private var _nameEnable:Boolean;					// enable name button?
		
		// PUBLIC VARIABLES
		
		/**
		 * A function to call on time button click.
		 */
		public var timeclick:Function;
		/**
		 * A function to call on comment button click.
		 */
		public var commentclick:Function;
		/**
		 * A function to call on rate button click.
		 */
		public var rateclick:Function;
		/**
		 * A function to call on vote button click.
		 */
		public var voteclick:Function;
		/**
		 * A function to call on remote button click.
		 */
		public var remoteclick:Function;
		/**
		 * A function to call on username button click.
		 */
		public var userclick:Function;
		/**
		 * A function to call on login button click.
		 */
		public var loginclick:Function;
		/**
		 * A function to call on logout button click.
		 */
		public var logoutclick:Function;
		/**
		 * A function to call on facebook button click.
		 */
		public var facebookclick:Function;
		/**
		 * A function to call on twitter button click.
		 */
		public var twitterclick:Function;
		/**
		 * A function to call on google plus button click.
		 */
		public var gplusclick:Function;
		/**
		 * A function to call on search button click.
		 */
		public var searchclick:Function;
		/**
		 * A function to call on notes button click.
		 */
		public var noteclick:Function;
		/**
		 * A function to call on zoom button click.
		 */
		public var zoomclick:Function;
		
		/**
		 * InterfacePlusMenu constructor.
		 * @param	web	is web (server information) available?
		 */
		public function InterfacePlusMenu(web:Boolean = true) {
			this._ready = false;
			this._web = web;
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		/**
		 * The stage became available.
		 */
		private function onStage(evt:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			// prepare graphics
			this._bg = new InterfaceWindow(false);
			this._bg.width = 360;
			this.addChild(this._bg);
			this._ready = true;
			// web available?
			if (this._web) {
				// first button line
				this._facebook = new ButtonFacebook() as Sprite;
				ManaganaInterface.setSize(this._facebook);
				this._facebook.x = (this._bg.width / 8) - (this._facebook.width / 2);
				this._facebook.y = 20;
				this._facebook.alpha = 0.5;
				this.addChild(this._facebook);
				this._twitter = new ButtonTwitter() as Sprite;
				ManaganaInterface.setSize(this._twitter);
				this._twitter.x = (3 * this._bg.width / 8) - (this._twitter.width / 2);
				this._twitter.y = 20;
				this._twitter.alpha = 0.5;
				this.addChild(this._twitter);
				this._gplus = new ButtonGPlus() as Sprite;
				ManaganaInterface.setSize(this._gplus);
				this._gplus.x = (5 * this._bg.width / 8) - (this._gplus.width / 2);
				this._gplus.y = 20;
				this._gplus.alpha = 0.5;
				this.addChild(this._gplus);
				this._search = new ButtonSearch() as Sprite;
				ManaganaInterface.setSize(this._search);
				this._search.x = (7 * this._bg.width / 8) - (this._search.width / 2);
				this._search.y = 20;
				this._search.alpha = 0.5;
				this.addChild(this._search);
				// second button line
				this._timebutton = new InterfaceCheckButton("time");
				ManaganaInterface.setSize(this._timebutton);
				this._timebutton.x = (1 * this._bg.width / 8) - (this._timebutton.width / 2);
				this._timebutton.y = this._facebook.y + this._facebook.height + 20;
				this._timebutton.addEventListener(MouseEvent.CLICK, onTimeClick);
				this.addChild(this._timebutton);
				this._zoom = new InterfaceCheckButton("zoom");
				ManaganaInterface.setSize(this._zoom);
				this._zoom.x = (3 * this._bg.width / 8) - (this._zoom.width / 2);
				this._zoom.y = this._timebutton.y;
				this._zoom.addEventListener(MouseEvent.CLICK, onZoomClick);
				this.addChild(this._zoom);
				this._notes = new InterfaceCheckButton("notes");
				ManaganaInterface.setSize(this._notes);
				this._notes.x = (5 * this._bg.width / 8) - (this._notes.width / 2);
				this._notes.y = this._timebutton.y;
				this._notes.addEventListener(MouseEvent.CLICK, onNotesClick);
				this.addChild(this._notes);
				this._votebutton = new InterfaceCheckButton("vote");
				ManaganaInterface.setSize(this._votebutton);
				this._votebutton.x = (7 * this._bg.width / 8) - (this._votebutton.width / 2);
				this._votebutton.y = this._timebutton.y;
				this._votebutton.addEventListener(MouseEvent.CLICK, onVoteClick);
				this.addChild(this._votebutton);
				// third button line
				this._comment = new InterfaceCheckButton("comment");
				ManaganaInterface.setSize(this._comment);
				this._comment.x = (1 * this._bg.width / 8) - (this._comment.width / 2);
				this._comment.y = this._timebutton.y + this._timebutton.height + 20;
				this._comment.addEventListener(MouseEvent.CLICK, onCommentClick);
				this.addChild(this._comment);
				this._rate = new InterfaceCheckButton("rate");
				ManaganaInterface.setSize(this._rate);
				this._rate.x = (3 * this._bg.width / 8) - (this._rate.width / 2);
				this._rate.y = this._comment.y;
				this._rate.addEventListener(MouseEvent.CLICK, onRateClick);
				this.addChild(this._rate);
				this._username = new InterfaceCheckButton("name");
				ManaganaInterface.setSize(this._username);
				this._username.x = (5 * this._bg.width / 8) - (this._username.width / 2);
				this._username.y = this._comment.y;
				this._username.addEventListener(MouseEvent.CLICK, onUsernameClick);
				this.addChild(this._username);
				this._remotebutton = new InterfaceCheckButton("remote");
				ManaganaInterface.setSize(this._remotebutton);
				this._remotebutton.x = (7 * this._bg.width / 8) - (this._remotebutton.width / 2);
				this._remotebutton.y = this._comment.y;
				this._remotebutton.addEventListener(MouseEvent.CLICK, onRemoteClick);
				this.addChild(this._remotebutton);
				// fourth button line
				this._login = new InterfaceButton();
				this._logout = new InterfaceButton();
				this._login.x = this._logout.x = this._facebook.x;
				this._login.y = this._logout.y = this._comment.y + this._comment.height + 20;
				this._login.width = this._logout.width = this._bg.width - (2 * this._login.x);
				this._login.buttonMode = this._logout.buttonMode = true;
				this._login.useHandCursor = this._logout.useHandCursor = true;
				this._login.addEventListener(MouseEvent.CLICK, onLoginClick);
				this.addChild(this._login);
				this._logout.visible = false;
				this._logout.addEventListener(MouseEvent.CLICK, onLogoutClick);
				this.addChild(this._logout);
				// background height
				this._bg.height = this._login.y + this._login.height + 20;
			} else { // no web
				// draw only non-web buttons
				this._timebutton = new InterfaceCheckButton("time");
				ManaganaInterface.setSize(this._timebutton);
				this._timebutton.x = (1 * this._bg.width / 8) - (this._timebutton.width / 2);
				this._timebutton.y = 20;
				this._timebutton.addEventListener(MouseEvent.CLICK, onTimeClick);
				this.addChild(this._timebutton);
				this._zoom = new InterfaceCheckButton("zoom");
				ManaganaInterface.setSize(this._zoom);
				this._zoom.x = (3 * this._bg.width / 8) - (this._zoom.width / 2);
				this._zoom.y = this._timebutton.y;
				this._zoom.addEventListener(MouseEvent.CLICK, onZoomClick);
				this.addChild(this._zoom);
				this._notes = new InterfaceCheckButton("notes");
				ManaganaInterface.setSize(this._notes);
				this._notes.x = (5 * this._bg.width / 8) - (this._notes.width / 2);
				this._notes.y = this._timebutton.y;
				this._notes.addEventListener(MouseEvent.CLICK, onNotesClick);
				this.addChild(this._notes);
				this._votebutton = new InterfaceCheckButton("vote");
				ManaganaInterface.setSize(this._votebutton);
				this._votebutton.x = (7 * this._bg.width / 8) - (this._votebutton.width / 2);
				this._votebutton.y = this._timebutton.y;
				this._votebutton.addEventListener(MouseEvent.CLICK, onVoteClick);
				this.addChild(this._votebutton);
				// background height
				this._bg.height = this._timebutton.y + this._timebutton.height + 20;
			}
			this.redraw(((this.stage.stageWidth - this.width) / 2), ((this.stage.stageHeight - this.height) / 2));
		}
		
		// PUBLIC METHODS
		
		/**
		 * Enable only basic, offline functions of the plus menu.
		 */
		public function toBasic():void {
			if (this._facebook != null) {
				this._facebook.visible = false;
				this._twitter.visible = false;
				this._gplus.visible = false;
				this._search.visible = false;
				this._login.visible = false;
				this._logout.visible = false;
				this._comment.visible = false;
				this._username.visible = false;
				this._rate.visible = false;
				this._remotebutton.visible = false;
			}
			this._timebutton.y = 20;
			this._notes.y = 20;
			this._zoom.y = 20;
			this._votebutton.y = 20;
			this._bg.height = this._timebutton.y + this._timebutton.height + 20;
		}
		
		/**
		 * Check/uncheck toggle buttons.
		 * @param	rate	rate button checked?
		 * @param	comment	comment button checked?
		 * @param	time	time button checked?
		 * @param	vote	vote button checked?
		 * @param	zoom	zoom button checked?
		 * @param	notes	notes button checked?
		 * @param	name	name button checked?
		 */
		public function checkButtons(rate:Boolean, comment:Boolean, time:Boolean, vote:Boolean, zoom:Boolean, notes:Boolean, name:Boolean):void {
			// web based
			if (this._rate != null) {
				this._rate.checked = false;
				this._rate.enabled = false;
				this._rateEnable = rate;
				this._rate.alpha = 0.5;
			}
			if (this._comment != null) {
				this._comment.checked = false;
				this._comment.enabled = false;
				this._commentEnable = comment;
				this._comment.alpha = 0.5;
			}
			if (this._username != null) {
				this._username.checked = false;
				this._username.enabled = false;
				this._nameEnable = name;
				this._username.alpha = 0.5;
			}
			if (this._remotebutton != null) {
				this._remotebutton.checked = false;
				this._remotebutton.enabled = false;
				this._remotebutton.alpha = 0.5;
			}
			// local
			this._timebutton.checked = time;
			this._timebutton.enabled = true;
			this._votebutton.checked = vote;
			this._votebutton.enabled = true;
			this._zoom.checked = zoom;
			this._zoom.enabled = true;
			this._notes.checked = notes;
			this._notes.enabled = true;
		}
		
		/**
		 * Set plus menu buttons state after web is available.
		 * @param	userate	make rate available?
		 * @param	usecomment	make comment available?
		 * @param	useshare	make sharing available?
		 * @param	usesearch	make search available?
		 * @param	useremote	use remote control by default?
		 */
		public function setState(userate:Boolean, usecomment:Boolean, useshare:Boolean, usesearch:Boolean, useremote:Boolean):void {
			if ((userate) && (this._rate != null)) {
				this._rate.enabled = true;
				this._rate.checked = this._rateEnable;
				this._rate.alpha = 1;
			}
			if ((usecomment) && (this._comment != null)) {
				this._comment.enabled = true;
				this._comment.checked = this._commentEnable;
				this._comment.alpha = 1;
			}
			if (this._remotebutton != null) {
				this._remotebutton.checked = useremote;
				this._remotebutton.enabled = true;
				this._remotebutton.alpha = 1;
			}
			if (this._username != null) {
				this._username.checked = this._nameEnable;
				this._username.enabled = true;
				this._username.alpha = 1;
			}
			if ((useshare) && (this._facebook != null)) {
				this._facebook.alpha = 1;
				this._twitter.alpha = 1;
				this._gplus.alpha = 1;
				this._facebook.addEventListener(MouseEvent.CLICK, onFacebook);
				this._twitter.addEventListener(MouseEvent.CLICK, onTwitter);
				this._gplus.addEventListener(MouseEvent.CLICK, onGPlus);
				this._facebook.useHandCursor = true;
				this._facebook.buttonMode = true;
				this._twitter.useHandCursor = true;
				this._twitter.buttonMode = true;
				this._gplus.useHandCursor = true;
				this._gplus.buttonMode = true;
			}
			if ((usesearch) && (this._search != null)) {
				this._search.alpha = 1;
				this._search.addEventListener(MouseEvent.CLICK, onSearch);
				this._search.useHandCursor = true;
				this._search.buttonMode = true;
			}
		}
		
		/**
		 * Set plus menu buttons text.
		 * @param	login	text for login button
		 * @param	logout	text for logout button
		 */
		public function setText(login:String, logout:String):void {
			if (this._login != null) {
				this._login.text = login;
				this._logout.text = logout;
			}
		}
		
		/**
		 * Show/hide login and logout buttons.
		 * @param	to	is an user logged?
		 */
		public function setLogin(to:Boolean):void {
			if (this._login != null) {
				this._login.visible = !to;
				this._logout.visible = to;
			}
		}
		
		/**
		 * Redraw this menu.
		 */
		public function redraw(toX:Number, toY:Number):void {
			if (this._ready) {
				this.x = toX;
				this.y = toY;
				if ((this.x + this.width) > this.stage.stageWidth) {
					this.x = this.stage.stageWidth - this.width - 5;
				}
			}
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			if (this._ready) {
				this.removeChild(this._bg);
				this._bg = null;
				if (this._timebutton != null) {
					this.removeChild(this._timebutton);
					this._timebutton.removeEventListener(MouseEvent.CLICK, onTimeClick);
					this._timebutton.kill();
					this._timebutton = null;
				}
				if (this._comment != null) {
					this.removeChild(this._comment);
					this._comment.removeEventListener(MouseEvent.CLICK, onCommentClick);
					this._comment.kill();
					this._comment = null;
				}
				if (this._rate != null) {
					this.removeChild(this._rate);
					this._rate.removeEventListener(MouseEvent.CLICK, onRateClick);
					this._rate.kill();
					this._rate = null;
				}
				if (this._votebutton != null) {
					this.removeChild(this._votebutton);
					this._votebutton.removeEventListener(MouseEvent.CLICK, onVoteClick);
					this._votebutton.kill();
					this._votebutton = null;
				}
				if (this._remotebutton != null) {
					this.removeChild(this._remotebutton);
					this._remotebutton.removeEventListener(MouseEvent.CLICK, onRemoteClick);
					this._remotebutton.kill();
					this._remotebutton = null;
				}
				if (this._login != null) {
					this.removeChild(this._login);
					this._login.removeEventListener(MouseEvent.CLICK, onLoginClick);
					this._login.kill();
					this._login = null;
					this.removeChild(this._logout);
					this._logout.removeEventListener(MouseEvent.CLICK, onLogoutClick);
					this._logout.kill();
					this._logout = null;
				}
			} else {
				this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			}
			this.timeclick = null;
			this.commentclick = null;
			this.rateclick = null;
			this.loginclick = null;
			this.logoutclick = null;
			this.voteclick = null;
			this.remoteclick = null;
			this.searchclick = null;
			this.noteclick = null;
			this.zoomclick = null;
		}
		
		// PRIVATE METHODS
		
		/**
		 * Time button clicked.
		 */
		private function onTimeClick(evt:MouseEvent):void {
			if (this._timebutton.enabled) {
				this._timebutton.checked = !this._timebutton.checked;
				if (this.timeclick != null) this.timeclick(this._timebutton.checked);
			}
		}
		
		/**
		 * Comment button clicked.
		 */
		private function onCommentClick(evt:MouseEvent):void {
			if (this._comment.enabled) {
				this._comment.checked = !this._comment.checked;
				if (this.commentclick != null) this.commentclick(this._comment.checked);
			}
		}
		
		/**
		 * Rate button clicked.
		 */
		private function onRateClick(evt:MouseEvent):void {
			if (this._rate.enabled) {
				this._rate.checked = !this._rate.checked;
				if (this.rateclick != null) this.rateclick(this._rate.checked);
			}
		}
		
		/**
		 * Vote button clicked.
		 */
		private function onVoteClick(evt:MouseEvent):void {
			this._votebutton.checked = !this._votebutton.checked;
			if (this.voteclick != null) this.voteclick(this._votebutton.checked);
		}
		
		/**
		 * Remote button clicked.
		 */
		private function onRemoteClick(evt:MouseEvent):void {
			
			
			
			this._remotebutton.checked = !this._remotebutton.checked;
			if (this.remoteclick != null) this.remoteclick(this._remotebutton.checked);
		}
		
		/**
		 * Username button clicked.
		 */
		private function onUsernameClick(evt:MouseEvent):void {
			this._username.checked = !this._username.checked;
			if (this.userclick != null) this.userclick(this._username.checked);
		}
		
		/**
		 * Search button clicked.
		 */
		private function onSearch(evt:MouseEvent):void {
			if (this.searchclick != null) this.searchclick();
		}
		
		/**
		 * Zoom button clicked.
		 */
		private function onZoomClick(evt:MouseEvent):void {
			this._zoom.checked = !this._zoom.checked;
			if (this.zoomclick != null) this.zoomclick(this._zoom.checked);
		}
		
		/**
		 * Notes button clicked.
		 */
		private function onNotesClick(evt:MouseEvent):void {
			this._notes.checked = !this._notes.checked;
			if (this.noteclick != null) this.noteclick(this._notes.checked);
		}
		
		/**
		 * Login button clicked.
		 */
		private function onLoginClick(evt:MouseEvent):void {
			if (this.loginclick != null) this.loginclick();
		}
		
		/**
		 * Logout button clicked.
		 */
		private function onLogoutClick(evt:MouseEvent):void {
			if (this.logoutclick != null) this.logoutclick();
		}
		
		/**
		 * Facebook button click.
		 */
		private function onFacebook(evt:MouseEvent):void {
			if (this.facebookclick != null) this.facebookclick();
		}
		
		/**
		 * Twitter button click.
		 */
		private function onTwitter(evt:MouseEvent):void {
			if (this.twitterclick != null) this.twitterclick();
		}
		
		/**
		 * Google plus button click.
		 */
		private function onGPlus(evt:MouseEvent):void {
			if (this.gplusclick != null) this.gplusclick();
		}
		
	}

}
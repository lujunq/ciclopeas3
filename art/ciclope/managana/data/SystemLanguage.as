package art.ciclope.managana.data {
	
	// FLASH PACKAGES
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.system.Capabilities;
	import flash.events.EventDispatcher;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * SystemLanguage holds text strings for Managana interface in the chosen language.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class SystemLanguage extends EventDispatcher {
		
		// VARIABLES
		
		private var _language:Array;		// the language strings
		private var _chosenLang:String;		// the chosen language
		
		public function SystemLanguage() {
			// prepare initial, default language (en)
			this._chosenLang = "en";
			this._language = new Array();
			// general text
			this._language["NOWEBERROR"] = "No Internet connection detected and no offline content available. The application can't run.";
			this._language["LOGINERROR"] = "Your login was not recognized. Please try again.";
			this._language["LOGINRECOVERPASS"] = "forgot your password?";
			this._language["LOGINTITLE"] = "Managana login";
			this._language["RATETEXT"] = "rate this stream";
			this._language["TIMEMENU"] = "Time";
			this._language["LOGINRECOVERABOUT"] = "In order to change your Managana password, provide your e-mail address and the new password below. The change will only be completed after you access your inbox and follow the new password validation instructions.";
			this._language["LOGINMAILFIELD"] = "your e-mail";
			this._language["COMMENTBUTTON"] = "add comment";
			this._language["LOGINNORETURN"] = "return to Managana without login";
			this._language["MAILNEWSUBJECT"] = "Welcome to Managana";
			this._language["RATEMENU"] = "Rate";
			this._language["LOGINREQUIRED"] = "You must login before rating or commenting streams.";
			this._language["LOGINRECOVEROK"] = "Your e-mail address was found at our database. You'll soon receive a message on your inbox with an aditional step to validate the new password.";
			this._language["COMMENTADD"] = "Your comment was received.";
			this._language["LOGINPASSFIELD"] = "your password";
			this._language["CREATETEXT"] = "create an account";
			this._language["MAILRECOVERSUBJECT"] = "Managana password change";
			this._language["LOGINOPENCANCEL"] = "The authentication was cancelled. Would you like to try again?";
			this._language["LOGINWITHGUEST"] = "Login with your Managana account. You may also use your Google or Yahoo accounts by clicking the logos. Managana Will not receive your password for Google and Yahoo: you'll be redirected to their site to login.";
			this._language["MAILNEWBODY"] = "Hi, [NAME], and welcome to Managana!\n\nA new account was set to you with the following data:\n\ne-mail address: [EMAIL]\npassword: [PASS]\n\nYou can access the Managana content here: [VIEWLINK]\n\nYou can also access the Managana editor by clicking on this link: [LINK]";
			this._language["LOGINRECOVERBUTTON"] = "change my password";
			this._language["LOGOUTBUTTON"] = "logout";
			this._language["LOGINCHECKLABEL"] = "check login";
			this._language["LOGINOK"] = "Welcome, [NAME]. You have successfully validated your account. Click on the button below to return to Managana.";
			this._language["COMMENTMENU"] = "Comment";
			this._language["MAILRECOVERBODY"] = "You asked for a password change for your Managana account. In order to complete the process, just access the link below:\n\n[LINK]\n\nIf you did not ask for this, don't worry. Just ignore this message.";
			this._language["COMMENTTEXT"] = "comment this stream";
			this._language["LOGINNOGUEST"] = "Please provide your e-mail and password to access Managana.";
			this._language["LOGINSUCCESS"] = "Welcome back to Managana!";
			this._language["LOGINWAIT"] = "Please wait while the chosen authentication service is open...";
			this._language["LOGINRECOVERMAILFIELD"] = "your e-mail";
			this._language["USERMENU"] = "User name";
			this._language["MAILNEWBODYSUBSCRIBER"] = "Hi, [NAME], and welcome to Managana!\n\nA new account was set to you with the following data:\n\ne-mail address: [EMAIL]\npassword: [PASS]\n\nYou can access the Managana content by clicking on this link: [VIEWLINK]";
			this._language["LOGINBUTTON"] = "login";
			this._language["LOGINRECOVERPASSFIELD"] = "the new password";
			this._language["LOGINRECOVERNOTFOUND"] = "The provided e-mail address was not found at our database. Please try again.";
			this._language["LOGINOKRETURN"] = "return to Managana";
			this._language["LOGINFAIL"] = "The authentication failed. Would you like to try again?";
			this._language["READERERROR"] = "The communication with the server failed.";
			this._language["REMOTEMENU"] = "Remote";
			this._language["COMMENTWAIT"] = "Your comment was received and is waiting for approval.";
			this._language["VOTEMENU"] = "Vote";
			this._language["SEARCHNORESULTS"] = "no results found";
			this._language["SEARCHALLCOMMUNITIES"] = "search on all available communities";
			this._language["NOTESTITLE"] = "Notes and bookmarks";
			// content manager
			this._language["OFFLINETITLE"] = "Content management";
			this._language["OFFLINEGETTINGINFOWAIT"] = "Getting content information. Please wait...";
			this._language["OFFLINELISTMARK"] = "[offline]";
			this._language["OFFLINEDOWNBT"] = "download content for offline access";
			this._language["OFFLINERETBT"] = "return to list";
			this._language["OFFLINEINFOFOR"] = "content information for";
			this._language["OFFLINESIZE"] = "expected download size";
			this._language["OFFLINEINFOERROR"] = "Sorry, the information about the selected content is not available.";
			this._language["OFFLINEWIFI"] = "Before start downloding, please check your web connection. Wi-fi is always preferred since the content size may lead to mobile connection plans charges.";
			this._language["OFFLINEDOWNERROR"] = "Error found while downloading the requested content. Please try again.";
			this._language["OFFLINEDOWNMSG"] = "Downloading content. Please wait...\n\nYou may safely close this window and keep using Managana. Your download will continue in background. If you exit Managana the download will be paused and resumed when the application is restarted.";
			this._language["OFFLINEDOWNCLOSE"] = "close this download window";
			this._language["OFFLINEDOWNCANCEL"] = "cancel the download";
			this._language["OFFLINEUPDABOUT"] = "You can check updates for this content and also remove it from you offline collection. If you delete it, you'll need to download the entire content again to access it offline.";
			this._language["OFFLINEUPDBT"] = "check for content updates";
			this._language["OFFLINEUPDDEL"] = "delete content";
			this._language["OFFLINENEWAVAILABLE"] = "Updates found for your current offline content. Please check the content manager.";
			// ui warnings
			this._language["WARNCLOCKOFF"] = "clock disabled";
			this._language["WARNCOMMENTOFF"] = "comments disabled";
			this._language["WARNUSEROFF"] = "user name disabled";
			this._language["WARNNOTEON"] = "notes enabled";
			this._language["WARNNOTEOFF"] = "notes disabled";
			this._language["WARNRATEON"] = "rating enabled";
			this._language["WARNCLOCKON"] = "clock enabled";
			this._language["WARNRATEOFF"] = "rating disabled";
			this._language["WARNREMOTEON"] = "remote control enabled";
			this._language["WARNCOMMENTON"] = "comments enabled";
			this._language["WARNREMOTEOFF"] = "remote control disabled";
			this._language["WARNUSERON"] = "user name enabled";
			this._language["WARNVOTEOFF"] = "voting options disabled";
			this._language["WARNVOTEON"] = "voting options enabled";
			this._language["WARNOFFLINEOK"] = "offline content downloaded";
			this._language["WARNCOMMENTADD"] = "comment add";
			this._language["WARNRATEADD"] = "rate received";
			this._language["WARNLOGIN"] = "user logged in";
			this._language["WARNLOGOUT"] = "user logged out";
			this._language["WARNZOOMON"] = "zoom buttons visible";
			this._language["WARNZOOMOFF"] = "zoom buttons hidden";
			// leap motion
			this._language["LEAPCALIBRATING"] = "calibrating the Leap Motion device";
			this._language["LEAPERROR"] = "errors found while calibrating the Leap Motion device";
			this._language["LEAPPOINTTL"] = "point to the top left corner of the window for a while";
			this._language["LEAPSUCCESS"] = "Leap Motion device successfully calibrated";
			this._language["LEAPPOINTBR"] = "point to the bottom right corner of the window for a while";
			// remote
			this._language["REMOTENOPEER"] = "The peer network could not be initialized. Remote controls won't work. Check your Flash Player settings to enable peer network for this site.";
			this._language["REMOTECOMMENTSFOR1"] = "comment for";
			this._language["REMOTEINFOLOGINTITLE"] = "Connection";
			this._language["REMOTEINFOCONNECTCIRRUS"] = "looking for player over the Internet...";
			this._language["REMOTERATESENT"] = "thank you for your rating";
			this._language["REMOTESTREAMSTAB"] = "streams";
			this._language["REMOTEINFOCONNECTEDAS"] = "Connected as";
			this._language["REMOTECOMMENTSFOR0"] = "no comments for";
			this._language["REMOTERATETITLE"] = "Rating for";
			this._language["REMOTECOMMENTSLOGIN"] = "you must login to add comments";
			this._language["REMOTEINFODISCONNECT"] = "close presentation connection";
			this._language["RECOVERMESSAGEOK"] = "Your password was changed successfully.";
			this._language["REMOTEINFOCONNECTEDTO"] = "Connected to";
			this._language["REMOTEMAINTITLE"] = "Managana remote control";
			this._language["REMOTEINFOWAIT"] = "looking for player at local network...";
			this._language["REMOTEVOTEGUIDEABOUT"] = "guide vote";
			this._language["REMOTEINFOCONNECTIONERROR"] = "The Managana player was not found, check the public key and try again";
			this._language["REMOTECOMMENTSBUTTON"] = "comment";
			this._language["REMOTECOMMENTSSENDING"] = "sending";
			this._language["REMOTEINFOSHARETWITTER"] = "Share on Twitter";
			this._language["REMOTEINFOSHAREGPLUS"] = "Share on Google Plus";
			this._language["REMOTEINFOSHAREFACEBOOK"] = "Share on Facebook";
			this._language["REMOTECOMMENTERROR"] = "Error while sending the comment, please try again.";
			this._language["REMOTERATECLICK"] = "plase rate the current content";
			this._language["REMOTEINFOPUBLICLOGIN"] = "Login to enable full controls";
			this._language["REMOTEINFOTAB"] = "information";
			this._language["REMOTERATELOGIN"] = "you must login to rate content";
			this._language["REMOTEINFONOSTREAMDESCRIPTION"] = "No extra information about the current stream.";
			this._language["REMOTEINFOPUBLICNOKEY"] = "Provide the presentation key to connect";
			this._language["REMOTESOUNDTAB"] = "sound";
			this._language["REMOTECOMMUNITYTAB"] = "communities";
			this._language["REMOTEINFOLOGINBUTTON"] = "access login screen";
			this._language["REMOTEINFOLOGINWINDOWTITLE"] = "Login";
			this._language["REMOTEINFOCONNECTEDJUSTAS"] = "as";
			this._language["REMOTECOMMENTSFOR"] = "comments for";
			this._language["REMOTEINFOLOGINABOUT"] = "Connect using login";
			this._language["REMOTETARGETTAB"] = "target";
			this._language["REMOTEVOTETAB"] = "voting";
			this._language["REMOTENAVTAB"] = "navigation";
			this._language["REMOTECOMMENTSENT"] = "Thank you for your comment. It will be available at this list as soon as it is evaluated.";
			this._language["REMOTEINFOLOGINABOUTERROR"] = "User login error, please try again";
			this._language["REMOTEZOOMTAB"] = "zoom and position";
			this._language["REMOTEINFOWAITLOGINMESSAGE"] = "checking login data...";
			this._language["RECOVERMESSAGEERROR"] = "The information for password change was not correct. Please try to recover or change your password again. If the problem persists, contact the system administrator.";
			this._language["REMOTEINFOPUBLICBUTTON"] = "connect";
			this._language["REMOTEINFOPUBLICABOUT"] = "Connect to a public presentation";
			// months
			this._language["MONTH1"] = "jan";
			this._language["MONTH2"] = "feb";
			this._language["MONTH3"] = "mar";
			this._language["MONTH4"] = "apr";
			this._language["MONTH5"] = "may";
			this._language["MONTH6"] = "jun";
			this._language["MONTH7"] = "jul";
			this._language["MONTH8"] = "aug";
			this._language["MONTH9"] = "sep";
			this._language["MONTH10"] = "oct";
			this._language["MONTH11"] = "nov";
			this._language["MONTH12"] = "dec";
			// check system language
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
			loader.load(new URLRequest("language/language_" + Capabilities.language + ".xml"));
		}
		
		// READ-ONLY VALUES
		
		/**
		 * The system chosen language code.
		 */
		public function get chosenLang():String {
			return (this._chosenLang);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Get a language text string.
		 * @param	name	the name of the string to fetch
		 * @return	the requested text in the system chosen language or empty string if not found
		 */
		public function getText(name:String):String {
			if (this._language[name] != null) return (this._language[name]);
				else return ("");
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			for (var index:String in this._language) delete(this._language[index]);
			this._language = null;
			this._chosenLang = null;
		}
		
		// PRIVATE METHODS
		
		/**
		 * Current system language file loaded.
		 */
		private function onLoadComplete(evt:Event):void {
			var loader:URLLoader = evt.target as URLLoader;
			loader.removeEventListener(Event.COMPLETE, onLoadComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
			if (processLanguage(loader.data, Capabilities.language)) {
				// warn listeners about the final language set
				this.dispatchEvent(new Event(Event.COMPLETE));
			} else {
				// try to load the default language
				loader.addEventListener(Event.COMPLETE, onLoadDefaultComplete);
				loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadDefaultError);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadDefaultError);
				loader.load(new URLRequest("language/language_default.xml"));
			}
		}
		
		/**
		 * Current system language file load error.
		 */
		private function onLoadError(evt:Event):void {
			var loader:URLLoader = evt.target as URLLoader;
			loader.removeEventListener(Event.COMPLETE, onLoadComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
			// try to load the default language file
			loader.addEventListener(Event.COMPLETE, onLoadDefaultComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadDefaultError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadDefaultError);
			loader.load(new URLRequest("language/language_default.xml"));
		}
		
		/**
		 * Default system language file loaded.
		 */
		private function onLoadDefaultComplete(evt:Event):void {
			var loader:URLLoader = evt.target as URLLoader;
			loader.removeEventListener(Event.COMPLETE, onLoadDefaultComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadDefaultError);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadDefaultError);
			if (processLanguage(loader.data, "default")) {
				// warn listeners about the final language set
				this.dispatchEvent(new Event(Event.COMPLETE));
			} else {
				// system will keep the static 'en' language
				this._chosenLang = 'en';
			}
		}
		
		/**
		 * Current system language file load error.
		 */
		private function onLoadDefaultError(evt:Event):void {
			var loader:URLLoader = evt.target as URLLoader;
			loader.removeEventListener(Event.COMPLETE, onLoadDefaultComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadDefaultError);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadDefaultError);
			// system will keep the static 'en' language
			this._chosenLang = 'en';
			// warn listeners about the final language set
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * Process a loaded language xml file.
		 * @param	lang	the xml file contents
		 * @param	langCode	the language code
		 * @return	true if the language file was processed, false on error
		 */
		private function processLanguage(lang:String, langCode:String):Boolean {
			var ret:Boolean = false;
			try {
				var langXML:XML = new XML(lang);
				ret = true;
			} catch (e:Error) { }
			if (ret) {
				for (var index:uint = 0; index < langXML.child("language").length(); index++) {
					this._language[String(langXML.language[index].name)] = String(langXML.language[index].value);
				}
				this._chosenLang = langCode;
				System.disposeXML(langXML);
			}
			return (ret);
		}

	}

}
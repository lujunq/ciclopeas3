package art.ciclope.handle {
	
	// FLASH PACKAGES
	import flash.events.*;
	import flash.display.Loader;
	import flash.net.LocalConnection;
	import flash.net.URLRequest;
	import flash.text.Font;
	
	// CICLOPE CLASSES
	import art.ciclope.event.Loading;
	import art.ciclope.util.LoadedFile;
	
	// EVENTS
	
	/**
     * Font download finished.
     */
    [Event( name = "FINISHED", type = "art.ciclope.event.Loading" )]
	/**
     * Font download IO error.
     */
    [Event( name = "ERROR_IO", type = "art.ciclope.event.Loading" )]
	/**
     * Font download progress.
     */
    [Event( name = "PROGRESS", type = "art.ciclope.event.Loading" )]
	/**
     * Font download security error.
     */
    [Event( name = "ERROR_SECURITY", type = "art.ciclope.event.Loading" )]
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * FontManager manages embed font download at runtime. Check compatible font resource example code at "GentiumRegular" below.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 * @see	art.ciclope.resource.GentiumRegular
	 */
	public class FontManager extends EventDispatcher {
		
		// CLASS CONSTANTS
		
		/**
		 * Font type: regular.
		 */
		public static const TYPE_REGULAR:String = "fontmanager_regular";
		/**
		 * Font type: bold.
		 */
		public static const TYPE_BOLD:String = "fontmanager_bold";
		/**
		 * Font type: italic.
		 */
		public static const TYPE_ITALIC:String = "fontmanager_italic";
		/**
		 * Font type: bold and italic.
		 */
		public static const TYPE_BOLDITALIC:String = "fontmanager_bolditalic";
		/**
		 * Font type: other.
		 */
		public static const TYPE_OTHER:String = "fontmanager_other";
		
		// VARIABLES
		
		/**
		 * The font file loader.
		 */
		private var _loader:Loader;
		/**
		 * Font sources.
		 */
		private var _fontURL:Array;
		/**
		 * To hold loaded fonts.
		 */
		private var _fontHolder:Array;
		/**
		 * Current font loading.
		 */
		private var _currentFont:String;
		/**
		 * Type of current font loading.
		 */
		private var _currentType:String;
		/**
		 * The file being loaded.
		 */
		private var _filename:String;
		/**
		 * A messenger to communicate about font loading.
		 */
		private var _messenger:LocalConnection;
		/**
		 * LocalConnection server name.
		 */
		private var _serverName:String;
		/**
		 * LocalConnetion client object.
		 */
		private var _serverClient:Object;
		/**
		 * The server name of LocalConnetion caller.
		 */
		private var _caller:String;
		/**
		 * Font names/type waiting to download.
		 */
		private var _fontQuery:Array;
		/**
		 * The funcions to call when a new font is loaded.
		 */
		private var _loadCallers:Array;
		
		/**
		 * FontManager constructor.
		 * @param	serverName	The name of the server created to listen to font download requests form aplication. Leave blank or null to avoid server creation.
		 */
		public function FontManager(serverName:String = "_FontManager") {
			// preparing loader
			this._loader = new Loader();
            this._loader.contentLoaderInfo.addEventListener(Event.INIT, initHandler);
            this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			// init
			this._fontURL = new Array();
			this._fontHolder = new Array();
			this._currentFont = "";
			this._currentType = "";
			this._filename = "";
			this._caller = "";
			this._fontQuery = new Array();
			this._loadCallers = new Array();
			// prepare messenger
			if (serverName == null) {
				this._messenger = null;
				this._serverName = "";
			}
			else {
				try {
					// create local connection
					this._messenger = new LocalConnection();
					this._messenger.addEventListener(StatusEvent.STATUS, statusHandler);
					this._messenger.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityConnHandler);
					this._serverName = serverName;
					this._messenger.connect(serverName);
					// prepare client listener
					this._serverClient = new Object();
					this._serverClient.addDownload = this.messageAddDownload;
					this._serverClient.setSource = this.messageSetSource;
					this._serverClient.loadFont = this.messageLoadFont;
					this._serverClient.askFont = this.messageAskFont;
					this._serverClient.warnAboutload = this.messageWarnAboutLoad;
					this._messenger.client = this._serverClient;
				} catch (e:Error) {
					this._messenger = null;
					this._serverName = "";
				}
			}
		}
		
		// PUBLIC METHODS
		
		/**
		 * Set the url source for a font face.
		 * @param	font	The font face name.
		 * @param	type	Font type.
		 * @param	source	URL to swf file containing the font.
		 */
		public function setSource(font:String, type:String, source:String):void {
			// is the font new?
			if (this._fontURL[font] == undefined) this._fontURL[font] = new Array();
			// add the font source
			this._fontURL[font][type] = source;
		}
		
		/**
		 * Load a font file (font embed into a swf file).
		 * @param	font	The font face name.
		 * @param	type	Font type.
		 * @param	source	URL of the swf file (leave default to use internal font urls).
		 * @return	Font download status according to donwload status constants.
		 * @see	art.ciclope.event.Loading
		 */
		public function loadFont(font:String, type:String, source:String = null):String {
			if (this._currentFont != "") {
				// another font is being downloaded right now
				return (Loading.DOWNLOADERROR_NOSLOT);
			} else if (this.isLoaded(font, type)) {
				// font already downloaded
				return (Loading.DOWNLOADERROR_ALREADY);
			} else {
				if (source == null) {
					// is there a source url for this font?
					if (this._fontURL[font] == undefined) {
						return (Loading.DOWNLOADERROR_NOTAVAILABLE);
					} else if (this._fontURL[font][type] == undefined) {
						return (Loading.DOWNLOADERROR_NOTAVAILABLE);
					} else {
						this._currentFont = font;
						this._currentType = type;
						this._filename = this._fontURL[font][type];
						this._loader.load(new URLRequest(this._fontURL[font][type]));
						return (Loading.DOWNLOADERROR_OK);
					}
				} else {
					this._currentFont = font;
					this._currentType = type;
					this._filename = source;
					this._loader.load(new URLRequest(source));
					return (Loading.DOWNLOADERROR_OK);
				}
			}
		}
		
		/**
		 * Is the requested font loaded?
		 * @param	font	The font name.
		 * @param	type	The font type.
		 * @return	True if font/type is already donwloaded.
		 */
		public function isLoaded(font:String, type:String):Boolean {
			if (this._fontHolder[font] == undefined) return (false);
			else if (this._fontHolder[font][type] == undefined) return (false);
			else return (true);
		}
		
		/**
		 * Add a font to download query.
		 * @param	font	The font name.
		 * @param	type	The font type.
		 * @return	True if a valid source for the font is found. False otherwise.
		 */
		public function addDownload(font:String, type:String):Boolean {
			
			trace ("call adddownload for " + font);
			
			if (this._fontURL[font] == undefined) {
				return (false);
			} else if (this._fontURL[font][type] == undefined) {
				return (false);
			} else {
				this._fontQuery.push( { font:font, type:type } );
				this.checkDownload();
				return (true);
			}
		}
		
		/**
		 * Localconnection function to add a font download to query.
		 * @param	font	The font name.
		 * @param	type	The font type.
		 */
		public function messageAddDownload(font:String, type:String):void {
			this.addDownload(font, type);
		}
		
		/**
		 * LocalConnection function to set the url source for a font face.
		 * @param	caller	LocalConnection server name of the caller (for response).
		 * @param	font	The font face name.
		 * @param	type	Font type.
		 * @param	source	URL to swf file containing the font.
		 */
		public function messageSetSource(caller:String, font:String, type:String, source:String):void {
			// no need to return to the caller
			this.setSource(font, type, source);
		}
		
		/**
		 * LocalConnection function to load a font file (font embed into a swf file).
		 * @param	caller	LocalConnection server name of the caller (for response).
		 * @param	font	The font face name.
		 * @param	type	Font type.
		 * @param	source	URL of the swf file (leave default to use internal font urls).
		 */
		public function messageLoadFont(caller:String, font:String, type:String, source:String = null):void {
			// can the font be loaded?
			var error:String = this.loadFont(font, type, source);
			if (error == Loading.DOWNLOADERROR_OK) this._caller = caller;
			else {
				// warn caller about no font download
				this._messenger.send(caller, "downloadError", error, font, type, source);
			}
		}
		
		/**
		 * Ask the name of an alternative loaded font to be used as embed.
		 * @param	caller	The caller server name to return.
		 * @param	type	The font type to look for.
		 */
		public function messageAskFont(caller:String, type:String):void {
			var theReturn:String = "";
			for (var index:String in this._fontHolder) {
				if ((theReturn == "") && (this._fontHolder[index] != undefined)) {
					if (this._fontHolder[index][type] != undefined) theReturn = index;
				}
			}
			this._messenger.send(caller, "alternativeFont", theReturn);
		}
		
		/**
		 * Add a function to be called when a font is loaded.
		 * @param	caller	A function that will receive two string parameters: font name and font type (see font type constants).
		 */
		public function messageWarnAboutLoad(caller:String):void {
			this._loadCallers.push(caller);
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			// listeners
			try {
				this._loader.contentLoaderInfo.removeEventListener(Event.INIT, initHandler);
				this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				this._loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				this._loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			} catch (e:Error) { }
			// server
			try { this._messenger.close() } catch (e:Error) { }
			this._messenger = null;
			// arrays
			while (this._fontHolder.length > 0) {
				while (this._fontHolder[0].length > 0) {
					delete (this._fontHolder[0][0]);
				}
				delete (this._fontHolder[0]);
			}
			this._fontHolder = null;
			while (this._fontURL.length > 0) {
				delete (this._fontURL[0]);
			}
			this._fontURL = null;
			while (this._fontQuery.length > 0) {
				delete (this._fontQuery[0]);
			}
			this._fontQuery = null;
			while (this._loadCallers.length > 0) {
				delete (this._loadCallers[0]);
			}
			this._loadCallers = null;
			// other variables
			this._currentFont = null;
			this._currentType = null;
			this._filename = null;
			this._serverName = null;
			this._serverClient = null;
			this._caller = null;
		}
		
		// PRIVATE METHODS
		
		/**
		 * Check if it is possible to download the requested font.
		 */
		private function checkDownload():void {
			if (this._fontQuery.length > 0) this.loadFont(this._fontQuery[0].font, this._fontQuery[0].type);
		}
		
		/**
		 * Loader INIT event.
		 */
		private function initHandler(evt:Event):void {
			// font loaded
			if (this._fontHolder[this._currentFont] == undefined) this._fontHolder[this._currentFont] = new Array();
			this._fontHolder[this._currentFont][this._currentType] = Object(this._loader.content).getFont();
			Font.registerFont(this._fontHolder[this._currentFont][this._currentType]);
			// is the font in query?
			if (this._fontQuery.length > 0) if ((this._fontQuery[0].font == this._currentFont) && (this._fontQuery[0].type == this._currentType)) {
				this._fontQuery.shift();
			}
			
			// call all listeners
			for (var i:uint = 0; i < this._loadCallers.length; i++) {
				try {
					this._messenger.send(this._loadCallers[i], "fontDownload", this._currentFont, this._currentType);
				} catch (e:Error) {
					// do nothing
				}
			}
			// clearing download
			var fname:String = this._filename;
			this._currentFont = "";
			this._currentType = "";
			this._filename = "";
			// warn about font load ok
			this.dispatchEvent(new Loading(Loading.FINISHED, this._loader, fname, LoadedFile.TYPE_FONT));
			// load font from query?
			this.checkDownload();
		}
		/**
		 * Loader IO ERROR event.
		 */
		private function ioErrorHandler(evt:IOErrorEvent):void {
			// warn about error
			this.dispatchEvent(new Loading(Loading.ERROR_IO, this._loader, this._filename, LoadedFile.TYPE_FONT));
			// is the font in query?
			if (this._fontQuery.length > 0) if ((this._fontQuery[0].font == this._currentFont) && (this._fontQuery[0].type == this._currentType)) {
				this._fontQuery.shift();
			}
			// clearing download
			this._currentFont = "";
			this._currentType = "";
			this._filename = "";
			// load font from query?
			this.checkDownload();
		}
		/**
		 * Loader SECURITY ERROR event.
		 */
		private function securityErrorHandler(evt:SecurityErrorEvent):void {
			// warn about error
			this.dispatchEvent(new Loading(Loading.ERROR_SECURITY, this._loader, this._filename, LoadedFile.TYPE_FONT));
			// is the font in query?
			if (this._fontQuery.length > 0) if ((this._fontQuery[0].font == this._currentFont) && (this._fontQuery[0].type == this._currentType)) {
				this._fontQuery.shift();
			}
			// clearing download
			this._currentFont = "";
			this._currentType = "";
			this._filename = "";
			// load font from query?
			this.checkDownload();
		}
		/**
		 * Loader PROGRESS event.
		 */
		private function progressHandler(evt:ProgressEvent):void {
			this.dispatchEvent(new Loading(Loading.PROGRESS, this._loader, this._filename, LoadedFile.TYPE_FONT, evt.bytesLoaded, evt.bytesTotal));
		}
		/**
		 * STATUS event handler for local connection.
		 */
		private function statusHandler(evt:StatusEvent):void {
			// handle LocalConnection status messages
		}
		/**
		 * SECURITY ERROR event handler for local connection.
		 */
		private function securityConnHandler(evt:SecurityErrorEvent):void {
			// handle LocalConnection status messages
		}

	}

}
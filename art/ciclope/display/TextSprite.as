package art.ciclope.display {
	
	// FLASH PACKAGES
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.text.TextFormatAlign;
	
	// CICLOPE CLASSES
	import art.ciclope.util.LoadedFile;
	import art.ciclope.event.Loading;
	import art.ciclope.handle.FontManager;
	import art.ciclope.util.MediaDefinitions;
	import art.ciclope.staticfunctions.StringFunctions;
	import art.ciclope.event.Message;
	
	// EVENTS
	
	/**
     * File download complete.
     */
    [Event( name = "COMPLETE", type = "flash.events.Event" )]
	/**
     * File download IO error.
     */
    [Event( name = "IO_ERROR", type = "flash.events.IOErrorEvent" )]
	/**
     * Font manager server status.
     */
    [Event( name = "STATUS", type = "flash.events.StatusEvent" )]
	/**
     * File download HTTO status.
     */
    [Event( name = "HTTP_STATUS", type = "flash.events.HTTPStatusEvent" )]
	/**
     * File download security error.
     */
    [Event( name = "SECURITY_ERROR", type = "flash.events.SecurityErrorEvent" )]
	/**
     * File download progress.
     */
    [Event( name = "PROGRESS", type = "flash.events.ProgressEvent" )]
	/**
     * File download starts.
     */
    [Event( name = "OPEN", type = "flash.events.Event" )]
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * TextSprite creates a display capable of showing simple html text.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class TextSprite extends Sprite {
		
		// CONSTANTS
		
		/**
		 * Text image mode: paragraph (size set by font size).
		 */
		public static const MODE_PARAGRAPH:String = "MODE_PARAGRAPH";
		/**
		 * Text image mode: artistic (size set by display size).
		 */
		public static const MODE_ARTISTIC:String = "MODE_ARTISTIC";
		
		/**
		 * Font type: regular.
		 */
		public static const TYPE_REGULAR:String = "regular";
		/**
		 * Font type: bold.
		 */
		public static const TYPE_BOLD:String = "bold";
		/**
		 * Font type: italic.
		 */
		public static const TYPE_ITALIC:String = "italic";
		/**
		 * Font type: bold and italic.
		 */
		public static const TYPE_BOLDITALIC:String = "boldItalic";
		
		// VARIABLES
	
		/**
		 * A loader for text files.
		 */
		private var _loader:URLLoader
		/**
		 * The text display itself.
		 */
		private var _text:TextField;
		/**
		 * The loaded file url.
		 */
		private var _url:String;
		/**
		 * Is a text loaded?
		 */
		private var _loaded:Boolean;
		/**
		 * Loaded file subtype.
		 */
		private var _subtype:String;
		/**
		 * Force some type of file subtype?
		 */
		private var _forcedSubtype:String;
		/**
		 * Current text loaded.
		 */
		private var _currentText:String;
		/**
		 * The text format object.
		 */
		private var _textFormat:TextFormat;
		/**
		 * Try to use device font if no embed is found?
		 */
		private var _useDeviceFont:Boolean;
		/**
		 * The text display mode.
		 */
		private var _showMode:String;
		/**
		 * Maximum number of characters.
		 */
		private var _maxchars:uint;
		/**
		 * Style sheet for html text.
		 */
		private var _css:StyleSheet;
		
		public var active:Boolean = true;
		
		// PUBLIC VARIABLES
		
		/**
		 * Switch to device fonts while loading a HTML text? (default = true)
		 */
		public var deviceOnHtml:Boolean;
		/**
		 * Switch to embed fonts while loading a plain text? (default = true)
		 */
		public var embedOnText:Boolean;
		
		/**
		 * TextSprite constructor.
		 * @param	width	Display width.
		 * @param	height	Display height.
		 */
		public function TextSprite(width:Number = 160, height:Number = 90) {
			// initializing
			this._loaded = false;
			this._subtype = LoadedFile.SUBTYPE_NONE;
			this._forcedSubtype = LoadedFile.SUBTYPE_NONE;
			this._currentText = "";
			this._useDeviceFont = true;
			this._showMode = TextSprite.MODE_ARTISTIC;
			this.deviceOnHtml = true;
			this.embedOnText = true;
			this._maxchars = 0;
			this._css = new StyleSheet();
			// create text field
			this._text = new TextField();
			this._text.width = width;
			this._text.height = height;
			this._text.autoSize = TextFieldAutoSize.LEFT;
			this._text.wordWrap = false;
			this._text.multiline = false;
			this._text.embedFonts = true;
			this._text.condenseWhite = true;
			this._text.selectable = true;
			this._text.antiAliasType = AntiAliasType.ADVANCED;
			this._text.addEventListener(TextEvent.LINK, onLink);
			this._text.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this._text.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.addChild(this._text);
			// formatting text field
			this._textFormat = new TextFormat();
			this._text.defaultTextFormat = this._textFormat;
			// creating loader
			this._loader = new URLLoader();
			this._loader.addEventListener(Event.COMPLETE, completeHandler);
            this._loader.addEventListener(Event.OPEN, openHandler);
            this._loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            this._loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            this._loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			this._loader.addEventListener(StatusEvent.STATUS, statusHandler);
		}
		
		
		
		// READ-ONLY VALUES
		
		/**
		 * Text original width (original width for paragraph text or current for artistic one).
		 */
		public function get originalWidth():Number {
			if (this._showMode == TextSprite.MODE_PARAGRAPH) {
				return (this._text.textWidth);
			} else {
				return (this._text.width);
			}
		}
		
		/**
		 * Text original height (original height for paragraph text or current for artistic one).
		 */
		public function get originalHeight():Number {
			if (this._showMode == TextSprite.MODE_PARAGRAPH) {
				return (this._text.textHeight);
			} else {
				return (this._text.height);
			}
		}
		
		// PROPERTIES
		
		/**
		 * Display width.
		 */
		override public function get width():Number {
			if (this._showMode == TextSprite.MODE_ARTISTIC) {
				return (super.width);
			} else {
				return (this._text.width);
			}
		}
		override public function set width(value:Number):void {
			if (this._showMode == TextSprite.MODE_ARTISTIC) {
				super.width = value;
			} else {
				this._text.width = value;
			}
		}
		
		/**
		 * Display height.
		 */
		override public function get height():Number {
			if (this._showMode == TextSprite.MODE_ARTISTIC) {
				return (super.height);
			} else {
				return (this._text.height);
			}
		}
		override public function set height(value:Number):void {
			if (this._showMode == TextSprite.MODE_ARTISTIC) {
				super.height = value;
			} else {
				this._text.height = value;
			}
		}
		
		// PUBLIC METHODS
		
		/**
		 * Load a text file.
		 * @param	url	Path to the text file (txt or html).
		 */
		public function load(url:String):void {
			this._url = url;
			this._loaded = false;
			this._loader.load(new URLRequest(url));
		}
		
		/**
		 * Set the content of current text.
		 * @param	to	The new text string.
		 */
		public function setText(to:String):void {
			// remove window line breaks
			to = to.split("\r").join("");
			this._text.styleSheet = null;
			this._url = "settext";
			this._text.defaultTextFormat = this._textFormat;
			this._text.embedFonts = this.embedOnText;
			this._subtype = LoadedFile.SUBTYPE_TXT;
			this._currentText = StringFunctions.stripTags(to);
			if (this._maxchars == 0) {
				this._text.text = this._currentText;
			} else {
				if (this._currentText.length > this._maxchars) {
					this._text.text = this._currentText.substr(0, this._maxchars) + "...";
				} else {
					this._text.text = this._currentText;
				}
			}
		}
		
		/**
		 * Set the html content of current text.
		 * @param	to	The html-formatted text.
		 */
		public function setHTMLText(to:String):void {
			if (to != null) {
				if ((to.indexOf('<body>') < 0) && (to.indexOf('<TEXTFORMAT') < 0)) to = '<body>' + to + '</body>';
				this._url = "settext";
				this._text.embedFonts = !this.deviceOnHtml;
				this._text.styleSheet = this._css;
				this._subtype = LoadedFile.SUBTYPE_HTML;
				this._currentText = to;
				if (this._maxchars == 0) {
					this._text.htmlText = this._currentText;
				} else {
					if (this._currentText.length > this._maxchars) {
						var newText:String = this._currentText.substr(0, this._maxchars);
						if (newText.lastIndexOf("<") > newText.lastIndexOf(">")) newText = newText.substr(0, newText.lastIndexOf("<"));
						this._text.htmlText = newText + "...";
					} else {
						this._text.htmlText = this._currentText;
					}
				}
			}
		}
		
		/**
		 * Set CSS formatting to the HTML text.
		 * @param	css	the style sheet to apply
		 */
		public function setStyle(css:StyleSheet):void {
			this._css = css;
			if (this.subType == "html") {
				this._text.styleSheet = css;
			}
		}
		
		/**
		 * Play: does nothig. Set only to be compatible with the other sprite classes.
		 * @param time	time position to play (-1 for current) 
		 */
		public function play(time:int = -1):void {
			// do nothing: only for compatibility.
		}
		
		/**
		 * Pause: does nothig. Set only to be compatible with the other sprite classes.
		 */
		public function pause():void {
			// do nothing: only for compatibility.
		}
		
		/**
		 * Stop: does nothig. Set only to be compatible with the other sprite classes.
		 */
		public function stop():void {
			// do nothing: only for compatibility.
		}
		
		/**
		 * Seek: does nothig. Set only to be compatible with the other sprite classes.
		 * @param	to	anything
		 */
		public function seek(to:*):void {
			// do nothing: only for compatibility.
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			// remove listeners
			try {
				this._loader.removeEventListener(Event.COMPLETE, completeHandler);
				this._loader.removeEventListener(Event.OPEN, openHandler);
				this._loader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
				this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				this._loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
				this._loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				this._loader.removeEventListener(StatusEvent.STATUS, statusHandler);
			} catch (e:Error) { }
			// remove graphics
			this.removeChild(this._text);
			this._text.removeEventListener(TextEvent.LINK, onLink);
			this._text.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this._text.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this._text = null;
			// other variables
			this._css = null;
			this._loader = null;
			this._url = null;
			this._subtype = null;
			this._forcedSubtype = null;
			this._currentText = null;
			this._textFormat = null;
			this._showMode = null;
		}
		
		// PROPERTIES
		
		/**
		 * The standard text font.
		 */
		public function get font():String {
			return(this._textFormat.font);
		}
		public function set font(to:String):void {
			if (this._textFormat.font != to) {
				this._textFormat.font = to;
				if (this._subtype != LoadedFile.SUBTYPE_HTML) {
					this._text.styleSheet = null;
					this._text.setTextFormat(this._textFormat);
					this._text.defaultTextFormat = this._textFormat;
				}
			}
		}
		
		/**
		 * The standard text bold.
		 */
		public function get bold():Boolean {
			return(this._textFormat.bold);
		}
		public function set bold(to:Boolean):void {
			if (this._textFormat.bold != to) {
				this._textFormat.bold = to;
				if (this._subtype != LoadedFile.SUBTYPE_HTML) {
					this._text.styleSheet = null;
					this._text.setTextFormat(this._textFormat);
					this._text.defaultTextFormat = this._textFormat;
				}
			}
		}
		
		/**
		 * The standard text italic.
		 */
		public function get italic():Boolean {
			return(this._textFormat.italic);
		}
		public function set italic(to:Boolean):void {
			if (this._textFormat.italic != to) {
				this._textFormat.italic = to;
				if (this._subtype != LoadedFile.SUBTYPE_HTML) {
					this._text.styleSheet = null;
					this._text.setTextFormat(this._textFormat);
					this._text.defaultTextFormat = this._textFormat;
				}
			}
		}
		
		/**
		 * The text color.
		 */
		public function get color():uint {
			return (uint(this._textFormat.color));
		}
		public function set color(to:uint):void {
			if (this._textFormat.color != to) {
				this._textFormat.color = to;
				if (this._subtype != LoadedFile.SUBTYPE_HTML) {
					this._text.styleSheet = null;
					this._text.setTextFormat(this._textFormat);
					this._text.defaultTextFormat = this._textFormat;
				}
			}
		}
		
		/**
		 * The standard letter spacing.
		 */
		public function get letterSpacing():Object {
			return(this._textFormat.letterSpacing);
		}
		public function set letterSpacing(to:Object):void {
			if (this._textFormat.letterSpacing != to) {
				this._textFormat.letterSpacing = to;
				if (this._subtype != LoadedFile.SUBTYPE_HTML) {
					this._text.styleSheet = null;
					this._text.setTextFormat(this._textFormat);
					this._text.defaultTextFormat = this._textFormat;
				}
			}
		}
		
		/**
		 * The standard text line leading.
		 */
		public function get leading():Object {
			return(this._textFormat.leading);
		}
		public function set leading(to:Object):void {
			if (this._textFormat.leading != to) {
				this._textFormat.leading = to;
				if (this._subtype != LoadedFile.SUBTYPE_HTML) {
					this._text.styleSheet = null;
					this._text.setTextFormat(this._textFormat);
					this._text.defaultTextFormat = this._textFormat;
				}
			}
		}
		
		/**
		 * Try to use an alternative device font if the desired embed one is not available?
		 */
		public function get alternativeFont():Boolean {
			return (this._useDeviceFont);
		}
		public function set alternativeFont(to:Boolean):void {
			this._useDeviceFont = to;
		}
		
		/**
		 * Use embed fonts? This value may be constantly changed by the system due to configurations.
		 */
		public function get embed():Boolean {
			return (this._text.embedFonts);
		}
		public function set embed(to:Boolean):void {
			if (this._text.embedFonts != to) {
				if (this._subtype == LoadedFile.SUBTYPE_HTML) this._text.embedFonts = false;
					else this._text.embedFonts = to;
			}
		}
		
		/**
		 * The standard text size.
		 */
		public function get size():uint {
			return(uint(this._textFormat.size));
		}
		public function set size(to:uint):void {
			if (this._textFormat.size != to) {
				this._textFormat.size = to;
				if (this._subtype != LoadedFile.SUBTYPE_HTML) {
					this._text.setTextFormat(this._textFormat);
					this._text.defaultTextFormat = this._textFormat;
				}
			}
		}
		
		/**
		 * The text alignment.
		 */
		public function get align():String {
			return(String(this._textFormat.align));
		}
		public function set align(to:String):void {
			if (this._textFormat.align != to) {
				if ((to == TextFormatAlign.CENTER) || (to == TextFormatAlign.LEFT) || (to == TextFormatAlign.RIGHT) || (to == TextFormatAlign.JUSTIFY)) {
					this._textFormat.align = to;
					if (this._showMode == TextSprite.MODE_PARAGRAPH) {
						if (this._subtype != LoadedFile.SUBTYPE_HTML) {
							if (to == TextFormatAlign.CENTER) this._text.autoSize = TextFieldAutoSize.CENTER;
							else if (to == TextFormatAlign.RIGHT) this._text.autoSize = TextFieldAutoSize.RIGHT;
							else if (to == TextFormatAlign.LEFT) this._text.autoSize = TextFieldAutoSize.LEFT;
							else if (to == TextFormatAlign.JUSTIFY) this._text.autoSize = TextFieldAutoSize.CENTER;
							this._text.setTextFormat(this._textFormat);
							this._text.defaultTextFormat = this._textFormat;
						}
					} else {
						this._text.autoSize = TextFieldAutoSize.LEFT;
					}
				}
			}
		}
		
		/**
		 * Is the text selectable?
		 */
		public function get selectable():Boolean {
			return(this._text.selectable);
		}
		public function set selectable(to:Boolean):void {
			this._text.selectable = to;
		}
		
		/**
		 * Vertical position of text.
		 */
		public function get scrollV():int {
			return(this._text.scrollV);
		}
		public function set scrollV(to:int):void {
			if (this._text.scrollV != to) {
				if (to <= this._text.maxScrollV) this._text.scrollV = to;
			}
		}
		
		/**
		 * Horizontal position of text.
		 */
		public function get scrollH():int {
			return(this._text.scrollH);
		}
		public function set scrollH(to:int):void {
			if (this._text.scrollH != to) {
				if (to <= this._text.maxScrollH) this._text.scrollH = to;
			}
		}
		
		/**
		 * Text display mode: paragraph or artistic. Changing to artistic mode on device text will not be effective.
		 */
		public function get mode():String {
			return (this._showMode);
		}
		public function set mode(to:String):void {
			if (to != this._showMode) {
				if (to == TextSprite.MODE_ARTISTIC) {
					this._text.autoSize = TextFieldAutoSize.LEFT;
					this._text.wordWrap = false;
					this._text.multiline = false;
				} else {
					this._text.autoSize = TextFieldAutoSize.NONE;
					this._text.wordWrap = true;
					this._text.multiline = true;
				}
				this._showMode = to;
			}
		}
		
		/**
		 * Maximum number of chars to show.
		 */
		public function get maxchars():uint {
			return (this._maxchars);
		}
		public function set maxchars(to:uint):void {
			if (to != this._maxchars) {
				this._maxchars = to;
				if (this._subtype == LoadedFile.SUBTYPE_TXT) this.setText(this._currentText);
					else this.setHTMLText(this._currentText);
			}
		}
		
		// READ-ONLY VALUES
		
		/**
		 * The media playback state (for compatibility).
		 * @see	art.ciclope.util.MediaDefinitions
		 */
		public function get mediaState():String {
			return (MediaDefinitions.PLAYBACKSTATE_NOTSTREAM);
		}
		
		/**
		 * Maximum vertical position of the text.
		 */
		public function get maxScrollV():int {
			return (this._text.maxScrollV);
		}
		
		/**
		 * Maximum horizontal position of the text.
		 */
		public function get maxScrollH():int {
			return (this._text.maxScrollH);
		}
		
		/**
		 * The loaded file URL.
		 */
		public function get currentFile():String {
			return (this._url);
		}
		
		/**
		 * The current text (plain or html-encoded).
		 */
		public function get currentText():String {
			return (this._currentText);
		}
		
		/**
		 * Sub type of text loaded (plain text or html).
		 * @see	art.ciclope.util.LoadedFile
		 */
		public function get subType():String {
			return (this._subtype);
		}
		
		// PRIVATE METHODS
		
		/**
		 * Remove <html> tag and <head> session from text if found.
		 * @param	original	The original html text.
		 * @return	Html-marked text without <html> tag and <head> section.
		 */
		private function removeHTMLTag(htmlText:String):String {
			// convert string to lower case to compare
			var lowerCompare:String = htmlText.toLowerCase();
			// is there a <body> tag?
			if (lowerCompare.indexOf("<body") == -1) {
				// no <body>, so considering that there is no <html> or <head>
				return (htmlText);
			} else {
				// remove anything before <body> tag
				var charPos:int = lowerCompare.indexOf("<body");
				charPos = lowerCompare.indexOf(">", charPos) + 1;
				htmlText = htmlText.substr(charPos);
				lowerCompare = lowerCompare.substr(charPos);
				// remove final tags
				charPos = lowerCompare.lastIndexOf("</body>");
				lowerCompare = lowerCompare.substr(0, charPos);
				htmlText = htmlText.substr(0, charPos);
				// remove line breaks
				while (htmlText.indexOf("\n") >= 0) htmlText = htmlText.replace("\n", "");
				while (htmlText.indexOf("\r") >= 0) htmlText = htmlText.replace("\r", "");
				return (htmlText);
			}
		}
		
		/**
		 * COMPLETE evet handler.
		 */
		private function completeHandler(evt:Event):void {
			// is the loaded file a plain text or html?
			this._subtype = LoadedFile.subtypeOf(this._url);
			if (this._forcedSubtype != LoadedFile.SUBTYPE_NONE) this._subtype = this._forcedSubtype;
			// load text into field according to type
			if (this._subtype == LoadedFile.SUBTYPE_TXT) {
				this._text.embedFonts = this.embedOnText;
				this._currentText = this._loader.data;
				while (this._currentText.indexOf("\r") >= 0) this._currentText = this._currentText.replace("\r", "");
				this._text.text = this._currentText;
			} else {
				this._text.embedFonts = !this.deviceOnHtml;
				this._currentText = this.removeHTMLTag(this._loader.data);
				this._text.htmlText = this._currentText;
			}
			this._loaded = true;
			this.dispatchEvent(evt);
		}
		/**
		 * OPEN evet handler.
		 */
		private function openHandler(evt:Event):void {
			this.dispatchEvent(evt);
		}
		/**
		 * PROGRESS evet handler.
		 */
		private function progressHandler(evt:ProgressEvent):void {
			this.dispatchEvent(evt);
		}
		/**
		 * SECURITY ERROR evet handler.
		 */
		private function securityErrorHandler(evt:SecurityErrorEvent):void {
			this.dispatchEvent(evt);
		}
		/**
		 * HTTP STATUS evet handler.
		 */
		private function httpStatusHandler(evt:HTTPStatusEvent):void {
			this.dispatchEvent(evt);
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
		/**
		 * IO ERROR evet handler.
		 */
		private function ioErrorHandler(evt:IOErrorEvent):void {
			this.dispatchEvent(evt);
		}
		
		/**
		 * A link on text was clicked.
		 */
		private function onLink(evt:TextEvent):void {
			this.dispatchEvent(evt);
			evt.stopPropagation();
		}
		
		/**
		 * Mouse over the text.
		 */
		private function onMouseOver(evt:MouseEvent):void {
			this.dispatchEvent(new Message(Message.MOUSEOVER));
		}
		
		/**
		 * Mouse out the text.
		 */
		private function onMouseOut(evt:MouseEvent):void {
			this.dispatchEvent(new Message(Message.MOUSEOUT));
		}
	}

}
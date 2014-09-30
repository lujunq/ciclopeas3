package art.ciclope.sitio.data {
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class DISElementFile {
		
		// VARIABLES
		
		private var _format:String;			// file format
		private var _lang:String;			// file language
		private var _absolute:Boolean;		// is file url absolute?
		private var _url:String;			// file url
		private var _name:String;			// file name
		private var _type:String;			// file media type
		private var _font:String;			// font for text
		private var _fontStyle:String;		// text font style
		
		public function DISElementFile(format:String, lang:String, absolute:Boolean, url:String, path:String, type:String, font:String = "_sans", fontStyle:String = "normal") {
			this._format = format;
			this._lang = lang;
			this._absolute = absolute;
			this._type = type;
			this._font = font;
			this._fontStyle = fontStyle;
			if ((this._type == DISFileFormat.MEDIA_TEXT) || (this._type == DISFileFormat.MEDIA_PARAGRAPH)) {
				this._url = url;
			} else if (absolute) {
				this._url = url;
			} else {
				if (url.substr(0, 1) == "/") url = url.substr(1);
				this._url = path + url;
			}
			var ar:Array = this._url.split("/");
			this._name = ar[ar.length - 1];
		}
		
		// READ-ONLY VALUES
		
		/**
		 * File format.
		 */
		public function get format():String {
			return (this._format);
		}
		
		/**
		 * File language.
		 */
		public function get lang():String {
			return (this._lang);
		}
		
		/**
		 * File media type.
		 */
		public function get type():String {
			return (this._type);
		}
		
		/**
		 * Is file url absolute?
		 */
		public function get absolute():Boolean {
			return (this._absolute);
		}
		
		/**
		 * File URL.
		 */
		public function get url():String {
			return (this._url);
		}
		
		/**
		 * File name.
		 */
		public function get name():String {
			return (this._name);
		}
		
		/**
		 * Font family.
		 */
		public function get font():String {
			return (this._font);
		}
		
		/**
		 * Font style.
		 */
		public function get fontStyle():String {
			return (this._fontStyle);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Release memory used by this object.
		 */
		public function kill():void {
			this._format = null;
			this._lang = null;
			this._url = null;
			this._type = null;
			this._font = null;
			this._fontStyle = null;
		}
		
		/**
		 * Set the file url (mainly for cache).
		 * @param	url	the new file url
		 */
		public function setURL(url:String):void {
			this._url = url;
		}
		
	}

}
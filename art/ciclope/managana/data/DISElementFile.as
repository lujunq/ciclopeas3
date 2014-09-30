package art.ciclope.managana.data {
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * DISElementFile holds information about an element file, text or external feed link.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class DISElementFile {
		
		// VARIABLES
		
		private var _format:String;			// file format
		private var _lang:String;			// file language
		private var _absolute:Boolean;		// is file url absolute?
		private var _url:String;			// file url
		private var _name:String;			// file name
		private var _type:String;			// file media type
		private var _feed:String;			// file loaded from feed data? the feed name.
		private var _feedType:String;		// the feed type
		private var _field:String;			// the feed field to load data from
		
		/**
		 * DISElementFile constructor.
		 * @param	format	the file format
		 * @param	lang	the file language
		 * @param	absolute	is the file url absolute?
		 * @param	url	the file url for downloading
		 * @param	path	the file path
		 * @param	type	the file type
		 * @param	feed	the file feed name (if it is an external feed reference)
		 * @param	feedType	the feed type
		 * @param	field	the external feed field to check
		 */
		public function DISElementFile(format:String, lang:String, absolute:Boolean, url:String, path:String, type:String, feed:String = "", feedType:String = "", field:String = "") {
			this._format = format;
			this._lang = lang;
			this._absolute = absolute;
			this._type = type;
			this._feed = feed;
			this._feedType = feedType;
			this._field = field;
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
		 * Feed name (if assigned).
		 */
		public function get feed():String {
			return (this._feed);
		}
		
		/**
		 * Feed type (if assigned).
		 */
		public function get feedType():String {
			return (this._feedType);
		}
		
		/**
		 * Feed field name (if assigned).
		 */
		public function get field():String {
			return (this._field);
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
			this._field = null;
			this._feed = null;
			this._feedType = null;
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
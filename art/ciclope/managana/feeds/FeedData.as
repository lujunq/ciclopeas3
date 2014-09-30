package art.ciclope.managana.feeds {
	
	// FLASH PACKAGES
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	// CICLOPE CLASSES
	import art.ciclope.staticfunctions.StringFunctions;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * FeedData holds information about an external feed post.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class FeedData extends EventDispatcher {
		
		// VARIABLES
		
		private var _ready:Boolean;		// is feed post data ready to use?
		
		// PUBLIC VARIABLES
		
		/**
		 * The post title.
		 */
		public var title:String;
		
		/**
		 * The post excerpt.
		 */
		public var excerpt:String;
		
		/**
		 * The post text.
		 */
		public var text:String;
		
		/**
		 * The post picture url.
		 */
		public var picture:String;
		
		/**
		 * Embed audio url.
		 */
		public var audio:String;
		
		/**
		 * Embed video url.
		 */
		public var video:String;
		
		/**
		 * Custom progress code.
		 */
		public var code:String;
		
		/**
		 * The post link.
		 */
		public var link:String;
		
		/**
		 * The post author.
		 */
		public var author:String;
		
		/**
		 * The post feed name.
		 */
		public var feedName:String;
		
		/**
		 * the post feed type.
		 */
		public var feedType:String;
		
		/**
		 * The post date.
		 */
		public var pubDate:Date;
		
		/**
		 * Raw date information.
		 */
		public var rawDate:String;
		
		/**
		 * Wordpress extra field 1.
		 */
		public var extra1:String;
		
		/**
		 * Wordpress extra field 2.
		 */
		public var extra2:String;
		
		/**
		 * Wordpress extra field 3.
		 */
		public var extra3:String;
		
		/**
		 * Wordpress extra field 4.
		 */
		public var extra4:String;
		
		/**
		 * Wordpress extra field 5.
		 */
		public var extra5:String;
		
		/**
		 * Wordpress full text.
		 */
		public var fullText:String;
		
		/**
		 * FeedData constructor.
		 * @param	title	the post title
		 * @param	excerpt	the post excerpt
		 * @param	text	the post full text
		 * @param	link	the post link
		 * @param	pubDate	the post date
		 * @param	feedName	the post feed name
		 * @param	feedType	the post feed type
		 * @param	picture	the post picture
		 * @param	audio	the post audio
		 * @param	video	the post video
		 * @param	author	the post author
		 * @param	code	custom progress code
		 * @param	rawDate	raw date information
		 * @param	extra1	wordpress extra field 1
		 * @param	extra2	wordpress extra field 2
		 * @param	extra3	wordpress extra field 3
		 * @param	extra4	wordpress extra field 4
		 * @param	extra5	wordpress extra field 5
		 * @param	fulltext	wordpress full text
		 */
		public function FeedData(title:String = "", excerpt:String = "", text:String = "", link:String = "", pubDate:Date = null, feedName:String = "", feedType:String = "", picture:String = "", audio:String = "", video:String = "", author:String = "", code:String = "", rawDate:String = "", extra1:String = "", extra2:String = "", extra3:String = "", extra4:String = "", extra5:String = "", fulltext:String = "") {
			// assign data
			this.title = title;
			this.excerpt = excerpt;
			this.text = text;
			this.link = link;
			this.author = author;
			this.feedName = feedName;
			this.feedType = feedType;
			if (pubDate == null) {
				this.pubDate = new Date();
			} else {
				this.pubDate = pubDate;
			}
			this.picture = picture;
			this.audio = audio;
			this.video = video;
			this.code = code;
			this.rawDate = rawDate;
			this.extra1 = extra1;
			this.extra2 = extra2;
			this.extra3 = extra3;
			this.extra4 = extra4;
			this.extra5 = extra5;
			this.fullText = fulltext;
			// is picture url already available?
			if (this.picture != "") {
				// feed post data is ready
				this._ready = true;
			} else {
				this._ready = false;
				// try to load a picture from the provided link
				var picloader:URLLoader = new URLLoader();
				picloader.addEventListener(Event.COMPLETE, onImage);
				picloader.addEventListener(IOErrorEvent.IO_ERROR, onImageError);
				picloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onImageError);
				picloader.load(new URLRequest(link));
			}
		}
		
		// READ-ONLY VALUES
		
		/**
		 * Is the feed post data ready to be used?
		 */
		public function get ready():Boolean {
			return (this._ready);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Get a string with the post date/time information.
		 * @param	format	the format to use - check format constants
		 * @return	a formatted string with current post date
		 */
		public function getPubDate(format:String = ""):String {
			var ret:String =  "";
			switch (format) {
				case "dateRAW":
					ret = this.rawDate;
					break;
				case "dateYYYY":
					ret = pubDate.fullYear + "-" + StringFunctions.leading0((pubDate.month + 1), 2) + "-" + StringFunctions.leading0(pubDate.date, 2);
					break;
				case "dateMM":
					ret = StringFunctions.leading0((pubDate.month + 1), 2) + "/" + StringFunctions.leading0(pubDate.date, 2) + "/" + pubDate.fullYear;
					break;
				case "dateDD":
					ret = StringFunctions.leading0(pubDate.date, 2) + "/" + StringFunctions.leading0((pubDate.month + 1), 2) + "/" + pubDate.fullYear;
					break;
				case "timeYYYY":
					ret = pubDate.fullYear + "-" + StringFunctions.leading0((pubDate.month + 1), 2) + "-" + StringFunctions.leading0(pubDate.date, 2) + " - " + StringFunctions.leading0(pubDate.hours, 2) + ":" + StringFunctions.leading0(pubDate.minutes, 2);
					break;
				case "timeMM":
					ret = StringFunctions.leading0((pubDate.month + 1), 2) + "/" + StringFunctions.leading0(pubDate.date, 2) + "/" + pubDate.fullYear + " - " + StringFunctions.leading0(pubDate.hours, 2) + ":" + StringFunctions.leading0(pubDate.minutes, 2);
					break;
				case "timeDD":
					ret = StringFunctions.leading0(pubDate.date, 2) + "/" + StringFunctions.leading0((pubDate.month + 1), 2) + "/" + pubDate.fullYear + " - " + StringFunctions.leading0(pubDate.hours, 2) + ":" + StringFunctions.leading0(pubDate.minutes, 2);
					break;
				case "time":
					ret = StringFunctions.leading0(pubDate.hours, 2) + ":" + StringFunctions.leading0(pubDate.minutes, 2);
					break;
				case "DAY":
					ret = StringFunctions.leading0(pubDate.date, 2);
					break;
				case "MONTH":
					ret = StringFunctions.leading0((pubDate.month + 1), 2);
					break;
				case "YEAR":
					ret = String(pubDate.fullYear);
					break;
				case "HOUR":
					ret = StringFunctions.leading0(pubDate.hours, 2);
					break;
				case "MINUTE":
					ret = StringFunctions.leading0(pubDate.minutes, 2);
					break;
			}
			return (ret);
		}
		
		/**
		 * Get an information field from the post data.
		 * @param	name	the field name to retrieve
		 * @return	the requested field information or an empty string if the field is not found
		 */
		public function getField(name:String):String {
			var ret:String = "";
			switch (name) {
				case "title": ret = this.title; break;
				case "excerpt": ret = this.excerpt; break;
				case "text": ret = this.text; break;
				case "picture": ret = this.picture; break;
				case "audio": ret = this.audio; break;
				case "video": ret = this.video; break;
				case "link": ret = this.link; break;
				case "author": ret = this.author; break;
				case "code": ret = this.code; break;
				case "extra1": ret = this.extra1; break;
				case "extra2": ret = this.extra2; break;
				case "extra3": ret = this.extra3; break;
				case "extra4": ret = this.extra4; break;
				case "extra5": ret = this.extra5; break;
				case "fulltext": ret = this.fullText; break;
				default: ret = this.getPubDate(name); break;
			}
			return (ret);
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {

		}
		
		/**
		 * Release memory used by the object.
		 */
		public function dispose():void {
			this.title = null;
			this.excerpt = null;
			this.text = null;
			this.pubDate = null;
			this.picture = null;
			this.audio = null;
			this.video = null;
			this.link = null;
			this.author = null;
			this.feedName = null;
			this.feedType = null;
			this.code = null;
			this.rawDate = null;
			this.extra1 = null;
			this.extra2 = null;
			this.extra3 = null;
			this.extra4 = null;
			this.extra5 = null;
			this.fullText = null;
		}
		
		// EVENTS
		
		/**
		 * Link loading for picture url failed.
		 */
		private function onImageError(evt:Event):void {
			// no picture, just stop loading
			var picloader:URLLoader = evt.target as URLLoader;
			picloader.removeEventListener(Event.COMPLETE, onImage);
			picloader.removeEventListener(IOErrorEvent.IO_ERROR, onImageError);
			picloader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onImageError);
			// no picture, but the other data is ready
			this._ready = true;
			// warn listeners about feed post data available
			this.dispatchEvent(new FeedEvent(FeedEvent.DATA_READY, this.feedName, this.feedType));
		}
		
		/**
		 * Try to get an image URL from the link loaded text.
		 */
		private function onImage(evt:Event):void {
			// remove listeners
			var picloader:URLLoader = evt.target as URLLoader;
			picloader.removeEventListener(Event.COMPLETE, onImage);
			picloader.removeEventListener(IOErrorEvent.IO_ERROR, onImageError);
			picloader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onImageError);
			// get the image reference
			this.picture = StringFunctions.parseForImage(String(picloader.data));
			// all data ready to be loaded
			this._ready = true;
			// warn listeners about feed post data available
			this.dispatchEvent(new FeedEvent(FeedEvent.DATA_READY, this.feedName, this.feedType));
		}
		
	}

}
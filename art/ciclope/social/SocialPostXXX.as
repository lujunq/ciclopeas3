package art.ciclope.social {
	
	// CICLOPE CLASSES
	import art.ciclope.staticfunctions.StringFunctions;
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class SocialPost {
		
		// STATIC CONSTANTS
		
		/**
		 * Post source: Twitter.
		 */
		public static const SOURCE_TWITTER:String = 'SOURCE_TWITTER';
		/**
		 * Post source: Facebook.
		 */
		public static const SOURCE_FACEBOOK:String = 'SOURCE_FACEBOOK';
		
		// PUBLIC VARIABLES
		
		/**
		 * Post title.
		 */
		public var title:String = "";
		/**
		 * Post text.
		 */
		public var text:String = "";
		/**
		 * Post id.
		 */
		public var id:String = "";
		/**
		 * Post link.
		 */
		public var link:String = "";
		/**
		 * Post source.
		 */
		public var source:String = "";
		/**
		 * Post picture.
		 */
		public var picture:String = "";
		/**
		 * Post date.
		 */
		public var date:Date = new Date();
		
		public function SocialPost(title:String, text:String, link:String = "", source:String = "", date:String = "", picture:String = "", id:String = "") {
			this.title = title;
			this.text = text;
			this.link = link;
			this.source = source;
			this.picture = picture;
			this.id = id;
			this.date = StringFunctions.stringToDate(date);
			// check for link on title (twitter)
			if (this.source == SocialPost.SOURCE_TWITTER) {
				if (this.title.indexOf("http://") >= 0) {
					var trylink:String = StringFunctions.trim(this.title.substr(this.title.indexOf("http://")));
					if (trylink.indexOf(" ") >= 0) trylink = trylink.substr(0, trylink.indexOf(" "));
					this.link = trylink;
				} else {
					this.link = "";
				}
			}
		}
		
		// PUBLIC METHODS
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			this.title = null;
			this.text = null;
			this.link = null;
			this.source = null;
			this.id = null;
			this.date = null;
			this.picture = null;
		}
		
	}

}
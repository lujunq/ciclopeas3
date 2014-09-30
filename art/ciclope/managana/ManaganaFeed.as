package art.ciclope.managana {
	
	// FLASH PACKAGES
	import flash.events.EventDispatcher;
	
	// CICLOPE CLASSES
	import art.ciclope.managana.feeds.*;
	
	// EVENTS
	
	/**
     * An external feed content is available.
     */
    [Event( name = "FEED_READY", type = "art.ciclope.managana.feeds.FeedEvent" )]
	/**
     * There was an error while downloading an external feed content.
     */
    [Event( name = "FEED_ERROR", type = "art.ciclope.managana.feeds.FeedEvent" )]
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * ManaganaFeed handles external feed fetch and display for the Managana player.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class ManaganaFeed extends EventDispatcher {
		
		// PUBLIC CONSTANTS
		
		/**
		 * Feed type: RSS2.
		 */
		public static const TYPE_RSS2:String = "RSS2";
		
		/**
		 * Feed type: Twitter.
		 */
		public static const TYPE_TWITTER:String = "Twitter";
		
		/**
		 * Feed type: Facebook.
		 */
		public static const TYPE_FACEBOOK:String = "Facebook";
		
		/**
		 * Feed type: Wordpress.
		 */
		public static const TYPE_WORDPRESS:String = "Wordpress";
		
		// VARIABLES
		
		private var _types:Array;				// feed types
		
		// PUBLIC VARIABLES
		
		/**
		 * The url to look for feeds.
		 */
		public var feedurl:String = "";
		
		/**
		 * ManaganaFeed constructor.
		 */
		public function ManaganaFeed() {
			this._types = new Array();
			this.clear();
		}
		
		// PUBLIC METHODS
		
		/**
		 * Release memory used by this object.
		 */
		public function kill():void {
			for (var istr:String in this._types) {
				this._types[istr].removeEventListener(FeedEvent.FEED_READY, onFeedReady);
				this._types[istr].removeEventListener(FeedEvent.FEED_ERROR, onFeedError);
				this._types[istr].kill();
				delete(this._types[istr]);
			}
			this._types = null;
		}
		
		/**
		 * Clear feed pool.
		 */
		public function clear():void {
			for (var istr:String in this._types) {
				this._types[istr].removeEventListener(FeedEvent.FEED_READY, onFeedReady);
				this._types[istr].removeEventListener(FeedEvent.FEED_ERROR, onFeedError);
				this._types[istr].kill();
				delete(this._types[istr]);
			}
			// add feed types
			this._types[ManaganaFeed.TYPE_RSS2] = new FeedType(ManaganaFeed.TYPE_RSS2);
			this._types[ManaganaFeed.TYPE_RSS2].addEventListener(FeedEvent.FEED_READY, onFeedReady);
			this._types[ManaganaFeed.TYPE_RSS2].addEventListener(FeedEvent.FEED_ERROR, onFeedError);
			this._types[ManaganaFeed.TYPE_TWITTER] = new FeedType(ManaganaFeed.TYPE_TWITTER);
			this._types[ManaganaFeed.TYPE_TWITTER].addEventListener(FeedEvent.FEED_READY, onFeedReady);
			this._types[ManaganaFeed.TYPE_TWITTER].addEventListener(FeedEvent.FEED_ERROR, onFeedError);
			this._types[ManaganaFeed.TYPE_FACEBOOK] = new FeedType(ManaganaFeed.TYPE_FACEBOOK);
			this._types[ManaganaFeed.TYPE_FACEBOOK].addEventListener(FeedEvent.FEED_READY, onFeedReady);
			this._types[ManaganaFeed.TYPE_FACEBOOK].addEventListener(FeedEvent.FEED_ERROR, onFeedError);
			this._types[ManaganaFeed.TYPE_WORDPRESS] = new FeedType(ManaganaFeed.TYPE_WORDPRESS);
			this._types[ManaganaFeed.TYPE_WORDPRESS].addEventListener(FeedEvent.FEED_READY, onFeedReady);
			this._types[ManaganaFeed.TYPE_WORDPRESS].addEventListener(FeedEvent.FEED_ERROR, onFeedError);
		}
		
		/**
		 * Add a new feed.
		 * @param	type	the feed type (check type constants)
		 * @param	name	the feed name
		 * @param	reference	feed reference (url, user name, etc)
		 * @param	comunity	feed community
		 * @return	true if the fed type is supported
		 */
		public function addFeed(type:String, name:String, reference:String, community:String):Boolean {
			if (this._types[type] != null) {
				this._types[type].addFeed(name, this.feedurl, reference, community);
				this._types[type].update(name);
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Is a feed available?
		 * @param	type	the feed type (check type constants)
		 * @param	name	the feed name
		 * @return	true if the feed is already configured (may not be ready to use)
		 */
		public function isFeed(type:String, name:String):Boolean {
			if (this._types[type] != null) {
				return (this._types[type].isFeed(name));
			} else {
				return (false);
			}
		}
		
		/**
		 * Is a feed ready?
		 * @param	type	the feed type (check type constants)
		 * @param	name	the feed name
		 * @return	true if the feed is ready to use
		 */
		public function isReady(type:String, name:String):Boolean {
			if (this._types[type] != null) {
				return (this._types[type].isReady(name));
			} else {
				return (false);
			}
		}
		
		/**
		 * Number of available posts of a given feed name.
		 * @param	type	the feed type (check type constants)
		 * @param	name	the feed name
		 * @return	the number of available posts or 0 if the feed is not available or not ready
		 */
		public function length(type:String, name:String):uint {
			if (this._types[type] != null) {
				return (this._types[type].length(name));
			} else {
				return (0);
			}
		}
		
		/**
		 * Get information about a feed post.
		 * @param	type	the feed type (check type constants)
		 * @param	name	the feed name
		 * @param	num	the post number (order)
		 * @return	post reference as a FeedData object (null if no post is found)
		 * @see	art.ciclope.managana.feeds.FeedData
		 */
		public function getPost(type:String, name:String, num:uint):FeedData {
			if (this._types[type] != null) {
				return (this._types[type].getPost(name, num));
			} else {
				return (null);
			}
		}
		
		/**
		 * Update feed information. Updated information is not immediately available.
		 * @param	type	the feed type (check type constants)
		 * @param	name	the feed name
		 * @return	true if the feed is found and can be updated
		 */
		public function update(type:String, name:String):Boolean {
			if (this._types[type] != null) {
				return (this._types[type].update(name));
			} else {
				return (false);
			}
		}
		
		/**
		 * A feed just loaded correctly.
		 */
		private function onFeedReady(evt:FeedEvent):void {
			// warn lisneters
			this.dispatchEvent(new FeedEvent(FeedEvent.FEED_READY, evt.feedName, evt.feedType));
		}
		
		/**
		 * A feed load failed.
		 */
		private function onFeedError(evt:FeedEvent):void {
			// warn listeners
			this.dispatchEvent(new FeedEvent(FeedEvent.FEED_ERROR, evt.feedName, evt.feedType));
		}
		
	}

}
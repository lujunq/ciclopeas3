package art.ciclope.managana.feeds {
	
	// FLASH PACKAGES
	import flash.events.EventDispatcher;
	import flash.system.System;
	
	// CICLOPE CLASSES
	import art.ciclope.data.TextCache;
	import art.ciclope.event.Loading;
	import art.ciclope.staticfunctions.StringFunctions;
	import art.ciclope.managana.ManaganaFeed;
	
	// EVENTS
	
	/**
     * The external feed content is available.
     */
    [Event( name = "FEED_READY", type = "art.ciclope.managana.feeds.FeedEvent" )]
	/**
     * There was an error while downloading external feed content.
     */
    [Event( name = "FEED_ERROR", type = "art.ciclope.managana.feeds.FeedEvent" )]
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * FeedType handles all external feeds of a single type (source): Twitter, Facebook, RSS2 or Wordpress.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class FeedType extends EventDispatcher {
		
		// VARIABLES
		
		private var _type:String;		// the feed type
		private var _feeds:Array;		// feed references
		
		/**
		 * FeedType constructor.
		 * @param	type	the feed type
		 */
		public function FeedType(type:String) {
			this._type = type;
			this._feeds = new Array();
		}
		
		// PUBLIC METHODS
		
		/**
		 * Add a new feed.
		 * @param	name	feed name
		 * @param	url	url to fetch the feed
		 * @param	reference	the feed reference
		 * @param	community	the feed community
		 */
		public function addFeed(name:String, url:String, reference:String, community:String):void {
			var feedARR:Array = new Array();
			feedARR['name'] = name;
			if (this._type == ManaganaFeed.TYPE_WORDPRESS) feedARR['url'] = reference;
				else feedARR['url'] = url + "?type=" + this._type + "&com=" + community + "&ref=" + escape(reference);
			feedARR['posts'] = new Array();
			feedARR['ready'] = false;
			feedARR['length'] = 0;
			this._feeds[name] = feedARR;
		}
		
		/**
		 * Is a feed available?
		 * @param	name	the feed name to check
		 * @return	true if the feed is already configured (may not be ready to use)
		 */
		public function isFeed(name:String):Boolean {
			return (this._feeds[name] != null);
		}
		
		/**
		 * Is a feed ready to use?
		 * @param	name	the feed name to check
		 * @return	true if the feed is ready to use
		 */
		public function isReady(name:String):Boolean {
			if (isFeed(name)) {
				return (this._feeds[name]['ready']);
			} else {
				return (false);
			}
		}
		
		/**
		 * Number of available posts of a given feed name.
		 * @param	name	the feed name to check the available number of posts
		 * @return	the number of available posts or 0 if the feed is not available or not ready
		 */
		public function length(name:String):uint {
			if (isFeed(name)) {
				return (this._feeds[name]['length']);
			} else {
				return (0);
			}
		}
		
		/**
		 * Get information about a feed post.
		 * @param	name	the feed name
		 * @param	num	the post number (order)
		 * @return	post reference as a FeedData object (null if no post is found)
		 * @see	art.ciclope.managana.feeds.FeedData
		 */
		public function getPost(name:String, num:uint):FeedData {
			if (isReady(name)) {
				if (num < length(name)) {
					return (this._feeds[name]['posts'][num]);
				} else {
					return (null);
				}
			} else {
				return (null);
			}
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			for (var index:String in this._feeds) {
				while (this._feeds[index]['posts'].length > 0) {
					this._feeds[index]['posts'][0].dispose();
					this._feeds[index]['posts'].shift();
				}
				delete(this._feeds[index]['name']);
				delete(this._feeds[index]['url']);
				delete(this._feeds[index]['posts']);
				delete(this._feeds[index]['ready']);
				delete(this._feeds[index]['length']);
				delete(this._feeds[index]);
			}
		}
		
		/**
		 * Update a feed information.
		 * @param	name	the feed name to update
		 * @return	true if the feed is available for update, false otherwise
		 */
		public function update(name:String):Boolean {
			if (this._feeds[name] != null) {
				var load:TextCache;
				load = new TextCache(this._feeds[name]['url'], "", "post", name);
				load.addEventListener(Loading.ERROR, onLoadError);
				load.addEventListener(Loading.FINISHED, onLoadFinish);
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Feed text load error.
		 */
		private function onLoadError(evt:Loading):void {
			var load:TextCache = evt.loader as TextCache;
			load.removeEventListener(Loading.ERROR, onLoadError);
			load.removeEventListener(Loading.FINISHED, onLoadFinish);
			load.kill();
		}
		
		/**
		 * Feed text load complete.
		 */
		private function onLoadFinish(evt:Loading):void {
			var load:TextCache = evt.loader as TextCache;
			load.removeEventListener(Loading.ERROR, onLoadError);
			load.removeEventListener(Loading.FINISHED, onLoadFinish);
			// valid feed data?
			try {
				// try to load data
				var feedXML:XML = new XML(load.data);
				// check for a valid rss2 feed (musta have a "channel" child)
				if (feedXML.child("channel").length() > 0) {
					// remove previous posts
					while (this._feeds[load.name]['posts'].length > 0) {
						this._feeds[load.name]['posts'][0].dispose();
						this._feeds[load.name]['posts'].shift();
					}
					// get new post data
					this._feeds[load.name]['length'] = 0;
					// get all items
					for (var index:uint = 0; index < feedXML.channel[0].child("item").length(); index++) {
						var title:String = "";
						var description:String = "";
						var link:String = "";
						var pubDate:Date = new Date();
						var picture:String = "";
						var audio:String = "";
						var video:String = "";
						var code:String = "";
						var author:String = "";
						var rawDate:String = "";
						var extra1:String = "";
						var extra2:String = "";
						var extra3:String = "";
						var extra4:String = "";
						var extra5:String = "";
						var fulltext:String = "";
						if (feedXML.channel[0].item[index].child("title").length() > 0) title = String(feedXML.channel[0].item[index].title[0]);
						if (feedXML.channel[0].item[index].child("description").length() > 0) description = String(feedXML.channel[0].item[index].description[0]);
						if (feedXML.channel[0].item[index].child("link").length() > 0) link = String(feedXML.channel[0].item[index].link[0]);
						if (feedXML.channel[0].item[index].child("picture").length() > 0) picture = String(feedXML.channel[0].item[index].picture[0]);
						if (feedXML.channel[0].item[index].child("audio").length() > 0) audio = String(feedXML.channel[0].item[index].audio[0]);
						if (feedXML.channel[0].item[index].child("video").length() > 0) video = String(feedXML.channel[0].item[index].video[0]);
						if (feedXML.channel[0].item[index].child("code").length() > 0) code = String(feedXML.channel[0].item[index].code[0]);
						if (feedXML.channel[0].item[index].child("author").length() > 0) author = String(feedXML.channel[0].item[index].author[0]);
						if (feedXML.channel[0].item[index].child("pubDate").length() > 0) {
							pubDate = StringFunctions.stringToDate(String(feedXML.channel[0].item[index].pubDate[0]));
							rawDate = String(feedXML.channel[0].item[index].pubDate[0]);
						}
						if (feedXML.channel[0].item[index].child("extra1").length() > 0) extra1 = String(feedXML.channel[0].item[index].extra1[0]);
						if (feedXML.channel[0].item[index].child("extra2").length() > 0) extra2 = String(feedXML.channel[0].item[index].extra2[0]);
						if (feedXML.channel[0].item[index].child("extra3").length() > 0) extra3 = String(feedXML.channel[0].item[index].extra3[0]);
						if (feedXML.channel[0].item[index].child("extra4").length() > 0) extra4 = String(feedXML.channel[0].item[index].extra4[0]);
						if (feedXML.channel[0].item[index].child("extra5").length() > 0) extra5 = String(feedXML.channel[0].item[index].extra5[0]);
						if (feedXML.channel[0].item[index].child("fulltext").length() > 0) fulltext = String(feedXML.channel[0].item[index].fulltext[0]);
						this._feeds[load.name]['posts'].push(new FeedData(title, description, description, link, pubDate, load.name, this._type, picture, audio, video, author, code, rawDate, extra1, extra2, extra3, extra4, extra5, fulltext));
						this._feeds[load.name]['length']++;
					}
					// is there at least one post available?
					this._feeds[load.name]['ready'] = (this._feeds[load.name]['length'] > 0);
					// warn listeners
					if (this._feeds[load.name]['ready']) {
						this.dispatchEvent(new FeedEvent(FeedEvent.FEED_READY, load.name, this._type));
					} else {
						this.dispatchEvent(new FeedEvent(FeedEvent.FEED_ERROR, load.name, this._type));
					}
				}
				System.disposeXML(feedXML);
			} catch (e:Error) {
				// warn listeners
				this.dispatchEvent(new FeedEvent(FeedEvent.FEED_ERROR, load.name, this._type));
			}
			load.kill();
		}
		
	}

}
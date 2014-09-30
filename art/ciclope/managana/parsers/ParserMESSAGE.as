package art.ciclope.managana.parsers {
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaPlayer;
	import art.ciclope.event.Message;
	import art.ciclope.managana.feeds.FeedData;
	import art.ciclope.staticfunctions.StringFunctions;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * ParserMESSAGE handles all Managana progress code related to message exchange.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class ParserMESSAGE {
		
		// VARIABLES
		
		private var _player:ManaganaPlayer;		// reference to player
		
		/**
		 * ParserMESSAGE constructor.
		 * @param	player	a reference to the Managana player
		 */
		public function ParserMESSAGE(player:ManaganaPlayer) {
			this._player = player;
		}
		
		/**
		 * Release memory used by this object.
		 */
		public function kill():void {
			this._player = null;
		}
		
		/**
		 * Check if a code line is valid.
		 * @param	line	the code line to check
		 * @return	true if the line is valid, false otherwise
		 */
		public function check(line:Array):Boolean {
			var ret:Boolean = true;
			if (line[0] != "MESSAGE") {
				ret = false;
			} else {
				if ((line[1] != null) && (line[1] != "")) {
					switch (line[1]) {
						case "custom":
						case "openurl":
						case "send":
							if (line[2] != null) ret = true;
								else ret = false;
							break;
						case "htmlbox":
							if ((line[2] != null) && (line[3] != null)) ret = true;
								else ret = false;
							break;
						case "openfeedlink":
							if ((line[2] != null) && (line[3] != null) && (line[4] != null)) ret = true;
								else ret = false;
							break;
						case "sharefacebook":
						case "sharetwitter":
						case "sharegplus":
						case "startPCodeSend":
						case "endPCodeSend":
							ret = true;
							break;
						default:
							ret = false;
							break;
					}
				} else {
					ret = false;
				}
			}
			return(ret);
		}
		
		/**
		 * Run a progress code line.
		 * @param	line	the code line to check
		 */
		public function run(line:Array):void {
			var message:Object = new Object();
			message.key = line[1];
			switch (line[1]) {
				case "custom":
					message.value = line[2];
					this._player.send(message, Message.MESSAGE);
					break;
				case "send":
					message.value = line[2];
					this._player.send(message, Message.SENDTOCONNECTED);
					break;
				case "openurl":
					message.value = line[2];
					if (line[3] != null) message.target = line[3];
						else message.target = '_blank';
					this._player.send(message, Message.OPENURL);
					break;
				case "openfeedlink":
					line[3] = StringFunctions.noSpecial(line[3]);
					if (this._player.feeds.isFeed(line[2], line[3])) { // feed found
						if (this._player.feeds.isReady(line[2], line[3])) { // feed is ready
							if (this._player.feeds.length(line[2], line[3]) > uint(line[4])) { // feed post is available
								var data:FeedData = this._player.feeds.getPost(line[2], line[3], uint(line[4]));
								message.value = data.link;
								this._player.send(message, Message.OPENURL);
								data.kill();
							}
						}
					}
					break;
				case "sharefacebook":
					if (this._player.shareurl != "") {
						message.value = "http://www.facebook.com/sharer.php?t=" + escape(this._player.currentStreamTitle) + "&u=" + escape(this._player.shareurl + "?c=" + this._player.currentCommunity + "&s=" + this._player.currentStream);
						message.community = this._player.currentCommunity;
						message.stream = this._player.currentStream;
						message.share = this._player.shareurl;
						this._player.send(message, Message.SHARE_FACEBOOK);
					}
					break;
				case "sharetwitter":
					if (this._player.shareurl != "") {
						message.value = "https://twitter.com/intent/tweet?text=" + escape(this._player.currentCommunityTitle + ": " + this._player.currentStreamTitle) + "&url=" + escape(this._player.shareurl + "?c=" + this._player.currentCommunity + "&s=" + this._player.currentStream);
						message.community = this._player.currentCommunity;
						message.stream = this._player.currentStream;
						message.share = this._player.shareurl;
						this._player.send(message, Message.SHARE_TWITTER);
					}
					break;
				case "sharegplus":
					if (this._player.shareurl != "") {
						message.value = "https://plus.google.com/share?url=" + escape(this._player.shareurl + "?c=" + this._player.currentCommunity + "&s=" + this._player.currentStream);
						message.community = this._player.currentCommunity;
						message.stream = this._player.currentStream;
						message.share = this._player.shareurl;
						this._player.send(message, Message.SHARE_GPLUS);
					}
					break;
				case "startPCodeSend":
				case "endPCodeSend":
					// do nothing
					break;
				case "htmlbox":
					message.from = line[2];
					message.folder = line[3];
					this._player.send(message, Message.OPENHTMLBOX);
					break;
			}
		}
		
	}

}
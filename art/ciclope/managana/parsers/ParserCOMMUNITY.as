package art.ciclope.managana.parsers {
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaPlayer;
	import art.ciclope.event.Message;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * ParserCOMMUNITY handles all Managana progress code related to community display.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class ParserCOMMUNITY {
		
		// VARIABLES
		
		private var _player:ManaganaPlayer;		// reference to player
		
		/**
		 * ParserCOMMUNITY constructor.
		 * @param	player	a reference to the Managana player
		 */
		public function ParserCOMMUNITY(player:ManaganaPlayer) {
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
			if (line[0] != "COMMUNITY") {
				ret = false;
			} else {
				if ((line[1] != null) && (line[1] != "")) {
					switch (line[1]) {
						case "loadCommunity":
							if (line[2] != null) ret = true;
								else ret = false;
							break;
						case "showLowerGuide":
						case "hideLowerGuide":
						case "toggleLowerGuideVisibility":
						case "showUpperGuide":
						case "hideUpperGuide":
						case "toggleUpperGuideVisibility":
						case "showMainLayer":
						case "hideMainLayer":
						case "toggleMainLayerVisibility":
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
				case "loadCommunity":
					if (line[3] != null) this._player.startStream = line[3];
					this._player.loadCommunity(line[2]);
					break;
				case "showLowerGuide":
					this._player.lowerGuideVisible = true;
					break;
				case "hideLowerGuide":
					this._player.lowerGuideVisible = false;
					break;
				case "toggleLowerGuideVisibility":
					this._player.lowerGuideVisible = !this._player.lowerGuideVisible;
					break;
				case "showUpperGuide":
					this._player.upperGuideVisible = true;
					break;
				case "hideUpperGuide":
					this._player.upperGuideVisible = false;
					break;
				case "toggleUpperGuideVisibility":
					this._player.upperGuideVisible = !this._player.upperGuideVisible;
					break;
				case "showMainLayer":
					this._player.mainLayerVisible = true;
					break;
				case "hideMainLayer":
					this._player.mainLayerVisible = false;
					break;
				case "toggleMainLayerVisibility":
					this._player.mainLayerVisible = !this._player.mainLayerVisible;
					break;
			}
		}
		
	}

}
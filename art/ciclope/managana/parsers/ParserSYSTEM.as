package art.ciclope.managana.parsers {
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaPlayer;
	import art.ciclope.staticfunctions.StringFunctions;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * ParserSYSTEM handles all Managana progress code related to the display system itself.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class ParserSYSTEM {
		
		// VARIABLES
		
		private var _player:ManaganaPlayer;		// reference to player
		
		/**
		 * ParserSYSTEM constructor.
		 * @param	player	a reference to the Managana player
		 */
		public function ParserSYSTEM(player:ManaganaPlayer) {
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
			if (line[0] != "SYSTEM") {
				ret = false;
			} else {
				if ((line[1] != null) && (line[1] != "")) {
					switch (line[1]) {
						case "print":
						case "showClock":
						case "hideClock":
						case "showRate":
						case "hideRate":
						case "showComments":
						case "hideComments":
						case "showBookmarks":
						case "hideBookmarks":
						case "showNotes":
						case "hideNotes":
						case "readQRCode":
						case "showRemoteInfo":
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
			switch (line[1]) {
				case "print":
					this._player.print();
					break;
				case "readQRCode":
					this._player.send({ "ac":"readQRCode" });
					break;
				case "showRemoteInfo":
					this._player.send({ "ac":"showRemoteInfo" });
					break;
				case "showClock":
				case "hideClock":
				case "showRate":
				case "hideRate":
				case "showComments":
				case "hideComments":
				case "showBookmarks":
				case "hideBookmarks":
				case "showNotes":
				case "hideNotes":
					if (this._player.interfaceMessage != null) {
						this._player.interfaceMessage(line[1]);
					}
					break;
			}
		}
		
	}

}
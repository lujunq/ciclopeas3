package art.ciclope.managana.parsers {
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaPlayer;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * ParserSTREAM handles all Managana progress code related to stream playback.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class ParserSTREAM {
		
		// VARIABLES
		
		private var _player:ManaganaPlayer;		// reference to player
		
		/**
		 * ParserMESSAGE constructor.
		 * @param	player	a reference to the Managana player
		 */
		public function ParserSTREAM(player:ManaganaPlayer) {
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
			if (line[0] != "STREAM") {
				ret = false;
			} else {
				switch (line[1]) {
					case "play":
					case "pause":
					case "clearTransition":
					case "nextX":
					case "nextY":
					case "nextZ":
					case "previousX":
					case "previousY":
					case "previousZ":
					case "historyNext":
					case "historyBack":
						ret = true;
						break;
					case "load":
					case "transition":
					case "gotoKeyframe":
						if (line[2] != null) ret = true;
							else ret = false;
						break;
					default:
						ret = false;
						break;
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
				case "play":
					this._player.play();
					break;
				case "pause":
					this._player.pause();
					break;
				case "load":
					this._player.loadStream(line[2]);
					break;
				case "transition":
					this._player.transition = line[2];
					break;
				case "gotoKeyframe":
					this._player.nextKeyframe = int(line[2]) - 1;
					break;
				case "clearTransition":
					this._player.transition = "";
					break;
				case "nextX":
					this._player.navigateTo("xnext");
					break;
				case "nextY":
					this._player.navigateTo("ynext");
					break;
				case "nextZ":
					this._player.navigateTo("znext");
					break;
				case "previousX":
					this._player.navigateTo("xprev");
					break;
				case "previousY":
					this._player.navigateTo("yprev");
					break;
				case "previousZ":
					this._player.navigateTo("zprev");
					break;
				case "historyNext":
					this._player.historyNext();
					break;
				case "historyBack":
					this._player.historyBack();
					break;
			}
		}
		
	}

}
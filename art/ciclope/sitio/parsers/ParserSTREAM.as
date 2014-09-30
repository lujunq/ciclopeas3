package art.ciclope.sitio.parsers {
	
	// CICLOPE CLASSES
	import art.ciclope.sitio.SitioPlayer;
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class ParserSTREAM {
		
		// VARIABLES
		
		private var _player:SitioPlayer;		// reference to player
		
		public function ParserSTREAM(player:SitioPlayer) {
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
						ret = true;
						break;
					case "load":
					case "transition":
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
				case "clearTransition":
					this._player.transition = "";
					break;
			}
		}
		
	}

}
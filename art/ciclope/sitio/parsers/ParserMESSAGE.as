package art.ciclope.sitio.parsers {
	
	// CICLOPE CLASSES
	import art.ciclope.sitio.SitioPlayer;
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class ParserMESSAGE {
		
		// VARIABLES
		
		private var _player:SitioPlayer;		// reference to player
		
		public function ParserMESSAGE(player:SitioPlayer) {
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
			message.value = line[2];
			message.extra = new String();
			if (line[3] != null) message.extra = line[3];
			this._player.send(message);
		}
		
	}

}
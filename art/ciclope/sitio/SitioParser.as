package art.ciclope.sitio {
	
	// CICLOPE CLASSES
	import art.ciclope.sitio.SitioPlayer;
	import art.ciclope.staticfunctions.StringFunctions;
	import art.ciclope.sitio.parsers.*;
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class SitioParser {
		
		// VARIABLES
		
		private var _groups:Array;			// progress code groups
		private var _player:SitioPlayer;	// the player reference
		
		public function SitioParser(player:SitioPlayer) {
			this._player = player;
			this._groups = new Array();
			// add parser groups
			this._groups["STREAM"] = new ParserSTREAM(player);
			this._groups["MESSAGE"] = new ParserMESSAGE(player);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Release memory used by this object.
		 */
		public function kill():void {
			this._player = null;
			for (var istr:String in this._groups) {
				this._groups[istr].kill();
				delete(this._groups[istr]);
			}
			this._groups = null;
		}
		
		/**
		 * Check is a progress code is ok.
		 * @param	code	the code string to check
		 * @return	true if the progress code is ok, false otherwise
		 */
		public function checkCode(code:String):Boolean {
			var ret:Boolean = true;
			var codelines:Array = code.split("|");
			while (codelines.length > 0) {
				if (StringFunctions.trim(codelines[0]).length > 0) {
					var line:Array = StringFunctions.trim(codelines[0]).split("->");
					if (line.length < 2) {
						// must have at laeast 2 parameters
						ret = false;
					} else {
						if (this._groups[line[0]] == null) {
							// code group doesn't exist
							ret = false;
						} else if (this._groups[line[0]].check(line) == false) {
							// code line not recognized
							ret = false;
						}
					}
				}
				codelines.shift();
			}
			return (ret);
		}
		
		/**
		 * Perform a progress code action.
		 * @param	code	the code to parse and execute
		 * @return	true if the code is valid an executed, false otherwise
		 */
		public function run(code:String):Boolean {
			if (this.checkCode(code)) {
				var codelines:Array = code.split("|");
				while (codelines.length > 0) {
					if (StringFunctions.trim(codelines[0]).length > 0) {
						var line:Array = StringFunctions.trim(codelines[0]).split("->");
						this._groups[line[0]].run(line);
					}
					codelines.shift();
				}
				return (true);
			} else {
				return (false);
			}
		}
		
	}

}
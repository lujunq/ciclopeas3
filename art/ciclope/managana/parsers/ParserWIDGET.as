package art.ciclope.managana.parsers {
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaPlayer;
	import art.ciclope.staticfunctions.StringFunctions;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * ParserWIDGET handles all Managana progress code related to widgets handling.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class ParserWIDGET {
		
		// VARIABLES
		
		private var _player:ManaganaPlayer;		// reference to player
		
		/**
		 * ParserWIDGET constructor.
		 * @param	player	a reference to the Managana player
		 */
		public function ParserWIDGET(player:ManaganaPlayer) {
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
			if (line[0] != "WIDGET") {
				ret = false;
			} else if ((line[1] == '') || (line[1] == null)) {
				ret = false;
			} else {
				if ((line[2] != null) && (line[2] != "")) {
					switch (line[2]) {
						case "showAbove":
						case "showBelow":
						case "hide":
						case "hideAll":
							ret = true;
							break;
						case "setXPosition":
						case "setYPosition":
						case "customCall":
							ret = (line[3] != null);
							break;
						case "setPosition":
						case "customCallValue":
							ret = ((line[3] != null) && (line[4] != null));
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
			switch (line[2]) {
				case "showAbove":
					this._player.showWidgetAbove(String(line[1]));
					break;
				case "showBelow":
					this._player.showWidgetBelow(String(line[1]));
					break;
				case "hide":
					this._player.hideWidget(String(line[1]));
					break;
				case "hideAll":
					this._player.hideAllWidgets();
					break;
				case "setXPosition":
					this._player.setWidgetXPos(String(line[1]), uint(line[3]));
					break;
				case "setYPosition":
					this._player.setWidgetYPos(String(line[1]), uint(line[3]));
					break;
				case "customCall":
					this._player.callWidgetMethod(String(line[1]), String(line[3]));
					break;
				case "setPosition":
					this._player.setWidgetPos(String(line[1]), uint(line[3]), uint(line[4]));
					break;
				case "customCallValue":
					this._player.callWidgetMethod(String(line[1]), String(line[3]), String(line[4]));
					break;
			}
		}
		
	}

}
package art.ciclope.managana {
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaPlayer;
	import art.ciclope.staticfunctions.StringFunctions;
	import art.ciclope.managana.parsers.*;
	import art.ciclope.event.Message;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * ManaganaParser handles progress code parsing for the Managana player.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class ManaganaParser {
		
		// VARIABLES
		
		private var _groups:Array;				// progress code groups
		private var _player:ManaganaPlayer;		// the player reference
		private var _hold:Array;				// progress code saved for later execution (CODE->wait command)
		private var _codelines:Array;			// current progress code actions
		private var _ifState:String;			// code if current state
		private var _pcodeSend:Boolean;			// is progress code being hold to send?
		private var _pcodeHold:Array;			// progress code hold to send
		
		/**
		 * ManaganaParser constructor.
		 * @param	player	a reference for the Managana player
		 */
		public function ManaganaParser(player:ManaganaPlayer = null) {
			this._player = player;
			this._groups = new Array();
			// add parser groups
			this._groups["STREAM"] = new ParserSTREAM(player);
			this._groups["MESSAGE"] = new ParserMESSAGE(player);
			this._groups["INSTANCE"] = new ParserINSTANCE(player);
			this._groups["COMMUNITY"] = new ParserCOMMUNITY(player);
			this._groups["SYSTEM"] = new ParserSYSTEM(player);
			this._groups["WIDGET"] = new ParserWIDGET(player);
			this._groups["CODE"] = new ParserCODE(player, this);
			// legacy support
			this._groups["PLAYLIST"] = new ParserPLAYLIST(player);
			// prepare hold actions
			this._codelines = new Array();
			this._hold = new Array();
			// if state
			this._ifState = ParserCODE.IFSTATE_NOIF;
			// progress code sending
			this._pcodeSend = false;
			this._pcodeHold = new Array();
		}
		
		// PROPERTIES
		
		/**
		 * Current saved string values as an url-encoded string.
		 */
		public function get strValues():String {
			return (this._groups["CODE"].strValues);
		}
		public function set strValues(to:String):void {
			this._groups["CODE"].strValues = to;
		}
		
		/**
		 * Current saved numeric values as an url-encoded string.
		 */
		public function get numValues():String {
			return (this._groups["CODE"].numValues);
		}
		public function set numValues(to:String):void {
			this._groups["CODE"].numValues = to;
		}
		
		/**
		 * Current saved community values as an url-encoded string.
		 */
		public function get comValues():String {
			return (this._groups["CODE"].comValues);
		}
		public function set comValues(to:String):void {
			this._groups["CODE"].comValues = to;
		}
		
		// PUBLIC METHODS
		
		/**
		 * Get the value of a single string variable.
		 * @param	name	the string variable name
		 * @return	the value or null if the variable is not set
		 */
		public function getString(name:String):String {
			if (this._groups["CODE"].getString(name) != null) {
				return (String(this._groups["CODE"].getString(name)));
			} else {
				return (null);
			}
		}
		
		/**
		 * Set the value of a single string variable.
		 * @param	name	the string variable name
		 * @param	value	the value to set
		 */
		public function setString(name:String, value:String):void {
			this._groups["CODE"].setString(name, value);
		}
		
		/**
		 * Is a string variable set?
		 * @param	name	the string variable name
		 * @return	true if the string variable checked is set, false otherwise
		 */
		public function isStrSet(name:String):Boolean {
			return (this._groups["CODE"].isStrSet(name) as Boolean);
		}
		
		/**
		 * Get the value of a single number variable.
		 * @param	name	the number variable name
		 * @return	the value or 0 if the variable is not set
		 */
		public function getNumber(name:String):Number {
			if (this._groups["CODE"].getNumber(name) != null) {
				return(Number(this._groups["CODE"].getNumber(name)));
			} else {
				return (0);
			}
		}
		
		/**
		 * Set the value of a single number variable.
		 * @param	name	the number variable name
		 * @param	value	the value to set
		 */
		public function setNumber(name:String, value:Number):void {
			this._groups["CODE"].setNumber(name, value);
		}
		
		/**
		 * Is a number variable set?
		 * @param	name	the number variable name
		 * @return	true if the number variable checked is set, false otherwise
		 */
		public function isNumSet(name:String):Boolean {
			return (this._groups["CODE"].isNumSet(name) as Boolean);
		}
		
		/**
		 * Get the value of a single community variable.
		 * @param	name	the community variable name
		 * @return	the value or null if the variable is not set
		 */
		public function getComValue(name:String):String {
			if (this._groups["CODE"].getComValue(name) != null) {
				return(String(this._groups["CODE"].getComValue(name)));
			} else {
				return (null);
			}
		}
		
		/**
		 * Set the value of a single community variable.
		 * @param	name	the community variable name
		 * @param	value	the value to set
		 */
		public function setComValue(name:String, value:String):void {
			this._groups["CODE"].setComValue(name, value);
		}
		
		/**
		 * Is a community variable set?
		 * @param	name	the community variable name
		 * @return	true if the community variable checked is set, false otherwise
		 */
		public function isComValueSet(name:String):Boolean {
			return (this._groups["CODE"].isComValueSet(name) as Boolean);
		}
		
		/**
		 * Add current action to hold list.
		 * @param	time	the time in seconds to hold actions
		 */
		public function addHold(time:uint):void {
			// check current code and remove the wait command
			if (this._codelines.length > 1) {
				this._codelines.shift();
				// add the hold action set
				this._hold.push( { time: time, action:this._codelines.join("|") } );
				// clear current code
				while (this._codelines.length > 0) this._codelines.shift();
			}
		}
		
		/**
		 * Remove all actions hold for later execution.
		 */
		public function clearTimers():void {
			while (this._hold.length > 0) {
				this._hold[0].action = null;
				this._hold.shift();
			}
		}
		
		/**
		 * Update hold action timers and execute them if necessary.
		 */
		public function update():void {
			if (this._hold.length > 0) {
				var toClear:Array = new Array();
				for (var index:uint = 0; index < this._hold.length; index++) {
					this._hold[index].time--;
					if (this._hold[index].time <= 0) {
						// run action
						this.run(this._hold[index].action);
						toClear.push(index);
					}
				}
				// remove executed actions
				if (toClear.length > 0) {
					toClear.reverse();
					while (toClear.length > 0) {
						this._hold.splice(toClear[0], 1);
						toClear.shift();	
					}
				}
			}
		}
		
		/**
		 * Set the current if state for code parsing.
		 * @param	state	the state according to the ParserCODE class constants
		 */
		public function setIf(state:String):void {
			switch (state) {
				case ParserCODE.IFSTATE_TRUE: this._ifState = ParserCODE.IFSTATE_TRUE; break;
				case ParserCODE.IFSTATE_FALSE: this._ifState = ParserCODE.IFSTATE_FALSE; break;
				default: this._ifState = ParserCODE.IFSTATE_NOIF; break;
			}
		}
		
		/**
		 * Set the current if state on a CODE->else command (invert true/false).
		 */
		public function elseState():void {
			if (this._ifState == ParserCODE.IFSTATE_TRUE) this._ifState = ParserCODE.IFSTATE_FALSE;
				else if (this._ifState == ParserCODE.IFSTATE_FALSE) this._ifState = ParserCODE.IFSTATE_TRUE;
		}
		
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
			while (this._hold.length > 0) {
				this._hold[0].action = null;
				this._hold.shift();
			}
			this._hold = null;
			this._ifState = null;
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
						// must have at least 2 parameters
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
			if ((code != "") && this.checkCode(code)) {
				// remove previous code
				while (this._codelines.length > 0) this._codelines.shift();
				// set current code
				this._codelines = code.split("|");
				// process code
				while (this._codelines.length > 0) {
					var lnIndex:uint;
					if (StringFunctions.trim(this._codelines[0]).length > 0) {
						// hold progress code for further send?
						if (StringFunctions.trim(this._codelines[0]) == "MESSAGE->startPCodeSend") this._pcodeSend = true;
						// send progress code?
						if (StringFunctions.trim(this._codelines[0]) == "MESSAGE->endPCodeSend") this.sendPCode();
						// hold or process code?
						if (this._pcodeSend) {
							if ((StringFunctions.trim(this._codelines[0]) != "MESSAGE->startPCodeSend") && (StringFunctions.trim(this._codelines[0]) != "MESSAGE->endPCodeSend")) this._pcodeHold.push(StringFunctions.trim(this._codelines[0]));
						} else {
							// get code line elements
							var line:Array = StringFunctions.trim(this._codelines[0]).split("->");
							// check variables
							if (line.length > 2) for (lnIndex = 2; lnIndex < line.length; lnIndex++) line[lnIndex] = this._groups["CODE"].checkVar(line[lnIndex]);
							// check if state
							if ((this._ifState == ParserCODE.IFSTATE_NOIF) || (this._ifState == ParserCODE.IFSTATE_TRUE) || ((line[0] == "CODE") && (line[1] == "else")) || ((line[0] == "CODE") && (line[1] == "endIf"))) {
								this._groups[line[0]].run(line);
							}
						}
					}
					if (this._codelines.length > 0) this._codelines.shift();
				}
				// return to no if state after the code parsing is finished
				this._ifState = ParserCODE.IFSTATE_NOIF;
				// send any progress code hold
				this.sendPCode();
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Send the progress code hold at the array to a connected software.
		 */
		private function sendPCode():void {
			if (this._pcodeSend) {
				this._player.send( { value: this._pcodeHold.join("|") }, Message.SENDPROGRESSCODE);
				while (this._pcodeHold.length > 0) this._pcodeHold.shift();
				this._pcodeSend = false;
			}
		}
		
	}

}
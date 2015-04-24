package art.ciclope.managana.parsers {
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaImage;
	import art.ciclope.managana.ManaganaParser;
	import art.ciclope.managana.ManaganaPlayer;
	import art.ciclope.event.Message;
	import art.ciclope.managana.feeds.FeedData;
	import art.ciclope.staticfunctions.StringFunctions;
	
	// FLASH PACKAGES
	import flash.net.URLVariables;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * ParserCODE handles all Managana progress code related to the code itself.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class ParserCODE {
		
		// PUBLIC CONSTANTS
		
		/**
		 * If code state: no if running.
		 */
		public static const IFSTATE_NOIF:String = "IFSTATE_NOIF";
		/**
		 * If code state: if is true.
		 */
		public static const IFSTATE_TRUE:String = "IFSTATE_TRUE";
		/**
		 * If code state: if is false.
		 */
		public static const IFSTATE_FALSE:String = "IFSTATE_FALSE";
		
		// VARIABLES
		
		private var _player:ManaganaPlayer;		// reference to player
		private var _parser:ManaganaParser;		// reference to parser
		private var _numbers:Array;				// stored numbers
		private var _strings:Array;				// stored strings
		private var _comValues:Array;			// stored community values
		
		/**
		 * ParserCODE constructor.
		 * @param	player	a reference to the Managana player
		 * @param	parser	a reference to the Managana player code parser
		 */
		public function ParserCODE(player:ManaganaPlayer, parser:ManaganaParser) {
			this._player = player;
			this._parser = parser;
			this._numbers = new Array();
			this._strings = new Array();
			this._comValues = new Array();
		}
		
		// PROPERTIES
		
		/**
		 * Current saved string values as an url-encoded string.
		 */
		public function get strValues():String {
			var ret:URLVariables = new URLVariables();
			for (var index:String in this._strings) {
				ret[index] = this._strings[index];
			}
			return (ret.toString());
		}
		public function set strValues(to:String):void {
			for (var index:String in this._strings) delete(this._strings[index]);
			if (String(to) != "") {
				try {
					var ret:URLVariables = new URLVariables(to);				
					for (index in ret) {
						if (ret[index] is String) {
							this._strings[index] = ret[index];
						}
					}
				} catch (e:Error) { }
			}
		}
		
		/**
		 * Current saved numeric values as an url-encoded string.
		 */
		public function get numValues():String {
			var ret:URLVariables = new URLVariables();
			for (var index:String in this._numbers) {
				ret[index] = this._numbers[index];
			}
			return (ret.toString());
		}
		public function set numValues(to:String):void {
			for (var index:String in this._numbers) delete(this._numbers[index]);
			if (String(to) != "") {
				try {
					var ret:URLVariables = new URLVariables(to);
					for (index in ret) {
						if (!isNaN(ret[index])) {
							this._numbers[index] = Number(ret[index]);
						}
					}
				} catch (e:Error) { }
			}
		}
		
		/**
		 * Current saved community values as an url-encoded string.
		 */
		public function get comValues():String {
			var ret:URLVariables = new URLVariables();
			for (var index:String in this._comValues) {
				ret[index] = this._comValues[index];
			}
			return (ret.toString());
		}
		public function set comValues(to:String):void {
			for (var index:String in this._comValues) delete(this._comValues[index]);
			if (String(to) != "") {
				try {
					var ret:URLVariables = new URLVariables(to);
					for (index in ret) {
						this._comValues[index] = ret[index];
					}
				} catch (e:Error) { }
			}
		}
		
		// PUBLIC METHODS
		
		/**
		 * Get the value of a single string variable.
		 * @param	name	the string variable name
		 * @return	the value or null if the variable is not set
		 */
		public function getString(name:String):String {
			if (this._strings[name] != null) {
				return(String(this._strings[name]));
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
			this._strings[name] = value;
		}
		
		/**
		 * Is a string variable set?
		 * @param	name	the string variable name
		 * @return	true if the string variable checked is set, false otherwise
		 */
		public function isStrSet(name:String):Boolean {
			return ((this._strings[name] != null));
		}
		
		/**
		 * Get the value of a single number variable.
		 * @param	name	the number variable name
		 * @return	the value or 0 if the variable is not set
		 */
		public function getNumber(name:String):Number {
			if (this._numbers[name] != null) {
				return(Number(this._numbers[name]));
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
			this._numbers[name] = value;
		}
		
		/**
		 * Is a number variable set?
		 * @param	name	the number variable name
		 * @return	true if the number variable checked is set, false otherwise
		 */
		public function isNumSet(name:String):Boolean {
			return ((this._numbers[name] != null));
		}
		
		/**
		 * Get the value of a single community variable.
		 * @param	name	the community variable name
		 * @return	the value or null if the variable is not set
		 */
		public function getComValue(name:String):String {
			if (this._comValues[name] != null) {
				return(String(this._comValues[name]));
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
			this._comValues[name] = value;
		}
		
		/**
		 * Is a community variable set?
		 * @param	name	the community variable name
		 * @return	true if the community variable checked is set, false otherwise
		 */
		public function isComValueSet(name:String):Boolean {
			return ((this._comValues[name] != null));
		}
		
		/**
		 * Check a progress code string and replace variable values if they are found.
		 * @param	toCheck	the code string to check
		 * @return	the provided string if it is not a variable or the variable value if it is found
		 */
		public function checkVar(toCheck:String):String {
			// look for string values
			if (toCheck.substr(0, 1) == "$") {
				// may be a string
				if (this._strings[toCheck.substr(1)] != null) {
					toCheck = String(this._strings[toCheck.substr(1)]);
				}
			} else if (toCheck.substr(0, 1) == "#") {
				// may be a number
				if (this._numbers[toCheck.substr(1)] != null) {
					toCheck = String(this._numbers[toCheck.substr(1)]);
				}
			} else if (toCheck.substr(0, 1) == "%") {
				// may be a community value
				if (this._comValues[toCheck.substr(1)] != null) {
					toCheck = String(this._comValues[toCheck.substr(1)]);
				}
			} else if (toCheck.substr(0, 1) == "&") {
				// may be a meta value
				if (this._player.isMeta(toCheck.substr(1))) {
					toCheck = String(this._player.getMeta(toCheck.substr(1)));
				}
			}
			return (toCheck);
		}
		
		/**
		 * Release memory used by this object.
		 */
		public function kill():void {
			this._player = null;
			this._parser = null;
			for (var index:String in this._numbers) delete(this._numbers[index]);
			for (index in this._strings) delete(this._strings[index]);
			for (index in this._comValues) delete(this._comValues[index]);
			this._numbers = null;
			this._strings = null;
			this._comValues = null;
		}
		
		/**
		 * Check if a code line is valid.
		 * @param	line	the code line to check
		 * @return	true if the line is valid, false otherwise
		 */
		public function check(line:Array):Boolean {
			var ret:Boolean = true;
			if (line[0] != "CODE") {
				ret = false;
			} else {
				if ((line[1] != null) && (line[1] != "")) {
					switch (line[1]) {
						case "wait":
							if (line[2] != null) ret = true;
								else ret = false;
							break;
						case "clearTimers":
							ret = true;
							break;
						case "clearNumber":
						case "clearString":
						case "getStreamID":
						case "getCommunityID":
						case "getCategory":
							if (line[2] != null) ret = true;
								else ret = false;
							break;
						case "setString":
						case "setNumber":
						case "addToNum":
						case "subtractFromNum":
						case "multiplyNum":
						case "divideNum":
						case "mergeToStr":
						case "setRandomNum":
							if ((line[2] != null) && (line[3] != null)) {
								ret = true;
							} else {
								ret = false;
							}
							break;
						case "getInstanceProp":
							if ((line[2] != null) && (line[3] != null) && (line[4] != null)) {
								ret = true;
							} else {
								ret = false;
							}
							break;
						case "clearAllNumbers":
						case "clearAllStrings":
						case "clearAllValues":
						case "getComValues":
						case "clearComValues":
						case "ifComValues":
							ret = true;
							break;
						case "endIf":
						case "else":
						case "saveValues":
						case "loadValues":
						case "ifUserLogged":
							ret = true;
							break;
						case "ifNumEqual":
						case "ifNumDifferent":
						case "ifNumLower":
						case "ifNumHigher":
						case "ifNumLowerOrEqual":
						case "ifNumHigherOrEqual":
						case "ifStrEqual":
						case "ifStrDifferent":
						case "setComValue":
						case "addToComValue":
						case "subtractFromComValue":
						case "multiplyComValue":
						case "divideComValue":
							if ((line[2] != null) && (line[3] != null)) {
								ret = true;
							} else {
								ret = false;
							}
							break;
						case "ifNumExist":
						case "ifStrExist":
						case "ifIsMeta":
							if (line[2] != null) {
								ret = true;
							} else {
								ret = false;
							}
							break;
						case "ifHistoryNext":
						case "ifHistoryBack":
							ret = true;
							break;
						case "runFunctionA":
						case "runFunctionB":
						case "runFunctionC":
						case "runFunctionD":
						case "runMouseWUp":
						case "runMouseWDown":
							ret = true;
							break;
						case "runFeedCode":
						case "getPostCount":
							if ((line[2] != null) && (line[3] != null) && (line[4] != null)) ret = true;
								else ret = false;
							break;
						case "ifPostData":
							if ((line[2] != null) && (line[3] != null) && (line[4] != null) && (line[5] != null)) ret = true;
								else ret = false;
							break;
						case "ifPlayerMobile":
						case "ifPlayerWeb":
						case "ifPlayerDesktop":
						case "ifPlayerShowtime":
						case "ifPlayerUnknown":
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
				case "wait":
					this._parser.addHold(uint(line[2]));
					break;
				case "clearTimers":
					this._parser.clearTimers();
					break;
				case "setNumber":
					this._numbers[line[2]] = Number(line[3]);
					break;
				case "setString":
					this._strings[line[2]] = String(line[3]);
					break;
				case "clearNumber":
					if (this._numbers[line[2]] != null) delete(this._numbers[line[2]]);
					break;
				case "clearString":
					if (this._strings[line[2]] != null) delete(this._strings[line[2]]);
					break;
				case "clearAllNumbers":
					for (var inum:String in this._numbers) delete(this._numbers[inum]);
					break;
				case "clearAllStrings":
					for (var istr:String in this._strings) delete(this._strings[istr]);
					break;
				case "clearAllValues":
					for (var ival:String in this._numbers) delete(this._numbers[ival]);
					for (ival in this._strings) delete(this._strings[ival]);
					break;
				case "else":
					this._parser.elseState();
					break;
				case "endIf":
					this._parser.setIf(ParserCODE.IFSTATE_NOIF);
					break;
				case "ifNumEqual":
					if (!isNaN(line[2]) && !isNaN(line[3])) {
						if (Number(line[2]) == Number(line[3])) {
							this._parser.setIf(ParserCODE.IFSTATE_TRUE);
						} else {
							this._parser.setIf(ParserCODE.IFSTATE_FALSE);
						}
					} else {
						this._parser.setIf(ParserCODE.IFSTATE_FALSE);
					}
					break;
				case "ifNumDifferent":
					if (!isNaN(line[2]) && !isNaN(line[3])) {
						if (Number(line[2]) != Number(line[3])) {
							this._parser.setIf(ParserCODE.IFSTATE_TRUE);
						} else {
							this._parser.setIf(ParserCODE.IFSTATE_FALSE);
						}
					} else {
						this._parser.setIf(ParserCODE.IFSTATE_FALSE);
					}
					break;
				case "ifNumLower":
					if (!isNaN(line[2]) && !isNaN(line[3])) {
						if (Number(line[2]) < Number(line[3])) {
							this._parser.setIf(ParserCODE.IFSTATE_TRUE);
						} else {
							this._parser.setIf(ParserCODE.IFSTATE_FALSE);
						}
					} else {
						this._parser.setIf(ParserCODE.IFSTATE_FALSE);
					}
					break;
				case "ifNumHigher":
					if (!isNaN(line[2]) && !isNaN(line[3])) {
						if (Number(line[2]) > Number(line[3])) {
							this._parser.setIf(ParserCODE.IFSTATE_TRUE);
						} else {
							this._parser.setIf(ParserCODE.IFSTATE_FALSE);
						}
					} else {
						this._parser.setIf(ParserCODE.IFSTATE_FALSE);
					}
					break;
				case "ifNumLowerOrEqual":
					if (!isNaN(line[2]) && !isNaN(line[3])) {
						if (Number(line[2]) <= Number(line[3])) {
							this._parser.setIf(ParserCODE.IFSTATE_TRUE);
						} else {
							this._parser.setIf(ParserCODE.IFSTATE_FALSE);
						}
					} else {
						this._parser.setIf(ParserCODE.IFSTATE_FALSE);
					}
					break;
				case "ifNumHigherOrEqual":
					if (!isNaN(line[2]) && !isNaN(line[3])) {
						if (Number(line[2]) >= Number(line[3])) {
							this._parser.setIf(ParserCODE.IFSTATE_TRUE);
						} else {
							this._parser.setIf(ParserCODE.IFSTATE_FALSE);
						}
					} else {
						this._parser.setIf(ParserCODE.IFSTATE_FALSE);
					}
					break;
				case "ifStrEqual":
					if (line[2] == line[3]) {
						this._parser.setIf(ParserCODE.IFSTATE_TRUE);
					} else {
						this._parser.setIf(ParserCODE.IFSTATE_FALSE);
					}
					break;
				case "ifStrDifferent":
					if (line[2] != line[3]) {
						this._parser.setIf(ParserCODE.IFSTATE_TRUE);
					} else {
						this._parser.setIf(ParserCODE.IFSTATE_FALSE);
					}
					break;
				case "ifNumExist":
					if (this._numbers[line[2]] != null) {
						this._parser.setIf(ParserCODE.IFSTATE_TRUE);
					} else {
						this._parser.setIf(ParserCODE.IFSTATE_FALSE);
					}
					break;
				case "ifStrExist":
					if (this._strings[line[2]] != null) {
						this._parser.setIf(ParserCODE.IFSTATE_TRUE);
					} else {
						this._parser.setIf(ParserCODE.IFSTATE_FALSE);
					}
					break;
				case "addToNum":
					if (this._numbers[line[2]] != null) {
						if (!isNaN(line[3])) {
							this._numbers[line[2]] = Number(this._numbers[line[2]]) + Number(line[3]);
						}
					}
					break;
				case "subtractFromNum":
					if (this._numbers[line[2]] != null) {
						if (!isNaN(line[3])) {
							this._numbers[line[2]] = Number(this._numbers[line[2]]) - Number(line[3]);
						}
					}
					break;
				case "multiplyNum":
					if (this._numbers[line[2]] != null) {
						if (!isNaN(line[3])) {
							this._numbers[line[2]] = Number(this._numbers[line[2]]) * Number(line[3]);
						}
					}
					break;
				case "divideNum":
					if (this._numbers[line[2]] != null) {
						if (!isNaN(line[3])) {
							if (Number(line[3]) != 0) this._numbers[line[2]] = Number(this._numbers[line[2]]) / Number(line[3]);
						}
					}
					break;
				case "mergeToStr":
					if (this._strings[line[2]] != null) {
						this._strings[line[2]] = String(this._strings[line[2]]) + String(line[3]);
						
						trace ('new string', this._strings[line[2]]);
					}
					break;
				case "getStreamID":
					this._strings[line[2]] = this._player.currentStream;
					break;
				case "getCommunityID":
					this._strings[line[2]] = this._player.currentCommunity;
					break;
				case "getCategory":
					this._strings[line[2]] = this._player.streamCategory;
					break;
				case "getInstanceProp":
					var inst:ManaganaImage = this._player.getImage(line[3]);
					if (inst != null) {
						switch (line[4]) {
							case "x":
								this._numbers[line[2]] = inst.x;
								break;
							case "y":
								this._numbers[line[2]] = inst.y;
								break;
							case "z":
								this._numbers[line[2]] = inst.z;
								break;
							case "rx":
								this._numbers[line[2]] = inst.rotationX;
								break;
							case "ry":
								this._numbers[line[2]] = inst.rotationY;
								break;
							case "rz":
								this._numbers[line[2]] = inst.rotationZ;
								break;
							case "width":
								this._numbers[line[2]] = inst.width;
								break;
							case "height":
								this._numbers[line[2]] = inst.height;
								break;
							case "alpha":
								this._numbers[line[2]] = inst.alpha;
								break;
							case "volume":
								this._numbers[line[2]] = inst.volume;
								break;
							case "red":
								this._numbers[line[2]] = inst.red;
								break;
							case "green":
								this._numbers[line[2]] = inst.green;
								break;
							case "blue":
								this._numbers[line[2]] = inst.blue;
								break;
							case "element":
								this._strings[line[2]] = inst.element;
								break;
							case "blend":
								this._strings[line[2]] = inst.blendMode;
								break;
						}
					}
					inst = null;
					break;
				case "saveValues":
					this._player.send(null, Message.SAVEDATA);
					break;
				case "loadValues":
					this._player.send(null, Message.LOADDATA);
					break;
				case "setRandomNum":
					if (!isNaN(line[3])) {
						this._numbers[line[2]] = uint(Math.round(Math.random() * Number(line[3])))
					}
					break;
				case "getComValues":
					for (var icomv:String in this._comValues) delete(this._comValues[icomv]);
					this._player.send(null, Message.LOADCOMVALUES);
					break;
				case "clearComValues":
					for (var icomv2:String in this._comValues) delete(this._comValues[icomv2]);
					break;
				case "ifComValues":
					var checkComv:Boolean = false;
					for (var icomcheck:String in this._comValues) checkComv = true;
					if (checkComv) {
						this._parser.setIf(ParserCODE.IFSTATE_TRUE);
					} else {
						this._parser.setIf(ParserCODE.IFSTATE_FALSE);
					}
					break;
				case "setComValue":
					this._player.send({varName:String(line[2]), varValue:String(line[3])}, Message.SAVECOMVALUE);
					break;
				case "addToComValue":
					this._player.send({varName:String(line[2]), varValue:String(line[3]), varAction:"add"}, Message.CHANGECOMVALUE);
					break;
				case "subtractFromComValue":
					this._player.send({varName:String(line[2]), varValue:String(line[3]), varAction:"subtract"}, Message.CHANGECOMVALUE);
					break;
				case "multiplyComValue":
					this._player.send({varName:String(line[2]), varValue:String(line[3]), varAction:"multiply"}, Message.CHANGECOMVALUE);
					break;
				case "divideComValue":
					this._player.send({varName:String(line[2]), varValue:String(line[3]), varAction:"divide"}, Message.CHANGECOMVALUE);
					break;
				case "ifUserLogged":
					if (this._player.usrLogged) {
						this._parser.setIf(ParserCODE.IFSTATE_TRUE);
					} else {
						this._parser.setIf(ParserCODE.IFSTATE_FALSE);
					}
					break;
				case "ifHistoryNext":
					if (this._player.hasHistoryNext) {
						this._parser.setIf(ParserCODE.IFSTATE_TRUE);
					} else {
						this._parser.setIf(ParserCODE.IFSTATE_FALSE);
					}
					break;
				case "ifHistoryBack":
					if (this._player.hasHistoryBack) {
						this._parser.setIf(ParserCODE.IFSTATE_TRUE);
					} else {
						this._parser.setIf(ParserCODE.IFSTATE_FALSE);
					}
					break;
				case "ifIsMeta":
					if (this._player.isMeta(line[2])) {
						this._parser.setIf(ParserCODE.IFSTATE_TRUE);
					} else {
						this._parser.setIf(ParserCODE.IFSTATE_FALSE);
					}
					break;
				case "runFunctionA":
					this._player.runCustomFunction('A');
					break;
				case "runFunctionB":
					this._player.runCustomFunction('B');
					break;
				case "runFunctionC":
					this._player.runCustomFunction('C');
					break;
				case "runFunctionD":
					this._player.runCustomFunction('D');
					break;
				case "runMouseWUp":
					this._player.mouseWheelUp();
					break;
				case "runMouseWDown":
					this._player.mouseWheelDown();
					break;
				case "runFeedCode":
					line[3] = StringFunctions.noSpecial(line[3]);
					if (this._player.feeds.isFeed(line[2], line[3])) { // feed found
						if (this._player.feeds.isReady(line[2], line[3])) { // feed is ready
							if (this._player.feeds.length(line[2], line[3]) > uint(line[4])) { // feed post is available
								var data:FeedData = this._player.feeds.getPost(line[2], line[3], uint(line[4]));
								if (data.code != null) this._parser.run(data.code);
							}
						}
					}
					break;
				case "getPostCount":
					this._numbers[line[2]] = 0;
					line[4] = StringFunctions.noSpecial(line[4]);
					if (this._player.feeds.isFeed(line[3], line[4])) { // feed found
						if (this._player.feeds.isReady(line[3], line[4])) { // feed is ready
							this._numbers[line[2]] = this._player.feeds.length(line[3], line[4]);
						}
					}
					break;
				case "ifPostData":
					var hasData:Boolean = false;
					line[3] = StringFunctions.noSpecial(line[3]);
					if (this._player.feeds.isFeed(line[2], line[3])) { // feed found
						if (this._player.feeds.isReady(line[2], line[3])) { // feed is ready
							if (this._player.feeds.length(line[2], line[3]) > uint(line[4])) { // feed post is available
								var datapost:FeedData = this._player.feeds.getPost(line[2], line[3], uint(line[4]));
								if ((datapost.getField(line[5]) != null) && (datapost.getField(line[5]) != "")) hasData = true;
							}
						}
					}
					if (hasData) this._parser.setIf(ParserCODE.IFSTATE_TRUE);
						else this._parser.setIf(ParserCODE.IFSTATE_FALSE);
					break;
				case "ifPlayerMobile":
					if (this._player.type == ManaganaPlayer.TYPE_MOBILE) {
						this._parser.setIf(ParserCODE.IFSTATE_TRUE);
					} else {
						this._parser.setIf(ParserCODE.IFSTATE_FALSE);
					}
					break;
				case "ifPlayerWeb":
					if (this._player.type == ManaganaPlayer.TYPE_WEB) {
						this._parser.setIf(ParserCODE.IFSTATE_TRUE);
					} else {
						this._parser.setIf(ParserCODE.IFSTATE_FALSE);
					}
					break;
				case "ifPlayerShowtime":
					if (this._player.type == ManaganaPlayer.TYPE_SHOWTIME) {
						this._parser.setIf(ParserCODE.IFSTATE_TRUE);
					} else {
						this._parser.setIf(ParserCODE.IFSTATE_FALSE);
					}
					break;
				case "ifPlayerDesktop":
					if (this._player.type == ManaganaPlayer.TYPE_DESKTOP) {
						this._parser.setIf(ParserCODE.IFSTATE_TRUE);
					} else {
						this._parser.setIf(ParserCODE.IFSTATE_FALSE);
					}
					break;
				case "ifPlayerUnknown":
					if (this._player.type == ManaganaPlayer.TYPE_UNKNOWN) {
						this._parser.setIf(ParserCODE.IFSTATE_TRUE);
					} else {
						this._parser.setIf(ParserCODE.IFSTATE_FALSE);
					}
					break;
			}
		}
		
	}

}
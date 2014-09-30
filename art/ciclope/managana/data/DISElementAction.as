package art.ciclope.managana.data {
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * DISElementAction holds information about a playlist element action.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class DISElementAction {
		
		// VARIABLES
		
		private var _time:uint;		// time for action (seconds)
		private var _type:String;	// action type (button, do or end)
		private var _code:String;	// action code
		
		/**
		 * DISElementAction constructor.
		 * @param	time	the action time
		 * @param	type	the action type
		 * @param	code	the action code
		 */
		public function DISElementAction(time:uint, type:String, code:String) {
			this._time = time;
			this._type = type;
			this._code = code;
		}
		
		// READ-ONLY VALUES
		
		/**
		 * The time to run action (in seconds).
		 */
		public function get time():uint {
			return (this._time);
		}
		
		/**
		 * The action type: button or do (just run).
		 */
		public function get type():String {
			return (this._type);
		}
		
		/**
		 * The action code.
		 */
		public function get code():String {
			return (this._code);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Release memory used by this object.
		 */
		public function kill():void {
			this._type = null;
			this._code = null;
		}
		
	}

}
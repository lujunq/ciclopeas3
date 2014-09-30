package art.ciclope.sitio.data {
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public final class VoteData {
		
		// VARIABLES
		
		private var _id:uint;		// the vote id (numbers 1 to 9)
		private var _ac:String;		// the vote action string
		
		/**
		 * Create a new VoteData object.
		 * @param	id	the vote id
		 * @param	C	the vote action string
		 */
		public function VoteData(id:uint, ac:String) {
			if ((id >= 1) && (id <= 9)) {
				this._ac = ac;
				this._id = id;
			} else {
				this._id = 0;
				this._ac = "";
			}
		}
		
		/**
		 * The vote id (number from 1 to 9).
		 */
		public function get id():uint {
			return(this._id);
		}
		
		/**
		 * The vote action string.
		 */
		public function get ac():String {
			return (this._ac);
		}
		
		/**
		 * Release memory used by this object.
		 */
		public final function kill():void {
			this._ac = null;
		}
		
	}

}
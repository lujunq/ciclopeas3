package art.ciclope.managana.data {
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * AuthorData holds information about an author.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public final class AuthorData {
		
		// VARIABLES
		
		private var _name:String;		// the author name
		private var _id:String;			// the author identifier
		
		/**
		 * AuthorData constructor.
		 * @param	name	the author name
		 * @param	id	the author identifier
		 */
		public function AuthorData(name:String, id:String) {
			this._name = name;
			this._id = id;
		}
		
		/**
		 * The author name.
		 */
		public function get name():String {
			return(this._name);
		}
		
		/**
		 * The author identifier.
		 */
		public function get id():String {
			return (this._id);
		}
		
		/**
		 * Release memory used by this object.
		 */
		public final function kill():void {
			this._name = null;
			this._id = null;
		}
		
	}

}
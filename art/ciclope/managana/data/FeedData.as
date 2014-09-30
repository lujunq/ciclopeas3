package art.ciclope.managana.data {
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * FeedData holds information about external feeds.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public final class FeedData {
		
		// VARIABLES
		
		private var _name:String;		// the feed name
		private var _type:String;		// the feed type
		private var _reference:String;	// the feed reference
		
		/**
		 * Create a new FeedData object.
		 * @param	name	the feed name
		 * @param	type	the feed type
		 * @param	reference	the feed reference (url, username, etc)
		 */
		public function FeedData(name:String, type:String, reference:String) {
			this._name = name;
			this._type = type;
			this._reference = reference;
		}
		
		/**
		 * The feed name.
		 */
		public function get name():String {
			return (this._name);
		}
		
		/**
		 * The feed type.
		 */
		public function get type():String {
			return (this._type);
		}
		
		/**
		 * The feed reference.
		 */
		public function get reference():String {
			return (this._reference);
		}
		
		/**
		 * Release memory used by object.
		 */
		public final function kill():void {
			this._name = null;
			this._type = null;
			this._reference = null;
		}
		
	}

}
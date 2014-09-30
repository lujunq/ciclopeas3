package art.ciclope.managanaeditor.data {
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * DISElementFielED provides information about playlist element files for Managana editor.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class DISElementFileED {
		
		// VARIABLES
		
		/**
		 * File format.
		 */
		public var format:String = "";
		/**
		 * File language.
		 */
		public var lang:String = "";
		/**
		 * Is file path absolute?
		 */
		public var absolute:Boolean = false;
		/**
		 * File path.
		 */
		public var path:String = "";
		/**
		 * The external feed name.
		 */
		public var feedName:String = "";
		/**
		 * The type if the file is an external feed post.
		 */
		public var feedType:String = "";
		/**
		 * The feed field if the file is an external feed post.
		 */
		public var feedField:String = "";
		
		/**
		 * DISElementFileED constructor.
		 * @param	path	the file path (or text)
		 * @param	format	the file format
		 * @param	lang	the file language
		 * @param	absolute	if file path absolute?
		 * @param	feedName	if is an external feed, the feed name
		 * @param	feedType	the feed type
		 * @param	feedField	the feed post field
		 */
		public function DISElementFileED(path:String = "", format:String = "", lang:String = "", absolute:Boolean = false, feedName:String = "", feedType:String = "", feedField:String = "") {
			this.path = path;
			this.format = format;
			this.lang = lang;
			this.absolute = absolute;
			this.feedType = feedType;
			this.feedField = feedField;
			this.feedName = feedName;
		}
		
		// READ-ONLY VALUES
		
		/**
		 * An exact copy of current file description.
		 */
		public function get clone():DISElementFileED {
			return(new DISElementFileED(this.path, this.format, this.lang, this.absolute, this.feedName, this.feedType, this.feedField));
		}
		
		// PUBLIC METHODS
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			this.feedType = null;
			this.feedField = null;
			this.feedName = null;
			this.path = null;
			this.format = null;
			this.lang = null;
		}
		
	}

}
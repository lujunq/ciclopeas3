package art.ciclope.util {
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * PageDescription creates an object with information about a single page to be used with MediaPages object.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 * @see	art.ciclope.display.MediaPages
	 */
	public class PageDescription {
		
		// PUBLIC VARIABLES
		
		/**
		 * The path to the media file. Can be left as an empty string for picture, text and animation file types.
		 */
		public var path:String;
		/**
		 * The file type of the media to be loaded. If left blank, the system will try to guess.
		 * @see	art.ciclope.util.LoadedFile
		 */
		public var type:String;
		/**
		 * A resource to be used instead of a file while creating the page. Must be a display object for picture type, an array of graphic file paths for animation type or a string for text type.
		 * @see	art.ciclope.util.LoadedFile
		 */
		public var resource:*;
		/**
		 * A parameter to help define the resource. If file type is text, can assume SUBTTILE_TXT or SUBTITLE_HTML. If of animation type, sets the placement according to Placing class.
		 * @see	art.ciclope.util.LoadedFile
		 * @see	art.ciclope.util.Placing
		 */
		public var param:String;
		/**
		 * The page number to access when moving from this page to an upper sequence on MultiSequencePages.
		 */
		public var upPage:uint;
		/**
		 * The page number to access when moving from this page to an lower sequence on MultiSequencePages.
		 */
		public var downPage:uint;
		
		/**
		 * PageDescription constructor.
		 * @param	path	The path to the media file. Can be left as an empty string for picture, text and animation file types.
		 * @param	type	The file type of the media to be loaded.
		 * @param	resource	A resource to be used instead of a file while creating the page.
		 * @param	param	A parameter to help define the resource.
		 * @param	upPage	The page number to access when moving from this page to an upper sequence on MultiSequencePages.
		 * @param	downPage	The page number to access when moving from this page to an lower sequence on MultiSequencePages.
		 */
		public function PageDescription(path:String = "", type:String = "", resource:* = null, param:String = "", upPage:uint = NaN, downPage:uint = NaN) {
			this.path = path;
			this.type = type;
			this.resource = resource;
			this.param = param;
			this.upPage = upPage;
			this.downPage = downPage;
		}
		
	}

}
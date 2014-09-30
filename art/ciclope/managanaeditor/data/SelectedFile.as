package art.ciclope.managanaeditor.data {
	
	// CICLOPE CLASSES
	import art.ciclope.managanaeditor.UserInfo;
	import art.ciclope.staticfunctions.StringFunctions;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * SelectedFile provides information about selected files for playlist elements on Managana editor.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class SelectedFile {
		
		// PUBLIC VARIABLES
		
		/**
		 * Is the file saved at community folder?
		 */
		public var isCommunity:Boolean;
		
		/**
		 * File comunity.
		 */
		public var community:String;
		/**
		 * File name.
		 */
		public var name:String;
		/**
		 * File foler (user id or community).
		 */
		public var folder:String;
		/**
		 * A tentative name for a new playlist.
		 */
		public var playlist:String;
		/**
		 * File type.
		 */
		public var type:String;
		/**
		 * File format.
		 */
		public var format:String;
		/**
		 * Full path to the file.
		 */
		public var path:String;
		/**
		 * The type if the file is an external feed post.
		 */
		public var feedType:String;
		/**
		 * The feed reference if the file is an external feed post.
		 */
		public var feedReference:String;
		/**
		 * The feed field if the file is an external feed post.
		 */
		public var feedField:String;
		/**
		 * The feed post number if the file is an external feed post.
		 */
		public var feedPost:String;
		
		/**
		 * SelectedFile constructor.
		 * @param	community	the community
		 * @param	name	the file name
		 * @param	folder	the file folder
		 * @param	type	the file type
		 * @param	format	the file format
		 * @param	isCommunity	is the file available to the community?
		 * @param	text	text (for text type files)
		 * @param	feedType	if the file is an external feed, the feed type
		 * @param	feedReference	the feed reference
		 * @param	feedField	the feed post field
		 * @param	feedPost	the feed post number
		 */
		public function SelectedFile(community:String, name:String, folder:String, type:String, format:String, isCommunity:Boolean, text:String = "", feedType:String = "", feedReference:String = "", feedField:String = "", feedPost:String = "") {
			this.community = community;
			this.name = StringFunctions.noSpecial(name);
			this.folder = folder;
			this.type = type;
			this.format = format;
			this.isCommunity = isCommunity;
			if (text == "") this.path = "media/" + folder + "/" + type + "/" + name;
				else this.path = text;
			this.playlist = StringFunctions.noSpecial(name) + "_" + UserInfo.index + "_" + (new Date().getTime());
			this.feedType = feedType;
			this.feedReference = feedReference;
			this.feedField = feedField;
			this.feedPost = feedPost;
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			this.community = null;
			this.name = null;
			this.folder = null;
			this.type = null;
			this.format = null;
			this.path = null;
			this.playlist = null;
			this.feedType = null;
			this.feedReference = null;
			this.feedField = null;
			this.feedPost = null;
		}
		
	}

}
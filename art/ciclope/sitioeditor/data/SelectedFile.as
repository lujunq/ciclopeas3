package art.ciclope.sitioeditor.data {
	
	// CICLOPE CLASSES
	import art.ciclope.sitioeditor.UserInfo;
	
	/**
	 * ...
	 * @author Lucas Junqueira
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
		
		public function SelectedFile(community:String, name:String, folder:String, type:String, format:String, isCommunity:Boolean) {
			this.community = community;
			this.name = name;
			this.folder = folder;
			this.type = type;
			this.format = format;
			this.isCommunity = isCommunity;
			this.path = "media/" + folder + "/" + type + "/" + name;
			this.playlist = UserInfo.index + "_" + name.split(".")[0];
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
		}
		
	}

}
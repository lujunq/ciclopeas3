package art.ciclope.sitioeditor.data {
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class DISPlaylistED {
		
		/**
		 * Playlist name.
		 */
		public var name:String = "";
		/**
		 * Playlist id.
		 */
		public var id:String = "";
		/**
		 * Playlist author.
		 */
		public var author:DISAuthorED = new DISAuthorED();
		/**
		 * About this playlist.
		 */
		public var about:String = "";
		/**
		 * Playlist elements.
		 */
		public var elements:Array = new Array();
		
		public function DISPlaylistED() {
			
		}
		
		// PUBLIC METHODS
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			this.name = null;
			this.id = null;
			this.about = null;
			this.author.kill();
			for (var index:String in this.elements) {
				this.elements[index].kill();
				delete(this.elements[index]);
			}
		}
	}

}
package art.ciclope.sitioeditor.data {
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class DISElementED {
		
		// VARIABLES
		
		/**
		 * Element id.
		 */
		public var id:String = "";
		/**
		 * Element playback time.
		 */
		public var time:uint = 10;
		/**
		 * Element type.
		 */
		public var type:String = "picture";
		/**
		 * Element order on playlist.
		 */
		public var order:uint = 0;
		/**
		 * Element actions.
		 */
		public var action:Array = new Array();
		/**
		 * Element files.
		 */
		public var file:Array = new Array();
		
		public function DISElementED(id:String = "", type:String = "picture", time:uint = 10) {
			this.id = id;
			this.type = type;
			this.time = time;
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			id = null;
			type = null;
			while (action.length > 0) {
				action[0].kill();
				action.shift();
			}
			while (file.length > 0) {
				file[0].kill();
				file.shift();
			}
		}
		
	}

}
package art.ciclope.managanaeditor.data {
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * DISElementED provides information about playlist elements for Managana editor.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
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
		 * Element action when time finishes.
		 */
		public var end:String = "stop";
		/**
		 * Element order on playlist.
		 */
		public var order:uint = 0;
		/**
		 * Element actions.
		 */
		public var action:Array = new Array();
		/**
		 * Element end action.
		 */
		public var endAction:String = "";
		/**
		 * Element files.
		 */
		public var file:Array = new Array();
		/**
		 * The external feed name.
		 */
		public var feedName:String = "";
		/**
		 * The type if the file is an external feed post.
		 */
		public var feedType:String = "";
		/**
		 * The feed reference if the file is an external feed post.
		 */
		public var feedReference:String = "";
		
		/**
		 * DISElementED constructor.
		 * @param	id	the element id
		 * @param	type	the element type
		 * @param	time	the element total time
		 * @param	feedName	if it is an external feed, the feed name
		 * @param	feedType	the feed type
		 * @param	feedReference	the feed reference
		 */
		public function DISElementED(id:String = "", type:String = "picture", time:uint = 10, feedName:String = "", feedType:String = "", feedReference:String = "") {
			this.id = id;
			this.type = type;
			this.time = time;
			if (this.type == "feed") {
				this.feedType = feedType;
				this.feedReference = feedReference;
				this.feedName = feedName;
			}
		}
		
		// READ-ONLY VALUES
		
		/**
		 * An exact copy of current element.
		 */
		public function get clone():DISElementED {
			var ret:DISElementED = new DISElementED(this.id, this.type, this.time, this.feedName, this.feedType, this.feedReference);
			ret.order = this.order;
			for (var inuint:uint = 0; inuint < this.file.length; inuint++) ret.file.push(this.file[inuint].clone);
			for (var instring:String in this.action) ret.setAction(this.action[instring].time, this.action[instring].action, this.action[instring].type);
			if (this.endAction != "") ret.endAction = this.endAction;
			return (ret);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Set an element progress code.
		 * @param	time	the code time (seconds)
		 * @param	action	the progress code actions
		 * @param	type	action type: "button", "do" or "end"
		 */
		public function setAction(time:uint, action:String, type:String = "button"):void {
			if (type == "end") this.endAction = action;
			else this.action["t" + time] = { time:time, action:action, type:type };
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			id = null;
			type = null;
			end = null;
			this.feedType = null;
			this.feedReference = null;
			this.feedName = null;
			for (var index:String in this.action) delete(this.action[index]);
			while (file.length > 0) {
				file[0].kill();
				file.shift();
			}
		}
		
	}

}
package art.ciclope.util {
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * SubtitleObject holds information about a single subtitle loaded from a srt file.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class SubtitleObject {
		
		// PUBLIC VARIABLES
		
		/**
		 * The subtitle start time.
		 */
		public var time:Number;
		
		/**
		 * The subtitle text.
		 */
		public var subtitle:String;
		
		/**
		 * Constructor: creates a new object with subtitle data.
		 * @param	time	Subtitle time.
		 * @param	text	Subtitle text.
		 */
		public function SubtitleObject(time:Number = 0, text:String = "") {
			// getting values
			this.time = time;
			this.subtitle = text;
		}
		
	}

}
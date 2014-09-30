package art.ciclope.managana.data {
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * HistoryData holds information about an user navigation point.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class HistoryData {
		
		/**
		 * The accessed stream ID.
		 */
		public var stream:String;
		
		/**
		 * The accessed stream community.
		 */
		public var community:String;
		
		/**
		 * HistoryData constructor.
		 * @param	com	the community ID
		 * @param	str	the stream ID
		 */
		public function HistoryData(com:String, str:String) {
			this.community = com;
			this.stream = str;
		}
		
		/**
		 * Release memory used by this object.
		 */
		public function kill():void {
			this.community = null;
			this.stream = null;
		}
		
	}

}
package art.ciclope.managanaeditor.data {
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * DISMetaED provides information about a meta data field for Managana editor.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class DISMetaED {
		
		/**
		 * The meta data field name.
		 */
		public var name:String = "";
		/**
		 * The meta data field ID.
		 */
		public var id:int = -1;
		/**
		 * The meta data value (for streams).
		 */
		public var value:String = "";
		
		/**
		 * DISFeedED constructor.
		 * @param	mname	the meta data field name
		 * @param	mid		the meta data field id
		 * @param	mvalue	the meta data value (for streams)
		 */
		public function DISMetaED(mname:String = "", mid:int = -1, mvalue:String = "") {
			this.name = mname;
			this.id = mid;
			this.value = mvalue;
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			this.name = null;
			this.value = null;
		}
		
	}

}
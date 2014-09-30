package art.ciclope.managanaeditor.data {
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * DISFeedED provides information about external feeds for Managana editor.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class DISFeedED {
		
		/**
		 * The feed name.
		 */
		public var name:String = "";
		/**
		 * The feed type.
		 */
		public var type:String = "";
		/**
		 * The feed reference.
		 */
		public var reference:String = "";
		
		/**
		 * DISFeedED constructor.
		 * @param	fname	the feed name
		 * @param	ftype	the feed type
		 * @param	fref	the feed reference
		 */
		public function DISFeedED(fname:String = "", ftype:String = "", fref:String = "") {
			this.name = fname;
			this.type = ftype;
			this.reference = fref;
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			this.name = null;
			this.type = null;
			this.reference = null;
		}
		
	}

}
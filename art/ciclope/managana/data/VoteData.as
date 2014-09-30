package art.ciclope.managana.data {
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * VoteData holds information about a dis folder stream vote option.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public final class VoteData {
		
		// PUBLIC VARIABLES
		
		/**
		 * Vote number reference.
		 */
		public var num:int = -1;
		/**
		 * Vote display x position.
		 */
		public var px:int = 0;
		/**
		 * Vote display y position.
		 */
		public var py:int = 0;
		/**
		 * Is vote display visible?
		 */
		public var visible:Boolean = true;
		/**
		 * Vote action.
		 */
		public var action:String = "";
		
		/**
		 * VoteData constructor.
		 * @param	id	the vote id
		 * @param	ac	the vote action string
		 */
		public function VoteData(vnum:int = -1, vaction:String = "", vpx:int = 0, vpy:int = 0, vvisible:Boolean = true) {
			this.num = vnum;
			this.action = vaction;
			this.px = vpx;
			this.py = vpy;
			this.visible = vvisible;
		}
		
		/**
		 * Release memory used by this object.
		 */
		public final function kill():void {
			this.action = null;
		}
		
		/**
		 * Clear vote option information.
		 * @param	vnum	the option number reference
		 */
		public function clear(vnum:int = -1):void {
			this.num = vnum;
			this.action = "";
			this.px = 0;
			this.py = 0;
			this.visible = true;
		}
		
	}

}
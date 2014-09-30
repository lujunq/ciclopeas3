package art.ciclope.managanaeditor.data {
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * DISVoteED provides information about a vote option of a stream.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class DISVoteED {
		
		/**
		 * The vote action.
		 */
		public var action:String = "";
		/**
		 * The vote number.
		 */
		public var num:int = -1;
		/**
		 * The vote graphic x position.
		 */
		public var px:int = 0;
		/**
		 * The vote graphic y position.
		 */
		public var py:int = 0;
		/**
		 * Is the vote graphic visible?
		 */
		public var visible:Boolean = true;
		
		/**
		 * DISVoteED constructor.
		 * @param	vnum	the vote number
		 * @param	vaction	the vote action
		 * @param	vpx	the graphic x position
		 * @param	vpy	the graphic y position
		 * @param	vvisible	is the graphic visible?
		 */
		public function DISVoteED(vnum:int = -1, vaction:String = "", vpx:int = 0, vpy:int = 0, vvisible:Boolean = true) {
			this.action = vaction;
			this.num = vnum + 1;
			this.px = vpx;
			this.py = vpy;
			this.visible = vvisible;
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			this.action = null;
		}
		
		/**
		 * Clear vote option.
		 * @param	vnum	vote number
		 */
		public function clear(vnum:int = -1):void {
			this.action = "";
			this.num = vnum + 1;
			this.px = 0;
			this.py = 0;
			this.visible = true;
		}
		
	}

}
package art.ciclope.util {
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * Placing defines values (constants) for relative image placing on parent display object.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class Placing {
		
		// STATIC CONSTANTS
		
		/**
		 * Image place: top left corner.
		 */
		public static const TOPLEFT:String = "TOPLEFT";
		/**
		 * Image place: top center corner.
		 */
		public static const TOPCENTER:String = "TOPCENTER";
		/**
		 * Image place: top right corner.
		 */
		public static const TOPRIGHT:String = "TOPRIGHT";
		/**
		 * Image place: middle left corner.
		 */
		public static const MIDDLELEFT:String = "MIDDLELEFT";
		/**
		 * Image place: center.
		 */
		public static const CENTER:String = "CENTER";
		/**
		 * Image place: middle right corner.
		 */
		public static const MIDDLERIGHT:String = "MIDDLERIGHT";
		/**
		 * Image place: bottom left corner.
		 */
		public static const BOTTOMLEFT:String = "BOTTOMLEFT";
		/**
		 * Image place: bottom center corner.
		 */
		public static const BOTTOMCENTER:String = "BOTTOMCENTER";
		/**
		 * Image place: bottom right corner.
		 */
		public static const BOTTOMRIGHT:String = "BOTTOMRIGHT";
		
		/**
		 * Checks if the provided string is a Placing constant.
		 * @param	check	The string to test.
		 * @return	True if the string is a Placing constant, false otherwise.
		 */
		public static function isPlacing(check:String):Boolean {
			var ret:Boolean = false;
			switch (check) {
				case TOPLEFT: ret = true; break;
				case TOPCENTER: ret = true; break;
				case TOPRIGHT: ret = true; break;
				case MIDDLELEFT: ret = true; break;
				case MIDDLERIGHT: ret = true; break;
				case CENTER: ret = true; break;
				case BOTTOMCENTER: ret = true; break;
				case BOTTOMLEFT: ret = true; break;
				case BOTTOMRIGHT: ret = true; break;
			}
			return (ret);
		}
		
	}

}
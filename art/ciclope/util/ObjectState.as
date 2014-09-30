package art.ciclope.util {
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * ObjectState provides information for handling objects states, like download status and so on.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class ObjectState {
		
		// STATIC CONSTANTS
		
		/**
		 * Object state: not ready.
		 */
		public static const STATE_NOTREADY:String = "STATE_NOTREADY";
		/**
		 * Object state: clean (no data loaded).
		 */
		public static const STATE_CLEAN:String = "STATE_CLEAN";
		/**
		 * Object state: loading data.
		 */
		public static const STATE_LOADING:String = "STATE_LOADING";
		/**
		 * Object state: last data didn't load correclty.
		 */
		public static const STATE_LOADERROR:String = "STATE_LOADERROR";
		/**
		 * Object state: last data loaded correctly
		 */
		public static const STATE_LOADOK:String = "STATE_LOADOK";
		
	}

}
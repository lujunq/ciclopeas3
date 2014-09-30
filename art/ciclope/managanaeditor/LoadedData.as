package art.ciclope.managanaeditor {
	
	// CICLOPE CLASSES
	import art.ciclope.managanaeditor.data.DISCommunityED;
	import art.ciclope.managanaeditor.data.DISStreamED;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * LoadedData provides static references for the loaded community and stream on Managana editor.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class LoadedData {
		
		// STATIC STATEMENTS
		
		/**
		 * Information about loaded community.
		 */
		public static var community:DISCommunityED = new DISCommunityED();
		
		/**
		 * Information about loaded stream.
		 */
		public static var stream:DISStreamED = new DISStreamED();
		
	}

}
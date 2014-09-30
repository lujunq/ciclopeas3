package art.ciclope.resource {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * <b>Font: </b>Gentium regular.<br>
	 * <b>Attention: this is a font resource file embeder. Please check out font licenses before using them. This is an embed font exemple working on Flex SDK 4.x only. May not work on other Flex SDK versions. Will not work on Flash.</b><br><br>
	 * This is an example file of font asset creation from a true type or an open type font file. At this example we are using the nice Gentium font provided under the SIL Open Font License. Please chek http://scripts.sil.org/Gentium for more details.<br>
	 * Gentium ("belonging to the nations" in Latin) is a Unicode typeface family designed to enable the many diverse ethnic groups around the world who use the Latin script to produce readable, high-quality publications. It supports a wide range of Latin-based alphabets and includes glyphs that correspond to all the Latin ranges of Unicode.<br>
	 * Gentium was created by J. Victor Gaultney and Annie Olsen and uses OFL license - http://scripts.sil.org/OFL
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 * @see	art.ciclope.resource.FontManager
	 */
	public class GentiumRegular extends Sprite {
		
		// VARIABLES
		
		/**
		 * The font class.
		 */
		[Embed(source='GenR102.TTF', fontName='Gentium', embedAsCFF='false', mimeType="application/x-font")]	// relative of full path to the font file
		private var _Gentium:Class;																				// name your font here: this name will be used in yout code to identify the font
		
		/**
		 * Prepares the font.
		 * @return	The font resource.
		 */
		public function getFont():Class {					// always keep this getFont function to maintain FontManager compatibility
			return (_Gentium);								// return the font class variable you created above
		}
		
	}

}
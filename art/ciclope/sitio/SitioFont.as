package art.ciclope.sitio {
	
	// FLASH PACKAGES
	import flash.text.Font;
	import flash.text.FontStyle;
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class SitioFont {
		
		/**
		 * Gentium
		 */
		[Embed(source='./fonts/GenBasR.ttf', fontFamily='Gentium', fontStyle='normal', fontWeight='normal', unicodeRange='U+0020-002F,U+0030-0039,U+003A-0040,U+0041-005A,U+005B-0060,U+0061-007A,U+007B-007E,U+0020,U+00A1-00FF,U+2000-206F,U+20A0-20CF,U+2100-2183', embedAsCFF='false', advancedAntiAliasing='false', mimeType="application/x-font")]
		private var GentiumRegular:Class;
		[Embed(source='./fonts/GenBasB.ttf', fontFamily='Gentium', fontStyle='normal', fontWeight='bold', unicodeRange='U+0020-002F,U+0030-0039,U+003A-0040,U+0041-005A,U+005B-0060,U+0061-007A,U+007B-007E,U+0020,U+00A1-00FF,U+2000-206F,U+20A0-20CF,U+2100-2183', embedAsCFF='false', advancedAntiAliasing='false', mimeType="application/x-font")]
		private var GentiumBold:Class;
		[Embed(source='./fonts/GenBasI.ttf', fontFamily='Gentium', fontStyle='italic', fontWeight='normal', unicodeRange='U+0020-002F,U+0030-0039,U+003A-0040,U+0041-005A,U+005B-0060,U+0061-007A,U+007B-007E,U+0020,U+00A1-00FF,U+2000-206F,U+20A0-20CF,U+2100-2183', embedAsCFF='false', advancedAntiAliasing='false', mimeType="application/x-font")]
		private var GentiumItalic:Class;
		[Embed(source='./fonts/GenBasBI.ttf', fontFamily='Gentium', fontStyle='italic', fontWeight='bold', unicodeRange='U+0020-002F,U+0030-0039,U+003A-0040,U+0041-005A,U+005B-0060,U+0061-007A,U+007B-007E,U+0020,U+00A1-00FF,U+2000-206F,U+20A0-20CF,U+2100-2183', embedAsCFF='false', advancedAntiAliasing='false', mimeType="application/x-font")]
		private var GentiumBoldItalic:Class;
		
		/**
		 * Marvel
		 */
		[Embed(source='./fonts/Marvel-Regular.ttf', fontFamily='Marvel', fontStyle='normal', fontWeight='normal', unicodeRange='U+0020-002F,U+0030-0039,U+003A-0040,U+0041-005A,U+005B-0060,U+0061-007A,U+007B-007E,U+0020,U+00A1-00FF,U+2000-206F,U+20A0-20CF,U+2100-2183', embedAsCFF='false', advancedAntiAliasing='false', mimeType="application/x-font")]
		private var MarvelRegular:Class;
		[Embed(source='./fonts/Marvel-Bold.ttf', fontFamily='Marvel', fontStyle='normal', fontWeight='bold', unicodeRange='U+0020-002F,U+0030-0039,U+003A-0040,U+0041-005A,U+005B-0060,U+0061-007A,U+007B-007E,U+0020,U+00A1-00FF,U+2000-206F,U+20A0-20CF,U+2100-2183', embedAsCFF='false', advancedAntiAliasing='false', mimeType="application/x-font")]
		private var MarvelBold:Class;
		[Embed(source='./fonts/Marvel-Italic.ttf', fontFamily='Marvel', fontStyle='italic', fontWeight='normal', unicodeRange='U+0020-002F,U+0030-0039,U+003A-0040,U+0041-005A,U+005B-0060,U+0061-007A,U+007B-007E,U+0020,U+00A1-00FF,U+2000-206F,U+20A0-20CF,U+2100-2183', embedAsCFF='false', advancedAntiAliasing='false', mimeType="application/x-font")]
		private var MarvelItalic:Class;
		[Embed(source='./fonts/Marvel-BoldItalic.ttf', fontFamily='Marvel', fontStyle='italic', fontWeight='bold', unicodeRange='U+0020-002F,U+0030-0039,U+003A-0040,U+0041-005A,U+005B-0060,U+0061-007A,U+007B-007E,U+0020,U+00A1-00FF,U+2000-206F,U+20A0-20CF,U+2100-2183', embedAsCFF='false', advancedAntiAliasing='false', mimeType="application/x-font")]
		private var MarvelBoldItalic:Class;
		
		public function SitioFont() {	}
		
		public static function getEmbed(name:String, style:String):Font {
			var found:Boolean = false;
			var reallyfound:Boolean = false;
			var enum:Array = Font.enumerateFonts();
			var ret:Font;
			for (var istr:String in enum) {
				if (enum[istr] is Font) {
					if ((!found) && (!reallyfound)) {
						ret = enum[istr];
						found = true;
					} else if (!reallyfound) {
						if (enum[istr].fontStyle == style) ret = enum[istr];
					}
					if ((enum[istr].fontStyle == style) && (enum[istr].fontName == name)) {
						ret = enum[istr];
						reallyfound = true;
					}
				}
			}
			return (ret);
		}
		
	}

}
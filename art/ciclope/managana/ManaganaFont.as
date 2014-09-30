package art.ciclope.managana {
	
	// FLASH PACKAGES
	import flash.text.Font;
	import flash.text.FontStyle;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * ManaganaFont handles font installations. It comes with some open fonts already assigned for reference. To learn more about open fonts, access http://openfontlibrary.org/ or http://www.google.com/webfonts
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class ManaganaFont {
		
		/**
		 * Crimson, by Sebastian Kosch. Font license: OFL - http://scripts.sil.org/OFL
		 */
		[Embed(source='./fonts/Crimson-Roman.otf', fontFamily='Crimson', fontStyle='normal', fontWeight='normal', unicodeRange='U+0020-002F,U+0030-0039,U+003A-0040,U+0041-005A,U+005B-0060,U+0061-007A,U+007B-007E,U+0020,U+00A1-00FF,U+2000-206F,U+20A0-20CF,U+2100-2183', embedAsCFF='false', advancedAntiAliasing='false', mimeType="application/x-font")]
		private var CrimsonRegular:Class;
		[Embed(source='./fonts/Crimson-Bold.otf', fontFamily='Crimson', fontStyle='normal', fontWeight='bold', unicodeRange='U+0020-002F,U+0030-0039,U+003A-0040,U+0041-005A,U+005B-0060,U+0061-007A,U+007B-007E,U+0020,U+00A1-00FF,U+2000-206F,U+20A0-20CF,U+2100-2183', embedAsCFF='false', advancedAntiAliasing='false', mimeType="application/x-font")]
		private var CrimsonBold:Class;
		[Embed(source='./fonts/Crimson-Italic.otf', fontFamily='Crimson', fontStyle='italic', fontWeight='normal', unicodeRange='U+0020-002F,U+0030-0039,U+003A-0040,U+0041-005A,U+005B-0060,U+0061-007A,U+007B-007E,U+0020,U+00A1-00FF,U+2000-206F,U+20A0-20CF,U+2100-2183', embedAsCFF='false', advancedAntiAliasing='false', mimeType="application/x-font")]
		private var CrimsonItalic:Class;
		
		/**
		 * NotCourierSans, by Harrisson, Pierre Huyghebaert, Femke Snelting, Ivan Monroy-Lopez, Yi Jiang, Nicolas Malevé and Ludivine Loiseau. Font license: OFL - http://scripts.sil.org/OFL
		 */
		[Embed(source='./fonts/NotCourierSans.otf', fontFamily='NotCourierSans', fontStyle='normal', fontWeight='normal', unicodeRange='U+0020-002F,U+0030-0039,U+003A-0040,U+0041-005A,U+005B-0060,U+0061-007A,U+007B-007E,U+0020,U+00A1-00FF,U+2000-206F,U+20A0-20CF,U+2100-2183', embedAsCFF='false', advancedAntiAliasing='false', mimeType="application/x-font")]
		private var NotCourierSansRegular:Class;
		[Embed(source='./fonts/NotCourierSans-Bold.otf', fontFamily='NotCourierSans', fontStyle='normal', fontWeight='bold', unicodeRange='U+0020-002F,U+0030-0039,U+003A-0040,U+0041-005A,U+005B-0060,U+0061-007A,U+007B-007E,U+0020,U+00A1-00FF,U+2000-206F,U+20A0-20CF,U+2100-2183', embedAsCFF='false', advancedAntiAliasing='false', mimeType="application/x-font")]
		private var NotCourierSansBold:Class;
		
		/**
		 * Pfenning, by Daniel Johnson. Font license: OFL - http://scripts.sil.org/OFL
		 */
		[Embed(source='./fonts/Pfennig.ttf', fontFamily='Pfenning', fontStyle='normal', fontWeight='normal', unicodeRange='U+0020-002F,U+0030-0039,U+003A-0040,U+0041-005A,U+005B-0060,U+0061-007A,U+007B-007E,U+0020,U+00A1-00FF,U+2000-206F,U+20A0-20CF,U+2100-2183', embedAsCFF='false', advancedAntiAliasing='false', mimeType="application/x-font")]
		private var PfenningRegular:Class;
		[Embed(source='./fonts/PfennigBold.ttf', fontFamily='Pfenning', fontStyle='normal', fontWeight='bold', unicodeRange='U+0020-002F,U+0030-0039,U+003A-0040,U+0041-005A,U+005B-0060,U+0061-007A,U+007B-007E,U+0020,U+00A1-00FF,U+2000-206F,U+20A0-20CF,U+2100-2183', embedAsCFF='false', advancedAntiAliasing='false', mimeType="application/x-font")]
		private var PfenningBold:Class;
		[Embed(source='./fonts/PfennigItalic.ttf', fontFamily='Pfenning', fontStyle='italic', fontWeight='normal', unicodeRange='U+0020-002F,U+0030-0039,U+003A-0040,U+0041-005A,U+005B-0060,U+0061-007A,U+007B-007E,U+0020,U+00A1-00FF,U+2000-206F,U+20A0-20CF,U+2100-2183', embedAsCFF='false', advancedAntiAliasing='false', mimeType="application/x-font")]
		private var PfenningItalic:Class;
		[Embed(source='./fonts/PfennigBoldItalic.ttf', fontFamily='Pfenning', fontStyle='italic', fontWeight='bold', unicodeRange='U+0020-002F,U+0030-0039,U+003A-0040,U+0041-005A,U+005B-0060,U+0061-007A,U+007B-007E,U+0020,U+00A1-00FF,U+2000-206F,U+20A0-20CF,U+2100-2183', embedAsCFF='false', advancedAntiAliasing='false', mimeType="application/x-font")]
		private var PfenningBoldItalic:Class;
		
		/**
		 * ManaganaFont constructor.
		 */
		public function ManaganaFont() {	}
		
		/**
		 * An Array with all available fonts names.
		 */
		public static function get fontList():Array {
			var ret:Array = new Array();
			var enum:Array = Font.enumerateFonts();
			var temp:Array = new Array();
			for (var istr:String in enum) {
				if (enum[istr] is Font) {
					temp[String(enum[istr].fontName)] = String(enum[istr].fontName);
				}
			}
			for (istr in temp) ret.push(istr);
			return (ret);
		}
		
		/**
		 * Get a font resource.
		 * @param	name	the font name
		 * @param	style	the font style
		 * @return	a Font class with the font reference if it is available, null otherwise
		 */
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
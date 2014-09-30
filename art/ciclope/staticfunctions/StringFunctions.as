package art.ciclope.staticfunctions {
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * StringFunctions provides static methods for handling strings.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class StringFunctions {
		
		// STATIC FUNCTIONS
		
		/**
		 * Checks a url for ending slash.
		 * @param	url	the url to check
		 * @return	the url with an ending slash
		 */
		public static function slashURL(url:String):String {
			if (url.charAt(url.length - 1) == "/") return (url);
			else return (url + "/");
		}
		
		/**
		 * "Clean" a string removing unnecessary whitespaces.
		 * @param	of 	the string to trim
		 * @return	the resulting string
		 */
		public static function trim(of:String):String {
			return (of.replace( /^([\s|\t|\n]+)?(.*)([\s|\t|\n]+)?$/gm, "$2"));
		}
		
		/**
		 * Remove special chars and convert spaces to _.
		 * @param	of	the string to transform
		 * @return	a string with all repeacements
		 */
		public static function noSpecial(of:String):String {
			var text:String = StringFunctions.trim(of);
			var output:String = "";
			for (var index:uint = 0; index < text.length; index++) {
				if (text.charAt(index) == " ") output += "_";
					if (text.charAt(index) == ".") output += ".";
					else if (text.charAt(index) == escape(text.charAt(index))) output += text.charAt(index);
						else output += "_";
			}
			return (output);
		}
		
		/**
		 * Convert a date string to a Date object.
		 * @param	date	a string representing a date in format like 'Mon, 10 Oct 2011 13:56:54 +0000'
		 * @return	a date object holding the provided date
		 */
		public static function stringToDate(date:String):Date {
			var ret:Date;
			try {
				ret = new Date(Date.parse(StringFunctions.trim(date)));
			} catch (e:Error) {
				// keep current date
				ret = new Date();
			}
			return (ret);
		}
		
		/**
		 * Check for the requested string length and add leading zeroes ulti it is reached.
		 * @param	num	the number to check
		 * @param	lenght	the minimum lenght the string must have
		 * @return	a string with at least the requestes leght with leading zeroes if necessary
		 */
		public static function leading0(num:*, lenght:uint):String {
			var str:String = new String(num);
			while (str.length < lenght) str = "0" + str;
			return (str);
		}
		
		/**
		 * Parse a text to find any link.
		 * @param	text	the text to check
		 * @return	the first link found or an empty string
		 */
		public static function parseForLink(text:String):String {
			var ret:String = "";
			var linkARR:Array = text.split("http://");
			if (linkARR.length > 1) {
				ret = "http://" + linkARR[1];
				ret = StringFunctions.trim(ret);
				if (ret.indexOf(" ") >= 0) ret = ret.substr(0, ret.indexOf(" "));
			}
			return (StringFunctions.trim(ret));
		}
		
		/**
		 * Parse a html-formatted text looking for a random image url.
		 * @param	text	a html-formatted text string
		 * @return	a random image url found on the text
		 */
		public static function parseForImage(text:String):String {
			var ret:String = "";
			var width:Number = 0;
			var imgArr:Array = text.split("<img");
			for (var index:uint = 0; index < imgArr.length; index++) {
				var imgCode:String = String(imgArr[index]).substring(0, String(imgArr[index]).indexOf(">"));
				if (imgCode.indexOf('src="') > 0) {
					var src:String = imgCode.substr((imgCode.indexOf('src="') + 5));
					src = src.substr(0, src.indexOf('"'));
					var imgWidth:String = "0";
					if (imgCode.indexOf('width="') > 0) {
						imgWidth = imgCode.substr((imgCode.indexOf('width="') + 7));
						imgWidth = imgWidth.substr(0, imgWidth.indexOf('"'));
					}
					var imgHeight:String = "0";
					if (imgCode.indexOf('height="') > 0) {
						imgHeight = imgCode.substr((imgCode.indexOf('height="') + 8));
						imgHeight = imgHeight.substr(0, imgHeight.indexOf('"'));
					}
					if (Number(imgWidth) >= width) {
						if ((Number(imgHeight) >= 100) || (Number(imgHeight) == 0)) {
							ret = src;
							width = Number(imgWidth);
						}
					}
				}
			}
			return(ret)
		}
		
		/**
		 * Remove HTML tags from a string.
		 * @param	from	a html formatted string
		 * @return	the string without tags
		 */
		public static function stripTags(from:String):String {
			var removeHTML:RegExp = new RegExp("<[^>]*>", "gi");
			return (from.replace(removeHTML, ""));
		}
		
		/**
		 * Convert a boolean to a string.
		 * @param	bool	the boolean to convert - may be a boolean, a string ("true"/"false") or a number
		 * @return	the string "true" if bool is true or "false" otherwise
		 */
		public static function boolToString(bool:*):String {
			var ret:Boolean = false;
			if (bool is Boolean) {
				ret = bool;
			} else if (bool is String) {
				ret = bool == "true";
			} else if ((bool is Number) || (bool is uint) || (bool is int)) {
				ret = bool != 0;
			}
			if (ret) return ("true");
				else return ("false");
		}
		
		/**
		 * Convert a boolean to a string.
		 * @param	bool	the boolean to convert - may be a boolean, a string ("true"/"false") or a number
		 * @return	the string "1" if bool is true or "0" otherwise
		 */
		public static function boolToNumString(bool:*):String {
			var ret:Boolean = false;
			if (bool is Boolean) {
				ret = bool;
			} else if (bool is String) {
				ret = bool == "true";
			} else if ((bool is Number) || (bool is uint) || (bool is int)) {
				ret = bool != 0;
			}
			if (ret) return ("1");
				else return ("0");
		}
		
		/**
		 * Convert a number of seconds into a formatted ##:##:## time string.
		 * @param	seconds	the total number of seconds
		 * @return	a formatted string
		 */
		public static function parseSeconds(seconds:uint):String {
			var s:Number = seconds % 60;
			var m:Number = Math.floor((seconds % 3600) / 60);
			var h:Number = Math.floor(seconds / (60 * 60));
			var ret:String = "";
			if (h > 0) ret += h + ":";
			if (m == 0) ret += "00:";
				else if (m < 10) ret += "0" + m + ":";
				else ret += m + ":";
			if (s == 0) ret += "00";
				else if (s < 10) ret += "0" + s;
				else ret += s;
			return (ret);
		}
		
		/**
		 * Write a xml item with CDATA.
		 * @param	name	item name
		 * @param	value	item value
		 * @return	XML-formatted item with CDATA
		 */
		public static function cdataXML(name:String, value:String):String {
			return ('<' + name + '><![CDATA[' + value + ']]></' + name + '>');
		}
		
		/**
		 * Replace all <br> on an html-formatted string by <br />.
		 * @param	str	the input string
		 * @return	a string will all <br> turned into <br />
		 */
		public static function htmlBR(str:String):String {
			return (str.replace(/<br>/gi, '<br />'));
		}
		
		/**
		 * Convert text from the Flex rich text editor into html-compatible format.
		 * This function was developed by Robert Cesaric: http://cesaric.com
		 * @param	str	the Flex rich text edit text
		 * @return	an html-compatible text
		 */
		public static function richTextEditorToHtml(str:String):String {
			// Create XML document
			var xml:XML = XML("<BODY>"+str+"</BODY>");
			// temporary
			var t1:XML;
			var t2:XML;
			// Remove all TEXTFORMAT
			for( t1 = xml..TEXTFORMAT[0]; t1 != null; t1 = xml..TEXTFORMAT[0] ) {				
				if(t1.child("LI").length() != 0){
					trace(t1.childIndex());
					delete t1.@LEADING;
					t1.setName("UL");						
				} else {
					t1.parent().replace( t1.childIndex(), t1.children() );
				}										
			}
 			// Find all ALIGN
			for each ( t1 in xml..@ALIGN ) {
				t2 = t1.parent();
				t2.@STYLE = "text-align: " + t1 + "; " + t2.@STYLE;
				delete t2.@ALIGN;
			}
			// Find all FACE
			for each ( t1 in xml..@FACE ) {
				t2 = t1.parent();
				t2.@STYLE = "font-family: " + t1 + "; " + t2.@STYLE;
				delete t2.@FACE;
			}
			// Find all SIZE 
			for each ( t1 in xml..@SIZE ) {
				t2 = t1.parent();
				t2.@STYLE = "font-size: " + t1 + "px; " + t2.@STYLE;
				delete t2.@SIZE;
			}
			// Find all COLOR 
			for each ( t1 in xml..@COLOR ) {
				t2 = t1.parent();
				t2.@STYLE = "color: " + t1 + "; " + t2.@STYLE;
				delete t2.@COLOR;
			}
			// Find all LETTERSPACING 
			for each ( t1 in xml..@LETTERSPACING ) {
				t2 = t1.parent();
				t2.@STYLE = "letter-spacing: " + t1 + "px; " + t2.@STYLE;
				delete t2.@LETTERSPACING;
			}
			// Find all KERNING
			for each ( t1 in xml..@KERNING ) {
				t2 = t1.parent();
				// ? css 
				delete t2.@KERNING;
			}
			//Group adjacent LI's together 
			var str:String = xml.children().toXMLString();
			var pattern:RegExp = /<\/UL>\s*<UL>/ixg;
           	str = str.replace(pattern, "");
			// return
			return str;
		}
		
	}

}
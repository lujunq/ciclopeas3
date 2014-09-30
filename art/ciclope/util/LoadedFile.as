package art.ciclope.util {
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * LoadedFile provides data and functions related to loaded media content.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class LoadedFile	{
		
		// CLASS CONSTANT DEFINITIONS
		
		/**
		 * Type of data loaded: none.
		 */
		public static const TYPE_NONE:String = "TYPE_NONE";
		/**
		 * Type of data loaded: picture (jpeg, gif or png).
		 */
		public static const TYPE_PICTURE:String = "TYPE_PICTURE";
		/**
		 * Type of data loaded: flash movie (swf).
		 */
		public static const TYPE_FLASH:String = "TYPE_FLASH";
		/**
		 * Type of data loaded: video (flv, mp4, 3gp).
		 */
		public static const TYPE_VIDEO:String = "TYPE_VIDEO";
		/**
		 * Type of data loaded: audio (mp3).
		 */
		public static const TYPE_AUDIO:String = "TYPE_AUDIO";
		/**
		 * Type of data loaded: text.
		 */
		public static const TYPE_TEXT:String = "TYPE_TEXT";
		/**
		 * Type of data loaded: paragraph text.
		 */
		public static const TYPE_PARAGRAPH:String = "TYPE_PARAGRAPH";
		/**
		 * Type of data loaded: other media types.
		 */
		public static const TYPE_OTHER:String = "TYPE_OTHER";
		/**
		 * Type of data loaded: xml text.
		 */
		public static const TYPE_XML:String = "TYPE_XML";
		/**
		 * Type of data loaded: font (embed into swf file).
		 */
		public static const TYPE_FONT:String = "TYPE_FONT";
		/**
		 * Type of data loaded: animation (sequence of picture or swf files).
		 */
		public static const TYPE_ANIMATION:String = "TYPE_ANIMATION";
		/**
		 * Type of data loaded: unknown.
		 */
		public static const TYPE_UNKNOWN:String = "TYPE_UNKNOWN";
		
		/**
		 * Subtype: plain text (must be utf-8 encoded).
		 */
		public static const SUBTYPE_TXT:String = "SUBTYPE_TXT";
		/**
		 * Subtype: html text (must be utf-8 encoded).
		 */
		public static const SUBTYPE_HTML:String = "SUBTYPE_HTML";
		/**
		 * Subtype: mp3 audio.
		 */
		public static const SUBTYPE_MP3:String = "SUBTYPE_MP3";
		/**
		 * Subtype: png image.
		 */
		public static const SUBTYPE_PNG:String = "SUBTYPE_PNG";
		/**
		 * Subtype: jpeg image.
		 */
		public static const SUBTYPE_JPEG:String = "SUBTYPE_JPEG";
		/**
		 * Subtype: gif image.
		 */
		public static const SUBTYPE_GIF:String = "SUBTYPE_GIF";
		/**
		 * Subtype: flash movie.
		 */
		public static const SUBTYPE_SWF:String = "SUBTYPE_SWF";
		/**
		 * Subtype: flv video.
		 */
		public static const SUBTYPE_FLV:String = "SUBTYPE_FLV";
		/**
		 * Subtype: mp4 video.
		 */
		public static const SUBTYPE_MP4:String = "SUBTYPE_MP4";
		/**
		 * Subtype: mobile video.
		 */
		public static const SUBTYPE_3GP:String = "SUBTYPE_3GP";
		/**
		 * Subtype: none (no file loaded).
		 */
		public static const SUBTYPE_NONE:String = "SUBTYPE_NONE";
		
		/**
		 * File comment: download asked as a single file.
		 */
		public static const COMMENT_SINGLE:String = "COMMENT_SINGLE";
		/**
		 * File comment: file is the first on a multiple download request.
		 */
		public static const COMMENT_FIRST:String = "COMMENT_FIRST";
		/**
		 * File comment: file is in the middle of a multiple download request.
		 */
		public static const COMMENT_MIDDLE:String = "COMMENT_MIDDLE";
		/**
		 * File comment: file is the last one on a multiple download request.
		 */
		public static const COMMENT_LAST:String = "COMMENT_LAST";
		
		// STATIC FUNCTIONS
		
		/**
		 * Returns the file type guessing by its extension.
		 * @param	path
		 * @return	The file type.
		 */
		public static function typeOf(path:String):String {
			var theReturn:String = LoadedFile.TYPE_UNKNOWN;
			if (path != null) {
				var extTest:Array = path.split(".");
				switch (String(extTest[extTest.length -1]).toLowerCase()) {
					case "jpg":
					case "jpeg":
					case "png":
					case "gif":
						theReturn = LoadedFile.TYPE_PICTURE;
						break;
					case "swf":
						theReturn = LoadedFile.TYPE_FLASH;
						break;
					case "flv":
					case "f4v":
					case "3gp":
					case "3g2":
					case "mp4":
					case "avi":
					case "mov":
						theReturn = LoadedFile.TYPE_VIDEO;
						break;
					case "mp3":
						theReturn = LoadedFile.TYPE_AUDIO;
						break;
					case "txt":
					case "htm":
					case "html":
					case "php":
					case "asp":
					case "aspx":
					case "cfm":
					case "jsp":
						theReturn = LoadedFile.TYPE_TEXT;
						break;
				}
			}
			return (theReturn);
		}
		
		/**
		 * Returns the file subtype guessing by its extension.
		 * @param	path
		 * @return	The file subtype.
		 */
		public static function subtypeOf(path:String):String {
			var extTest:Array = path.split(".");
			var theReturn:String = LoadedFile.TYPE_UNKNOWN;
			switch (String(extTest[extTest.length -1]).toLowerCase()) {
				case "jpg":
				case "jpeg":
					theReturn = LoadedFile.SUBTYPE_JPEG;
					break;
				case "png":
					theReturn = LoadedFile.SUBTYPE_PNG;
					break;
				case "gif":
					theReturn = LoadedFile.SUBTYPE_GIF;
					break;
				case "swf":
					theReturn = LoadedFile.SUBTYPE_SWF;
					break;
				case "flv":
					theReturn = LoadedFile.SUBTYPE_FLV;
					break;
				case "f4v":
					theReturn = LoadedFile.SUBTYPE_MP4;
					break;
				case "3gp":
					theReturn = LoadedFile.SUBTYPE_3GP;
					break;
				case "3g2":
					theReturn = LoadedFile.SUBTYPE_3GP;
					break;
				case "mp4":
					theReturn = LoadedFile.SUBTYPE_MP4;
					break;
				case "avi":
					theReturn = LoadedFile.SUBTYPE_MP4;
					break;
				case "mov":
					theReturn = LoadedFile.SUBTYPE_MP4;
					break;
				case "mp3":
					theReturn = LoadedFile.SUBTYPE_MP3;
					break;
				case "txt":
					theReturn = LoadedFile.SUBTYPE_TXT;
					break;
				case "htm":
				case "html":
				case "php":
				case "asp":
				case "aspx":
				case "cfm":
				case "jsp":
					theReturn = LoadedFile.SUBTYPE_HTML;
					break;
			}
			return (theReturn);
		}
		
		/**
		 * Is the file type streamed?
		 * @param	ftype	The file type to check.
		 * @return	True if the type is streamed (video, audio), false otherwise (picture, flash, text).
		 */
		public static function isStream(ftype:String):Boolean {
			var theReturn:Boolean = false;
			if (ftype == LoadedFile.TYPE_AUDIO) theReturn = true;
			else if (ftype == LoadedFile.TYPE_VIDEO) theReturn = true;
			return (theReturn);
		}
		
		/**
		 * Is the file a picture or a flash movie?
		 * @param	ftype	The file type to check.
		 * @return	True if the type is streamed (video, audio), false otherwise (picture, flash, text).
		 */
		public static function isPicorFlash(url:String):Boolean {
			var theReturn:Boolean = false;
			if (LoadedFile.typeOf(url) == LoadedFile.TYPE_FLASH) theReturn = true;
			else if (LoadedFile.typeOf(url) == LoadedFile.TYPE_PICTURE) theReturn = true;
			return (theReturn);
		}
		
	}

}
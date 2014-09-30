package art.ciclope.managana {
	
	// FLASH PACKAGES

	// CICLOPE CLASSES
	import art.ciclope.managana.data.DISFileFormat;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * managanaOptions holds information about Managana player initialization options.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class ManaganaOptions {
		
		// VARIABLES
		
		private var _preferred:Array;		// preferred file formats for media
		private var _supported:Array;		// supported file formats
		
		// PUBLIC VARIABLES
		
		/**
		 * Language reference to load media.
		 */
		public var lang:String = "en_net";
		
		/**
		 * ManaganaOptions constructor.
		 */
		public function ManaganaOptions() {
			// preferred formats
			this._preferred = new Array();
			this._preferred[DISFileFormat.MEDIA_VIDEO] = "";
			this._preferred[DISFileFormat.MEDIA_AUDIO] = "";
			this._preferred[DISFileFormat.MEDIA_PICTURE] = "";
			this._preferred[DISFileFormat.MEDIA_OTHER] = "";
			// supported formats
			this._supported = new Array();
			this._supported[DISFileFormat.MEDIA_VIDEO] = "";
			this._supported[DISFileFormat.MEDIA_AUDIO] = "";
			this._supported[DISFileFormat.MEDIA_PICTURE] = "";
			this._supported[DISFileFormat.MEDIA_OTHER] = "";
		}
		
		// PUBLIC METHODS
		
		/**
		 * Set to standard file formats.
		 */
		public function setStandard():void {
			this.addSupported(DISFileFormat.MEDIA_PICTURE, DISFileFormat.PICTURE_JPEG);
			this.addSupported(DISFileFormat.MEDIA_PICTURE, DISFileFormat.PICTURE_PNG);
			this.addSupported(DISFileFormat.MEDIA_PICTURE, DISFileFormat.PICTURE_GIF);
			this.addSupported(DISFileFormat.MEDIA_PICTURE, DISFileFormat.OTHER_SWF);
			this.addSupported(DISFileFormat.MEDIA_AUDIO, DISFileFormat.AUDIO_MP3);
			this.addSupported(DISFileFormat.MEDIA_VIDEO, DISFileFormat.VIDEO_H264);
			this.addSupported(DISFileFormat.MEDIA_VIDEO, DISFileFormat.VIDEO_SPARK);
			this.addSupported(DISFileFormat.MEDIA_VIDEO, DISFileFormat.VIDEO_VP6);
			this.addSupported(DISFileFormat.MEDIA_VIDEO, DISFileFormat.VIDEO_ONVP);
			this.addPreferred(DISFileFormat.MEDIA_PICTURE, DISFileFormat.PICTURE_PNG);
			this.addPreferred(DISFileFormat.MEDIA_AUDIO, DISFileFormat.AUDIO_MP3);
			this.addPreferred(DISFileFormat.MEDIA_VIDEO, DISFileFormat.VIDEO_VP6);
		}
		
		/**
		 * Add a preferred file format.
		 * @param	type	the media type
		 * @param	format	the file format
		 * @see art.ciclope.managana.data.DISFileFormat
		 */
		public function addPreferred(type:String, format:String):void {
			this._preferred[type] = format;
		}
		
		/**
		 * Add a supported file format.
		 * @param	type	the media type
		 * @param	format	the file format
		 * @see art.ciclope.managana.data.DISFileFormat
		 */
		public function addSupported(type:String, format:String):void {
			this._supported[type] += format;
		}
		
		/**
		 * Get the preferred file format.
		 * @param	type	the media type
		 * @return	the preferred format (null if no preferred format is set)
		 */
		public function getPreferred(type:String):String {
			if (this._preferred[type] != "") {
				return (this._preferred[type]);
			} else {
				return (null);
			}
		}
		
		/**
		 * Check if a file format is supported.
		 * @param	type	the media type
		 * @param	format	the file format
		 * @return	true if the format is supported, false otherwise
		 */
		public function isSupported(type:String, format:String):Boolean {
			return (this._supported[type].search(format) >= 0);
		}
		
		/**
		 * Release memory used by this object.
		 */
		public function kill():void {
			this.lang = null;
			for (var istr:String in this._preferred) {
				this._preferred[istr] = null;
				delete (this._preferred[istr]);
			}
			this._preferred = null;
			for (istr in this._supported) {
				this._supported[istr] = null;
				delete (this._supported[istr]);
			}
			this._supported = null;
		}
		
	}

}
package art.ciclope.handle {
	
	// FLASH PACKAGES
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.*;
	
	// CICLOPE CLASSES
	import art.ciclope.util.LoadedFile;
	import art.ciclope.util.SubtitleObject;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * SubtitleManager handles srt files to provide subtitles to videos.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class SubtitleManager {
		
		// PUBLIC CONSTANTS
		
		/**
		 * Srt file acces status: file not found.
		 */
		public static const STATUS_NOTFOUND:String = "status_notfound";
		/**
		 * Srt file acces status: checking file.
		 */
		public static const STATUS_CHECKING:String = "status_checking";
		/**
		 * Srt file acces status: file downloading.
		 */
		public static const STATUS_DOWNLOADING:String = "status_downloading";
		/**
		 * Srt file acces status: file ready.
		 */
		public static const STATUS_READY:String = "status_ready";
		
		// VARIABLES
		
		/**
		 * Parsed data from current srt file.
		 */
		private var _subtitleData:Array;
		
		/**
		 * Current subtitle to check.
		 */
		private var _current:uint;
		
		/**
		 * Is this manager available to use?
		 */
		private var _ready:Boolean;
		
		/**
		 * Status of current srt file access.
		 */
		private var _status:String;
		
		/**
		 * Path to the subtitle srt file.
		 */
		private var _url:String;
		
		/**
		 * A loader for srt text files.
		 */
		private var _loader:URLLoader;
		
		/**
		 * SubtitleManager constructor.
		 */
		public function SubtitleManager() {
			// starting: this manager is not usable right now
			this._ready = false;
			this._url = "";
			this._status = SubtitleManager.STATUS_CHECKING;
			this._subtitleData = new Array();
			this._loader = new URLLoader();
			this._loader.addEventListener(Event.COMPLETE, completeHandler);
            this._loader.addEventListener(Event.OPEN, openHandler);
            this._loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            this._loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            this._loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Check a stream file for srt subtitles.
		 * @param	file	The url to the stream file.
		 */
		public function checkSrt(file:String):void {
			// is the provided path really a stream?
			if (LoadedFile.isStream(LoadedFile.typeOf(file))) {
				// getting path to srt file
				var fileChange:Array = file.split(".");
				fileChange[fileChange.length - 1] = "srt";
				this._url = fileChange.join(".");
				// accessing the file
				this._ready = false;
				this.clearData();
				this._status = SubtitleManager.STATUS_CHECKING;
				this._loader.load(new URLRequest(this._url));
			}
		}
		
		/**
		 * Check for a subtitle change at current time.
		 * @param	time	Time to check (miliseconds).
		 * @return	A string with the subtitle for current time, an empty string if the subtitle should be removed, null if nothing is found.
		 */
		public function checkTime(time:uint):String {
			var inSec:Number = time / 1000;
			while ((this._current < this._subtitleData.length) && (this._subtitleData[this._current].time <= inSec)) this._current++;
			if (this._current > 0) this._current--;
			if (this._current < this._subtitleData.length) {
				if (this._subtitleData[this._current].time <= inSec) {
					this._current++;
					return (this._subtitleData[this._current - 1].subtitle);
				}
				else {
					return (null);
				}
			} else {
				return (null);
			}
		}
		
		/**
		 * Restart subtitle checking to the beginning of the file.
		 */
		public function restart():void {
			this._current = 0;
		}
		
		/**
		 * Reset this manager clearing all information about downloaded subtitles.
		 */
		public function reset():void {
			this.clearData();
		}
		
		// READ-ONLY VALUES
		
		/**
		 * Is this manager ready to use?
		 */
		public function get ready():Boolean {
			return (this._ready);
		}
		
		/**
		 * Srt file access status. Check status constants for reference.
		 */
		public function get status():String {
			return (this._status);
		}
		
		// PRIVATE METHODS
		
		/**
		 * Clear information about current srt file.
		 */
		private function clearData():void {
			while (this._subtitleData.length > 0) this._subtitleData.shift();
			this._current = 0;
		}
		
		/**
		 * Process the srt data.
		 * Function created from the work of Jankees van Woezik posted at his blog http://blog.base42.nl/
		 * @param	data	srt content
		 */
		private function process(data:String):void {
			var lines: Array;
			var start: SubtitleObject;
			var end: SubtitleObject;
			var blocks: Array = data.split(/^[0-9]+$/gm);
			for each (var block : String in blocks) {
				start = new SubtitleObject();
				end = new SubtitleObject();
				lines = block.split('\n');
				for each (var line: String in lines) { 
					// all lines in a translation block
					if (trim(line) != "") {
						if (line.match("-->")) { 
							// timecodes line
							var timecodes: Array = line.split(/[ ]+-->[ ]+/gm);
							if (timecodes.length != 2) {
								// corrupted data: error at start or end times
							} else {
								start.time = stringToSeconds(timecodes[0]);
								end.time = stringToSeconds(timecodes[1]);
							}
						} else { 
							// translation line
							if (start.subtitle.length != 0) line = "\n" + trim(line);
							start.subtitle += line;
							end.subtitle = "";
						}
					}
				}
				this._subtitleData.push(start);
				this._subtitleData.push(end);
			}		
		}
		
		/**
		 * Clear text lines.
		 * Function created from the work of Jankees van Woezik posted at his blog http://blog.base42.nl/
		 * @param	p_string	The text line to be trimmed.
		 * @return	A cleared, trimmed text line.
		 */
		private function trim(p_string: String): String {
			if (p_string == null) return '';
			else return p_string.replace(/^\s+|\s+$/g, '');
		}
 
		/**
		 * Convert a string to seconds, with these formats supported: 00:03:00.1 / 03:00.1 / 180.1s / 3.2m / 3.2h / 00:01:53,800
		 * Function created from the work of Jankees van Woezik posted at his blog http://blog.base42.nl/
		 * Special thanks to Thijs Broerse of Media Monks!
		 */
		public static function stringToSeconds(string: String): Number {
			var arr : Array = string.split(':');
			var sec : Number = 0;
			if (string.substr(-1) == 's') {
				sec = Number(string.substr(0, string.length - 1));
			}else if (string.substr(-1) == 'm') {
				sec = Number(string.substr(0, string.length - 1)) * 60;
			}else if(string.substr(-1) == 'h') {
				sec = Number(string.substr(0, string.length - 1)) * 3600;
			}else if(arr.length > 1) {
				if(arr[2] && String(arr[2]).indexOf(',') != -1) arr[2] = String(arr[2]).replace(/\,/, ".");
				sec = Number(arr[arr.length - 1]);
				sec += Number(arr[arr.length - 2]) * 60;
				if(arr.length == 3) {
					sec += Number(arr[arr.length - 3]) * 3600;
				}
			} else {
				sec = Number(string);
			}
			return sec;
		}
		
		/**
		 * COMPLETE event handler.
		 */
		private function completeHandler(evt:Event):void {
			// srt file ready to parse
			this.process(this._loader.data);
			this._status = SubtitleManager.STATUS_READY;
			this._ready = true;
		}
		/**
		 * OPEN event handler.
		 */
		private function openHandler(evt:Event):void {
			// file exists and will be downloaded
			this._status = SubtitleManager.STATUS_DOWNLOADING;
		}
		/**
		 * PROGRESS event handler.
		 */
		private function progressHandler(evt:ProgressEvent):void {
			// do nothing
		}
		/**
		 * SECURITY ERROR event handler.
		 */
		private function securityErrorHandler(evt:SecurityErrorEvent):void {
			// file not available
			this._ready = false;
			this._status = SubtitleManager.STATUS_NOTFOUND;
		}
		/**
		 * HTTP STATUS event handler.
		 */
		private function httpStatusHandler(evt:HTTPStatusEvent):void {
			// do nothing
		}
		/**
		 * IO ERROR event handler.
		 */
		private function ioErrorHandler(evt:IOErrorEvent):void {
			// file not available
			this._ready = false;
			this._status = SubtitleManager.STATUS_NOTFOUND;
		}
		
	}

}
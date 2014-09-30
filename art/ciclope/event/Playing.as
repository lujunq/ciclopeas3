package art.ciclope.event {
	
	// FLASH PACKAGES
	import flash.display.Loader;
	import flash.events.Event;
	
	// CICLOPE CLASSES
	import art.ciclope.util.LoadedFile;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * Playing provides events for media file playing.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class Playing extends Event {
		
		// CONSTANT DEFINITIONS
		
		/**
		 * Media started playing.
		 */
		public static const MEDIA_PLAY:String = "MEDIA_PLAY";
		/**
		 * Media was paused.
		 */
		public static const MEDIA_PAUSE:String = "MEDIA_PAUSE";
		/**
		 * Media was stopped.
		 */
		public static const MEDIA_STOP:String = "MEDIA_STOP";
		/**
		 * Media play progress.
		 */
		public static const MEDIA_PROGRESS:String = "MEDIA_PROGRESS";
		/**
		 * Media cue point reached.
		 */
		public static const MEDIA_CUE:String = "MEDIA_CUE";
		/**
		 * Media end reached.
		 */
		public static const MEDIA_END:String = "MEDIA_END";
		/**
		 * Media play looped.
		 */
		public static const MEDIA_LOOP:String = "MEDIA_LOOP";
		/**
		 * Media seek applied.
		 */
		public static const MEDIA_SEEK:String = "MEDIA_SEEK";
		
		// VARIABLES
		
		private var _currentTime:Number;	// current play time
		private var _totalTime:Number;		// total play time
		private var _fileName:String;		// name of the file being loaded
		private var _fileType:String;		// the loaded file type
		private var _cueData:Object;		// cue point data
		private var _target:*;				// the player (stream) itself
		
		/**
		 * Playing constructor.
		 * @param	type	The type of the event.
		 * @param	target	Link to the media stream object.
		 * @param	fname	The name and path of the file being loaded.
		 * @param	ftype	The file type.
		 * @param	currTime	The current play time.
		 * @param	totalTime	The total media playback time.
		 * @param	cueData	Cue point data.
		 * @param	bubbles	Determines whether the Event object participates in the bubbling stage of the event flow.
		 * @param	cancelable	Determines whether the Event object can be canceled.
		 */
		public function Playing(type:String, target:* = null, fname:String = "", ftype:String = "TYPE_UNKNOWN", currTime:Number = 0, totalTime:Number = 0, cueData:Object = null, bubbles:Boolean = false, cancelable:Boolean = false) {
			// getting values
			this._fileName = fname;
			this._target = target;
			this._currentTime = currTime;
			this._totalTime = totalTime;
			this._cueData = cueData;
			this._fileType = ftype;
			// creating event
			super(type, bubbles, cancelable);
		}
		
		// READ-ONLY VALUES
		
		/**
		 * The current playback time.
		 */
		public function get currentTime():Number {
			return (this._currentTime);
		}
		/**
		 * The total playback time.
		 */
		public function get totalTime():Number {
			return (this._totalTime);
		}
		/**
		 * The name of the file being loaded (may include path).
		 */
		public function get fileName():String {
			return (this._fileName);
		}
		/**
		 * The loaded file type.
		 * @see	art.ciclope.util.LoadedFile
		 */
		public function get fileType():String {
			return (this._fileType);
		}
		/**
		 * The cue point data.
		 */
		public function get cueData():Object {
			return (this._cueData);
		}
		/**
		 * The media stream.
		 */
		public function get stream():* {
			return(this._target);
		}
	}
	
}
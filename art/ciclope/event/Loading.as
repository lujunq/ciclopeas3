package art.ciclope.event {
	
	// FLASH PACKAGES
	import flash.display.Loader;
	import flash.events.Event;
	
	// CICLOPE CLASSES
	import art.ciclope.util.LoadedFile;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * Loading provides events for loading/unloading data of any kind.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class Loading extends Event {
		
		// CONSTANT DEFINITIONS
		
		/**
		 * General load error.
		 */
		public static const ERROR:String = "ERROR";
		/**
		 * The data was loaded but it was not formated as expected.
		 */
		public static const ERROR_CONTENT:String = "ERROR_CONTENT";
		/**
		 * An IO error was raised while loading data.
		 */
		public static const ERROR_IO:String = "ERROR_IO";
		/**
		 * A SECUTIRY error was raised while loading data.
		 */
		public static const ERROR_SECURITY:String = "ERROR_SECURITY";
		/**
		 * The load process finished without errors and the data loaded is ready. If the file is a video or an audio, it can be streamed right now.
		 */
		public static const FINISHED:String = "FINISHED";
		/**
		 * A media stream was completely downloaded from a http server.
		 */
		public static const STREAM_COMPLETE:String = "STREAM_COMPLETE";
		/**
		 * Called when a HTTP status change occur.
		 */
		public static const HTTP_STATUS:String = "HTTP_STATUS";
		/**
		 * Insuficient data for request.
		 */
		public static const NODATA:String = "NODATA";
		/**
		 * Called every time the loading process has an update.
		 */
		public static const PROGRESS:String = "PROGRESS";
		/**
		 * The load process has just begun.
		 */
		public static const START:String = "START";
		/**
		 * The load process has finished.
		 */
		public static const END:String = "END";
		/**
		 * The data was just unload.
		 */
		public static const UNLOAD:String = "UNLOAD";
		/**
		 * A file download queue just reached its end.
		 */
		public static const QUEUE_END:String = "QUEUE_END";
		
		/**
		 * Download error status: download not available. Definitive error.
		 */
		public static const DOWNLOADERROR_NOTAVAILABLE:String = "DOWNLOADERROR_NOTAVAILABLE";
		/**
		 * Download error status: no error.
		 */
		public static const DOWNLOADERROR_OK:String = "DOWNLOADERROR_OK";
		/**
		 * Download error status: no download slot available right now.
		 */
		public static const DOWNLOADERROR_NOSLOT:String = "DOWNLOADERROR_NOSLOT";
		/**
		 * Download error status: download already done.
		 */
		public static const DOWNLOADERROR_ALREADY:String = "DOWNLOADERROR_ALREADY";
		
		/**
		 * Loaded media transition start.
		 */
		public static const TRANSITION_START:String = "TRANSITION_START";
		/**
		 * Loaded media transition end.
		 */
		public static const TRANSITION_END:String = "TRANSITION_END";
		/**
		 * The loaded content changed.
		 */
		public static const CONTENT_CHANGED:String = "CONTENT_CHANGED";
		
		
		
		// VARIABLES
		
		private var _bytesLoaded:Number;	// number of bytes loaded
		private var _bytesTotal:Number;		// total number of bytes
		private var _fileName:String;		// name of the file being loaded
		private var _fileType:String;		// the loaded file type
		private var _fileData:String;		// text content of the file
		private var _fileContent:Loader;	// binary loader data
		private var _target:*;				// the event target
		
		/**
		 * Loading constructor.
		 * @param	type	The type of the event.
		 * @param	target	The loader target.
		 * @param	fname	The name and path of the file being loaded or action reference.
		 * @param	ftype	The loaded file type.
		 * @param	bloaded	The current bytes loaded from source.
		 * @param	btotal	The total number of byths of the source.
		 * @param	fdata	Loaded data file (for text).
		 * @param	fcontent	The loader.
		 * @param	bubbles	Determines whether the Event object participates in the bubbling stage of the event flow.
		 * @param	cancelable	Determines whether the Event object can be canceled.
		 */
		public function Loading(type:String, target:* = null, fname:String = "", ftype:String = "TYPE_UNKNOWN", bloaded:Number = 0, btotal:Number = 0, fdata:String = "", fcontent:Loader = null, bubbles:Boolean = false, cancelable:Boolean = false) {
			// getting values
			this._fileName = fname;
			this._bytesLoaded = bloaded;
			this._bytesTotal = btotal;
			this._fileData = fdata;
			this._fileContent = fcontent;
			this._fileType = ftype;
			this._target = target;
			// creating event
			super(type, bubbles, cancelable);
		}
		
		// READ-ONLY VALUES
		
		/**
		 * The number of items or bytes loaded when the listener processes the event, if available.
		 */
		public function get bytesLoaded():Number {
			return (this._bytesLoaded);
		}
		/**
		 * The total number of items or bytes that will be loaded if the loading process succeeds, if available.
		 */
		public function get bytesTotal():Number {
			return (this._bytesTotal);
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
		 * The text data of the file loaded, if available.
		 */
		public function get fileData():String {
			return (this._fileData);
		}
		/**
		 * The binary loader data of the file loaded, if available.
		 */
		public function get fileContent():Loader {
			return (this._fileContent);
		}
		/**
		 * The loader itself.
		 */
		public function get loader():* {
			return(this._target);
		}
	}
	
}
package art.ciclope.managana.data {
	
	// CICLOPE CLASSES
	import art.ciclope.util.LoadedFile;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * DISElement provides methods for handling playlist elements.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class DISElement {
		
		// VARIABLE
		
		private var _type:String;				// element type
		private var _time:uint;					// element playback time
		private var _atend:String;				// element time end behavior
		private var _id:String;					// element identifier
		private var _order:uint;				// element order in sequence
		private var _action:Array;				// element action array
		private var _end:DISElementAction;		// an action for end
		private var _file:Array;				// element files
		private var _subtitle:Array;			// element subtitles
		private var _path:String;				// path to DIS folder
		
		/**
		 * DISElement constructor.
		 * @param	order	the element order on the playlist
		 * @param	id	the element id
		 * @param	type	the element type
		 * @param	atend	action to run at element time end
		 * @param	time	the element total time
		 * @param	path	the element file path (or text)
		 */
		public function DISElement(order:uint, id:String, type:String, atend:String, time:uint, path:String) {
			// get data
			this._order = order;
			this._time = time;
			this._id = id;
			this._path = path;
			this._atend = atend;
			this._end = new DISElementAction(0, "end", "");
			this._action = new Array();
			this._file = new Array();
			this._subtitle = new Array();
			// check type
			this._type = LoadedFile.TYPE_UNKNOWN;
			switch (type) {
				case "video":
					this._type = DISFileFormat.MEDIA_VIDEO;
					break;
				case "audio":
					this._type = DISFileFormat.MEDIA_AUDIO;
					break;
				case "picture":
					this._type = DISFileFormat.MEDIA_PICTURE;
					break;
				case "other":
					this._type = DISFileFormat.MEDIA_OTHER;
					break;
				case "text":
					this._type = DISFileFormat.MEDIA_TEXT;
					break;
				case "paragraph":
					this._type = DISFileFormat.MEDIA_PARAGRAPH;
					break;
			}
		}
		
		// READ-ONLY VALUES
		
		/**
		 * The element file type.
		 * @see	art.ciclope.util.LoadedFile
		 */
		public function get type():String {
			return (this._type);
		}
		
		/**
		 * Element identifier.
		 */
		public function get id():String {
			return (this._id);
		}
		
		/**
		 * Element end of time behavior.
		 */
		public function get atend():String {
			return (this._atend);
		}
		
		/**
		 * Element playback time (for non-stream media).
		 */
		public function get time():uint {
			return (this._time);
		}
		
		/**
		 * Element pomanaganan on playlist sequence
		 */
		public function get order():uint {
			return (this._order);
		}
		
		/**
		 * Action to take when element time finishes.
		 */
		public function get endAction():DISElementAction {
			return (this._end);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Get file information.
		 * @param	lang	chosen language
		 * @param	preferred	preferred file format (leave null for any format)
		 * @return	file information (if no file in preferred format or language is found, any available will be returned)
		 */
		public function getFile(lang:String = null, preferred:String = null):DISElementFile {
			var found:DISElementFile;
			var istr:String;
			if (this._file[preferred] != null) {
				if (lang != null) {
					if (this._file[preferred][lang] != null) {
						found = this._file[preferred][lang];
					} else {
						for (istr in this._file[preferred]) {
							found = this._file[preferred][istr];
						}
					}
				}
			}
			if (found == null) {
				for (istr in this._file) {
					if (lang != null) {
						if (this._file[istr][lang] != null) {
							found = this._file[istr][lang];
						} else {
							for (var istr2:String in this._file[istr]) {
								found = this._file[istr][istr2];
							}
						}
					}
				}
			}
			return(found);
		}
		
		/**
		 * Get the action associated with a given time.
		 * @param	time	the time to check
		 * @return	action information or null if no action is found on time
		 */
		public function getAction(time:uint):DISElementAction {
			return (this._action["t" + time]);
		}
		
		/**
		 * Get subtitles associated with the element.
		 * @param	lang	the language to get subtitles
		 * @return	subtitle information or null of no subtitle on desired language is found
		 */
		public function getSubtitles(lang:String):DISElementFile {
			return (this._subtitle[lang]);
		}
		
		/**
		 * Set element data (files, actions and subtitles).
		 * @param	to	element data xml
		 */
		public function setData(to:XML):void {
			var index:uint;
			for (index = 0; index < to.child("action").length(); index++) {
				if (to.action[index].hasOwnProperty('@time') && to.action[index].hasOwnProperty('@type')) {
					if (String(to.action[index].@type) == "end") {
						this._end.kill();
						this._end = new DISElementAction(uint(to.action[index].@time), String(to.action[index].@type), String(to.action[index]));
					} else {
						this._action["t" + String(to.action[index].@time)] = new DISElementAction(uint(to.action[index].@time), String(to.action[index].@type), String(to.action[index]));
					}
				}
			}
			for (index = 0; index < to.child("file").length(); index++) {
				if (to.file[index].hasOwnProperty('@format') && to.file[index].hasOwnProperty('@lang') && to.file[index].hasOwnProperty('@absolute')) {
					if (this._file[String(to.file[index].@format)] == null) this._file[String(to.file[index].@format)] = new Array();
					this._file[String(to.file[index].@format)][String(to.file[index].@lang)] = new DISElementFile(String(to.file[index].@format), String(to.file[index].@lang), Boolean(uint(to.file[index].@absolute)), String(to.file[index]), this._path, this._type, String(to.file[index].@feed), String(to.file[index].@feedType), String(to.file[index].@field));
				}
			}
			for (index = 0; index < to.child("subtitle").length(); index++) {
				if (to.subtitle[index].hasOwnProperty('@lang') && to.subtitle[index].hasOwnProperty('@absolute')) {
					this._subtitle[String(to.subtitle[index].@lang)] = new DISElementFile("subtitle", String(to.subtitle[index].@lang), Boolean(uint(to.subtitle[index].@absolute)), String(to.subtitle[index]), this._path, this._type);
				}
			}
		}
		
		/**
		 * Relase memory used by this object.
		 */
		public function kill():void {
			this._type = null;
			this._id = null;
			this._path = null;
			this._atend = null;
			var istr:String;
			for (istr in this._action) {
				this._action[istr].kill();
				delete(this._action[istr]);
			}
			this._action = null;
			this._end.kill();
			this._end = null;
			for (istr in this._file) {
				for (var istr2:String in this._file[istr]) {
					this._file[istr][istr2].kill();
					delete(this._file[istr][istr2]);
				}
				delete(this._file[istr]);
			}
			this._file = null;
			for (istr in this._subtitle) {
				this._subtitle[istr].kill();
				delete(this._subtitle[istr]);
			}
			this._subtitle = null;
		}
		
	}

}
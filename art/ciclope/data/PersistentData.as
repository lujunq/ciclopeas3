package art.ciclope.data {
	
	// FLASH PACKAGES
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.System;
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class PersistentData extends EventDispatcher {
		
		// CONSTANTS
		
		/**
		 * Initializing data state.
		 */
		public static const INITIALIZING:String = 'INITIALIZING';
		
		/**
		 * No data folder available state.
		 */
		public static const NOFOLDER:String = 'NOFOLDER';
		
		/**
		 * Opening main data file state.
		 */
		public static const OPENINGFILE:String = 'OPENINGFILE';
		
		/**
		 * Ready state.
		 */
		public static const READY:String = 'READY';
		
		// PRIVATE VARIABLES
		
		private var _ready:Boolean = false;				// data available?
		private var _folder:String = 'ciclopedata';		// the storage folder name
		private var _fileName:String = 'appdata';		// the storage file name
		private var _path:File;							// reference to storage folder
		private var _state:String;						// current data object state
		private var _dataFile:File;						// reference to data file
		private var _data:XML;							// application data
		private var _values:Array;						// stored values
		
		/**
		 * PersistentData constructor.
		 * @param	folder	the folder to save the associated xml file (inder system documents folder)
		 * @param	filename	the xml file name to use
		 */
		public function PersistentData(folder:String = 'ciclopedata', filename:String = 'appdata', useDocs:Boolean = true) {
			super();
			// prepare folder
			this._state = PersistentData.INITIALIZING;
			if (folder) this._folder = folder;
			if (filename) this._fileName = filename;
			if (useDocs) {
				this._path = File.documentsDirectory.resolvePath(this._folder);
			} else {
				this._path = File.applicationStorageDirectory.resolvePath(this._folder);
			}
			if (!this._path.isDirectory) {
				try {
					this._path.createDirectory();
					this._state = PersistentData.OPENINGFILE;
				} catch (e:Error) {
					this._state = PersistentData.NOFOLDER;
				}
			} else {
				this._state = PersistentData.OPENINGFILE;
			}
			// loading data file
			if (this._state == PersistentData.OPENINGFILE) {
				this._values = new Array();
				if (useDocs) {
					this._dataFile = File.documentsDirectory.resolvePath(this._folder + '/' + this._fileName + '.xml');
				} else {
					this._dataFile = File.applicationStorageDirectory.resolvePath(this._folder + '/' + this._fileName + '.xml');
				}
				if (!this._dataFile.exists) {
					// create original file
					this._values['datafolder'] = this._folder;
					this._values['dataurl'] = this._dataFile.url;
					this._values['datapath'] = this._dataFile.nativePath;
					this._values['datafile'] = this._fileName;
					this.createXML();
					this.saveXML();
					this._state = PersistentData.READY;
				} else {
					this.loadXML();
					this._state = PersistentData.READY;
				}
			}
		}
		
		// READ-ONLY VALUES
		
		/**
		 * Current data object state.
		 */
		public function get state():String {
			return (this._state);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Save current variable values to the associated XML file.
		 * @return	true if the values were correctly saved to XML file on disk
		 */
		public function save():Boolean {
			if (this._state == PersistentData.READY) {
				this.createXML();
				this.saveXML();
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Load variable values from the associated XML file.
		 * @return	true if the variable values can be loaded from XML
		 */
		public function load():Boolean {
			if (this._state == PersistentData.READY) {
				this.loadXML();
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Is a variable set?
		 * @param	name	the variable name to check
		 * @return	true if the variable is currently set
		 */
		public function isSet(name:String):Boolean {
			return (this._values[name] != null);
		}
		
		/**
		 * Get the current value of a variable.
		 * @param	name	the variable name
		 * @return	the value if the variable is set, null otherwise
		 */
		public function getValue(name:String):String {
			if (this.isSet(name)) {
				return (this._values[name] as String);
			} else {
				return (null);
			}
		}
		
		/**
		 * Set a variable value.
		 * @param	name	the variable name
		 * @param	value	the variable value
		 * @param	save	save XML file after set?
		 * @return	true if the requested name is suitable for a variable and value is set
		 */
		public function setValue(name:String, value:String, save:Boolean = false):Boolean {
			if (this.validName(name)) {
				this._values[name] = value;
				return (this.save());
			} else {
				return (false);
			}
		}
		
		/**
		 * Remove a variable.
		 * @param	name	the avriable name to remove
		 */
		public function clearValue(name:String):void {
			if (this._values[name] != null) delete(this._values[name]);
		}
		
		// PRIVATE METHODS
		
		/**
		 * Create a XML resource from current data.
		 */
		private function createXML():void {
			var xmlString:String = '<data>';
			for (var index:String in this._values) {
				xmlString += '<' + index + '>' + this._values[index] + '</' + index + '>';
			}
			xmlString += '</data>';
			if (this._data != null) System.disposeXML(this._data);
			this._data = new XML(xmlString);
		}
		
		/**
		 * Save the current values to a XML file.
		 */
		private function saveXML():void {
			if (this._data != null) {
				var fStream:FileStream = new FileStream();
				fStream.open(this._dataFile, FileMode.WRITE);
				fStream.writeUTFBytes('<?xml version="1.0" encoding="utf-8"?>' + this._data.toXMLString());
				fStream.close();
			}
		}
		
		/**
		 * Load the data XML file.
		 */
		private function loadXML():void {
			// load xml files
			var fStream:FileStream = new FileStream(); 
			fStream.open(this._dataFile, FileMode.READ);
			if (this._data != null) System.disposeXML(this._data);
			this._data = XML(fStream.readUTFBytes(fStream.bytesAvailable)); 
			fStream.close();
			// read xml values
			for (var index:String in this._values) delete(this._values[index]);
			var xmlNodes:XMLList =  this._data.children();
			for each (var item:XML in xmlNodes) {
				this._values[String(item.name())] = String(item);
			}
			// set object own values
			this._values['datafolder'] = this._folder;
			this._values['dataurl'] = this._dataFile.url;
			this._values['datapath'] = this._dataFile.nativePath;
			this._values['datafile'] = this._fileName;
		}
		
		/**
		 * Is the given name valid for a variable?
		 * @param	name	the name to test
		 * @return	true if the name is suitable to be given to a variable
		 */
		private function validName(name:String):Boolean {
			var ret:Boolean = true;
			for (var i:uint = 0; i < name.length; i++) {
				if (name.substr(i, 1) != escape(name.substr(i, 1))) ret = false;
			}
			return (ret);
		}
		
	}

}
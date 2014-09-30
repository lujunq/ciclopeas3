package art.ciclope.managana.data {
	
	// FLASH PACKAGES
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.System;
	
	// CICLOPE CLASSES
	import art.ciclope.staticfunctions.StringFunctions;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * ConfigData loads the managana.xml configuration data for system initialize.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class ConfigData extends EventDispatcher	{
		
		// VARIABLES
		
		private var _config:Array;				// system configuration
		private var _onRemovable:Boolean;		// running from removable device (flash drive?)
		
		/**
		 * ConfigData constructor: start loading managana.xml automattically.
		 */
		public function ConfigData() {
			this._config = new Array();
			this._onRemovable = false;
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			loader.load(new URLRequest("managanaconfig.xml"));
		}
		
		// READ-ONLY VALUES
		
		/**
		 * The local storage folder.
		 */
		public function get localStorage():String {
			var ret:String = this.getConfig("server");
			if (ret == "") {
				ret = "ManaganaPlayer";
			} else {
				ret = ret.replace("http://", "");
				ret = ret.replace("https://", "");
				ret = ret.replace(/\//gi, ".");
				if (ret.substr( -1) == ".") ret = ret.substr(0, (ret.length - 1));
				ret = "ManaganaPlayer/" + ret;
			}
			return (ret);
		}
		
		/**
		 * Running from a removable (flash) drive?
		 */
		public function get onRemovable():Boolean {
			return (this._onRemovable);
		}
		
		/**
		 * Force removable drivre write off.
		 */
		public function setNoRemovable():void {
			this._onRemovable = false;
		}
		
		// PUBLIC METHODS
		
		/**
		 * Get a configuration value.
		 * @param	name	the config name
		 * @return	the value or empty string if not found
		 */
		public function getConfig(name:String):String {
			if (this._config[name] != null) return (this._config[name]);
				else return ("");
		}
		
		/**
		 * Force a configuration value.
		 * @param	name	the configuration name
		 * @param	value	the new configuration value
		 */
		public function setConfig(name:String, value:String):void {
			this._config[name] = value;
		}
		
		/**
		 * Is a config value available?
		 * @param	name	the config value name
		 * @return	true if the config value is available, false otherwise
		 */
		public function isConfig(name:String):Boolean {
			return (this._config[name] != null);
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			if (this._config != null) {
				for (var index:String in this._config) delete (this._config[index]);
			}
		}
		
		// PRIVATE METHODS
		
		/**
		 * Config file load error.
		 */
		private function onError(evt:Event):void {
			var loader:URLLoader = evt.target as URLLoader;
			loader.removeEventListener(Event.COMPLETE, onComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			// warn listeners (for system halt)
			this.dispatchEvent(new Event(Event.CANCEL));
		}
		
		/**
		 * Config file loaded successfully.
		 */
		private function onComplete(evt:Event):void {
			var loader:URLLoader = evt.target as URLLoader;
			loader.removeEventListener(Event.COMPLETE, onComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			// get config
			try {
				var data:XML = new XML(loader.data);
				for (var index:uint = 0; index < data.child('config').length(); index++) {
					this._config[String(data.config[index].name)] = String(data.config[index].value);
					if (String(data.config[index].name) == "server") {
						this._config[String(data.config[index].name)] = StringFunctions.slashURL(String(data.config[index].value));
					} else if (String(data.config[index].name) == "flashdrive") {
						this._onRemovable = (String(data.config[index].value) == "true");
					}
				}
				System.disposeXML(data);
				// warn listeners about data load
				this.dispatchEvent(new Event(Event.COMPLETE));
			} catch (e:Error) {
				// config file error = system halt
				this.dispatchEvent(new Event(Event.CANCEL));
			}
			// warn listeners (for system halt)
			this.dispatchEvent(new Event(Event.CANCEL));
		}
	}

}
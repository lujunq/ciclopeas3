package art.ciclope.sitio.data {
	
	// FLASH PACKAGES
	import flash.system.System;
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public final class PluginData {
		
		// VARIABLES
		
		private var _name:String;		// the plugin name
		private var _id:String;			// the plugin identifier
		private var _config:XML;		// the plugin configuration
		
		/**
		 * Create a new PluginData object.
		 * @param	name	the plugin name
		 * @param	id	the plugin identifier
		 * @param	configstring	a xml-formatted string for plugin configuration
		 */
		public function PluginData(name:String, id:String, configstring:String) {
			this._name = name;
			this._id = id;
			try {
				this._config = new XML(configstring);
			} catch (e:Error) {
				this._config = new XML();
			}
		}
		
		/**
		 * The plugin name.
		 */
		public function get name():String {
			return (this._name);
		}
		
		/**
		 * The plugin idenntifier.
		 */
		public function get id():String {
			return (this._id);
		}
		
		/**
		 * The plugin configuration.
		 */
		public function get config():XML {
			return (this._config);
		}
		
		/**
		 * Release memory used by object.
		 */
		public final function kill():void {
			this._name = null;
			this._id = null;
			System.disposeXML(this._config);
		}
		
	}

}
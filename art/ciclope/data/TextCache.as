package art.ciclope.data {
	
	// FLASH PACKAGES
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	// CICLOPE CLASSES
	import art.ciclope.event.Loading;
	
	// EVENTS
	
	/**
     * Data download finished.
     */
    [Event( name = "FINISHED", type = "art.ciclope.event.Loading" )]
	/**
     * Error while downloading data.
     */
    [Event( name = "ERROR", type = "art.ciclope.event.Loading" )]
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * TextCache provides text data automated download and caching.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class TextCache extends EventDispatcher {
		
		// VARIABLES
		
		private var _ready:Boolean;		// is cached data ready?
		private var _data:String;		// the cached text data
		private var _loader:URLLoader;	// loader for text data
		private var _name:String;		// text load name
		
		/**
		 * TextCache constructor.
		 * @param	url	the url of the text file or generator scritp to load and cache
		 * @param	variables	url-encoded variables to send to text url
		 * @param	method	access method for file url
		 * @param	name	a name for the object
		 * @param	text	the text to be cached (instead of accessing an url)
		 */
		public function TextCache(url:String = "", variables:String = "", method:String = "post", name:String = "", text:String = "") {
			this._name = name;
			if (url != null) if (url != "") {
				this._ready = false;
				this._loader = new URLLoader();
				this._loader.addEventListener(Event.COMPLETE, onComplete);
				this._loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
				this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
				var request:URLRequest = new URLRequest(url);
				if (variables != null) if (variables != "") {
					var data:URLVariables = new URLVariables(variables);
					request.data = data;
					request.method = method;
				}
				this._loader.load(request);
			} else {
				// add provided text
				this._data = text;
				this._ready = true;
				this.dispatchEvent(new Loading(Loading.FINISHED, this));
			}
		}
		
		// READ-ONLY VALUES
		
		/**
		 * Is the text cache ready?
		 */
		public function get ready():Boolean {
			return (this._ready);
		}
		
		/**
		 * Cache file name.
		 */
		public function get name():String {
			return (this._name);
		}
		
		/**
		 * Plain text cache data.
		 */
		public function get data():String {
			if (this._ready) return (this._data);
				else return("");
		}
		
		/**
		 * Cache data as an xml object (null if the text could not be parsed as a xml).
		 */
		public function get xmldata():String {
			var ret:XML;
			if (this._ready) {
				try {
					ret = new XML(this._data);
				} catch (e:Error) { }
			}
			return(ret);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			this._name = null;
			this._data = null;
			if (this._loader != null) if (this._loader.hasEventListener(Event.COMPLETE)) {
				this._loader.removeEventListener(Event.COMPLETE, onComplete);
				this._loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
				this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			}
			this._loader = null;
		}
		
		// PRIVATE METHODS
		
		/**
		 * Data download is complete.
		 */
		private function onComplete(evt:Event):void {
			this._data = new String(this._loader.data);
			this._ready = true;
			this._loader.removeEventListener(Event.COMPLETE, onComplete);
			this._loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			this._loader = null;
			this.dispatchEvent(new Loading(Loading.FINISHED, this));
		}
		
		/**
		 * Error while downloading data.
		 */
		private function onError(evt:Event):void {
			this._loader.removeEventListener(Event.COMPLETE, onComplete);
			this._loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			this._loader = null;
			this.dispatchEvent(new Loading(Loading.ERROR, this));
		}
	}

}
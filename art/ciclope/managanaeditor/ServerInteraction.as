package art.ciclope.managanaeditor {
	
	// FLASH PACKAGES
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.events.EventDispatcher;
	import flash.system.System;
		
	// CICLOPE CLASSES
	import art.ciclope.managanaeditor.EditorOptions;
	
	// EVENTS
	
	/**
     * The server agent key sent did not match the expected one from the server.
     */
    [Event( name = "SERVER_AGENT", type = "art.ciclope.managanaeditor.ServerEvent" )]
    /**
     * There was an error on server communication.
     */
    [Event( name = "SERVER_ERROR", type = "art.ciclope.managanaeditor.ServerEvent" )]
    /**
     * The server communication was completed successfully.
     */
    [Event( name = "SERVER_OK", type = "art.ciclope.managanaeditor.ServerEvent" )]
    /**
     * The server response did not match the expected format.
     */
    [Event( name = "SERVER_CONTENT", type = "art.ciclope.managanaeditor.ServerEvent" )]
    /**
     * The server was not found on provided url.
     */
    [Event( name = "SERVER_NOTFOUND", type = "art.ciclope.managanaeditor.ServerEvent" )]
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * ServerInteraction provides standarized communitcation between Managana editor and server.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class ServerInteraction extends EventDispatcher {
		
		// STATIC STATEMENTS
		
		/**
		 * Get full url for a server script.
		 * @param	name	script name
		 * @return	the full script url
		 */
		public static function callScript(name:String):String {
			return(EditorOptions.path + EditorOptions.prefix + name + EditorOptions.extension);
		}
		
		// VARIABLES
		
		private var _loader:URLLoader;		// a loader for XML data
		private var _error:String;			// last call error
		private var _errorID:String;		// last error ID
		
		// PUBLIC VARIABLES
		
		/**
		 * XML data with last call correct return.
		 */
		public var data:XML;
		
		/**
		 * ServerInteraction constructor.
		 */
		public function ServerInteraction() {
			// prepare loader
			this._loader = new URLLoader();
			this._loader.addEventListener(Event.COMPLETE, onComplete);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			// prepare data
			this.data = new XML();
		}
		
		// READ-ONLY VALUES
		
		/**
		 * Last call error.
		 */
		public function get error():String {
			return (this._error);
		}
		
		/**
		 * Last call error ID.
		 */
		public function get errorID():String {
			return (this._errorID);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Force the no server found error.
		 */
		public function setNoServerError():void {
			this._error = ServerEvent.SERVER_NOTFOUND;
		}
		
		/**
		 * Call a server script.
		 * @param	script	the servere script to call
		 * @param	variables	url-formatted name/value pairs to add to the server request
		 */
		public function call(script:String, variables:String = null):void {
			var request:URLRequest = new URLRequest(EditorOptions.path + EditorOptions.prefix + script + EditorOptions.extension);
			if (variables != null) request.data = new URLVariables(variables);
			request.method = EditorOptions.method;
			this._loader.load(request);
		}
		
		/**
		 * Release memory used by this object.
		 */
		public function kill():void {
			this._loader.removeEventListener(Event.COMPLETE, onComplete);
			this._loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			System.disposeXML(this.data);
			this._loader = null;
			this._error = null;
			this._errorID = null;
			this.data = null;
		}
		
		/**
		 * Data is correctly loaded from server.
		 */
		private function onComplete(evt:Event):void {
			try {
				System.disposeXML(this.data);
				this.data = new XML(this._loader.data);
				if (this.data.child("error").length() > 0) { // there is an error child on XML
					if (this.data.agent != EditorOptions.agent) { // check for agent
						this._error = ServerEvent.SERVER_AGENT;
						this.dispatchEvent(new ServerEvent(ServerEvent.SERVER_AGENT, this));
					} else if (this.data.error[0].@id != "0") { // response with an error
						this._error = ServerEvent.SERVER_ERROR;
						this._errorID = String(this.data.error[0].@id);
						this.dispatchEvent(new ServerEvent(ServerEvent.SERVER_ERROR, this));
					} else { // ressponse ok
						this._error = ServerEvent.SERVER_OK;
						this._errorID = "0";
						this.dispatchEvent(new ServerEvent(ServerEvent.SERVER_OK, this));
					}
				} else { // no "error" child on xml
					this._error = ServerEvent.SERVER_CONTENT;
					this.dispatchEvent(new ServerEvent(ServerEvent.SERVER_CONTENT, this));
				}
			} catch (e:Error) {
				
				// trace ("data error: " + this._loader.data);
				
				// data is not xml-formatted
				this.data = new XML();
				this._error = ServerEvent.SERVER_AGENT;
				this.dispatchEvent(new ServerEvent(ServerEvent.SERVER_CONTENT, this));
			}
		}
		
		/**
		 * Error while locating the requested server script.
		 */
		private function onError(evt:Event):void {
			this._error = ServerEvent.SERVER_NOTFOUND;
			this.dispatchEvent(new ServerEvent(ServerEvent.SERVER_NOTFOUND, this));
		}
		
	}

}
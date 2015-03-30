package art.ciclope.handle {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class WEBROOTManager extends EventDispatcher {
		
		private var _webroot:File;
		private var _ready:Boolean;
		
		public function WEBROOTManager(rootfolder:String = 'webroot', usecache:Boolean = true) {
			super();
			this._ready = false;
			var source:File = File.applicationDirectory.resolvePath(rootfolder);
			if (usecache) {
				this._webroot = File.cacheDirectory.resolvePath(rootfolder);
			} else {
				this._webroot = File.documentsDirectory.resolvePath(rootfolder);
			}
			source.addEventListener(Event.COMPLETE, onFileComplete);
			source.copyToAsync(this._webroot, true);
		}
		
		// READ-ONLY VALUES
		
		public function get webroot():File {
			return (this._webroot);
		}
		
		public function get ready():Boolean {
			return (this._ready);
		}
		
		// PUBLIC METHODS
		
		public function writeFile(path:String, content:String):Boolean {
			if (this._ready) {
				var file:File = new File(this._webroot.nativePath + File.separator + path);
				var fstream:FileStream = new FileStream();
				fstream.open(file, FileMode.WRITE);
				fstream.writeUTFBytes(content);
				fstream.close();
				return (true);
			} else {
				return (false);
			}
		}
		
		// PRIVATE METHODS
		
		private function onFileComplete(evt:Event):void {
			this._ready = true;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}

}
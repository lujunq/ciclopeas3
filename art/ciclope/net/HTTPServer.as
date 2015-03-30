package art.ciclope.net {
	
	import flash.events.EventDispatcher;
	import flash.net.ServerSocket;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.Socket;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class HTTPServer extends EventDispatcher {
		
		private var _port:uint;							// the port to listen to
		private var _serverSocket:ServerSocket;			// the tcp server
		private var _mimeTypes:Object;					// file mime types
		private var _ready:Boolean;						// is the server ready?
		private var _webroot:File;						// a link to the webroot folder
		
		public function HTTPServer() {
			super();
			// get values
			this._ready = false;
			// prepare mime types
			this._mimeTypes = new Object();
			this._mimeTypes['.css'] = 'text/css';
			this._mimeTypes['.gif'] = 'image/gif';
			this._mimeTypes['.html'] = 'text/html';
			this._mimeTypes['.htm'] = 'text/html';
			this._mimeTypes['.ico'] = 'image/x-icon';
			this._mimeTypes['.jpg'] = 'image/jpeg';
			this._mimeTypes['.js'] = 'application/x-javascript';
			this._mimeTypes['.png'] = 'image/png';
			this._mimeTypes['.m4a'] = 'audio/mp4';
			this._mimeTypes['.ogg'] = 'audio/ogg';
			this._mimeTypes['.mp3'] = 'audio/mp3';
			this._mimeTypes['.mp4'] = 'video/mp4';
			this._mimeTypes['.ogv'] = 'video/ogv';
			this._mimeTypes['.webm'] = 'video/webm';
		}
		
		public function get ready():Boolean {
			return (this._ready);
		}
		
		public function get port():uint {
			return (this._port);
		}
		
		public function serverAddress(me:String):String {
			if (this._ready) {
				return ('http://' + me + ':' + this._port);
			} else {
				return ('');
			}
		}
		
		public function start(port:uint, webroot:File):void {
			this._webroot = webroot;
			this._port = port;
			try {
				this._serverSocket = new ServerSocket();
				this._serverSocket.addEventListener(Event.CONNECT, onSocketConnect);
				this._serverSocket.bind(this._port);
				this._serverSocket.listen();
				this._ready = true;
			} catch (e:Error) {
				this._ready = false;
			}
		}
		
		private function onSocketConnect(evt:ServerSocketConnectEvent):void {
			var socket:Socket = evt.socket;
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
		}
		
		private function onSocketData(evt:ProgressEvent):void {
			try {
				var socket:Socket = evt.target as Socket;
				var bytes:ByteArray = new ByteArray();
				socket.readBytes(bytes);
				var request:String = '' + bytes;
				var filePath:String = request.substring(4, request.indexOf('HTTP/') - 1);
				var file:File = new File(this._webroot.nativePath + File.separator + filePath);
				if (file.exists && !file.isDirectory) {
					var stream:FileStream = new FileStream();
					stream.open(file, FileMode.READ);
					var content:ByteArray = new ByteArray();
					stream.readBytes(content);
					stream.close();
					socket.writeUTFBytes("HTTP/1.1 200 OK\n");
					socket.writeUTFBytes("Content-Type: " + getMimeType(filePath) + "\n\n");
					socket.writeBytes(content);
				} else {
					socket.writeUTFBytes("HTTP/1.1 404 Not Found\n");
					socket.writeUTFBytes("Content-Type: text/html\n\n");
					socket.writeUTFBytes("<html><body><h2>Page Not Found</h2></body></html>");
				}
				socket.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
				socket.flush();
				socket.close();
			} catch (e:Error) { }
		}
		
		private function getMimeType(path:String):String {
			var mimeType:String;
			var index:int = path.lastIndexOf('.');
			if (index > -1) {
				mimeType = this._mimeTypes[path.substring(index)];
			}
			return (mimeType == null ? 'text/html' : mimeType);
		}
		
	}

}
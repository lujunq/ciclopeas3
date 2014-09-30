package art.ciclope.managana.data {
	
	// FLASH PACKAGES
	import flash.events.EventDispatcher;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.events.NetStatusEvent;
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class ConnectedRemote extends EventDispatcher {
		
		// VARIABLES
		
		private var _connection:NetConnection;		// remote connection
		private var _stream:NetStream;				// input stream
		
		// PUBLIC VARIABLES
		
		/**
		 * The remote peer id.
		 */
		public var peer:String = "";
		
		public function ConnectedRemote(id:String, connection:NetConnection, group:String, client:Object) {
			// get remote info
			this.peer = id;
			this._connection = connection;
			this._connection.addEventListener(NetStatusEvent.NET_STATUS, onNetstatus);
			this._stream = new NetStream(connection, id);
			this._stream.addEventListener(NetStatusEvent.NET_STATUS, onNetstatus);
			this._stream.client = client;
			this._stream.play(group);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			this._stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetstatus);
			this._connection.removeEventListener(NetStatusEvent.NET_STATUS, onNetstatus);
			this._stream.close();
			this._stream = null;
			this._connection = null;
			this.peer = null;
		}
		
		// PRIVATE METHODS
		
		/**
		 * Received status from network connection.
		 */
		private function onNetstatus(evt:NetStatusEvent):void {
			switch (evt.info.code) {
				case "NetStream.Play.Start":
					// send welcome message to remote
					//this._stream.client.sendToRemote("onPlayerData", "welcome|" + this.peer);
					this._stream.client.sendWelcome(this.peer);
					break;
				case "NetStream.Connect.Closed":
					// close remote connection
					this._stream.client.closeRemote(this.peer);
					break;
			}
		}
		
		/**
		 * For netconnection bug.
		 */
		public function onPeerConnect(callerns:NetStream):Boolean {
			trace ("onpeerconnect");
			callerns.client = this;
			return (true);
		}
		public function startTransmit(arg1:*= null, arg2:*= null):Boolean {
			trace ("call startransmit", arg1, arg2);
			return(true);
		}
		public function stopTransmit(arg1:*= null, arg2:*= null):Boolean {
			trace ("call stoptransmit", arg1, arg2);
			return(true);
		}
		
	}

}
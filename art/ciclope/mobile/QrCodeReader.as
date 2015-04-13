package art.ciclope.mobile {
	
	// FLASH PACKAGES
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaParser;
	import art.ciclope.event.Message;
	
	// ZBAR QRCODE READ CLASSES
	import com.davikingcode.nativeExtensions.zbar.ZBar;
	import com.davikingcode.nativeExtensions.zbar.ZBarEvent;
	
	// EVENTS
	
	/**
     * A valid progress code was found at a qrcode.
     */
    [Event( name = "SENDPROGRESSCODE", type = "art.ciclope.event.Message" )]
	
	/**
     * The qrcode reading interface was just closed.
     */
    [Event( name = "CLOSE", type = "flash.events.Event" )]
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * QrCodeReader uses ZBAR to scan and parse qrcodes looking for Managana progress code buit into the read string.
	 * ZBar-ANE native extension (LGPL-licensed): https://github.com/DaVikingCode/ZBar-ANE
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class QrCodeReader extends Sprite {
		
		// CONSTANTS
		
		private const INTERVAL:uint = 2000;		// data read interval (milliseconds)
		
		// VARIABLES
		
		private var _bg:Shape;					// dark background
		private var _video:Video;				// display video
		private var _camera:Camera;				// input camera
		private var _data:BitmapData;			// bitmap data read from camera
		private var _interval:int;				// bitmap fetch interval
		private var _zbar:ZBar;					// qrcode parser
		private var _parser:ManaganaParser;		// managana progress code parser
		private var _automatic:Boolean;			// automatically run any progress code found?
		private var _closebt:Sprite;			// the close button
		
		/**
		 * QRCodeReader constructor.
		 * @param	w	screen width
		 * @param	h	screen height
		 */
		public function QrCodeReader(w:Number, h:Number, parser:ManaganaParser, closebt:Sprite, automatic:Boolean = true) {
			super();
			// create background
			this._bg = new Shape();
			this._bg.graphics.beginFill(0x000000);
			this._bg.graphics.drawRect(0, 0, 100, 100);
			this._bg.graphics.endFill();
			this.addChild(this._bg);
			// create video
			this._video = new Video(960, 540);
			this._video.smoothing = true;
			this.addChild(this._video);
			// prepare data
			this._interval = -1;
			this._data = new BitmapData(this._video.width, this._video.height);
			// prepare parser
			this._zbar = new ZBar();
			// close button
			this._closebt = closebt;
			this.addChild(this._closebt);
			// place images
			this.resize(w, h);
			// set progress code parser
			this._parser = parser;
			this._automatic = automatic;
		}
		
		// PUBLIC METHODS
		
		/**
		 * Start qrcode reading and display interface.
		 */
		public function startReading():void {
			// prepare camera and video
			this._camera = Camera.getCamera();
			this._camera.setMode(960, 540, 10);
			this._video.attachCamera(this._camera);
			// keep checking recorded image for qrcodes
			if (this._interval >= 0) {
				try {
					clearInterval(this._interval);
				} catch (e:Error) { /* do nothing */ }
			}
			this._interval = setInterval(this.fetchImage, INTERVAL);
			this._zbar.addEventListener(ZBarEvent.SCAN, onZbarScan);
			this._closebt.addEventListener(MouseEvent.CLICK, onCloseBT);
		}
		
		/**
		 * Resize the qrcode reading interface;
		 * @param	w	stage width
		 * @param	h	stage height
		 */
		public function resize(w:Number, h:Number):void {
			this._bg.width = w;
			this._bg.height = h;
			this._video.width = uint(Math.round(w));
			this._video.height = uint(Math.round(w * 9 / 16));
			if (this._video.height > h) {
				this._video.height = uint(Math.round(h));
				this._video.width = uint(Math.round(h * 16 / 9));
			}
			this._video.x = (w - this._video.width) / 2;
			this._video.y = (h - this._video.height) / 2;
			if (this._data != null) {
				this._data.dispose();
				this._data = null;
			}
			this._data = new BitmapData(this._video.width, this._video.height);
			this._closebt.x = w - this._closebt.width - 10;
			this._closebt.y = h - this._closebt.height - 10;
		}
		
		/**
		 * Close qrcode reading interface and stop parsing.
		 */
		public function close():void {
			if (this._interval >= 0) {
				try {
					clearInterval(this._interval);
				} catch (e:Error) { /* do nothing */ }
			}
			this._interval = -1;
			this._video.attachCamera(null);
			this._zbar.removeEventListener(ZBarEvent.SCAN, onZbarScan);
			this._closebt.removeEventListener(MouseEvent.CLICK, onCloseBT);
			this._camera = null;
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
		// PRIVATE METHODS
		
		/**
		 * Fetch an image from video and try to parse it.
		 */
		private function fetchImage():void {
			// fetch bitmap from video
			this._data.draw(this._video);
			this._zbar.decodeFromBitmapData(this._data);
		}
		
		/**
		 * The qrcode parse for a fetched image was finished.
		 * @param	evt	information about the parsing result
		 */
		private function onZbarScan(evt:ZBarEvent):void {
			var found:String = String(evt.data);
			if (found.indexOf('managana=') >= 0) {
				found = found.substr(found.indexOf('managana='));
				try {
					var foundVar:URLVariables = new URLVariables(found);
				} catch (e:Error) { /* do nothing */ }
				if (foundVar != null) {
					found = String(foundVar['managana']);
				}
			}
			if (this._parser.checkCode(found)) {
				this.dispatchEvent(new Message(Message.SENDPROGRESSCODE, found));
				if (this._automatic) this._parser.run(found);
				this.close();
			}
		}
		
		/**
		 * Close button was pressed.
		 */
		private function onCloseBT(evt:MouseEvent):void {
			this.close();
		}
	}

}
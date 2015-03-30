package art.ciclope.display {
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import org.qrcode.QRCode;
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class QRCodeDisplay extends Sprite {
		
		var _qrcode:QRCode;
		var _codeDisplay:Bitmap;
		var _lastCode:String;
		
		public function QRCodeDisplay() {
			super();
			this._qrcode = new QRCode();
			this._codeDisplay = new Bitmap();
			this.addChild(this._codeDisplay);
			this._lastCode = '';
		}
		
		public function get code():String {
			return (this._lastCode);
		}
		
		public function setCode(text:String):void {
			this._lastCode = text;
			this._qrcode.encode(text);
			this._codeDisplay.bitmapData = this._qrcode.bitmapData;
		}
		
	}

}
package art.ciclope.display {
	
	// FLASH PACKAGES
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	// AS3 QRCODE ENCODER
	import org.qrcode.QRCode;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * QRCodeDisplay provides methods for creating an sprite with a string encoded as a QR Code.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class QRCodeDisplay extends Sprite {
		
		// PRIVATE VARIABLES
		
		private var _qrcode:QRCode;				// the qrcode encoder library reference
		private var _codeDisplay:Bitmap;		// the qrcode display bitmap
		private var _lastCode:String;			// the last encoded string
		
		/**
		 * QRCodeDisplay constructor.
		 */
		public function QRCodeDisplay() {
			super();
			this._qrcode = new QRCode();
			this._codeDisplay = new Bitmap();
			this.addChild(this._codeDisplay);
			this._lastCode = '';
		}
		
		// READ-ONLY VALUES
		
		/**
		 * The last string encoded.
		 */
		public function get code():String {
			return (this._lastCode);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Encode a string as a qrcode and display the resulting bitmap.
		 * @param	text	the string to be encoded
		 */
		public function setCode(text:String):void {
			this._lastCode = text;
			this._qrcode.encode(text);
			this._codeDisplay.bitmapData = this._qrcode.bitmapData;
		}
		
	}

}
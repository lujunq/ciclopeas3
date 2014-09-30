package art.ciclope.display {
	
	// FLASH PACKAGES
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class LockedImage extends Sprite {
		
		// VARIABLES
		
		/**
		 * Background color.
		 */
		private var _bg:Shape;
		/**
		 * Image placed on center.
		 */
		private var _img:DisplayObject;
		
		public function LockedImage(color:uint, image:DisplayObject, alpha:Number = 1) {
			// draw background
			this._bg = new Shape();
			this.addChild(this._bg);
			// get image
			this._img = image;
			this.addChild(this._img);
			if (this._img is Bitmap) Bitmap(this._img).smoothing = true;
			this._img.x = this._img.y = 10;
			this._bg.graphics.beginFill(color, alpha);
			this._bg.graphics.drawRect(0, 0, (this._img.width + 20), (this._img.height + 20));
			this._bg.graphics.endFill();
		}
		
		/**
		 * Release memory used by this object.
		 */
		public function kill():void {
			this._bg.graphics.clear();
			this.removeChild(this._bg);
			this._bg = null;
			this.removeChild(this._img);
			if (this._img is Bitmap) Bitmap(this._img).bitmapData.dispose();
			this._img = null;
		}
		
	}

}
package art.ciclope.display {
	
	// FLASH PACKAGES
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import flash.geom.Point;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * EdgePoint create points for video cropping display object.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class EdgePoint extends Sprite {
		
		// VARIABLES
		
		private var _color:uint;		// point color
		private var _graphic:Shape;		// point shape
		private var _diameter:uint;		// point diameter
		private var _release:int;		// release timeout
		private var _dragging:Boolean;	// is point being drag?
		
		/**
		 * EdgePoint constructor.
		 * @param	color	the dot color
		 * @param	diameter	the dot diameter
		 */
		public function EdgePoint(color:uint = 0xFF0000, diameter:uint = 10) {
			// get values
			this._color = color;
			this._diameter = diameter;
			this._release = -1;
			this._dragging = false;
			// set graphic
			this._graphic = new Shape();
			this.addChild(this._graphic);
			this.drawPoint();
			// drag
			this.useHandCursor = true;
			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			if (this.stage != null) {
				this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			} else {
				this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			}
		}
		
		/**
		 * The point color.
		 */
		public function get color():uint {
			return (this._color);
		}
		public function set color(to:uint):void {
			this._color = to;
			this.drawPoint();
		}
		
		/**
		 * Release resources used by the object.
		 */
		public function kill():void {
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			if (this.hasEventListener(Event.ADDED_TO_STAGE)) {
				this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			} else {
				if (this.stage != null) this.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
			this.removeChild(this._graphic);
			this._graphic.graphics.clear();
			this._graphic = null;
			if (this._dragging) clearTimeout(this._release);
		}
		
		/**
		 * Get normalized position for current point.
		 * @param	boxW	holder sprite width
		 * @param	boxH	holder sprite height
		 * @return	the current normalized position according to the holder sprite
		 */
		public function getNormalized(boxW:Number, boxH:Number):Point {
			return (new Point());
		}
		
		/**
		 * Draw the point graphic.
		 */
		private function drawPoint():void {
			this._graphic.graphics.clear();
			this._graphic.graphics.beginFill(this._color, 0.75);
			this._graphic.graphics.drawCircle(0, 0, (this._diameter / 2));
		}
		
		/**
		 * Stage became available.
		 */
		private function onStage(evt:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		/**
		 * Mouse press over this object.
		 */
		private function onMouseDown(evt:MouseEvent):void {
			this._dragging = true;
			this.startDrag();
		}
		
		/**
		 * Mouse button relase.
		 */
		private function onMouseUp(evt:MouseEvent):void {
			if (this._dragging) {
				this.stopDrag();
				this._release = setTimeout(afterDrag, 100);
			}
		}
		
		/**
		 * Warn listeners about drag end.
		 */
		private function afterDrag():void {
			this._dragging = false;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}

}
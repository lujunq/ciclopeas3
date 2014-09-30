package art.ciclope.display {
	
	// FLASH PACKAGES
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import flash.display.BitmapData;
	import flash.display.TriangleCulling;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Chokito
	 */
	public class RectangleMapping extends Sprite {
		
		// CONSTANTS
		
		/**
		 * Mapping mode: input set.
		 */
		public static const MODE_IN:String = "MODE_IN";
		
		/**
		 * Mapping mode: output set.
		 */
		public static const MODE_OUT:String = "MODE_OUT";
		
		// VARIABLES
		
		private var _width:Number;				// square width
		private var _height:Number;				// square height
		private var _bg:Sprite;					// background
		private var _color:uint;				// background color
		private var _edges:Array;				// crop edges
		private var _uvt:Vector.<Number>;		// normalized edge positions
		private var _release:int;				// release timeout
		private var _dragging:Boolean;			// is rectangle being drag?
		private var _mode:String;				// rectanlge usage: input or output
		private var _dObject:DisplayObject;		// input reference display object
		private var _inRect:RectangleMapping;	// input rectangle reference for output rectangle
		private var _data:BitmapData;			// bitmap data for input rectangle
		
		public function RectangleMapping(mode:String, reference:Object, width:Number = 200, height:Number = 200, color:uint = 0x00FF00) {
			// get values
			this._width = width;
			this._height = height;
			this._color = color;
			this._release = -1;
			this._dragging = false;
			this._mode = mode;
			// rectangle mode
			if (this._mode == RectangleMapping.MODE_IN) {
				this._dObject = reference as DisplayObject;
				this._data = new BitmapData(width, height);
			} else {
				this._inRect = reference as RectangleMapping;
				this._inRect.addEventListener(Event.CHANGE, onInChange);
			}
			// background
			this._bg = new Sprite();
			this.addChild(this._bg);
			this._bg.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			if (this.stage != null) {
				this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			} else {
				this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			}
			// edges
			this._edges = new Array();
			this._edges.push(new EdgePoint()); // top-left
			this._edges[0].x = 0;
			this._edges[0].y = 0;
			this._edges[0].addEventListener(Event.COMPLETE, onEdgeDrag);
			this.addChild(this._edges[0]);
			this._edges.push(new EdgePoint()); // top-right
			this._edges[1].x = width;
			this._edges[1].y = 0;
			this.addChild(this._edges[1]);
			this._edges[1].addEventListener(Event.COMPLETE, onEdgeDrag);
			this._edges.push(new EdgePoint()); // bottom-left
			this._edges[2].x = 0;
			this._edges[2].y = height;
			this.addChild(this._edges[2]);
			this._edges[2].addEventListener(Event.COMPLETE, onEdgeDrag);
			this._edges.push(new EdgePoint()); // bottom-right
			this._edges[3].x = width;
			this._edges[3].y = height;
			this.addChild(this._edges[3]);
			this._edges[3].addEventListener(Event.COMPLETE, onEdgeDrag);
			this._edges.push(new EdgePoint()); // center
			this._edges[4].x = width / 2;
			this._edges[4].y = height / 2;
			this.addChild(this._edges[4]);
			this._edges[4].addEventListener(Event.COMPLETE, onEdgeDrag);
			this.drawLines();
			// draw background
			this.drawBackground();
		}
		
		/**
		 * The background color.
		 */
		public function get color():uint {
			return (this._color);
		}
		public function set color(to:uint):void {
			this._color = to;
			this.drawBackground();
		}
		
		/**
		 * The background width.
		 */
		override public function get width():Number {
			return (this._width);
		}
		override public function set width(to:Number):void {
			this._width = to;
			this.drawBackground();
		}
		
		/**
		 * The background height.
		 */
		override public function get height():Number {
			return (this._height);
		}
		override public function set height(to:Number):void {
			this._height = to;
			this.drawBackground();
		}
		
		/**
		 * Mapping settings active?
		 */
		public function get active():Boolean {
			return (this.mouseEnabled);
		}
		public function set active(to:Boolean):void {
			this.mouseChildren = to;
			this.mouseEnabled = to;
			for (var index:uint = 0; index < this._edges.length; index++) {
				this._edges[index].mouseEnabled = to;
				this._edges[index].mouseChildren = to;
				this._edges[index].visible = to;
			}
			this._bg.visible = to;
			if (!to) {
				this.graphics.clear();
				// draw output
				if (this._mode == RectangleMapping.MODE_OUT) {
					this.graphics.beginBitmapFill(this._inRect.bitmapData, null, false, true);
					this.graphics.drawTriangles( 
					Vector.<Number>([
					this._edges[0].x, this._edges[0].y,
					this._edges[1].x, this._edges[1].y,
					this._edges[2].x, this._edges[2].y,
					this._edges[3].x, this._edges[3].y,
					this._edges[4].x, this._edges[4].y
					]), 
					//Vector.<int>([0,1,2, 1,3,2]),
					Vector.<int>([0,1,4, 1,3,4, 3,2,4, 2,0,4]),
					this._inRect.uvtData,
					TriangleCulling.NONE);
					this.graphics.endFill();
				}
			} else {
				this.drawLines();
			}
		}
		
		/**
		 * BitmapData for input rectangle.
		 */
		public function get bitmapData():BitmapData {
			if (this._mode == RectangleMapping.MODE_IN) return (this._data);
				else return (null);
		}
		
		/**
		 * Normalized edge points positions.
		 */
		public function get uvtData():Vector.<Number> {
			return (this._uvt);
		}
		
		/**
		 * Release resources used by the object.
		 */
		public function kill():void {
			while (this._edges.length > 0) {
				this._edges[0].removeEventListener(Event.COMPLETE, onEdgeDrag);
				this.removeChild(this._edges[0]);
				this._edges[0].kill();
				this._edges.shift();
			}
			this._edges = null;
			this.removeChild(this._bg);
			this._bg.graphics.clear();
			this._bg = null;
			if (this._dragging) clearTimeout(this._release);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			if (this.hasEventListener(Event.ADDED_TO_STAGE)) {
				this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			} else {
				if (this.stage != null) this.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
			this._uvt = null;
			if (this._mode == RectangleMapping.MODE_IN) {
				this._dObject = null;
				this._data.dispose();
				this._data = null;
			} else {
				this._inRect.removeEventListener(Event.CHANGE, onInChange);
				this._inRect = null;
			}
		}
		
		/**
		 * Grab image from the reference display object for input rectangles.
		 */
		public function grabPicture():void {
			if (this._mode == RectangleMapping.MODE_IN) {
				this._data.fillRect(new Rectangle(0, 0, this._width, this._height), 0x00000000);
				this._data.draw(this._dObject, new Matrix(1, 0, 0, 1, -this.x, -this.y));
			}
		}
		
		/**
		 * Reset edge positions.
		 */
		public function resetEdges():void {
			this._edges[0].x = 0;
			this._edges[0].y = 0;
			this._edges[1].x = this._width;
			this._edges[1].y = 0;
			this._edges[2].x = 0;
			this._edges[2].y = this._height;
			this._edges[3].x = this._width;
			this._edges[3].y = this._height;
			this._edges[4].x = this._width / 2;
			this._edges[4].y = this._height / 2;
			this.drawLines();
		}
		
		/**
		 * Set edge positions (position values normalized according to the rectangle box).
		 * @param	ed0	edge 0 position as a (x, y) Point
		 * @param	ed1	edge 1 position as a (x, y) Point
		 * @param	ed2	edge 2 position as a (x, y) Point
		 * @param	ed3	edge 3 position as a (x, y) Point
		 * @param	ed4	edge 4 position as a (x, y) Point
		 */
		public function setEdges(ed0:Point, ed1:Point, ed2:Point, ed3:Point, ed4:Point):void {
			this._edges[0].x = this._width * ed0.x;
			this._edges[0].y = this._height * ed0.y;
			this._edges[1].x = this._width * ed1.x;
			this._edges[1].y = this._height * ed1.y;
			this._edges[2].x = this._width * ed2.x;
			this._edges[2].y = this._height * ed2.y;
			this._edges[3].x = this._width * ed3.x;
			this._edges[3].y = this._height * ed3.y;
			this._edges[4].x = this._width * ed4.x;
			this._edges[4].y = this._height * ed4.y;
			if (this._mode == RectangleMapping.MODE_OUT) {
				this.graphics.clear();
				this.graphics.beginBitmapFill(this._inRect.bitmapData, null, false, true);
				this.graphics.drawTriangles( 
				Vector.<Number>([
					this._edges[0].x, this._edges[0].y,
					this._edges[1].x, this._edges[1].y,
					this._edges[2].x, this._edges[2].y,
					this._edges[3].x, this._edges[3].y,
					this._edges[4].x, this._edges[4].y
				]), 
				//Vector.<int>([0,1,2, 1,3,2]),
				Vector.<int>([0,1,4, 1,3,4, 3,2,4, 2,0,4]),
				this._inRect.uvtData,
				TriangleCulling.NONE);
				this.graphics.endFill();
			}
			if (this.active) this.drawLines();
			this._uvt = new <Number>[ ed0.x, ed0.y, ed1.x, ed1.y, ed2.x, ed2.y, ed3.x, ed3.y, ed4.x, ed4.y ];
		}
		
		/**
		 * Set a singe edge position.
		 * @param	edge	the edge number (0 to 4)
		 * @param	position	the new position (normalized values)
		 */
		public function setEdgePosition(edge:uint, position:Point):void {
			if (edge <= 4) {
				this._edges[edge].x = position.x * this._width;
				this._edges[edge].y = position.y * this._height;
				this.drawLines();
			}
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
		 * An edge point was moved.
		 */
		private function onEdgeDrag(evt:Event):void {
			this.drawLines();
		}
		
		/**
		 * There was a change at input rectangle edge points.
		 */
		private function onInChange(evt:Event):void {
			this.drawLines();
		}
		
		/**
		 * Draw the rectangle background.
		 */
		private function drawBackground():void {
			// background display
			this._bg.graphics.clear();
			this._bg.graphics.beginFill(this._color, 0.25);
			this._bg.graphics.drawRect(0, 0, this._width, this._height);
			this._bg.graphics.endFill();
			// bitmap data
			if (this._mode == RectangleMapping.MODE_IN) {
				this._data.dispose();
				this._data = new BitmapData(this._width, this._height);
			}
			this.grabPicture();
			// check normalized edge positions
			this.drawLines();
		}
		
		/**
		 * Draw lines connecting edges.
		 */
		public function drawLines():void {
			// check edges position
			for (var index:uint = 0; index < this._edges.length; index++) {
				if (this._edges[index].x < 0) this._edges[index].x = 0;
					else if (this._edges[index].x > this._width) this._edges[index].x = this._width;
				if (this._edges[index].y < 0) this._edges[index].y = 0;
					else if (this._edges[index].y > this._height) this._edges[index].y = this._height;
			}
			// check normalized edge positions
			this.processUVT();
			// clear draw buffer
			this.graphics.clear();
			// draw output
			if (this._mode == RectangleMapping.MODE_OUT) {
				this.graphics.beginBitmapFill(this._inRect.bitmapData, null, false, true);
				this.graphics.drawTriangles( 
				Vector.<Number>([
				this._edges[0].x, this._edges[0].y,
				this._edges[1].x, this._edges[1].y,
				this._edges[2].x, this._edges[2].y,
				this._edges[3].x, this._edges[3].y,
				this._edges[4].x, this._edges[4].y
				]), 
				Vector.<int>([0,1,4, 1,3,4, 3,2,4, 2,0,4]),
				this._inRect.uvtData,
				TriangleCulling.NONE);
				this.graphics.endFill();
			}
			// draw the lines
			if (this.active) {
				this.graphics.lineStyle(2, this._edges[0].color);
				this.graphics.moveTo(this._edges[0].x, this._edges[0].y);
				this.graphics.lineTo(this._edges[1].x, this._edges[1].y);
				this.graphics.lineTo(this._edges[3].x, this._edges[3].y);
				this.graphics.lineTo(this._edges[2].x, this._edges[2].y);
				this.graphics.lineTo(this._edges[0].x, this._edges[0].y);
			}
			// warn listeners
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * Warn listeners about drag end.
		 */
		private function afterDrag():void {
			this._dragging = false;
			this.grabPicture();
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * Check the normalized positions for each edge point.
		 */
		private function processUVT():void {
			this._uvt = new <Number>[
			(this._edges[0].x / this._width), (this._edges[0].y / this._height),
			(this._edges[1].x / this._width), (this._edges[1].y / this._height),
			(this._edges[2].x / this._width), (this._edges[2].y / this._height),
			(this._edges[3].x / this._width), (this._edges[3].y / this._height),
			(this._edges[4].x / this._width), (this._edges[4].y / this._height)
			];
		}
		
	}

}
package art.ciclope.display {
	
	// FLASH PACKAGES
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * VideoMappingCrop creates a crop are from a display source and shows it on an output image.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class VideoMappingCrop {
		
		// VARIABLES
		
		/**
		 * The origin rectangle display.
		 */
		public var originDisplay:RectangleMapping;
		
		/**
		 * The output rectangle display.
		 */
		public var outputDisplay:RectangleMapping;
		
		/**
		 * Constructor.
		 * @param	reference	the display object to grab image from
		 * @param	inR	input rectangle position and size
		 * @param	outR	output rectangle position and size
		 * @param	inP0	input rectangle top-left point normalized position
		 * @param	inP1	input rectangle top-right point normalized position
		 * @param	inP2	input rectangle bottom-left point normalized position
		 * @param	inP3	input rectangle bottom-right point normalized position
		 * @param	inP4	input rectangle center point normalized position
		 * @param	outP0	output rectangle top-left point normalized position
		 * @param	outP1	output rectangle top-right point normalized position
		 * @param	outP2	output rectangle bottom-left point normalized position
		 * @param	outP3	output rectangle bottom-right point normalized position
		 * @param	outP4	output rectangle center point normalized position
		 */
		public function VideoMappingCrop(reference:DisplayObject, inR:Rectangle, outR:Rectangle, inP0:Point, inP1:Point, inP2:Point, inP3:Point, inP4:Point, outP0:Point, outP1:Point, outP2:Point, outP3:Point, outP4:Point) {
			// create crop rectangles
			this.originDisplay = new RectangleMapping(RectangleMapping.MODE_IN, reference, inR.width, inR.height);
			this.originDisplay.x = inR.x;
			this.originDisplay.y = inR.y;
			this.originDisplay.setEdges(inP0, inP1, inP2, inP3, inP4);
			this.outputDisplay = new RectangleMapping(RectangleMapping.MODE_OUT, this.originDisplay, outR.width, outR.height, 0x0000FF);
			this.outputDisplay.x = outR.x;
			this.outputDisplay.y = outR.y;
			this.outputDisplay.setEdges(outP0, outP1, outP2, outP3, outP4);
		}
		
		/**
		 * Image origin rectangle position and size.
		 */
		public function get origin():Rectangle {
			return (new Rectangle(this.originDisplay.x, this.originDisplay.y, this.originDisplay.width, this.originDisplay.height));
		}
		public function set origin(to:Rectangle):void {
			this.originDisplay.x = to.x;
			this.originDisplay.y = to.y;
			this.originDisplay.width = to.width;
			this.originDisplay.height = to.height;
		}
		
		/**
		 * Image output rectangle position and size.
		 */
		public function get output():Rectangle {
			return (new Rectangle(this.outputDisplay.x, this.outputDisplay.y, this.outputDisplay.width, this.outputDisplay.height));
		}
		public function set output(to:Rectangle):void {
			this.outputDisplay.x = to.x;
			this.outputDisplay.y = to.y;
			this.outputDisplay.width = to.width;
			this.outputDisplay.height = to.height;
		}
		
		/**
		 * Origin rectangle top-left point normalized position.
		 */
		public function get originP0():Point {
			return (new Point(this.originDisplay.uvtData[0], this.originDisplay.uvtData[1]));
		}
		public function set originP0(to:Point):void {
			this.originDisplay.setEdgePosition(0, to);
		}
		
		/**
		 * Origin rectangle top-right point normalized position.
		 */
		public function get originP1():Point {
			return (new Point(this.originDisplay.uvtData[2], this.originDisplay.uvtData[3]));
		}
		public function set originP1(to:Point):void {
			this.originDisplay.setEdgePosition(1, to);
		}
		
		/**
		 * Origin rectangle bottom-left point normalized position.
		 */
		public function get originP2():Point {
			return (new Point(this.originDisplay.uvtData[4], this.originDisplay.uvtData[5]));
		}
		public function set originP2(to:Point):void {
			this.originDisplay.setEdgePosition(2, to);
		}
		
		/**
		 * Origin rectangle bottom-right point normalized position.
		 */
		public function get originP3():Point {
			return (new Point(this.originDisplay.uvtData[6], this.originDisplay.uvtData[7]));
		}
		public function set originP3(to:Point):void {
			this.originDisplay.setEdgePosition(3, to);
		}
		
		/**
		 * Origin rectangle center point normalized position.
		 */
		public function get originP4():Point {
			return (new Point(this.originDisplay.uvtData[8], this.originDisplay.uvtData[9]));
		}
		public function set originP4(to:Point):void {
			this.originDisplay.setEdgePosition(4, to);
		}
		
		/**
		 * Output rectangle top-left point normalized position.
		 */
		public function get outputP0():Point {
			return (new Point(this.outputDisplay.uvtData[0], this.outputDisplay.uvtData[1]));
		}
		public function set outputP0(to:Point):void {
			this.outputDisplay.setEdgePosition(0, to);
		}
		
		/**
		 * Output rectangle top-right point normalized position.
		 */
		public function get outputP1():Point {
			return (new Point(this.outputDisplay.uvtData[2], this.outputDisplay.uvtData[3]));
		}
		public function set outputP1(to:Point):void {
			this.outputDisplay.setEdgePosition(1, to);
		}
		
		/**
		 * Output rectangle bottom-left point normalized position.
		 */
		public function get outputP2():Point {
			return (new Point(this.outputDisplay.uvtData[4], this.outputDisplay.uvtData[5]));
		}
		public function set outputP2(to:Point):void {
			this.outputDisplay.setEdgePosition(2, to);
		}
		
		/**
		 * Output rectangle bottom-right point normalized position.
		 */
		public function get outputP3():Point {
			return (new Point(this.outputDisplay.uvtData[6], this.outputDisplay.uvtData[7]));
		}
		public function set outputP3(to:Point):void {
			this.outputDisplay.setEdgePosition(3, to);
		}
		
		/**
		 * Output rectangle center point normalized position.
		 */
		public function get outputP4():Point {
			return (new Point(this.outputDisplay.uvtData[8], this.outputDisplay.uvtData[9]));
		}
		public function set outputP4(to:Point):void {
			this.outputDisplay.setEdgePosition(4, to);
		}
		
		
		/**
		 * Release resources used by the object.
		 */
		public function kill():void {
			this.originDisplay.kill();
			this.originDisplay = null;
			this.outputDisplay.kill();
			this.outputDisplay = null;
		}
		
	}

}
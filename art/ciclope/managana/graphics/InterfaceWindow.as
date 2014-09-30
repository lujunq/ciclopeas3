package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaInterface;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * InterfaceWindow provides a graphic interface for Managana reader windows background.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class InterfaceWindow extends Sprite {
		
		// VARIABLES
		
		private var _borderLT:Sprite;		// left-top border
		private var _borderLB:Sprite;		// left-bottom border
		private var _borderRT:Sprite;		// right-top border
		private var _borderRB:Sprite;		// right-bottom border
		private var _bgTop:Sprite;			// top plain background
		private var _bgMiddle:Sprite;		// middle background
		private var _bgBottom:Sprite;		// bottom background
		
		/**
		 * InterfaceWindow constructor.
		 * @param	squaretop	should right-top corner be a square?
		 */
		public function InterfaceWindow(squaretop:Boolean = true) {
			// set graphics
			this._borderLT = new BorderLT() as Sprite;
			this._borderLB = new BorderLB() as Sprite;
			if (squaretop) this._borderRT = new Background() as Sprite;
				else this._borderRT = new BorderRT() as Sprite;
			this._borderRB = new BorderRB() as Sprite;
			this._bgTop = new Background() as Sprite;
			this._bgMiddle = new Background() as Sprite;
			this._bgBottom = new Background() as Sprite;
			this.addChild(this._borderLT);
			this.addChild(this._borderLB);
			this.addChild(this._borderRT);
			this.addChild(this._borderRB);
			this.addChild(this._bgTop);
			this.addChild(this._bgMiddle);
			this.addChild(this._bgBottom);
			this.width = 50;
			this.height = 50;
			this.mouseChildren = false;
		}
		
		// PROPERTIES
		
		/**
		 * Window width (minimum = 50).
		 */
		override public function get width():Number {
			return (super.width);
		}
		override public function set width(value:Number):void {
			if (value < 50) value = 50;
			this._borderLT.x = 0;
			this._borderLT.y = 0;
			this._borderLB.x = 0;
			this._borderLB.y = this.height - this._borderLB.height;
			this._borderRT.x = value - this._borderRT.width;
			this._borderRT.y = 0;
			this._borderRB.x = value - this._borderRB.width;
			this._borderRB.y = this.height - this._borderRB.height;
			this._bgTop.x = this._borderLT.width;
			this._bgTop.y = 0;
			this._bgTop.width = value - this._borderLT.width - this._borderRT.width;
			this._bgTop.height = this._borderLT.height;
			this._bgBottom.x = this._borderLT.width;
			this._bgBottom.y = this.height - this._borderLB.height;
			this._bgBottom.width = value - this._borderLT.width - this._borderRT.width;
			this._bgBottom.height = this._borderLB.height;
			this._bgMiddle.x = 0;
			this._bgMiddle.y = this._borderLT.height;
			this._bgMiddle.width = value;
			this._bgMiddle.height = this.height - this._borderLT.height - this._borderLB.height;
		}
		
		/**
		 * Window height (minimum = 50).
		 */
		override public function get height():Number {
			return (super.height);
		}
		override public function set height(value:Number):void {
			if (value < 50) value = 50;
			this._borderLT.x = 0;
			this._borderLT.y = 0;
			this._borderLB.x = 0;
			this._borderLB.y = value - this._borderLB.height;
			this._borderRT.x = this.width - this._borderRT.width;
			this._borderRT.y = 0;
			this._borderRB.x = this.width - this._borderRB.width;
			this._borderRB.y = value - this._borderRB.height;
			this._bgTop.x = this._borderLT.width;
			this._bgTop.y = 0;
			this._bgTop.width = this.width - this._borderLT.width - this._borderRT.width;
			this._bgTop.height = this._borderLT.height;
			this._bgBottom.x = this._borderLT.width;
			this._bgBottom.y = value - this._borderLB.height;
			this._bgBottom.width = this.width - this._borderLT.width - this._borderRT.width;
			this._bgBottom.height = this._borderLB.height;
			this._bgMiddle.x = 0;
			this._bgMiddle.y = this._borderLT.height;
			this._bgMiddle.width = this.width;
			this._bgMiddle.height = value - this._borderLT.height - this._borderLB.height;
		}
		
		// PUBLIC METHODS
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			this.removeChild(this._borderLT);
			this.removeChild(this._borderLB);
			this.removeChild(this._borderRT);
			this.removeChild(this._borderRB);
			this.removeChild(this._bgTop);
			this.removeChild(this._bgMiddle);
			this.removeChild(this._bgBottom);
			this._borderLT = null;
			this._borderLB = null;
			this._borderRT = null;
			this._borderRB = null;
			this._bgTop = null;
			this._bgMiddle = null;
			this._bgBottom = null;
		}
		
	}

}
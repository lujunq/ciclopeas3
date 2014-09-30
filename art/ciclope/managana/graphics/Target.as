package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import art.ciclope.display.AnimSprite;
	import art.ciclope.event.Loading;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaImage;
	import art.ciclope.display.GraphicSprite;
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class Target extends Sprite {
		
		// STATIC CONSTANTS
		
		/**
		 * The time before hiding the target graphic.
		 */
		public static const HIDE_TIME:uint = 5;
		
		/**
		 * The time for image action call (remote mode).
		 */
		public static const ACT_TIME:uint = 3;
		
		/**
		 * The target interacts as a mouse cursor.
		 */
		public static const INTERACTION_MOUSE:String = "INTERACTION_MOUSE";
		
		/**
		 * The target interacts from remote control data.
		 */
		public static const INTERACTION_REMOTE:String = "INTERACTION_REMOTE";
		
		/**
		 * No target interaction.
		 */
		public static const INTERACTION_NONE:String = "INTERACTION_NONE";
		
		// PUBLIC VARIABLES
		
		/**
		 * Counter for target hide.
		 */
		public var counter:uint = 0;
		
		/**
		 * Target mode.
		 */
		public var mode:String = Target.INTERACTION_NONE;
		
		/**
		 * The managana image object the target is interacting with
		 */
		public var image:ManaganaImage;
		
		// VARIABLES
		
		private var _graphic:GraphicSprite;		// the target graphic
		private var _imagecounter:uint;			// a counter for image interaction
		private var _imagefeedback:AnimSprite;	// a visual feedkback for image counter valus
		private var _forceHide:Boolean;			// force target hide? (for selectable text)
		
		public function Target() {
			// prepare graphic
			this._graphic = new GraphicSprite(30, 30);
			this._graphic.setContent(new TargetGraphic() as Sprite);
			this._graphic.x = -this._graphic.width / 2;
			this._graphic.y = -this._graphic.height / 2;
			this.addChild(this._graphic);
			// image interaction
			this.image = null;
			this._imagecounter = 0;
			// visual feedback
			this._forceHide = false;
			this._imagefeedback = new AnimSprite();
			this._imagefeedback.addFrame(new TargetLevel0() as Sprite);
			this._imagefeedback.addFrame(new TargetLevel20() as Sprite);
			this._imagefeedback.addFrame(new TargetLevel40() as Sprite);
			this._imagefeedback.addFrame(new TargetLevel60() as Sprite);
			this._imagefeedback.addFrame(new TargetLevel80() as Sprite);
			this._imagefeedback.addFrame(new TargetLevel100() as Sprite);
			this._imagefeedback.x = 0;
			this._imagefeedback.y = (this._graphic.height / 2) + 2 + (this._imagefeedback.height / 2);
			this._imagefeedback.mouseEnabled = false;
			this._imagefeedback.gotoAndStop(0);
			this._imagefeedback.visible = false;
			this.addChild(this._imagefeedback);
		}
		
		// PROPERTIES
		
		/**
		 * Force target hidden?
		 */
		public function set forceHide(to:Boolean):void {
			this._forceHide = to;
			if (to) this.visible = false;
		}
		public function get forceHide():Boolean {
			return (this._forceHide);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Set the target graphic.
		 * @param	url	the target graphic url (leave empty for standard graphic)
		 */
		public function setGraphic(url:String = ""):void {
			// remove previous graphic
			if (this._graphic != null) {
				this.removeChild(this._graphic);
				if (this._graphic.hasEventListener(Loading.FINISHED)) {
					this._graphic.removeEventListener(Loading.FINISHED, onGraphicOK);
					this._graphic.removeEventListener(Loading.ERROR_IO, onGraphicError);
				}
				this._graphic.kill();
			}
			// set the new graphic
			if (url == "") {
				this._graphic = new GraphicSprite(30, 30);
				this._graphic.setContent(new TargetGraphic() as Sprite);
				this._graphic.x = -this._graphic.width / 2;
				this._graphic.y = -this._graphic.height / 2;
				this.addChild(this._graphic);
			} else {
				this._graphic = new GraphicSprite(30, 30, url);
				this._graphic.addEventListener(Loading.FINISHED, onGraphicOK);
				this._graphic.addEventListener(Loading.ERROR_IO, onGraphicError);
				this.addChild(this._graphic);
			}
			// place the feedback bar
			if (this._imagefeedback != null) {
				this._imagefeedback.x = 0;
				this._imagefeedback.y = (this._graphic.height / 2) + 2 + (this._imagefeedback.height / 2);
			}
		}
		
		/**
		 * Check if the target is overlapping another object.
		 * @param	object	the graphic object to check
		 * @return	true if the target is overlapping the object
		 */
		public function checkCollision(object:DisplayObject):Boolean {
			var check:Boolean = false;
			if (this.x >= object.x) {
				if (this.x <= (object.x + object.width)) {
					if (this.y >= object.y) {
						if (this.y <= (object.y + object.height)) {
							check = true;
						}
					}
				}
			}
			return(check);
		}
		
		/**
		 * Update target counters.
		 */
		public function update():void {
			// show/hide target
			if (counter < Target.HIDE_TIME) {
				counter++;
			} else {
				this.visible = false;
			}
			// check for image interaction
			if (this.visible && (this.mode == Target.INTERACTION_REMOTE)) {
				if (this.image != null) {
					this._imagecounter++;
					this._imagefeedback.visible = true;
					var current:Number = this._imagecounter / Target.ACT_TIME;
					if (current == 1) {
						this._imagefeedback.gotoAndStop(6);
					} else if (current >= 0.8) {
						this._imagefeedback.gotoAndStop(5);
					} else if (current >= 0.6) {
						this._imagefeedback.gotoAndStop(4);
					} else if (current >= 0.4) {
						this._imagefeedback.gotoAndStop(3);
					} else if (current >= 0.2) {
						this._imagefeedback.gotoAndStop(2);
					} else {
						this._imagefeedback.gotoAndStop(1);
					}
					if (this._imagecounter >= Target.ACT_TIME) {
						this._imagecounter = 0;
						this.image.onClick();
						this.image = null;
						this._imagefeedback.visible = false;
						this.visible = false;
					}
				} else {
					this._imagefeedback.visible = false;
				}
			}
		}
		
		/**
		 * Activates the instance code.
		 */
		public function act():void {
			if (this.image != null) if (this.image.hasAction) {
				this._imagecounter = 0;
				this.image.onClick();
				this.image = null;
				this._imagefeedback.visible = false;
				this.visible = false;
			}
		}
		
		/**
		 * Set a new interaction image.
		 * @param	newimage	the new image (or null for none)
		 */
		public function setImage(newimage:ManaganaImage = null):void {
			if (newimage == null) {
				// no image selected
				this.image = null;
				this._imagecounter = 0;
			} else if (newimage == this.image) {
				// same image, do nothing
			} else {
				// new image, restart counter
				this.image = newimage;
				this._imagecounter = 0;
				this._imagefeedback.gotoAndStop(1);
				this._imagefeedback.visible = true;
			}
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			this.removeChild(this._graphic);
			if (this._graphic.hasEventListener(Loading.FINISHED)) {
				this._graphic.removeEventListener(Loading.FINISHED, onGraphicOK);
				this._graphic.removeEventListener(Loading.ERROR_IO, onGraphicError);
			}
			this._graphic.kill();
			this._graphic = null;
			this.removeChild(this._imagefeedback);
			this._imagefeedback.kill();
			this._imagefeedback = null;
			this.image = null;
			this.mode = null;
		}
		
		// PRIVATE METHODS
		
		/**
		 * The target graphic failed to load.
		 */
		private function onGraphicError(evt:Loading):void {
			this._graphic.removeEventListener(Loading.FINISHED, onGraphicOK);
			this._graphic.removeEventListener(Loading.ERROR_IO, onGraphicError);
			// use standard graphic
			this.setGraphic();
		}
		
		/**
		 * The target graphic was loaded.
		 */
		private function onGraphicOK(evt:Loading):void {
			this._graphic.removeEventListener(Loading.FINISHED, onGraphicOK);
			this._graphic.removeEventListener(Loading.ERROR_IO, onGraphicError);
			// use original picture size
			this._graphic.width = this._graphic.originalWidth;
			this._graphic.height = this._graphic.originalHeight;
			this._graphic.x = -this._graphic.width / 2;
			this._graphic.y = -this._graphic.height / 2;
			this._imagefeedback.x = 0;
			this._imagefeedback.y = (this._graphic.height / 2) + 2 + (this._imagefeedback.height / 2);
		}
		
	}

}
package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * InterfaceCheckButton provides a graphic interface for Managana reader check buttons.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class InterfaceCheckButton extends Sprite {
		
		// VARIABLES
		
		private var _uncheck:Sprite;		// unchecked background
		private var _check:Sprite;			// checked background
		private var _enabled:Boolean;		// is button enabled?
		
		/**
		 * InterfaceCheckButton constructor.
		 * @param	graphic	the button appearence
		 * @param	checked	is the button checked by default?
		 */
		public function InterfaceCheckButton(graphic:String, checked:Boolean = false) {
			switch (graphic) {
				case "time":
					this._uncheck = new InterfaceClockOff() as Sprite;
					this._check = new InterfaceClockOn() as Sprite;
					break;
				case "name":
					this._uncheck = new InterfaceNameOff() as Sprite;
					this._check = new InterfaceNameOn() as Sprite;
					break;
				case "rate":
					this._uncheck = new InterfaceRateOff() as Sprite;
					this._check = new InterfaceRateOn() as Sprite;
					break;
				case "comment":
					this._uncheck = new InterfaceCommentOff() as Sprite;
					this._check = new InterfaceCommentOn() as Sprite;
					break;
				case "remote":
					this._uncheck = new InterfaceRemoteOff() as Sprite;
					this._check = new InterfaceRemoteOn() as Sprite;
					break;
				case "vote":
					this._uncheck = new InterfaceVoteOff() as Sprite;
					this._check = new InterfaceVoteOn() as Sprite;
					break;
				case "zoom":
					this._uncheck = new InterfaceZoomOff() as Sprite;
					this._check = new InterfaceZoomOn() as Sprite;
					break;
				case "notes":
					this._uncheck = new InterfaceNotesOff() as Sprite;
					this._check = new InterfaceNotesOn() as Sprite;
					break;
			}
			this._uncheck.visible = !checked;
			this.addChild(this._uncheck);
			this._check.visible = checked;
			this.addChild(this._check);
			this._enabled = false;
			this.alpha = 0.5;
			this.buttonMode = true;
			this.useHandCursor = true;
			this.mouseChildren = false;
		}
		
		// PROPERTIES
		
		/**
		 * Is the button enabled?
		 */
		public function get enabled():Boolean {
			return (this._enabled);
		}
		public function set enabled(to:Boolean):void {
			this._enabled = to;
			to ? this.alpha = 1 : this.alpha = 0.5;
			this.useHandCursor = this.buttonMode = to;
			if (!to) this.checked = false;
		}
		
		/**
		 * Is the button checked?
		 */
		public function get checked():Boolean {
			return (this._check.visible);
		}
		public function set checked(to:Boolean):void {
			this._check.visible = to;
			this._uncheck.visible = !to;
		}
		
		// PUBLIC METHODS
		
		/**
		 * release memory used by the object.
		 */
		public function kill():void {
			this.removeChild(this._check);
			this.removeChild(this._uncheck);
			this._check = null;
			this._uncheck = null;
		}
		
	}

}
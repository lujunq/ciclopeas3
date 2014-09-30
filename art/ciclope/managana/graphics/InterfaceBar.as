package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaPlayer;
	import art.ciclope.managana.ManaganaInterface;
	import art.ciclope.managana.graphics.MainButton;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * InterfaceBar provides a graphic interface Managana reader main upper bar.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class InterfaceBar extends Sprite {
		
		// VARIABLES
		
		private var _left:Sprite;						// left border
		private var _right:Sprite;						// right border
		private var _bg:Sprite;							// bar background
		private var _ready:Boolean;						// is the bar ready?
		private var _home:Sprite;						// the home button
		private var _sound:InterfaceSoundOnOff;			// the sound button
		private var _plus:InterfacePlusOnOff			// the plus button
		private var _extra:Sprite;						// the fullscreen button
		private var _ondevice:Boolean;					// running on a mobile device?
		private var _timeWidth:Number;					// time button width
		
		/**
		 * A function to call on full screen button click.
		 */
		public var fullclick:Function;
		/**
		 * A function to call on resize button click.
		 */
		public var offlineclick:Function;
		/**
		 * A function to call on home button click.
		 */
		public var homeclick:Function;
		
		
		// PUBLIC VARIABLES
		
		/**
		 * A reference for the managana player.
		 */
		public var player:ManaganaPlayer;
		/**
		 * The plus menu.
		 */
		public var plusmenu:InterfacePlusMenu;
		/**
		 * A function to call wne the plus menu is shown or hidden.
		 */
		public var plusmenuToggle:Function;
		
		/**
		 * InterfaceBar constructor.
		 * @param	ondevice	is reader running on a mobile or desktop device on adobe AIR?
		 */
		public function InterfaceBar(ondevice:Boolean = false) {
			this._ready = false;
			this._ondevice = ondevice;
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		/**
		 * Stage became available.
		 */
		private function onStage(evt:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			this._left = new MainBarBorderLeft() as Sprite;
			this._right = new MainBarBorderRight() as Sprite;
			this._bg = new MainBar() as Sprite;
			ManaganaInterface.setSize(this._left);
			ManaganaInterface.setSize(this._right);
			ManaganaInterface.setSize(this._bg);
			this.addChild(this._left);
			this.addChild(this._right);
			this.addChild(this._bg);
			if (!this._ondevice) {
				this._extra = new ButtonFullscreenBar() as Sprite;
				this._extra.addEventListener(MouseEvent.CLICK, onFullClick);
			} else {
				this._extra = new OfflineButtonBar() as Sprite;
				this._extra.addEventListener(MouseEvent.CLICK, onOfflineClick);
			}
			ManaganaInterface.setSize(this._extra);
			this._extra.useHandCursor = true;
			this._extra.buttonMode = true;
			this.addChild(this._extra);
			this._home = new HomeButtonBar();
			this._home.useHandCursor = true;
			this._home.buttonMode = true;
			this._home.addEventListener(MouseEvent.CLICK, onHomeClick);
			ManaganaInterface.setSize(this._home);
			this.addChild(this._home);
			this._sound = new InterfaceSoundOnOff();
			ManaganaInterface.setSize(this._sound);
			this.addChild(this._sound);
			this._sound.addEventListener(MouseEvent.CLICK, onSoundClick);
			this._plus = new InterfacePlusOnOff();
			ManaganaInterface.setSize(this._plus);
			this.addChild(this._plus);
			this._plus.addEventListener(MouseEvent.CLICK, onPlusClick);
			this._ready = true;
			
			var timebutton:Sprite = new TimeButtonBG() as Sprite;
			ManaganaInterface.setSize(timebutton);
			this._timeWidth = timebutton.width;
			timebutton = null;
			
			this.redraw();
		}
		
		// PROPERTIES
		
		/**
		 * Bar visibility.
		 */
		override public function get visible():Boolean {
			return super.visible;
		}
		override public function set visible(value:Boolean):void {
			super.visible = value;
			if (this._ready) {
				if (!value) this._plus.showPlus(true);
			}
		}
		
		/**
		 * Is sound button on mute state?
		 */
		public function get isMute():Boolean {
			return(this._sound.isMute);
		}
		public function set isMute(to:Boolean):void {
			this._sound.isMute = to;
		}
		
		/**
		 * Allow offline content?
		 */
		public function get allowOffline():Boolean {
			if (this._ondevice) {
				return (this._extra.alpha > 0.75);
			} else {
				return (false);
			}
		}
		public function set allowOffline(to:Boolean):void {
			if (this._ondevice) {
				if (to) {
					this._extra.alpha = 1;
					this._extra.buttonMode = true;
					this._extra.useHandCursor = true;
				} else {
					this._extra.alpha = 0.5;
					this._extra.buttonMode = false;
					this._extra.useHandCursor = false;
				}
			}
		}
		
		// PUBLIC METHODS
		
		/**
		 * Redraw the interface bar.
		 */
		public function redraw(leftWidth:Number = 60, rightWidth:Number = 85):void {
			if (this._ready) {
				this._left.x = this._left.y = 0;
				this._right.x = this.stage.stageWidth - 10 - this._right.width;
				this._right.y = 0;
				this._bg.x = this._left.x + this._left.width;
				this._bg.y = 0;
				this._bg.width = this._right.x - this._bg.x;
				// place buttons
				var buttonInterval:Number = (this.stage.stageWidth - 10 - MainButton.minWidth - this._timeWidth) / 4;
				
				this._home.x = leftWidth + ((buttonInterval - this._home.width) / 2);
				this._home.y = (this._bg.height - this._home.height) / 2;
				
				this._extra.x = leftWidth + buttonInterval + ((buttonInterval - this._extra.width) / 2);
				this._extra.y = (this._bg.height - this._extra.height) / 2;
				
				this._sound.x = leftWidth + (2 * buttonInterval) + ((buttonInterval - this._sound.width) / 2);
				this._sound.y = (this._bg.height - this._sound.height) / 2;
				
				this._plus.x = leftWidth + (3 * buttonInterval) + ((buttonInterval - this._plus.width) / 2);
				this._plus.y = (this._bg.height - this._plus.height) / 2;
				
				// plus menu
				if (this.plusmenu != null) this.plusmenu.redraw((this.x + (this._plus.x + (this._plus.width / 2) - (this.plusmenu.width / 2))), (this.y + this._bg.height + 5));
			}
		}
		
		/**
		 * Show/hide plus and minus signs.
		 * @param	to	true: show + and hide -, false: hide + and show -
		 */
		public function showPlus(to:Boolean):void {
			this._plus.showPlus(to);
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			if (this._ready) {
				this._sound.removeEventListener(MouseEvent.CLICK, onSoundClick);
				this._plus.removeEventListener(MouseEvent.CLICK, onPlusClick);
				this.removeChild(this._left);
				this.removeChild(this._right);
				this.removeChild(this._bg);
				this.removeChild(this._home);
				this.removeChild(this._sound);
				this.removeChild(this._plus);
				this._left = null;
				this._right = null;
				this._bg = null;
				this.removeChild(this._extra);
				if (!this._ondevice) this._extra.removeEventListener(MouseEvent.CLICK, onFullClick);
					else this._extra.removeEventListener(MouseEvent.CLICK, onOfflineClick);
				this._extra = null;
				this._home.removeEventListener(MouseEvent.CLICK, onHomeClick);
				this._home = null;
				this._sound.kill();
				this._sound = null;
				this._plus.kill();
				this._plus = null;
			} else {
				this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			}
			this.player = null;
			this.plusmenu = null;
			this.plusmenuToggle = null;
			this.homeclick = null;
			this.offlineclick = null;
			this.fullclick = null;
		}
		
		// PRIVATE METHODS
		
		/**
		 * Click on sound button.
		 */
		private function onSoundClick(evt:MouseEvent):void {
			if (this._sound.onClick()) {
				SoundMixer.soundTransform = new SoundTransform(1);
			} else {
				SoundMixer.soundTransform = new SoundTransform(0);
			}
		}
		
		/**
		 * Click on plus button.
		 */
		private function onPlusClick(evt:MouseEvent):void {
			if (!ManaganaInterface.lockExtra) {
				if (this.plusmenu != null) {
					this.plusmenu.redraw((this.x + (this._plus.x + (this._plus.width / 2) - (this.plusmenu.width / 2))), (this.y + this._bg.height + 5));
					this.plusmenu.visible = !this.plusmenu.visible;
					this._plus.showPlus(!this.plusmenu.visible);
					if (this.plusmenuToggle != null) this.plusmenuToggle(this.plusmenu.visible);
				}
			}
		}
		
		/**
		 * Fullscreen button clicked.
		 */
		private function onFullClick(evt:MouseEvent):void {
			if (this.fullclick != null) this.fullclick();
		}
		
		/**
		 * Resize button clicked.
		 */
		private function onOfflineClick(evt:MouseEvent):void {
			if ((this.offlineclick != null) && (this._extra.alpha > 0.75)) this.offlineclick(null);
		}
		
		/**
		 * Home button clicked.
		 */
		private function onHomeClick(evt:MouseEvent):void {
			if (this.homeclick != null) this.homeclick();
		}
		
	}

}
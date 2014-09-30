package art.ciclope.managana.system {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	import flash.display.Stage;
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaInterface;
	import art.ciclope.managana.ManaganaPlayer;
	import art.ciclope.managana.graphics.*;
	
	// SONY XPERIA PLAY EXTENSION
	import com.sonyericsson.airextension.TouchpadExtension;
	import com.sonyericsson.airextension.GameKeyCode;
	import com.sonyericsson.airextension.GameKeyEvent;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * XperiaPlay provides an interface to the XperiaPlay mobile phone features from Sony.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class XperiaPlay extends SystemSpecific {
		
		// CONSTANTS
		
		private const HELPWIDTH:uint = 500;		// help graphic original width
		private const HELPHEIGHT:uint = 210;	// help graphic original width
		
		// VARIABLES
		
		private var _help:Sprite;					// help sprite
		private var _xperia:TouchpadExtension;		// xperia play extension
		
		/**
		 * XperiaPlay constructor.
		 * @param	stage	the current stage
		 * @param	player	the managana player
		 * @param	interf	the managana player interface
		 */
		public function XperiaPlay(stage:Stage, player:ManaganaPlayer, interf:ManaganaInterface) {
			// prepare object
			super(stage, player, interf);
			// prepare help
			this._help = new XperiaPlayHelp() as Sprite;
			this._help.mouseEnabled = false;
			this._help.mouseChildren = false;
			this._help.visible = false;
			// check xperia play extension
			try {
				this._xperia = new TouchpadExtension();
				this._xperia.starttouchpadevents();
				this._xperia.addEventListener(GameKeyEvent.GAMEKEYPRESS, onGameKeyPress);
			} catch (e:Error) {
				// do nothing - not supported
			}
		}
		
		// PUBLIC METHODS
		
		/**
		 * Release resources used by the object.
		 */
		override public function kill():void {
			try { this._stage.removeChild(this._help); } catch (e:Error) { }
			this._help = null;
			if (this._xperia != null) {
				this._xperia.removeEventListener(GameKeyEvent.GAMEKEYPRESS, onGameKeyPress);
				this._xperia.dispose();
				this._xperia = null;
			}
			super.kill();
		}
		
		// PRIVATE METHODS
		
		/**
		 * Hide/show help graphics.
		 */
		private function toggleHelp():void {
			if (this._help.visible) { // hide help
				this._stage.removeChild(this._help);
				this._help.visible = false;
			} else { // show help
				this._help.width = this._stage.stageWidth;
				this._help.height = this._help.width * HELPHEIGHT / HELPWIDTH;
				if (this._help.height > this._stage.stageHeight) {
					this._help.height = this._stage.stageHeight;
					this._help.width = this._help.height * HELPWIDTH / HELPHEIGHT;
				}
				this._help.x = (this._stage.stageWidth - this._help.width) / 2;
				this._help.y = (this._stage.stageHeight - this._help.height) / 2;
				this._stage.addChild(this._help);
				this._help.visible = true;
			}
		}
		
		/**
		 * Catch game key presses.
		 */
		private function onGameKeyPress(evt:GameKeyEvent):void {
			// check the key
			var key:int = evt.keycode;
			switch (key) {
				case (GameKeyCode.KEYCODE_BUTTON_SELECT): // show help
					this.toggleHelp();
					break;
				case (GameKeyCode.KEYCODE_BUTTON_START): // play/pause
					if (this._player.playing) this._player.pause();
						else this._player.play();
					break;
				case (GameKeyCode.KEYCODE_BUTTON_Y): // custom function A
					this._player.runCustomFunction('A');
					break;
				case (GameKeyCode.KEYCODE_BUTTON_X): // custom function B
					this._player.runCustomFunction('B');
					break;
				case (GameKeyCode.KEYCODE_BACK): // custom function C
					this._player.runCustomFunction('C');
					break;
				case (GameKeyCode.KEYCODE_DPAD_CENTER): // custom function D
					this._player.runCustomFunction('D');
					break;
				case (GameKeyCode.KEYCODE_DPAD_LEFT): // previous X
					this._player.navigateTo('xprev');
					break;
				case (GameKeyCode.KEYCODE_DPAD_RIGHT): // next X
					this._player.navigateTo('xnext');
					break;
				case (GameKeyCode.KEYCODE_DPAD_DOWN): // previous Y
					this._player.navigateTo('yprev');
					break;
				case (GameKeyCode.KEYCODE_DPAD_UP): // next Y
					this._player.navigateTo('ynext');
					break;
			}
			try { evt.preventDefault(); } catch (e:Error) { }
		}
		
	}

}
package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	// CICLOPE CLASSES
	import art.ciclope.staticfunctions.StringFunctions;
	import art.ciclope.managana.ManaganaInterface;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * TimeButton provides a graphic interface for Managana reader time button.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class TimeButton extends Sprite {
		
		// VARIABLES
		
		private var _ready:Boolean;					// is component ready?
		private var _bg:Sprite;						// button background
		private var _time:TextField;				// time textfield
		private var _total:TextField;				// total time textfield
		private var _rotating:WaitingGraphic;		// rotating graphic
		
		private var _play:Sprite;		// the play graphic
		private var _pause:Sprite;		// the pause graphic
		private var _showPlayPause:Boolean;			// show play/pause graphic?
		
		/**
		 * TimeButton constructor.
		 */
		public function TimeButton(showPlay:Boolean = true) {
			this._ready = false;
			this._showPlayPause = showPlay;
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		/**
		 * The stage became available.
		 */
		private function onStage(evt:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			this._bg = new TimeButtonBG() as Sprite;
			ManaganaInterface.setSize(this._bg);
			this.addChild(this._bg);
			
			this._play = new ButtonPlayTime() as Sprite;
			ManaganaInterface.setSize(this._play);
			this._play.x = 10;
			this._play.y = (this._bg.height - this._play.height) / 2;
			this._play.alpha = 0.75;
			this._play.visible = false;
			if (this._showPlayPause) this.addChild(this._play);
			
			this._pause = new ButtonPauseTime() as Sprite;
			ManaganaInterface.setSize(this._pause);
			this._pause.x = 10;
			this._pause.y = (this._bg.height - this._pause.height) / 2;
			this._pause.visible = true;
			if (this._showPlayPause) this.addChild(this._pause);
			
			this._time = new TextField();
			this._time.multiline = false;
			this._time.wordWrap = false;
			if (this._showPlayPause) {
				this._time.defaultTextFormat = new TextFormat('_sans', ManaganaInterface.newSize(15), 0xFFFFFF, false, false, false, null, null, TextFormatAlign.CENTER);
				this._time.width = this._bg.width - this._play.x - this._play.width - 10;
				this._time.x = this._play.x + this._play.width + 5;
			} else {
				this._time.defaultTextFormat = new TextFormat('_sans', ManaganaInterface.newSize(17), 0xFFFFFF, false, false, false, null, null, TextFormatAlign.CENTER);
				this._time.width = this._bg.width - 10;
				this._time.x = 5;
			}
			this._time.text = "00:00";
			this._time.height = this._time.getLineMetrics(0).height + ManaganaInterface.newSize(2);
			this._time.y = ((this._bg.height - this._time.height) / 2) - ManaganaInterface.newSize(2);	
			this.addChild(this._time);
			
			this._total = new TextField();
			this._total.multiline = false;
			this._total.wordWrap = false;
			if (this._showPlayPause) {
				this._total.defaultTextFormat = new TextFormat('_sans', ManaganaInterface.newSize(11), 0xFFFFFF, false, false, false, null, null, TextFormatAlign.CENTER);
				this._total.width = this._bg.width - this._play.x - this._play.width - 10;
				this._total.x = this._play.x + this._play.width + 5;
			} else {
				this._total.defaultTextFormat = new TextFormat('_sans', ManaganaInterface.newSize(12), 0xFFFFFF, false, false, false, null, null, TextFormatAlign.CENTER);
				this._total.width = this._bg.width - 10;
				this._total.x = 5;
			}
			this._total.height = this._total.getLineMetrics(0).height + ManaganaInterface.newSize(2);
			this._total.y = ((this._bg.height - this._total.height) / 2) - ManaganaInterface.newSize(2);	
			this.addChild(this._total);
			this._total.visible = false;
			
			this._rotating = new WaitingGraphic();
			ManaganaInterface.setSize(this._rotating);
			this._rotating.x = this._bg.width / 2;
			this._rotating.y = this._bg.height / 2;
			this._rotating.visible = false;
			this.addChild(this._rotating);
			this.mouseChildren = false;
			this.useHandCursor = true;
			this.buttonMode = true;
			this._ready = true;
			this.redraw();
		}
		
		// PROPERTIES
		
		/**
		 * Is component background visible?
		 */
		public function get bgVisible():Boolean {
			return (this._bg.visible);
		}
		public function set bgVisible(to:Boolean):void {
			this._bg.visible = to;
		}
		
		/**
		 * Show play state.
		 */
		public function get playVisible():Boolean {
			return (this._total.alpha < 1);
		}
		public function set playVisible(to:Boolean):void {
			if (to) {
				this._total.alpha = 0.75;
				this._time.alpha = 0.75;
			} else {
				this._total.alpha = 1;
				this._time.alpha = 1;
			}
			this._play.visible = to;
			this._pause.visible = !to;
		}
		
		// PUBLIC METHODS
		
		/**
		 * Start waiting animation.
		 */
		public function startWaiting():void {
			this._time.visible = false;
			this._total.visible = false;
			this._rotating.visible = true;
			this._play.alpha = 0;
			this._pause.alpha = 0;
		}
		
		/**
		 * Stop waiting animation.
		 */
		public function stopWaiting():void {
			this._time.visible = true;
			this._total.visible = true;
			this._rotating.visible = false;
			this._play.alpha = 0.75;
			this._pause.alpha = 1;
		}
		
		/**
		 * Set the current and total time of the player stream.
		 * @param	current	the current time
		 * @param	total	the total time (0 for infinite)
		 */
		public function setTime(current:uint, total:uint):void {
			this._time.text = StringFunctions.parseSeconds(current);
			this._time.height = this._time.getLineMetrics(0).height + ManaganaInterface.newSize(2);
			if (total == 0) {
				this._time.y = ((this._bg.height - this._time.height) / 2) - ManaganaInterface.newSize(2);	
				this._total.text = "";
			} else {
				if (this._showPlayPause) this._time.y = 13;
					else this._time.y = 10;
				this._total.text = StringFunctions.parseSeconds(total);
				this._total.height = this._total.getLineMetrics(0).height + ManaganaInterface.newSize(2);
				var dist:Number = (this._bg.height - this._time.height - this._total.height) / 2;
				this._time.y = dist - ManaganaInterface.newSize(2);
				this._total.y = this._bg.height - dist - this._total.height;
			}
		}
		
		/**
		 * Redraw component.
		 */
		public function redraw():void {
			if (this._ready) {
				this.y = 5;
				this.x = this.stage.stageWidth - this._bg.width - 5;
			}
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			if (this._ready) {
				this.removeChild(this._bg);
				this._bg = null;
				this.removeChild(this._time);
				this._time = null;
			} else {
				this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			}
		}
	}

}
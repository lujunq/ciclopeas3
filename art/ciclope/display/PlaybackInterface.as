package art.ciclope.display {
	
	// FLASH PACKAGES
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	// CICLOPE CLASSES
	import art.ciclope.util.MediaDefinitions;
	import art.ciclope.util.LoadedFile;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * PlaybackInterface creates an simple interface for video playback management by the user on VideoSprite objects.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class PlaybackInterface extends Sprite {
		
		// GRAPHICS
		
		/**
		 * Graphics for buttons and slider
		 */
		[Embed( source = "../resource/PlayButton.png" )] private const PlayButton:Class;
		[Embed( source = "../resource/PauseButton.png" )] private const PauseButton:Class;
		[Embed( source = "../resource/SlideBar.png" )] private const SlideBar:Class;
		[Embed( source = "../resource/SlideCursor.png" )] private const SlideCursor:Class;
		[Embed( source = "../resource/SlideCursorUp.png" )] private const SlideCursorUp:Class;
		[Embed( source = "../resource/SlideBackground.png" )] private const SlideBackground:Class;
		[Embed( source = "../resource/SlidePlus.png" )] private const SlidePlus:Class;
		[Embed( source = "../resource/SlideMinus.png" )] private const SlideMinus:Class;
		[Embed( source = "../resource/SlidePlusUp.png" )] private const SlidePlusUp:Class;
		[Embed( source = "../resource/SlideMinusUp.png" )] private const SlideMinusUp:Class;
		
		// VARIABLES
		
		private var _playButton:Sprite;			// the play button
		private var _pauseButton:Sprite;		// the pause button
		private var _slider:Sprite;				// the slider bar
		private var _cursor:Sprite;				// the slider cursor
		private var _bg:Sprite;					// interface background
		private var _plus:Sprite;				// interface plus
		private var _minus:Sprite;				// interface minus
		private var _play:Function;				// function to play media
		private var _pause:Function;			// function to pause media
		private var _seek:Function;				// function to seek media (percent)
		private var _dragging:Boolean;			// dragging slider cursor?
		private var _stage:Stage;				// stage reference
		private var _showplay:Boolean;			// show play button (hide pause)?
		private var _slidefactor:Number;		// slider position multiply factor
		
		/**
		 * PlaybackInterface constructor.
		 * @param	play	the VideoSprite play function reference
		 * @param	pause	the VideoSprite pause function reference
		 * @param	seek	the VideoSprite seek function reference
		 */
		public function PlaybackInterface(play:Function, pause:Function, seek:Function) {
			// create graphics
			var gr:Bitmap;
			this._bg = new Sprite();
			gr = new SlideBackground() as Bitmap;
			gr.smoothing = true;
			this._bg.addChild(gr);
			this._plus = new Sprite();
			gr = new SlidePlus() as Bitmap;
			gr.smoothing = true;
			this._plus.addChild(gr);
			this._minus = new Sprite();
			gr = new SlideMinus() as Bitmap;
			gr.smoothing = true;
			this._minus.addChild(gr);
			this._playButton = new Sprite();
			gr = new PlayButton() as Bitmap;
			gr.smoothing = true;
			this._playButton.addChild(gr);
			this._pauseButton = new Sprite();
			gr = new PauseButton() as Bitmap;
			gr.smoothing = true;
			this._pauseButton.addChild(gr);
			this._slider = new Sprite();
			gr = new SlideBar() as Bitmap;
			gr.smoothing = true;
			this._slider.addChild(gr);
			this._cursor = new Sprite();
			gr = new SlideCursor() as Bitmap;
			gr.smoothing = true;
			this._cursor.addChild(gr);
			// add graphics
			this.addChild(this._bg);
			this.addChild(this._slider);
			this.addChild(this._plus)
			this.addChild(this._minus);
			this.addChild(this._cursor);
			this.addChild(this._playButton);
			this.addChild(this._pauseButton);
			this._slider.mouseEnabled = false;
			// place graphics
			this._bg.x = this._bg.y = 0;
			this._bg.width = 164;
			this._minus.y = this._plus.y = 0;
			this._plus.x = 0;
			this._minus.x = this._bg.width;
			this._pauseButton.x = this._playButton.x = 3;
			this._pauseButton.y = this._playButton.y = 3;
			this._slider.x = this._cursor.x = this._playButton.width + 3;
			this._slider.y = this._cursor.y = 3;
			this._slidefactor = 1;
			// assign action functions
			this._play = play;
			this._pause = pause;
			this._seek = seek;
			this._showplay = true;
			this._playButton.addEventListener(MouseEvent.CLICK, onPlay);
			this._pauseButton.addEventListener(MouseEvent.CLICK, onPause);
			this._playButton.buttonMode = true;
			this._playButton.useHandCursor = true;
			this._pauseButton.buttonMode = true;
			this._pauseButton.useHandCursor = true;
			this._cursor.addEventListener(MouseEvent.MOUSE_DOWN, cursorStartDrag);
			this._dragging = false;
			this._plus.visible = false;
			this._plus.buttonMode = true;
			this._plus.useHandCursor = true;
			this._minus.buttonMode = true;
			this._minus.useHandCursor = true;
			this._plus.addEventListener(MouseEvent.CLICK, onPlus);
			this._minus.addEventListener(MouseEvent.CLICK, onMinus);
			// wait for the stage to become available
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		// PROPERTIES
		
		/**
		 * Minimum width to show control.
		 */
		public function get minimumWidth():uint {
			return(uint(this._minus.x + this._minus.width));
		}
		
		/**
		 * Minimum height to show control.
		 */
		public function get minimumHeight():uint {
			return(uint(this._playButton.height + 6));
		}
		
		// PUBLIC METHODS
		
		/**
		 * Check if the control can be shown.
		 * @param	w	the container width
		 * @param	h	the container height
		 * @param	type	media type loaded
		 */
		public function checkView(w:Number, h:Number, type:String = LoadedFile.TYPE_AUDIO):void {
			if ((w >= this.minimumWidth) && (h >= this.minimumHeight)) {
				this.alpha = 0.5;
				this.mouseChildren = true;
				this.x = -w / 2;
				this.y = (h / 2) - this.minimumHeight;
				this._bg.width = 164;
				this._minus.x = this._bg.width;
			} else {
				this.alpha = 0;
				this.mouseChildren = false;
			}
		}
		
		/**
		 * Set buttons according to playback state.
		 * @param	to	current playback state
		 */
		public function setButtons(to:String):void {
			if (to == MediaDefinitions.PLAYBACKSTATE_PLAY) {
				this._playButton.visible = false;
				this._pauseButton.visible = true;
				this._showplay = false;
			} else {
				this._playButton.visible = true;
				this._pauseButton.visible = false;
				this._showplay = true;
			}
		}
		
		/**
		 * Set playback cursor position.
		 * @param	to	percent of file played
		 */
		public function setProgress(to:uint):void {
			if (!this._dragging) this._cursor.x = this._slider.x + (to * this._slidefactor);
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			// remove listeners
			this._playButton.removeEventListener(MouseEvent.CLICK, onPlay);
			this._pauseButton.removeEventListener(MouseEvent.CLICK, onPause);
			this._cursor.removeEventListener(MouseEvent.MOUSE_DOWN, cursorStartDrag);
			this._plus.removeEventListener(MouseEvent.CLICK, onPlus);
			this._minus.removeEventListener(MouseEvent.CLICK, onMinus);
			if (this.hasEventListener(Event.ADDED_TO_STAGE)) {
				this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			} else {
				this._stage.removeEventListener(MouseEvent.MOUSE_UP, cursorStopDrag);
				this._stage = null;
			}
			// clear sprites
			while (this.numChildren > 0) {
				var sp:Sprite = Sprite(this.getChildAt(0));
				var bm:Bitmap = Bitmap(sp.getChildAt(0));
				sp.removeChild(bm);
				bm.bitmapData.dispose();
				this.removeChild(sp);
				bm = null;
				sp = null;
			}
			// clear functions
			this._pause = null;
			this._play = null;
			this._seek = null;
		}
		
		// PRIVATE METHODS
		
		/**
		 * Play media.
		 */
		private function onPlay(evt:MouseEvent):void {
			this._play();
		}
		
		/**
		 * Pause media.
		 */
		private function onPause(evt:MouseEvent):void {
			this._pause();
		}
		
		/**
		 * Start playback cursor drag.
		 */
		private function cursorStartDrag(evt:MouseEvent):void {
			if (this.visible) {
				this._dragging = true;
				this._cursor.startDrag(false, new Rectangle(this._slider.x, this._slider.y, this._slider.width, 0));
			}
		}
		
		/**
		 * Stop Playback cursor drag.
		 */
		private function cursorStopDrag(evt:MouseEvent):void {
			if (this._dragging) {
				this._cursor.stopDrag();
				this._seek(uint((this._cursor.x - this._slider.x) / this._slidefactor));
				this._dragging = false;
			}
		}
		
		/**
		 * Listen to mouse up when stage is available.
		 */
		private function onStage(evt:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			this._stage = stage;
			this._stage.addEventListener(MouseEvent.MOUSE_UP, cursorStopDrag);
		}
		
		/**
		 * Hide interface bar.
		 */
		private function onMinus(evt:MouseEvent):void {
			this._bg.visible = false;
			this._slider.visible = false;
			this._cursor.visible = false;
			this._playButton.visible = false;
			this._pauseButton.visible = false;
			this._minus.visible = false;
			this._plus.visible = true;
		}
		
		/**
		 * Show interface bar.
		 */
		private function onPlus(evt:MouseEvent):void {
			this._bg.visible = true;
			this._slider.visible = true;
			this._cursor.visible = true;
			this._playButton.visible = this._showplay;
			this._pauseButton.visible = !this._showplay;
			this._minus.visible = true;
			this._plus.visible = false;
		}
		
		
	}

}
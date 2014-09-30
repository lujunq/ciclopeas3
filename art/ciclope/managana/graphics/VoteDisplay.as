package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import art.ciclope.display.GraphicSprite;
	import art.ciclope.event.CustomEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.display.BlendMode;
	
	// CICLOPE CLASSES
	import art.ciclope.display.AnimSprite;
	import art.ciclope.util.Placing;
	import art.ciclope.event.Loading;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * VoteDisplay creates a feedback display for votes on Managana streams.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class VoteDisplay extends Sprite {
		
		// VARIABLES
		
		private var _select:GraphicSprite;		// selected vote graphic
		private var _display:AnimSprite;		// the display graphic
		private var _id:TextField;				// the display vote number id
		private var _format:TextFormat;			// formatting for text display
		private var _numVotes:uint;				// current number of votes
		
		// PUBLIC VARIABLES
		
		/**
		 * Is the vote number enabled to current stream?
		 */
		public var enabled:Boolean = false;
		
		/**
		 * VoteDisplay cosntructor.
		 * @param	num	the vote number reference (from 1 to 9).
		 * @param	graphic	an array with the vote display graphic urls
		 */
		public function VoteDisplay(num:uint, graphic:Array) {
			// initial data
			this._numVotes = 0;
			// text format
			this._format = new TextFormat("_sans", 18, 0xFFFFFF, true, null, null, null, null, TextFormatAlign.CENTER);
			// vote text
			this._id = new TextField();
			this._id.multiline = false;
			this._id.wordWrap = false;
			this._id.selectable = false;
			this._id.defaultTextFormat = this._format;
			this._id.text = String(num);
			this._id.filters = new Array(new GlowFilter(0, 0.75, 5, 5, 1));
			this.addChild(this._id);
			// set graphics
			this.setGraphics(graphic);
			// click
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.CLICK, onClick);
			this.useHandCursor = true;
			this.buttonMode = true;
		}
		
		// READ-ONLY VALUES
		
		/**
		 * The vote ID (1 to 9).
		 */
		public function get voteID():uint {
			return (uint(this._id.text));
		}
		
		/**
		 * The number of votes for this selection.
		 */
		public function get numVotes():uint {
			return (this._numVotes);
		}
		
		// PROPERTIES
		
		/**
		 * Is this vote selected?
		 */
		public function get selected():Boolean {
			//return (this._select.visible);
			return (this._display.blendMode != BlendMode.NORMAL);
		}
		public function set selected(to:Boolean):void {
			//this._select.visible = to;
			if (to) {
				this._display.blendMode = BlendMode.INVERT;
			} else {
				this._display.blendMode = BlendMode.NORMAL;
			}
		}
		
		// PUBLIC METHODS
		
		/**
		 * Set the number of votes.
		 * @param	current	the current number of votes for this selection
		 * @param	total	the total votes received
		 */
		public function setVotes(current:uint, total:uint):void {
			this._numVotes = current;
			if ((current == 0) || (total == 0)) {
				this._display.gotoAndStop(0);
			} else if (current == total) {
				this._display.gotoAndStop(10);
			} else {
				var percent:uint = uint(Math.round(100 * current / total));
				if (percent < 10) this._display.gotoAndStop(1);
				else if (percent < 20) this._display.gotoAndStop(2);
				else if (percent < 30) this._display.gotoAndStop(3);
				else if (percent < 40) this._display.gotoAndStop(4);
				else if (percent < 50) this._display.gotoAndStop(5);
				else if (percent < 60) this._display.gotoAndStop(6);
				else if (percent < 70) this._display.gotoAndStop(7);
				else if (percent < 80) this._display.gotoAndStop(8);
				else if (percent < 90) this._display.gotoAndStop(9);
				else this._display.gotoAndStop(10);
			}
			if (this._id != null) {
				this._id.height = this._format.size + 4;
				this._id.width = this._display.width;
				this._id.text = this._id.text;
				this._id.x = 0;
				this._id.y = (this._display.height - this._id.height) / 2;
			}
		}
		
		/**
		 * Set voting graphics to the default ones.
		 * @param	graphic	an array with display graphic urls
		 */
		public function setGraphics(graphic:Array):void {
			// selected graphic
			if (this._select != null) {
				this.removeChild(this._select);
				this._select.kill();
			}
			var selectGraphic:Sprite = new VoteSelect() as Sprite;
			this._select = new GraphicSprite(selectGraphic.width, selectGraphic.height);
			this._select.setContent(selectGraphic);
			this._select.width = this._select.originalWidth;
			this._select.height = this._select.originalHeight;
			this._select.visible = false;
			this.addChild(this._select);
			// vote levels
			if (this._display != null) {
				if (this._display.hasEventListener(Loading.QUEUE_END)) this._display.removeEventListener(Loading.QUEUE_END, onAllFrames);
				this.removeChild(this._display);
				this._display.kill();
			}
			this._display = new AnimSprite();
			this._display.addEventListener(Loading.QUEUE_END, onAllFrames);
			if (graphic['0'] == "") this._display.addFrame(new Vote000() as Sprite, Placing.TOPLEFT);
				else this._display.loadFrame(graphic['0'], Placing.TOPLEFT);
			if (graphic['10'] == "") this._display.addFrame(new Vote010() as Sprite, Placing.TOPLEFT);
				else this._display.loadFrame(graphic['10'], Placing.TOPLEFT);
			if (graphic['20'] == "") this._display.addFrame(new Vote020() as Sprite, Placing.TOPLEFT);
				else this._display.loadFrame(graphic['20'], Placing.TOPLEFT);
			if (graphic['30'] == "") this._display.addFrame(new Vote030() as Sprite, Placing.TOPLEFT);
				else this._display.loadFrame(graphic['30'], Placing.TOPLEFT);
			if (graphic['40'] == "") this._display.addFrame(new Vote040() as Sprite, Placing.TOPLEFT);
				else this._display.loadFrame(graphic['40'], Placing.TOPLEFT);
			if (graphic['50'] == "") this._display.addFrame(new Vote050() as Sprite, Placing.TOPLEFT);
				else this._display.loadFrame(graphic['50'], Placing.TOPLEFT);
			if (graphic['60'] == "") this._display.addFrame(new Vote060() as Sprite, Placing.TOPLEFT);
				else this._display.loadFrame(graphic['60'], Placing.TOPLEFT);
			if (graphic['70'] == "") this._display.addFrame(new Vote070() as Sprite, Placing.TOPLEFT);
				else this._display.loadFrame(graphic['70'], Placing.TOPLEFT);
			if (graphic['80'] == "") this._display.addFrame(new Vote080() as Sprite, Placing.TOPLEFT);
				else this._display.loadFrame(graphic['80'], Placing.TOPLEFT);
			if (graphic['90'] == "") this._display.addFrame(new Vote090() as Sprite, Placing.TOPLEFT);
				else this._display.loadFrame(graphic['90'], Placing.TOPLEFT);
			if (graphic['100'] == "") this._display.addFrame(new Vote100() as Sprite, Placing.TOPLEFT);
				else this._display.loadFrame(graphic['100'], Placing.TOPLEFT);
			this._display.gotoAndStop(0);
			this._display.smoothing = true;
			this._display.blendMode = BlendMode.NORMAL;
			this.addChild(this._display);
			// text display
			this.removeChild(this._id);
			this._id.defaultTextFormat = this._format;
			this._id.height = this._format.size + 4;
			this._id.width = this._display.width;
			this._id.text = this._id.text;
			this._id.x = 0;
			this._id.y = (this._display.height - this._id.height) / 2;
			this.addChild(this._id);
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			this.removeChild(this._select);
			this._select.kill();
			this._select = null;
			this.removeChild(this._display);
			this._display.kill();
			this._display = null;
			this.removeChild(this._id);
			this._id = null;
			this._format = null;
			this.removeEventListener(MouseEvent.CLICK, onClick);
		}
		
		// PRIVATE METHODS
		
		/**
		 * Mouse click on vote graphic.
		 */
		private function onClick(evt:MouseEvent):void {
			//this._select.visible = !this._select.visible;
			if (this._display.blendMode == BlendMode.NORMAL) this._display.blendMode = BlendMode.INVERT;
				else this._display.blendMode = BlendMode.NORMAL;
			this.dispatchEvent(new CustomEvent(CustomEvent.CUSTOM_UINT, String(this.voteID)));
		}
		
		/**
		 * All vote graphics were downloaded.
		 */
		private function onAllFrames(evt:Loading):void {
			this.removeChild(this._id);
			this._id.defaultTextFormat = this._format;
			this._id.height = this._format.size + 4;
			this._id.width = this._display.width;
			this._id.text = this._id.text;
			this._id.x = 0;
			this._id.y = (this._display.height - this._id.height) / 2;
			this.addChild(this._id);
		}
		
	}

}
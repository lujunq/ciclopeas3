package art.ciclope.display {
	
	// FLASH PACKAGES
	import flash.display.DisplayObject;
	import flash.events.TransformGestureEvent;
	
	// CICLOPE CLASSES
	import art.ciclope.util.PageDescription;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * MultiSequencePages extends MediaPages to enable several simultaneous page sequences.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 * @see	art.ciclope.util.PageDescription
	 */
	public class MultiSequencePages extends MediaPages {
		
		// PUBLIC CONSTANTS
		
		/**
		 * Do not use swipe gesture.
		 */
		public static const SWIPE_NONE:String = "SWIPE_NONE";
		/**
		 * Use swipe gestures to move next and previous on a singe sequence only (left and right).
		 */
		public static const SWIPE_NEXTPREVIOUS:String = "SWIPE_NEXTPREVIOUS";
		/**
		 * Use swipe gestures to change among sequences only (up and down).
		 */
		public static const SWIPE_UPDOWN:String = "SWIPE_UPDOWN";
		/**
		 * Use swipe gestures to change both pages and sequences (will prefer next/previous).
		 */
		public static const SWIPE_BOTH:String = "SWIPE_BOTH";
		
		// VARIABLES
		
		/**
		 * A collection of page sequences.
		 */
		private var _timelines:Array;
		/**
		 * The transition to use when moving "up" on page sequences.
		 */
		private var _upTransition:String;
		/**
		 * The transition to use when moving "down" on page sequences.
		 */
		private var _downTransition:String;
		/**
		 * The current sequence number.
		 */
		private var _currentSequence:uint;
		
		// PUBLIC VARIABLES
		
		/**
		 * When showing a new sequence, open it at firts page? If false, system will try to open at the same page number, but will open at first page if it is not possible. The PageDescription's upPage and downPage properties overrides this option.
		 */
		public var firstPageOnSequence:Boolean = true;
		/**
		 * Calling downSequence at last sequence will show the first one? Calling upSequence at first sequence will show the last one?
		 */
		public var loopSequences:Boolean = true;
		/**
		 * The swipe gestures mode. Check swipe constants.
		 */
		public var swipeMode:String = MultiSequencePages.SWIPE_BOTH;
		
		/**
		 * MultiSequencePages constructor.
		 * @param	width	The display width.
		 * @param	height	The display height.
		 * @param	audioIcon	An icon to be used when playing audio.
		 * @param	defaultTransition	The default transition animation of this display (see MediaDisplay transition constants).
		 * @param	nextTransition	The transition animation to use when calling the next page (see MediaDisplay transition constants).
		 * @param	previousTransition	The transition animation to use when calling the previous page (see MediaDisplay transition constants).
		 * @param	upTransition	The transition to use when moving "up" on page sequences.
		 * @param	downTransition	The transition to use when moving "down" on page sequences.
		 * @param	update	The transition animation time in miliseconds.
		 * @param	steps	The transition animation steps.
		 * @param	bgcolor	The background color.
		 * @param	transparent	Should the background be transparent?
		 */
		public function MultiSequencePages(width:Number = 160, height:Number = 90, audioIcon:DisplayObject = null, defaultTransition:String = MediaDisplay.TRANSITION_FADE, nextTransition:String = MediaDisplay.TRANSITION_LEFT, previousTransition:String = MediaDisplay.TRANSITION_RIGHT, upTransition:String = MediaDisplay.TRANSITION_UP, downTransition:String = MediaDisplay.TRANSITION_DOWN, update:uint = 1000, steps:uint = 12, bgcolor:uint = 0, transparent:Boolean = true) {
			// assign values
			this._timelines = new Array();
			this._upTransition = upTransition;
			this._downTransition = downTransition;
			this._currentSequence = 0;
			// creating display
			super(width, height, audioIcon, defaultTransition, nextTransition, previousTransition, update, steps, bgcolor, transparent);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Create a new page sequence.
		 * @param	pages	An optional array of page descriptions to populate the new sequence.
		 * @see	art.ciclope.util.PageDescription
		 */
		public function createSequence(pages:Array = null):void {
			this._timelines.push(new Array());
			if (pages) this.addPages((this._timelines.length - 1), pages);
			if (this._timelines.length == 1) {
				this._pages = this._timelines[0];
				if (pages) this.setPage(0);
			}
		}
		
		/**
		 * Add a page description array to a sequence.
		 * @param	sequence	The sequence number to use.
		 * @param	pages	An array of page descriptions to add to the sequence.
		 * @return	True if the requested sequence exist and can receive the pages, false othewise.
		 * @see	art.ciclope.util.PageDescription
		 */
		public function addPages(sequence:uint, pages:Array):Boolean {
			var setFirst:Boolean = false;
			if ((this._timelines.length == 1) && (this._timelines[0].length == 0)) setFirst = true;
			if (sequence < this._timelines.length) {
				for (var index:uint = 0; index < pages.length; index++) {
					this._timelines[sequence].push(pages[index]);
				}
				if (setFirst) this.setPage(0);
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Add a single page description to a sequence.
		 * @param	sequence	The sequence number to use.
		 * @param	page	A single page description
		 * @return	True if the requested sequence exist and can receive the pages, false othewise.
		 * @see	art.ciclope.util.PageDescription
		 */
		public function addPageToSequence(sequence:uint, page:PageDescription):Boolean {
			if (sequence < this._timelines.length) {
				this._timelines[sequence].push(page);
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Set the current sequence.
		 * @param	to	The sequence number to open.
		 * @param	transition	The transition to use (leave null for default).
		 * @param	forcedPage	The sequence page number to show. Will look for firstPageOnSequence option if this parameter is not set.
		 * @return	True if the sequence and page request is valid, false otherwise.
		 */
		public function setSequence(to:uint, transition:String = null, forcedPage:uint = NaN):Boolean {
			if (to < this._timelines.length) {
				this._pages = this._timelines[to];
				var ret:Boolean;
				if (isNaN(forcedPage)) {
					if (this.firstPageOnSequence) {
						ret = this.setPage(0, transition);
					} else {
						if (this._current < this.numPages) {
							ret = this.setPage(this._current, transition);
						} else {
							ret = this.setPage(0, transition);
						}
					}
				} else {
					ret = this.setPage(forcedPage, transition);
				}
				if (ret) {
					this._currentSequence = to;
				} else {
					this._pages = this._timelines[this._currentSequence];
				}
				return (ret);
			} else {
				return (false);
			}
		}
		
		/**
		 * Open the upper sequence.
		 * @param	transition	The transition to use. Leave null for the default up one.
		 */
		public function upSequence(transition:String = null):void {
			var trans:String = this._upTransition;
			if (transition) trans = transition;
			var toSequence:int = this._currentSequence - 1;
			if (toSequence < 0) {
				if (this.loopSequences) this.setSequence((this._timelines.length - 1), trans, this.currentPage.upPage);
			} else {
				this.setSequence(toSequence, trans, this.currentPage.upPage);
			}
		}
		
		/**
		 * Open the lower sequence.
		 * @param	transition	The transition to use. Leave null for the default down one.
		 */
		public function downSequence(transition:String = null):void {
			var trans:String = this._downTransition;
			if (transition) trans = transition;
			var toSequence:int = this._currentSequence + 1;
			if (toSequence >= this._timelines.length) {
				if (this.loopSequences) this.setSequence(0, trans, this.currentPage.downPage);
			} else {
				this.setSequence(toSequence, trans, this.currentPage.downPage);
			}
		}
		
		/**
		 * Release memory used by this object.
		 */
		override public function kill():void {
			// array
			this._pages = new Array();
			while (this._timelines.length > 0) {
				while (this._timelines[0].length > 0) this._timelines[0].shift();
				this._timelines.shift();
			}
			// values
			this._upTransition = null;
			this._downTransition = null;
			this.swipeMode = null;
			// parent
			super.kill();
		}
		
		// PROPERTIES
		
		/**
		 * The number of available page sequences.
		 */
		public function get sequences():uint {
			return (this._timelines.length);
		}
		
		// PRIVATE METHODS
		
		/**
		 * Change pages using gestures.
		 */
		override protected function gestureSwipe(evt:TransformGestureEvent):void {
			if (this.swipeMode == MultiSequencePages.SWIPE_NONE) {
				// do nothing
			} else {
				if (this.allowGestures) {
					if (this.swipeMode == MultiSequencePages.SWIPE_NEXTPREVIOUS) {
						if ((this.rotation >= -90) && (this.rotation <= 90)) {
							if (evt.offsetX > 0) this.previous();
							else if (evt.offsetX < 0) this.next();
						} else {
							if (evt.offsetX > 0) this.previous(this._nextTransition);
							else if (evt.offsetX < 0) this.next(this._previousTransition);
						}
					} else if (this.swipeMode == MultiSequencePages.SWIPE_UPDOWN) {
						if ((this.rotation >= -90) && (this.rotation <= 90)) {
							if (evt.offsetY > 0) this.downSequence();
							else if (evt.offsetY < 0) this.upSequence();
						} else {
							if (evt.offsetY > 0) this.downSequence(this._upTransition);
							else if (evt.offsetY < 0) this.upSequence(this._downTransition);
						}
					} else {
						var nextprevious:Boolean = true;
						if ((evt.offsetX * evt.offsetX) < (evt.offsetY * evt.offsetY)) nextprevious = false;
						if (nextprevious) {
							if ((this.rotation >= -90) && (this.rotation <= 90)) {
								if (evt.offsetX > 0) this.previous();
								else if (evt.offsetX < 0) this.next();
							} else {
								if (evt.offsetX > 0) this.previous(this._nextTransition);
								else if (evt.offsetX < 0) this.next(this._previousTransition);
							}
						} else {
							if ((this.rotation >= -90) && (this.rotation <= 90)) {
								if (evt.offsetY > 0) this.downSequence();
								else if (evt.offsetY < 0) this.upSequence();
							} else {
								if (evt.offsetY > 0) this.downSequence(this._upTransition);
								else if (evt.offsetY < 0) this.upSequence(this._downTransition);
							}
						}
					}
				}
			}
		}
		
	}

}
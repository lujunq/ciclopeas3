package art.ciclope.display {
	
	// FLASH PACKAGES
	import flash.events.MouseEvent;
	import flash.ui.Multitouch;
	import flash.display.DisplayObject;
	import flash.events.TouchEvent;
	import flash.events.TransformGestureEvent;
	import flash.ui.MultitouchInputMode;
	
	// CICLOPE CLASSES
	import art.ciclope.util.PageDescription;
	import art.ciclope.util.LoadedFile;
	import art.ciclope.util.Placing;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * MediaPages extends MediaDisplay to create a "page" sequence of media files and handle them.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 * @see	art.ciclope.util.PageDescription
	 */
	public class MediaPages extends MediaDisplay {
		
		// VARIABLES
		
		/**
		 * The pages reference.
		 */
		protected var _pages:Array;
		/**
		 * The current page.
		 */
		protected var _current:uint;
		/**
		 * The default transition animation for pages.
		 */
		protected var _defaultTransition:String;
		/**
		 * The transition animation to use when calling next.
		 */
		protected var _nextTransition:String;
		/**
		 * The transition animation to use when calling previous.
		 */
		protected var _previousTransition:String;
		
		// PUBLIC VARIABLES
		
		/**
		 * Allow this object to receive mouse or gesture input?
		 */
		public var allowGestures:Boolean = true;
		/**
		 * Calling next at last page will show the first one? Calling preivous at first page will show the last one?
		 */
		public var loopPages:Boolean = true;
		
		/**
		 * MediaPages constructor.
		 * @param	width	The display width.
		 * @param	height	The display height.
		 * @param	audioIcon	An icon to be used when playing audio.
		 * @param	defaultTransition	The default transition animation of this display (see MediaDisplay transition constants).
		 * @param	nextTransition	The transition animation to use when calling the next page (see MediaDisplay transition constants).
		 * @param	previousTransition	The transition animation to use when calling the previous page (see MediaDisplay transition constants).
		 * @param	update	The transition animation time in miliseconds.
		 * @param	steps	The transition animation steps.
		 * @param	bgcolor	The background color.
		 * @param	transparent	Should the background be transparent?
		 */
		public function MediaPages(width:Number = 160, height:Number = 90, audioIcon:DisplayObject = null, defaultTransition:String = MediaDisplay.TRANSITION_FADE, nextTransition:String = MediaDisplay.TRANSITION_LEFT, previousTransition:String = MediaDisplay.TRANSITION_RIGHT, update:uint = 1000, steps:uint = 12, bgcolor:uint = 0, transparent:Boolean = true) {
			// create the display
			super(width, height, audioIcon, defaultTransition, update, steps, bgcolor, transparent);
			// set data
			this._defaultTransition = defaultTransition;
			this._nextTransition = nextTransition;
			this._previousTransition = previousTransition;
			this._current = 0;
			this._pages = new Array();
			// add touch events?
			if (Multitouch.supportsGestureEvents) {					
				Multitouch.inputMode = MultitouchInputMode.GESTURE;
				var gestures:Vector.<String> = Multitouch.supportedGestures;
				for each (var s:String in gestures) {
					switch (s) {
						case "gestureZoom":
							this.addEventListener(TransformGestureEvent.GESTURE_ZOOM, gestureZoom);
							break;
						case "gestureRotate":
							this.addEventListener(TransformGestureEvent.GESTURE_ROTATE, gestureRotate);
							break;
						case "gesturePan":
							this.addEventListener(TransformGestureEvent.GESTURE_PAN, gesturePan);
							break;
						case "gestureSwipe":
							this.addEventListener(TransformGestureEvent.GESTURE_SWIPE, gestureSwipe);
							break;
					}
				}
			} else {
				// add mouse-driven events
				this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
		}
		
		// PUBLIC METHODS
		
		/**
		 * Adds a page to the list.
		 * @param	page	A PageDescription object containing page data.
		 * @see	art.ciclope.util.PageDescription
		 */
		public function addPage(page:PageDescription):void {
			if (page.type == "") page.type = LoadedFile.typeOf(page.path);
			if (this._pages.push(page)) this.setPage(0);
		}
		
		/**
		 * Set the current page.
		 * @param	to	The page number to show.
		 * @param	transition	The transition to use. Leave null for the default one.
		 * @return	True if the page exists and can be loaded, false otherwise.
		 */
		public function setPage(to:uint, transition:String = null):Boolean {
			if (to < this._pages.length) {
				var ret:Boolean = true;
				if (transition != null) this.transition = transition;
				else this.transition = this._defaultTransition;
				switch (this._pages[to].type) {
					case (LoadedFile.TYPE_PICTURE):
						if (this._pages[to].path == "") {
							if (this._pages[to].resource is DisplayObject) {
								this.setGraphic(this._pages[to].resource);
							} else ret = false;
						} else {
							this.loadFile(this._pages[to].path);
						}
						break;
					case (LoadedFile.TYPE_ANIMATION):
						if (this._pages[to].resource is Array) {
							if (Placing.isPlacing(this._pages[0].param)) this.loadAnimation(this._pages[to].resource, this._pages[0].param);
							else this.loadAnimation(this._pages[to].resource);
						} else ret = false;
						break;
					case (LoadedFile.TYPE_TEXT):
						if (this._pages[to].path == "") {
							if (this._pages[to].resource is String) {
								if (this._pages[0].param == LoadedFile.SUBTYPE_HTML) this.setHTMLText(this._pages[to].resource);
								else this.setText(this._pages[to].resource);
							} else ret = false;
						} else {
							this.loadFile(this._pages[to].path);
						}
						break;
					default:
						this.loadFile(this._pages[to].path);
						break;
				}
				this._current = to;
				return (ret);
			} else {
				return (false);
			}
		}
		
		/**
		 * Remove a single page.
		 * @param	num	The page number to remove.
		 * @return	True if the page exists and can be removes, false otherwise.
		 */
		public function removePage(num:uint):Boolean {
			if (num < this._pages.length) {
				this._pages.splice(num, 1);
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Replace a single page.
		 * @param	num	The page number to remove.
		 * @return	True if the page exists and can be removes, false otherwise.
		 */
		public function replacePage(num:uint, page:PageDescription):Boolean {
			if (page.type == "") page.type = LoadedFile.typeOf(page.path);
			if (num < this._pages.length) {
				this._pages[num] = page;
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Remove all pages.
		 */
		public function clearPages():void {
			while (this._pages.length > 0) this._pages.shift();
		}
		
		/**
		 * Show the next page.
		 * @param	transition	The transition to use. Leave null to use the default one to next page.
		 */
		public function next(transition:String = null):void {
			
			trace ("transition = " + transition);
			
			var trans:String = this._nextTransition;
			if (transition) trans = transition;
			
			trace ("transition = " + trans);
			
			var toPage:uint = this._current + 1;
			if (toPage >= this._pages.length) {
				if (this.loopPages) this.setPage(0, trans);
			} else {
				this.setPage(toPage, trans);
			}
		}
		
		/**
		 * Show the previous page.
		 * @param	transition	The transition to use. Leave null to use the default one to previous page.
		 */
		public function previous(transition:String = null):void {
			var trans:String = this._previousTransition;
			if (transition) trans = transition;
			var toPage:int = this._current - 1;
			if (toPage < 0) {
				if (this.loopPages) this.setPage((this._pages.length - 1), trans);
			} else {
				this.setPage(toPage, trans);
			}
		}
		
		/**
		 * Release memory used by this object.
		 */
		override public function kill():void {
			// events
			if (Multitouch.supportsGestureEvents) {					
				Multitouch.inputMode = MultitouchInputMode.GESTURE;
				var gestures:Vector.<String> = Multitouch.supportedGestures;
				for each (var s:String in gestures) {
					switch (s) {
						case "gestureZoom":
							this.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, gestureZoom);
							break;
						case "gestureRotate":
							this.removeEventListener(TransformGestureEvent.GESTURE_ROTATE, gestureRotate);
							break;
						case "gesturePan":
							this.removeEventListener(TransformGestureEvent.GESTURE_PAN, gesturePan);
							break;
						case "gestureSwipe":
							this.removeEventListener(TransformGestureEvent.GESTURE_SWIPE, gestureSwipe);
							break;
					}
				}
			} else {
				// add mouse-driven events
				this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				this.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
			// arrays
			while (this._pages.length > 0) this._pages.shift();
			this._pages = null;
			// variables
			this._defaultTransition = null;
			this._nextTransition = null;
			this._previousTransition = null;
			// clear MediaDisplay
			super.kill();
		}
		
		// PROPERTIES
		
		/**
		 * Can this object handle gesture input for zoon, resize, pan and swipe?
		 */
		public function get gesturesSupport():Boolean {
			return (Multitouch.supportsGestureEvents);
		}
		
		/**
		 * This sequence number of pages.
		 */
		public function get numPages():uint {
			return (this._pages.length);
		}
		
		/**
		 * Information about the current page shown.
		 */
		public function get currentPage():PageDescription {
			return (this._pages[this._current]);
		}
		
		// PRIVATE METHODS
		
		/**
		 * Move object using drag.
		 */
		private function onMouseDown(evt:MouseEvent):void {
			if (this.allowGestures) this.startDrag();
		}
		
		/**
		 * Move object using drag.
		 */
		private function onMouseUp(evt:MouseEvent):void {
			if (this.allowGestures) this.stopDrag();
		}
		
		/**
		 * Zoom object using gestures.
		 */
		protected function gestureZoom(evt:TransformGestureEvent):void {
			if (this.allowGestures) {
				this.scaleX *= evt.scaleX;
				this.scaleY *= evt.scaleY;
			}
			
		}
		
		/**
		 * Rotate object using gestures.
		 */
		protected function gestureRotate(evt:TransformGestureEvent):void {
			if (this.allowGestures) this.rotation += evt.rotation;
		}
		
		/**
		 * Move object using gestures.
		 */
		protected function gesturePan(evt:TransformGestureEvent):void {
			if (this.allowGestures) {
				this.x += evt.offsetX;
				this.y += evt.offsetY;
			}
			
		}
		
		/**
		 * Change pages using gestures.
		 */
		protected function gestureSwipe(evt:TransformGestureEvent):void {
			if (this.allowGestures) {
				if ((this.rotation >= -90) && (this.rotation <= 90)) {
					if (evt.offsetX > 0) this.previous();
					else if (evt.offsetX < 0) this.next();
				} else {
					if (evt.offsetX > 0) this.previous(this._nextTransition);
					else if (evt.offsetX < 0) this.next(this._previousTransition);
				}
			}
			
		}
	}

}
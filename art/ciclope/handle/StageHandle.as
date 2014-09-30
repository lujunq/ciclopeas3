package art.ciclope.handle {
	
	// FLASH PACKAGES
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * StageHandle provides useful functions for managing stage events and assignments.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class StageHandle {
		
		// VARIABLES
		
		/**
		 * The stage reference.
		 */
		private var _stage:Stage;
		
		/**
		 * Actions to take on stage enter frame event.
		 */
		private var _enterFrame:Array;
		private var _ief:uint;
		
		/**
		 * Actions to take on key down event.
		 */
		private var _keyDown:Array;
		private var _keyDownAll:Array;
		private var _ikd:uint;
		
		/**
		 * StageHandle constructor.
		 * @param	stage	the main stage
		 * @param	align	stage align to set
		 * @param	scaleMode	stage sclae mode to set
		 */
		public function StageHandle(stage:Stage, align:String = "TL", scaleMode:String = "noScale") {
			// preparing stage
			this._stage = stage;
			this._stage.scaleMode = scaleMode;
			this._stage.align = align;
			
			// events
			this._enterFrame = new Array();
			this._stage.addEventListener(Event.ENTER_FRAME, eventEnterFrame);
			this._keyDown = new Array();
			this._keyDownAll = new Array();
			this._stage.addEventListener(KeyboardEvent.KEY_DOWN, eventKeyDown);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Add a new function to run on enter frame.
		 * @param	action	The function to run (must receive a single flash.events.Event parameter).
		 */
		public function addEnterFrame(action:Function):void {
			this._enterFrame.push(action);
		}
		
		/**
		 * Remove a function set to run on enter frame.
		 * @param	action	The function to stop running.
		 * @return	True if the function is found running on enter frame and removed from list, false otherwise.
		 */
		public function removeEnterFrame(action:Function):Boolean {
			var found:int = -1;
			for (var index:uint = 0; index < this._enterFrame.length; index++) if (this._enterFrame[index] == action) found = index;
			if (found >= 0) {
				this._enterFrame.splice(found, 1);
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Add a new function to run on key down event.
		 * @param	keycode	The keycode to track (use -1 to listen to all keycodes).
		 * @param	action	The function to run (must receive a single flash.events.KeyboardEvent parameter).
		 */
		public function addKeyDown(keycode:int, action:Function):void {
			// create keycode entry?
			if (keycode == -1) {
				this._keyDownAll.push(action);
			} else {
				if (!this._keyDown[String(keycode)]) this._keyDown[String(keycode)] = new Array();
				this._keyDown[String(keycode)].push(action);
			}
		}
		
		/**
		 * Remove a function set to run on key down.
		 * @param	keycode	The keycode to track.
		 * @param	action	The function to stop running.
		 * @return	True if the function is found running on keycode set and removed from list, false otherwise.
		 */
		public function removeKeyDown(keycode:int, action:Function):Boolean {
			var found:int = -1;
			var index:uint = 0;
			if (keycode == -1) {
				for (index = 0; index < this._keyDownAll.length; index++) if (this._keyDownAll[index] == action) found = index;
				if (found >= 0) {
					this._keyDownAll.splice(found, 1);
					return (true);
				} else {
					return (false);
				}
			} else {
				if (!this._keyDown[String(keycode)]) {
					// no keycode register found: return false
					return (false);
				} else {
					for (index = 0; index < this._keyDown[String(keycode)].length; index++) if (this._keyDown[String(keycode)][index] == action) found = index;
					if (found >= 0) {
						this._keyDown[String(keycode)].splice(found, 1);
						return (true);
					} else {
						return (false);
					}
				}
			}
		}
		
		// PRIVATE METHODS
		
		/**
		 * Perform requested actions on enter fame event.
		 * @param	evt	Stage event.
		 */
		private function eventEnterFrame(evt:Event):void {
			for (this._ief = 0; this._ief < this._enterFrame.length; this._ief++) this._enterFrame[this._ief](evt); 
		}
		
		/**
		 * Perform requested actions on key down event.
		 * @param	evt	Keyboard event.
		 */
		private function eventKeyDown(evt:KeyboardEvent):void {
			// to actions listen to all keycodes
			for (this._ikd = 0; this._ikd < this._keyDownAll.length; this._ikd++) this._keyDownAll[this._ikd](evt); 
			// to actions listen only to a single keycode
			if (this._keyDown[String(evt.keyCode)]) {
				for (this._ikd = 0; this._ikd < this._keyDown[String(evt.keyCode)].length; this._ikd++) this._keyDown[String(evt.keyCode)][this._ikd](evt); 
			}
		}
	}

}
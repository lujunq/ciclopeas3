package art.ciclope.managana.data {
	
	// FLASH PACKAGES
	import flash.system.System;
	
	// CICLOPE CLASSES
	import art.ciclope.util.ObjectState;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * DISKeyframe provides information about a stream keyframe.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class DISKeyframe {
		
		// VARIABLES
		
		private var _state:String;			// keyframe object state
		private var _instances:Array;		// playlist instances on keyframe
		
		// PUBLIC VARIABLES
		
		/**
		 * Progress code to run on keyframe enter.
		 */
		public var codeIn:String = "";
		
		/**
		 * Progress code to run on keyframe exit.
		 */
		public var codeOut:String = "";
		
		/**
		 * DISKeyframe constructor.
		 * @param	datastr	keyframe xml information in String format
		 */
		public function DISKeyframe(datastr:String) {
			// check for input xml
			this._state = ObjectState.STATE_NOTREADY;
			this._instances = new Array();
			try {
				var data:XML = new XML(datastr);
			} catch (e:Error) {
				// bad xml
				this._state = ObjectState.STATE_LOADERROR;
			}
			// get playlist instances and keyframe progress codes
			if (this._state == ObjectState.STATE_NOTREADY) {
				if (data.child("actionin").length() > 0) this.codeIn = String(data.actionin);
				if (data.child("actionout").length() > 0) this.codeOut = String(data.actionout);
				if (data.child("instance").length() > 0) {
					for (var index:uint = 0; index < data.child("instance").length(); index++) {
						this._instances.push(new DISInstance(data.instance[index]));
					}
				}
				System.disposeXML(data);
				this._state = ObjectState.STATE_LOADOK;
			}
		}
		
		// READ-ONLY VALUES
		
		/**
		 * This object state.
		 */
		public function get state():String {
			return (this._state);
		}
		
		/**
		 * Playlist instances of current keyframe.
		 * @see	art.ciclope.managana.data.DISInstance
		 */
		public function get instances():Array {
			return (this._instances);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Release memory used by this object.
		 */
		public function kill():void {
			while (this._instances.length > 0) {
				this._instances[0].kill();
				this._instances.shift();
			}
			this._instances = null;
			this.codeIn = null;
			this.codeOut = null;
		}
		
	}

}
package art.ciclope.sitio.data {
	
	// FLASH PACKAGES
	import flash.system.System;
	
	// CICLOPE CLASSES
	import art.ciclope.util.ObjectState;
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class DISKeyframe {
		
		// VARIABLES
		
		private var _state:String;			// keyframe object state
		private var _instances:Array;		// playlist instances on keyframe
		
		
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
			// get playlist instances
			if (this._state == ObjectState.STATE_NOTREADY) {
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
		 * @see	art.ciclope.sitio.data.DISInstance
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
		}
		
	}

}
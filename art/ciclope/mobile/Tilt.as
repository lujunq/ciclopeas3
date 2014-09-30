package art.ciclope.mobile {
	
	
	// FLASH PACKAGES
	import flash.display.Stage;
	import flash.display.StageOrientation;
	import flash.events.AccelerometerEvent;
	import flash.sensors.Accelerometer
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * Tilt provides simple methods to interact with the device's accelerators.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class Tilt {
		
		// VARIABLES
		
		private var _update:Function;					// a function to call on accelerometer update
		private var _acc:Accelerometer;					// the accelerometer information
		private var _active:Boolean;					// is accelerometer active?
		private var _interval:uint;						// sensor update interval
		private var _acX:Number;						// x axis accelerator value
		private var _acY:Number;						// y axis accelerator value
		private var _acZ:Number;						// z axis accelerator value
		private var _stage:Stage;						// stage for rotation adjust
		private var _rotateLandscape:Boolean;			// automatic rotate screen on landscape aspect?
		
		/**
		 * Tilt constructor.
		 * @param	update	a function to call on sensor update (won't receive any parameters)
		 * @param	interval	the sensor update interval in miliseconds
		 */
		public function Tilt(update:Function = null, interval:uint = 6000) {
			// get data
			this._update = update;
			this._interval = 0;
			this._acX = this._acY = this._acZ = 0;
			// prepare accelerometer
			this._active = false;
			this._rotateLandscape = false;
			if (flash.sensors.Accelerometer.isSupported) {
				this._acc = new flash.sensors.Accelerometer();
				this._acc.setRequestedUpdateInterval(interval);
				this._acc.addEventListener(AccelerometerEvent.UPDATE, onAccUpdate);
				this._interval = interval;
				this._active = true;
			}
		}
		
		/**
		 * Is the sensor active?
		 */
		public function get active():Boolean {
			return (this._active);
		}
		
		/**
		 * Accelerator X axis value.
		 */
		public function get accX():Number {
			return(this._acX);
		}
		
		/**
		 * Accelerator Y axis value.
		 */
		public function get accY():Number {
			return(this._acY);
		}
		
		/**
		 * Accelerator Z axis value.
		 */
		public function get accZ():Number {
			return(this._acZ);
		}
		
		/**
		 * Release all memory used by this object.
		 */
		public function kill():void {
			if (this.active) {
				this._acc.removeEventListener(AccelerometerEvent.UPDATE, onAccUpdate);
			}
			this._stage = null;
			this._update = null;
			this._acc = null;
		}
		
		/**
		 * Sensor update interval (miliseconds).
		 */
		public function get interval():uint {
			return (this._interval);
		}
		public function set interval(to:uint):void {
			if (this._active) {
				this._acc.setRequestedUpdateInterval(interval);
				this._interval = interval;
			}
		}
		
		/**
		 * Atomatically rotate stage on landscape aspect on device orientation change?
		 * @param	active	automatic change?
		 * @param	stage	stage reference to rotate
		 */
		public function setLandscapeRotation(active:Boolean, stage:Stage):void {
			this._stage = stage;
			this._rotateLandscape = active;
		}
		
		/**
		 * Accelerometer update event.
		 */
		private function onAccUpdate(evt:AccelerometerEvent):void {
			// get data
			this._acX = evt.accelerationX;
			this._acY = evt.accelerationY;
			this._acZ = evt.accelerationZ;
			// landscape rotation?
			if (this._rotateLandscape) {
				if ((this._stage.deviceOrientation == StageOrientation.ROTATED_LEFT) && (this._stage.orientation == this._stage.deviceOrientation)) {
					this._stage.setOrientation(StageOrientation.ROTATED_RIGHT);
				} else if ((this._stage.deviceOrientation == StageOrientation.ROTATED_RIGHT) && (this._stage.orientation == this._stage.deviceOrientation)) {
					this._stage.setOrientation(StageOrientation.ROTATED_LEFT);
				}
			}
			// call update function
			if (this._update != null) this._update();
		}
		
	}

}
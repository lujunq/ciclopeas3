package art.ciclope.mobile {
	
	// FLASH PACKAGES
	import flash.sensors.Geolocation;
	import flash.events.GeolocationEvent;
	
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * GPS provides simple methods to interact with device's position hardware.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class GPS {
		
		// VARIABLES
		
		private var _active:Boolean;		// is geolocation available?
		private var _geo:Geolocation;		// the geolocation sensor
		private var _latitude:Number;		// current latitude
		private var _longitude:Number;		// current longitude
		private var _timestamp:Number;		// request timestamp
		private var _update:Function;		// function to call on value update
		private var _interval:uint;			// interval for sensor update
		
		/**
		 * GPS constructor.
		 * @param	update	a function to call on sensor update (won't receive any parameters)
		 * @param	interval	the sensor update interval in miliseconds
		 */
		public function GPS(update:Function, interval:uint = 6000) {
			this._update = update;
			this._active = false;
			this._interval = 0;
			this._latitude = this._longitude = this._timestamp = 0;
			// get geolocation
			if (Geolocation.isSupported) {
				this._geo = new Geolocation();
				if (!this._geo.muted) {
					this._interval = interval;
					this._geo.setRequestedUpdateInterval(interval);
					this._geo.addEventListener(GeolocationEvent.UPDATE, geolocationUpdateHandler);
					this._active = true;
				}
			}
		}
		
		/**
		 * Release all memory used by this object.
		 */
		public function kill():void {
			if (this.active) {
				this._geo.removeEventListener(GeolocationEvent.UPDATE, geolocationUpdateHandler);
			}
			this._update = null;
			this._geo = null;
		}
		
		/**
		 * Is the sensor active?
		 */
		public function get active():Boolean {
			return (this._active);
		}
		
		/**
		 * Current latitude value.
		 */
		public function get latitude():Number {
			return (this._latitude);
		}
		
		/**
		 * Current longitude value.
		 */
		public function get longitude():Number {
			return (this._longitude);
		}
		
		/**
		 * Current timestamp.
		 */
		public function get timestamp():Number {
			return (this._timestamp);
		}
		
		/**
		 * The sensor update interval (miliseconds).
		 */
		public function get interval():uint {
			return (this._interval);
		}
		public function set interval(to:uint):void {
			if (this._active) {
				this._geo.setRequestedUpdateInterval(interval);
				this._interval = interval;
			}
		}
		
		/**
		 * Geolocation update event.
		 */
		private function geolocationUpdateHandler(evt:GeolocationEvent):void {
			// get gps data
			this._latitude = evt.latitude;
			this._longitude = evt.longitude;
			this._timestamp = evt.timestamp;
			// call update function
			this._update();
		}
		
	}

}
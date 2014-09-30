package art.ciclope.managana.data {
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * GeolocationPoint holds information about geolocation point.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public final class GeolocationPoint {
		
		// CONSTANTS
		
		private const INTERVAL:Number = 0.00002;	// interval for latitude and longitude check
		
		// PUBLIC VARIABLES
		
		/**
		 * The point name.
		 */
		public var name:String;
		
		/**
		 * The point latitude.
		 */
		public var latitude:Number;
		
		/**
		 * Minimum latitude value to check.
		 */
		public var minlat:Number;
		
		/**
		 * Maximum latitude value to check.
		 */
		public var maxlat:Number;
		
		/**
		 * The point longitude.
		 */
		public var longitude:Number;
		
		/**
		 * Minimum longitude value to check.
		 */
		public var minlong:Number;
		
		/**
		 * Maximum longitude value to check.
		 */
		public var maxlong:Number;
		
		/**
		 * The point progress code.
		 */
		public var code:String;
		
		/**
		 * AuthorData constructor.
		 * @param	name	the author name
		 * @param	id	the author identifier
		 */
		public function GeolocationPoint(name:String, latitude:Number, longitude:Number, code:String) {
			this.name = name;
			this.latitude = latitude;
			this.maxlat = latitude + INTERVAL;
			this.minlat = latitude - INTERVAL;
			this.longitude = longitude;
			this.maxlong = longitude + INTERVAL;
			this.minlong = longitude - INTERVAL;
			this.code = code;
		}
		
		/**
		 * Release memory used by this object.
		 */
		public final function kill():void {
			this.name = null;
			this.code = null;
		}
		
	}

}
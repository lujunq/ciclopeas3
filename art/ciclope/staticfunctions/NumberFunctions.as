package art.ciclope.staticfunctions {
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * NumberFunctions provides static methods for handling numbers.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class NumberFunctions {
		
		// STATIC FUNCTIONS
		
		/**
		 * Convert angle to radians.
		 * @param	ang	the angle in degrees
		 * @return	the angle in radiand
		 */
		public static function degreeToRadian(ang:Number):Number {
			return (ang * (Math.PI/180.0));
		}
		
		/**
		 * Mercator projection for longitude to cartesian transform.
		 * @param	lon	the longitude (in degrees)
		 * @return	an approximate value for X axis
		 */
		public static function mercatorX(lon:Number):Number {
			var r_major:Number = 6378137.000;
			return (r_major * NumberFunctions.degreeToRadian(lon));
		}
		
		/**
		 * Mercator projection for latitude to cartesian transform.
		 * @param	lat	the latitude (in degrees)
		 * @return	an approximate value for Y axis
		 */
		public static function mercatorY(lat:Number):Number {
			if (lat > 89.5)
				lat = 89.5;
			if (lat < -89.5)
				lat = -89.5;
			var r_major:Number = 6378137.000;
			var r_minor:Number = 6356752.3142;
			var temp:Number = r_minor / r_major;
			var es:Number = 1.0 - (temp * temp);
			var eccent:Number = Math.sqrt(es);
			var phi:Number =  NumberFunctions.degreeToRadian(lat);
			var sinphi:Number = Math.sin(phi);
			var con:Number = eccent * sinphi;
			var com:Number = 0.5 * eccent;
			con = Math.pow((1.0-con)/(1.0+con), com);
			var ts:Number = Math.tan(0.5 * (Math.PI*0.5 - phi))/con;
			var y:Number = 0 - r_major * Math.log(ts);
			return (y);
		}

	}

}
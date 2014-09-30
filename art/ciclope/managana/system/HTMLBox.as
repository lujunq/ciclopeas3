package art.ciclope.managana.system {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * HTMLBox is a base class for creating an HTML renderer layer over the Managana interface.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class HTMLBox extends Sprite {
		
		// PUBLIC VARIABLES
		
		/**
		 * Progress code sent by html content.
		 */
		public var pcode:String = "";
		
		/**
		 * LinkManager constructor (not meant to be used directly).
		 */
		public function HTMLBox(refSize:Point = null) {		}
		
		// PUBLIC METHODS
		
		/**
		 * Open a url (dumb function to be overriden by extended classes).
		 * @param	url	the url to open
		 */
		public function openURL(url:String):void {
			// do nothing
		}
		
		/**
		 * Release memory used by the object (dumb function to be overriden by extended classes).
		 */
		public function kill():void { }
		
	}

}
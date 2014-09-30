package art.ciclope.managana.system {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * LinkManager words as a base class for different ways to access external links according to os/player.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class LinkManager extends Sprite {
		
		/**
		 * LinkManager constructor (not meant to be used directly).
		 */
		public function LinkManager(refSize:Point = null) {		}
		
		// PUBLIC METHODS
		
		/**
		 * Open a url (dumb function to be overriden by extended classes).
		 * @param	url	the url to open
		 */
		public function openURL(url:String, target:String = '_blank'):void {
			// do nothing
		}
		
		/**
		 * Open a url for OpenID/oAuth authentication (dumb function to be overriden by extended classes).
		 * @param	url	the authentication url
		 * @param	community	the current community
		 * @param	stream	the current stream
		 * @param	caller	the caller app
		 * @param	key	current public presentation key
		 */
		public function authenticate(url:String, community:String = "", stream:String = "", caller:String = "", key:String = ""):void {
			// do nothing
		}
		
		/**
		 * Release memory used by the object (dumb function to be overriden by extended classes).
		 */
		public function kill():void { }
		
	}

}
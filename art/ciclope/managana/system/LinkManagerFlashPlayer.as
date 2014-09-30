package art.ciclope.managana.system {
	
	// FLASH PACKAGES
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.display.StageDisplayState;
	import flash.geom.Point;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * LinkManagerFlashPlayer extends LinkManager enabling external link opening while running on Flash Plaeyr embed into a html page. It works by opening links on browser's tabs/windows.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class LinkManagerFlashPlayer extends LinkManager {
		
		// PUBLIC VARIABLES
		
		/**
		 * LinkManagerFlashPlayer constructor.
		 */
		public function LinkManagerFlashPlayer(refSize:Point = null) { }
		
		// PUBLIC METHODS
		
		/**
		 * Open a url.
		 * @param	url	the url to open
		 */
		override public function openURL(url:String, target:String = '_blank'):void {
			if (this.stage.displayState != StageDisplayState.NORMAL) this.stage.displayState = StageDisplayState.NORMAL;
			navigateToURL(new URLRequest(url), target);
		}
		
		/**
		 * Authenticate an user with OpenID/oAuth.
		 * @param	url	the authentication url
		 * @param	community	the current community
		 * @param	stream	the current stream
		 * @param	caller	the caller app
		 * @param	key	current public presentation key
		 */
		override public function authenticate(url:String, community:String = "", stream:String = "", caller:String = "", key:String = ""):void {
			var request:URLRequest = new URLRequest(url);
			request.data = new URLVariables("community=" + escape(community) + "&stream=" + escape(stream) + "&player=web" + "&from=" + escape(caller) + "&pkey=" + escape(key));
			request.method = "POST";
			if (this.stage.displayState != StageDisplayState.NORMAL) this.stage.displayState = StageDisplayState.NORMAL;
			navigateToURL(request, "_top");
		}
		
	}

}
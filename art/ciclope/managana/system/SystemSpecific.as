package art.ciclope.managana.system {
	
	// FLASH PACKAGES
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaInterface;
	import art.ciclope.managana.ManaganaPlayer;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * SystemSpecific is a basic class to be extended to provide support for specific system resources like special hardwares.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class SystemSpecific extends EventDispatcher {
		
		// VARIABLES
		
		protected var _stage:Stage;						// a reference to the main stage
		protected var _player:ManaganaPlayer;			// a reference to the managana player
		protected var _interface:ManaganaInterface;		// a reference to the managana interface
		
		/**
		 * SystemSpecific constructor.
		 * @param	stage	the current stage
		 * @param	player	the managana player
		 * @param	interf	the managana player interface
		 */
		public function SystemSpecific(stage:Stage, player:ManaganaPlayer, interf:ManaganaInterface) {
			// get data
			this._stage = stage;
			this._player = player;
			this._interface = interf;
		}
		
		// PUBLIC METHODS
		
		/**
		 * Release resources used by the object.
		 */
		public function kill():void {
			this._stage = null;
			this._player = null;
			this._interface = null;
		}
		
	}

}
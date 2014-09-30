package art.ciclope.util {
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes<br>
	 * <b>License:</b> Mozilla MLP 1.1 or GNU/GPL version 3 or later (at your choice)<br><br>
	 * MediaDefinitions provides constants for setting up media playbacks.
	 * @author Lucas S. Junqueira - chokito76@gmail.com
	 */
	public class MediaDefinitions {
		
		// CLASS CONSTANT DEFINITIONS
		
		/**
		 * Playback update interval optimized for playback speed.
		 */
		public static const PLAYBACKUPDATE_SPEED:uint = 1000;
		/**
		 * Playback update above standard interval.
		 */
		public static const PLAYBACKUPDATE_ABOVE:uint = 500;
		/**
		 * Playback update standard interval.
		 */
		public static const PLAYBACKUPDATE_STANDARD:uint = 250;
		/**
		 * Playback update interval optimized for playback control.
		 */
		public static const PLAYBACKUPDATE_CONTROL:uint = 100;
		
		/**
		 * Media playback state: play.
		 */
		public static const PLAYBACKSTATE_PLAY:String = "PLAYBACKSTATE_PLAY";
		/**
		 * Media playback state: stop.
		 */
		public static const PLAYBACKSTATE_STOP:String = "PLAYBACKSTATE_STOP";
		/**
		 * Media playback state: pause.
		 */
		public static const PLAYBACKSTATE_PAUSE:String = "PLAYBACKSTATE_PAUSE";
		/**
		 * Media playback state: unload.
		 */
		public static const PLAYBACKSTATE_UNLOAD:String = "PLAYBACKSTATE_UNLOAD";
		/**
		 * Media playback state: not stream media.
		 */
		public static const PLAYBACKSTATE_NOTSTREAM:String = "PLAYBACKSTATE_NOTSTREAM"; 
		
		
		// CONSTRUCTOR
		
		/**
		 * Creates a new instance of MediaDefinitions, however this class is not meant to be used as an object.
		 */
		public function MediaDefinitions() {
			
		}
		
	}

}
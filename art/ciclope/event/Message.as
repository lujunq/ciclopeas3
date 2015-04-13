package art.ciclope.event {
	
	// FLASH PACKAGES
	import flash.events.Event;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * Message create events for message exchange among classes.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class Message extends Event {
		
		// CONSTANT DEFINITIONS
		
		/**
		 * An openURL message.
		 */
		public static const OPENURL:String = "OPENURL";
		/**
		 * An open HTML box message.
		 */
		public static const OPENHTMLBOX:String = "OPENHTMLBOX";
		/**
		 * An share on Facebook message.
		 */
		public static const SHARE_FACEBOOK:String = "SHARE_FACEBOOK";
		/**
		 * An share on Twitter message.
		 */
		public static const SHARE_TWITTER:String = "SHARE_TWITTER";
		/**
		 * An share on Google Plus message.
		 */
		public static const SHARE_GPLUS:String = "SHARE_GPLUS";
		/**
		 * A generic message.
		 */
		public static const MESSAGE:String = "MESSAGE";
		/**
		 * Ask for OpenID/oAuth authentication.
		 */
		public static const AUTHENTICATE:String = "AUTHENTICATE";
		/**
		 * OpenID/oAuth success.
		 */
		public static const AUTHOK:String = "AUTHOK";
		/**
		 * OpenID/oAuth authentication error.
		 */
		public static const AUTHERROR:String = "AUTHERROR";
		/**
		 * Request variable data save.
		 */
		public static const SAVEDATA:String = "SAVEDATA";
		/**
		 * Request variable data load.
		 */
		public static const LOADDATA:String = "LOADDATA";
		/**
		 * Request community variable data load.
		 */
		public static const LOADCOMVALUES:String = "LOADCOMVALUES";
		/**
		 * Save a community variable.
		 */
		public static const SAVECOMVALUE:String = "SAVECOMVALUE";
		/**
		 * Change a community value.
		 */
		public static const CHANGECOMVALUE:String = "CHANGECOMVALUE";
		/**
		 * Send a custom message to a connected software.
		 */
		public static const SENDTOCONNECTED:String = "SENDTOCONNECTED";
		/**
		 * Send a message with progress code to a connected Managana.
		 */
		public static const SENDPROGRESSCODE:String = "SENDPROGRESSCODE";
		/**
		 * Internal mouse over event.
		 */
		public static const MOUSEOVER:String = "MOUSEOVER";
		/**
		 * Internal mouse out event.
		 */
		public static const MOUSEOUT:String = "MOUSEOUT";
		/**
		 * A message sent by the sitio player is available (kept for compatibility issues).
		 */
		public static const SITIO_MESSAGE:String = "SITIO_MESSAGE";
		
		// VARIABLES
		
		private var _param:Object;	// event parameter
		
		/**
		 * DISLoad constructor.
		 * @param	type	event type
		 * @param	param	any parameters the message should carry
		 * @param	bubbles	Determines whether the Event object participates in the bubbling stage of the event flow.
		 * @param	cancelable	Determines whether the Event object can be canceled.
		 */
		public function Message(type:String, param:Object = null, bubbles:Boolean = false, cancelable:Boolean = false) { 
			this._param = param;
			super(type, bubbles, cancelable);
		}
		
		// READ-ONLY VALUES
		
		/**
		 * The event custom parameter.
		 */
		public function get param():Object {
			return (this._param);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Duplicate an instance of this event.
		 */
		public override function clone():Event { 
			return new Message(type, this._param, bubbles, cancelable);
		} 

		/**
		 * Return a string containing all properties of the event.
		 */
		public override function toString():String { 
			return formatToString("Message", "type", "param", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}
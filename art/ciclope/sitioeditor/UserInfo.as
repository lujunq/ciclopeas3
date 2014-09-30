package art.ciclope.sitioeditor {
	import art.ciclope.sitioeditor.data.DISAuthorED;
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class UserInfo {
		
		// STATIC STATEMENTS
		
		/**
		 * User index on database.
		 */
		public static var index:uint = 0;
		
		/**
		 * The user id.
		 */
		public static var id:String = "";
		
		/**
		 * The user name.
		 */
		public static var name:String = "";
		
		/**
		 * The user e-mail.
		 */
		public static var email:String = "";
		
		/**
		 * The user access levek to system.
		 */
		public static var level:String = "";
		
		/**
		 * Author information based on current user.
		 */
		public static function get author():DISAuthorED {
			var aut:DISAuthorED = new DISAuthorED();
			aut.name = UserInfo.name;
			aut.id = UserInfo.id;
			return(aut);
		}
		
		/**
		 * Clear user information.
		 */
		public static function clear():void {
			UserInfo.index = 0;
			UserInfo.name = "";
			UserInfo.email = "";
			UserInfo.level = "";
			UserInfo.id = "";
		}
		
		/**
		 * Is there an user logged?
		 */
		public static function get logged():Boolean {
			return (UserInfo.email != "");
		}
		
	}

}
package art.ciclope.sitioeditor.data {
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class DISCommunityED {
		
		// PUBLIC VARIABLES
		
		/**
		 * Community id/DIS folder name.
		 */
		public var id:String = "";
		/**
		 * Community title.
		 */
		public var title:String = "";
		/**
		 * Community index on database.
		 */
		public var index:uint = 0;
		/**
		 * Community view width.
		 */
		public var width:Number = 0;
		/**
		 * Community view height.
		 */
		public var height:Number = 0;
		/**
		 * Community copyleft.
		 */
		public var copyleft:String = "";
		/**
		 * Community copyright.
		 */
		public var copyright:String = "";
		/**
		 * Community about text.
		 */
		public var about:String = "";
		/**
		 * Community background color.
		 */
		public var background:String = "0x000000";
		/**
		 * Community background alpha.
		 */
		public var alpha:Number = 1;
		/**
		 * Community use highlight.
		 */
		public var highlight:Boolean = false;
		/**
		 * Community highlight color.
		 */
		public var highlightcolor:String = "0x000000";
		/**
		 * Community language.
		 */
		public var language:String = "";
		/**
		 * Community edition date.
		 */
		public var edition:String = "";
		
		public function DISCommunityED() {
			
		}
		
		// PUBLIC METHODS
		
		/**
		 * Clear data about community.
		 */
		public function clear():void {
			id = "";
			title = "";
			index = 0;
			width = 0;
			height = 0;
			copyleft = "";
			copyright = "";
			about = "";
			background = "0x000000";
			alpha = 1;
			highlight = false;
			highlightcolor = "0x000000";
			language = "";
			edition = "";
		}
		
		/**
		 * Load community data from a xml.
		 * @param	data	a xml with community information
		 */
		public function getData(data:XML):void {
			index = uint(data.index);
			id = String(data.id);
			title = String(data.title);
			width = Number(data.width);
			height = Number(data.height);
			copyleft = String(data.copyleft);
			copyright = String(data.copyright);
			about = String(data.about);
			background = String(data.background);
			alpha = Number(data.alpha);
			highlight = Boolean(uint(data.highlight));
			highlightcolor = String(data.highlightcolor);
			language = String(data.language);
			edition = String(data.edition);
		}
		
	}

}
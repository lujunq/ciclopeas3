package art.ciclope.managanaeditor.data {
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * DISCommunityED provides information about communities for Managana editor.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class DISCommunityED {
		
		// PUBLIC VARIABLES
		
		/**
		 * Community permission level for current user.
		 */
		public var level:String = "admin";
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
		 * Community portrait view width.
		 */
		public var pwidth:Number = 0;
		/**
		 * Community portrait view height.
		 */
		public var pheight:Number = 0;
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
		/**
		 * Community home stream.
		 */
		public var home:String = "";
		/**
		 * List of community external feeds.
		 */
		public var feeds:Array = new Array();
		/**
		 * List of community meta data fields.
		 */
		public var meta:Array = new Array();
		/**
		 * List of community widget files.
		 */
		public var widgets:Array = new Array();
		/**
		 * Icon graphic.
		 */
		public var icon:String = "";
		/**
		 * Target graphic.
		 */
		public var target:String = "";
		/**
		 * 0% vote graphic.
		 */
		public var vote0:String = "";
		/**
		 * 10% vote graphic.
		 */
		public var vote10:String = "";
		/**
		 * 20% vote graphic.
		 */
		public var vote20:String = "";
		/**
		 * 30% vote graphic.
		 */
		public var vote30:String = "";
		/**
		 * 40% vote graphic.
		 */
		public var vote40:String = "";
		/**
		 * 50% vote graphic.
		 */
		public var vote50:String = "";
		/**
		 * 60% vote graphic.
		 */
		public var vote60:String = "";
		/**
		 * 70% vote graphic.
		 */
		public var vote70:String = "";
		/**
		 * 80% vote graphic.
		 */
		public var vote80:String = "";
		/**
		 * 90% vote graphic.
		 */
		public var vote90:String = "";
		/**
		 * 100% vote graphic.
		 */
		public var vote100:String = "";
		/**
		 * Community default vote for group interaction.
		 */
		public var voteDefault:uint = 0;
		/**
		 * Save stream voting results on server?
		 */
		public var voteRecord:Boolean = true;
		/**
		 * The community style sheet for HTML text.
		 */
		public var css:String = "";
		
		/**
		 * Navigation transition for next X stream.
		 */
		public var navxnext:String = "";
		
		/**
		 * Navigation transition for previous X stream.
		 */
		public var navxprev:String = "";
		
		/**
		 * Navigation transition for next Y stream.
		 */
		public var navynext:String = "";
		
		/**
		 * Navigation transition for previous Y stream.
		 */
		public var navyprev:String = "";
		
		/**
		 * Navigation transition for next Z stream.
		 */
		public var navznext:String = "";
		
		/**
		 * Navigation transition for previous Z stream.
		 */
		public var navzprev:String = "";
		
		/**
		 * Navigation transition for home stream.
		 */
		public var navhome:String = "";
		
		/**
		 * Navigation transition list-selected streams.
		 */
		public var navlist:String = "";
		
		/**
		 * DISCommunityED constructor.
		 */
		public function DISCommunityED() { }
		
		// PUBLIC METHODS
		
		/**
		 * Clear data about community.
		 */
		public function clear():void {
			level = "admin";
			id = "";
			title = "";
			index = 0;
			width = 0;
			height = 0;
			pwidth = 0;
			pheight = 0;
			copyleft = "";
			copyright = "";
			about = "";
			background = "0x000000";
			alpha = 1;
			highlight = false;
			highlightcolor = "0x000000";
			language = "";
			edition = "";
			home = "";
			icon = "";
			target = "";
			vote0 = "";
			vote10 = "";
			vote20 = "";
			vote30 = "";
			vote40 = "";
			vote50 = "";
			vote60 = "";
			vote70 = "";
			vote80 = "";
			vote90 = "";
			vote100 = "";
			voteDefault = 0;
			while (this.feeds.length > 0) {
				this.feeds[0].kill();
				this.feeds.shift();
			}
			while (this.meta.length > 0) {
				this.meta[0].kill();
				this.meta.shift();
			}
			while (this.widgets.length > 0) {
				this.widgets.shift();
			}
			voteRecord = true;
			// css
			css = "body {\n    color: #000000;\n    font-family: Arial, Helvetica, sans-serif;\n    font-size: 16px;\n}\n\na {\n    color: #0000FF;\n    text-decoration: underline;\n}";
			// navigation
			navxnext = "";
			navxprev = "";
			navynext = "";
			navyprev = "";
			navznext = "";
			navzprev = "";
			navhome = "";
			navlist = "";
		}
		
		/**
		 * Clear meta data field information.
		 */
		public function clearMeta():void {
			while (this.meta.length > 0) {
				this.meta[0].kill();
				this.meta.shift();
			}
		}
		
		/**
		 * Clear widgets information.
		 */
		public function clearWidgets():void {
			while (this.widgets.length > 0) {
				this.widgets.shift();
			}
		}
		
		/**
		 * Load community data from a xml.
		 * @param	data	a xml with community information
		 */
		public function getData(data:XML):void {
			this.clear();
			level = String(data.level);
			index = uint(data.index);
			id = String(data.id);
			title = String(data.title);
			width = Number(data.width);
			height = Number(data.height);
			pwidth = Number(data.pwidth);
			pheight = Number(data.pheight);
			copyleft = String(data.copyleft);
			copyright = String(data.copyright);
			about = String(data.about);
			background = String(data.background);
			alpha = Number(data.alpha);
			highlight = Boolean(uint(data.highlight));
			highlightcolor = String(data.highlightcolor);
			language = String(data.language);
			edition = String(data.edition);
			home = String(data.home);
			if (data.child("defaultvote").length() > 0) this.voteDefault = uint(data.defaultvote);
			if (data.child("voterecord").length() > 0) this.voteRecord = (String(data.voterecord) == "1");
			if (data.child("graphic").length() > 0) {
				icon = String(data.graphic.gIcon);
				target = String(data.graphic.gTarget);
				vote0 = String(data.graphic.gVote0);
				vote10 = String(data.graphic.gVote10);
				vote20 = String(data.graphic.gVote20);
				vote30 = String(data.graphic.gVote30);
				vote40 = String(data.graphic.gVote40);
				vote50 = String(data.graphic.gVote50);
				vote60 = String(data.graphic.gVote60);
				vote70 = String(data.graphic.gVote70);
				vote80 = String(data.graphic.gVote80);
				vote90 = String(data.graphic.gVote90);
				vote100 = String(data.graphic.gVote100);
			}
			// feeds
			for (var index:uint = 0; index < data.feeds.child("feed").length(); index++) {
				this.feeds.push(new DISFeedED(String(data.feeds.feed[index]), String(data.feeds.feed[index].@type), String(data.feeds.feed[index].@reference)));
			}
			// meta data
			for (index = 0; index < data.meta.child("field").length(); index++) {
				this.meta.push(new DISMetaED(String(data.meta.field[index]), int(data.meta.field[index].@id)));
			}
			// widgets
			for (index = 0; index < data.widgets.child("widget").length(); index++) {
				this.widgets.push(String(data.widgets.widget[index]).substr(0, (String(data.widgets.widget[index]).length-4)));
			}
			//css
			if (data.child("css").length() > 0) {
				if (String(data.css) != "") css = String(data.css);
			}
			// navigation
			if (data.child("transition").length() > 0) {
				navxnext = String(data.transition[0].xnext);
				navxprev = String(data.transition[0].xprev);
				navynext = String(data.transition[0].ynext);
				navyprev = String(data.transition[0].yprev);
				navznext = String(data.transition[0].znext);
				navzprev = String(data.transition[0].zprev);
				navhome = String(data.transition[0].home);
				navlist = String(data.transition[0].list);
			}
		}
		
	}

}
package art.ciclope.managanaeditor {
	
	// FLASH PACKAGES
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.StyleSheet;
	import mx.core.FlexGlobals;
	
	// CICLOPE CLASSES
	import art.ciclope.managanaeditor.LoadedData;
	import art.ciclope.managanaeditor.InstanceDisplay;
	import art.ciclope.staticfunctions.DisplayFunctions;
	import art.ciclope.display.TextSprite;
	import art.ciclope.managana.ManaganaFeed;
	import art.ciclope.managana.feeds.FeedData;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * ViewArea creates a display area to display the stream being edited.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class ViewArea extends Sprite {
		
		// VARIABLES
		
		private var _bg:Sprite;			// background area
		private var _main:Sprite;		// main stream graphics
		private var _aspect:String;		// view area aspect
		private var _votes:Array;		// vote displays
		
		// PUBLIC VARIABLES
		
		/**
		 * Message to show on not visible instance.
		 */
		public var notVisibleMessage:String = "";
		/**
		 * Message to show on no element found.
		 */
		public var noElementMessage:String = "";
		/**
		 * Current community paragraph text style sheet.
		 */
		public var stylesheet:StyleSheet = new StyleSheet();
		/**
		 * External feed name text.
		 */
		public var externalFeedText:String = "external feed";
		/**
		 * External feed field text.
		 */
		public var externalFeedField:String = "field";
		/**
		 * External feed post text.
		 */
		public var externalFeedPost:String = "post";
		/**
		 * External feeds reference.
		 */
		public var feeds:ManaganaFeed;
		
		/**
		 * ViewArea constructor.
		 * @param	notVisible	message to show if the instance will not be visible while playing
		 * @param	noElement	message to show if the instance element is not found
		 * @param	feedText	external feed name text
		 * @param	feedField	external feed field text
		 * @param	feedPost	external feed post text
		 */
		public function ViewArea(notVisible:String, noElement:String, feedText:String, feedField:String, feedPost:String) {
			// get data
			this.notVisibleMessage = notVisible;
			this.noElementMessage = noElement;
			this.externalFeedText = feedText;
			this.externalFeedField = feedField;
			this.externalFeedPost = feedPost;
			// start at landscape aspect
			this._aspect = "landscape";
			// create background
			this._bg = new Sprite();
			this._bg.addEventListener(MouseEvent.CLICK, onBGClick);
			this.addChild(this._bg);
			// stream graphics
			this._main = new Sprite();
			this.addChild(this._main);
			// vote displays
			this._votes = new Array();
			for (var index:uint = 1; index <= 9; index++) {
				var display:VoteDisplayED = new VoteDisplayED(index);
				this.addChild(display);
				this._votes.push(display);
			}
			// wait for stage
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		// READ-ONLY VALUES
		
		/**
		 * A list of the current instance names.
		 */
		public function get instanceNames():Array {
			var ret:Array = new Array();
			for (var index:uint = 0; index < this._main.numChildren; index++) {
				var image:InstanceDisplay = this._main.getChildAt(index) as InstanceDisplay;
				ret.push(image.instance.id);
			}
			return (ret);
		}
		
		// PROPERTIES
		
		/**
		 * View area aspect.
		 */
		public function get aspect():String {
			return (this._aspect);
		}
		public function set aspect(to:String):void {
			if (to == "portrait") this._aspect = to;
				else this._aspect = "landscape";
		}
		
		// PUBLIC FUNCTIONS
		
		/**
		 * Show current community.
		 */
		public function showCommunity():void {
			// redraw background
			this._bg.graphics.clear();
			this._bg.graphics.lineStyle(1, 0, 1);
			this._bg.graphics.beginFill(uint(LoadedData.community.background), LoadedData.community.alpha);
			if (this._aspect == "landscape") this._bg.graphics.drawRect(0, 0, LoadedData.community.width, LoadedData.community.height);
				else this._bg.graphics.drawRect(0, 0, LoadedData.community.pwidth, LoadedData.community.pheight);
			this._bg.graphics.endFill();
		}
		
		/**
		 * Get the reference for an instance.
		 * @param	id	the instance id
		 * @return	the instance reference or null if it is not found
		 */
		public function getInstance(id:String):InstanceDisplay {
			var ret:InstanceDisplay;
			for (var index:uint = 0; index < this._main.numChildren; index++) {
				var image:InstanceDisplay = this._main.getChildAt(index) as InstanceDisplay;
				if (image.instance.id == id) ret = image;
			}
			return (ret);
		}
		
		/**
		 * Get the next order value for new instances (must be bigger than any other on stage).
		 * @return	the new order value
		 */
		public function getNextOrder():uint {
			var ret:uint = 0;
			for (var index:uint = 0; index < this._main.numChildren; index++) {
				var image:InstanceDisplay = this._main.getChildAt(index) as InstanceDisplay;
				if (image.instance.order >= ret) ret = image.instance.order + 1;
			}
			return (ret);
		}
		
		/**
		 * Toggle instance visibility.
		 * @param	id	the instance id
		 */
		public function hideInstance(id:String):void {
			for (var index:uint = 0; index < this._main.numChildren; index++) {
				var image:InstanceDisplay = this._main.getChildAt(index) as InstanceDisplay;
				if (image.instance.id == id) {
					image.shown = !image.shown;
				}
			}
		}
		
		/**
		 * Toggle instance lock.
		 * @param	id	the instance id
		 */
		public function lockInstance(id:String):void {
			for (var index:uint = 0; index < this._main.numChildren; index++) {
				var image:InstanceDisplay = this._main.getChildAt(index) as InstanceDisplay;
				if (image.instance.id == id) {
					image.mouseEnabled = !image.mouseEnabled;
				}
			}
		}
		
		/**
		 * Select an instance.
		 * @param	instance	the instance to select
		 */
		public function selectInstance(instance:InstanceDisplay):void {
			for (var index:uint = 0; index < this._main.numChildren; index++) {
				(this._main.getChildAt(index) as InstanceDisplay).selected = (this._main.getChildAt(index) == instance);
			}
		}
		
		/**
		 * Update instance selection properties.
		 * @param	instance	the instance to update
		 */
		public function selectUpdate(instance:InstanceDisplay):void {
			// update window
		}
		
		/**
		 * No intance selected.
		 */
		public function selectNone():void {
			for (var index:uint = 0; index < this._main.numChildren; index++) {
				(this._main.getChildAt(index) as InstanceDisplay).selected = false;
			}
		}
		
		/**
		 * Check for the stream votes.
		 */
		public function checkVotes():void {
			for (var index:uint = 0; index < this._votes.length; index++) {
				this._votes[index].visible = false;
				for (var index2:uint = 0; index2 < LoadedData.stream.voteoptions.length; index2++) {
					if (LoadedData.stream.voteoptions[index2].num == this._votes[index].num) {
						this._votes[index].x = LoadedData.stream.voteoptions[index2].px;
						this._votes[index].y = LoadedData.stream.voteoptions[index2].py;
						if (!LoadedData.stream.voteoptions[index2].visible) {
							this._votes[index].visible = false;
						} else {
							this._votes[index].visible = (LoadedData.stream.voteoptions[index2].action != "");
						}
					}
				}
			}
		}
		
		/**
		 * Draw current keyframe on view area.
		 */
		public function redraw():void {
			// remove any visible object
			while (this._main.numChildren > 0) {
				InstanceDisplay(this._main.getChildAt(0)).kill();
				this._main.removeChildAt(0);
			}
			// draw current keyframe images
			var instances:Array = LoadedData.stream.keyframes[LoadedData.stream.currentKeyframe].instance;
			var playlists:Array = LoadedData.stream.playlists;
			for (var index:String in instances) {
				if (playlists[instances[index].playlist] != null) if (playlists[instances[index].playlist].elements[instances[index].element] != null) {
					var child:InstanceDisplay = new InstanceDisplay(instances[index], this.notVisibleMessage, this.noElementMessage, this.stylesheet);
					if (playlists[instances[index].playlist].elements[instances[index].element].file[0].feedName != "") {
						var feedData:FeedData = this.feeds.getPost(playlists[instances[index].playlist].elements[instances[index].element].file[0].feedType, playlists[instances[index].playlist].elements[instances[index].element].file[0].feedName, uint(playlists[instances[index].playlist].elements[instances[index].element].file[0].path));
						if (playlists[instances[index].playlist].elements[instances[index].element].type == "text") {
							child.textMode = TextSprite.MODE_ARTISTIC;
							if (feedData == null) {
								child.setText("[" + this.externalFeedText + ": " + playlists[instances[index].playlist].elements[instances[index].element].file[0].feedName + ", " + this.externalFeedField + ": " + playlists[instances[index].playlist].elements[instances[index].element].file[0].feedField + ", " + this.externalFeedPost + ": " + (Number(playlists[instances[index].playlist].elements[instances[index].element].file[0].path) + 1) + "]");
							} else {
								child.setText(feedData.getField(playlists[instances[index].playlist].elements[instances[index].element].file[0].feedField));
							}
						} else if (playlists[instances[index].playlist].elements[instances[index].element].type == "paragraph") {
							child.textMode = TextSprite.MODE_PARAGRAPH;
							if (feedData == null) {
								if (child.instance.cssClass == "") child.setHTMLText("[" + this.externalFeedText + ": " + playlists[instances[index].playlist].elements[instances[index].element].file[0].feedName + ", " + this.externalFeedField + ": " + playlists[instances[index].playlist].elements[instances[index].element].file[0].feedField + ", " + this.externalFeedPost + ": " + (Number(playlists[instances[index].playlist].elements[instances[index].element].file[0].path) + 1) + ']<br /><br />Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur auctor laoreet suscipit. Praesent pretium quam eget nulla congue tincidunt. Nulla luctus, lectus in auctor tincidunt, mi lacus pharetra orci, at tristique magna nunc non dui. Vestibulum tristique arcu nec mauris tincidunt nec malesuada quam sagittis. Sed diam enim, consectetur eget facilisis vitae, dapibus a enim. Nullam mattis laoreet sem, ac sodales lectus rutrum eu. Suspendisse tempus dapibus rhoncus. Duis aliquam ligula a erat euismod quis faucibus risus aliquet. Quisque non ullamcorper lacus. Aenean cursus ullamcorper urna, et pharetra tortor auctor non. Suspendisse velit lectus, laoreet et convallis id, rhoncus ut lorem.<br /><br />Suspendisse sollicitudin scelerisque pharetra. Ut massa dolor, scelerisque non dapibus id, laoreet eu diam. Quisque sollicitudin, metus id ornare auctor, enim massa interdum erat, ac mollis odio nibh eu sapien. Sed non sapien risus. Aliquam vehicula vulputate congue. Morbi feugiat nulla at sem posuere posuere eget vitae dui. Vivamus ullamcorper feugiat augue. Integer eu dapibus felis. Proin non enim tortor. Ut ut elit eget eros blandit posuere. Vestibulum ultricies nisi ac dolor pellentesque gravida. Quisque sit amet lorem risus, id cursus erat. Nulla laoreet pretium porttitor.<br /><br />Nam eu eros ut lacus placerat tincidunt accumsan id nunc. Ut vestibulum ante et neque pellentesque imperdiet. Duis a urna velit, ac sodales libero. Ut vehicula lectus at turpis tincidunt sit amet commodo nisi ultrices. Nunc sodales accumsan metus, vel dignissim quam iaculis eu. Fusce vel neque leo. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur imperdiet aliquet diam id ultricies.');
									else child.setHTMLText('<span class="' + child.instance.cssClass + '">[' + this.externalFeedText + ": " + playlists[instances[index].playlist].elements[instances[index].element].file[0].feedName + ", " + this.externalFeedField + ": " + playlists[instances[index].playlist].elements[instances[index].element].file[0].feedField + ", " + this.externalFeedPost + ": " + (Number(playlists[instances[index].playlist].elements[instances[index].element].file[0].path) + 1) + ']<br /><br />Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur auctor laoreet suscipit. Praesent pretium quam eget nulla congue tincidunt. Nulla luctus, lectus in auctor tincidunt, mi lacus pharetra orci, at tristique magna nunc non dui. Vestibulum tristique arcu nec mauris tincidunt nec malesuada quam sagittis. Sed diam enim, consectetur eget facilisis vitae, dapibus a enim. Nullam mattis laoreet sem, ac sodales lectus rutrum eu. Suspendisse tempus dapibus rhoncus. Duis aliquam ligula a erat euismod quis faucibus risus aliquet. Quisque non ullamcorper lacus. Aenean cursus ullamcorper urna, et pharetra tortor auctor non. Suspendisse velit lectus, laoreet et convallis id, rhoncus ut lorem.<br /><br />Suspendisse sollicitudin scelerisque pharetra. Ut massa dolor, scelerisque non dapibus id, laoreet eu diam. Quisque sollicitudin, metus id ornare auctor, enim massa interdum erat, ac mollis odio nibh eu sapien. Sed non sapien risus. Aliquam vehicula vulputate congue. Morbi feugiat nulla at sem posuere posuere eget vitae dui. Vivamus ullamcorper feugiat augue. Integer eu dapibus felis. Proin non enim tortor. Ut ut elit eget eros blandit posuere. Vestibulum ultricies nisi ac dolor pellentesque gravida. Quisque sit amet lorem risus, id cursus erat. Nulla laoreet pretium porttitor.<br /><br />Nam eu eros ut lacus placerat tincidunt accumsan id nunc. Ut vestibulum ante et neque pellentesque imperdiet. Duis a urna velit, ac sodales libero. Ut vehicula lectus at turpis tincidunt sit amet commodo nisi ultrices. Nunc sodales accumsan metus, vel dignissim quam iaculis eu. Fusce vel neque leo. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur imperdiet aliquet diam id ultricies.</span>');
							} else {
								if (child.instance.cssClass == "") child.setHTMLText(feedData.getField(playlists[instances[index].playlist].elements[instances[index].element].file[0].feedField));
									else child.setHTMLText('<span class="' + child.instance.cssClass + '">' + feedData.getField(playlists[instances[index].playlist].elements[instances[index].element].file[0].feedField) + '</span>');
							}
						} else {
							if ((feedData == null) || (feedData.getField(playlists[instances[index].playlist].elements[instances[index].element].file[0].feedField)) == "") {
								child.setGraphic(new ExternalFeedDisplay("[" + this.externalFeedText + ": " + playlists[instances[index].playlist].elements[instances[index].element].file[0].feedName + ", " + this.externalFeedField + ": " + playlists[instances[index].playlist].elements[instances[index].element].file[0].feedField + ", " + this.externalFeedPost + ": " + (Number(playlists[instances[index].playlist].elements[instances[index].element].file[0].path) + 1) + "]"));
							} else {
								if (playlists[instances[index].playlist].elements[instances[index].element].type == "audio") {
									child.instance.width = child.instance.height = child.width = child.height = 64;
								}
								child.loadFile(feedData.getField(playlists[instances[index].playlist].elements[instances[index].element].file[0].feedField));
							}
						}
					} else {
						if ((playlists[instances[index].playlist].elements[instances[index].element].type == "text") || (playlists[instances[index].playlist].elements[instances[index].element].type == "paragraph")) {
							if (playlists[instances[index].playlist].elements[instances[index].element].type == "text") child.textMode = TextSprite.MODE_ARTISTIC;
								else child.textMode = TextSprite.MODE_PARAGRAPH;
							if (playlists[instances[index].playlist].elements[instances[index].element].file[0].format == "txt") {
								child.setText(playlists[instances[index].playlist].elements[instances[index].element].file[0].path);
							} else {
								child.setHTMLText(playlists[instances[index].playlist].elements[instances[index].element].file[0].path);
							}
						} else {
							if (playlists[instances[index].playlist].elements[instances[index].element].type == "audio") {
								child.instance.width = child.instance.height = child.width = child.height = 64;
							}
							child.loadFile(EditorOptions.path + EditorOptions.cfolder + "/" + LoadedData.community.id + ".dis/" + playlists[instances[index].playlist].elements[instances[index].element].file[0].path);
						}
					}
					this._main.addChild(child);
				} else {
					var childnoel:InstanceDisplay = new InstanceDisplay(instances[index], this.notVisibleMessage, this.noElementMessage, this.stylesheet);
					childnoel.setNoElement();
					this._main.addChild(childnoel);
				}
			}
			this.checkVotes();
			DisplayFunctions.zSort(this._main);
			FlexGlobals.topLevelApplication.processCommand("updateInstances");
		}
		
		/**
		 * Organize instances according to their z positions.
		 */
		public function zSort():void {
			DisplayFunctions.zSort(this._main);
		}
		
		/**
		 * Stage information is available.
		 */
		private function onStage(evt:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		/**
		 * Mouse click released.
		 */
		private function onMouseUp(evt:MouseEvent):void {
			// check for all shown instances and stop any drag
			for (var index:uint = 0; index < this._main.numChildren; index++) {
				InstanceDisplay(this._main.getChildAt(index)).dragStop();
			}
			// votes
			for (index = 0; index < this._votes.length; index++) {
				this._votes[index].dragStop();
			}
		}
		
		/**
		 * Background clicked.
		 */
		private function onBGClick(evt:MouseEvent):void {
			// remove properties selection
			FlexGlobals.topLevelApplication.processCommand("selectNone");
		}
		
	}

}
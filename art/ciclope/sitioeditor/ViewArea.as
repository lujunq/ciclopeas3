package art.ciclope.sitioeditor {
	
	// FLASH PACKAGES
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import mx.core.FlexGlobals;
	
	// CICLOPE CLASSES
	import art.ciclope.sitioeditor.LoadedData;
	import art.ciclope.sitioeditor.InstanceDisplay;
	import art.ciclope.staticfunctions.DisplayFunctions;
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class ViewArea extends Sprite {
		
		// VARIABLES
		
		private var _bg:Sprite;			// background area
		private var _main:Sprite;		// main stream graphics
		
		public function ViewArea() {
			// create background
			this._bg = new Sprite();
			this._bg.addEventListener(MouseEvent.CLICK, onBGClick);
			this.addChild(this._bg);
			// stream graphics
			this._main = new Sprite();
			this.addChild(this._main);
			// wait for stage
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
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
			this._bg.graphics.drawRect(0, 0, LoadedData.community.width, LoadedData.community.height);
			this._bg.graphics.endFill();
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
				var child:InstanceDisplay = new InstanceDisplay(instances[index]);
				child.loadFile(EditorOptions.path + EditorOptions.cfolder + "/" + LoadedData.community.id + ".dis/" + playlists[instances[index].playlist].elements[instances[index].element].file[0].path);
				this._main.addChild(child);
			}
			DisplayFunctions.zSort(this._main);
		}
		
		// EVENT
		
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
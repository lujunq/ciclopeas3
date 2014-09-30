package art.ciclope.sitioeditor.data {
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class DISInstanceED {
		
		// VARIABLES
		
		public var playlist:String = "";
		public var id:String = "";
		public var element:String = "";
		public var force:Boolean = true;
		public var width:uint = 160;
		public var height:uint = 90;
		public var px:int = 0;
		public var py:int = 0;
		public var pz:int = 0;
		public var alpha:Number = 1.0;
		public var play:Boolean = true;
		public var volume:Number = 1.0;
		public var rx:int = 0;
		public var ry:int = 0;
		public var rz:int = 0;
		public var active:Boolean = true;
		public var visible:Boolean = true;
		public var action:String = "";
		public var red:uint = 0;
		public var green:uint = 0;
		public var blue:uint = 0;
		public var blend:String = "normal";
		public var DropShadowFilter:Boolean = false;
		public var DSFalpha:Number = 1.0;
		public var DSFangle:uint = 45;
		public var DSFblurX:uint = 4;
		public var DSFblurY:uint = 4;
		public var DSFdistance:uint = 4;
		public var DSFcolor:String = "0x000000";
		public var BevelFilter:Boolean = false;
		public var BVFangle:uint = 45;
		public var BVFblurX:uint = 4;
		public var BVFblurY:uint = 4;
		public var BVFdistance:uint = 4;
		public var BVFhighlightAlpha:Number = 1;
		public var BVFshadowAlpha:Number = 1;
		public var BVFhighlightColor:String = "0xFFFFFF";
		public var BVFshadowColor:String = "0x000000";
		public var BlurFilter:Boolean = false;
		public var BLFblurX:uint = 4;
		public var BLFblurY:uint = 4;
		public var GlowFilter:Boolean = false;
		public var GLFalpha:Number = 1;
		public var GLFblurX:uint = 4;
		public var GLFblurY:uint = 4;
		public var GLFinner:Boolean = false;
		public var GLFstrength:uint = 2;
		public var GLFcolor:String = "0xFF0000";
		
		
		public function DISInstanceED() {
			
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			playlist = null;
			id = null;
			element = null;
			action = null;
			blend = null;
			DSFcolor = null;
			BVFhighlightColor = null;
			BVFshadowColor = null;
			GLFcolor = null;
		}
		
	}

}
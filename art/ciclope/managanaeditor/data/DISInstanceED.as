package art.ciclope.managanaeditor.data {
	
	// CICLOPE CLASSES
	import art.ciclope.display.MediaDisplay;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * DISInstanceED provides information about image instances for Managana editor.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class DISInstanceED {
		
		// VARIABLES
		
		public var playlist:String = "";
		public var id:String = "";
		public var element:String = "";
		public var force:Boolean = false;
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
		public var displayMode:String = "stretch";
		public var smooth:Boolean = false;
		public var transition:String = MediaDisplay.TRANSITION_FADE;
		public var leading:Object = 0;
		public var letterSpacing:Object = 0;
		public var fontcolor:String = "0x141414";
		public var fontbold:Boolean = false;
		public var fontitalic:Boolean = false;
		public var fontsize:uint = 12;
		public var fontface:String = "_sans";
		public var textalign:String = "left";
		public var charmax:uint = 0;
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
		public var order:uint = 0;
		
		public var cssClass:String = "";
		
		/**
		 * DISInstanceED constructor.
		 */
		public function DISInstanceED() { }
		
		// READ-ONLY VALUES
		
		/**
		 * An exact copy of current object.
		 */
		public function get clone():DISInstanceED {
			var clone:DISInstanceED = new DISInstanceED();
			clone.playlist = playlist;
			clone.id = id;
			clone.element = element;
			clone.force = force;
			clone.width = width;
			clone.height = height;
			clone.px = px;
			clone.py = py;
			clone.pz = pz;
			clone.alpha = alpha;
			clone.play = play;
			clone.volume = volume;
			clone.rx = rx;
			clone.ry = ry;
			clone.rz = rz;
			clone.active = active;
			clone.visible = visible;
			clone.action = action;
			clone.red = red;
			clone.green = green;
			clone.blue = blue;
			clone.blend = blend;
			clone.displayMode = displayMode;
			clone.smooth = smooth;
			clone.transition = transition;
			clone.leading = leading;
			clone.letterSpacing = letterSpacing;
			clone.fontcolor = fontcolor;
			clone.fontbold = fontbold;
			clone.fontitalic = fontitalic;
			clone.fontsize = fontsize;
			clone.fontface = fontface;
			clone.textalign = textalign;
			clone.charmax = charmax;
			clone.DropShadowFilter = DropShadowFilter;
			clone.DSFalpha = DSFalpha;
			clone.DSFangle = DSFangle;
			clone.DSFblurX = DSFblurX;
			clone.DSFblurY = DSFblurY;
			clone.DSFdistance = DSFdistance;
			clone.DSFcolor = DSFcolor;
			clone.BevelFilter = BevelFilter;
			clone.BVFangle = BVFangle;
			clone.BVFblurX = BVFblurX;
			clone.BVFblurY = BVFblurY;
			clone.BVFdistance = BVFdistance;
			clone.BVFhighlightAlpha = BVFhighlightAlpha;
			clone.BVFshadowAlpha = BVFshadowAlpha;
			clone.BVFhighlightColor = BVFhighlightColor;
			clone.BVFshadowColor = BVFshadowColor;
			clone.BlurFilter = BlurFilter;
			clone.BLFblurX = BLFblurX;
			clone.BLFblurY = BLFblurY;
			clone.GlowFilter = GlowFilter;
			clone.GLFalpha = GLFalpha;
			clone.GLFblurX = GLFblurX;
			clone.GLFblurY = GLFblurY;
			clone.GLFinner = GLFinner;
			clone.GLFstrength = GLFstrength;
			clone.GLFcolor = GLFcolor;
			clone.order = order;
			clone.cssClass = cssClass;
			return (clone);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			playlist = null;
			id = null;
			element = null;
			action = null;
			blend = null;
			displayMode = null;
			transition = null;
			DSFcolor = null;
			BVFhighlightColor = null;
			BVFshadowColor = null;
			GLFcolor = null;
			fontface = null;
			fontcolor = null;
			textalign = null;
			cssClass = null;
		}
		
	}

}
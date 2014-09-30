package art.ciclope.staticfunctions {
	
	// FLASH PACKAGES
	import flash.display.Sprite;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * DisplayFunctions provides static methods for handling display objects.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class DisplayFunctions {
		
		// STATIC METHODS
		
		/**
		 * Sort all children from a sprite according to their z position.
		 * @param	obj	the sprite to check
		 */
		public static function zSort(obj:Sprite):void {
			if (obj != null) {
				var children:Array = new Array();
				for (var index:uint = 0; index < obj.numChildren; index++) {
					children.push(obj.getChildAt(index));
				}
				if (children.length > 0) {
					if (children[0].hasOwnProperty("order")) children.sortOn(["z", "order"], [Array.DESCENDING, Array.NUMERIC]);
						else children.sortOn("z", Array.DESCENDING);
					for (index = 0; index < obj.numChildren; index++) {
						obj.setChildIndex(children[index], index);
					}
					while (children.length > 0) children.shift();
				}
				children = null;
			}
		}
		
	}

}
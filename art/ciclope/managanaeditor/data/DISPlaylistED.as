package art.ciclope.managanaeditor.data {
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * DISPlaylistED provides information about playlists for Managana editor.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class DISPlaylistED {
		
		/**
		 * Playlist name.
		 */
		public var name:String = "";
		/**
		 * Playlist id.
		 */
		public var id:String = "";
		/**
		 * Playlist author.
		 */
		public var author:DISAuthorED = new DISAuthorED();
		/**
		 * About this playlist.
		 */
		public var about:String = "";
		/**
		 * Is playlist locked (used by someone else)? An empty string means no.
		 */
		public var locked:String = "";
		/**
		 * Playlist elements.
		 */
		public var elements:Array = new Array();
		
		/**
		 * DISPlaylistED constructor.
		 */
		public function DISPlaylistED() { }
		
		// READ-ONLY VALUES
		
		/**
		 * The current number of elements.
		 */
		public function get numElements():uint {
			var ret:uint = 0;
			for (var index:String in this.elements) ret++;
			return (ret);
		}
		
		/**
		 * An indexed (not associative) array with elements on their correct order.
		 */
		public function get sortedElements():Array {
			var ret:Array = new Array(this.numElements);
			for (var index:String in this.elements) {
				ret[this.elements[index].order] = this.elements[index];
			}
			return (ret);
		}
		
		/**
		 * An exact copy of current playlist.
		 */
		public function get clone():DISPlaylistED {
			var ret:DISPlaylistED = new DISPlaylistED();
			ret.name = this.name;
			ret.id = this.id;
			ret.author = this.author.clone;
			ret.about = this.about;
			for (var index:String in this.elements) {
				ret.elements[index] = this.elements[index].clone;
			}
			return(ret);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Process a playlist xml data.
		 * @param	data	a standard playlist xml
		 */
		public function processs(data:XML):void {
			this.locked = String(data.locked);
			this.id = String(data.id);
			this.name = String(data.meta.title);
			this.about = String(data.meta.about);
			this.author.name = String(data.meta.author);
			this.author.id = String(data.meta.author.@id);
			for (var index2:uint = 0; index2 < data.elements.child("element").length(); index2++) {
				var element:DISElementED = new DISElementED();
				element.id = String(data.elements.element[index2].@id);
				element.type = String(data.elements.element[index2].@type);
				element.time = uint(data.elements.element[index2].@time);
				element.end = String(data.elements.element[index2].@end);
				element.order = index2;
				for (var index3:uint = 0; index3 < data.elements.element[index2].child("file").length(); index3++) {
					var file:DISElementFileED = new DISElementFileED();
					file.format = String(data.elements.element[index2].file[index3].@format);
					file.lang = String(data.elements.element[index2].file[index3].lang);
					file.absolute = Boolean(uint(data.elements.element[index2].file[index3].@absolute));
					file.path = String(data.elements.element[index2].file[index3]);
					file.feedName = String(data.elements.element[index2].file[index3].@feed);
					file.feedType = String(data.elements.element[index2].file[index3].@feedType);
					file.feedField = String(data.elements.element[index2].file[index3].@field);
					element.file.push(file);
				}
				for (index3 = 0; index3 < data.elements.element[index2].child("action").length(); index3++) {
					if (data.elements.element[index2].action[index3].hasOwnProperty('@time')) {
						element.setAction(uint(data.elements.element[index2].action[index3].@time), String(data.elements.element[index2].action[index3]), String(data.elements.element[index2].action[index3].@type));
					}
				}
				this.elements[element.id] = element;
			}
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			this.name = null;
			this.id = null;
			this.about = null;
			this.locked = null;
			this.author.kill();
			for (var index:String in this.elements) {
				this.elements[index].kill();
				delete(this.elements[index]);
			}
		}
	}

}
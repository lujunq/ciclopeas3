package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldAutoSize;
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaInterface;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * CommentItem provides a graphic interface for comment list item.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class CommentItem extends Sprite {
		
		// VARIABLES
		
		private var _separator:Sprite;			// separator line
		private var _bg:Shape;					// invisible background 
		private var _text:TextField;			// comment text
		
		/**
		 * CommentItem constructor.
		 * @param	text	the item text
		 * @param	user	the item user name
		 * @param	time	the item time
		 * @param	width	the item width
		 */
		public function CommentItem(text:String, user:String, time:String, width:Number = 150) {
			// prepare graphics
			this._bg = new Shape();
			this._bg.graphics.beginFill(0, 0);
			this._bg.graphics.drawRect(0, 0, 100, 100);
			this._bg.graphics.endFill();
			this.addChild(this._bg);
			this._separator = new SeparatorLine() as Sprite;
			ManaganaInterface.setSize(this._separator);
			this.addChild(this._separator);
			this._text = new TextField();
			this._text.selectable = false;
			this._text.multiline = true;
			this._text.wordWrap = true;
			this._text.autoSize = TextFieldAutoSize.LEFT;
			this._text.defaultTextFormat = new TextFormat("_sans", ManaganaInterface.newSize(16), 0xFFFFFF, false, false, false, null, null, TextFormatAlign.LEFT);
			if (time == "") {
				this._text.htmlText = '<font face="_sans" color="0xFFFFFF" size="' + ManaganaInterface.newSize(16) + '">' + text + '</font><br><font face="_sans" color="0xFFFFFF" size="' + ManaganaInterface.newSize(14) + '"><b>' + user + '</b></font>';
			} else {
				this._text.htmlText = '<font face="_sans" color="0xFFFFFF" size="' + ManaganaInterface.newSize(16) + '">' + text + '</font><br><font face="_sans" color="0xFFFFFF" size="' + ManaganaInterface.newSize(14) + '"><b>' + user + '</b>&nbsp;&nbsp;(' + time + ')</font>';
			}
			this.addChild(this._text);
			this.width = width;
			this.mouseChildren = false;
		}
		
		// PROPERTIES
		
		/**
		 * Item width.
		 */
		override public function get width():Number {
			return (super.width);
		}
		override public function set width(value:Number):void {
			this._bg.width = value;
			this._text.width = value - 20;
			this._text.x = this._text.y = 5;
			this._bg.height = this._text.height + 5;
			this._separator.width = value;
			this._separator.y = this._bg.height - this._separator.height;
		}
		
		/**
		 * Item height (read-only).
		 */
		override public function get height():Number {
			return super.height;
		}
		override public function set height(value:Number):void {
			// do nothing
		}
		
		/**
		 * Is item separator line visible?
		 */
		public function get separatorVisible():Boolean {
			return (this._separator.visible);
		}
		public function set separatorVisible(to:Boolean):void {
			this._separator.visible = to;
		}
		
		// PUBLIC METHODS
		
		/**
		 * Set the item text.
		 * @param	text	comment text
		 * @param	user	user name
		 * @param	time	comment time
		 */
		public function setText(text:String, user:String, time:String):void {
			if (time == "") {
				this._text.htmlText = '<font face="_sans" color="0xFFFFFF" size="' + ManaganaInterface.newSize(16) + '">' + text + '</font><br><font face="_sans" color="0xFFFFFF" size="' + ManaganaInterface.newSize(14) + '"><b>' + user + '</b></font>';
			} else {
				this._text.htmlText = '<font face="_sans" color="0xFFFFFF" size="' + ManaganaInterface.newSize(16) + '">' + text + '</font><br><font face="_sans" color="0xFFFFFF" size="' + ManaganaInterface.newSize(14) + '"><b>' + user + '</b>&nbsp;&nbsp;(' + time + ')</font>';
			}
			this.width = this.width;
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			this.removeChild(this._bg);
			this._bg.graphics.clear();
			this._bg = null;
			this.removeChild(this._separator);
			this._separator = null;
			this.removeChild(this._text);
			this._text = null;
		}
		
	}

}
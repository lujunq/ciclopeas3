package art.ciclope.managana.graphics {
	
	// FLASH PACKAGES
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldAutoSize;
	
	// CICLOPE CLASSES
	import art.ciclope.event.CommunityContentEvent;
	import art.ciclope.managana.ManaganaInterface;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * CommunityContentItem provides a graphic interface for community content list item.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class CommunityContentItem extends Sprite {
		
		// VARIABLES
		
		private var _separator:Sprite;			// separator line
		private var _bg:Shape;					// invisible background 
		private var _text:TextField;			// comment text
		private var _open:Sprite;				// the open stream button
		private var _state:Sprite;				// the state button
		
		// PUBLIC VARIABLES
		
		/**
		 * The community update time.
		 */
		public var update:String = "";
		
		/**
		 * The comunity content state.
		 */
		public var state:String = "";
		
		/**
		 * The community title.
		 */
		public var title:String = "";
		
		/**
		 * The community id.
		 */
		public var id:String = "";
		
		/**
		 * CommentItem constructor.
		 * @param	id	community id
		 * @param	update	community update
		 * @param	state	community state
		 * @param	title	community title
		 * @param	offmark	offline mark text
		 * @param	width	the item width
		 */
		public function CommunityContentItem(id:String, update:String, state:String, title:String, offmark:String, width:Number = 150) {
			// prepare graphics
			this._bg = new Shape();
			this._bg.graphics.beginFill(0, 0);
			this._bg.graphics.drawRect(0, 0, 100, 100);
			this._bg.graphics.endFill();
			this.addChild(this._bg);
			this._separator = new SeparatorLine() as Sprite;
			ManaganaInterface.setSize(this._separator);
			this.addChild(this._separator);
			this._open = new ButtonLink() as Sprite;
			this._open.x = this._open.y = 5;
			this._open.width = this._open.height = ManaganaInterface.newSize(40);
			this._open.addEventListener(MouseEvent.CLICK, onOpenClick);
			this._open.useHandCursor = true;
			this._open.buttonMode = true;
			this.addChild(this._open);
			if ((state == 'update') || (state == 'updating')){
				this._state = new ButtonCInfoUpdate() as Sprite;
			} else {
				this._state = new ButtonCInfo() as Sprite;
			}
			this._state.x = this._open.x + this._open.width + 5;
			this._state.y = 5;
			this._state.width = this._state.height = ManaganaInterface.newSize(40);
			this._state.addEventListener(MouseEvent.CLICK, onStateClick);
			this._state.useHandCursor = true;
			this._state.buttonMode = true;
			this.addChild(this._state);
			this._text = new TextField();
			this._text.selectable = false;
			this._text.multiline = true;
			this._text.wordWrap = true;
			this._text.autoSize = TextFieldAutoSize.LEFT;
			this._text.defaultTextFormat = new TextFormat("_sans", ManaganaInterface.newSize(16), 0xFFFFFF, false, false, false, null, null, TextFormatAlign.LEFT);
			if ((state == "offline") || (state == "update")) this._text.htmlText = '<font face="_sans" color="0xFFFFFF" size="' + ManaganaInterface.newSize(16) + '"><b>' + title + '</b></font> <font face="_sans" color="0xFFFFFF" size="' + ManaganaInterface.newSize(14) + '"><i>' + offmark + '</i></font>';
				else this._text.htmlText = '<font face="_sans" color="0xFFFFFF" size="' + ManaganaInterface.newSize(16) + '"><b>' + title + '</b></font>';
			this.addChild(this._text);
			this.width = width;
			this._separator.mouseEnabled = false;
			this._text.mouseEnabled = false;
			this.id = id;
			this.update = update;
			this.state = state;
			this.title = title;
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
			this._text.x = this._state.x + this._state.width + 5;
			this._text.width = value - 20 - this._open.width - this._state.width - 15;
			this._bg.height = this._text.height + 5;
			if (this._bg.height < (this._open.height + 10)) {
				this._bg.height = this._open.height + 10;
				this._text.y = (this._bg.height - this._text.height) / 2;
				this._open.y = this._state.y = 5;
			} else {
				this._open.y = this._state.y = (this._bg.height - this._open.height) / 2;
			}
			this._separator.width = value;
			this._separator.y = this._bg.height - this._separator.height;
		}
		
		/**
		 * Item height (read-only).
		 */
		override public function get height():Number {
			return (this._bg.height);
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
		 * @param	title	the item title
		 */
		public function setText(title:String):void {
			this._text.htmlText = '<font face="_sans" color="0xFFFFFF" size="16"><b>' + title + '</b></font>';
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
			this.removeChild(this._open);
			this._open.removeEventListener(MouseEvent.CLICK, onOpenClick);
			this._open = null;
			this.removeChild(this._state);
			this._state.removeEventListener(MouseEvent.CLICK, onStateClick);
			this._state = null;
			this.removeChild(this._text);
			this._text = null;
			this.id = null;
			this.update = null;
			this.state = null;
			this.title = null;
		}
		
		// PRIVATE METHODS
		
		/**
		 * Open community button clicked.
		 */
		private function onOpenClick(evt:MouseEvent):void {
			this.dispatchEvent(new Event(Event.OPEN));
		}
		
		/**
		 * Remove item button clicked.
		 */
		private function onStateClick(evt:MouseEvent):void {
			this.dispatchEvent(new CommunityContentEvent(CommunityContentEvent.GET_INFO, (this.id + "|it|" + this.title + "|it|" + this.state)));
		}
		
	}

}

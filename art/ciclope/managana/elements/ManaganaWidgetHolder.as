package art.ciclope.managana.elements {
	
	// FLASH PACKAGES
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaPlayer;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * ManaganaWidgetHolder creates a holder object to load a widget applet into the Managana player.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class ManaganaWidgetHolder extends EventDispatcher {
		
		// VARIABLES
		
		private var _name:String;				// the widget name given by Managana player
		private var _loader:Loader;				// the widget loader object
		private var _ready:Boolean = false;		// is the widget downloaded and ready?
		private var _widget:Object;				// the widget communication interface
		private var _player:ManaganaPlayer;		// a reference to the Managana playeer
		
		/**
		 * ManaganaWidgetHolder constructor.
		 * @param	name	the widget name given by Managana player
		 * @param	community	the current community download path
		 * @param	player	a reference to the Managana player
		 */
		public function ManaganaWidgetHolder(name:String, community:String, player:ManaganaPlayer) {
			super(null);
			this._name = name;
			this._player = player;
			this._loader = new Loader();
			this._loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaded);
			this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			this._loader.load(new URLRequest(community + '/media/community/widget/' + name + '.swf'));
		}
		
		// READ-ONLY VALUES
		
		/**
		 * Widget name given by the Managana player.
		 */
		public function get name():String {
			return (this._name);
		}
		
		/**
		 * Is the widget downloaded and ready?
		 */
		public function get ready():Boolean {
			return (this._ready);
		}
		
		/**
		 * The widget display output object (null if not ready).
		 */
		public function get widgetDisplay():DisplayObject {
			if (this._ready) {
				return (this._loader);
			} else {
				return (null);
			}
		}
		
		/**
		 * A reference to the loaded widget object itself (null if not loaded yet or on error).
		 */
		public function get widgetObject():Object {
			return (this._widget);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Warn the widget about a Managana player event.
		 * @param	about	the evet to warn about
		 */
		public function warn(about:String):void {
			if (this._ready) {
				switch (about) {
					case 'hide':
						this._widget.__display(ManaganaWidget.DISPLAY_NONE);
						break;
					case 'showAbove':
						this._widget.__display(ManaganaWidget.DISPLAY_ABOVE);
						break;
					case 'showBelow':
						this._widget.__display(ManaganaWidget.DISPLAY_BELOW);
						break;
					case 'newStream':
						this._widget.__streamChange();
						break;
					case 'aspectChange':
						this._widget.__aspectChange();
						break;
				}
			}
		}
		
		/**
		 * Call an exposed custom method on the widget.
		 * @param	method	the exposed method name
		 * @param	param	a string parameter to send
		 */
		public function callMethod(method:String, param:String = null):void {
			if (this._ready) {
				if (param != null) {
					this._widget.__callCustomParam(method, param);
				} else {
					this._widget.__callCustom(method);
				}
			}
		}
		
		/**
		 * Release resources used by the object.
		 */
		public function kill():void {
			if (this._loader.parent != null) {
				this._loader.parent.removeChild(this._loader);
			}
			if (this._loader.contentLoaderInfo.hasEventListener(Event.INIT)) {
				this._loader.contentLoaderInfo.removeEventListener(Event.INIT, onLoaded);
			}
			if (this._loader.contentLoaderInfo.hasEventListener(IOErrorEvent.IO_ERROR)) {
				this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			}
			this._loader.unloadAndStop();
			if (this._ready) {
				this._widget.__dispose();
			}
			this._name = null;
			this._loader = null;
			this._widget = null;
			this._player = null;
		}
		
		// PRIVATE METHODS
		
		/**
		 * The widget fails to load.
		 */
		private function onLoadError(evt:IOErrorEvent):void {
			this._loader.contentLoaderInfo.removeEventListener(Event.INIT, onLoaded);
			this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		}
		
		/**
		 * The widget file was loaded.
		 */
		private function onLoaded(evt:Event):void {
			this._loader.contentLoaderInfo.removeEventListener(Event.INIT, onLoaded);
			this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			this._widget = this._loader.contentLoaderInfo.content;
			this._widget.__startup(this._name, this._player);
			this._ready = true;
		}
	}

}
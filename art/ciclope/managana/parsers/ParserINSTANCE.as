package art.ciclope.managana.parsers {
	
	// CICLOPE CLASSES
	import art.ciclope.managana.ManaganaImage;
	import art.ciclope.managana.ManaganaPlayer;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * ParserINSTANCE handles all Managana progress code related to image instances.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class ParserINSTANCE {
		
		// VARIABLES
		
		private var _player:ManaganaPlayer;		// reference to player
		
		/**
		 * ParserINSTANCE constructor.
		 * @param	player	a reference to the Managana player
		 */
		public function ParserINSTANCE(player:ManaganaPlayer) {
			this._player = player;
		}
		
		/**
		 * Release memory used by this object.
		 */
		public function kill():void {
			this._player = null;
		}
		
		/**
		 * Check if a code line is valid.
		 * @param	line	the code line to check
		 * @return	true if the line is valid, false otherwise
		 */
		public function check(line:Array):Boolean {
			var ret:Boolean = true;
			if (line[0] != "INSTANCE") {
				ret = false;
			} else {
				if ((line[1] != null) && (line[1] != "")) {
					switch (line[2]) {
						case "runCode":
						case "webcam":
						case "clearWebcam":
						case "forceLoop":
						case "unforceLoop":
						case "fullScreen":
						case "clearFullScreen":
						case "hideSubtitle":
						case "showSubtitle":
						case "toggleSubtitle":
						case "next":
						case "pause":
						case "play":
						case "previous":
						case "hide":
						case "show":
						case "clearAllSets":
						case "clearElement":
						case "clearURL":
						case "clearSubtitle":
						case "scrollUp":
						case "scrollDown":
						case "scrollTop":
						case "scrollBottom":
							ret = true;
							break;
						case "element":
						case "mediaURL":
						case "setSubtitle":
						case "clearSet":
						case "seek":
							if (line[3] != null) ret = true;
								else ret = false;
							break;
						case "set":
							if ((line[3] == "x") || (line[3] == "y") || (line[3] == "z")) {
								if (line[4] != null) ret = true;
									else ret = false;
							}
							if ((line[3] == "width") || (line[3] == "height")) {
								if (line[4] != null) ret = true;
									else ret = false;
							}
							if ((line[3] == "rx") || (line[3] == "ry") || (line[3] == "rz")) {
								if (line[4] != null) ret = true;
									else ret = false;
							}
							if ((line[3] == "alpha") || (line[3] == "blend") || (line[3] == "volume")) {
								if (line[4] != null) ret = true;
									else ret = false;
							}
							if ((line[3] == "red") || (line[3] == "green") || (line[3] == "blue")) {
								if (line[4] != null) ret = true;
									else ret = false;
							}
							break;
						default:
							ret = false;
							break;
					}
				} else {
					ret = false;
				}
			}
			return(ret);
		}
		
		/**
		 * Run a progress code line.
		 * @param	line	the code line to check
		 */
		public function run(line:Array):void {
			var image:ManaganaImage = this._player.getImage(line[1]);
			if (image != null) {
				switch (line[2]) {
					case "runCode":
						this._player.run(image.progressCode);
						break;
					case "webcam":
						image.loadWebcam();
						break;
					case "clearWebcam":
						image.clearWebcam();
						break;
					case "forceLoop":
						image.force("loop", true);
						break;
					case "unforceLoop":
						image.unforce("loop");
						break;
					case "fullScreen":
						image.force("width", this._player.width);
						image.force("height", this._player.height);
						image.force("x", 0);
						image.force("y", 0);
						image.force("z", 0);
						break;
					case "clearFullScreen":
						image.unforce("width");
						image.unforce("height");
						image.unforce("x");
						image.unforce("y");
						image.unforce("z");
						break;
					case "hideSubtitle":
						image.subtitleVisible = false;
						break;
					case "showSubtitle":
						image.subtitleVisible = true;
						break;
					case "toggleSubtitle":
						image.toggleSubtitle();
						break;
					case "next":
						image.next();
						break;
					case "pause":
						image.pause();
						break;
					case "play":
						image.play( -1, true);
						break;
					case "seek":
						image.seek(uint(Math.round(Number(line[3]))));
						break;
					case "previous":
						image.previous();
						break;
					case "hide":
						image.force("visible", false);
						break;
					case "show":
						image.force("visible", true);
						break;
					case "clearAllSets":
						image.unforceAll();
						break;
					case "element":
						image.force("element", String(line[3]));
						break;
					case "clearElement":
						image.unforce("element");
						break;
					case "mediaURL":
						image.force("url", String(line[3]));
						break;
					case "clearURL":
						image.unforce("url");
						break;
					case "setSubtitle":
						image.setSubtitle(String(line[3]));
						break;
					case "clearSubtitle":
						image.setSubtitle(null);
						break;
					case "clearSet":
						image.unforce(String(line[3]));
						break;
					case "set":
						image.force(String(line[3]), line[4]);
						break;
					case "scrollUp":
						image.textScrollV++;
						break;
					case "scrollDown":
						image.textScrollV--;
						break;
					case "scrollTop":
						image.textScrollV = 0;
						break;
					case "scrollBottom":
						image.textScrollV = image.textMaxScrollV;
						break;
				}
			}
		}
		
	}

}
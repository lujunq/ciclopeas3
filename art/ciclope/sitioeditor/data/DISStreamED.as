package art.ciclope.sitioeditor.data {
	import art.ciclope.sitio.data.DISElementFile;
	
	/**
	 * ...
	 * @author Lucas Junqueira
	 */
	public class DISStreamED {
		
		// PUBLIC VARIABLES
		
		/**
		 * Stream id.
		 */
		public var id:String = "";
		/**
		 * Stream title.
		 */
		public var title:String = "";
		/**
		 * Stream author.
		 */
		public var author:DISAuthorED = new DISAuthorED();
		/**
		 * Stream about text.
		 */
		public var about:String = "";
		/**
		 * Stream tags.
		 */
		public var tags:String = "";
		/**
		 * Stream update.
		 */
		public var update:String = "";
		/**
		 * Stream categories.
		 */
		public var categories:Array = new Array();
		/**
		 * Stream plugins.
		 */
		public var plugins:Array = new Array();
		/**
		 * Stream upper guide.
		 */
		public var guideup:String = "";
		/**
		 * Stream upper guide id.
		 */
		public var guideupid:String = "";
		/**
		 * Stream lower guide.
		 */
		public var guidedown:String = "";
		/**
		 * Stream lower guide id.
		 */
		public var guidedownid:String = "";
		/**
		 * Stream speed.
		 */
		public var speed:uint = 3;
		/**
		 * Stream tweening method.
		 */
		public var tweening:String = "linear";
		/**
		 * Stream fade method.
		 */
		public var fade:String = "fade";
		/**
		 * Stream entropy level.
		 */
		public var entropy:uint = 0;
		/**
		 * Stream distortion level.
		 */
		public var distortion:uint = 0;
		/**
		 * Stream target id.
		 */
		public var target:String = "";
		/**
		 * Stream uses voting?.
		 */
		public var vote:Boolean = false;
		/**
		 * Stream voting type.
		 */
		public var votetype:String = "timer";
		/**
		 * Stream voting reference.
		 */
		public var votereference:String = "10";
		/**
		 * Stream voting show.
		 */
		public var voteshow:String = "this";
		/**
		 * Stream voting options.
		 */
		public var voteoptions:Array = new Array();
		/**
		 * Stream playlists.
		 */
		public var playlists:Array = new Array();
		/**
		 * Stream keyframes.
		 */
		public var keyframes:Array = new Array();
		/**
		 * Is this a new Stream?
		 */
		public var newStream:Boolean = false;
		/**
		 * The current keyframe.
		 */
		public var currentKeyframe:uint = 0;
		
		public function DISStreamED() {
			
		}
		
		// PUBLIC METHODS
		
		/**
		 * Get stream data from a xml.
		 * @param	data	xml stream information
		 */
		public function getData(data:XML):void {
			this.clear();
			id = String(data.id);
			title = String(data.meta[0].title);
			author.name = String(data.meta[0].author);
			author.id = String(data.meta[0].author.@id);
			about = String(data.meta[0].about);
			tags = String(data.meta[0].tags);
			update = String(data.meta[0].update);
			speed = uint(data.animation[0].speed);
			tweening = String(data.animation[0].tweening);
			fade = String(data.animation[0].fade);
			entropy = uint(data.animation[0].entropy);
			distortion = uint(data.animation[0].distortion);
			target = String(data.animation[0].target);
			// load keyframes
			if (data.keyframes.child("keyframe").length() > 0) {
				// remove previous blank keyframe
				while (keyframes.length > 0) {
					keyframes[0].kill();
					keyframes.shift();
				}
				for (var index:uint = 0; index < data.keyframes.child("keyframe").length(); index++) {
					keyframes.push(new DISKeyframeED());
					for (var index2:uint = 0; index2 < data.keyframes.keyframe[index].child("instance").length(); index2++) {
						var instance:DISInstanceED = new DISInstanceED();
						instance.id = String(data.keyframes.keyframe[index].instance[index2].@id);
						instance.playlist = String(data.keyframes.keyframe[index].instance[index2].@playlist);
						instance.element = String(data.keyframes.keyframe[index].instance[index2].@element);
						instance.px = int(data.keyframes.keyframe[index].instance[index2].@px);
						instance.py = int(data.keyframes.keyframe[index].instance[index2].@py);
						instance.pz = int(data.keyframes.keyframe[index].instance[index2].@pz);
						instance.width = uint(data.keyframes.keyframe[index].instance[index2].@width);
						instance.height = uint(data.keyframes.keyframe[index].instance[index2].@height);
						instance.alpha = Number(data.keyframes.keyframe[index].instance[index2].@alpha);
						instance.volume = Number(data.keyframes.keyframe[index].instance[index2].@volume);
						instance.rx = int(data.keyframes.keyframe[index].instance[index2].@rx);
						instance.ry = int(data.keyframes.keyframe[index].instance[index2].@ry);
						instance.rz = int(data.keyframes.keyframe[index].instance[index2].@rz);
						instance.force = Boolean(uint(data.keyframes.keyframe[index].instance[index2].@force));
						instance.play = Boolean(uint(data.keyframes.keyframe[index].instance[index2].@play));
						instance.active = Boolean(uint(data.keyframes.keyframe[index].instance[index2].@active));
						instance.visible = Boolean(uint(data.keyframes.keyframe[index].instance[index2].@visible));
						instance.red = uint(data.keyframes.keyframe[index].instance[index2].@red);
						instance.green = uint(data.keyframes.keyframe[index].instance[index2].@green);
						instance.blue = uint(data.keyframes.keyframe[index].instance[index2].@blue);
						instance.blend = String(data.keyframes.keyframe[index].instance[index2].@blend);
						instance.DropShadowFilter = Boolean(uint(data.keyframes.keyframe[index].instance[index2].@DropShadowFilter));
						instance.DSFalpha = Number(data.keyframes.keyframe[index].instance[index2].@DSFalpha);
						instance.DSFangle = uint(data.keyframes.keyframe[index].instance[index2].@DSFangle);
						instance.DSFblurX = uint(data.keyframes.keyframe[index].instance[index2].@DSFblurX);
						instance.DSFblurY = uint(data.keyframes.keyframe[index].instance[index2].@DSFblurY);
						instance.DSFdistance = uint(data.keyframes.keyframe[index].instance[index2].@DSFdistance);
						instance.DSFcolor = String(data.keyframes.keyframe[index].instance[index2].@DSFcolor);
						instance.BevelFilter = Boolean(uint(data.keyframes.keyframe[index].instance[index2].@BevelFilter));
						instance.BVFangle = uint(data.keyframes.keyframe[index].instance[index2].@DSFangle);
						instance.BVFblurX = uint(data.keyframes.keyframe[index].instance[index2].@DSFblurX);
						instance.BVFblurY = uint(data.keyframes.keyframe[index].instance[index2].@DSFblurY);
						instance.BVFdistance = uint(data.keyframes.keyframe[index].instance[index2].@DSFdistance);
						instance.BVFhighlightAlpha = Number(data.keyframes.keyframe[index].instance[index2].@BVFhighlightAlpha);
						instance.BVFshadowAlpha = Number(data.keyframes.keyframe[index].instance[index2].@BVFshadowAlpha);
						instance.BVFhighlightColor = String(data.keyframes.keyframe[index].instance[index2].@BVFhighlightColor);
						instance.BVFshadowColor = String(data.keyframes.keyframe[index].instance[index2].@BVFshadowColor);
						instance.BlurFilter = Boolean(uint(data.keyframes.keyframe[index].instance[index2].@BlurFilter));
						instance.BLFblurX = uint(data.keyframes.keyframe[index].instance[index2].@BLFblurX);
						instance.BLFblurY = uint(data.keyframes.keyframe[index].instance[index2].@BLFblurY);
						instance.GlowFilter = Boolean(uint(data.keyframes.keyframe[index].instance[index2].@GlowFilter));
						instance.GLFalpha = Number(data.keyframes.keyframe[index].instance[index2].@GLFalpha);
						instance.GLFblurX = uint(data.keyframes.keyframe[index].instance[index2].@GLFblurX);
						instance.GLFblurY = uint(data.keyframes.keyframe[index].instance[index2].@GLFblurY);
						instance.GLFstrength = uint(data.keyframes.keyframe[index].instance[index2].@GLFstrength);
						instance.GLFinner = Boolean(uint(data.keyframes.keyframe[index].instance[index2].@GLFinner));
						instance.GLFcolor = String(data.keyframes.keyframe[index].instance[index2].@GLFcolor);
						instance.action = String(data.keyframes.keyframe[index].instance[index2]);
						keyframes[index].instance[instance.id] = instance;
					}
				}
			}
			// load playlists
			if (data.playlists.child("playlist").length() > 0) {
				for (index = 0; index < data.playlists.child("playlist").length(); index++) {
					var playlist:DISPlaylistED = new DISPlaylistED();
					playlist.id = String(data.playlists.playlist[index].id);
					playlist.name = String(data.playlists.playlist[index].meta.title);
					playlist.author.name = String(data.playlists.playlist[index].author);
					playlist.author.id = String(data.playlists.playlist[index].author.@id);
					for (index2 = 0; index2 < data.playlists.playlist[index].elements.child("element").length(); index2++) {
						var element:DISElementED = new DISElementED();
						element.id = String(data.playlists.playlist[index].elements.element[index2].@id);
						element.type = String(data.playlists.playlist[index].elements.element[index2].type);
						element.time = uint(data.playlists.playlist[index].elements.element[index2].time);
						for (var index3:uint = 0; index3 < data.playlists.playlist[index].elements.element[index2].child("file").length(); index3++) {
							var file:DISElementFileED = new DISElementFileED();
							file.format = String(data.playlists.playlist[index].elements.element[index2].file[index3].@format);
							file.lang = String(data.playlists.playlist[index].elements.element[index2].file[index3].lang);
							file.absolute = Boolean(uint(data.playlists.playlist[index].elements.element[index2].file[index3].@absolute));
							file.path = String(data.playlists.playlist[index].elements.element[index2].file[index3]);
							element.file.push(file);
						}
						playlist.elements[element.id] = element;
					}
					this.playlists[playlist.id] = playlist;
				}
				
			}
		}
		
		/**
		 * A xml description of loaded playlists.
		 */
		public function get playlistxml():String {
			var desc:String = '<?xml version="1.0" encoding="UTF-8"?><data>';
			for (var index:String in this.playlists) {
				desc += '<playlist>';
				desc += '<id>' + this.playlists[index].id + '</id>';
				desc += '<meta>';
				desc += '<title>' + this.playlists[index].name + '</title>';
				desc += '<author id="' + this.playlists[index].author.id + '">' + this.playlists[index].author.name + '</author>';
				desc += '<about>' + this.playlists[index].about + '</about>';
				desc += '</meta>';
				desc += '<elements>';
				for (var index2:String in this.playlists[index].elements) {
					desc += '<element id="' + this.playlists[index].elements[index2].id + '" time="' + this.playlists[index].elements[index2].time + '" type="' + this.playlists[index].elements[index2].type + '" order="' + this.playlists[index].elements[index2].order + '">';
					for (var index3:uint = 0; index3 < this.playlists[index].elements[index2].file.length; index3++) {
						desc += '<file format="' + this.playlists[index].elements[index2].file[index3].format + '" lang="' + this.playlists[index].elements[index2].file[index3].lang + '" absolute="' + this.playlists[index].elements[index2].file[index3].absolute + '">' + this.playlists[index].elements[index2].file[index3].path + '</file>';
					}
					desc += '</element>';
				}
				desc += '</elements>';
				desc += '</playlist>';
			}
			desc += '</data>';
			return(desc);
		}
		
		/**
		 * A xml description of keyframes.
		 */
		public function get keyframexml():String {
			var desc:String = '<?xml version="1.0" encoding="UTF-8"?><data>';
			for (var index:uint = 0; index < this.keyframes.length; index++) {
				desc += '<keyframe>';
				desc += '<order>' + index + '</order>';
				for (var index2:String in this.keyframes[index].instance) {
					var instance:DISInstanceED = this.keyframes[index].instance[index2];
					desc += '<instance playlist="' + instance.playlist + '" element="' + instance.element + '" id="' + instance.id + '" ';
					desc += ' width="' + instance.width + '" height="' + instance.height + '" px="' + instance.px + '" py="' + instance.py + '" pz="' + instance.pz + '" ';
					desc += ' force="' + instance.force + '" play="' + instance.play + '" active="' + instance.active + '" visible="' + instance.visible + '" ';
					desc += ' alpha="' + instance.alpha + '" volume="' + instance.volume + '" rx="' + instance.rx + '" ry="' + instance.ry + '" rz="' + instance.rz + '" ';
					desc += ' red="' + instance.red + '" green="' + instance.green + '" blue="' + instance.blue + '" blend="' + instance.blend + '" ';
					desc += ' DropShadowFilter="' + instance.DropShadowFilter + '" DSFalpha="' + instance.DSFalpha + '" DSFangle="' + instance.DSFangle + '" DSFblurX="' + instance.DSFblurX + '" DSFblurY="' + instance.DSFblurY + '" DSFdistance="' + instance.DSFdistance + '" DSFcolor="' + instance.DSFcolor + '" ';
					desc += ' BevelFilter="' + instance.BevelFilter + '" BVFangle="' + instance.BVFangle + '" BVFblurX="' + instance.BVFblurX + '" BVFblurY="' + instance.BVFblurY + '" BVFdistance="' + instance.BVFdistance + '" BVFhighlightAlpha="' + instance.BVFhighlightAlpha + '" BVFshadowAlpha="' + instance.BVFshadowAlpha + '" BVFhighlightColor="' + instance.BVFhighlightColor + '" BVFshadowColor="' + instance.BVFshadowColor + '" ';
					desc += ' BlurFilter="' + instance.BlurFilter + '" BLFblurX="' + instance.BLFblurX + '" BLFblurY="' + instance.BLFblurY + '" ';
					desc += ' GlowFilter="' + instance.GlowFilter + '" GLFalpha="' + instance.GLFalpha + '" GLFblurX="' + instance.GLFblurX + '" GLFblurY="' + instance.GLFblurY + '" GLFinner="' + instance.GLFinner + '" GLFstrength="' + instance.GLFstrength + '" GLFcolor="' + instance.GLFcolor + '" ';
					desc += '>' + instance.action + '</instance>';
				}
				desc += '</keyframe>';
			}
			desc += '</data>';
			return(desc);
		}
		
		/**
		 * Clear information about the stream.
		 */
		public function clear():void {
			id = "";
			title = "";
			author.clear();
			about = "";
			tags = "";
			update = "";
			while (categories.length > 0) {
				categories[0].kill();
				categories.shift();
			}
			// plugins = new Array();
			guideup = "";
			guideupid = "";
			guidedown = "";
			guidedownid = "";
			speed = 3;
			tweening = "linear";
			fade = "fade";
			entropy = 0;
			distortion = 0;
			target = "";
			vote = false;
			votetype = "timer";
			votereference = "10";
			voteshow = "this";
			// voteoptions = new Array();
			for (var index:String in this.playlists) {
				playlists[index].kill();
				delete(playlists[index]);
			}
			while (keyframes.length > 0) {
				keyframes[0].kill();
				keyframes.shift();
			}
			keyframes.push(new DISKeyframeED());
			newStream = false;
			currentKeyframe = 0;
		}
		
	}

}
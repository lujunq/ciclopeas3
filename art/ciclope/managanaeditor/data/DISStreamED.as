package art.ciclope.managanaeditor.data {
	
	// CICLOPE CLASSES
	import art.ciclope.managana.data.DISElementFile;
	import art.ciclope.staticfunctions.StringFunctions;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * DISStreamED provides information about streams for Managana editor.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class DISStreamED {
		
		// PUBLIC VARIABLES
		
		/**
		 * Stream id.
		 */
		public var id:String = "";
		/**
		 * Landscape stream id.
		 */
		public var landscapeID:String = "";
		/**
		 * Portrait stream id.
		 */
		public var portraitID:String = "";
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
		 * Stream category.
		 */
		public var category:String = "";
		/**
		 * Stream plugins.
		 */
		public var plugins:Array = new Array();
		/**
		 * Stream upper guide id.
		 */
		public var guideupid:String = "";
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
		 * Stream voting type.
		 */
		public var votetype:String = "infinite";
		/**
		 * Stream voting reference.
		 */
		public var votereference:String = "60";
		/**
		 * Only start stream timer after first vote?
		 */
		public var startaftervote:Boolean = false;
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
		/**
		 * Next streams on x axis (separated by |).
		 */
		public var xnext:String = "";
		/**
		 * Previous streams on x axis (separated by |).
		 */
		public var xprev:String = "";
		/**
		 * Next streams on y axis (separated by |).
		 */
		public var ynext:String = "";
		/**
		 * Previous streams on y axis (separated by |).
		 */
		public var yprev:String = "";
		/**
		 * Next streams on z axis (separated by |).
		 */
		public var znext:String = "";
		/**
		 * Previous streams on z axis (separated by |).
		 */
		public var zprev:String = "";
		/**
		 * Stream custom meta data.
		 */
		public var meta:Array = new Array();
		/**
		 * Stream initial progress code.
		 */
		public var pcode:String = "";
		/**
		 * Progress code for custom function A.
		 */
		public var functionA:String = "";
		/**
		 * Progress code for custom function B.
		 */
		public var functionB:String = "";
		/**
		 * Progress code for custom function C.
		 */
		public var functionC:String = "";
		/**
		 * Progress code for custom function D.
		 */
		public var functionD:String = "";
		/**
		 * Progress code for mouse wheel up.
		 */
		public var mouseWUp:String = "";
		/**
		 * Progress code for mouse wheel down.
		 */
		public var mouseWDown:String = "";
		/**
		 * Default vote for public interactions.
		 */
		public var voteDefault:uint = 0;
		/**
		 * A stream to load on connected remote controls.
		 */
		public var remoteStream:String = "";
		
		/**
		 * DISStreamED constructor.
		 */
		public function DISStreamED() {
			// prepare vote options
			for (var index:uint = 0; index < 9; index++) {
				this.voteoptions.push(new DISVoteED(index));
			}
		}
		
		// PROPERTIES
		
		/**
		 * Number of loaded playlists.
		 */
		public function get numplaylist():uint {
			var ret:uint = 0;
			for (var index:String in this.playlists) ret++;
			return (ret);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Add a new keyframe with a copy of the last one.
		 */
		public function addKeyframe():void {
			this.keyframes.push(this.keyframes[this.keyframes.length - 1].clone);
		}
		
		/**
		 * Add a new empty keyframe to the stream.
		 */
		public function addEmptyKeyframe():void {
			this.keyframes.push(new DISKeyframeED());
		}
		
		/**
		 * Remove the selected keyframe.
		 * @param	num	the keyframe to remove
		 */
		public function removeKeyframe(num:uint):void {
			if (this.keyframes.length > 1) { // do not remove if there is only one keyframe
				if (num < this.keyframes.length) { // does the keyframe exist?
					this.keyframes[num].kill();
					this.keyframes.splice(num, 1);
				}
			}
		}
		
		/**
		 * Get stream data from a xml.
		 * @param	data	xml stream information
		 */
		public function getData(data:XML):void {
			this.clear();
			id = String(data.id);
			landscapeID = String(data.aspect[0].landscape);
			portraitID = String(data.aspect[0].portrait);
			if (data.child("remote").length() > 0) this.remoteStream = String(data.remote[0].alternateid);
			guideupid = String(data.guides[0].up);
			guidedownid = String(data.guides[0].down);
			category = String(data.meta[0].category);
			title = String(data.meta[0].title);
			author.name = String(data.meta[0].author);
			author.id = String(data.meta[0].author.@id);
			about = String(data.meta[0].about);
			tags = String(data.meta[0].tags);
			update = String(data.meta[0].update);
			for (var imeta:uint = 0; imeta < data.meta[0].child("custom").length(); imeta++) {
				this.meta[String("meta" + int(data.meta[0].custom[imeta].@id))] = new DISMetaED(String(data.meta[0].custom[imeta].metaname[0]), int(data.meta[0].custom[imeta].@id), String(data.meta[0].custom[imeta].metavalue[0]));
			}
			speed = uint(data.animation[0].speed);
			tweening = String(data.animation[0].tweening);
			fade = String(data.animation[0].fade);
			entropy = uint(data.animation[0].entropy);
			distortion = uint(data.animation[0].distortion);
			target = String(data.animation[0].target);
			// voting and time
			votetype = String(data.voting[0].type);
			votereference = String(data.voting[0].reference);
			voteDefault = uint(data.voting[0].defaultvote);
			startaftervote = false;
			if (data.voting[0].child("startaftervote").length() > 0) startaftervote = (String(data.voting[0].startaftervote) == "1");
			for (var ivote:uint = 0; ivote < data.voting[0].child("option").length(); ivote++) {
				if (this.voteoptions[int(data.voting[0].option[ivote].@id) - 1] != null) {
					this.voteoptions[int(data.voting[0].option[ivote].@id) - 1].action = String(data.voting[0].option[ivote]);
					this.voteoptions[int(data.voting[0].option[ivote].@id) - 1].px = int(data.voting[0].option[ivote].@px);
					this.voteoptions[int(data.voting[0].option[ivote].@id) - 1].py = int(data.voting[0].option[ivote].@py);
					this.voteoptions[int(data.voting[0].option[ivote].@id) - 1].visible = (int(data.voting[0].option[ivote].@show) != 0);
					this.voteoptions[int(data.voting[0].option[ivote].@id) - 1].num = int(data.voting[0].option[ivote].@id);
				}
			}
			// navigation
			if (data.child("navigation").length() > 0) {
				if (data.navigation[0].child("xnext").length() > 0) xnext = String(data.navigation[0].xnext);
				if (data.navigation[0].child("xprev").length() > 0) xprev = String(data.navigation[0].xprev);
				if (data.navigation[0].child("ynext").length() > 0) ynext = String(data.navigation[0].ynext);
				if (data.navigation[0].child("yprev").length() > 0) yprev = String(data.navigation[0].yprev);
				if (data.navigation[0].child("znext").length() > 0) znext = String(data.navigation[0].znext);
				if (data.navigation[0].child("zprev").length() > 0) zprev = String(data.navigation[0].zprev);
			}
			// progress code
			if (data.child("code").length() > 0) {
				this.pcode = String(data.code[0]);
			}
			// custom functions
			if (data.child("functions").length() > 0) {
				this.functionA = String(data.functions[0].customa);
				this.functionB = String(data.functions[0].customb);
				this.functionC = String(data.functions[0].customc);
				this.functionD = String(data.functions[0].customd);
			}
			// mouse wheel functions
			if (data.child("wheel").length() > 0) {
				this.mouseWUp = String(data.wheel[0].up);
				this.mouseWDown = String(data.wheel[0].down);
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
						element.type = String(data.playlists.playlist[index].elements.element[index2].@type);
						element.time = uint(data.playlists.playlist[index].elements.element[index2].@time);
						element.end = String(data.playlists.playlist[index].elements.element[index2].@end);
						element.order = index2;
						for (var index3:uint = 0; index3 < data.playlists.playlist[index].elements.element[index2].child("file").length(); index3++) {
							var file:DISElementFileED = new DISElementFileED();
							file.format = String(data.playlists.playlist[index].elements.element[index2].file[index3].@format);
							file.lang = String(data.playlists.playlist[index].elements.element[index2].file[index3].lang);
							file.absolute = Boolean(uint(data.playlists.playlist[index].elements.element[index2].file[index3].@absolute));
							file.path = String(data.playlists.playlist[index].elements.element[index2].file[index3]);
							file.feedName = String(data.playlists.playlist[index].elements.element[index2].file[index3].@feed);
							file.feedType = String(data.playlists.playlist[index].elements.element[index2].file[index3].@feedType);
							file.feedField = String(data.playlists.playlist[index].elements.element[index2].file[index3].@field);
							element.file.push(file);
						}
						for (index3 = 0; index3 < data.playlists.playlist[index].elements.element[index2].child("action").length(); index3++) {
							if (data.playlists.playlist[index].elements.element[index2].action[index3].hasOwnProperty('@time')) {
								element.setAction(uint(data.playlists.playlist[index].elements.element[index2].action[index3].@time), String(data.playlists.playlist[index].elements.element[index2].action[index3]), String(data.playlists.playlist[index].elements.element[index2].action[index3].@type));
							}
						}
						playlist.elements[element.id] = element;
					}
					this.playlists[playlist.id] = playlist;
				}
			}
			// load keyframes
			if (data.keyframes.child("keyframe").length() > 0) {
				// remove previous blank keyframe
				while (keyframes.length > 0) {
					keyframes[0].kill();
					keyframes.shift();
				}
				for (var index:uint = 0; index < data.keyframes.child("keyframe").length(); index++) {
					keyframes.push(new DISKeyframeED());
					if (data.keyframes.keyframe[index].child("actionin").length() > 0) {
						keyframes[index].codeIn = String(data.keyframes.keyframe[index].actionin);
						keyframes[index].codeOut = String(data.keyframes.keyframe[index].actionout);
					}
					for (var index2:uint = 0; index2 < data.keyframes.keyframe[index].child("instance").length(); index2++) {
						var instance:DISInstanceED = new DISInstanceED();
						instance.id = String(data.keyframes.keyframe[index].instance[index2].@id);
						instance.playlist = String(data.keyframes.keyframe[index].instance[index2].@playlist);
						instance.element = String(data.keyframes.keyframe[index].instance[index2].@element);
						instance.px = int(data.keyframes.keyframe[index].instance[index2].@px);
						instance.py = int(data.keyframes.keyframe[index].instance[index2].@py);
						instance.pz = int(data.keyframes.keyframe[index].instance[index2].@pz);
						instance.order = int(data.keyframes.keyframe[index].instance[index2].@order);
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
						instance.smooth = Boolean(uint(data.keyframes.keyframe[index].instance[index2].@smooth));
						instance.displayMode = String(data.keyframes.keyframe[index].instance[index2].@crop);
						instance.transition = String(data.keyframes.keyframe[index].instance[index2].@transition);
						instance.fontface = String(data.keyframes.keyframe[index].instance[index2].@font);
						instance.fontsize = uint(data.keyframes.keyframe[index].instance[index2].@fontsize);
						instance.letterSpacing = int(data.keyframes.keyframe[index].instance[index2].@spacing);
						instance.leading = int(data.keyframes.keyframe[index].instance[index2].@leading);
						instance.fontbold = Boolean(uint(data.keyframes.keyframe[index].instance[index2].@bold));
						instance.fontitalic = Boolean(uint(data.keyframes.keyframe[index].instance[index2].@italic));
						instance.charmax = uint(data.keyframes.keyframe[index].instance[index2].@charmax);
						instance.fontcolor = String(data.keyframes.keyframe[index].instance[index2].@fontcolor);
						instance.action = String(data.keyframes.keyframe[index].instance[index2]);
						// new instance attributes (may not be available on previous Managana versions)
						if (data.keyframes.keyframe[index].instance[index2].attribute('textalign').length() > 0) {
							instance.textalign = String(data.keyframes.keyframe[index].instance[index2].@textalign);
						} else {
							instance.textalign = "left";
						}
						if (data.keyframes.keyframe[index].instance[index2].attribute('cssclass').length() > 0) {
							instance.cssClass = String(data.keyframes.keyframe[index].instance[index2].@cssclass);
						} else {
							instance.cssClass = "";
						}
						// set instance
						keyframes[index].instance[instance.id] = instance;
					}
				}
			}
		}
		
		/**
		 * A xml description of current stream.
		 */
		public function get streamxml():String {
			var desc:String = '<?xml version="1.0" encoding="UTF-8"?><stream>';
			desc += '<id>|preview|current|stream|</id>';
			desc += '<meta>';
			desc += '<title>' + this.title + '</title>';
			desc += '<author id="' + this.author.id + '">' + this.author.name + '</author>';
			desc += '<about><![CDATA[' + this.about + ']]></about>';
			desc += '<icon></icon>';
			desc += '<tags>' + this.tags + '</tags>';
			desc += '<update>' + this.update + '</update>';
			desc += '<category>' + this.category + '</category>';
			for (var imeta:String in this.meta) {
				desc += '<custom id="' + this.meta[imeta].id + '"><metaname><![CDATA[' + this.meta[imeta].name + ']]></metaname><metavalue><![CDATA[' + this.meta[imeta].value + ']]></metavalue></custom>';
			}
			desc += '</meta>';
			desc += '<code><![CDATA[' + this.pcode + ']]></code>';
			desc += '<remote><alternateid><![CDATA[' + this.remoteStream + ']]></alternateid></remote>';
			desc += '<functions>';
			desc += '<customa><![CDATA[' + this.functionA + ']]></customa>';
			desc += '<customb><![CDATA[' + this.functionB + ']]></customb>';
			desc += '<customc><![CDATA[' + this.functionC + ']]></customc>';
			desc += '<customd><![CDATA[' + this.functionD + ']]></customd>';
			desc += '</functions>';
			desc += '<wheel>';
			desc += '<up><![CDATA[' + this.mouseWUp + ']]></up>';
			desc += '<down><![CDATA[' + this.mouseWDown + ']]></down>';
			desc += '</wheel>';
			desc += '<plugins />';
			desc += '<guides>';
			if (this.guideupid != "") desc += '<stream id="' + this.guideupid + '" type="up" />';
			if (this.guidedownid != "") desc += '<stream id="' + this.guidedownid + '" type="down" />';
			desc += '</guides>';
			desc += '<aspect>';
			if ((this.landscapeID == "") || (this.landscapeID == this.id)) desc += '<landscape>|preview|current|stream|</landscape>';
				else desc += '<landscape>' + this.landscapeID + '</landscape>';
			if ((this.portraitID == "") || (this.portraitID == this.id)) desc += '<portrait>|preview|current|stream|</portrait>';
				else desc += '<portrait>' + this.portraitID + '</portrait>';
			desc += '</aspect>';
			desc += '<animation>';
			desc += '<speed>' + this.speed + '</speed>';
			desc += '<tweening>' + this.tweening + '</tweening>';
			desc += '<fade>' + this.fade + '</fade>';
			desc += '<entropy>' + this.entropy + '</entropy>';
			desc += '<distortion>' + this.distortion + '</distortion>';
			desc += '<target>' + this.target + '</target>';
			desc += '</animation>';
			desc += '<voting>';
			desc += '<type>' + this.votetype + '</type >';
			desc += '<reference>' + this.votereference + '</reference>';
			desc += '<defaultvote>' + this.voteDefault + '</defaultvote>';
			if (startaftervote) desc += '<startaftervote>1</startaftervote>';
				else desc += '<startaftervote>0</startaftervote>';
			for (var ivote:uint = 0; ivote < this.voteoptions.length; ivote++) {
				if (this.voteoptions[ivote].visible) {
					desc += '<option id="' + this.voteoptions[ivote].num + '" px="' + this.voteoptions[ivote].px + '" py="' + this.voteoptions[ivote].py + '" show="1"><![CDATA[' + this.voteoptions[ivote].action + ']]></option>';
				} else {
					desc += '<option id="' + this.voteoptions[ivote].num + '" px="' + this.voteoptions[ivote].px + '" py="' + this.voteoptions[ivote].py + '" show="0"><![CDATA[' + this.voteoptions[ivote].action + ']]></option>';
				}
			}
			desc += '</voting>';
			desc += '<navigation>';
			desc += '<xnext><![CDATA[' + xnext + ']]></xnext>';
			desc += '<xprev><![CDATA[' + xprev + ']]></xprev>';
			desc += '<ynext><![CDATA[' + ynext + ']]></ynext>';
			desc += '<yprev><![CDATA[' + yprev + ']]></yprev>';
			desc += '<znext><![CDATA[' + znext + ']]></znext>';
			desc += '<zprev><![CDATA[' + zprev + ']]></zprev>';
			desc += '</navigation>';
			desc += '<keyframes>';
			for (var index:uint = 0; index < this.keyframes.length; index++) {
				desc += '<keyframe>';
				desc += '<actionin><![CDATA[' + this.keyframes[index].codeIn + ']]></actionin>';
				desc += '<actionout><![CDATA[' + this.keyframes[index].codeOut + ']]></actionout>';
				for (var index2:String in this.keyframes[index].instance) {
					var instance:DISInstanceED = this.keyframes[index].instance[index2];
					desc += '<instance playlist="' + instance.playlist + '" element="' + instance.element + '" id="' + instance.id + '" ';
					desc += ' width="' + instance.width + '" height="' + instance.height + '" px="' + instance.px + '" py="' + instance.py + '" pz="' + instance.pz + '" order="' + instance.order + '" ';
					desc += ' force="' + StringFunctions.boolToNumString(instance.force) + '" play="' + StringFunctions.boolToNumString(instance.play) + '" active="' + StringFunctions.boolToNumString(instance.active) + '" visible="' + StringFunctions.boolToNumString(instance.visible) + '" ';
					desc += ' alpha="' + instance.alpha + '" volume="' + instance.volume + '" rx="' + instance.rx + '" ry="' + instance.ry + '" rz="' + instance.rz + '" ';
					desc += ' red="' + instance.red + '" green="' + instance.green + '" blue="' + instance.blue + '" blend="' + instance.blend + '" ';
					desc += ' DropShadowFilter="' + StringFunctions.boolToNumString(instance.DropShadowFilter) + '" DSFalpha="' + instance.DSFalpha + '" DSFangle="' + instance.DSFangle + '" DSFblurX="' + instance.DSFblurX + '" DSFblurY="' + instance.DSFblurY + '" DSFdistance="' + instance.DSFdistance + '" DSFcolor="' + instance.DSFcolor + '" ';
					desc += ' BevelFilter="' + StringFunctions.boolToNumString(instance.BevelFilter) + '" BVFangle="' + instance.BVFangle + '" BVFblurX="' + instance.BVFblurX + '" BVFblurY="' + instance.BVFblurY + '" BVFdistance="' + instance.BVFdistance + '" BVFhighlightAlpha="' + instance.BVFhighlightAlpha + '" BVFshadowAlpha="' + instance.BVFshadowAlpha + '" BVFhighlightColor="' + instance.BVFhighlightColor + '" BVFshadowColor="' + instance.BVFshadowColor + '" ';
					desc += ' BlurFilter="' + StringFunctions.boolToNumString(instance.BlurFilter) + '" BLFblurX="' + instance.BLFblurX + '" BLFblurY="' + instance.BLFblurY + '" ';
					desc += ' GlowFilter="' + StringFunctions.boolToNumString(instance.GlowFilter) + '" GLFalpha="' + instance.GLFalpha + '" GLFblurX="' + instance.GLFblurX + '" GLFblurY="' + instance.GLFblurY + '" GLFinner="' + StringFunctions.boolToNumString(instance.GLFinner) + '" GLFstrength="' + instance.GLFstrength + '" GLFcolor="' + instance.GLFcolor + '" ';
					desc += ' crop="' + instance.displayMode + '" smooth="' + StringFunctions.boolToNumString(instance.smooth) + '" transition="' + instance.transition + '"';
					desc += ' font="' + instance.fontface + '" fontsize="' + instance.fontsize + '" spacing="' + instance.letterSpacing + '" leading="' + instance.leading + '" bold="' + StringFunctions.boolToNumString(instance.fontbold) + '" italic="' + StringFunctions.boolToNumString(instance.fontitalic) + '" charmax="' + instance.charmax + '" fontcolor="' + instance.fontcolor + '" textalign="' + instance.textalign + '" cssclass="' + instance.cssClass + '"';
					desc += '><![CDATA[' + instance.action + ']]></instance>';
				}
				desc += '</keyframe>';
			}
			desc += '</keyframes>';
			desc += '<playlists>';
			for (var indexstr:String in this.playlists) {
				desc += '<playlist id="' + this.playlists[indexstr].id + '" />';
			}
			desc += '</playlists>';
			desc += '</stream>';
			return (desc);
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
					desc += '<element id="' + this.playlists[index].elements[index2].id + '" time="' + this.playlists[index].elements[index2].time + '" type="' + this.playlists[index].elements[index2].type + '" end="' + this.playlists[index].elements[index2].end + '" order="' + this.playlists[index].elements[index2].order + '">';
					for (var index3:uint = 0; index3 < this.playlists[index].elements[index2].file.length; index3++) {
						desc += '<file format="' + this.playlists[index].elements[index2].file[index3].format + '" lang="' + this.playlists[index].elements[index2].file[index3].lang + '" absolute="' + this.playlists[index].elements[index2].file[index3].absolute + '" feed="' + this.playlists[index].elements[index2].file[index3].feedName + '" feedType="' + this.playlists[index].elements[index2].file[index3].feedType + '" field="' + this.playlists[index].elements[index2].file[index3].feedField + '"><![CDATA[' + this.playlists[index].elements[index2].file[index3].path + ']]></file>';
					}
					var actionfound:Boolean = false;
					// end action
					if (this.playlists[index].elements[index2].endAction != "") {
						desc += '<action time="0" type="end"><![CDATA[' + this.playlists[index].elements[index2].endAction + ']]></action>';
						actionfound = true;
					}
					// timed actions
					for (var index4:String in this.playlists[index].elements[index2].action) {
						desc += '<action time="' + this.playlists[index].elements[index2].action[index4].time + '" type="' + this.playlists[index].elements[index2].action[index4].type + '"><![CDATA[' + this.playlists[index].elements[index2].action[index4].action + ']]></action>';
						actionfound = true;
					}
					if (!actionfound) desc += '<action />';
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
				desc += '<actionin><![CDATA[' + this.keyframes[index].codeIn + ']]></actionin>';
				desc += '<actionout><![CDATA[' + this.keyframes[index].codeOut + ']]></actionout>';
				desc += '<order>' + index + '</order>';
				for (var index2:String in this.keyframes[index].instance) {
					var instance:DISInstanceED = this.keyframes[index].instance[index2];
					desc += '<instance playlist="' + instance.playlist + '" element="' + instance.element + '" id="' + instance.id + '" ';
					desc += ' width="' + instance.width + '" height="' + instance.height + '" px="' + instance.px + '" py="' + instance.py + '" pz="' + instance.pz + '" order="' + instance.order + '" ';
					desc += ' force="' + StringFunctions.boolToNumString(instance.force) + '" play="' + StringFunctions.boolToNumString(instance.play) + '" active="' + StringFunctions.boolToNumString(instance.active) + '" visible="' + StringFunctions.boolToNumString(instance.visible) + '" ';
					desc += ' alpha="' + instance.alpha + '" volume="' + instance.volume + '" rx="' + instance.rx + '" ry="' + instance.ry + '" rz="' + instance.rz + '" ';
					desc += ' red="' + instance.red + '" green="' + instance.green + '" blue="' + instance.blue + '" blend="' + instance.blend + '" ';
					desc += ' DropShadowFilter="' + StringFunctions.boolToNumString(instance.DropShadowFilter) + '" DSFalpha="' + instance.DSFalpha + '" DSFangle="' + instance.DSFangle + '" DSFblurX="' + instance.DSFblurX + '" DSFblurY="' + instance.DSFblurY + '" DSFdistance="' + instance.DSFdistance + '" DSFcolor="' + instance.DSFcolor + '" ';
					desc += ' BevelFilter="' + StringFunctions.boolToNumString(instance.BevelFilter) + '" BVFangle="' + instance.BVFangle + '" BVFblurX="' + instance.BVFblurX + '" BVFblurY="' + instance.BVFblurY + '" BVFdistance="' + instance.BVFdistance + '" BVFhighlightAlpha="' + instance.BVFhighlightAlpha + '" BVFshadowAlpha="' + instance.BVFshadowAlpha + '" BVFhighlightColor="' + instance.BVFhighlightColor + '" BVFshadowColor="' + instance.BVFshadowColor + '" ';
					desc += ' BlurFilter="' + StringFunctions.boolToNumString(instance.BlurFilter) + '" BLFblurX="' + instance.BLFblurX + '" BLFblurY="' + instance.BLFblurY + '" ';
					desc += ' GlowFilter="' + StringFunctions.boolToNumString(instance.GlowFilter) + '" GLFalpha="' + instance.GLFalpha + '" GLFblurX="' + instance.GLFblurX + '" GLFblurY="' + instance.GLFblurY + '" GLFinner="' + instance.GLFinner + '" GLFstrength="' + instance.GLFstrength + '" GLFcolor="' + instance.GLFcolor + '" ';
					desc += ' crop="' + instance.displayMode + '" smooth="' + StringFunctions.boolToNumString(instance.smooth) + '" transition="' + instance.transition + '"';
					desc += ' font="' + instance.fontface + '" fontsize="' + instance.fontsize + '" spacing="' + instance.letterSpacing + '" leading="' + instance.leading + '" bold="' + StringFunctions.boolToNumString(instance.fontbold) + '" italic="' + StringFunctions.boolToNumString(instance.fontitalic) + '" charmax="' + instance.charmax + '" fontcolor="' + instance.fontcolor + '" textalign="' + instance.textalign + '" cssclass="' + instance.cssClass + '"';
					desc += '><![CDATA[' + instance.action + ']]></instance>';
				}
				desc += '</keyframe>';
			}
			desc += '</data>';
			return(desc);
		}
		
		/**
		 * XML-formatted information about a single playlist.
		 * @param	id	the playlist id
		 * @return	the playlist xml description or an empty string if the playlist is not on current stream
		 */
		public function singlePlaylist(id:String):String {
			var ret:String = "";
			for (var index:String in this.playlists) {
				if (this.playlists[index].id == id) {
					ret = '<?xml version="1.0" encoding="utf-8"?><playlist>';
					ret += '<id>' + id + '</id>';
					ret += '<meta>';
					ret += '<title>' + this.playlists[index].name + '</title>';
					ret += '<author id="' + this.playlists[index].author.id + '">' + this.playlists[index].author.name + '</author>';
					ret += '<about>' + this.playlists[index].about + '</about>';
					ret += '</meta>';
					ret += '<elements>';
					var elements:Array = this.playlists[index].sortedElements;
					for (var index2:uint = 0; index2 < elements.length; index2++) {
						ret += '<element id="' + elements[index2].id + '" time="' + elements[index2].time + '" type="' + elements[index2].type + '" end="' + elements[index2].end + '">';
						for (var index3:uint = 0; index3 < elements[index2].file.length; index3++) {
							ret += '<file format="' + elements[index2].file[index3].format + '" lang="' + elements[index2].file[index3].lang + '" absolute="' + StringFunctions.boolToNumString(elements[index2].file[index3].absolute) + '" feed="' + elements[index2].file[index3].feedName + '" feedType="' + elements[index2].file[index3].feedType + '" field="' + elements[index2].file[index3].feedField + '"><![CDATA[' + elements[index2].file[index3].path + ']]></file>';
						}
						var actionfound:Boolean = false;
						if (elements[index2].endAction != "") {
							ret += '<action time="0" type="end"><![CDATA[' + elements[index2].endAction + ']]></action>';
							actionfound = true;
						}
						for (var index4:String in elements[index2].action) {
							ret += '<action time="' + elements[index2].action[index4].time + '" type="' + elements[index2].action[index4].type + '"><![CDATA[' + elements[index2].action[index4].action + ']]></action>';
							actionfound = true;
						}
						if (!actionfound) ret += '<action />';
						ret += '</element>';
					}
					ret += '</elements>';
					ret += '</playlist> ';
				}
			}
			return (ret);
		}
		
		/**
		 * Clear information about the stream.
		 */
		public function clear():void {
			id = "";
			title = "";
			remoteStream = "";
			author.clear();
			about = "";
			tags = "";
			update = "";
			category = "";
			guideupid = "";
			guidedownid = "";
			landscapeID = "";
			portraitID = "";
			speed = 1;
			tweening = "linear";
			fade = "fade";
			entropy = 0;
			distortion = 0;
			target = "";
			votetype = "infinite";
			votereference = "60";
			voteDefault = 0;
			startaftervote = false;
			xnext = "";
			xprev = "";
			ynext = "";
			yprev = "";
			znext = "";
			zprev = "";
			for (var index:String in this.playlists) {
				playlists[index].kill();
				delete(playlists[index]);
			}
			for (index in this.meta) {
				this.meta[index].kill();
				delete(this.meta[index]);
			}
			while (keyframes.length > 0) {
				keyframes[0].kill();
				keyframes.shift();
			}
			for (var ivote:uint = 0; ivote < 9; ivote++) this.voteoptions[ivote].clear(ivote);
			keyframes.push(new DISKeyframeED());
			newStream = false;
			currentKeyframe = 0;
			pcode = "";
			functionA = "";
			functionB = "";
			functionC = "";
			functionD = "";
			mouseWUp = "";
			mouseWDown = "";
		}
		
	}

}
package art.ciclope.managana.data {
	
	// FLASH PACKAGES
	import flash.events.EventDispatcher;
	import flash.system.System;
	
	// CICLOPE CLASSES
	import art.ciclope.event.ReaderServerEvent;
	import art.ciclope.event.CommunityContentEvent;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * OfflineCommunities handles the download of Managana content for offline access.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class OfflineCommunities extends EventDispatcher {
		
		// VARIABLES
		
		private var _saveFunction:Function;			// a function to save offline data
		private var _getFunction:Function;			// a function to load offline data
		private var _reader:ReaderServer;			// a reference to the reader server
		private var _list:XML;						// current local data
		private var _action:String;					// current action
		private var _current:String;				// current community for file management
		private var _currentTitle:String;			// current community title for file management
		private var _currentFile:int;				// current file downloading
		private var _remotefiles:XML;				// remote file list for current community
		private var _localfiles:XML;				// local file list for current community
		private var _downloadSize:Number;			// the current download size guessing
		private var _totalFiles:int;				// current community total number of files
		private var _remainFiles:int;				// remaining files to download
		private var _startAfterInfo:Boolean;		// start community download after information received?
		private var _firstRun:Boolean;				// first execution of this object during current application time?
		
		/**
		 * OfflineCommunities constructor.
		 * @param	savefunction	an IO function for saving data
		 * @param	getfunction	an IO function for loading data
		 * @param	reader	a reference to the system reader server
		 */
		public function OfflineCommunities(savefunction:Function, getfunction:Function, reader:ReaderServer) {
			this._firstRun = true;
			this._saveFunction = savefunction;
			this._getFunction = getfunction;
			this._reader = reader;
			if (this._reader != null) {
				this._reader.addEventListener(ReaderServerEvent.OFFLINEINFO, onOfflineInfo);
				this._reader.addEventListener(ReaderServerEvent.OFFLINEERROR, onOfflineError);
			}
			this.checkContent();
		}
		
		// READ-ONLY VALUES
		
		/**
		 * The working community at the moment.
		 */
		public function get currentCommunity():String {
			return (this._current);
		}
		
		/**
		 * The working community title at the moment.
		 */
		public function get currentTitle():String {
			return (this._currentTitle);
		}
		
		/**
		 * The current community total number of files.
		 */
		public function get totalFiles():uint {
			return (this._totalFiles);
		}
		
		/**
		 * Number of remaining files to download.
		 */
		public function get remainFiles():uint {
			return (this._remainFiles);
		}
		
		/**
		 * Amount (%) of the current community downloaded.
		 */
		public function get amountDownloaded():uint {
			return (uint(Math.round((100 * (this._totalFiles - this._remainFiles)) / this._totalFiles)));
		}
		
		/**
		 * A guess, in MB, of the community download size.
		 */
		public function get downloadSize():uint {
			return (this._downloadSize);
		}
		
		/**
		 * Available communities list.
		 */
		public function get list():XML {
			return (this._list);
		}
		
		/**
		 * Is there at least one community available for offline access?
		 */
		public function get hasOffline():Boolean {
			var found:Boolean = false;
			for (var index:uint = 0; index < this._list.child("community").length(); index++) {
				if ((String(this._list.community[index].state) == "offline") || (String(this._list.community[index].state) == "update")) found = true;
			}
			return (found);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Check online and offline content.
		 */
		public function checkContent():void {
			// get current list
			this._list = new XML(this._getFunction( { action: "getlist" } ));
			// get offline information
			this._action = "availableoffline";
			if (this._reader != null) this._reader.getAvailableOffline();
			// get current download information
			this._startAfterInfo = false;
			this._totalFiles = 1;
			this._remainFiles = 0;
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			System.disposeXML(this._list);
			this._action = null;
			this._saveFunction = null;
			this._getFunction = null;
			if (this._reader != null) {
				this._reader.removeEventListener(ReaderServerEvent.OFFLINEINFO, onOfflineInfo);
				this._reader.removeEventListener(ReaderServerEvent.OFFLINEERROR, onOfflineError);
			}
			this._reader = null;
			this._current = null;
			this._currentTitle = null;
		}
		
		/**
		 * Read a community information from online server.
		 * @param	id	the community id
		 * @param	title	the community title
		 */
		public function getCommunityInfo(id:String, title:String):void {
			if (this._reader != null) {
				this._current = id;
				this._currentTitle = title;
				this._action = "getofflineinfo";
				this._reader.getOfflineCInfo(id);
			}
		}
		
		/**
		 * Process a community information, compating local and remote files.
		 * @param	id	the community id
		 * @return	true if the community information can be compared, false otherwise
		 */
		public function processCommunity(id:String):Boolean {
			var ret:Boolean = false;
			// is there a remote file list?
			if (this._getFunction( { action:"checkremotefiles", community:id } ) == "ok") {
				// is the remote file list valid?
				try {
					this._remotefiles = new XML(this._getFunction( { action:"getremotefiles", community:id } ));
					ret = true;
				} catch (e:Error) {
					ret = false;
				}
				// get local files list
				if (ret) {
					this._localfiles = new XML(this._getFunction( { action:"getlocalfiles", community:id } ));
					this._current = id;
				}
				// compare files to update and add new ones
				this._downloadSize = 0;
				this._totalFiles = 0;
				this._remainFiles = 0;
				for (var ion:uint = 0; ion < this._remotefiles.child("file").length(); ion++) {
					var found:Boolean = false;
					this._totalFiles++;
					for (var ioff:uint = 0; ioff < this._localfiles.child("file").length(); ioff++) {
						if (String(this._remotefiles.file[ion]) == String(this._localfiles.file[ioff].path)) {
							found = true;
							if ((String(this._remotefiles.file[ion].@size) == String(this._localfiles.file[ioff].size)) && (String(this._remotefiles.file[ion].@check) == String(this._localfiles.file[ioff].check))) {
								if (this._localfiles.file[ioff].state != "download") {
									this._localfiles.file[ioff].state = "ok";
								} else {
									this._remainFiles++;
									this._downloadSize += Number(this._remotefiles.file[ion].@size);
								}
							} else {
								this._remainFiles++;
								this._localfiles.file[ioff].state = "download";
								this._localfiles.file[ioff].size = String(this._remotefiles.file[ion].@size);
								this._localfiles.file[ioff].check = String(this._remotefiles.file[ion].@check);
								this._downloadSize += Number(this._remotefiles.file[ion].@size);
							}
						}
					}
					if (!found) {
						this._localfiles.appendChild(XML('<file><path>' + String(this._remotefiles.file[ion]) + '</path><state>download</state><size>' + String(this._remotefiles.file[ion].@size) + '</size><check>' + String(this._remotefiles.file[ion].@check) + '</check></file>'));
						this._remainFiles++;
						this._downloadSize += Number(this._remotefiles.file[ion].@size);
					}
				}
				this._downloadSize = Math.ceil(this._downloadSize / (1024 * 1024));
			}
			return (ret);
		}
		
		/**
		 * Start a community download.
		 * @return	true if the community data is available and the download was started, false otherwise
		 */
		public function startDownload():Boolean {
			if (this._current != "") {
				for (var index:uint = 0; index < this._list.child("community").length(); index++) {
					if (String(this._list.community[index].id) == this._current) {
						this._list.community[index].state = "updating";
					}
				}
				this._saveFunction( { action: "savelist", data: this._list } );
				this._currentFile = -1;
				this._saveFunction( { action:"downloadstart", community:this._current } );
				this.downloadFile();
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Stop any download.
		 */
		public function stopDownload():void {
			this._saveFunction( { action: "stopdownload", community:this._current } );
			this.dispatchEvent(new CommunityContentEvent(CommunityContentEvent.DOWNLOAD_STOP));
		}
		
		/**
		 * Delete all community files.
		 */
		public function delCommunity(id:String):void {
			this._saveFunction( { action: "delete", community:id } );
			for (var index:uint = 0; index < this._list.child("community").length(); index++) {
				if (String(this._list.community[index].id) == id) this._list.community[index].state = "online";
			}
			this._saveFunction( { action: "savelist", data: this._list } );
		}
		
		// PRIVATE METHODS
		
		/**
		 * Download a file for current community.
		 * @param	result	was the previous file downloaded?
		 */
		private function downloadFile(result:Boolean = true):void {
			if (this._currentFile >= 0) if (this._localfiles.file[this._currentFile] != null) {
				if (result) {
					this._localfiles.file[this._currentFile].state = "ok";
					this._saveFunction( { action:"savelocalfiles", data:this._localfiles, community:this._current } );
				}
			}
			this._currentFile++;
			this._remainFiles--;
			var found:Boolean = false;
			for (var index:uint = this._currentFile; index < this._localfiles.child("file").length(); index++) {
				if ((String(this._localfiles.file[index].state) == "download") && (!found)) {
					found = true;
					this._currentFile = index;
					this._saveFunction( { action:"downloadfile", community:this._current, endFunction:this.downloadFile, file:String(this._localfiles.file[index].path) } );
				}
			}
			if (!found) {
				this._saveFunction( { action:"downloadfinish", community:this._current } );
				this._remainFiles = 0;
				for (index = 0; index < this._list.child("community").length(); index++) {
					if (String(this._list.community[index].id) == this._current) this._list.community[index].state = "offline";
				}
				this._saveFunction( { action: "savelist", data: this._list } );
				this.dispatchEvent(new CommunityContentEvent(CommunityContentEvent.DOWNLOAD_ALL));
			} else {
				this.dispatchEvent(new CommunityContentEvent(CommunityContentEvent.DOWNLOAD_ITEM));
			}
		}
		
		/**
		 * Offline information received.
		 */
		private function onOfflineInfo(evt:ReaderServerEvent):void {
			var data:XML = new XML(evt.message);
			switch (String(data.action)) {
				case "availableoffline": // read available communities
					this.checkCommunities(data);
					this.dispatchEvent(new CommunityContentEvent(CommunityContentEvent.LIST_AVAILABLE));
					break;
				case "getofflineinfo":	// get community file list
					this._saveFunction( { action:"savefilelist", community:String(data.community), filelist:String(data.filelist) } );
					if (this.processCommunity(String(data.community))) {
						this._saveFunction( { action:"savelocalfiles", data:this._localfiles, community:String(data.community) } );
						if (!this._startAfterInfo) {
							this.dispatchEvent(new CommunityContentEvent(CommunityContentEvent.INFO_READY));
						} else {
							this.startDownload();
							this.dispatchEvent(new CommunityContentEvent(CommunityContentEvent.DOWNLOAD_START));
						}
						this._startAfterInfo = false;
					} else {
						this._current = "";
						this._currentTitle = "";
						this._currentFile = -1;
						this._remainFiles = 0;
						this._totalFiles = 1;
						if (!this._startAfterInfo) this.dispatchEvent(new CommunityContentEvent(CommunityContentEvent.INFO_ERROR));
						this._startAfterInfo = false;
					}
					break;
			}
			System.disposeXML(data);
		}
		
		/**
		 * Offline information error received.
		 */
		private function onOfflineError(evt:ReaderServerEvent):void {
			switch (this._action) {
				case "availableoffline": // read available communities
					break;
				case "getofflineinfo":	// get community file list
					this._current = "";
					this._currentTitle = "";
					this._currentFile = -1;
					this._remainFiles = 0;
					this._totalFiles = 1;
					if (!this._startAfterInfo) this.dispatchEvent(new CommunityContentEvent(CommunityContentEvent.INFO_ERROR));
					this._startAfterInfo = false;
					break;
			}
		}
		
		/**
		 * Compare online communties with offline information
		 * @param	online	online communities information
		 */
		private function checkCommunities(online:XML):void {
			// mark current communities for list removal
			for (var ioff:int = 0; ioff < this._list.child("community").length(); ioff++) {
				this._list.community[ioff].remove = "true";
			}
			// compare the online communities
			for (var ion:uint = 0; ion < online.child("community").length(); ion++) {
				var found:Boolean = false;
				for (ioff = 0; ioff < this._list.child("community").length(); ioff++) {
					if (String(this._list.community[ioff].id) == String(online.community[ion].@id)) {
						found = true;
						this._list.community[ioff].title = String(online.community[ion]);
						this._list.community[ioff].remove = "false";
						if (String(this._list.community[ioff].update) != String(online.community[ion].@update)) {
							if ((String(this._list.community[ioff].state) == "offline") || (String(this._list.community[ioff].state) == "updating")) {
								this._list.community[ioff].state = "update";
							}
							this._list.community[ioff].update = String(online.community[ion].@update);
						}
					}
				}
				if (!found) {
					this._list.appendChild(XML('<community><id>' + String(online.community[ion].@id) + '</id><update>' + String(online.community[ion].@update) + '</update><state>online</state><title><![CDATA[' + String(online.community[ion]) + ']]></title><remove>false</remove></community>'));
				}
			}
			// remove communities from list
			for (ioff = (this._list.child("community").length() - 1); ioff >= 0; ioff--) {
				if (String(this._list.community[ioff].remove) == "true") delete(this._list.community[ioff]);
			}
			// save updated offline list
			this._saveFunction( { action: "savelist", data: this._list } );
			// start some downloading right away?
			this._current = "";
			this._currentTitle = "";
			this._currentFile = -1;
			this._remainFiles = 0;
			this._totalFiles = 1;
			var foundUpdate:Boolean = false;
			for (var index:uint = 0; index < this._list.child("community").length(); index++) {
				if (String(this._list.community[index].state) == "updating") {
					this._current = String(this._list.community[index].id);
					this._currentTitle = String(this._list.community[index].title);
				} else if (String(this._list.community[index].state) == "update") {
					foundUpdate = true;
				}
			}
			if (this._current != "") {
				this._startAfterInfo = true;
				this.getCommunityInfo(this._current, this._currentTitle);
			} else {
				// warn user about updates?
				if (foundUpdate && this._firstRun) {
					this._firstRun = false;
					this.dispatchEvent(new CommunityContentEvent(CommunityContentEvent.UPDATE_AVAILABLE));
				}
			}
		}
		
	}

}
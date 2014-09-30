package art.ciclope.managana.data {
	
	// FLASH PACKAGES
	import flash.events.EventDispatcher;
	import flash.net.SharedObject;
	import flash.system.System;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * NoteAndMarkData holds information about an user note or bookmark.
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class NoteAndMarkData extends EventDispatcher {
		
		// PUBLIC CONSTANTS
		
		/**
		 * Data type: note.
		 */
		public static const TYPE_NOTE:String = "note";
		
		/**
		 * Data type: bookmark.
		 */
		public static const TYPE_MARK:String = "mark";
		
		// VARIABLES
		
		private var _type:String;				// data type
		private var _local:SharedObject;		// local saved data
		private var _user:SharedObject;			// local user saved data
		private var _userid:String;				// current user id
		private var _logged:Boolean;			// is the a logged user?
		private var _localData:Array;			// local saved data entries
		private var _userData:Array;			// user saved data entries
		private var _systemFunction:Function;	// a function to save data
		
		/**
		 * NoteAndMarkData constructor.
		 * @param	type	the data type (note or mark)
		 * @param	sysFunc	a system function to do IO operations on AIR runtime
		 */
		public function NoteAndMarkData(type:String, sysFunc:Function = null) {
			// data type
			if (type == NoteAndMarkData.TYPE_NOTE) this._type = NoteAndMarkData.TYPE_NOTE;
				else this._type = NoteAndMarkData.TYPE_MARK;
			// user
			this._userid = "";
			// local data
			this._systemFunction = sysFunc;
			this._localData = new Array();
			var localArray:Array;
			if (this._systemFunction != null) {
				// use the system function to read/write data
				localArray = this._systemFunction("load").split("|br|");
			} else {
				// use shared object to read/write data
				this._local = SharedObject.getLocal("local_" + this._type);
				localArray = String(this._local.data.savedValue).split("|br|");
			}
			if (localArray.length > 0) {
				for (var index:uint = 0; index < localArray.length; index++) {
					var localItem:Array = String(localArray[index]).split("|it|");
					if (localItem.length == 5) {
						this._localData[String(localItem[0])] = new Array(String(localItem[0]), String(localItem[1]), String(localItem[2]), String(localItem[3]), String(localItem[4]));
					}
				}
			}
			// user data
			this._logged = false;
			this._userData = new Array();
		}
		
		// READ-ONLY VALUES
		
		/**
		 * The object data type: note or mark.
		 */
		public function get type():String {
			return (this._type);
		}
		
		/**
		 * The current user id.
		 */
		public function get userid():String {
			return (this._userid);
		}
		
		// PUBLIC METHODS
		
		/**
		 * Set the current user id.
		 * @param	id	the user id
		 */
		public function setUser(id:String):void {
			this._userid = id;
			this._logged = true;
			var userArray:Array;
			if (this._systemFunction != null) {
				userArray = this._systemFunction("load", null, id).split("|br|");
			} else {
				this._user = SharedObject.getLocal(this._type + "_" + id);
				userArray = String(this._user.data.savedValue).split("|br|");
			}
			for (var item:String in this._userData) delete(this._userData[item]);
			if (userArray.length > 0) {
				for (var index:uint = 0; index < userArray.length; index++) {
					var userItem:Array = String(userArray[index]).split("|it|");
					if (userItem.length == 5) {
						this._userData[String(userItem[0])] = new Array(String(userItem[0]), String(userItem[1]), String(userItem[2]), String(userItem[3]), String(userItem[4]));
					}
				}
			}
		}
		
		/**
		 * Clear current user id.
		 */
		public function clearUser():void {
			this._userid = "";
			this._logged = false;
			for (var item:String in this._userData) delete(this._userData[item]);
			if (this._user != null) {
				try {
					this._user.flush();
					this._user.close();
					this._user = null;
				} catch (e:Error) { }
			}
		}
		
		/**
		 * Save sync data received for current user.
		 * @param	data	the server data
		 */
		public function saveSync(data:String):void {
			if (this._logged) {
				var userArray:Array;
				if (this._systemFunction != null) {
					userArray = this._systemFunction("save", data, this._userid).split("|br|");
				} else {
					this._user.data.savedValue = data;
					this._user.flush();
					userArray = String(this._user.data.savedValue).split("|br|");
				}
				for (var item:String in this._userData) delete(this._userData[item]);
				if (userArray.length > 0) {
					for (var index:uint = 0; index < userArray.length; index++) {
						var userItem:Array = String(userArray[index]).split("|it|");
						if (userItem.length == 5) {
							this._userData[String(userItem[0])] = new Array(String(userItem[0]), String(userItem[1]), String(userItem[2]), String(userItem[3]), String(userItem[4]));
						}
					}
				}
			}
		}
		
		/**
		 * Save current data.
		 */
		public function saveData():void {
			// prepare items for saving
			var preparedData:Array = new Array();
			for (var item:String in this._localData) {
				preparedData[item] = this._localData[item].join("|it|");
			}
			// user data?
			if (this._logged) {
				for (item in this._userData) {
					preparedData[item] = this._userData[item].join("|it|");
				}
			}
			var dataToSave:String = "";
			for (item in preparedData) dataToSave += preparedData[item] + "|br|";
			dataToSave = dataToSave.substring(0, (dataToSave.length - 4));
			// save local?
			if (!this._logged) {
				if (this._systemFunction != null) {
					this._systemFunction("save", dataToSave);
				} else {
					this._local.data.savedValue = dataToSave;
					this._local.flush();
				}
			} else {
				if (this._systemFunction != null) {
					this._systemFunction("save", dataToSave, this._userid);
				} else {
					this._user.data.savedValue = dataToSave;
					this._user.flush();
				}
			}
		}
		
		/**
		 * Add a note or bookmark item.
		 * @param	title	the item title
		 * @param	text	the item text
		 * @param	stream	the stream id
		 * @param	community	the community id
		 */
		public function addItem(title:String, text:String, stream:String, community:String):void {
			// item id
			var itemid:String = "d" + String(new Date().time);
			// local or user?
			if (!this._logged) {
				this._localData[itemid] = [ itemid, title, text, stream, community ];
			} else {
				this._userData[itemid] = [ itemid, title, text, stream, community ];
			}
			// save
			this.saveData();
		}
		
		/**
		 * Remove a note or bookmark item.
		 * @param	id	the item id to remove
		 */
		public function deleteItem(id:String):void {
			delete(this._localData[id]);
			if (this._logged) delete(this._userData[id]);
			this.saveData();
		}
		
		/**
		 * Current notes or bookmark items.
		 * @return	an array with the items information
		 */
		public function getItems():Array {
			var items:Array = new Array();
			if (this._logged) for (index in this._userData) items[this._userData[index][0]] = new Array(this._userData[index][0], this._userData[index][1], this._userData[index][2], this._userData[index][3], this._userData[index][4]);
			for (var index:String in this._localData) items[this._localData[index][0]] = new Array(this._localData[index][0], this._localData[index][1], this._localData[index][2], this._localData[index][3], this._localData[index][4]);
			var itemsfinal:Array = new Array();
			for (index in items) itemsfinal.push(items[index]);
			return (itemsfinal);
		}
		
		/**
		 * Release memory used by the object.
		 */
		public function kill():void {
			for (var index:String in this._localData) delete (this._localData[index]);
			for (index in this._userData) delete (this._userData[index]);
			this._localData = null;
			this._userData = null;
			if (this._systemFunction != null) {
				this._systemFunction = null;
			} else {
				this._local.close();
				this._local = null;
				if (this._logged) {
					this._user.close();
					this._user = null;
				}
			}
			this._userid = null;
			this._type = null;
		}
	}

}
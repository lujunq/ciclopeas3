package art.ciclope.data {
		
	// FLASH PACKAGES
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	
	// CICLOPE CLASSES
	import art.ciclope.event.LeapDataEvent;
	
	// LEAP CLASSES
	import com.leapmotion.leap.SwipeGesture;
	//import com.leapmotion.leap.LeapMotion;
	import com.leapmotion.leap.events.LeapEvent;
	import com.leapmotion.leap.Frame;
	import com.leapmotion.leap.Hand;
	import com.leapmotion.leap.Vector3;
	import com.leapmotion.leap.Finger;
	import com.leapmotion.leap.Gesture;
	
	import com.leapmotion.leap.Controller;
	
	/**
	 * <b>Availability:</b> CICLOPE AS3 Classes - www.ciclope.art.br<br>
	 * <b>License:</b> GNU LGPL version 3<br><br>
	 * LeapData provides a simplifued interface to interact with the Leap Motion controller. I iteracts with the LeapMotionAS3 library (https://github.com/logotype/LeapMotionAS3).
	 * @author Lucas Junqueira - lucas@ciclope.art.br
	 */
	public class LeapData extends EventDispatcher {
		
		// STATIC VARIABLES
		
		/**
		 * Leap controller mode: send raw finger data.
		 */
		public static var MODE_RAW:String = "MODE_RAW";
		
		/**
		 * Leap controller mode: send auto-calibrated finger data.
		 */
		public static var MODE_AUTOCALIBRATION:String = "MODE_AUTOCALIBRATION";
		
		/**
		 * Leap controller mode: send calibrated finger data.
		 */
		public static var MODE_CALIBRATION:String = "MODE_CALIBRATION";
		
		// VARIABLES
		
		private var _leap:Controller;			// the leap motion controller reference
		private var _frame:Frame;				// current frame information
		private var _hand0:Hand;				// current first hand information
		private var _hand1:Hand;				// current second hand information
		private var _fingers0:Array;			// first hand fingers information
		private var _numFingers0:uint;			// number of fingers detected at first hand
		private var _numFingers1:uint;			// number of fingers detected at second hand
		private var _fingers1:Array;			// second hand fingers information
		private var _avgPos0:Object;			// average finger position for first hand
		private var _avgPos1:Object;			// average finger position for second hand
		private var _handsDetected:Boolean;		// is there at least a single hand detected?
		private var _numHands:uint;				// number of hands detected (0 to 2)
		private var _sphere0Radius:Number;		// first hand sphere radius
		private var _sphere0Center:Object;		// first hand sphere center
		private var _palm0Position:Object;		// first hand palm position
		private var _sphere1Radius:Number;		// second hand sphere radius
		private var _sphere1Center:Object;		// second hand sphere center
		private var _palm1Position:Object;		// second hand palm position
		private var _lastGSwipe:Number;			// last recognized swipe gesture
		private var _lastSwipeSent:String;		// last swipe gesture sent
		private var _swipeTimeout:int;			// last swipe clear Timeout
		private var _mode:String;				// finger data send mode
		private var _maxX:Number;				// maximum X detected
		private var _maxY:Number;				// maximum Y detected
		private var _maxZ:Number;				// maximum Z detected
		private var _minX:Number;				// minimum X detected
		private var _minY:Number;				// minimum Y detected
		private var _minZ:Number;				// minimum Z detected
		private var _deltaX:Number;				// X variance
		private var _deltaY:Number;				// Y variance
		private var _deltaZ:Number;				// Z variance
		private var _calibrating:Boolean;		// is system in calibration mode?
		private var _calX:Array;				// x axis calibration data
		private var _calY:Array;				// y axis calibration data
		private var _calText:String;			// calibration message text
		private var _calError:String;			// calibration error text
		private var _calOK:String;				// calibration success message
		private var _calTLText:String;			// calibration point to top left text
		private var _calBRText:String;			// calibration point to bottom right text
		private var _calStage:Stage;			// stage reference for calibration
		private var _calInterval:int;			// calibration interval reference
		private var _calCount:uint;				// calibration counting
		private var _calSprite:Sprite;			// calibration sprite
		private var _calState:uint;				// calibration state: 0 for tl; 1 for br
		
		/**
		 * LeapData constructor.
		 * @param	autoCalib	use auto calibration?
		 * @param	startMinX	initial minimum x value
		 * @param	startMaxX	initial maximum x value
		 * @param	startMinY	initial minimum y value
		 * @param	startMaxY	initial maximum y value
		 * @param	startMinZ	initial minimum z value
		 * @param	startMaxZ	initial maximum z value
		 */
		public function LeapData(autoCalib:Boolean = false, startMinX:Number = -50, startMaxX:Number = 50, startMinY:Number = 70, startMaxY:Number = 100, startMinZ:Number = -50, startMaxZ:Number = 50) {
			// auto calibration
			if (autoCalib) this._mode = LeapData.MODE_AUTOCALIBRATION;
				else this._mode = LeapData.MODE_RAW;
			this._calibrating = false;
			this._minX = startMinX;
			this._minY = startMinY;
			this._minZ = startMinZ;
			this._maxX = startMaxX;
			this._maxY = startMaxY;
			this._maxZ = startMaxZ;
			this._deltaX = this._maxX - this._minX;
			this._deltaY = this._maxY - this._minY;
			this._deltaZ = this._maxZ - this._minZ;
			// start leap
			/*this._leap = new LeapMotion();
			this._leap.controller.addEventListener(LeapEvent.LEAPMOTION_INIT, onInit);
			this._leap.controller.addEventListener(LeapEvent.LEAPMOTION_CONNECTED, onConnect);
			this._leap.controller.addEventListener(LeapEvent.LEAPMOTION_DISCONNECTED, onDisconnect);
			this._leap.controller.addEventListener(LeapEvent.LEAPMOTION_EXIT, onExit);
			this._leap.controller.addEventListener(LeapEvent.LEAPMOTION_FRAME, onFrame);*/
			
			this._leap = new Controller();
			this._leap.addEventListener(LeapEvent.LEAPMOTION_INIT, onInit);
			this._leap.addEventListener(LeapEvent.LEAPMOTION_CONNECTED, onConnect);
			this._leap.addEventListener(LeapEvent.LEAPMOTION_DISCONNECTED, onDisconnect);
			this._leap.addEventListener(LeapEvent.LEAPMOTION_EXIT, onExit);
			this._leap.addEventListener(LeapEvent.LEAPMOTION_FRAME, onFrame);
			
			
			// prepare data
			this._fingers0 = new Array();
			this._fingers1 = new Array();
			this._avgPos0 = new Object();
			this._avgPos0.x = null;
			this._avgPos0.y = null;
			this._avgPos0.z = null;
			this._avgPos0.pitch = null;
			this._avgPos0.roll = null;
			this._avgPos0.yaw = null;
			this._avgPos1 = new Object();
			this._avgPos1.x = null;
			this._avgPos1.y = null;
			this._avgPos1.z = null;
			this._avgPos1.pitch = null;
			this._avgPos1.roll = null;
			this._avgPos1.yaw = null;
			this._numHands = 0;
			this._handsDetected = false;
			this._numFingers0 = 0;
			this._numFingers1 = 0;
			this._sphere0Radius = 0;
			this._sphere0Center = new Object();
			this._sphere0Center.x = null;
			this._sphere0Center.y = null;
			this._sphere0Center.z = null;
			this._sphere0Center.pitch = null;
			this._sphere0Center.roll = null;
			this._sphere0Center.yaw = null;
			this._palm0Position = new Object();
			this._palm0Position.x = null;
			this._palm0Position.y = null;
			this._palm0Position.z = null;
			this._palm0Position.pitch = null;
			this._palm0Position.roll = null;
			this._palm0Position.yaw = null;
			this._sphere1Radius = 0;
			this._sphere1Center = new Object();
			this._sphere1Center.x = null;
			this._sphere1Center.y = null;
			this._sphere1Center.z = null;
			this._sphere1Center.pitch = null;
			this._sphere1Center.roll = null;
			this._sphere1Center.yaw = null;
			this._palm1Position = new Object();
			this._palm1Position.x = null;
			this._palm1Position.y = null;
			this._palm1Position.z = null;
			this._palm1Position.pitch = null;
			this._palm1Position.roll = null;
			this._palm1Position.yaw = null;
			this._lastGSwipe = 0;
			this._lastSwipeSent = "";
		}
		
		// READ-ONLY VALUES
		
		/**
		 * Is Leap Motion device ready?
		 */
		public function get ready():Boolean {
			return (this._leap.isConnected());
		}
		
		/**
		 * Current frame information.
		 */
		public function get frame():Frame {
			return (this._frame);
		}
		
		/**
		 * Current first detected hand (null if no hand is detected).
		 */
		public function get hand0():Hand {
			return (this._hand0);
		}
		
		/**
		 * Current second detected hand (null if no second hand is detected).
		 */
		public function get hand1():Hand {
			return (this._hand1);
		}
		
		/**
		 * The number of detected fingers on first hand.
		 */
		public function get numFingers0():uint {
			return (this._numFingers0);
		}
		
		/**
		 * The number of detected fingers on second hand.
		 */
		public function get numFingers1():uint {
			return (this._numFingers1);
		}
		
		/**
		 * First hand sphere radius.
		 */
		public function get sphere0Radius():Number {
			return (this._sphere0Radius);
		}
		
		/**
		 * Second hand sphere radius.
		 */
		public function get sphere1Radius():Number {
			return (this._sphere1Radius);
		}
		
		/**
		 * First hand sphere center represented by an object with 6 properties: x, y, z, pitch, roll and yaw.
		 */
		public function get sphere0Center():Object {
			return (this._sphere0Center);
		}
		
		/**
		 * Second hand sphere center represented by an object with 6 properties: x, y, z, pitch, roll and yaw.
		 */
		public function get sphere1Center():Object {
			return (this._sphere1Center);
		}
		
		/**
		 * First hand palm position represented by an object with 6 properties: x, y, z, pitch, roll and yaw.
		 */
		public function get palm0Position():Object {
			return (this._palm0Position);
		}
		
		/**
		 * Second hand palm position represented by an object with 6 properties: x, y, z, pitch, roll and yaw.
		 */
		public function get palm1Position():Object {
			return (this._palm1Position);
		}
		
		/**
		 * First hand fingers information (empty array if no fingers are detected). One finger per index, in order. Fingers are represented by objects with 6 properties: x, y, z, pitch, roll and yaw.
		 */
		public function get fingers0():Array {
			return (this._fingers0);
		}
		
		/**
		 * Second hand fingers information (empty array if no fingers are detected). One finger per index, in order. Fingers are represented by objects with 6 properties: x, y, z, pitch, roll and yaw.
		 */
		public function get fingers1():Array {
			return (this._fingers1);
		}
		
		/**
		 * Is there at least a single hand detected?
		 */
		public function get handsDetected():Boolean {
			return (this._handsDetected);
		}
		
		/**
		 * The number of detected hands (0 to 2).
		 */
		public function get numHands():uint {
			return (this._numHands);
		}
		
		/**
		 * The average finger position for the first hand on an object with properties "x", "y", "z", "pitch", "roll" and "yaw". Null values for every property if no first hand is detected.
		 */
		public function get avgPos0():Object {
			return (this._avgPos0);
		}
		
		/**
		 * The average finger position for the second hand on an object with properties "x", "y", "z", "pitch", "roll" and "yaw". Null values for every property if no second hand is detected.
		 */
		public function get avgPos1():Object {
			return (this._avgPos1);
		}
		
		/**
		 * Current calibration data (an object with properties xmin, ymin, zmin, xmax, ymax and zmax).
		 */
		public function get calibration():Object {
			return ( { xmin:this._minX, ymin:this._minY, zmin:this._minZ, xmax:this._maxX, ymax:this._maxY, zmax:this._maxZ } );
		}
		
		// PUBLIC METHODS
		
		/**
		 * Set calibration data.
		 * @param	minX	minimum x value
		 * @param	maxX	maximum x value
		 * @param	minY	minimum y value
		 * @param	maxY	maximum y value
		 * @param	minZ	minimum z value
		 * @param	maxZ	maximum z value
		 */
		public function setCalibration(minX:Number, maxX:Number, minY:Number, maxY:Number, minZ:Number = -50, maxZ:Number = 50):void {
			this._minX = minX;
			this._minY = minY;
			this._minZ = minZ;
			this._maxX = maxX;
			this._maxY = maxY;
			this._maxZ = maxZ;
			this._deltaX = this._maxX - this._minX;
			this._deltaY = this._maxY - this._minY;
			this._deltaZ = this._maxZ - this._minZ;
			this._mode = LeapData.MODE_CALIBRATION;
		}
		
		/**
		 * Start Leap Motion device calibration.
		 * @param	stg	a reference to the stage
		 * @param	message	the calibration message
		 * @param	error	a calibration error message
		 * @param	success	successfull calibration message
		 * @param	tl	point to top left message
		 * @param	br	point to down right message
		 */
		public function calibrate(stg:Stage, message:String = null, error:String = null, success:String = null, tl:String = null, br:String = null):void {
			this._calStage = stg;
			// get text
			if (message == null) this._calText = "calibrating the Leap Motion device";
				else this._calText = message;
			if (error == null) this._calError = "errors found while calibrating the Leap Motion device";
				else this._calError = error;
			if (tl == null) this._calTLText = "point to the top left corner of the window for a while";
				else this._calTLText = tl;
			if (br == null) this._calBRText = "point to the bottom right corner of the window for a while";
				else this._calBRText = br;
			if (success == null) this._calOK = "Leap Motion device successfully calibrated";
				else this._calOK = success;
			// prepare calibration
			this._calSprite = new Sprite();
			this._calStage.addChild(this._calSprite);
			this.showCalibText(this._calText + "\n" + this._calTLText);
			this._calX = new Array();
			this._calY = new Array();
			this._calState = 0;
			this._calCount = 0;
			this._calibrating = true;
			setTimeout(calibrationCheck, 5000);
		}
		
		/**
		 * Release resources used by the object.
		 */
		public function kill():void {
			/*this._leap.controller.removeEventListener(LeapEvent.LEAPMOTION_INIT, onInit);
			this._leap.controller.removeEventListener(LeapEvent.LEAPMOTION_CONNECTED, onConnect);
			this._leap.controller.removeEventListener(LeapEvent.LEAPMOTION_DISCONNECTED, onDisconnect);
			this._leap.controller.removeEventListener(LeapEvent.LEAPMOTION_EXIT, onExit);
			this._leap.controller.removeEventListener(LeapEvent.LEAPMOTION_FRAME, onFrame);*/
			
			this._leap.removeEventListener(LeapEvent.LEAPMOTION_INIT, onInit);
			this._leap.removeEventListener(LeapEvent.LEAPMOTION_CONNECTED, onConnect);
			this._leap.removeEventListener(LeapEvent.LEAPMOTION_DISCONNECTED, onDisconnect);
			this._leap.removeEventListener(LeapEvent.LEAPMOTION_EXIT, onExit);
			this._leap.removeEventListener(LeapEvent.LEAPMOTION_FRAME, onFrame);
			
			this._leap = null;
			this.clearData();
			this._fingers0 = null;
			this._fingers1 = null;
			this._avgPos0 = null;
			this._avgPos1 = null;
			this._sphere0Center = null;
			this._sphere1Center = null;
			this._palm0Position = null;
			this._palm1Position = null;
			try { clearTimeout(this._swipeTimeout); } catch (e:Error) { }
			this._lastSwipeSent = null;
		}
		
		// PRIVATE METHODS
		
		/**
		 * Check calibration state.
		 */
		private function calibrationCheck():void {
			// enough data?
			if (this._calCount > 100) {
				this.showCalibText(this._calError);
				this._calibrating = false;
				setTimeout(calibrationEnd, 3000);
			} else {
				var index:uint;
				// calibration state
				if (this._calState == 0) { // top left
					this._minX = 0;
					for (index = 0; index < this._calX.length; index++) this._minX += this._calX[index];
					this._minX = this._minX / this._calX.length;
					this._calX = new Array();
					this._maxY = 0;
					for (index = 0; index < this._calY.length; index++) this._maxY += this._calY[index];
					this._maxY = this._maxY / this._calY.length;
					this._calY = new Array();
					this._deltaX = this._maxX - this._minX;
					this._deltaY = this._maxY - this._minY;
					this._calState = 1;
					this.showCalibText(this._calText + "\n" + this._calBRText);
					this._calCount = 0;
					setTimeout(calibrationCheck, 5000);
				} else if (this._calState == 1) { // bottom right
					this._maxX = 0;
					for (index = 0; index < this._calX.length; index++) this._maxX += this._calX[index];
					this._maxX = this._maxX / this._calX.length;
					this._minY = 0;
					for (index = 0; index < this._calY.length; index++) this._minY += this._calY[index];
					this._minY = this._minY / this._calY.length;
					this._deltaX = this._maxX - this._minX;
					this._deltaY = this._maxY - this._minY;
					this._calState = 2;
					this.showCalibText(this._calOK);
					this._calibrating = false;
					this._mode = LeapData.MODE_CALIBRATION;
					this.dispatchEvent(new LeapDataEvent(LeapDataEvent.LEAP_CALIBRATE));
					setTimeout(calibrationEnd, 3000);
				} else {
					this._calibrating = false;
					this.calibrationEnd();
				}
			}
		}
		
		/**
		 * Finish calibration process.
		 */
		private function calibrationEnd():void {
			this._calStage.removeChild(this._calSprite);
			this._calSprite.removeChildren();
			this._calSprite = null;
			this._calText = null;
			this._calTLText = null;
			this._calBRText = null;
			this._calError = null;
			this._calStage = null;
			this._calX = null;
			this._calY = null;
		}
		
		/**
		 * Show calibration text.
		 * @param	text	the text to show
		 */
		private function showCalibText(text:String):void {
			this._calSprite.removeChildren();
			var txmessage:TextField = new TextField();
			txmessage.defaultTextFormat = new TextFormat("_sans", 15, 0xFFFFFF, true, null, null, null, null, "center");
			txmessage.autoSize = "center";
			txmessage.selectable = false;
			txmessage.multiline = true;
			txmessage.text = text;
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0xCCCCCC, 0.75);
			shape.graphics.drawRoundRect(0, 0, (txmessage.width + 50), (txmessage.height + 50), 10, 10);
			shape.graphics.endFill();
			this._calSprite.addChild(shape);
			this._calSprite.addChild(txmessage);
			txmessage.x = 25;
			txmessage.y = 25;
			this._calSprite.x = (this._calStage.stageWidth - this._calSprite.width) / 2;
			this._calSprite.y = (this._calStage.stageHeight - this._calSprite.height) / 2;
		}
		
		/**
		 * Leap Motion device initialized.
		 */
		private function onInit(evt:LeapEvent):void {
			this.dispatchEvent(new LeapDataEvent(LeapDataEvent.LEAP_INIT));
		}
		
		/**
		 * Leap Motion device disconnected.
		 */
		private function onDisconnect(evt:LeapEvent):void {
			this.dispatchEvent(new LeapDataEvent(LeapDataEvent.LEAP_DISCONNECT));
		}
		
		/**
		 * Leap Motion device connected.
		 */
		private function onConnect(evt:LeapEvent):void {
			this._leap.enableGesture(Gesture.TYPE_SWIPE, true);
			this.dispatchEvent(new LeapDataEvent(LeapDataEvent.LEAP_CONNECT));
		}
		
		/**
		 * Leap Motion device exit.
		 */
		private function onExit(evt:LeapEvent):void {
			this.dispatchEvent(new LeapDataEvent(LeapDataEvent.LEAP_EXIT));
		}
		
		/**
		 * Frame data received from the Leap Motion device.
		 */
		private function onFrame(evt:LeapEvent):void {
			if (this._calibrating) {
				// getting calibration data
				if (evt.frame.hands.length > 0) {
					if (evt.frame.hands[0].fingers.length > 0) {
						this._calX.push(evt.frame.hands[0].fingers[0].tipPosition.x);
						this._calY.push(evt.frame.hands[0].fingers[0].tipPosition.y);
					} else {
						this._calCount++;
					}
				} else {
					this._calCount++;
				}
			} else {
				this._frame = evt.frame;
				this.clearData();
				if (frame.hands.length > 0) {
					// get first hand
					this._handsDetected = true;
					this._numHands = 1;
					this._hand0 = this._frame.hands[0];
					this._sphere0Radius = this._hand0.sphereRadius;
					this._sphere0Center.x = this._hand0.sphereCenter.x;
					this._sphere0Center.y = this._hand0.sphereCenter.y;
					this._sphere0Center.z = this._hand0.sphereCenter.z;
					this._sphere0Center.pitch = this._hand0.sphereCenter.pitch;
					this._sphere0Center.roll = this._hand0.sphereCenter.roll;
					this._sphere0Center.yaw = this._hand0.sphereCenter.yaw;
					this._palm0Position.x = this._hand0.palmPosition.x;
					this._palm0Position.y = this._hand0.palmPosition.y;
					this._palm0Position.z = this._hand0.palmPosition.z;
					this._palm0Position.pitch = this._hand0.palmPosition.pitch;
					this._palm0Position.roll = this._hand0.palmPosition.roll;
					this._palm0Position.yaw = this._hand0.palmPosition.yaw;
					this._numFingers0 = this._hand0.fingers.length;
					this.getFingers(this._hand0, this._fingers0, this._avgPos0);
					// second hand?
					if (frame.hands.length > 1) {
						this._numHands = 2;
						this._hand1 = this._frame.hands[1];
						this._sphere1Radius = this._hand1.sphereRadius;
						this._sphere1Center.x = this._hand1.sphereCenter.x;
						this._sphere1Center.y = this._hand1.sphereCenter.y;
						this._sphere1Center.z = this._hand1.sphereCenter.z;
						this._sphere1Center.pitch = this._hand1.sphereCenter.pitch;
						this._sphere1Center.roll = this._hand1.sphereCenter.roll;
						this._sphere1Center.yaw = this._hand1.sphereCenter.yaw;
						this._palm1Position.x = this._hand1.palmPosition.x;
						this._palm1Position.y = this._hand1.palmPosition.y;
						this._palm1Position.z = this._hand1.palmPosition.z;
						this._palm1Position.pitch = this._hand1.palmPosition.pitch;
						this._palm1Position.roll = this._hand1.palmPosition.roll;
						this._palm1Position.yaw = this._hand1.palmPosition.yaw;
						this._numFingers1 = this._hand1.fingers.length;
						this.getFingers(this._hand1, this._fingers1, this._avgPos1);
					}
				}
				// check for gestures
				var hasGestures:Boolean = false;
				if (frame.gestures.length > 0) {
					for each(var gesture:Gesture in frame.gestures) {
						if (gesture.type == Gesture.TYPE_SWIPE) {
							if (gesture.id != this._lastGSwipe) {
								var swipegesture:SwipeGesture = gesture as SwipeGesture;
								// check swipe direction
								var dir:String = "";
								if (swipegesture.direction.x > 0.5) dir = LeapDataEvent.TYPE_SWIPE_PREVX;
									else if (swipegesture.direction.x < -0.5) dir = LeapDataEvent.TYPE_SWIPE_NEXTX;
									else if (swipegesture.direction.y > 0.5) dir = LeapDataEvent.TYPE_SWIPE_NEXTY;
									else if (swipegesture.direction.y < -0.5) dir = LeapDataEvent.TYPE_SWIPE_PREVY;
									else if (swipegesture.direction.z > 0.5) dir = LeapDataEvent.TYPE_SWIPE_PREVZ;
									else if (swipegesture.direction.z < -0.5) dir = LeapDataEvent.TYPE_SWIPE_NEXTZ;
								if (dir != this._lastSwipeSent) {
									this.dispatchEvent(new LeapDataEvent(dir, gesture.id));
									this._lastSwipeSent = dir;
									this._lastGSwipe = gesture.id;
									hasGestures = true;
									try { clearTimeout(this._swipeTimeout); } catch (e:Error) { }
									this._swipeTimeout = setTimeout(this.clearSwipe, 1000);
								}
							}
						}
					}
				}
				// warn listeners of new frame if no gesture is found
				if (!hasGestures) this.dispatchEvent(new LeapDataEvent(LeapDataEvent.LEAP_FRAME));
			}
		}
		
		/**
		 * Process hand information into a fingers array.
		 * @param	hand	the hand data to process
		 * @param	fingers	the fingers array
		 * @param	avgpos	average position object
		 */
		private function getFingers(hand:Hand, fingers:Array, avgpos:Object):void {
			var handfingers:Vector.<Finger> = hand.fingers;
			var fingeravgpos:Vector3 = Vector3.zero();
			// get all fingers information
			for each (var finger:Finger in handfingers) {
				fingeravgpos = fingeravgpos.plus(finger.tipPosition);
				if (this._mode == LeapData.MODE_RAW) {
					fingers.push( { x: finger.tipPosition.x, y: finger.tipPosition.y, z: finger.tipPosition.z, pitch: finger.tipPosition.pitch, roll: finger.tipPosition.roll, yaw: finger.tipPosition.yaw } );
				} else if (this._mode == LeapData.MODE_CALIBRATION) {
					fingers.push( { x: getCalibrated('x', finger.tipPosition.x), y: getCalibrated('y', finger.tipPosition.y), z: finger.tipPosition.z, pitch: finger.tipPosition.pitch, roll: finger.tipPosition.roll, yaw: finger.tipPosition.yaw } );
				} else {
					// adjust calibration values
					if (finger.tipPosition.x < this._minX) {
						this._minX = finger.tipPosition.x;
						this._deltaX = this._maxX - this._minX;
					} else if (finger.tipPosition.x > this._maxX) {
						this._maxX = finger.tipPosition.x;
						this._deltaX = this._maxX - this._minX;
					}
					if (finger.tipPosition.y < this._minY) {
						this._minY = finger.tipPosition.y;
						this._deltaY = this._maxY - this._minY;
					} else if (finger.tipPosition.y > this._maxY) {
						this._maxY = finger.tipPosition.y;
						this._deltaY = this._maxY - this._minY;
					}
					if (finger.tipPosition.z < this._minZ) {
						this._minZ = finger.tipPosition.z;
						this._deltaZ = this._maxZ - this._minZ;
					} else if (finger.tipPosition.z > this._maxZ) {
						this._maxZ = finger.tipPosition.z;
						this._deltaZ = this._maxZ - this._minZ;
					}
					// get calibrated values
					fingers.push( { x: getCalibrated('x', finger.tipPosition.x), y: getCalibrated('y', finger.tipPosition.y), z: getCalibrated('z', finger.tipPosition.z), pitch: finger.tipPosition.pitch, roll: finger.tipPosition.roll, yaw: finger.tipPosition.yaw } );
				}
			}
			// average finger position
			if (handfingers.length > 0) {
				fingeravgpos = fingeravgpos.divide(handfingers.length);
				avgpos.x = fingeravgpos.x;
				avgpos.y = fingeravgpos.y;
				avgpos.z = fingeravgpos.z;
				avgpos.pitch = fingeravgpos.pitch;
				avgpos.roll = fingeravgpos.roll;
				avgpos.yaw = fingeravgpos.yaw;
			}
		}
		
		/**
		 * Get a calibrated value.
		 * @param	axis	x, y or z
		 * @param	value	the value to calibrate
		 * @return	the calibrated value, from 0 to 100
		 */
		private function getCalibrated(axis:String, value:Number):Number {
			if (axis == 'x') {
				return ((100 * (value - this._minX)) / this._deltaX);
			} else if (axis == 'y') {
				return ((100 * (value - this._minY)) / this._deltaY);
			} else if (axis == 'z') {
				return ((100 * (value - this._minZ)) / this._deltaZ);
			} else {
				return (0);
			}
		}
		
		/**
		 * Clear hands and fingers data from both hands.
		 */
		private function clearData():void {
			while (this._fingers0.length > 0) this._fingers0.shift();
			while (this._fingers1.length > 0) this._fingers1.shift();
			this._avgPos0.x = null;
			this._avgPos0.y = null;
			this._avgPos0.z = null;
			this._avgPos0.pitch = null;
			this._avgPos0.roll = null;
			this._avgPos0.yaw = null;
			this._avgPos1.x = null;
			this._avgPos1.y = null;
			this._avgPos1.z = null;
			this._avgPos1.pitch = null;
			this._avgPos1.roll = null;
			this._avgPos1.yaw = null;
			this._hand0 = null;
			this._hand1 = null;
			this._numHands = 0;
			this._handsDetected = false;
			this._numFingers0 = 0;
			this._numFingers1 = 0;
			this._sphere0Radius = 0;
			this._sphere0Center.x = null;
			this._sphere0Center.y = null;
			this._sphere0Center.z = null;
			this._sphere0Center.pitch = null;
			this._sphere0Center.roll = null;
			this._sphere0Center.yaw = null;
			this._palm0Position.x = null;
			this._palm0Position.y = null;
			this._palm0Position.z = null;
			this._palm0Position.pitch = null;
			this._palm0Position.roll = null;
			this._palm0Position.yaw = null;
			this._sphere1Radius = 0;
			this._sphere1Center.x = null;
			this._sphere1Center.y = null;
			this._sphere1Center.z = null;
			this._sphere1Center.pitch = null;
			this._sphere1Center.roll = null;
			this._sphere1Center.yaw = null;
			this._palm1Position.x = null;
			this._palm1Position.y = null;
			this._palm1Position.z = null;
			this._palm1Position.pitch = null;
			this._palm1Position.roll = null;
			this._palm1Position.yaw = null;
		}
		
		/**
		 * Clear the last swipe sent information.
		 */
		private function clearSwipe():void {
			this._lastSwipeSent = "";
		}
		
	}

}
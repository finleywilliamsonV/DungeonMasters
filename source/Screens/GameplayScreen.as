package {

	// errors:

	/*
	
	boss throws error when cannot move
	
	arrow trap throws error when stepped on
	
	*/


	// find it x 5


	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;
	import flash.geom.Rectangle;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.globalization.StringTools;
	import flash.utils.getDefinitionByName;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.TransformGesture;
	import flash.geom.Point;



	//
	// 	GameplayScreen contains main ui panel, various ui components, and a MasterGrid object (Dungeon)
	//

	public class GameplayScreen extends MovieClip {

		private static var RESET_ALL: Boolean = false;

		private var _docClass: DocClass;
		private var _masterGrid: MasterGrid;

		private var _dm: DungeonMaster;

		private var _currentMode: String;

		private var _ui_navPanel: UI_NavPanel;
		private var _goldDisplay: GoldDisplay;

		private var _btn_play: BTN_Play;
		private var _btn_stop: BTN_Stop;

		public var _UI: GameplayUI;

		private var _currentPanel: * ;

		private var _maskRect: Rectangle;

		private var _totalNotoriety: int;

		private var _ui_Selector: UI_Selector;
		private var _ui_Selected: * ;

		private var _savedX: int;
		private var _savedY: int;
		private var _savedScale: Number;

		private var _ui_UnitControlPanel: Sprite;
		private var _ui_NotorietyBar: UI_NotorietyBar;

		private var _ui_VisibilityButton: UI_VisibilityButton;

		private var _ui_SlotPanel_Empty: UI_SlotPanel_Empty;
		private var _ui_SlotPanel_Buy: UI_SlotPanel_Buy;
		private var _ui_SlotPanel_Set: UI_SlotPanel_Set;
		private var _ui_UnitInfo: UI_UnitInfo;

		private var _ui_DungeonCatalogScreen: DungeonCatalogScreen;
		private var _advProgressBar: UI_AdvProgressBar;

		private var _buttonDown: * ;
		private var _pixelWidth: int;

		private var _notoriety: Number = 0;
		private var _unitStrength: int = 0;

		private var _tempArray = [];
		private var _oneAdvArray = [];

		private var _currentDungeon: Dungeon;
		private var _currentDungeonName: String;

		// -	-	-	-	-	-	-	-	-	-	-	-	NEW !!!!!

		private var _advTeamStrength: int;
		private var _advSpawnTimer: int = 0;
		private var _advTicksPerSpawn: int = 50; //start
		private var _notorietyLevel: int = 1;
		private var _maxNotoriety: int;

		private var _clickListenerSet: Boolean;
		private var _clickListenerArray: Array;

		private var _residualGold: Number;

		private var _wrapperZoom: Sprite;
		private var _wrapperDungeon: Sprite;
		private var _freeTransform: TransformGesture;
		
		private var _savedPauseState: Boolean;

		public function GameplayScreen() {
			// constructor code


		}


		public function pause(displayAlert:Boolean = true): void {
			_dm.isPaused = true;
			_UI.playPause.gotoAndStop(1);
			if (displayAlert) _UI.dungeonAlertPanel.newAlert_PauseToggle(true);
		}
		public function unpause(displayAlert:Boolean = true): void {
			_dm.isPaused = false;
			_UI.playPause.gotoAndStop(2);
			if (displayAlert) _UI.dungeonAlertPanel.newAlert_PauseToggle(false);
		}

		public function get totalNotoriety(): int {
			return _totalNotoriety;
		}

		public function set totalNotoriety(value: int): void {
			_totalNotoriety = value;
			GlobalSharedObject.instance.totalNotoriety = value;
		}


		public function reset(): void {
			_dm.isPaused = true;
			removeChildren();
			setup(_docClass);
		}

		public function purchaseDungeon(newDungeon: Dungeon) {
			trace("\nAttempting Purchase Dungeon");
			_dm.isPaused = true;
			removeChildren();
			_currentDungeon = newDungeon;
			_currentDungeonName = newDungeon.nameString;
			_UI.dungeonNameGraphic.gotoAndStop(newDungeon.dungeonMapIndex);
			_goldDisplay.gold -= newDungeon.goldCost;

			resetNotoriety();
			GlobalSharedObject.instance.notorietyLevel = _notorietyLevel;
			GlobalSharedObject.instance.totalNotoriety = 0;
			GlobalSharedObject.instance.resetSpawnPoints();

			setup(_docClass, newDungeon, _goldDisplay.gold);

			GlobalUnlockTracker.instance.registerDungeonPurchase(newDungeon);

			GlobalVariables.modTimer(500);
			_dm.isPaused = true;
		}

		public function setup(doc: DocClass, specifiedDungeon: Dungeon = null, startingGold: int = -1): void {
			_docClass = doc;

			// create gameplay ui
			_UI = new GameplayUI();

			var firstSetup: Boolean = false;

			if (!specifiedDungeon) {
				var dungeonClass: Class = GlobalSharedObject.instance.currentDungeon as Class;
				specifiedDungeon = new dungeonClass();
				_currentDungeon = specifiedDungeon;
				firstSetup = true;
			}

			_UI.dungeonNameGraphic.gotoAndStop(specifiedDungeon.dungeonMapIndex);

			_ui_Selector = new UI_Selector();

			// here



			trace("\nbefore most - REMAINING NOTORIETY: " + GlobalSharedObject.instance.remainingNotoriety);


			// add background sprite
			var bkgSprite = new Sprite();
			bkgSprite.graphics.beginFill(0x000000);
			bkgSprite.graphics.drawRect(0, 0, 1334, 750);
			addChild(bkgSprite);

			var storedRemainingNotoriety: int = GlobalSharedObject.instance.remainingNotoriety;

			if (firstSetup) {
				storedRemainingNotoriety = GlobalSharedObject.instance.remainingNotoriety;
			} else {
				storedRemainingNotoriety = 0;
			}

			// setup dungeon
			setupDungeon(specifiedDungeon.dungeonLayout);


			trace("\nafter setupDungeon() - REMAINING NOTORIETY: " + GlobalSharedObject.instance.remainingNotoriety);
			trace("\nafter setupDungeon() - STORED REMAINING NOTORIETY: " + storedRemainingNotoriety);


			// add new wrapper sprite, add mastergrid to wrapper
			// add both to _wrapperDungeon

			_wrapperZoom = new Sprite();
			_wrapperDungeon = new Sprite();
			addChild(_wrapperDungeon);
			//_wrapperZoom.graphics.beginFill(0xBCBCBC);
			//_wrapperZoom.graphics.drawRect(0,0,1334/4,750/4);

			//trace(_wrapperZoom.width, _wrapperZoom.height);

			_wrapperZoom.x = _masterGrid.x + _masterGrid.width / 2;
			_wrapperZoom.y = _masterGrid.y + _masterGrid.height / 2;
			_wrapperZoom.scaleX = _masterGrid.scaleX;
			_wrapperZoom.scaleY = _masterGrid.scaleY;
			_wrapperDungeon.addChild(_wrapperZoom);

			_masterGrid.x = -_masterGrid.width / 2;
			_masterGrid.y = -_masterGrid.height / 2;

			_masterGrid.scaleX = 1;
			_masterGrid.scaleY = 1;

			_wrapperZoom.addChild(_masterGrid);

			_freeTransform = new TransformGesture(_wrapperZoom);
			_freeTransform.addEventListener(GestureEvent.GESTURE_BEGAN, onFreeTransform);
			_freeTransform.addEventListener(GestureEvent.GESTURE_CHANGED, onFreeTransform);

			_savedX = _masterGrid.x;
			_savedY = _masterGrid.y;
			_savedScale = _wrapperZoom.scaleX;
			
			
			addChild(_UI);


			// create and add unit control panel
			_ui_UnitControlPanel = new Sprite();
			addChild(_ui_UnitControlPanel);
			/*_ui_UnitControlPanel.width = 5100;
			_ui_UnitControlPanel.height = 625;*/
			_ui_UnitControlPanel.x = 1072;
			_ui_UnitControlPanel.y = 110;


			_ui_VisibilityButton = new UI_VisibilityButton();
			addChild(_ui_VisibilityButton);
			_ui_VisibilityButton.x = 1284;
			_ui_VisibilityButton.y = 50;


			// initialize UI components
			//_ui_SlotPanel_Empty = new UI_SlotPanel_Empty();
			_ui_SlotPanel_Buy = new UI_SlotPanel_Buy();
			_ui_SlotPanel_Set = new UI_SlotPanel_Set();
			_ui_UnitInfo = new UI_UnitInfo();

			// register buy new button
			//GlobalUnlockTracker.instance.newUnlockBubbleHandler.register(_ui_SlotPanel_Set.buyNewButton);

			_ui_DungeonCatalogScreen = new DungeonCatalogScreen(this);

			_advProgressBar = new UI_AdvProgressBar(this, _advTicksPerSpawn);
			addChild(_advProgressBar);

			_ui_NotorietyBar = new UI_NotorietyBar();
			addChild(_ui_NotorietyBar);
			_ui_NotorietyBar.update(_notoriety);

			//add gold display
			_goldDisplay = new GoldDisplay();
			addChild(_goldDisplay);

			if (startingGold < 0) {
				_goldDisplay.gold = GlobalSharedObject.instance.gold;
			} else {
				_goldDisplay.gold = startingGold;
			}

			//_ui_navPanel = new UI_NavPanel(_masterGrid);
			//addChild(_ui_navPanel);


			_clickListenerSet = false;
			_clickListenerArray = [];


			//_masterGrid.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);

			stage.addEventListener(KeyboardEvent.KEY_DOWN, onDown, false, 0, true);

			addEventListener(MouseEvent.CLICK, onClick, false, 0, true);

			_pixelWidth = _masterGrid._nodeSize;

			startGame();

			trace("\nREMAINING NOTORIETY: " + GlobalSharedObject.instance.remainingNotoriety);

			_masterGrid.deserializeSpawnPoints();
			//_masterGrid.transfer();

			/*trace("\n\n\n	8	8	8	8	8	8	8	8	8	8	START ANNOYING NOTORIETY PROBLEM");
			
			trace("\ncurrent totalNotoriety: " + _totalNotoriety);
			trace("stored totalNotoriety: " + GlobalSharedObject.instance.totalNotoriety);
			
			trace("stored notoriety: " + GlobalSharedObject.instance.remainingNotoriety);
			
			trace("\ncurrent notoriety: " + _notoriety);
			trace("current maxNotoriety: " + _maxNotoriety);
			trace("_notoriety / _maxNotoriety " + String(GlobalSharedObject.instance.totalNotoriety / _maxNotoriety));
			
			trace("\ncurrent notorietyLevel: " + _notorietyLevel);
			trace("stored notorietyLevel: " + GlobalSharedObject.instance.notorietyLevel);
			
			trace("\n	8	8	8	8	8	8	8	8	8	8	END ANNOYING NOTORIETY PROBLEM\n\n\n");*/

			//totalNotoriety = GlobalSharedObject.instance.totalNotoriety;
			//notoriety = totalNotoriety;

			_notoriety = storedRemainingNotoriety;

			trace("\nREMAINING NOTORIETY: " + GlobalSharedObject.instance.remainingNotoriety);

			var storedNotorietyLevel: int = GlobalSharedObject.instance.notorietyLevel;
			levelUpNotorietyMultiple(storedNotorietyLevel - 1); // dungeon already @ level 1, so remove one for levelups


			_ui_NotorietyBar.update(_notoriety / _maxNotoriety);

			GlobalUnlockTracker.instance.checkAllStoredProgress();
		}

		private function toggleVisiblityOfUI(): void {

			if (_ui_VisibilityButton.currentFrame == 1) {

				_ui_VisibilityButton.gotoAndStop(2);

				_ui_NotorietyBar.visible = false;
				_ui_UnitControlPanel.visible = false;
				_advProgressBar.visible = false;
				_goldDisplay.visible = false;
				//_UI.residualGoldDisplay.visible = false;
				_UI.menuBar.visible = false;
				_UI.dungeonNameGraphic.visible = false;
				_UI.centerDungeonButton.visible = false;
				_UI.playPause.visible = false;
				_UI.btn_FF.visible = false;
				_UI.dungeonAlertPanel.visible = false;


			} else {

				_ui_VisibilityButton.gotoAndStop(1);

				_ui_NotorietyBar.visible = true;
				_ui_UnitControlPanel.visible = true;
				_advProgressBar.visible = true;
				_goldDisplay.visible = true;
				_UI.menuBar.visible = true;
				_UI.dungeonNameGraphic.visible = true;
				_UI.centerDungeonButton.visible = true;
				_UI.playPause.visible = true;
				_UI.btn_FF.visible = true;
				_UI.dungeonAlertPanel.visible = true;

				/*if (_UI.residualGoldDisplay.residualGold == 0) {
					_UI.residualGoldDisplay.visible = false;
				} else {
					_UI.residualGoldDisplay.visible = true;
				}*/
			}
		}

		private function onFreeTransform(event: GestureEvent): void {

			// move, rotate, scale — all at once for better performance!
			trace(_freeTransform.offsetX, _freeTransform.offsetY, _freeTransform.rotation, _freeTransform.scale);

			_masterGrid.x += _freeTransform.offsetX / _wrapperZoom.scaleX;
			_masterGrid.y += _freeTransform.offsetY / _wrapperZoom.scaleY;
			//_masterGrid.rotation += freeTransform.rotation;

			if ((_wrapperZoom.scaleX < .1 && _freeTransform.scale < 1) || (_wrapperZoom.scaleX > 10 && _freeTransform.scale > 1)) return;
			_wrapperZoom.scaleX *= _freeTransform.scale;
			_wrapperZoom.scaleY *= _freeTransform.scale;

			//var globalPoint:Point = _masterGrid.localToGlobal(new Point(0,0));

			//trace(_wrapperDungeon.x,_wrapperDungeon.y);
		}

		public function earnGold(newAmt: int, sendAlert: Boolean = true): void {

			if (newAmt == 0) return;

			GlobalUnlockTracker.instance.registerGoldEarnedIncrease(newAmt);

			_goldDisplay.gold += newAmt;
			
			if (sendAlert) _UI.dungeonAlertPanel.newAlert_EarnedGold(newAmt);
		}

		public function startGame(): void {

			_dm = new DungeonMaster(this);
			_dm.awaken();
			_dm.isPaused = true;

			_currentDungeonName = _currentDungeon.nameString;

			GlobalVariables.instance.dm = _dm;

			_UI.redButton._gs = this;

			if (RESET_ALL) {
				GlobalSharedObject.instance.resetSharedObject();
				GlobalUnlockTracker.instance.resetSharedObject();
			}
			
			_UI.residualGoldDisplay.visible = false;

		}

		public function startClickListener(): void {
			trace("\n	^	^	^	STARTING CLICK LISTENER	^	^	^");
			_clickListenerSet = true;
			_clickListenerArray = [];
		}

		public function endClickListener(): void {
			_clickListenerSet = false;
			trace("\n	^	^	^	ENDING CLICK LISTENER	^	^	^");
			trace("	^	^	^	" + _clickListenerArray.join(", "));
			_clickListenerArray = [];
		}



		// keyboard handlers
		public function onDown(kE: KeyboardEvent): void {
			if (kE.keyCode == Keyboard.EQUAL) {
				_masterGrid.scaleX += .1;
				_masterGrid.scaleY += .1;
				_masterGrid.x -= _pixelWidth;
				_masterGrid.y -= _pixelWidth;

			} else if (kE.keyCode == Keyboard.MINUS) {
				_masterGrid.scaleX -= .1;
				_masterGrid.scaleY -= .1;
				_masterGrid.x += _pixelWidth;
				_masterGrid.y += _pixelWidth;
			} else if (kE.keyCode == Keyboard.SPACE) {

				

			} else if (kE.keyCode == Keyboard.SHIFT) {

				if (_ui_Selected && (_ui_Selected is Monster || _ui_Selected is Adventurer)) {
					_ui_Selected.applyStatus(Statuses.burn_5);
				} else {
					centerDungeon();
				}

			} else if (kE.keyCode == Keyboard.UP) {
				//if (_masterGrid.upSide < _pixelWidth * 4) {
				_masterGrid.y += _pixelWidth;
				trace(masterGrid.x, _masterGrid.y);
				//}
			} else if (kE.keyCode == Keyboard.DOWN) {
				//if (_masterGrid.downSide > 750 - _pixelWidth * 2) {
				_masterGrid.y -= _pixelWidth;
				trace(masterGrid.x, _masterGrid.y);
				//}
			} else if (kE.keyCode == Keyboard.LEFT) {
				//if (_masterGrid.leftSide < _pixelWidth * 3) {
				_masterGrid.x += _pixelWidth;
				trace(masterGrid.x, _masterGrid.y);
				//}
			} else if (kE.keyCode == Keyboard.RIGHT) {
				//if (_masterGrid.rightSide > 1134 - _pixelWidth * 3) {
				_masterGrid.x -= _pixelWidth;
				trace(masterGrid.x, _masterGrid.y);
				//}
			} else if (kE.keyCode == Keyboard.CONTROL) {
				if (_dm.isPaused) {
					unpause();
				} else {
					pause();
				}

			} else if (kE.keyCode == Keyboard.Z) {

				trace("\nZ PRESSED");

				fastForward(6);

			} else if (kE.keyCode == Keyboard.M) {

				GlobalSounds.instance.toggleMuted_Music();

			} else if (kE.keyCode == Keyboard.SLASH) {

				_advSpawnTimer += 100000;

			} else if (kE.keyCode == Keyboard.PERIOD) {

				notoriety += _maxNotoriety / 2;

			} else if (kE.keyCode == Keyboard.J) {

				GlobalVariables.instance.timer.delay = 500;

			} else if (kE.keyCode == Keyboard.K) {

				GlobalVariables.instance.timer.delay = 50;

			} else if (kE.keyCode == Keyboard.L) {

				GlobalVariables.instance.timer.delay = 10;


			} else if (kE.keyCode == Keyboard.G) {

				earnGold(1000);

			} else if (kE.keyCode == Keyboard.BACKQUOTE) {

				if (_clickListenerSet) endClickListener();
				else startClickListener();

			} else if (kE.keyCode == Keyboard.COMMA) {

				_masterGrid.killAllAdventurers();

			} else if (kE.keyCode == Keyboard.ENTER) {

				if (_UI.textBox.text.length > 0) {

					var string: String = _UI.textBox.text;
					_UI.textBox.text = "";

					if (string == "RESET ALL") {
						GlobalUnlockTracker.instance.resetSharedObject();
						GlobalSharedObject.instance.resetSharedObject();
						return;
					} else if (string == "GOLD") {
						earnGold(10000000, true);
					}

					var tClass: String = "";
					var tX: String = "";
					var tY: String = "";
					var tString: String = "";
					var tIndex: int = 0;

					if (string.charAt(0) == "~") {
						GlobalSounds.instance.setSound(int(string.substring(1)));
						return;
					}

					if (string.charAt(0) == "#") {
						_notoriety += int(string.substring(1));
						return;
					}

					if (string.charAt(0) == "%") {
						_masterGrid.swapAllGraphics(int(string.substring(1)));
						return;
					}

					if (string.charAt(0) == "&") {

						if (string.charAt(1) == "1") quickSetup(M_Bat);
						else if (string.charAt(1) == "2") quickSetup(M_Skeleton);
						else if (string.charAt(1) == "3") quickSetup(M_Shadow);
						else if (string.charAt(1) == "4") quickSetup(M_SpittingLizard);
						else if (string.charAt(1) == "5") quickSetup(M_Mummy);
						else if (string.charAt(1) == "6") quickSetup(M_RedDragon);
						else if (string.charAt(1) == "&") randomSetup();
						else quickSetup(M_ScaredyCat);

						return;
					}

					for (var i: int = 0; i < string.length; i++) {
						tString = string.charAt(i);
						trace(tString);

						if (tString == " ") {
							tIndex++;

						} else {

							if (tIndex == 0) {
								tClass += tString;
							} else if (tIndex == 1) {
								tX += tString;
							} else if (tIndex == 2) {
								tY += tString;
							}
						}
					}

					if (tX == "") tX = "6";
					if (tY == "") tY = "5";

					trace(tClass, tX, tY);

					var elementClass: Class = getDefinitionByName(tClass) as Class;

					if (tClass.charAt(0) == "S") {
						_masterGrid.addChild(new elementClass(_masterGrid.gridArray[tX][tY]));
					} else {
						_masterGrid.addGameElement(_masterGrid.gridArray[tX][tY], new elementClass(_masterGrid));
					}
				}
			}
		}
		
		
		public function fillAdvProgressBar() : void {
			_advSpawnTimer += 100000;
		}


		public function centerDungeon(): void {
			_wrapperZoom.scaleX = _savedScale;
			_wrapperZoom.scaleY = _savedScale;

			_masterGrid.x = _savedX;
			_masterGrid.y = _savedY;
		}

		public function setupDungeon(layout: Array): void {

			// setup empty dungeon @ width, height
			var currentArray: Array = layout[0];

			// add grid
			_masterGrid = new MasterGrid(_docClass, this, currentArray[0], currentArray[1]);
			var hWidth: int = _masterGrid.width / 2;
			var hHeight: int = _masterGrid.height / 2;

			addChild(_masterGrid);
			_masterGrid.x = -(hWidth) + 567;
			_masterGrid.y = -(hHeight) + 375;


			GlobalVariables.instance.masterGrid = _masterGrid;

			resetNotoriety();

			// floors
			currentArray = layout[1];
			for (var i: int = 0; i < currentArray.length; i += 4) {
				_masterGrid.fillFloors(currentArray[i + 0], currentArray[i + 1], _masterGrid.gridArray[currentArray[i + 2]][currentArray[i + 3]]);
			}
			_masterGrid.addWalls();


			// entrances
			currentArray = layout[2];
			for (var k: int = 0; k < currentArray.length; k += 2) {
				_masterGrid.entrance = _masterGrid.gridArray[currentArray[k + 0]][currentArray[k + 1]];

				// remove from floors
				_masterGrid.floors.splice(_masterGrid.floors.indexOf(tempNode), 1);
			}

			// slot - monster
			currentArray = layout[3];
			for (var q: int = 0; q < currentArray.length; q += 2) {
				var tempNode: GraphicNode = _masterGrid.gridArray[currentArray[q + 0]][currentArray[q + 1]];

				var newSlot: EmptySlot = new EmptySlot(_masterGrid, GlobalVariables.TYPE_MONSTER);
				_masterGrid.addGameElement(_masterGrid.gridArray[currentArray[q + 0]][currentArray[q + 1]], newSlot);
				trace(newSlot);

				// remove from floors
				_masterGrid.floors.splice(_masterGrid.floors.indexOf(tempNode), 1);
			}


			// slot - trap
			currentArray = layout[4];
			for (var r: int = 0; r < currentArray.length; r += 2) {
				var tempNode: GraphicNode = _masterGrid.gridArray[currentArray[r + 0]][currentArray[r + 1]];

				/*var newSlot: EmptySlot = new EmptySlot(_masterGrid, GlobalVariables.TYPE_TRAP);
				_masterGrid.addGameElement(_masterGrid.gridArray[currentArray[r + 0]][currentArray[r + 1]], newSlot);
				trace(newSlot);*/

				_masterGrid.addGameElement(_masterGrid.gridArray[currentArray[r + 0]][currentArray[r + 1]], new T_SpikeTrap(_masterGrid));

				// remove from floors
				_masterGrid.floors.splice(_masterGrid.floors.indexOf(tempNode), 1);
			}



			// slot - door
			currentArray = layout[5];
			for (var s: int = 0; s < currentArray.length; s += 2) {
				var tempNode: GraphicNode = _masterGrid.gridArray[currentArray[s + 0]][currentArray[s + 1]];

				//var newSlot: EmptySlot = new EmptySlot(_masterGrid, GlobalVariables.TYPE_DOOR);

				var checkTop: GraphicNode = _masterGrid.gridArray[currentArray[s + 0]][currentArray[s + 1] - 1];
				//var checkLeft : GraphicNode = _masterGrid.gridArray[currentArray[s + 0]-1][currentArray[s + 1]];
				var newDoor: LockedDoor;

				if (checkTop && (checkTop.graphic is IWall || checkTop.graphic is ICorner)) {
					newDoor = new LockedDoor(_masterGrid, 2);
				} else {
					newDoor = new LockedDoor(_masterGrid, 1);
				}

				_masterGrid.addGameElement(_masterGrid.gridArray[currentArray[s + 0]][currentArray[s + 1]], newDoor);
				//trace(newSlot);

				_masterGrid.floors.splice(_masterGrid.floors.indexOf(tempNode), 1);
			}


			// slot - chest
			currentArray = layout[6];
			for (var t: int = 0; t < currentArray.length; t += 2) {
				var tempNode: GraphicNode = _masterGrid.gridArray[currentArray[t + 0]][currentArray[t + 1]];

				var newSlot: EmptySlot = new EmptySlot(_masterGrid, GlobalVariables.TYPE_CHEST);
				_masterGrid.addGameElement(_masterGrid.gridArray[currentArray[t + 0]][currentArray[t + 1]], newSlot);
				trace(newSlot);

				_masterGrid.floors.splice(_masterGrid.floors.indexOf(tempNode), 1);
			}


			if (layout.length > 7) {
				_masterGrid.scaleX += layout[7];
				_masterGrid.scaleY += layout[7];
			}

			if (layout.length > 8) { // TAKES UP 2 SLOTS ON LAYOUT !!!
				_pixelWidth = _masterGrid._nodeSize
				_masterGrid.x = layout[8] * _pixelWidth;
				_masterGrid.y = layout[9] * _pixelWidth;
			}

			if (layout.length > 10) {

				// decor
				currentArray = layout[10];
				for (var t: int = 0; t < currentArray.length; t += 3) {
					var tempNode: GraphicNode = _masterGrid.gridArray[currentArray[t + 0]][currentArray[t + 1]];

					var newDecor: Floor_Decor_Object = new Floor_Decor_Object();
					newDecor.gotoAndStop(currentArray[t + 2]);
					tempNode.addDecor(newDecor);

					_masterGrid.floors.splice(_masterGrid.floors.indexOf(tempNode), 1);
					//_masterGrid.addGameElement(_masterGrid.gridArray[currentArray[t + 0]][currentArray[t + 1]], newDecor);
				}
			}

			if (layout.length > 11) {

				// wall decor
				currentArray = layout[11];
				for (var t: int = 0; t < currentArray.length; t += 3) {
					var tempNode: GraphicNode = _masterGrid.gridArray[currentArray[t + 0]][currentArray[t + 1]];

					var newWallDecor: Wall_Decor = new Wall_Decor();
					newWallDecor.gotoAndStop(currentArray[t + 2]);
					tempNode.addDecor(newWallDecor);

					//_masterGrid.floors.splice(_masterGrid.floors.indexOf(tempNode),1);
					//_masterGrid.addGameElement(_masterGrid.gridArray[currentArray[t + 0]][currentArray[t + 1]], newDecor);
				}
			}

			if (layout.length > 12) {

				// random items
				currentArray = layout[12];
				for (var t: int = 0; t < currentArray.length; t += 3) {
					var tempNode: GraphicNode = _masterGrid.gridArray[currentArray[t + 0]][currentArray[t + 1]];

					var tempClass: Class = currentArray[t + 2];

					_masterGrid.addGameElement(tempNode, new tempClass(_masterGrid));

					//_masterGrid.floors.splice(_masterGrid.floors.indexOf(tempNode),1);
					//_masterGrid.addGameElement();
				}
			}

			for each(var w: GraphicNode in _masterGrid.walls) {
				if (w.graphic is Wall_Horizontal_MC) {
					if (Math.random() < .2) {
						w.addDecor(new Wall_Decor_CracksAndVines());
					}
				}
			}


			// find it
			// remove unnecessary nodes
			for (var i: int = 0; i < _masterGrid.gridArray.length; i++) {

				for (var j: int = 0; j < _masterGrid.gridArray[i].length; j++) {

					var tempNode: GraphicNode = _masterGrid.gridArray[i][j];

					if (!tempNode.isTraversable && tempNode.graphic is IWall == false && tempNode.graphic is ICorner == false && tempNode.hasDecor == false) {
						_masterGrid.traversableMC.removeChild(tempNode);
						tempNode.destroy();
					}
				}
			}

			// random decor to floor tiles
			_masterGrid.addRandomDecor();

			// add transparent sprite
			_masterGrid.addTransparentSprite();



			//if (layout.length > 12) {

			// new dungeon sprite
			//var tempGraphic = new DungeonSprite01();

			//_masterGrid.addDungeonSprite(tempGraphic);
			//}

			//if (layout.length > 12) {
			//	
			//	//new dungeon sprite----
			//	var dungeonSprite = layout[12];
			//	_masterGrid.addDungeonSprite(dungeonSprite);
			//	_masterGrid.makeWallsAndFloorsInvisible();
			//}



		}






		public function updateUI(): void {

			//_UI.miscDisplayText.text = String(GlobalUnlockTracker.instance.goldEarned);
			//_UI.miscDisplayText2.text = String(GlobalUnlockTracker.instance.fetchData(M_PirateOrc));
			
			//trace("dungeonNameGraphic: " + _UI.dungeonNameGraphic.stage, _UI.getChildIndex(_UI.dungeonNameGraphic), _UI.dungeonNameGraphic.visible);
			//trace("backgroundSprite: " + _UI.dungeonNameGraphic.backgroundSprite.stage, _UI.dungeonNameGraphic.getChildIndex(_UI.dungeonNameGraphic.backgroundSprite), _UI.dungeonNameGraphic.backgroundSprite.visible);

			if (_ui_Selected) {
				if (_ui_Selected.stage) {

					_ui_Selector.x = _ui_Selected.currentNode.x;
					_ui_Selector.y = _ui_Selected.currentNode.y;

					//_ui_UnitInfo.setup(_ui_Selected);
					//_ui_UnitViewer.update(_ui_Selected);
				} else {
					if (_ui_Selector.stage) _masterGrid.removeChild(_ui_Selector);
					_ui_Selected = null;
					//_ui_UnitInfo.reset();
					//_ui_UnitViewer.reset();
				}
			}

			if (_ui_UnitInfo.stage) {

				if (_ui_Selected && _ui_Selected.stage) {
					_ui_UnitInfo.update(_ui_Selected);
				} else {
					_ui_UnitControlPanel.removeChild(_ui_UnitInfo);
					_ui_UnitInfo.reset();
					deselectAll();
				}

			}

			if (_ui_SlotPanel_Set.stage) {
				if (_ui_Selected && _ui_Selected.stage) {
					_ui_SlotPanel_Set.update();
				} else {
					_ui_UnitControlPanel.removeChild(_ui_SlotPanel_Set);
					_ui_SlotPanel_Set.reset();
					deselectAll();
				}
			}

			if (_masterGrid.entrance) _advProgressBar.update(_advSpawnTimer);

			updateNotoriety();
		}

		public function onClick(mE: MouseEvent): void {

			//GlobalSounds.instance.setSound(11);

			mE.stopPropagation();

			var clickTarget = mE.target;

			// change floors to nodes
			if (clickTarget is Floor_Middle_MC) clickTarget = clickTarget.parent as GraphicNode;

			if (clickTarget.parent is IGameUnit) clickTarget = clickTarget.parent;

			if (clickTarget is Anim_Chicken) {
				var targetCol: int = clickTarget.x / _pixelWidth;
				var targetRow: int = clickTarget.y / _pixelWidth;

				trace(targetCol, targetRow);

				clickTarget = _masterGrid.gridArray[targetCol][targetRow].occupier;
			}

			trace("\nCLICK: " + clickTarget);

			trace("CLICK PARENT: " + clickTarget.parent);


			if (clickTarget == _UI.menuBar.dungeonCatalogButton) {
				_dm.isPaused = true;
				addChild(_ui_DungeonCatalogScreen);
				GlobalSounds.instance.click();
				_ui_DungeonCatalogScreen.setup();
				
				
				
			} else if (clickTarget == _UI.menuBar.settingsButton) {
				_savedPauseState = _dm.isPaused;
				_dm.isPaused = true;
				_UI.menuBar.settingsButton.gotoAndStop(2);
				GlobalSounds.instance.click();
				
			} else if (clickTarget == _UI.menuBar.settingsButton.returnSprite) {
				_dm.isPaused = _savedPauseState;
				_UI.menuBar.settingsButton.gotoAndStop(1);
				GlobalSounds.instance.click();
				
			} else if (_UI.menuBar.settingsButton.optionsScreen && clickTarget == _UI.menuBar.settingsButton.optionsScreen.musicSwitch) {
				GlobalSounds.instance.click();
				if (clickTarget.currentFrame == 1) {
					clickTarget.gotoAndStop(2);
					GlobalSounds.instance.setMuted_Music(true);
					GlobalSharedObject.instance.isMutedMusic = true;
					
				} else {
					clickTarget.gotoAndStop(1);
					GlobalSounds.instance.setMuted_Music(false);
					GlobalSharedObject.instance.isMutedMusic = false;
				}
				
				
			} else if (_UI.menuBar.settingsButton.optionsScreen && clickTarget == _UI.menuBar.settingsButton.optionsScreen.sfxSwitch) {
				GlobalSounds.instance.click();
				if (clickTarget.currentFrame == 1) {
					clickTarget.gotoAndStop(2);
					GlobalSounds.instance.setMuted_SFX(true);
					GlobalSharedObject.instance.isMutedSFX = true;
				} else {
					clickTarget.gotoAndStop(1);
					GlobalSounds.instance.setMuted_SFX(false);
					GlobalSharedObject.instance.isMutedSFX = false;
				}
				
				
			} else if (clickTarget is BTN_CenterDungeon) {
				centerDungeon();

			} else if (clickTarget is UI_AdvProgressBar) {

				_advSpawnTimer = _advTicksPerSpawn - 2;

			} else if (clickTarget is UI_VisibilityButton) {

				toggleVisiblityOfUI();

			} else if (clickTarget is UI_ZoomPanel_ZoomOut) {
				_masterGrid.scaleX -= .1;
				_masterGrid.scaleY -= .1;
				_masterGrid.x += _pixelWidth;
				_masterGrid.y += _pixelWidth;

			} else if (clickTarget == _UI.playPause && _UI.playPause.currentFrame == 1) {

				_dm.isPaused = false;
				_UI.playPause.gotoAndStop(2);
				GlobalSounds.instance.click();

			} else if (clickTarget == _UI.playPause && _UI.playPause.currentFrame == 2) {

				_dm.isPaused = true;
				_UI.playPause.gotoAndStop(1);
				GlobalSounds.instance.click();



				// GRAPHIC NODE
			} else if (clickTarget is IGameUnit || (clickTarget is SpawnPoint && clickTarget.currentNode.isEntrance == false) || clickTarget is ISlot) {

				setSelected(clickTarget);

				trace("ClickTarget: " + clickTarget);


				// check / cast spell first

				//trace("_UI.spellBar.spellSelected: " + _UI.spellBar.spellSelected);

				/*if (_UI.spellBar.spellSelected) {

					_masterGrid.addChild(new _UI.spellBar.spellSelected.spellClass(clickTarget.currentNode));

					_UI.spellBar.spellSelected.addSpellTimer();

					_UI.spellBar.deselectAll();
					return;
				}*/


				// unit info
				if (clickTarget is IAdventurer || clickTarget is IMonster) {
					addUnitInfo();
				}

				// add SlotPanel_Set

				if (clickTarget is SpawnPoint || clickTarget is ITrap || clickTarget is IDoor || clickTarget is IChest) {
					addSlotPanel_Set();
				}

				if (clickTarget is ISlot) {

					trace("\n	9	9	9	9	9	9	9	9	9 ADDING MONSTER BUY SCREEN - ui_selected: " + _ui_Selected);
					addMonsterBuyScreen();
				}

			} else if (clickTarget is GraphicNode) {
				trace(clickTarget.getStats());

				// for building dungeons, click listener
				if (_clickListenerSet) {
					_clickListenerArray.push(String(clickTarget.col + ", " + clickTarget.row));
				}


				/*if (_UI.spellBar.spellSelected) {

					_masterGrid.addChild(new _UI.spellBar.spellSelected.spellClass(clickTarget));

					_UI.spellBar.spellSelected.addSpellTimer();

					_UI.spellBar.deselectAll();
				}*/

				deselectAll();

				//trace(_masterGrid.getAdjacentNodes(clickTarget, false, false));
				//trace(_masterGrid.getUp(clickTarget), _masterGrid.getDown(clickTarget), _masterGrid.getLeft(clickTarget), _masterGrid.getRight(clickTarget));


				// if out of bounds return
				/*if (_masterGrid.checkInBounds(clickTarget.col - 2, clickTarget.row - 2) == false || _masterGrid.checkInBounds(clickTarget.col + 2, clickTarget.row + 2) == false) {
					trace("out of bounds");
					return;
				}*/


			} else {
				deselectAll();
			}

		}

		//public function calculateResidualGold(): void {
		//	//trace("Starting residual gold: " + _residualGold);

		//	_residualGold = 0;
		//	var divisor: int = GlobalVariables.RESIDUAL_GOLD_DIVISOR;

		//	for each(var m: IPurchasable in _masterGrid.monsters) {
		//		_residualGold += m.goldCost / divisor;
		//	}

		//	for each(var t: IPurchasable in _masterGrid.traps) {
		//		_residualGold += t.goldCost / divisor;
		//	}

		//	for each(var d: IPurchasable in _masterGrid.doors) {
		//		_residualGold += d.goldCost / divisor;
		//	}

		//	for each(var c: IPurchasable in _masterGrid.chests) {
		//		_residualGold += c.goldCost / divisor;
		//	}

		//	_UI.residualGoldDisplay.residualGold = _residualGold;

		//	if (_UI.residualGoldDisplay.residualGold == 0) {
		//		_UI.residualGoldDisplay.visible = false;
		//	} else {
		//		_UI.residualGoldDisplay.visible = true;
		//	}

		//	//trace("Ending residual gold: " + _residualGold);
		//}

		public function get residualGold(): int {
			return _residualGold;
		}

		public function fastForward(numHours): void {
			var goldGained: int = 0;
			//calculateResidualGold();
			var timerDelay: int = GlobalVariables.instance.timer.delay;
			var ticksPerSecond: int = 1000 / timerDelay;
			var ticksPerHour: int = ticksPerSecond * 60 * 60 / _dm.residualGoldTimerMax;

			goldGained = _residualGold * ticksPerHour * numHours;

			trace("\nFAST FORWARDING " + numHours + " HOURS");
			trace("ADDING GOLD: " + goldGained);

			_goldDisplay.gold += goldGained;
		}

		public function resetPanels(): void {

			//if (_ui_SlotPanel_Empty.stage) {
			//	_ui_UnitControlPanel.removeChild(_ui_SlotPanel_Empty);
			//	_ui_SlotPanel_Empty.reset();
			//}

			if (_ui_SlotPanel_Buy.stage) {
				_ui_UnitControlPanel.removeChild(_ui_SlotPanel_Buy);
				_ui_SlotPanel_Buy.reset();
			}

			if (_ui_SlotPanel_Set.stage) {
				_ui_UnitControlPanel.removeChild(_ui_SlotPanel_Set);
				_ui_SlotPanel_Set.reset();
			}

			if (_ui_UnitInfo.stage) {
				_ui_UnitControlPanel.removeChild(_ui_UnitInfo);
				_ui_UnitInfo.reset();
			}
		}

		public function addMonsterBuyScreen(): void {
			_docClass.addMonsterBuyScreen();
			_dm.isPaused = true;
		}


		//public function addSlotPanel_Empty(): void {
		//	resetPanels();
		//	trace("adding _ui_SlotPanel_Empty");
		//	var slotType: String = _ui_Selected.slotType;
		//	_ui_UnitControlPanel.addChild(_ui_SlotPanel_Empty);
		//	_ui_SlotPanel_Empty.setup(slotType);

		//	setChildIndex(_ui_UnitControlPanel, numChildren - 1); // find it
		//}

		public function addSlotPanel_Buy(): void {
			resetPanels();
			trace("adding addSlotPanel_Buy");
			var slotType: String = _ui_Selected.slotType;
			_ui_UnitControlPanel.addChild(_ui_SlotPanel_Buy);
			_ui_SlotPanel_Buy.setup(slotType);

		}

		public function addSlotPanel_Set(): void {
			resetPanels();
			trace("adding _ui_SlotPanel_Set");
			_ui_UnitControlPanel.addChild(_ui_SlotPanel_Set);
			_ui_SlotPanel_Set.setup(_ui_Selected);
		}

		public function addUnitInfo(): void {
			resetPanels();
			trace("adding _ui_UnitInfo");
			_ui_UnitControlPanel.addChild(_ui_UnitInfo);
			_ui_UnitInfo.update(_ui_Selected);
		}


		public function quickSetup(monsterClass: Class = null): void {
			for (var i: int = _masterGrid.monsterSlots.length - 1; i >= 0; i--) {
				var mSlot: EmptySlot = _masterGrid.monsterSlots[i];
				trace(mSlot, mSlot.currentNode);
				var node: GraphicNode = mSlot.currentNode;
				_masterGrid.removeGameElement(mSlot);
				_masterGrid.addGameElement(node, new SpawnPoint(monsterClass, _masterGrid));
			}
			for (var i: int = _masterGrid.trapSlots.length - 1; i >= 0; i--) {
				var tSlot: EmptySlot = _masterGrid.trapSlots[i];
				trace(tSlot, tSlot.currentNode);
				var node: GraphicNode = tSlot.currentNode;
				_masterGrid.removeGameElement(tSlot);
				_masterGrid.addGameElement(node, new T_SpikeTrap(_masterGrid));
			}
			for (var i: int = _masterGrid.doorSlots.length - 1; i >= 0; i--) {
				var dSlot: EmptySlot = _masterGrid.doorSlots[i];
				trace(dSlot, dSlot.currentNode);
				var node: GraphicNode = dSlot.currentNode;
				_masterGrid.removeGameElement(dSlot);
				_masterGrid.addGameElement(node, new LockedDoor(_masterGrid));
			}
		}

		public function randomSetup(): void {
			var monsterClasses: Array = GlobalVariables.purchasableMonsters;
			//var trapClasses: Array = GlobalVariables.purchasableTraps;
			//var doorClasses: Array = GlobalVariables.purchasableDoors;

			for (var i: int = _masterGrid.monsterSlots.length - 1; i >= 0; i--) {
				var mSlot: EmptySlot = _masterGrid.monsterSlots[i];
				trace(mSlot, mSlot.currentNode);
				var node: GraphicNode = mSlot.currentNode;
				_masterGrid.removeGameElement(mSlot);
				var monsterClass: Class = monsterClasses[int(Math.random() * monsterClasses.length)];
				_masterGrid.addGameElement(node, new SpawnPoint(monsterClass, _masterGrid));
			}
			/*for (var i: int = _masterGrid.trapSlots.length - 1; i >= 0; i--) {
				var tSlot: EmptySlot = _masterGrid.trapSlots[i];
				trace(tSlot, tSlot.currentNode);
				var node: GraphicNode = tSlot.currentNode;
				_masterGrid.removeGameElement(tSlot);
				var trapClass: Class = trapClasses[int(Math.random() * trapClasses.length)];
				_masterGrid.addGameElement(node, new trapClass(_masterGrid));
			}
			for (var i: int = _masterGrid.doorSlots.length - 1; i >= 0; i--) {
				var dSlot: EmptySlot = _masterGrid.doorSlots[i];
				trace(dSlot, dSlot.currentNode);
				var node: GraphicNode = dSlot.currentNode;
				_masterGrid.removeGameElement(dSlot);
				var doorClass: Class = doorClasses[int(Math.random() * doorClasses.length)];
				_masterGrid.addGameElement(node, new doorClass(_masterGrid));
			}
			for (var i: int = _masterGrid.chestSlots.length - 1; i >= 0; i--) {
				var cSlot: EmptySlot = _masterGrid.chestSlots[i];
				trace(cSlot, cSlot.currentNode);
				var node: GraphicNode = cSlot.currentNode;
				_masterGrid.removeGameElement(cSlot);
				_masterGrid.addGameElement(node, new Chest(_masterGrid));
			}*/
		}

		//public function purchaseItem(libItem: LibraryItem): void {

		//	trace("\nAttempting Purchase - " + libItem.unit);
		//	if (_goldDisplay.gold < libItem.unit.goldCost) return;
		//	var node: GraphicNode = _ui_Selected.currentNode;
		//	_masterGrid.removeGameElement(_ui_Selected);

		//	if (_ui_Selected.slotType == GlobalVariables.TYPE_MONSTER) {
		//		_masterGrid.addGameElement(node, new SpawnPoint(libItem.unitClass, _masterGrid));
		//	} else if (_ui_Selected.slotType == GlobalVariables.TYPE_TRAP) {
		//		_masterGrid.addGameElement(node, new libItem.unitClass(_masterGrid));
		//	} else if (_ui_Selected.slotType == GlobalVariables.TYPE_DOOR) {
		//		_masterGrid.addGameElement(node, new libItem.unitClass(_masterGrid));
		//	} else if (_ui_Selected.slotType == GlobalVariables.TYPE_CHEST) {
		//		_masterGrid.addGameElement(node, new libItem.unitClass(_masterGrid));
		//	}

		//	node.structure = node.occupier;

		//	_goldDisplay.gold -= libItem.unit.goldCost;
		//	_ui_UnitControlPanel.removeChild(_ui_SlotPanel_Buy);

		//	// reset panels & reselect empty slot
		//	resetPanels();
		//	deselectAll();

		//	setSelected(node.occupier);

		//	// add buy panel 
		//	addSlotPanel_Set();
		//}

		public function getClass(obj: Object): Class {
			return Class(getDefinitionByName(getQualifiedClassName(obj)));
		}

		public function saveData(): void {

			var serializedSpawnPoints: Array = _masterGrid.serializeSpawnPoints();

			/*trace("\n\nCALL TO SAVE DATA FROM GAMEPLAY SCREEN");
			trace("_goldDisplay.gold: " + _goldDisplay.gold);
			trace("_totalNotoriety: " + _totalNotoriety);
			trace("remainingNotoriety: " + _notoriety);
			trace("_notorietyLevel: " + _notorietyLevel);
			trace("currentDungeon: " + currentDungeon);
			trace("serializedSpawnPoints: " + serializedSpawnPoints);*/

			GlobalSharedObject.instance.saveData(_goldDisplay.gold, _totalNotoriety, _notoriety, _notorietyLevel, currentDungeon, serializedSpawnPoints);
		}

		public function purchaseMonster(monster: Monster, costWithCredit: int = -1): void {

			trace("\nAttempting Purchase - " + monster);

			if (costWithCredit >= 0) {
				if (_goldDisplay.gold < costWithCredit) return;
				_goldDisplay.gold -= costWithCredit;

			} else {
				if (_goldDisplay.gold < monster.goldCost) return;
				_goldDisplay.gold -= monster.goldCost;
			}

			_docClass.removeMonsterBuyScreen();
			var node: GraphicNode = _ui_Selected.currentNode;
			_masterGrid.removeGameElement(_ui_Selected);

			_UI.playPause.gotoAndStop(2);

			//if (_ui_Selected.slotType == GlobalVariables.TYPE_MONSTER) {
			_masterGrid.addGameElement(node, new SpawnPoint(getClass(monster), _masterGrid));
			//}

			node.structure = node.occupier;

			saveData();
			GlobalUnlockTracker.instance.registerGoldSpent(monster.goldCost);

			// reset panels & reselect empty slot
			resetPanels();
			deselectAll();

			setSelected(node.occupier);

			// add set panel 
			addSlotPanel_Set();
		}

		public function toMonsterBuyScreen(selected: * ): void {
			_docClass.addMonsterBuyScreen(selected);
		}

		public function sellItem(selected: * ): void {

			// add sell gold
			//trace("Adding gold: " + String(int(_ui_SlotPanel_Set.goldCostText.text) / 10));
			//_goldDisplay.gold += int(_ui_SlotPanel_Set.goldCostText.text) / 10;

			// remove spawn point
			var node: GraphicNode = _ui_Selected.currentNode;
			_masterGrid.removeGameElement(_ui_Selected);

			// add empty slot
			var slotType: String;
			if (_ui_Selected is SpawnPoint) {
				slotType = GlobalVariables.TYPE_MONSTER;
			} else if (_ui_Selected is ITrap) {
				slotType = GlobalVariables.TYPE_TRAP;
			} else if (_ui_Selected is IDoor) {
				slotType = GlobalVariables.TYPE_DOOR;
			} else if (_ui_Selected is IChest) {
				slotType = GlobalVariables.TYPE_CHEST;
			}

			_masterGrid.addGameElement(node, new EmptySlot(_masterGrid, slotType));

			node.structure = null;

			// reset panels & reselect empty slot
			resetPanels();
			deselectAll();

			//setSelected(node.occupier);

			// add buy panel 
			//addSlotPanel_Buy();


		}



		public function calculateNotoriety(): int {

			// disable notoriety if no chests
			/*if (_masterGrid.checkForChestsRemaining() == false) {
				return 0;
			}*/

			var mNot: Number = 0;
			var cNot: Number = 0;
			var aNot: Number = 0;
			var totalNot: Number = 0;

			_tempArray = masterGrid.monsters;

			for (var i: int = 0; i < _tempArray.length; i++) {
				//trace(_tempArray[i], _tempArray[i].notoriety);
				mNot += _tempArray[i].notoriety;
			}

			trace("MONSTER NOT: " + mNot);


			_tempArray = masterGrid.chests;

			//trace("CHESTS: " + masterGrid.chests);

			for (var j: int = 0; j < _tempArray.length; j++) {
				//trace(_tempArray[j], _tempArray[j].gold);
				cNot += _tempArray[j].gold;
			}

			trace("Gold in chests: " + cNot);
			cNot /= 20;
			trace("CHEST NOT: " + cNot);


			_tempArray = masterGrid.adventurers;

			for (var k: int = 0; k < _tempArray.length; k++) {
				aNot += _tempArray[k].notoriety;
			}

			trace("ADVENTURER NOT: " + aNot);

			totalNot = mNot + cNot - aNot;

			trace("TOTAL NOT: " + totalNot);

			if (totalNot < 0) {
				totalNot = 0;
			}

			totalNotoriety = totalNot;
			trace("setting totalNotoriety: " + totalNotoriety);

			trace("													Total Dungeon Notoriety: " + totalNot);
			trace("													Notoriety Till Next Level: " + (_maxNotoriety - totalNot));

			var maxNotoriety: int = _maxNotoriety; // find it weird 1

			totalNot /= maxNotoriety;

			totalNot *= 100;

			trace("													percent of bar filled: " + totalNot + "%");

			_tempArray = [];

			return totalNot;
		}


		public function calculateChestNotoriety(): int {
			var additionalNotoriety: int;
			for each(var c: Chest in _masterGrid.chests) {
				additionalNotoriety += 25 * int(c.gold / 1000);
			}
			return additionalNotoriety;
		}


		public function updateNotoriety(): void {

			//trace("\n----------------");
			//trace("Current Notoriety: " + _notoriety);
			//trace("Max Notoriety: " + _maxNotoriety);
			//trace("Total Notoriety: " + totalNotoriety);
			//trace("----------------\n");

			// find it change 2
			//_notoriety += calculateNotoriety();
			// calculateNotoriety();

			// increment notoriety to keep bar moving
			//_notoriety *= 1.01;

			if (_notoriety >= _maxNotoriety) {

				// find it next 1
				// level up adv party
				levelUpNotoriety();

				GlobalVariables.instance.dungeonAlertPanel.newAlert_NotorietyIncrease(_notorietyLevel);
				
				GlobalSounds.instance.setSound(63);

			} else {
				_ui_NotorietyBar.update(_notoriety / _maxNotoriety);
			}


			//// dont update spawn timers while adv are in queue or in dungeon
			//if ((_masterGrid.entrance && _masterGrid.entrance.spawnPoint.unitsToSpawn.length > 0) || (_masterGrid.adventurers.length > 0)) return;


			//// NEW - increment spawn timer, calc & add new party, reset

			//trace("advSpawnTimer: " + _advSpawnTimer);
			//trace("advTicksPerSpawn: " + _advTicksPerSpawn);

			if (_masterGrid.advCount == 0) _advSpawnTimer++;
			if (_advSpawnTimer >= _advTicksPerSpawn) {
				//trace("\nADV TIMER COMPLETE - ADD TEAM W/ STRENGTH " + _advTeamStrength + " + " + calculateChestNotoriety() + " bonus from chests.");
				_advSpawnTimer = 0;

				if (_masterGrid.entrance) {

					// find it change 3
					//_masterGrid.entrance.spawnPoint.addToQueue(GlobalVariables.advLevelData.calculateAdvTeam(totalNotoriety));
					_masterGrid.entrance.spawnPoint.addToQueue(GlobalVariables.advLevelData.calculateAdvTeam(_advTeamStrength)); // independant of dungeon strength
					//_masterGrid.entrance.spawnPoint.addToQueue(new Array(GlobalVariables.advClasses[int(Math.random() * GlobalVariables.advClasses.length)]));
					//_masterGrid.entrance.spawnPoint.addToQueue(new Array(new A_FireWizard(_masterGrid)));
				}
				//_ui_NotorietyBar.update(100);
				//_notoriety = 0;
			}
		}

		public function addOneAdventurer(): void {
			_oneAdvArray = [];
			var newAdventurer: Adventurer = GlobalVariables.advLevelData.calculateSingleAdventurer(_notorietyLevel);
			_oneAdvArray.push(newAdventurer);
			_masterGrid.entrance.spawnPoint.addToQueue(_oneAdvArray);
			_oneAdvArray = [];
		}

		public function resetNotoriety(): void {
			_notoriety = 0;
			_notorietyLevel = 1;
			_totalNotoriety = 0;
			_maxNotoriety = 200;
			_advTeamStrength = 25;
			_advSpawnTimer = 0;

			GlobalSharedObject.instance.remainingNotoriety = 0;
		}

		public function levelUpNotoriety(): void {
			trace("\nLevel Up Notoriety");

			trace("PRE: _notorietyLevel: " + _notorietyLevel);
			trace("PRE: _maxNotoriety: " + _maxNotoriety);
			trace("PRE: _notoriety: " + _notoriety);
			trace("PRE: _advTeamStrength: " + _advTeamStrength);

			var remainingNotoriety: Number = _notoriety - _maxNotoriety;

			_notorietyLevel++;
			_maxNotoriety *= 1.25;
			_notoriety = remainingNotoriety;
			_advTeamStrength += 25;
			trace("_notorietyLevel: " + _notorietyLevel);
			trace("_maxNotoriety: " + _maxNotoriety);
			trace("_notoriety: " + _notoriety);
			trace("_advTeamStrength: " + _advTeamStrength);

			saveData();
			GlobalUnlockTracker.instance.registerNotorietyIncrease();

			_ui_NotorietyBar.notorietyLevelText.text = String(_notorietyLevel);
			_ui_NotorietyBar.update(_notoriety / _maxNotoriety);
		}


		public function levelUpNotorietyMultiple(numLevels: int): void {
			trace("\nLevel Up Notoriety Multiple: " + numLevels);

			if (numLevels == 0) return;

			trace("PRE: _notorietyLevel: " + _notorietyLevel);
			trace("PRE: _maxNotoriety: " + _maxNotoriety);
			trace("PRE: _notoriety: " + _notoriety);
			trace("PRE: _advTeamStrength: " + _advTeamStrength);

			_notorietyLevel += numLevels;
			_maxNotoriety *= (1.25 * numLevels);
			_advTeamStrength += (25 * numLevels);

			trace("_notorietyLevel: " + _notorietyLevel);
			trace("_maxNotoriety: " + _maxNotoriety);
			trace("_notoriety: " + _notoriety);
			trace("_advTeamStrength: " + _advTeamStrength);

			saveData();
			//GlobalUnlockTracker.instance.registerNotorietyIncrease();

			_ui_NotorietyBar.notorietyLevelText.text = String(_notorietyLevel);
			_ui_NotorietyBar.update(_notoriety / _maxNotoriety);
		}

		public function get notoriety(): int {
			return _notoriety;
		}

		public function get notorietyLevel(): int {
			return _notorietyLevel;
		}

		public function get currentDungeon(): Dungeon {
			return _currentDungeon;
		}

		public function get currentDungeonName(): String {
			return _currentDungeonName;
		}

		public function set currentDungeonName(value: String): void {
			_currentDungeonName = value;
		}

		public function set notoriety(value: int): void {

			if (value < 0) value = 0;

			_notoriety = value;
		}

		public function calculateUnitStrength(): void {

			//for (var i :int = 0; i < 
		}

		public function get advSpawnTimer(): int {
			return _advSpawnTimer;
		}

		public function setSelected(target: DisplayObject): void {

			_ui_Selected = target;
			_masterGrid.addChild(_ui_Selector);
			_ui_Selector.x = _ui_Selected.currentNode.x;
			_ui_Selector.y = _ui_Selected.currentNode.y;

			trace("Setting UI Selected: " + _ui_Selected);

			//_ui_UnitInfo.setup(_ui_Selected);
			//_ui_UnitViewer.update(_ui_Selected);
		}

		public function deselectAll(): void {
			_ui_Selected = null;

			if (_ui_Selector.stage) _masterGrid.removeChild(_ui_Selector);

			resetPanels();

			//_ui_UnitInfo.setup(_ui_Selected);
			//_ui_UnitViewer.update(_ui_Selected);
		}


		public function get gold(): int {
			return _goldDisplay.gold;
		}


		public function buyGameElement(node: GraphicNode, element: * ): void {

			trace("\nStart Buy Game Element");
			trace("Node: " + node + ", Element: " + element + "(" + element.cost + ")");

			if (node.isOccupied) {
				trace(" - Node occupied, unit purchase unsuccessful");
				return;
			} else if (_goldDisplay.gold < element.cost) {
				trace(" - Insufficient funds, unit purchase unsuccessful");
				return;
			}

			// add
			var newUnit;
			if (element.myClass == SpawnPoint) {
				if (element.unitClass == null) return;
				newUnit = new element.myClass(element.unitClass.myClass, _masterGrid);
			} else {
				newUnit = new element.myClass(_masterGrid);
			}
			_masterGrid.addGameElement(node, newUnit);


			// purchase
			_goldDisplay.gold -= element.cost;

		}

		public function get masterGrid(): MasterGrid {
			return _masterGrid;
		}
		public function get dm(): DungeonMaster {
			return _dm;
		}

		//public function get goldDisplay(): GoldDisplay {
		//	return _goldDisplay;
		//}

		public function destroy(): void {
			_docClass = null;
		}
	}

}
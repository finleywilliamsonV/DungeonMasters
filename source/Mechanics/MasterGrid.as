package {

	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;

	public class MasterGrid extends MovieClip implements IGrid {

		private var _docClass: DocClass;
		private var _gameplayScreen: GameplayScreen;

		private var _gameElements: Array;
		private var _updatableElements: Array;

		private var _monsters: Array = [];
		private var _adventurers: Array = [];
		private var _traps: Array = [];
		private var _doors: Array = [];
		private var _chests: Array = [];
		private var _spawnPoints: Array = [];


		// raycast
		public static const SHOW_LINES: Boolean = false;
		public static const WALL_INDEX: int = 1;
		public static const FLOOR_INDEX: int = 1;


		private var _areChestsRemaining: Boolean;

		private var _monsterSlots: Array = [];
		private var _trapSlots: Array = [];
		private var _doorSlots: Array = [];
		private var _chestSlots: Array = [];

		private var _activeChests: Array = [];

		private var _monsterCount: int;
		private var _advCount: int;

		private var _gridArray: Array;
		private var _columns: int;
		private var _rows: int;

		private var _floors: Array;
		private var _walls: Array;
		private var _corners: Array;

		public var obstacleMC: MovieClip;
		public var traversableMC: MovieClip;
		public var dungeonSpriteMC: MovieClip;

		private var _raycastArray: Array = [];
		private var _hitLine: Shape = new Shape();

		public var _nodeSize: int = 32;

		private var _entrances: Array = [];

		private var _backgroundSprite: Sprite;
		private var _decorSprite: Sprite;

		public function MasterGrid(doc: DocClass, gs: GameplayScreen, col: int, row: int): void {
			_docClass = doc;
			_gameplayScreen = gs;
			_columns = col;
			_rows = row;

			_floors = [];
			_walls = [];
			_corners = [];

			obstacleMC = new MovieClip();
			traversableMC = new MovieClip();
			dungeonSpriteMC = new MovieClip();

			_areChestsRemaining = false;
			_gameElements = [];
			_updatableElements = [];

			_monsterCount = 0;
			_advCount = 0;

			trace("New Dungeon");
			trace("- rows: " + _rows);
			trace("- columns: " + _columns);

			_gridArray = [];

			//scaleX = 1.25;
			//scaleY = 1.25;

			populateGrid();

			addChild(dungeonSpriteMC);
			addChild(traversableMC);
			addChild(obstacleMC);
		}

		/*public function makeWallsAndFloorsInvisible() : void {
			for each (var obstacle : * in obstacleMC) {
				trace(obstacle);
				if (obstacle is IWall) obstacle.visible = false;
			}
		}*/

		public function checkForChestsRemaining(): Boolean {

			_areChestsRemaining = false;

			for (var i: int = 0; i < _chests.length; i++) {
				if (_chests[i].gold > 0) {
					_areChestsRemaining = true;
					return true;
				}
			}

			return _areChestsRemaining;
		}

		public function serializeSpawnPoints(): Array {

			//trace("\n\nSTARTING SERIALIZE SPAWN POINTS");
			//trace("_spawnPoints: " + _spawnPoints);

			var returnArray: Array = [];

			for each(var s: SpawnPoint in _spawnPoints) {
				//trace("s: " + s);
				//trace("s.unit: " + s.unit);

				if (GlobalVariables.purchasableMonsters.indexOf(s.unit) > -1) {
					//trace("Adding Monster to return array: " + s);
					returnArray.push(s.currentNode.col, s.currentNode.row, getQualifiedClassName(s.unit) as String);
					trace(returnArray);
				}
			}

			return returnArray;
		}
		
		public function transfer() : void {
			trace("TRANSFER");
			deserializeSpawnPoints();
		}
		

		public function deserializeSpawnPoints(): void {
			
			var serializedArray: Array = GlobalSharedObject.instance.serializedSpawnPoints as Array;
			
			trace("\n\nSTARTING DESERIALIZE SPAWN POINTS");
			trace("serializedArray: " + serializedArray);

			if (serializedArray.length == 0) return;

			var mCol: int;
			var mRow: int;
			var mClassString: String;

			for (var i: int = 0; i < serializedArray.length; i += 3) {
				mCol = serializedArray[i];
				mRow = serializedArray[i + 1];
				mClassString = serializedArray[i + 2];

				trace(mCol, mRow, mClassString);

				// get current node
				// remove emptySlot
				// addGameElement(node, new SpawnPoint(getClass(monster), _masterGrid));
				// node.structure = node.occupier;
				
				var spawnPointNode: GraphicNode = _gridArray[mCol][mRow];
				trace("spawnPointNode: " + spawnPointNode);
				trace("spawnPointNode.occupier: " + spawnPointNode.occupier);
				
				removeGameElement(spawnPointNode.occupier);
				
				var mClass : Class = getDefinitionByName(mClassString) as Class;
				trace(mClass);
				addGameElement(spawnPointNode, new SpawnPoint(_gameplayScreen.getClass(mClass), this));
				spawnPointNode.structure = spawnPointNode.occupier;

			}


		}

		public function testRaycast(nodeA: * , nodeB: * ): Boolean {

			//return true;

			var buffer: int = _nodeSize / 2;

			//_hitLine.graphics.clear();

			_hitLine = new Shape();

			var doSwitch: Boolean = false;

			if (nodeB.occupier is IDoor && nodeB.occupier.isOpen == false) {

				obstacleMC.removeChild(nodeB.occupier);
				traversableMC.addChild(nodeB.occupier);
				doSwitch = true;
			}

			var randomColor = 0xFFFFFF * Math.random();
			var xA: int = nodeA.x;
			var yA: int = nodeA.y;
			var xB: int = nodeB.x;
			var yB: int = nodeB.y;
			_hitLine.graphics.beginFill(randomColor);
			_hitLine.graphics.moveTo(xA + buffer, yA + buffer - 1);
			_hitLine.graphics.lineTo(xB + buffer, yB + buffer + 1);
			_hitLine.graphics.lineTo(xA + buffer + 1, yA + buffer);

			_raycastArray.push(_hitLine);

			traversableMC.addChild(_hitLine);

			if (_raycastArray.length > 5000000) {
				traversableMC.removeChild(_raycastArray.shift());
			}

			//var result: Boolean = _hitLine.hitTestObject(obstacleMC);


			var result = PixelPerfectCollisionDetection.isColliding(_hitLine, obstacleMC, this, true, 0);



			if (SHOW_LINES) {

				var myColorTransform = new ColorTransform();

				if (result) {
					myColorTransform.color = 0x9C3232;
				} else {
					myColorTransform.color = 0x409C42;
				}

				_hitLine.transform.colorTransform = myColorTransform;
			} else {
				traversableMC.removeChild(_hitLine);
			}

			if (doSwitch) {
				traversableMC.removeChild(nodeB.occupier);
				obstacleMC.addChild(nodeB.occupier);
			}

			/*
			trace("\n *** RAYCAST ***");
			trace("Start: " + nodeA);
			trace("Finish: " + nodeB);
			trace("Hits Obstacle? - " + result);
			*/

			return result;
		}

		// populate grid
		public function populateGrid(): void {

			var tempNode: GraphicNode;

			for (var c: int = 0; c < _columns; c++) {

				_gridArray[c] = [];

				for (var r: int = 0; r < _rows; r++) {

					tempNode = new GraphicNode(c, r, this, _nodeSize);
					_gridArray[c][r] = tempNode;

					traversableMC.addChild(tempNode);
					tempNode.x = _nodeSize * c;
					tempNode.y = _nodeSize * r;

					tempNode.showGrid();

					if (checkInBounds(c - 2, r - 2) && checkInBounds(c + 2, r + 2)) {
						tempNode.hideGrid();
					} else {
						tempNode.gotoAndStop(3);
					}


					// find it!



				}
			}
		}

		public function killAllAdventurers(): void {
			for each(var adv: Adventurer in _adventurers) {
				if (adv.stage) adv.modHealth(-100000000);
			}
		}

		public function addTransparentSprite(): void {

			if (_backgroundSprite) return;

			_backgroundSprite = new Sprite();
			_backgroundSprite.graphics.beginFill(0x000000, 0);
			_backgroundSprite.graphics.drawRect(0, 0, width, height);
			traversableMC.addChild(_backgroundSprite);
			traversableMC.setChildIndex(_backgroundSprite, 0);
		}

		public function addDungeonSprite(ds: Sprite): void {
			dungeonSpriteMC.addChild(ds);
			ds.x += 64;
			ds.y += 64;
			//setChildIndex(ds, numChildren-1);
		}


		public function get floors(): Array {
			return _floors;
		}

		public function get walls(): Array {
			return _walls;
		}

		public function get activeChests(): Array {
			_activeChests = [];
			for each(var chest: Chest in _chests) {
				if (!chest.isEmpty) {
					_activeChests.push(chest);
				}
			}
			return _activeChests;
		}

		// ADD/REMOVE UNIT METHODS

		public function addGameElement(node: GraphicNode, element: * ): void {

			//trace("\nADD GAME ELEMENT " + node, element);
			if (element is IUpdatable) {
				_updatableElements.push(element);
				_updatableElements.sortOn('dexterity', Array.NUMERIC);
				//_updatableElements.reverse();

				if (element is IAdventurer) {
					_advCount++;
					//trace("ADDING ADV: " + _advCount);
					_adventurers.push(element);

					// play adv enter sound
					GlobalSounds.instance.enterDungeon_ADV(element);
					
					// signal new dungeon alert
					GlobalVariables.instance.dungeonAlertPanel.newAlert_AdventurerEnterDungeon(element.nameString);

				} else if (element is IMonster) {
					_monsterCount++;
					//trace("ADDING MONSTER: " + _monsterCount);
					_monsters.push(element);

					// play monster enter sound
					if (element.soundIndex > -1) {
						GlobalSounds.instance.setSound(element.soundIndex);
					} else {
						GlobalSounds.instance.enterDungeon();
					}
					
					// signal new dungeon alert
					GlobalVariables.instance.dungeonAlertPanel.newAlert_MonsterSpawned(element.nameString);
					
				} else if (element is SpawnPoint) {
					//trace("ADDING SpawnPoint");
					_spawnPoints.push(element);
				}

			} else if (element is ITrap) {
				//trace("ADDING TRAP");
				_traps.push(element);

			} else if (element is IDoor) {
				//trace("ADDING DOOR");
				_doors.push(element);

			} else if (element is IChest) {
				//trace("ADDING CHEST");
				_chests.push(element);

			} else if (element is EmptySlot) {

				//trace("ADDING SLOT W/ TYPE: " + element.slotType);

				if (element.slotType == GlobalVariables.TYPE_MONSTER) {
					_monsterSlots.push(element);
					//trace("ADDING MONSTER SLOT, TOTAL: " + _monsterSlots.length);
				} else if (element.slotType == GlobalVariables.TYPE_TRAP) {
					_trapSlots.push(element);
					//trace("ADDING TRAP SLOT, TOTAL: " + _trapSlots.length);
				} else if (element.slotType == GlobalVariables.TYPE_DOOR) {
					_doorSlots.push(element);
					//trace("ADDING DOOR SLOT, TOTAL: " + _doorSlots.length);
				} else if (element.slotType == GlobalVariables.TYPE_CHEST) {
					_chestSlots.push(element);
					//trace("ADDING CHEST SLOT, TOTAL: " + _chestSlots.length);
				}

			}

			_gameElements.push(element);

			node.enterNode(element);

			//_gameplayScreen.calculateResidualGold();
		}

		public function addBoss(node: GraphicNode, element: *): void {

			trace("\nADD BOSS " + node, element);

			_updatableElements.push(element);
			_updatableElements.sortOn('dexterity', Array.NUMERIC);

			_monsterCount++;
			trace("ADDING MONSTER: " + _monsterCount);

			_gameElements.push(element);

			node.enterNode(element);
		}

		public function removeGameElement(element: * ): void {

			trace("\nREMOVING GAME ELEMENT - " + element);
			//trace("BEFORE:\nGAME ELEMENTS: " + _gameElements);
			//trace("UPDATABLE ELEMENTS: " + _updatableElements);

			var node: GraphicNode = element.currentNode;

			if (element is IUpdatable) {
				_updatableElements.splice(_updatableElements.indexOf(element), 1);

				if (element is IAdventurer) {
					_advCount--;
					_adventurers.splice(_adventurers.indexOf(element), 1);
					trace("SUBTRACTING ADV: " + _advCount);
				} else if (element is IMonster) {
					_monsterCount--;
					_monsters.splice(_monsters.indexOf(element), 1);
					trace("SUBTRACTING MONSTER: " + _monsterCount);


				} else if (element is SpawnPoint) {
					_spawnPoints.splice(_spawnPoints.indexOf(element), 1);
					trace("SUBTRACTING SPAWNPOINT");
				}

			} else if (element is ITrap) {
				_traps.splice(_traps.indexOf(element), 1);

			} else if (element is IDoor) {
				_doors.splice(_doors.indexOf(element), 1);

			} else if (element is IChest) {
				_chests.splice(_chests.indexOf(element), 1);

			} else if (element is SpawnPoint) {
				_spawnPoints.splice(_spawnPoints.indexOf(element), 1);


			} else if (element is EmptySlot) {

				trace("SUBTRACTING SLOT W/ TYPE: " + element.slotType);

				if (element.slotType == GlobalVariables.TYPE_MONSTER) _monsterSlots.splice(_monsterSlots.indexOf(element), 1);
				else if (element.slotType == GlobalVariables.TYPE_TRAP) _trapSlots.splice(_trapSlots.indexOf(element), 1);
				else if (element.slotType == GlobalVariables.TYPE_DOOR) _doorSlots.splice(_doorSlots.indexOf(element), 1);
				else if (element.slotType == GlobalVariables.TYPE_CHEST) _chestSlots.splice(_chestSlots.indexOf(element), 1);

			}

			_gameElements.splice(_gameElements.indexOf(element), 1);

			node.exitNode(element);
			element.destroy();

			//trace("AFTER:\nGAME ELEMENTS: " + _gameElements);
			//trace("UPDATABLE ELEMENTS: " + _updatableElements);
			//_gameplayScreen.calculateResidualGold();
		}

		// BUILDER METHODS

		public function fillFloors(roomCols: int, roomRows: int, startNode: GraphicNode): void {
			var tempNode;
			var tX: int;
			var tY: int;

			for (var xx: int = 0; xx < roomCols; xx++) {
				for (var yy: int = 0; yy < roomRows; yy++) {

					tX = startNode.col + xx;
					tY = startNode.row + yy;

					if (checkInBounds(tX, tY) == false) {
						trace("\n\nERROR: ROOM OUT OF BOUNDS\n\n");
						return;
					}

					tempNode = _gridArray[tX][tY];

					if (tempNode.graphic is Floor_Middle_MC == false) {
						tempNode.graphic = new Floor_Middle_MC(FLOOR_INDEX);
						_floors.push(tempNode);
					}
				}
			}
		}

		public function addRandomDecor(): void {

			for each(var n: GraphicNode in floors) {

				if (n.hasDecor || n.isEntrance || n.isTraversable == false || n.occupier) continue;

				if (Math.random() < .03) {
					n.addDecor(new Floor_Decor_Bones());
				}
			}
		}


		public function swapAllGraphics(thisIndex: int): void {
			for each(var c: MovieClip in _corners) {
				//trace("corner: " + c, c.graphic);
				c.graphic.gotoAndStop(thisIndex);
			}
			for each(var w: MovieClip in _walls) {
				//trace("wall: " + w, w.graphic);
				w.graphic.gotoAndStop(thisIndex);
			}
			for each(var f: MovieClip in _floors) {
				//trace("floor: " + f, f.graphic);
				f.graphic.gotoAndStop(thisIndex);
			}
		}

		public function getUp2x2(node: GraphicNode): Array {
			var tempArray: Array = [];
			tempArray.push(getUp(node));
			tempArray.push(getUpperRight(node));

			return tempArray;
		}

		public function getDown2x2(node: GraphicNode): Array {
			var tempArray: Array = [];
			tempArray.push(getDown(getDown(node)));
			tempArray.push(getDown(getLowerRight(node)));

			return tempArray;
		}

		public function getLeft2x2(node: GraphicNode): Array {
			var tempArray: Array = [];
			tempArray.push(getLeft(node));
			tempArray.push(getLowerLeft(node));

			return tempArray;
		}

		public function getRight2x2(node: GraphicNode): Array {
			var tempArray: Array = [];
			tempArray.push(getRight(getRight(node)));
			tempArray.push(getRight(getLowerRight(node)));

			return tempArray;
		}


		public function estimateNotOverlapping(roomCols: int, roomRows: int, startNode: GraphicNode): int {
			var tempNode;
			var tempCount: int = 0;
			var tX: int;
			var tY: int;

			for (var xx: int = 0; xx < roomCols; xx++) {
				for (var yy: int = 0; yy < roomRows; yy++) {

					tX = startNode.col + xx;
					tY = startNode.row + yy;

					if (checkInBounds(tX, tY) == false) {
						trace("\n\nERROR: ROOM OUT OF BOUNDS\n\n");
						return int.MAX_VALUE;
					}

					tempNode = _gridArray[tX][tY];

					if (tempNode.graphic is Floor_Middle_MC == false) {
						tempCount++;
					}
				}
			}
			trace("Nodes not overlapping: " + tempCount);
			return tempCount;
		}


		// check if coordinate is in bounds
		public function checkInBounds(tempCol: int, tempRow: int): Boolean {
			if ((tempCol >= 0) && (tempCol < _columns) && (tempRow >= 0) && (tempRow < _rows)) {
				return true;
			} else {
				return false;
			}
		}

		// check for traversable
		public function checkForTraversable(): void {

			var tempNode: GraphicNode;

			//trace("Check for traversable");

			for (var c: int = 0; c < _columns; c++) {

				for (var r: int = 0; r < _rows; r++) {

					tempNode = _gridArray[c][r];

					if (tempNode.graphic is IFloor) {
						tempNode.isTraversable = true;
					} else {
						tempNode.isTraversable = false;
					}
				}
				//trace(tempChild + " set to grid @ (" + tempNode.row + ", " + tempNode.col + ") , isTraversable: " + tempNode.isTraversable);
			}
		}


		// get adjacent nodes
		public function getAdjacentNodes(thisNode: INode, lookForTraversable: Boolean, lookForUnoccupied: Boolean): Array {

			//trace("\nStart getAdjacentNodes with " + thisNode);

			var tempArray: Array = [];
			var tempNode: GraphicNode;
			var tempCol: int;
			var tempRow: int;

			for (var i: int = 0; i < 2; i++) {
				for (var j: int = -1; j < 2; j += 2) {

					tempCol = thisNode.col + j * (i);
					tempRow = thisNode.row + j * (1 - i);


					if (checkInBounds(tempCol, tempRow)) {

						tempNode = _gridArray[tempCol][tempRow];

						if (lookForTraversable && tempNode.isTraversable == false) {
							//trace("no trav");
							continue;
						}

						if (lookForUnoccupied && tempNode.isOccupied == true) {
							//trace("no unocc");
							continue;
						}

						tempArray.push(tempNode);

						// end qualifier check
					} // end position check
				} // end j for loop
			} // end i for loop

			//trace("adjacent Nodes: " + tempArray);
			return tempArray;

		} // end getAdjacentNodes


		// return if two *s are adjacent
		public function areAdjacent(a: GraphicNode, b: GraphicNode): Boolean {
			if (getUp(a) == b) return true;
			if (getDown(a) == b) return true;
			if (getLeft(a) == b) return true;
			if (getRight(a) == b) return true;
			return false
		}


		// get direction

		public function getUp(thisNode: GraphicNode): GraphicNode {
			return getGridItem(thisNode.col, thisNode.row - 1);
		}
		public function getDown(thisNode: GraphicNode): GraphicNode {
			return getGridItem(thisNode.col, thisNode.row + 1);
		}
		public function getLeft(thisNode: GraphicNode): GraphicNode {
			return getGridItem(thisNode.col - 1, thisNode.row);
		}
		public function getRight(thisNode: GraphicNode): GraphicNode {
			return getGridItem(thisNode.col + 1, thisNode.row);
		}

		public function getUpperLeft(thisNode: GraphicNode): GraphicNode {
			return getGridItem(thisNode.col - 1, thisNode.row - 1);
		}
		public function getLowerLeft(thisNode: GraphicNode): GraphicNode {
			return getGridItem(thisNode.col - 1, thisNode.row + 1);
		}
		public function getUpperRight(thisNode: GraphicNode): GraphicNode {
			return getGridItem(thisNode.col + 1, thisNode.row - 1);
		}
		public function getLowerRight(thisNode: GraphicNode): GraphicNode {
			return getGridItem(thisNode.col + 1, thisNode.row + 1);
		}


		// return grid item
		public function getGridItem(col: int, row: int): GraphicNode {
			if (checkInBounds(col, row)) {
				return (_gridArray[col][row]);
			} else {
				return null;
			}
		}


		// get/set 
		public function get gridArray(): Array {
			return _gridArray;
		}
		public function get rows(): int {
			return _rows;
		}
		public function get columns(): int {
			return _columns;
		}

		public function get leftSide(): int {
			return x;
		}
		public function get rightSide(): int {
			return x + width;
		}
		public function get upSide(): int {
			return y;
		}
		public function get downSide(): int {
			return y + height;
		}
		public function get monsters(): Array {
			return _monsters;
		}
		public function get adventurers(): Array {
			return _adventurers;
		}
		public function get doors(): Array {
			return _doors;
		}
		public function get traps(): Array {
			return _traps;
		}
		public function get chests(): Array {
			return _chests;
		}
		public function get spawnPoints(): Array {
			return _spawnPoints;
		}


		public function get monsterSlots(): Array {
			return _monsterSlots;
		}
		public function get trapSlots(): Array {
			return _trapSlots;
		}
		public function get doorSlots(): Array {
			return _doorSlots;
		}
		public function get chestSlots(): Array {
			return _chestSlots;
		}



		public function centerGrid(): void {
			var floorX: int = 0;
			var floorY: int = 0;

			for (var i: int = 0; i < _floors.length; i++) {
				floorX += _floors[i].col;
				floorY += _floors[i].row;
			}

			var avgX: int = floorX / _floors.length;
			var avgY: int = floorY / _floors.length;

			var centerX: int = avgX * 40;
			var centerY: int = avgY * 40; //_pixelwidth

			x = centerX;
			y = centerY;

		}


		// add walls
		public function addWalls(): void {

			var floorArray: Array = _floors;
			var tempElement;
			var tempElement2;


			for (var k: int = 0; k < floorArray.length; k++) {
				//trace("a");
				adjust(floorArray[k]);
			}

			for (var k2: int = 0; k2 < floorArray.length; k2++) {
				//trace("b");
				adjust(floorArray[k2]);
			}

			for (var k3: int = 0; k3 < floorArray.length; k3++) {
				//trace("c");
				addCorners(floorArray[k3]);
			}



			// next use wall array

			var wallArray: Array = _walls;
			for (var i2: int = 0; i2 < wallArray.length; i2++) {

				tempElement = wallArray[i2];

				var len = getAdjacentNodes(tempElement, true, true);

				if (len.length < 3) {
					adjustWall(tempElement);
				}

			}


			// next use corner array

			var cornerArray: Array = _corners;
			for (var i3: int = 0; i3 < cornerArray.length; i3++) {

				tempElement = cornerArray[i3];
				//trace(tempElement);

				var tempX: int = tempElement.col;
				var tempY: int = tempElement.row;

				//trace(tempX, tempY);

				var len2 = getAdjacentNodes(tempElement, true, true);
				//trace("NUMBER OF NODES ADJACENT TO " + tempElement + ": " + len2);

				if (len2.length > 2) {

					var cornerNode: GraphicNode = tempElement;
					var tempNode: GraphicNode;

					if (getUp(cornerNode).graphic is IWall) {

						swapAndCheck(cornerNode, new Wall_Vertical_MC());

					} else if (getDown(cornerNode).graphic is IWall) {

						swapAndCheck(cornerNode, new Wall_Vertical_MC());

					} else if (getLeft(cornerNode).graphic is IWall) {

						swapAndCheck(cornerNode, new Wall_Horizontal_MC());

					} else if (getRight(cornerNode).graphic is IWall) {

						swapAndCheck(cornerNode, new Wall_Horizontal_MC());
					}

				}
			}

			for each(var w: MovieClip in _walls) {
				w.graphic.gotoAndStop(WALL_INDEX);
			}
			for each(var c: MovieClip in _corners) {
				c.graphic.gotoAndStop(WALL_INDEX);
			}

			//adjustFloors(); find it
		}

		public function adjustWall(wallNode: GraphicNode): void {

			var tempX: int = wallNode.col;
			var tempY: int = wallNode.row;
			var tempNode: GraphicNode;

			//trace(tempX, tempY, wallNode);

			if (getUp(wallNode).graphic is Floor_Middle_MC) {

				if (getLeft(wallNode).graphic is Floor_Middle_MC) {

					swapAndCheck(wallNode, new Wall_UL_MC());

				} else if (getRight(wallNode).graphic is Floor_Middle_MC) {

					swapAndCheck(wallNode, new Wall_UR_MC());
				}

			} else if (getDown(wallNode).graphic is Floor_Middle_MC) {

				if (getLeft(wallNode).graphic is Floor_Middle_MC) {

					swapAndCheck(wallNode, new Wall_LL_MC());

				} else if (getRight(wallNode).graphic is Floor_Middle_MC) {

					swapAndCheck(wallNode, new Wall_LR_MC());
				}

			}
		}

		public function adjustFloors(): void {

			for each(var floorNode: GraphicNode in _floors) {

				if (getLeft(floorNode).graphic is Wall_Vertical_MC) {
					if (getRight(floorNode).graphic is Wall_Vertical_MC) {
						floorNode.graphic = new Floor_L_MC();
					}
				}
			}
		}

		public function adjust(floorNode: GraphicNode): void {

			var tempX: int = floorNode.col;
			var tempY: int = floorNode.row;
			var tempNode: GraphicNode;

			var tempLeft: GraphicNode;
			var tempRight: GraphicNode;
			var tempUp: GraphicNode;
			var tempDown: GraphicNode;

			//trace("start adjust with " + floorNode);
			//trace(tempX,tempY);

			tempNode = getUp(floorNode); //getting up

			if (tempNode.graphic == null) {

				swapAndCheck(tempNode, new Wall_Horizontal_MC()); // setting to wall horiz

				/*if (Math.random() < .2) {
					tempNode.graphic.addChild(new Wall_Decor_Candle);
				}*/

			} else if (tempNode.graphic is Wall_Horizontal_MC) {

				tempUp = getUp(tempNode);

				if (tempUp.graphic is Wall_Vertical_MC) { //if up of wall horiz is wall vert

					if (getLeft(tempNode).graphic is Floor_Middle_MC) { // if left of wall horiz is floor
						swapAndCheck(tempNode, new Wall_LL_MC());
					} else if (getRight(tempNode).graphic is Floor_Middle_MC) { // if right of wall horiz is floor
						swapAndCheck(tempNode, new Wall_LR_MC());
					}

				}
			}

			tempNode = getDown(floorNode);
			if (tempNode.graphic == null) {
				swapAndCheck(tempNode, new Wall_Horizontal_MC());

			} else if (tempNode.graphic is Wall_Horizontal_MC) {

				tempDown = getDown(tempNode);

				if (tempDown.graphic is Wall_Vertical_MC) { //if down of wall horiz is wall vert

					if (getLeft(tempNode).graphic is Floor_Middle_MC) { // if left of wall horiz is floor
						swapAndCheck(tempNode, new Wall_UL_MC());
					} else if (getRight(tempNode).graphic is Floor_Middle_MC) { // if right of wall horiz is floor
						swapAndCheck(tempNode, new Wall_UR_MC());
					}

				}
			}

			tempNode = getLeft(floorNode);
			if (tempNode.graphic == null) {
				swapAndCheck(tempNode, new Wall_Vertical_MC());

			} else if (tempNode.graphic is Wall_Vertical_MC) {

				tempLeft = getLeft(tempNode);

				if (tempLeft.graphic is Wall_Horizontal_MC) { //if left of wall vert is wall horiz

					if (getUp(tempNode).graphic is Floor_Middle_MC) { // if up of wall vert is floor
						swapAndCheck(tempNode, new Wall_UR_MC());
					} else if (getDown(tempNode).graphic is Floor_Middle_MC) { // if down of wall vert is floor
						swapAndCheck(tempNode, new Wall_LR_MC());
					}

				} else if (tempLeft.graphic is Wall_Vertical_MC) {

					if (getUp(tempNode).graphic is Floor_Middle_MC) {
						swapAndCheck(tempLeft, new Wall_UR_MC());
						swapAndCheck(tempNode, new Wall_UL_MC());
					} else if (getDown(tempNode).graphic is Floor_Middle_MC) {
						swapAndCheck(tempLeft, new Wall_LL_MC());
						swapAndCheck(tempNode, new Wall_LR_MC());
					}
				}
			}

			tempNode = getRight(floorNode);
			if (tempNode.graphic == null) {
				swapAndCheck(tempNode, new Wall_Vertical_MC());

			} else if (tempNode.graphic is Wall_Vertical_MC) {

				tempRight = getRight(tempNode);

				if (tempRight.graphic is Wall_Horizontal_MC) { //if down of wall vert is wall horiz

					if (getUp(tempNode).graphic is Floor_Middle_MC) { // if up of wall vert is floor
						swapAndCheck(tempNode, new Wall_UL_MC());
					} else if (getDown(tempNode).graphic is Floor_Middle_MC) { // if down of wall vert is floor
						swapAndCheck(tempNode, new Wall_LL_MC());
					}

				} else if (tempRight.graphic is Wall_Vertical_MC) {

					if (getUp(tempNode).graphic is Floor_Middle_MC) {
						swapAndCheck(tempRight, new Wall_UR_MC());
						swapAndCheck(tempNode, new Wall_UL_MC());
					} else if (getDown(tempNode).graphic is Floor_Middle_MC) {
						swapAndCheck(tempRight, new Wall_LR_MC());
						swapAndCheck(tempNode, new Wall_LL_MC());
					}
				}
			}
		}


		public function addCorners(floorNode: GraphicNode) {

			var tempX: int = floorNode.col;
			var tempY: int = floorNode.row;
			var tempNode: GraphicNode;

			tempNode = getUpperLeft(floorNode);
			if (tempNode.graphic == null) {
				swapAndCheck(tempNode, new Wall_UL_MC());
			}

			tempNode = getUpperRight(floorNode);
			if (tempNode.graphic == null) {
				swapAndCheck(tempNode, new Wall_UR_MC());
			}

			tempNode = getLowerLeft(floorNode);
			if (tempNode.graphic == null) {
				swapAndCheck(tempNode, new Wall_LL_MC());
			}

			tempNode = getLowerRight(floorNode);
			if (tempNode.graphic == null) {
				swapAndCheck(tempNode, new Wall_LR_MC());
			}
		}

		public function swap(thisNode: * , withThis: DisplayObject): void {

			if (thisNode.graphic is Floor_Middle_MC) return;

			thisNode.graphic = withThis;

			//trace("	-	-	-	-	-	-	-	-	-	-	Swap ended, thisNode.graphic = " +  thisNode.graphic);
		}

		public function swapAndCheck(thisNode: * , withThis: DisplayObject): void {

			if (thisNode.graphic is Floor_Middle_MC) return;

			thisNode.graphic = withThis;

			if (thisNode.graphic is IFloor) {
				_floors.push(thisNode);
			} else if (thisNode.graphic is IWall) {
				_walls.push(thisNode);
			} else if (thisNode.graphic is ICorner) {
				_corners.push(thisNode);
			}

			//trace("this node: " + thisNode + ", swapped with " + thisNode.graphic);
		}

		public function removeWallsAndCorners(): void {

			for (var i: int = 0; i < _walls.length; i++) {
				swapAndCheck(_walls[i], null);
			}

			for (var j: int = 0; j < _corners.length; j++) {
				swapAndCheck(_corners[j], null);
			}
			
			_walls = [];
			_corners = [];
		}


		//get/set
		public function get gameElements(): Array {
			return _gameElements;
		}
		public function get updatableElements(): Array {
			return _updatableElements;
		}
		public function get gameplayScreen(): GameplayScreen {
			return _gameplayScreen;
		}

		public function get entrance(): * {
			return _entrances[int(Math.random() * _entrances.length)];
		}

		public function get entrances(): * {
			return _entrances;
		}

		public function set entrance(node: GraphicNode): void {
			_entrances.push(node);
			var sp: SpawnPoint = new SpawnPoint(IAdventurer, this);
			node.setAsEntrance(sp);
			addGameElement(node, sp);
		}

		public function get advCount(): int {
			return _advCount;
		}
		public function get monsterCount(): int {
			return _monsterCount;
		}

		// destroy
		public function destroy(): void {

			if (_entrances) {
				for (var i: int = _entrances.length; i >= 0; i--) {
					_entrances[i].removeAsEntrance(); // watch this
					_entrances[i] = null;
				}
			}

			_docClass = null;
			_gameplayScreen = null;
			_gridArray = null;

			_monsters = null;
			_chests = null;
			_adventurers = null;

			_floors = null;
			_walls = null;
			_corners = null;

			_gameElements = null;
			_updatableElements = null;

			_backgroundSprite.graphics.clear();
			_backgroundSprite = null;
		}

	}

}
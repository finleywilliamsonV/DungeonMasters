package {

	import flash.display.MovieClip;


	// add check for max creatures allowed, here or in master grid

	public class SpawnPoint extends MovieClip implements IUpdatable {

		private var _unit: Class;
		private var _isSet: Boolean;
		private var _difficulty: int;
		private var _currentNode: GraphicNode;

		private var _spawnTimer: int;

		private var _unitsToSpawn: Array;

		private var _masterGrid: MasterGrid;
		private var _dm: DungeonMaster;
		private var _gE: Array;

		private var _timerLength: int = GlobalVariables.SPAWN_DELAY;

		private var _unitCap: int;
		private var _unitCount: int;
		private var _advCap: int = 6;
		private var _monsterCap: int = 16;

		private var _unitsSpawned: Array = [];
		private var _spawnMax: int = 1;

		//private var _advClasses: Array = new Array(A_Rogue, A_Knight, A_Wizard);
		private var _advClasses: Array = GlobalVariables.advClasses;
		//private var _advClasses: Array = new Array(Knight, Wizard, Cleric, Rogue);

		public var dexterity: int = 999;

		public function SpawnPoint(unit: Class, mg: MasterGrid): void {
			_unit = unit;

			_unitsToSpawn = [];
			_spawnTimer = _timerLength;

			_masterGrid = mg;
			_gE = _masterGrid.gameElements;

			if (unit == IAdventurer) {
				gotoAndStop(2);
				_unitCap = _advCap;
				_timerLength = int.MAX_VALUE;

			} else {
				gotoAndStop(1);
				_unitCap = _monsterCap;
			}

			trace("Created New Spawn Point - " + _unit);


			//_unitsToSpawn.push(new A_Rogue(_masterGrid));
		}

		public function calculateUnit(): * {
			var tempUnit;

			if (_unit != IAdventurer) {
				tempUnit = new _unit(_masterGrid);
				tempUnit.spawnPoint = this;
			} else {
				var rand: int = Math.random() * _advClasses.length;
				//trace("RAND: "+rand);
				var randClass: Class = _advClasses[rand];
				tempUnit = new randClass(_masterGrid);
			}

			return tempUnit;
		}

		public function update(): void {
			
			//trace("UPDATING - " + _unit);
			
			/*if (_unit != IAdventurer) {
				trace(" ");
			}*/

			// check all units to make sure none are off stage?? find it
			for (var i: int = _unitsSpawned.length - 1; i >= 0; i--) {
				var checkUnit = _unitsSpawned[i];
				
				if (checkUnit.stage == null) {
					_unitsSpawned.splice(_unitsSpawned.indexOf(checkUnit), 1);
				}
			}
			
			
			// spawn all that are in queue up to max num
			var adjUnocc2: Array;
			
			if (_unitsToSpawn.length > 0) {
				
				//trace("\n***\nAttempting reserve spawn" + _unit + ", " + _unitCount, _unitCap);
				//adjUnocc2 = DungeonPathfinder.getNodesInAreaUnoccupied(_currentNode, _masterGrid, 1); //2 gives a rectangle
				adjUnocc2 = []; //2 gives a rectangle
				
				if (_currentNode.occupier == this) {
					adjUnocc2.push(_currentNode);
				}
				
				if (_unit == IAdventurer) {
					_unitCount = _masterGrid.advCount;
				} else {
					_unitCount = _masterGrid.monsterCount;
				}
				
				if (adjUnocc2.length > 0 && _unitCount < _unitCap) {

					//if (_unit != IAdventurer && _masterGrid.advCount > 0) {	// wait for the adventurers to leave before spawning

					//} else {

						var tempUnit2 = _unitsToSpawn[_unitsToSpawn.length - 1];
						_unitsToSpawn.splice(_unitsToSpawn.length - 1, 1);
						_masterGrid.addGameElement(adjUnocc2[int(Math.random() * adjUnocc2.length)], tempUnit2);
						//trace("- spawn from reserve: " + tempUnit2);
					//}
				}
			}

			if (_unitsSpawned.length < _spawnMax) _spawnTimer++;

			if (_spawnTimer >= _timerLength) {
				
				
				// no spawn monsters if adv in dungeon
				/*if (_unit != IAdventurer && _masterGrid.advCount > 0) {
					return;
				}*/

				if (_unitsSpawned.length < _spawnMax) {

					var tempUnit = calculateUnit();

					_spawnTimer = 0;

					//trace("\n***\nAttempting " + _unit + ", " + _unitCount, _unitCap);

					//var adjUnocc: Array = DungeonPathfinder.getNodesInAreaUnoccupied(_currentNode, _masterGrid, 1); //2 gives a rectangle
					var adjUnocc: Array = [];
					//trace(adjUnocc);

					if (_currentNode.occupier == this) {
						adjUnocc.push(_currentNode);
					}

					if (adjUnocc.length == 0) {
						//trace("ALL FULL");
						//trace("# of units on field: " + _unitCount);
						_unitsToSpawn.push(tempUnit);
						//trace("Units to Spawn: " + _unitsToSpawn);
					} else {

							_masterGrid.addGameElement(adjUnocc[int(Math.random() * adjUnocc.length)], tempUnit);
							_unitsSpawned.push(tempUnit);
							trace("\n- spawn: " + tempUnit);
						
					}
				} else {
					_spawnTimer = _timerLength;
				}
			}
		}

		public function get currentNode(): GraphicNode {
			return _currentNode;
		}

		public function set currentNode(value: GraphicNode): void {
			_currentNode = value;
			//_currentNode.enterNode(this);
		}

		public function addToQueue(these: Array): void {
			for (var i: int = these.length - 1; i >= 0; i--) {
				var unit = these[i];
				if (unit is Class) {
					unit = new unit(_masterGrid);
				}
				_unitsToSpawn.push(unit);
			}
		}

		public function get spawnTimer(): int {
			return _spawnTimer;
		}

		public function get timerLength(): int {
			return _timerLength;
		}

		public function get unitsToSpawn(): Array {
			return _unitsToSpawn;
		}

		public function get unit(): Class {
			return _unit;
		}

		public function get unitsSpawned(): Array {
			return _unitsSpawned;
		}

		public function get spawnMax(): int {

			return _spawnMax;
		}

		public function get ticksTillNextSpawn(): int {
			return (_timerLength - _spawnTimer);
		}


		public function destroy(): void {

			//_currentNode.exitNode(this);

			for each(var unitSpawned: * in _unitsSpawned) {
				unitSpawned.die();
				unitSpawned.destroy();
			}

			_unitsSpawned = null;

			_unitsToSpawn = null;

			_masterGrid = null;
			_gE = null;

			_currentNode = null;
		}
	}

}
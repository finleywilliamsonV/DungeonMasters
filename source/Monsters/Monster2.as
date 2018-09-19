package {

	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	// spawn points
	// ranged attacks
	// boss door / key
	// status effects



	/*
	
		Check spaces around you
		if you see anything of interest, engage
		
		if (pursuing enemy)
			
			check if enemy is still alive
			
			if (within range of melee weapon) attack melee
			else if (within range of ranged weapon) arrack ranged
			else move within range
			
		if (pursuing non-hostile)
		
			follow path until higher priority target
			
			
		else if no targets of interest, mark room and move away
	
	
	
	NOTES

	private var _attacks : Array;
	
	private var _equippedWeaponMelee : Weapon;
	private var _equippedWeaponRanged : Weapon;
	
	Weapon Class:
	Range
	Damage (dice)
	Accuracy (dice)
	
	// elsewhere
	
	calculate battle event:
	weapon vs armor
	
	equipped armor?? or just defense?
	
	*/

	public class Monster extends MovieClip implements IMonster, IUpdatable {

		private var _masterGrid: MasterGrid;
		private var _dm: DungeonMaster;
		private var _gameElements: Array;

		private var _thingsOfInterest: Array;
		private var _currentThing: * ;

		private var _previousNode: GraphicNode;
		private var _previousNodes: Array = [];

		private var _currentNode: GraphicNode;
		private var _startNode: GraphicNode;
		private var _endNode: GraphicNode;

		private var _logicIndex: int = 0;
		private var _pathIndex: int = 0;

		private var _currentPath: Array;

		private var focusTarget: * ;

		private var _value: int;


		public var _currentlySelectedAttack: IWeapon;
		private var _attacks: Array = [];
		private var _armor: * ;

		//stats
		private var _maxHealth: int;
		private var _health: int;
		private var _maxMana: int;
		private var _mana: int;
		private var _attack: int;
		private var _magicAttack: int;
		private var _defense: int;
		private var _magicDefense: int;
		private var _dexterity: int;

		private var _healthBar: HealthBar;

		private var _sightDistance: int;
		private var _gold: int;

		private var _statusEffects: Array;

		private var _inventory: Array;

		private var _isLooking: Boolean;
		private var _movingInRange: Boolean = false;

		private var _isBattling: Boolean;

		public function Monster(mg: MasterGrid): void {

			gotoAndStop(1);

			_masterGrid = mg;

			_dm = _masterGrid.gameplayScreen.dm;
			_gameElements = _masterGrid.gameElements;

			_thingsOfInterest = [];
			_inventory = [];

			gold = Math.random() * 300;

			_isBattling = false;

			_statusEffects = [];

			_healthBar = new HealthBar();
			addChild(_healthBar);
			_healthBar.x = 9 - width / 2;
			_healthBar.y = -height / 2;

			_value = 100;

			trace("Monster Created");
		}


		public function switchFrames(): void {
			if (_isBattling) {
				if (currentFrame == 3) gotoAndStop(4);
				else gotoAndStop(3);
			} else {
				if (currentFrame == 1) gotoAndStop(2);
				else gotoAndStop(1);
			}

			////trace("switch to " + currentFrame);
		}

		public function get isBattling(): Boolean {
			return _isBattling;
		}

		public function update(): void {

			switchFrames();

			//   - fight
			// 0 - (no path) scan room & find points of interest
			// 1 - follow path
			// 2 - no points of interest found, calculate new path.
			//   * WHILE POINTS OF INTEREST REMAIN*
			// 3 - (if hostile point of interest) move to spot in range, cast spell
			// 4 - (if friendly point of interest) move to location, interact
			// 5 - (no points of interest remain) scan room
			//

			trace("\nUPDATE LIZ @ " + _currentNode);
			//if (isBattling) {

			//	fight();

			if (_logicIndex == 0) {

				trace("LIZ: scanning room");
				scanRoom();

			} else if (_logicIndex == 1) {

				trace("LIZ: following path");
				followPath();
				scanRoom();

			} else if (_logicIndex == 2) {

				_isLooking = true;

				trace("LIZ: no points of interest found, calculating new path");

				if (_previousNodes.length == 0) {
					_previousNode = _currentNode;
				}

				_previousNodes.push(_currentNode);

				if (_previousNodes.length > 5) {
					_previousNode = _previousNodes[_previousNodes.length - 4];
				}

				//trace("LIZ: _previousNode: " + _previousNode);

				// look for new stuff
				currentPath = DungeonPathfinder.findPath(_currentNode, DungeonPathfinder.findFarthestPoint(_currentNode, _previousNode, _sightDistance));
				_logicIndex = 1;

			} else if (_logicIndex == 3) { // engage hostile

				if (focusTarget.currentNode == null) {
					//trace("LIZ: focus target null, resetting logic");
					_movingInRange = false;
					resetLogic();
					return;
				}

				scanRoom();

				//find it
				// you have changed the fireball,
				// the path for attack


				trace("LIZ: engaging hostile " + focusTarget);
				_movingInRange = true;
				if (changePathForAttack(focusTarget.currentNode) == false) { // no change needed if false
					//trace("LIZ: FIRE FIRE FIRE");
					if (isBattling == false) {
						startBattle(focusTarget);
					} else {
						fight();
					}
				} else {
					followPath();
				}


			} else if (_logicIndex == 4) { // engage friendly

				if (focusTarget.currentNode == null) {
					//trace("LIZ: focus target null, resetting logic");
					resetLogic();
					return;
				}

				scanRoom();

				trace("LIZ: engaging friendly " + focusTarget);
				changePath(focusTarget.currentNode);
				followPath();
			}
		}

		public function resetLogic(): void {
			focusTarget = null;
			_logicIndex = 0;
			_previousNodes = [];
		}

		public function followPath(): void {

			//trace("LIZ: commence follow path");

			if (_currentPath[_pathIndex].isOccupied) {

				var occ = _currentPath[_pathIndex].occupier;
				//trace("LIZ: square occupied by: " + occ);

				if (occ == focusTarget) { // watch this
					//trace("LIZ: Focus Target found, clearing focus target");
					focusTarget = null;
					_logicIndex = 0;
				}

				if ((occ is IDoor && occ.isOpen) || (occ is IChest && occ.isEmpty) || occ is ITrap || occ is SpawnPoint) {

				} else {



					if (occ is IAdventurer) {

						attackTarget(occ);

					} else {

						if (tryUnoccupiedSpace()) {
							followPath();
						}
					}

					return;
				}

			}

			//trace("LIZ: --- not occupied, moving toward " + _endNode);

			_currentNode.exitNode(this);
			_currentNode = _currentPath[_pathIndex];
			_currentNode.enterNode(this);

			//trace("LIZ:  -> entered node " + _currentNode.row, _currentNode.col);

			_pathIndex++;

			if (_currentNode == _endNode) {
				//trace("LIZ:  * * * destination reached @ " + _currentNode);
				if (_isLooking) {
					_logicIndex = 2;
				} else if (_movingInRange) {
					//trace("LIZ: In range, prepare for attack");
				} else if (focusTarget) {
					//trace("LIZ: HERE !!!");
				} else {
					_logicIndex = 0;
				}
			}
		}


		public function setDestination(destNode: GraphicNode): void {

			trace("LIZ: setDestination : " + destNode.row, destNode.col);

			currentPath = DungeonPathfinder.findPath(_currentNode, destNode);
		}

		public function set currentPath(newPath: Array): void {

			/*if (_currentPath) {
				for (var i: int = 0; i < _currentPath.length; i++) {
					_currentPath[i].gotoAndStop(1);
				}
			}*/
			_currentPath = newPath;

			_startNode = _currentPath[0];
			_endNode = _currentPath[_currentPath.length - 1];

			/*for (var j: int = 0; j < _currentPath.length; j++) {
				_currentPath[j].gotoAndStop("mark");
			}*/

			//trace("LIZ: currentPath set, new destination: " + _endNode.row, _endNode.col);

			_pathIndex = 0;
		}


		public function tryUnoccupiedSpace(): Boolean {
			var tempArray: Array = DungeonPathfinder.getNodesInAreaUnoccupied(_currentNode, _masterGrid);
			//trace("					UNOCCUPIED SPACES " + tempArray);
			if (tempArray.length > 0) {
				setDestination(tempArray[int(Math.random() * tempArray.length)]);
				return true;
			} else {
				return false;
			}

		}

		public function scanRoom(): void {
			//trace("LIZ: commence scanning");

			//trace("LIZ: focus target: " + focusTarget);

			var nodesInArea: Array = DungeonPathfinder.getNodesInArea(_currentNode, _sightDistance);
			_thingsOfInterest = [];

			for (var i: int = 0; i < nodesInArea.length; i++) {
				var tempNode: GraphicNode = nodesInArea[i];

				if (tempNode.isOccupied) {
					var occ = tempNode.occupier;

					if (occ is IAdventurer) {

						_thingsOfInterest.push(nodesInArea[i]);
					}
				}
			}

			if (_thingsOfInterest.length > 0) {
				//trace("LIZ: - interests found: " + _thingsOfInterest);

				var poi;

				if (focusTarget) { // if focus target disappears then they are confused

					if (focusTarget.stage == null) {
						focusTarget = null;
					} else {
						_thingsOfInterest.push(focusTarget.currentNode);
					}
				}

				if (_thingsOfInterest.length > 1) {
					var closest: GraphicNode = DungeonPathfinder.closestPoint(_currentNode, _thingsOfInterest) as GraphicNode;
					poi = closest.occupier;
				} else if (_thingsOfInterest.length == 1) {
					poi = _thingsOfInterest[0].occupier;
				}

				trace("LIZ: set course for - " + poi + " @ " + poi.currentNode.row, poi.currentNode.col);
				focusTarget = poi;

				//trace("LIZ: _previousNodes emptied");
				_previousNodes = [];
				_isLooking = false;

				currentPath = DungeonPathfinder.findPath(_currentNode, focusTarget.currentNode);

				if (poi is IAdventurer) {
					_logicIndex = 3;
				} else {
					_logicIndex = 4;
				}

			}


			if (focusTarget == null) {
				//trace("\n" + _isLooking + "\n");
				if (_isLooking == false) {
					_logicIndex = 2;
				} else if (_isLooking == true) {
					_logicIndex = 1;
				}
			}
		}

		public function setStats(maxHealth: int, health: int, maxMana: int, mana: int, atk: int, mAtk: int, def: int, mDef: int, dex: int, sightDist: int, golds: int): void {

			_maxHealth = maxHealth;
			_health = health;
			_maxMana = maxMana;
			_mana = mana;
			_attack = atk;
			_magicAttack = mAtk;
			_defense = def;
			_magicDefense = mDef;
			_dexterity = dex;
			_sightDistance = sightDist;
			_gold = golds;

			_healthBar.setMaxHealth(maxHealth);
		}

		public function attackTarget(target:*): void {
			//trace("ADV: Attacking " + String(target) + "!");

			if (_masterGrid.areAdjacent(_currentNode, target.currentNode)) {
				
				var damageMod:int;
				
				if (_currentlySelectedAttack.isMagic) {
					if (_currentlySelectedAttack.manaCost > _mana) {
						trace("NOT ENOUGH MANA")
						return;
					} else {
						_mana -= _currentlySelectedAttack.manaCost;
					}
					damageMod = _magicAttack;
				} else {
					damageMod = _attack;
				}
				
				var attackDamage: int = _currentlySelectedAttack.damage + damageMod;

				if (_isBattling == false) _isBattling = true;

				if (target.calculateDamage(attackDamage, _currentlySelectedAttack.isMagic) == false) {
					GameplayScreen(_masterGrid.parent).goldDisplay.gold += target.gold;
				} else {
					_currentlySelectedAttack.animate(target);
				}
			}
		}


		public function calculateDamage(incomingAttack: int, isMagic:Boolean): Boolean {
			
			var defenseMod:int;
				
				if (isMagic) {
					defenseMod = _magicDefense;
				} else {
					defenseMod = _defense;
				}
				
			var newDamage: int = incomingAttack - defenseMod; // - armor.defense;
				
			if (newDamage > 0) {
				_health -= newDamage;
				_healthBar.addSub(-newDamage);
			}

			//trace("ADV: " + newDamage + " damage received. Health remaining: " + health);
			//_dm._isPaused = true;

			if (health <= 0) {
				die();
				return false;
			} else if (health <= maxHealth * (_retreatThreshold/100)) {	// retreat!
				//trace(this + " RETREATING!!!");
				_isRetreating = true;
				_isBattling = false;
			}

			return true;
		}

		public function die(): void {
			trace("!!! " + this + " IS DEAD !!!");
			_masterGrid.removeGameElement(this);
		}

		public function changePath(newNode: GraphicNode): void {
			//trace("LIZ: Changing path to destination " + newNode.row, newNode.col);
			var newPath = DungeonPathfinder.findPath(_currentNode, newNode);
			currentPath = newPath;
			_pathIndex = 0;
		}

		public function changePathForAttack(newNode: GraphicNode): Boolean {
			//trace("LIZ: Changing path to node within attack range of " + newNode);
			//var newPath = DungeonPathfinder.findRangedPath(_currentNode, newNode, _attackRange);//for straight lines
			var newPath = DungeonPathfinder.findPath(_currentNode, DungeonPathfinder.findClosestWithinRange(_currentNode, newNode, _currentlySelectedAttack.range));
			//trace("LIZ: NEW PATH - " + newPath);
			if (newPath.length > 1) {
				currentPath = newPath;
				_pathIndex = 0;
				return true;
			} else {
				//trace("LIZ: No change of path needed! Ready to attack!");
				return false;
			}
		}

		public function get pathIndex(): int {
			return _pathIndex;
		}

		// get and set

		public function get maxHealth(): int {
			return _maxHealth;
		}
		public function get health(): int {
			return _health;
		}
		public function get maxMana(): int {
			return _maxMana;
		}
		public function get mana(): int {
			return _mana;
		}
		public function get attack(): int {
			return _attack;
		}
		public function get magicAttack(): int {
			return _magicAttack;
		}
		public function get defense(): int {
			return _defense;
		}
		public function get magicDefense(): int {
			return _magicDefense;
		}
		public function get dexterity(): int {
			return _dexterity;
		}
		public function get sightDistance(): int {
			return _sightDistance;
		}

		public function get focusTarget() : * {
			return _focusTarget;
		}

		public function get gold(): int {
			return _gold;
		}

		public function get value(): int {
			return _value;
		}

		public function set gold(value: int): void {
			_gold = value;
		}
		
		public function get masterGrid(): MasterGrid {
			return _masterGrid;
		}

		public function addToInventory(newItems: Array): void {

			for (var i: int = 0; i < newItems.length; i++) {
				var tempItem = newItems[i];
				//trace("RAN:" + tempItem + " added to Inventory");
				if (tempItem is Gold) {
					_gold += tempItem.value;
				} else {
					_inventory.push(tempItem);
				}
			}

			//trace("RANGHT CURRENT INVENTORY:" + _inventory);
		}

		public function get inventory(): Array {
			return _inventory;
		}

		public function set inventory(value: Array): void {
			_inventory = value;
		}

		public function get currentNode(): GraphicNode {
			return _currentNode;
		}

		public function set currentNode(value: GraphicNode): void {
			_currentNode = value;
		}


		override public function toString(): String {
			return ("Monster @ " + _currentNode);
		}

		public function destroy(): void {

			_battleTargets = null;

			_statusEffects = null;
			_inventory = null;

			_dm = null;
			_gameElements = null;

			_attacks = null;
			_currentlySelectedAttack = null;

			_currentNode = null;
			_currentPath = null;
			_endNode = null;
			_startNode = null;
			_currentNode = null;
			_previousNodes = null;
			_previousNode = null;
			_thingsOfInterest = null;
			_masterGrid = null;
		}
	}

}
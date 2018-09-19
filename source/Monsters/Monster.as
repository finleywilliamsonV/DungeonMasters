package {

	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.Shape;
	import flash.filters.ColorMatrixFilter;
	import fl.motion.AdjustColor;
	import flash.events.Event;

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

	public class Monster extends MovieClip implements IMonster, IUpdatable, IGameUnit, IPurchasable {

		private var _masterGrid: MasterGrid;
		private var _dm: DungeonMaster;
		private var _gameElements: Array;

		private var _level: int = 1;

		private var _thingsOfInterest: Array;
		private var _currentThing: * ;

		private var _previousNode: GraphicNode;
		private var _previousNodes: Array = [];

		private var _currentNode: GraphicNode;
		private var _startNode: GraphicNode;
		private var _endNode: GraphicNode;

		public var _logicIndex: int = 0;
		private var _pathIndex: int = 0;

		private var _currentPath: Array;

		private var _focusTarget: * ;

		private var _value: int;

		public var _currentlySelectedAttack: IWeapon;
		public var _attacks: Array = [];
		private var _armor: * ;

		public var TARGET_TYPE: Class;

		private var _poisonTimer: int;
		private var _burnTimer: int;
		private var _paralyzeTimer: int;
		private var _freezeTimer: int;
		private var _confuseTimer: int;
		private var _fearTimer: int;
		private var _transmuteTimer: int;

		private var _poisonGraphic: MovieClip;
		private var _burnGraphic: MovieClip;
		private var _paralyzeGraphic: MovieClip;
		private var _freezeGraphic: MovieClip;
		private var _confuseGraphic: MovieClip;
		private var _fearGraphic: MovieClip;
		private var _transmuteGraphic: MovieClip;

		private var _isPoisoned: Boolean;
		private var _isBurned: Boolean;
		private var _isParalyzed: Boolean;
		private var _isFrozen: Boolean;
		private var _isConfused: Boolean;
		private var _isFeared: Boolean;
		private var _isTransmuted: Boolean;

		private var _waitOneTurn: Boolean = false;


		private var _hasHealing: int = 0;

		private var _healTargets: Array = [];

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

		private var stored_maxHealth: int;
		private var stored_health: int;
		private var stored_maxMana: int;
		private var stored_mana: int;
		private var stored_attack: int;
		private var stored_magicAttack: int;
		private var stored_defense: int;
		private var stored_magicDefense: int;
		private var stored_dexterity: int;
		private var stored_sightDistance: int;


		private var stored_nameString: String;
		private var stored_starLevel: int;

		private var _ui_name: String;
		private var _goldCost: int;
		private var _abilities: Array;
		private var _starLevel: int;

		public var _healthBar: HealthBar;

		private var _sightDistance: int;

		private var _statusEffects: Array;

		private var _isLooking: Boolean = true;
		private var _movingInRange: Boolean = false;
		private var _movingInRangeHeal: Boolean = false;

		private var _isBattling: Boolean;
		private var _isHealing: Boolean;

		public var nameString: String;
		public var description: String;
		public var soundIndex: int = -1;

		private var _lastNode: GraphicNode;

		private var _ui_graphic: int;

		private var _attritionTimer: int = 0;
		private var _attritionTimerMax: int = 8;
		
		public var spawnPoint:SpawnPoint;

		//private var _nodesMovedThisTurn:int;


		public function Monster(mg: MasterGrid): void {

			gotoAndStop(1);

			_masterGrid = mg;

			_dm = _masterGrid.gameplayScreen.dm;
			_gameElements = _masterGrid.gameElements;

			_thingsOfInterest = [];
			_isBattling = false;
			_isHealing = false;

			_statusEffects = [];

			_healthBar = new HealthBar();

			_healthBar.x = -10;
			_healthBar.y = -15;

			if (!_healthBar.stage) {
				addChild(_healthBar);
				setChildIndex(_healthBar, numChildren - 1);
			}

			_value = 100;

			nameString = "MON";

			// status
			TARGET_TYPE = Adventurer;
			_poisonTimer = 0;
			_burnTimer = 0;
			_paralyzeTimer = 0;
			_freezeTimer = 0;
			_confuseTimer = 0;
			_fearTimer = 0;
			_transmuteTimer = 0;

			////trace("Monster Created");
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
		}

		public function onAddedToStage(e: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			GlobalVariables.instance.graphicsTimer.addEventListener(TimerEvent.TIMER, onGraphicsTick, false, 0, true);
		}

		public function onGraphicsTick(tE: TimerEvent): void {
			switchFrames();
		}


		public function applyTransmutationStats(): void {

			if (_isTransmuted) return;

			var healthRatio = _health / _maxHealth;

			stored_maxHealth = _maxHealth;
			stored_health = _health;
			stored_maxMana = _maxMana;
			stored_mana = _mana;
			stored_attack = _attack;
			stored_magicAttack = _magicAttack;
			stored_defense = _defense;
			stored_magicDefense = _magicDefense;
			stored_dexterity = _dexterity;
			stored_sightDistance = _sightDistance;

			stored_nameString = nameString;
			stored_starLevel = _starLevel;

			setStatsTransmute(20, 20 * healthRatio, 0, 0, 0, 0, 0, 0, 0, 2);

			nameString = "Chicken";
			setStats2("Chicken", 1, _goldCost, 14);
		}

		public function removeTransmutationStats(): void {

			var healthRatio = _health / _maxHealth;
			var newHealth = stored_maxHealth * healthRatio;

			////trace("_health: " + _health);
			////trace("newHealth: " + newHealth);

			setStatsTransmute(stored_maxHealth, newHealth, stored_maxMana, stored_mana, stored_attack, stored_magicAttack, stored_defense, stored_magicDefense, stored_dexterity, stored_sightDistance);
			nameString = stored_nameString;
			setStats2(stored_nameString, stored_starLevel, _goldCost, 14);
		}


		public function get isHealer(): Boolean {
			if (hasHealing && bestHeal.manaCost < _mana) {
				return true;
			} else {
				return false;
			}
		}

		public function levelUp(): void {
			if (_level >= 3) return;
			_level++;
			_starLevel++;
			setLevel(_level);
		}

		public function setLevel(level: int): void {

			//trace("Setting level of " + nameString + " to: " + level);
			var hueMod: int = 40 * (level - 1);
			var adjustColor: AdjustColor = new AdjustColor();
			adjustColor.brightness = 0;
			adjustColor.contrast = 0;
			adjustColor.saturation = 0;
			adjustColor.hue = 100;

			var matrix: Array = adjustColor.CalculateFinalFlatArray();
			var colorMatrix: ColorMatrixFilter = new ColorMatrixFilter(matrix);

			this.filters = [colorMatrix];

			modStats(1 + (.5 * (level - 1)));

		}

		public function modStats(multiplier: Number): void {

			//trace("Modding stats of " + nameString + " by: " + multiplier);
			_maxHealth *= multiplier;
			_health *= multiplier;
			_maxMana *= multiplier;
			_mana *= multiplier;
			_attack *= multiplier;
			_magicAttack *= multiplier;
			_defense *= multiplier;
			_magicDefense *= multiplier;
			_dexterity *= multiplier;
			//_sightDistance *= multiplier;
			_goldCost *= multiplier;
			//_ *= multiplier;
			//_ *= multiplier;
		}


		public function applyStatus(newStatus: IStatus): void {

			////trace("\nApplying New Status: " + newStatus);
			////trace("Chance: " + newStatus.percentChance);

			if (Math.random() < newStatus.percentChance) {
				////trace("Roll Successful, Adding Status");
			} else {
				////trace("Roll Unsuccessful, Return");
				return;
			}

			var clonedStatus: IStatus = Statuses.cloneStatus(newStatus) as IStatus;
			_statusEffects.push(clonedStatus);
			_statusEffects.sortOn('duration', Array.NUMERIC);

			if (newStatus.statusType == GlobalVariables.TYPE_STATUS_POISON) {

			} else if (newStatus.statusType == GlobalVariables.TYPE_STATUS_BURN) {

			} else if (newStatus.statusType == GlobalVariables.TYPE_STATUS_PARALYZE) {

			} else if (newStatus.statusType == GlobalVariables.TYPE_STATUS_FREEZE) {

			} else if (newStatus.statusType == GlobalVariables.TYPE_STATUS_CONFUSE) {
				resetLogic();
			} else if (newStatus.statusType == GlobalVariables.TYPE_STATUS_FEAR) {
				resetLogic();
			} else if (newStatus.statusType == GlobalVariables.TYPE_STATUS_TRANSMUTE) {
				resetLogic();
				applyTransmutationStats();
			}
		}


		public function checkStatuses(): void {

			if (_health <= 0) return;

			var stillPoisoned: Boolean = false;
			var stillBurned: Boolean = false;
			var stillParalyzed: Boolean = false;
			var stillFrozen: Boolean = false;
			var stillConfused: Boolean = false;
			var stillFeared: Boolean = false;
			var stillTransmuted: Boolean = false;

			for each(var status: IStatus in _statusEffects) {

				////trace("\nSTATUS CHECk\n" + status.statusType + ": " + status.duration + " turns");

				if (status.duration > 0) {

					if (status.statusType == GlobalVariables.TYPE_STATUS_POISON) {
						stillPoisoned = true;
					} else if (status.statusType == GlobalVariables.TYPE_STATUS_BURN) {
						stillBurned = true;
					} else if (status.statusType == GlobalVariables.TYPE_STATUS_PARALYZE) {
						stillParalyzed = true;
					} else if (status.statusType == GlobalVariables.TYPE_STATUS_FREEZE) {
						stillFrozen = true;
					} else if (status.statusType == GlobalVariables.TYPE_STATUS_CONFUSE) {
						stillConfused = true;
					} else if (status.statusType == GlobalVariables.TYPE_STATUS_FEAR) {
						stillFeared = true;
					} else if (status.statusType == GlobalVariables.TYPE_STATUS_TRANSMUTE) {
						stillTransmuted = true;
					}

					modHealth(-status.damagePerTurn);
				} else {
					_statusEffects.splice(_statusEffects.indexOf(status), 1);
				}


				// if still 'status' check for anim and add, if status finished, remove

				// poison -	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	
				if (stillPoisoned) {

					_isPoisoned = true;
					if (!_poisonGraphic) _poisonGraphic = new Anim_Poison();
					if (!_poisonGraphic.stage) addChild(_poisonGraphic);
					_poisonGraphic.gotoAndStop(int(Math.random() * _poisonGraphic.totalFrames));
					setChildIndex(_poisonGraphic, numChildren-1);

				} else {
					_isPoisoned = false;
					if (_poisonGraphic && _poisonGraphic.stage) removeChild(_poisonGraphic);
					if (_poisonGraphic) _poisonGraphic = null;
				}

				// burn -	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	
				if (stillBurned) {


					if (!_burnGraphic) _burnGraphic = new Anim_Burn();
					if (!_burnGraphic.stage) addChild(_burnGraphic);
					_burnGraphic.gotoAndStop(int(Math.random() * _burnGraphic.totalFrames));
					setChildIndex(_burnGraphic, numChildren-1);

				} else {
					_isBurned = false;
					if (_burnGraphic && _burnGraphic.stage) removeChild(_burnGraphic);
					if (_burnGraphic) _burnGraphic = null;
				}

				// paralyze -	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	
				if (stillParalyzed) {

					_isParalyzed = true;
					if (!_paralyzeGraphic) _paralyzeGraphic = new Anim_Paralyze();
					if (!_paralyzeGraphic.stage) addChild(_paralyzeGraphic);
					_paralyzeGraphic.gotoAndStop(int(Math.random() * _paralyzeGraphic.totalFrames));
					setChildIndex(_paralyzeGraphic, numChildren-1);

				} else {
					_isParalyzed = false;
					if (_paralyzeGraphic && _paralyzeGraphic.stage) removeChild(_paralyzeGraphic);
					if (_paralyzeGraphic) _paralyzeGraphic = null;
				}

				// freeze -	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	
				if (stillFrozen) {

					_isFrozen = true;
					if (!_freezeGraphic) _freezeGraphic = new Anim_Freeze();
					if (!_freezeGraphic.stage) addChild(_freezeGraphic);
					_freezeGraphic.gotoAndStop(int(Math.random() * _freezeGraphic.totalFrames));
					setChildIndex(_freezeGraphic, numChildren-1);

				} else {
					_isFrozen = false;
					if (_freezeGraphic && _freezeGraphic.stage) removeChild(_freezeGraphic);
					if (_freezeGraphic) _freezeGraphic = null;
				}

				// confuse -	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	
				if (stillConfused) {
					_isConfused = true;
					if (!_confuseGraphic) _confuseGraphic = new Anim_Confuse();
					if (!_confuseGraphic.stage) addChild(_confuseGraphic);
					_confuseGraphic.gotoAndStop(int(Math.random() * _confuseGraphic.totalFrames));
					setChildIndex(_confuseGraphic, numChildren-1);
					TARGET_TYPE = Monster;

				} else {
					_isConfused = false;
					if (_confuseGraphic && _confuseGraphic.stage) removeChild(_confuseGraphic);
					if (_confuseGraphic) _confuseGraphic = null;
					TARGET_TYPE = Adventurer;
				}


				// fear -	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	
				if (stillFeared) {

					_isFeared = true;
					if (!_fearGraphic) _fearGraphic = new Anim_Alert();
					if (!_fearGraphic.stage) addChild(_fearGraphic);
					_fearGraphic.gotoAndStop(int(Math.random() * _fearGraphic.totalFrames));
					setChildIndex(_fearGraphic, numChildren-1);

				} else {
					_isFeared = false;
					if (_fearGraphic && _fearGraphic.stage) removeChild(_fearGraphic);
					if (_fearGraphic) _fearGraphic = null;
				}


				// transmute -	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	
				if (stillTransmuted) {
					_isTransmuted = true;
					if (!_transmuteGraphic) _transmuteGraphic = new Anim_Chicken(); //mask
					if (!_transmuteGraphic.stage) parent.addChild(_transmuteGraphic);
					_transmuteGraphic.gotoAndStop(int(Math.random() * _transmuteGraphic.totalFrames));
					parent.setChildIndex(_transmuteGraphic, parent.numChildren-1);

					////trace(_transmuteGraphic.x, _transmuteGraphic.y, x,y);
					this.visible = false;

				} else {
					_isTransmuted = false;
					if (_transmuteGraphic && _transmuteGraphic.stage) parent.removeChild(_transmuteGraphic);
					if (_transmuteGraphic) _transmuteGraphic = null;
					this.visible = true;

					if (nameString == "Chicken") {
						removeTransmutationStats();
					}
				}

				status.duration = status.duration - 1;
			}
		}

		public function switchFrames(): void {

			if (_isFrozen || _isParalyzed) {
				return;
			}


			if (_isBattling) {
				if (currentFrame == 3) gotoAndStop(4);
				else gotoAndStop(3);
			} else {
				if (currentFrame == 1) gotoAndStop(2);
				else gotoAndStop(1);
			}

			setChildIndex(_healthBar, numChildren - 1);

			//////trace("switch to " + currentFrame);
		}

		public function get isBattling(): Boolean {
			return _isBattling;
		}

		public function get ui_name(): String {
			return _ui_name;
		}

		public function get ui_graphic(): * {
			return _ui_graphic;
		}

		public function get starLevel(): int {
			return _starLevel;
		}

		public function get abilities(): Array {
			return _abilities;
		}

		public function get goldCost(): int {
			return _goldCost;
		}

		public function setStats2($ui_name: String, $starLevel: int, $goldCost: int, $ui_graphic: int): void {
			_ui_name = $ui_name;
			_starLevel = $starLevel;

			/*_goldCost = $goldCost;
			_ui_graphic = $ui_graphic;*/

			_goldCost = $starLevel * $starLevel * 200;
			_ui_graphic = 1;

			_abilities = _attacks;
		}

		public function get notoriety(): int {
			var not: int = 0;

			not += (_maxHealth + (_maxMana / 4)) / 10;
			not += _attack + _magicAttack + defense + magicDefense + dexterity + sightDistance;

			////trace(this + " notoriety -> " + not);

			return not;
		}

		public function update(): void {

			//_nodesMovedThisTurn = 1;

			selectBestAttack();



			//switchFrames();

			////trace(this + " focus target: " + _focusTarget);
			////trace(this + " logic index: " + _logicIndex);




			if (_health <= 0) {
				die();
				return;
			}

			checkStatuses();
			if (_health <= 0) {
				return;
			}

			if (_isTransmuted) {
				if (Math.random() < .25) {
					if (tryUnoccupiedSpace()) followPath();
				}
				_transmuteGraphic.x = x;
				_transmuteGraphic.y = y;
				return;
			}

			//   - fight
			// 0 - (no path) scan room & find points of interest
			// 1 - follow path
			// 2 - no points of interest found, calculate new path.
			//   * WHILE POINTS OF INTEREST REMAIN*
			// 3 - (if hostile point of interest) move to spot in range, cast spell
			// 4 - (if friendly point of interest) move to location, interact
			// 5 - (no points of interest remain) scan room
			//

			////trace("\nUPDATE " + nameString + " @ " + _currentNode);
			//if (isBattling) {

			//	fight();


			if (_attritionTimer == _attritionTimerMax) {
				if (_health < _maxHealth) {
					modHealth(1);
					_attritionTimer = 0;
				}
			} else {
				_attritionTimer++;
			}

			if (_mana < _maxMana) {

				if (_magicDefense == 0) {
					_mana++
				} else {
					_mana += _magicDefense;
				}

				if (_mana > _maxMana) _mana = _maxMana;
			}

			if (_isFrozen || _isParalyzed) {
				return;
			}

			if (_isFeared) {
				if (!_currentPath || DungeonPathfinder.manhattan(_currentNode, _currentPath[_currentPath.length - 1]) < 2) {
					resetLogic();
					changePath(GraphicNode(DungeonPathfinder.findFarthestPoint(_currentNode, _currentNode, _sightDistance * 2)));
				}
				followPath();
				return;
			}


			if (_currentlySelectedAttack && _currentlySelectedAttack.isMagic && _currentlySelectedAttack.manaCost > _mana) {

				_isBattling = false;
				lookForDanger();
				followPath();
				return;
			}



			if (_logicIndex == 0) {

				//trace("\n" + nameString + ": scanning room - logic 0");
				scanRoom();
				
				if (DungeonPathfinder.manhattan(_currentNode, spawnPoint.currentNode) > 3) {
					setDestination(spawnPoint.currentNode);
					followPath();
				}

			} else if (_logicIndex == 1) {

				//trace("\n" + nameString + ": following path - logic 1");
				scanRoom();
				followPath();


			} else if (_logicIndex == 2) {

				_isLooking = true;

				//trace("\n" + nameString + ": no points of interest found, calculating new path - logic 2");

				if (Math.random() < .1) {
					//tryUnoccupiedSpace();
				}
				_logicIndex = 0;

			} else if (_logicIndex == 3) { // engage hostile

				if (_focusTarget.currentNode == null || _masterGrid.testRaycast(_currentNode, _focusTarget.currentNode)) {
					//trace(nameString + ": focus target null, resetting logic - logic 3");
					_movingInRange = false;
					resetLogic();
					return;
				}

				//find it
				// you have changed the fireball,
				// the path for attack

				scanRoom();

				if (_abilities.length == 0) {

					if (tryUnoccupiedSpace())followPath();
					return;
					
				}

				//trace("\n" + nameString + ": engaging hostile " + _focusTarget + " - logic 3");
				_movingInRange = true;
				if (changePathForAttack(_focusTarget.currentNode) == false) { // no change needed if false
					//trace(nameString + ": FIRE FIRE FIRE");
					attackTarget(_focusTarget);
					_focusTarget.focusTarget = this;
				} else {
					followPath();
				}


			} else if (_logicIndex == 4) { // engage friendly

				if (_focusTarget.currentNode == null) {
					//trace(nameString + ": focus target null, resetting logic  - logic 4");
					resetLogic();
					return;
				}

				scanRoom();

				//trace("\n" + nameString + ": engaging friendly " + _focusTarget + " - logic 4");
				changePath(_focusTarget.currentNode);
				followPath();

			} else if (_logicIndex == 5) { //  ***  engage heal  ***

				if (focusTarget.currentNode == null) {
					//trace(this + ": focus target null, resetting logic  - logic 5");
					_movingInRangeHeal = false;
					resetLogic();
					return;
				}

				scanRoom();

				//trace("\n" + this + ": engaging heal -> " + focusTarget + " - logic 5");
				_movingInRangeHeal = true;
				if (changePathForAttack(focusTarget.currentNode) == false || focusTarget == this) { // no change needed if false
					//trace(this + ": HEAL HEAL HEAL - logic 5");
					heal();

				} else {
					followPath();
				}
			}



			if (_lastNode) {
				if (_lastNode != _currentNode) {
					if (_lastNode.col > _currentNode.col) {
						scaleX = 1;
					} else if (_lastNode.col < _currentNode.col) {
						scaleX = -1;
					}
				}
			}

			_lastNode = _currentNode;
		}



		public function resetLogic(): void {
			_focusTarget = null;
			_logicIndex = 0;
			_previousNodes = [];
			_isBattling = false;
			_isHealing = false;
			_healTargets = [];
		}

		public function get isTransmuted(): Boolean {
			return _isTransmuted;
		}

		public function followPath(): void {

			//trace("\n" + nameString + ": commence follow path");

			if (_currentPath == null || _pathIndex > _currentPath.length - 1) {
				resetLogic();
				return;
			}

			if (_currentPath[_pathIndex].isOccupied) {

				var occ = _currentPath[_pathIndex].occupier;
				////trace(nameString + ": square occupied by: " + occ);

				if (occ == _focusTarget) { // watch this
					////trace(nameString + ": Focus Target found, clearing focus target");
					_focusTarget = null;
					_logicIndex = 0;
				}

				if ((occ is IDoor && occ.isOpen) || (occ is IChest && occ.isEmpty) || occ is ITrap || occ is SpawnPoint || occ is EmptySlot) {



				} else if (occ is oppositeOfTargetType) {

					if (_currentPath[_pathIndex].units > 1) {
						tryUnoccupiedSpace();
						return;
					}

				} else {



					if (occ is TARGET_TYPE) {

						attackTarget(occ);

					} else {

						if (tryUnoccupiedSpace()) {
							//followPath();
						}
					}

					return;
				}

			}

			////trace(nameString + ": --- not occupied, moving toward " + _endNode);

			_currentNode.exitNode(this);
			_currentNode = _currentPath[_pathIndex];
			_currentNode.enterNode(this);

			////trace(nameString + ":  -> entered node " + _currentNode.col, _currentNode.row);

			_pathIndex++;

			if (_pathIndex > _currentPath.length - 1) {
				resetLogic();
				return;
			}

			if (_currentNode == _endNode) {
				////trace(nameString + ":  * * * destination reached @ " + _currentNode);
				if (_isLooking) {
					_logicIndex = 2;
				} else if (_movingInRange || _movingInRangeHeal) {
					////trace(nameString + ": In range, prepare for attack");
				} else if (_focusTarget) {
					////trace(nameString + ": HERE !!!");
				} else {
					_logicIndex = 0;
				}
			}
			/*
			if (_nodesMovedThisTurn == 1 && _dexterity > 15) {

				//trace("FOLLOWING PATH #2 - " + _currentNode);
				followPath();
				//trace("COMPLETED FOLLOW PATH #2 - " + _currentNode);
			}
			
			_nodesMovedThisTurn ++;*/
		}


		public function setDestination(destNode: GraphicNode): void {

			////trace(nameString + ": setDestination : " + destNode.col, destNode.row);

			currentPath = DungeonPathfinder.findPath(_currentNode, destNode);
		}

		/// CONFUSE & OTHER STATUSES

		public function get oppositeOfTargetType(): Class {
			if (TARGET_TYPE == Adventurer) {
				return Monster;
			} else {
				return Adventurer;
			}
		}

		public function get healTarget(): * {

			if (_healTargets.length > 0) {
				return _healTargets[0];
			} else {
				return;
			}
		}

		public function addHealTarget(target: * ): void {
			////trace("");
			////trace(this + ": adding heal target - " + target);

			if (_healTargets.indexOf(target) < 0) {
				_healTargets.push(target);
			} else {
				////trace("\n		*** BAD HEAL TARGET ***\n");
			}

			////trace(this + ": _healTargets - " + _healTargets);
		}

		public function removeHealTarget(target: * ): Boolean {
			////trace("");
			////trace(this + ": removing heal target - " + target);

			var tempIndex: int = _healTargets.indexOf(target);

			if (tempIndex >= 0) {
				_healTargets.removeAt(tempIndex);
			}

			if (_healTargets.length < 1) {
				_isHealing = false;
			}

			////trace(this + ": _healTargets - " + _healTargets);
			////trace(this + ": _isHealing - " + _isHealing);

			return _isHealing;
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

			////trace(nameString + ": currentPath set, new destination: " + _endNode.col, _endNode.row);

			_pathIndex = 0;
		}


		public function tryUnoccupiedSpace(): Boolean {
			var tempArray: Array = DungeonPathfinder.getNodesInAreaUnoccupied(_currentNode, _masterGrid);
			////trace("					UNOCCUPIED SPACES " + tempArray);
			if (tempArray.length > 0) {
				setDestination(tempArray[int(Math.random() * tempArray.length)]);
				return true;
			} else {
				return false;
			}
		}

		public function scanRoom(): void {
			//trace("\n" + nameString + ": commence scan room - normal");

			if (isHealer) {
				scanRoomHealer();
				return;
			}

			//trace(nameString + ": focus target: " + _focusTarget);

			var nodesInArea: Array = DungeonPathfinder.getNodesInArea(_currentNode, _sightDistance);
			_thingsOfInterest = [];

			for (var i: int = 0; i < nodesInArea.length; i++) {
				var tempNode: GraphicNode = nodesInArea[i];

				if (tempNode.isOccupied) {
					var occ = tempNode.occupier;
					
					//trace(nameString + " - unit in sight: " + occ);

					if (occ is TARGET_TYPE) {

						if (_masterGrid.testRaycast(_currentNode, tempNode)) {

							//trace(nameString + ": failed raycast on " + occ + ", continuing.");
							continue;
						}
						_thingsOfInterest.push(nodesInArea[i]);
						//trace(nameString + ": adding " + occ + " to things of interest.");
					}
				}
			}
			
			//trace(nameString + ": - interests found: " + _thingsOfInterest);

			if (_thingsOfInterest.length > 0) {

				var poi;

				if (_focusTarget) { // if focus target disappears then they are confused

					if (_focusTarget.stage == null) {
						_focusTarget = null;
					} else {
						_thingsOfInterest.push(_focusTarget.currentNode);
					}
				}

				if (_thingsOfInterest.length > 1) {
					var closest: GraphicNode = DungeonPathfinder.closestPoint(_currentNode, _thingsOfInterest) as GraphicNode;
					poi = closest.occupier;
				} else if (_thingsOfInterest.length == 1) {
					poi = _thingsOfInterest[0].occupier;
				}

				//trace(nameString + ": set course for - " + poi + " @ " + poi.currentNode.col, poi.currentNode.row);
				_focusTarget = poi;

				////trace(nameString + ": _previousNodes emptied");
				_previousNodes = [];
				_isLooking = false;

				currentPath = DungeonPathfinder.findPath(_currentNode, _focusTarget.currentNode);

				if (poi is TARGET_TYPE) {
					_logicIndex = 3;
				} else {
					_logicIndex = 4;
				}

			}


			if (_focusTarget == null) {
				//trace(nameString + ": isLooking - " + _isLooking);
				if (tryUnoccupiedSpace() && Math.random() < (.2 + (_dexterity / 25))) {
					followPath();
				}

				_logicIndex = 0;


			} else {
				if (_focusTarget is TARGET_TYPE) {
					_logicIndex = 3;
				}
			}

			selectBestAttack();
		}

		// check for if any attacks are healing
		public function get hasHealing(): Boolean {
			if (_hasHealing == 0) {

				// test and store result
				for each(var w: Weapon in _attacks) {
					if (w.isHealing) {
						_hasHealing = 1;
						return true;
					}
				}

				_hasHealing = -1;
				return false;
			} else if (_hasHealing == 1) {
				return true;
			} else { //if (_hasHealing == -1)
				return false;
			}
		}

		public function get bestHeal(): Weapon {

			////trace("\nSelecting Best Heal");

			if (_attacks.length == 1) return _attacks[0];

			var bestHeals: Weapon;
			var thisHeals: Weapon;
			var hpmBest: Number;
			var hpmThis: Number;

			var bestIndex: int = 0;
			while (!bestHeals || !bestHeals.isHealing) {
				bestHeals = _attacks[bestIndex];
				bestIndex++;
				if (bestIndex == _attacks.length) {
					break;
				}
			}
			////trace(" + bestHeals - start: " + bestHeals);
			hpmBest = bestHeals.numDice * bestHeals.numSides / bestHeals.manaCost;
			////trace(" + hpmBest - start: " + hpmBest);
			for (var i: int = bestIndex; i < _attacks.length; i++) {
				thisHeals = _attacks[i];
				////trace(" - thisHeals - test: " + thisHeals);
				if (!thisHeals.isHealing) {
					////trace(" - " + thisHeals + " is not healing, continue.");
					continue;
				}
				hpmThis = thisHeals.numDice * thisHeals.numSides / thisHeals.manaCost;
				////trace(" - hpmThis - test: " + hpmThis);
				if (hpmThis > hpmBest || (bestHeals.manaCost > _mana && thisHeals.manaCost <= _mana)) {
					bestHeals = thisHeals;
					////trace("Test heal is better choice, set to best.");
					////trace(" -> bestHeals: " + bestHeals);
				}
			}
			////trace("Returning " + bestHeals);
			return bestHeals;
		}

		public function selectBestAttack(): void { // -- 1 - remove omit

			if (_attacks.length == 0) return;

			//if (_currentlySelectedAttack) ////trace(nameString + ": currently selected attack - " + _currentlySelectedAttack.animation);


			// -- 2 vv

			// omit healing if targeting enemy
			var omitHealing: Boolean = false;

			if (_focusTarget is TARGET_TYPE) {
				omitHealing = true;
			}

			var bestIndex: int = 0;
			var bestAttack: Weapon;

			if (omitHealing) { // find first non healing
				while (!bestAttack || bestAttack.isHealing) {
					bestAttack = _attacks[bestIndex];
					bestIndex++;
					if (bestIndex == _attacks.length) {
						break;
					}
				}
			} else {
				bestAttack = _attacks[0];
			}

			// -- 2 ^^

			var thisAttack: Weapon;
			var dpmBest: int;
			var dpmThis: int;
			var damageBest: int;
			var damageThis: int;

			var chooseMostDamage: Boolean = false;

			// find it change 1
			if (focusTarget && focusTarget.currentNode && focusTarget is TARGET_TYPE) {
				if (focusTarget.stage) {
					var dist: int = DungeonPathfinder.manhattan(_currentNode, focusTarget.currentNode);
					if (dist == 1) {
						chooseMostDamage = true;
					}
				} else {
					return;
				}
			}


			for (var i: int = bestIndex; i < _attacks.length; i++) {
				thisAttack = _attacks[i];

				if (thisAttack.isHealing && omitHealing) continue; //3


				if (bestAttack.isRanged && chooseMostDamage == false) {

					if (thisAttack.isRanged) {

						if (bestAttack.isMagic) {

							if (thisAttack.isMagic) {

								dpmBest = bestAttack.numDice * bestAttack.numSides / bestAttack.manaCost;
								dpmThis = thisAttack.numDice * thisAttack.numSides / thisAttack.manaCost;

								if ((bestAttack.manaCost > _mana && thisAttack.manaCost < _mana) || (dpmThis > dpmBest && thisAttack.manaCost < _mana)) {
									bestAttack = thisAttack;
								}

							} else { // this attack is not magic but best is, compare damage

								damageBest = bestAttack.numDice * bestAttack.numSides;
								damageThis = thisAttack.numDice * thisAttack.numSides;
								if (damageThis > damageBest || bestAttack.manaCost > _mana) {
									bestAttack = thisAttack;
								}
							}
						} else { // best attack is not magic, compare damage

							if (thisAttack.isMagic && thisAttack.manaCost > _mana) {
								continue;
							}
							damageBest = bestAttack.numDice * bestAttack.numSides;
							damageThis = thisAttack.numDice * thisAttack.numSides;
							if (damageThis > damageBest) {
								bestAttack = thisAttack;
							}
						}

					} else { // if this attack isnt ranged and best is
						if (bestAttack.isMagic && bestAttack.manaCost > _mana) {
							bestAttack = thisAttack;
						}
					}
				} else { // if best attack isnt ranged (or chooseMostDamage == true)

					if (thisAttack.isRanged && chooseMostDamage == false) {

						if (thisAttack.isMagic && thisAttack.manaCost > _mana) {
							continue;
						} else {
							bestAttack = thisAttack;
						}

					} else { // if neither are ranged (or chooseMostDamage == true), compare damage

						damageBest = bestAttack.numDice * bestAttack.numSides;
						damageThis = thisAttack.numDice * thisAttack.numSides;

						if ((thisAttack.isMagic || thisAttack.isHealing) && thisAttack.manaCost > _mana) continue;

						if (damageThis > damageBest || (bestAttack.isMagic && bestAttack.manaCost > _mana)) {
							bestAttack = thisAttack;
						}
					}
				}
			} // end for loop

			////trace(nameString + ": new best attack - " + bestAttack.animation);
			_currentlySelectedAttack = bestAttack;
		}

		/*
			- import
			- save file
			- var at top
			- var inst at bottom
			- false ++
			- method
		*/

		public function setStats(maxHealth: int, maxMana: int, atk: int, mAtk: int, def: int, mDef: int, dex: int, sightDist: int): void {

			_maxHealth = maxHealth;
			_health = maxHealth;
			_maxMana = maxMana;
			_mana = maxMana;
			_attack = atk;
			_magicAttack = mAtk;
			_defense = def;
			_magicDefense = mDef;
			_dexterity = dex;
			_sightDistance = sightDist;

			_healthBar.setMaxHealth(maxHealth);
		}

		public function setStatsTransmute(maxHealth: int, health: int, maxMana: int, mana: int, atk: int, mAtk: int, def: int, mDef: int, dex: int, sightDist: int): void {

			_maxHealth = maxHealth;
			_health = maxHealth;
			_maxMana = maxMana;
			_mana = maxMana;
			_attack = atk;
			_magicAttack = mAtk;
			_defense = def;
			_magicDefense = mDef;
			_dexterity = dex;
			_sightDistance = sightDist;

			_healthBar.setMaxHealth(maxHealth);
		}

		public function attackTarget(target: * ): void {
			////trace(nameString + ": Attacking " + String(target) + "!");

			if (_currentlySelectedAttack.isHealing) {
				if (_attacks.length == 1) return; // only heals available
				selectBestAttack();
			}


			// find it
			if (_currentlySelectedAttack.status && _currentlySelectedAttack.status.statusType == GlobalVariables.TYPE_STATUS_TRANSMUTE && target.isTransmuted == true) {
				selectBestAttack();
				_isBattling = false;
				return;
			}

			if (_masterGrid.testRaycast(_currentNode, target.currentNode)) {
				return;
			}

			if (!_currentNode || !target.currentNode) return;



			if (_currentNode.col > target.currentNode.col) {
				scaleX = 1;
			} else if (_currentNode.col < target.currentNode.col) {
				scaleX = -1;
			}


			var dist: int = DungeonPathfinder.manhattan(_currentNode, target.currentNode);
			////trace(nameString + ": distance btw - " + dist + " of weapon range " + _currentlySelectedAttack.range);
			if (dist <= _currentlySelectedAttack.range) {

				var damageMod: int;

				if (_currentlySelectedAttack.isMagic) {
					if (_currentlySelectedAttack.manaCost > _mana) {
						////trace(nameString + ": NOT ENOUGH MANA")
						return;
					} else {
						_mana -= _currentlySelectedAttack.manaCost;
					}
					damageMod = _magicAttack;

				} else if (_currentlySelectedAttack.isRanged) {
					damageMod = _dexterity;

				} else {
					damageMod = _attack;
				}

				if (_currentlySelectedAttack.damage > 0) var attackDamage: int = _currentlySelectedAttack.damage + damageMod;

				////trace("attackDamage: " + attackDamage);

				if (_currentlySelectedAttack.status) {
					//_currentlySelectedAttack.status.roll()
					//new _currentlySelectedAttack.status(target, 5, 20, _dm);
					target.applyStatus(_currentlySelectedAttack.status);
				}

				if (_isBattling == false) _isBattling = true;

				_currentlySelectedAttack.animate(this, target);

				if (target.calculateDamage(attackDamage, _currentlySelectedAttack.isMagic) == false) {

					
					
					if (target is Adventurer) { // used for confuse
						GlobalVariables.instance.dungeonAlertPanel.newAlert_MonsterDefeatedAdventurer(nameString, target.nameString);
						_masterGrid.gameplayScreen.earnGold(target.gold);
					} else {
						
					}
					
					_isBattling = false;

					GlobalUnlockTracker.instance.registerKillWith(this);


				} else {

				}
			}
		}


		public function calculateDamage(incomingAttack: int, isMagic: Boolean = false): Boolean {

			////trace(nameString + ": Calculating damage");
			var defenseMod: int;

			if (isMagic) {
				defenseMod = _magicDefense;
			} else {
				defenseMod = _defense;
			}

			var newDamage: int = incomingAttack - defenseMod; // - armor.defense;

			////trace(nameString + ": newDamage: " + newDamage);

			if (newDamage > 0) {
				_health -= newDamage;
				_healthBar.addSub(-newDamage);
			}

			////trace(nameString + ": " + newDamage + " damage received. Health remaining: " + health);
			//_dm._isPaused = true;

			if (health <= 0) {

				die();
				return false;
			}

			return true;
		}

		public function modHealth(plusMinus: int): Boolean {

			////trace(nameString + ": - subbing from " + _health);
			_health += plusMinus;
			_healthBar.addSub(plusMinus);

			if (health <= 0) {
				die();
				return false;
			}

			return true;
		}

		public function die(): void {

			/*if(_waitOneTurn) {
				_waitOneTurn = false;
				return;
			}*/

			//trace("!!! " + this + " IS DEAD !!!");

			if (_transmuteGraphic && _transmuteGraphic.stage) parent.removeChild(_transmuteGraphic);
			if (_transmuteGraphic) _transmuteGraphic = null;

			if (_currentNode) {
				_masterGrid.addChild(new DieGhost(_currentNode));
				GlobalSounds.instance.randomOuch_Monster();
				_masterGrid.removeGameElement(this);
			}
		}

		public function changePath(newNode: GraphicNode): void {
			////trace(nameString + ": Changing path to destination " + newNode.col, newNode.row);
			var newPath = DungeonPathfinder.findPath(_currentNode, newNode);
			currentPath = newPath;
			_pathIndex = 0;
		}

		public function changePathForAttack(newNode: GraphicNode): Boolean {
			////trace(nameString + ": Changing path to node within attack range of " + newNode);
			//var newPath = DungeonPathfinder.findRangedPath(_currentNode, newNode, _attackRange);//for straight lines
			var newPath = DungeonPathfinder.findPath(_currentNode, DungeonPathfinder.findClosestWithinRange(_currentNode, newNode, _currentlySelectedAttack.range));
			////trace(nameString + ": NEW PATH - " + newPath);
			if (newPath.length > 1) {
				currentPath = newPath;
				_pathIndex = 0;
				return true;
			} else {

				// we stand on a spot in range, raycast

				//if (_masterGrid.testRaycast(_currentNode, newNode)) {
				//	////trace("WALL IN THE WAY");
				//	setDestination(newNode);
				//	//followPath();
				//	return true;
				//} 

				////trace(nameString + ": No change of path needed! Ready to attack!");
				return false;
			}
		}

		public function lookForDanger(): void {

			if (stage) {
				var dangerFound: Boolean = false;
				var danger;
				var newPath: Array;
				var farthestPoint;

				var _nodesInSight = DungeonPathfinder.getNodesInArea(_currentNode, _sightDistance);

				for (var i: int = 0; i < _nodesInSight.length; i++) {

					if (_nodesInSight[i].isOccupied) {

						var occ2 = _nodesInSight[i].occupier;

						if (occ2 is TARGET_TYPE) {

							if (_masterGrid.testRaycast(_currentNode, _nodesInSight[i])) continue;

							danger = occ2;
							dangerFound = true;
							_logicIndex = 1;
						}
					}
				}

				if (dangerFound) {

					farthestPoint = DungeonPathfinder.findFarthestPoint(_currentNode, danger.currentNode, _sightDistance);
					newPath = DungeonPathfinder.findPath(_currentNode, farthestPoint);
					currentPath = newPath;

					addChild(new Animation(Anim_Alert, _currentNode));

				} else {
					_logicIndex = 0;

					if (Math.random() < .2) tryUnoccupiedSpace();
				}
			}
		}

		public function scanRoomHealer(): void {
			//trace("\n" + this + ": commence scanning as healer");

			//trace(this + ": focus target: " + focusTarget);

			var nodesInArea: Array = DungeonPathfinder.getNodesInArea(_currentNode, _sightDistance);
			_thingsOfInterest = [];

			if (_focusTarget && _focusTarget.stage) _thingsOfInterest.push(_focusTarget);

			for (var i: int = 0; i < nodesInArea.length; i++) {
				var tempNode: GraphicNode = nodesInArea[i];

				if (tempNode.isOccupied) {
					var occ = tempNode.occupier;

					if (occ == _focusTarget) {
						continue;
					} else if (occ is TARGET_TYPE || occ is oppositeOfTargetType) {

						if (_masterGrid.testRaycast(_currentNode, tempNode)) continue;
						_thingsOfInterest.push(nodesInArea[i].occupier);
					}
				}
			}

			if (_thingsOfInterest.length > 0) {
				//trace(this + ": - interests found: " + _thingsOfInterest);

				var advArray: Array = new Array();
				var hArray: Array = new Array();
				var h: DisplayObject;
				var a: DisplayObject;
				var poi: * ;

				if (_focusTarget) { // if focus target disappears then they are confused

					if (_focusTarget.stage == null) {
						_focusTarget = null;
					} else if (_focusTarget is oppositeOfTargetType && _focusTarget.percentHealth < .6) {
						hArray.push(_focusTarget.currentNode);
					} else if (_focusTarget is TARGET_TYPE) {
						advArray.push(_focusTarget.currentNode);
					}
				}

				for (var j: int = 0; j < _thingsOfInterest.length; j++) {
					_currentThing = _thingsOfInterest[j];

					//trace("Current Thing of Interest: " + _currentThing);
					//trace("TARGET_TYPE: " + TARGET_TYPE);
					//trace("oppositeOfTargetType: " + oppositeOfTargetType);


					if (_currentThing is oppositeOfTargetType && _currentThing.percentHealth < .6) {
						hArray.push(_currentThing.currentNode);
					} else if (_currentThing is TARGET_TYPE) {
						advArray.push(_currentThing.currentNode);
					}
				}
				
				// add self to heal array
				if (_health < _maxHealth/3) hArray.push(_currentNode);

				//trace("Heal Array: " + hArray);
				//trace("Adv Array: " + advArray);

				if (hArray.length > 1) {
					var mostInNeed: GraphicNode = hArray[0];
					for (var k: int = 1; k < hArray.length; k++) {
						var least = oppositeOfTargetType(mostInNeed.occupier).health / oppositeOfTargetType(mostInNeed.occupier).maxHealth;
						var test = oppositeOfTargetType(hArray[k].occupier).health / oppositeOfTargetType(hArray[k].occupier).maxHealth;
						if (test < least) {
							mostInNeed = hArray[k];
						}
					}
					h = mostInNeed.occupier;
				} else if (hArray.length == 1 && hArray[0]) {
					h = hArray[0].occupier;
				}

				if (advArray.length > 1) {
					var closest: GraphicNode = DungeonPathfinder.closestPoint(_currentNode, advArray) as GraphicNode;
					a = closest.occupier;
				} else if (advArray.length == 1 && advArray[0]) {
					a = advArray[0].occupier;
				}


				if (h) {
					poi = h;

				} else if (a) {
					poi = a;

				}

				if (poi) {

					//trace(this + ": set course for POI - " + poi + " @ " + poi.currentNode.row, poi.currentNode.col);
					_focusTarget = poi;

					////trace(this + ": _previousNodes emptied");
					_previousNodes = [];
					_isLooking = false;

					if (poi is oppositeOfTargetType) {

						_currentlySelectedAttack = bestHeal;

						addHealTarget(poi);
						currentPath = DungeonPathfinder.findPath(_currentNode, DungeonPathfinder.findClosestWithinRange(_currentNode, poi.currentNode, _currentlySelectedAttack.range));
						_logicIndex = 5;

					} else {

						currentPath = DungeonPathfinder.findPath(_currentNode, focusTarget.currentNode);

						if (poi is TARGET_TYPE) {
							_logicIndex = 3;
						} else {
							_logicIndex = 4;
						}
					}
				}
			} else {
				//trace("NO THINGS OF INTEREST");
			}


			if (focusTarget == null) {
				//trace("isLooking: " + _isLooking);

				if (tryUnoccupiedSpace() && Math.random() < (.2 + (_dexterity / 25))) {
					//followPath();
				}

				if (_isLooking == false) {
					_logicIndex = 2;
				} else if (_isLooking == true) {
					_logicIndex = 1;
				}
			}
		}

		public function get percentHealth(): Number {
			return _health / _maxHealth;
		}

		public function heal(): void {
			////trace(this + ": Healing " + String(healTarget) + "!");
			var currentHTLocation: GraphicNode = healTarget.currentNode;

			_currentlySelectedAttack = bestHeal;

			if (currentHTLocation == null) {
				////trace(this + ": Heal target " + healTarget + " location is null, removing");
				removeHealTarget(healTarget);
				return;
			}

			////trace(healTarget.health, healTarget.maxHealth);

			////trace("\n * * * HEALING WITH: " + _currentlySelectedAttack + "\n * * *");

			if (_mana < _currentlySelectedAttack.manaCost) return;

			if (healTarget.health < healTarget.maxHealth) {

				_currentlySelectedAttack.animate(this, healTarget);

				_mana -= _currentlySelectedAttack.manaCost;

				////trace(this + ": " + healTarget + " before: " + healTarget.health);
				healTarget.calculateHealing(_currentlySelectedAttack.damage);

				//healTarget.health -= healTarget.health % healTarget.maxHealth;
				////trace(this + ": " + healTarget + " after: " + healTarget.health);
			}
		}

		public function calculateHealing(healingPoints: int): void {

			var healthBefore: int = _health;

			_health += healingPoints;
			if (_health > _maxHealth) _health = _maxHealth;
			_healthBar.set(_health);

			var changeInHealth: int = _health - healthBefore;
			GlobalUnlockTracker.instance.registerTotalHealingIncrease(changeInHealth);
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

		public function set focusTarget(value: IGameUnit): void {
			_focusTarget = value;
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

		public function get focusTarget(): * {
			return _focusTarget;
		}

		public function get value(): int {
			return _value;
		}

		public function get masterGrid(): MasterGrid {
			return _masterGrid;
		}

		public function get currentNode(): GraphicNode {
			return _currentNode;
		}

		public function get currentPath(): Array {
			return _currentPath;
		}

		public function set currentNode(value: GraphicNode): void {
			_currentNode = value;
		}

		public function get isFrozen(): Boolean {
			return _isFrozen;
		}

		public function set isFrozen(value: Boolean): void {
			_isFrozen = value;
		}

		override public function toString(): String {
			return (nameString + " @ " + _currentNode);
		}

		public function destroy(): void {

			_statusEffects = null;

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

			GlobalVariables.instance.graphicsTimer.removeEventListener(TimerEvent.TIMER, onGraphicsTick);
		}
	}

}
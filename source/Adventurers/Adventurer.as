package {

	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;

	// spawn points
	// ranged attacks
	// boss door / key
	// status effects

	public class Adventurer extends MovieClip implements IAdventurer, IUpdatable, IGameUnit {

		private static const RETREAT_IF_NO_CHESTS: Boolean = false;

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

		private var _isStuck: Boolean = false;

		private var _isRetreating: Boolean = false;
		private var _retreatThreshold: int = .2;
		private var _dungeonEntrance: * ;

		private var _logicIndex: int = 0;
		private var _pathIndex: int = 0;

		private var _currentPath: Array;

		private var _focusTarget: * ;


		private var _hasHealing: int = 0;

		private var _attritionTimer: int = 0;
		private var _attritionTimerMax: int = 8;


		public var _currentlySelectedAttack: IWeapon;
		public var _attacks: Array = [];
		private var _armor: * ;


		private var _starLevel: int;

		//public var 

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
		private var _sightDistance: int;

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
		private var stored_gold: int;

		private var stored_nameString: String;
		private var stored_starLevel: int;

		public var _healthBar: HealthBar;

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


		private var _healTargets: Array = [];

		private var _unscannedNodes: Array;

		private var _lastNode: GraphicNode;

		private var _gold: int;


		private var _statusEffects: Array;
		private var _statusGraphics: Array;

		private var _isLooking: Boolean;
		private var _movingInRange: Boolean = false;
		private var _movingInRangeHeal: Boolean = false;

		private var _isBattling: Boolean;
		private var _isHealing: Boolean;

		public var nameString: String;
		public var sex: String;

		private var _minimumSearchTime: int = 30;
		private var _timeSearched: int = 0;

		public function Adventurer(mg: MasterGrid): void {

			_masterGrid = mg;

			_dm = _masterGrid.gameplayScreen.dm;
			_gameElements = _masterGrid.gameElements;

			gotoAndStop(1);

			_thingsOfInterest = [];

			gold = Math.random() * 300;

			_isBattling = false;
			_isHealing = false;

			_statusEffects = [];
			_statusGraphics = [];

			_healthBar = new HealthBar();
			addChild(_healthBar);
			_healthBar.x = -10;
			_healthBar.y = -15;

			nameString = "ADV";

			// stauts
			TARGET_TYPE = Monster;
			_poisonTimer = 0;
			_burnTimer = 0;
			_paralyzeTimer = 0;
			_freezeTimer = 0;
			_confuseTimer = 0;
			_fearTimer = 0;
			_transmuteTimer = 0;

			////trace("Adventurer Created");

			//get and store unscanned nodes
			_unscannedNodes = _masterGrid.floors.concat();

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
		}

		public function onAddedToStage(e: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			GlobalVariables.instance.graphicsTimer.addEventListener(TimerEvent.TIMER, onGraphicsTick, false, 0, true);
		}

		public function onGraphicsTick(tE: TimerEvent): void {
			switchFrames();
		}

		public function get isHealer(): Boolean {
			if (hasHealing && bestHeal.manaCost < _mana) {
				return true;
			} else {
				return false;
			}
		}

		public function get isTransmuted(): Boolean {
			return _isTransmuted;
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

			setStatsTransmute(20, 20 * healthRatio, 0, 0, 0, 0, 0, 0, 0, 2, gold);

			nameString = "Chicken";
			setStats2(1);
		}

		public function removeTransmutationStats(): void {

			var healthRatio = _health / _maxHealth;
			var newHealth = stored_maxHealth * healthRatio;

			////trace("_health: " + _health);
			////trace("newHealth: " + newHealth);

			setStatsTransmute(stored_maxHealth, newHealth, stored_maxMana, stored_mana, stored_attack, stored_magicAttack, stored_defense, stored_magicDefense, stored_dexterity, stored_sightDistance, gold);
			nameString = stored_nameString;
			setStats2(stored_starLevel);
		}

		public function setStatsTransmute(maxHealth: int, health: int, maxMana: int, mana: int, atk: int, mAtk: int, def: int, mDef: int, dex: int, sightDist: int, gold: int): void {

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
			_gold = gold;

			_healthBar.setMaxHealth(maxHealth);
		}


		public function applyStatus(newStatus: IStatus): void {

			////trace("\n	-	-	" + nameString);
			////trace("Applying New Status: " + newStatus);
			////trace("Chance: " + newStatus.percentChance);

			if (Math.random() < newStatus.percentChance) {
				////trace("Roll Successful, Adding Status");
				////trace("Status: "+ newStatus);
				////trace("Duration: " + newStatus.duration);

				GlobalUnlockTracker.instance.registerStatus(newStatus.statusType);
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

			var stillPoisoned: Boolean = false;
			var stillBurned: Boolean = false;
			var stillParalyzed: Boolean = false;
			var stillFrozen: Boolean = false;
			var stillConfused: Boolean = false;
			var stillFeared: Boolean = false;
			var stillTransmuted: Boolean = false;

			for each(var status: IStatus in _statusEffects) {

				////trace("\nSTATUS CHECk\n" + status.statusType + ": " + status.durationTimer + " turns");

				if (status.durationTimer > 0) {

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
					
					if (_health <= 0) {
						GlobalVariables.instance.dungeonAlertPanel.newAlert_AdventurerDefeatedByStatus(nameString, status.statusType);
						GlobalVariables.gameplayScreen.earnGold(gold);
						return;
					}

				} else {
					_statusEffects.splice(_statusEffects.indexOf(status), 1);
					//status.durationTimer = status.duration;
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
					TARGET_TYPE = Adventurer;

				} else {
					_isConfused = false;
					if (_confuseGraphic && _confuseGraphic.stage) removeChild(_confuseGraphic);
					if (_confuseGraphic) _confuseGraphic = null;
					TARGET_TYPE = Monster;
				}


				// fear -	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	
				if (stillFeared) {
					_isFeared = true;
					if (!_fearGraphic) _fearGraphic = new Anim_Fear();
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

				status.durationTimer = status.durationTimer - 1;
			}
		}

		public function get oppositeOfTargetType(): Class {
			if (TARGET_TYPE == Monster) {
				return Adventurer;
			} else {
				return Monster;
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
				_healTargets.splice(tempIndex, 1);
			}

			if (_healTargets.length < 1) {
				_isHealing = false;
			}

			////trace(this + ": _healTargets - " + _healTargets);
			////trace(this + ": _isHealing - " + _isHealing);

			return _isHealing;
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

			////trace("switch to " + currentFrame);
		}

		public function get isBattling(): Boolean {
			return _isBattling;
		}

		public function get ui_name(): String {
			return nameString;
		}

		public function get notoriety(): int {
			var not: int = 0;

			not += (_maxHealth + (_maxMana / 4)) / 10;
			not += _attack + _magicAttack + defense + magicDefense + dexterity + sightDistance;

			////trace(this + " notoriety -> " + not);

			return not;
		}

		public function retreat(): void {
			if (_currentNode == _masterGrid.entrance && _isFeared == false) {
				////trace("Exit dungeon on retreat");
				exitDungeon();
			} else {

				//if (!isDungeonComplete() && (health > maxHealth * _retreatThreshold)) {

				//	_isRetreating = false;
				//}

				selectBestAttack();
				changePath(_masterGrid.entrance);
				followPath();
			}
		}


		public function update(): void {

			if (_health <= 0 || _currentNode == null) {
				die();
				return;
			}


			////trace("_isRetreating: "+ _isRetreating);

			////trace(this.name + " num unscanned: " + _unscannedNodes.length);

			selectBestAttack();

			//if (!stage) return;

			if (focusTarget) {
				if ((!focusTarget.stage) || (_focusTarget && _masterGrid.testRaycast(_currentNode, _focusTarget.currentNode))) {
					resetLogic();
					return;
				}
			}

			if (isDungeonComplete() || _health / _maxHealth < _retreatThreshold) {

				_isRetreating = true;
			} else {
				//_isRetreating = false;
			}

			checkStatuses();

			if (_health <= 0 || _currentNode == null) {
				die();
				return;
			}


			


			/*if (RETREAT_IF_NO_CHESTS) {
				if (_masterGrid.checkForChestsRemaining() == false) {
					_isRetreating = true;
				}
			}*/

			if (_attritionTimer == _attritionTimerMax) {
				modHealth(-100);
				_attritionTimer = 0;
				if (_health <= 0) {
					
					//GlobalUnlockTracker.instance.registerDeath(this);
					GlobalVariables.instance.dungeonAlertPanel.newAlert_MonsterDefeatedAdventurer("The Dungeon", nameString);
					GlobalVariables.gameplayScreen.earnGold(gold);
					return;
				}
			} else {
				_attritionTimer++;
			}
			
			if (_isTransmuted) {
				if (Math.random() < .25) {
					if (tryUnoccupiedSpace()) followPath();
				}
				_transmuteGraphic.x = x;
				_transmuteGraphic.y = y;
				return;
			}

			if (_mana < _maxMana) {
				_mana += _magicDefense;
				if (_mana > _maxMana) _mana = _maxMana;
			}

			if (_isFrozen || _isParalyzed) {
				return;
			}

			//switchFrames();

			////trace("\nUPDATE " + this);
			////trace("_maxHealth " + _maxHealth);
			if (_isRetreating) {

				retreat();

				if (_currentNode && !_isFeared) addChild(new Animation(Anim_Alert, _currentNode));

			} else if (_isFeared) {

				retreat();

			} else if (_logicIndex == 0) {

				////trace(nameString + ": scanning room");
				scanRoom();

			} else if (_logicIndex == 1) {

				////trace(nameString + ": following path");
				scanRoom();
				followPath();

			} else if (_logicIndex == 2) {

				_isLooking = true;

				//trace(nameString + ": no points of interest found, calculating new path");

				if (_previousNodes && _previousNodes.length == 0) {
					_previousNode = _currentNode;
				}

				_previousNodes.push(_currentNode);

				if (_previousNodes.length > 8) {
					_previousNodes.shift();
					_previousNode = _previousNodes[_previousNodes.length - 7];
				}

				////trace(nameString + ": _previousNode: " + _previousNode);

				// look for new stuff

				/*if (_masterGrid.activeChests.length > 0) {

					currentPath = DungeonPathfinder.findPath(_currentNode, _masterGrid.activeChests[0].currentNode);
			
				} else {
					currentPath = DungeonPathfinder.findPath(_currentNode, DungeonPathfinder.findFarthestPoint(_currentNode, _previousNode, 1 + int(Math.random() * _sightDistance)));
				}*/

				if (_unscannedNodes.length == 0) {
					return;
				}

				var tempDestination: GraphicNode = _unscannedNodes[int(Math.random() * _unscannedNodes.length)];

				currentPath = DungeonPathfinder.findPath(_currentNode, tempDestination);

				_logicIndex = 1;

			} else if (_logicIndex == 3) { // engage hostile

				if (_focusTarget.currentNode == null || _focusTarget is oppositeOfTargetType) {
					////trace(nameString + ": focus target null, resetting logic");
					_movingInRange = false;
					_isBattling = false;
					resetLogic();
					return;
				}

				scanRoom();

				////trace(nameString + ": engaging hostile " + _focusTarget);
				_movingInRange = true;
				if (changePathForAttack(_focusTarget.currentNode) == false) { // no change needed if false
					////trace(nameString + ": FIRE FIRE FIRE");
					attackTarget(_focusTarget);
					_focusTarget.focusTarget = this;
				} else {
					followPath();
				}


			} else if (_logicIndex == 4) { // engage friendly

				if (_focusTarget) {
					if (!_focusTarget.stage || (_focusTarget is IChest && _focusTarget.isEmpty) || (_focusTarget is IDoor && _focusTarget.isOpen)) {
						_focusTarget = null;
						resetLogic();
						return;
					}
				}

				if (_focusTarget.currentNode == null) {
					////trace(nameString + ": focus target null, resetting logic");
					resetLogic();
					return;
				}

				if (_focusTarget is IChest && _focusTarget.isEmpty) {
					////trace(nameString + ": chest is empty now, resetting logic");
					resetLogic();
					return;
				}

				scanRoom();

				////trace(nameString + ": engaging friendly " + _focusTarget);
				changePath(_focusTarget.currentNode);
				followPath();

			} else if (_logicIndex == 5) { //  ***  engage heal  ***

				if (focusTarget.currentNode == null || _masterGrid.testRaycast(_currentNode, _focusTarget.currentNode)) {
					////trace(this + ": focus target null, resetting logic");
					_movingInRangeHeal = false;
					resetLogic();
					return;
				}

				scanRoom();

				////trace(this + ": engaging heal -> " + focusTarget);
				_movingInRangeHeal = true;
				if (changePathForAttack(focusTarget.currentNode) == false || focusTarget == this) { // no change needed if false
					////trace(this + ": HEAL HEAL HEAL");
					heal();

				} else {
					followPath();
				}
			}



			if (_lastNode && _currentNode) {
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
			//_previousNodes = [];
			_isBattling = false;
			_isHealing = false;
			_healTargets = [];
		}

		public function followPath(): void {

			////trace(nameString + ": commence follow path");

			if (_currentPath[_pathIndex].isOccupied) {

				var occ = _currentPath[_pathIndex].occupier;
				////trace(nameString + ": square occupied by: " + occ);

				//if (occ == _focusTarget) { // watch this
				//	////trace(nameString + ": Focus Target found, clearing focus target");
				//	_focusTarget = null;
				//	_logicIndex = 0;
				//}

				if (occ is IChest) {

					if (occ.isEmpty == false) {
						if (occ.calculate(this) == true) {
							addToGold(occ.removeGold());
						} else {
							return; // chest unsuccessful
						}
					}

				} else if (occ is ITrap) {

					if (occ.isSet) {
						occ.calculate(this);
					}

					if (_health <= 0) return; // killed by trap

				} else if (occ is SpawnPoint || occ is EmptySlot) {

				} else if (occ is IAdventurer) {

					if (_currentPath[_pathIndex].units > 1) {
						tryUnoccupiedSpace();

						return;
					}

				} else if (occ is IDoor) {

					if (occ.isOpen == false) {
						if (occ.calculate(this) == false) return; // door unsuccessful
					}

					//} else if (occ is Gold) {

					//	occ.calculate(this)

				} else {

					if (occ is TARGET_TYPE) {

						attackTarget(occ);


					} else {
						if (tryUnoccupiedSpace()) {
							followPath();
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

			if (_currentNode == _endNode) {
				////trace(nameString + ":  * * * destination reached @ " + _currentNode);
				if (_isLooking) {
					_logicIndex = 2;
				} else if (_movingInRange) {
					////trace(nameString + ": In range, prepare for attack");
				} else if (_focusTarget) {
					////trace(nameString + ": HERE !!!");
				} else {
					_logicIndex = 0;
				}
			}
		}


		public function setDestination(destNode: GraphicNode): void {

			////trace(nameString + ": setDestination : " + destNode.col, destNode.row);

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
			//trace(nameString + ": commence scanning");

			if (isHealer) {
				scanRoomHealer();
				return;
			}

			////trace(nameString + ": focus target: " + _focusTarget);

			var nodesInArea: Array = DungeonPathfinder.getNodesInArea(_currentNode, _sightDistance);
			_thingsOfInterest = [];

			for (var i: int = 0; i < nodesInArea.length; i++) {
				var tempNode: GraphicNode = nodesInArea[i];



				var unscannedIndex: int = _unscannedNodes.indexOf(tempNode);

				if (unscannedIndex > -1) {
					// continue if blocked from sight
					if (_masterGrid.testRaycast(_currentNode, tempNode)) continue;
					_unscannedNodes.splice(unscannedIndex, 1);
				}

				if (tempNode.isOccupied) {
					var occ = tempNode.occupier;

					if (occ is TARGET_TYPE || (occ is IChest && occ.isEmpty == false) || (occ is IDoor && occ.isOpen == false)) {

						/*if (_masterGrid.testRaycast(_currentNode, tempNode)) {
							////trace("*** RAYCAST HITS OBSTACLE, CONTINUE");
							continue;
						} else {
							////trace("*** RAYCAST SUCCESS! - add to things of interest");
						}*/

						// continue if blocked from sight
						if (_masterGrid.testRaycast(_currentNode, tempNode)) continue;

						_thingsOfInterest.push(nodesInArea[i].occupier);
					}
				}
			}

			if (_thingsOfInterest.length > 0) {
				////trace(nameString + ": - interests found: " + _thingsOfInterest);

				var mArray: Array = new Array();
				var m: DisplayObject;
				var c: DisplayObject;
				var d: DisplayObject;
				var poi: * ;

				if (_focusTarget) { // if focus target disappears then they are confused

					if (_focusTarget.stage == null) {
						_focusTarget = null;
					} else if (_focusTarget is TARGET_TYPE) {
						mArray.push(_focusTarget.currentNode);
					}
				}

				/*if (_focusTarget && _focusTarget is IMonster) {
					mArray.push(_focusTarget.currentNode);
				}*/

				for (var j: int = 0; j < _thingsOfInterest.length; j++) {
					_currentThing = _thingsOfInterest[j];

					if (_currentThing.currentNode == null) {
						continue;
					}

					if (_currentThing is TARGET_TYPE) {
						mArray.push(_currentThing.currentNode);
					} else if (_currentThing is IChest && _currentThing.isEmpty == false) {
						c = _currentThing;
					} else if (_currentThing is IDoor && _currentThing.isOpen == false) {
						d = _currentThing;
					}
				}

				if (mArray.length > 1) {
					var closest: GraphicNode = DungeonPathfinder.closestPoint(_currentNode, mArray) as GraphicNode;
					m = closest.occupier;
				} else if (mArray.length == 1) {
					m = mArray[0].occupier;
				}

				if (d) poi = d;
				if (c) poi = c;
				if (m) poi = m;

				if (poi) {

					////trace(nameString + ": set course for POI - " + poi + " @ " + poi.currentNode.col, poi.currentNode.row);
					_focusTarget = poi;

					////trace(nameString + ": _previousNodes emptied");
					//_previousNodes = [];
					_isLooking = false;

					if (poi is Boss) {
						currentPath = DungeonPathfinder.findPath(_currentNode, _focusTarget.getClosestNode(_currentNode));
					} else {
						currentPath = DungeonPathfinder.findPath(_currentNode, _focusTarget.currentNode);
					}


					if (poi is TARGET_TYPE) {
						_logicIndex = 3;
					} else {
						_logicIndex = 4;
					}
				}
			}


			if (_focusTarget == null || (_focusTarget is IDoor && _focusTarget.isOpen) || (_focusTarget is IChest && _focusTarget.isEmpty)) {
				////trace(nameString + ": isLooking - " + _isLooking);
				if (_isLooking == false) {
					_logicIndex = 2;
				} else if (_isLooking == true) {
					_logicIndex = 1;
				}
			}

			selectBestAttack();
		}

		public function addToGold(g: int): void {
			_gold += g;
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

		public function attackTarget(target: * , isSneakAttack: Boolean = false): void {
			////trace(nameString + ": Attacking " + String(target) + "!");
			var dist: int;

			if (_currentlySelectedAttack.isHealing) {
				if (_attacks.length == 1) return; // only heals available
				selectBestAttack();
			}

			// find it
			if (_currentlySelectedAttack.status && _currentlySelectedAttack.status.statusType == GlobalVariables.TYPE_STATUS_TRANSMUTE && focusTarget.isTransmuted == true) {
				selectBestAttack();
				_isBattling = false;
				return;
			}

			/*
			if (_masterGrid.testRaycast(_currentNode, target.currentNode)) {
				return;
			}*/

			if (target is Boss) {
				dist = DungeonPathfinder.manhattan(_currentNode, target.getClosestNode(_currentNode));
			} else {
				dist = DungeonPathfinder.manhattan(_currentNode, target.currentNode);
			}



			if (_currentNode.col > target.currentNode.col) {
				scaleX = 1;
			} else if (_currentNode.col < target.currentNode.col) {
				scaleX = -1;
			}


			////trace(nameString + ": distance btw - " + dist + " of weapon range " + _currentlySelectedAttack.range);
			if (dist <= _currentlySelectedAttack.range) {

				var damageMod: int;

				if (_currentlySelectedAttack.isMagic) {
					if (_currentlySelectedAttack.manaCost > _mana) {
						////trace(nameString + ": NOT ENOUGH MANA")
						_isBattling = false;
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

				if (isSneakAttack) {
					attackDamage *= 4;
				}

				if (_currentlySelectedAttack.status) {
					//_currentlySelectedAttack.status.roll()

					//new _currentlySelectedAttack.status(target, 5, 5, _dm);

					target.applyStatus(_currentlySelectedAttack.status);
				}

				////trace("											!!!!!" + attackDamage);
				if (_isBattling == false) _isBattling = true;

				_currentlySelectedAttack.animate(this, target);

				if (target.calculateDamage(attackDamage, _currentlySelectedAttack.isMagic) == false) {

					if (target is Adventurer) { // used for confuse 
						GlobalVariables.instance.dungeonAlertPanel.newAlert_AdventurerDefeatedAdventurer(nameString, target.nameString);

					} else {
						GlobalVariables.instance.dungeonAlertPanel.newAlert_AdventurerDefeatedMonster(nameString, target.nameString);
					}

					_isBattling = false;

				} else {

				}

			}
		}

		public function get focusTarget(): * {
			return _focusTarget;
		}



		public function isDungeonComplete(): Boolean {

			if (_confuseTimer > 0) return false;

			if (_focusTarget) return false;

			//if (_masterGrid.monsterCount == 0 && _timeSearched >= _minimumSearchTime && _masterGrid.activeChests.length == 0) {
			if (_unscannedNodes.length == 0) {
				return true;
			}

			_timeSearched++;

			return false;
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

			if (newDamage < 0) newDamage = 0;

			return modHealth(-newDamage);
		}

		public function modHealth(plusMinus: int): Boolean {

			////trace(nameString + ": - subbing from " + _health);
			_health += plusMinus;
			_healthBar.addSub(plusMinus);

			if (health <= 0) {
				die();
				return false;
			} else if (health <= maxHealth * _retreatThreshold && _masterGrid.entrance) { // retreat!
				////trace(this + " RETREATING!!!");
				_isRetreating = true;
				_isBattling = false;
			}

			return true;
		}

		public function exitDungeon(): void { //&& !_isFeared

			var not: int = notoriety * (1 - (_health / _maxHealth));

			// if leaving w health & dungeon complete, subtract notoriety
			if (health / maxHealth > _retreatThreshold) not *= -1;

			_masterGrid.gameplayScreen.notoriety += not;

			_masterGrid.gameplayScreen.totalNotoriety += not;


			var droppedGold: int = _gold * (1 - (_health / _maxHealth)) * 1.5;

			GlobalVariables.instance.dungeonAlertPanel.newAlert_AdventurerLeftDungeon(nameString);
			
			if (droppedGold > 10) {
				_masterGrid.gameplayScreen.earnGold(droppedGold);
				//GlobalVariables.instance.dungeonAlertPanel.newAlert_EarnedGold(droppedGold);
			}

			_masterGrid.removeGameElement(this);
		}

		public function die(): void {
			//////trace("\n!!! " + this + " IS DEAD !!! ");

			if (!_masterGrid) return;
			_masterGrid.addChild(new DieGhost(_currentNode));
			GlobalSounds.instance.die_ADV(this);

			GlobalUnlockTracker.instance.registerDeath(this);

			if (_transmuteGraphic && _transmuteGraphic.stage) parent.removeChild(_transmuteGraphic);
			if (_transmuteGraphic) _transmuteGraphic = null;

			//remove all children, nullify

			_masterGrid.gameplayScreen.notoriety += notoriety;
			_masterGrid.gameplayScreen.totalNotoriety += notoriety;
			
			_masterGrid.removeGameElement(this);
		}

		public function changePath(newNode: GraphicNode): void {
			////trace(nameString + ": Changing path to destination " + newNode.col, newNode.row);
			var newPath = DungeonPathfinder.findPath(_currentNode, newNode);
			currentPath = newPath;
			_pathIndex = 0;
		}

		public function changePathForAttack(newNode: GraphicNode): Boolean {
			////trace(nameString + ": Changing path to node within attack range of " + newNode);

			var closestNode = DungeonPathfinder.findClosestWithinRange(_currentNode, newNode, _currentlySelectedAttack.range);
			////trace(nameString + ": closestNode - " + closestNode);
			//var newPath = DungeonPathfinder.findRangedPath(_currentNode, newNode, _attackRange);//for straight lines
			var newPath = DungeonPathfinder.findPath(_currentNode, closestNode);
			////trace(nameString + ": NEW PATH - " + newPath);
			if (newPath.length > 1) {
				currentPath = newPath;
				_pathIndex = 0;
				return true;
			} else {
				////trace(nameString + ": No change of path needed! Ready to attack!");
				return false;
			}
		}

		public function get pathIndex(): int {
			return _pathIndex;
		}

		public function scanRoomHealer(): void {
			//trace("\n\n"+ this + ": commence scanning with healer");

			//trace(this + ": focus target: " + _focusTarget);

			var nodesInArea: Array = DungeonPathfinder.getNodesInArea(_currentNode, _sightDistance);
			_thingsOfInterest = [];

			for (var i: int = 0; i < nodesInArea.length; i++) {
				var tempNode: GraphicNode = nodesInArea[i];


				// checks if any nodes scanned are unscanned, and removes them from list if so
				var unscannedIndex: int = _unscannedNodes.indexOf(tempNode);

				if (unscannedIndex > -1) {

					// continue if blocked from sight
					if (_masterGrid.testRaycast(_currentNode, tempNode)) continue;

					_unscannedNodes.splice(unscannedIndex, 1);
				}

				if (tempNode.isOccupied) {
					var occ = tempNode.occupier;

					//trace(nameString + " - unit in sight: " + occ);

					if (occ is IDoor) {
						//trace("Unit is Door, isOpen: " + occ.isOpen);
					}

					if (occ is TARGET_TYPE || occ is IChest || (occ is IDoor && occ.isOpen == false) || occ is oppositeOfTargetType) {

						//trace("Made it inside");
						if (occ is IChest) {
							if (occ.isEmpty) continue;
						}

						// continue if blocked from sight
						if (_masterGrid.testRaycast(_currentNode, tempNode)) {
							//trace(nameString + ": failed raycast on " + occ + ", continuing.");
							continue;
						}

						_thingsOfInterest.push(nodesInArea[i].occupier);
						//trace(nameString + ": adding " + occ + " to things of interest.");
					}
				}
			}

			//trace(nameString + ": - interests found: " + _thingsOfInterest);
			if (_thingsOfInterest.length > 0) {


				var mArray: Array = new Array();
				var hArray: Array = new Array();
				var h: * ;
				var m: DisplayObject;
				var c: DisplayObject;
				var d: DisplayObject;
				var poi: * ;

				if (_focusTarget) { // if focus target disappears then they are confused

					if (_focusTarget.stage == null) {
						_focusTarget = null;
					} else if (_focusTarget is oppositeOfTargetType && _focusTarget.percentHealth < .6) {
						//trace("Pushing " + _focusTarget + " to hArray as focus target");
						hArray.push(_focusTarget.currentNode);

					} else if (_focusTarget is TARGET_TYPE) {
						mArray.push(_focusTarget.currentNode);
					}
				}

				for (var j: int = 0; j < _thingsOfInterest.length; j++) {
					_currentThing = _thingsOfInterest[j];

					//trace("Current thing of interest: " + _currentThing);

					if (_focusTarget && _currentThing == _focusTarget) {
						//trace("Current thing is focus target, continue.");
						continue;
					}

					if (_currentThing is oppositeOfTargetType && _currentThing.percentHealth < .6) {
						//trace("Pushing " + _currentThing + " to hArray");
						hArray.push(_currentThing.currentNode);

					} else if (_currentThing is TARGET_TYPE) {
						mArray.push(_currentThing.currentNode);
						//trace("Pushing " + _currentThing + " to mArray");

					} else if (_currentThing is IChest) {
						c = _currentThing;
					} else if (_currentThing is IDoor && _currentThing.isLocked) {
						d = _currentThing;
					} else {

					}
				}

				// add self to heal array
				if (_health < _maxHealth / 3 && this is oppositeOfTargetType) {

					//trace("\nAdding Self to heal array\nHealth: " + _health + "\nMax Health: " + _maxHealth + "\nDiv: " + String(_health < _maxHealth / 4));
					hArray.push(_currentNode);
				}

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

				if (mArray.length > 1) {
					var closest: GraphicNode = DungeonPathfinder.closestPoint(_currentNode, mArray) as GraphicNode;
					m = closest.occupier;
				} else if (mArray.length == 1 && mArray[0]) {
					m = mArray[0].occupier;
				}


				if (h && h.health / h.maxHealth < .6) {
					poi = h;

				} else if (m) {
					poi = m;

				} else if (_focusTarget) {

					if (c) {
						if (_focusTarget is IDoor) poi = c;
					} else {
						poi = d;
					}

				} else {
					if (d) poi = d;
					if (c) poi = c;
					if (m) poi = m;
				}

				if (poi) {

					//trace(this + ": set course for POI - " + poi + " @ " + poi.currentNode.row, poi.currentNode.col);
					_focusTarget = poi;

					//trace(this + ": _previousNodes emptied");
					_previousNodes = [];
					_isLooking = false;

					if (poi is oppositeOfTargetType && poi.health < (3 * poi.maxHealth / 4)) {

						//FIND ME
						//FIND ME
						//FIND ME
						//FIND ME
						// select heal
						_currentlySelectedAttack = bestHeal;
						addHealTarget(poi);
						currentPath = DungeonPathfinder.findPath(_currentNode, DungeonPathfinder.findClosestWithinRange(_currentNode, poi.currentNode, _currentlySelectedAttack.range));
						_logicIndex = 5;

					} else {

						currentPath = DungeonPathfinder.findPath(_currentNode, _focusTarget.currentNode);

						if (poi is TARGET_TYPE) {
							_logicIndex = 3;
						} else {
							_logicIndex = 4;
						}
					}
				}
			} else {

				if (_focusTarget is TARGET_TYPE) {
					_logicIndex = 3;
				}
			}

			if (_focusTarget == null) {
				//trace("\n" + _isLooking + "\n");
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
			//trace(this + ": Healing " + String(healTarget) + "!");
			var currentHTLocation: GraphicNode = healTarget.currentNode;

			if (healTarget.percentHealth > .6) {
				//trace(" ABORT HEALING !!!");
				resetLogic();
				return;
			}

			if (currentHTLocation == null) {
				//trace(this + ": Heal target " + healTarget + " location is null, removing");
				removeHealTarget(healTarget);
				return;
			}

			_currentlySelectedAttack = bestHeal;

			//trace(healTarget.health, healTarget.maxHealth);

			if (_mana < _currentlySelectedAttack.manaCost) return;

			if (healTarget.health < healTarget.maxHealth) {

				_currentlySelectedAttack.animate(this, healTarget);

				_mana -= _currentlySelectedAttack.manaCost;

				//trace(this + ": " + healTarget + " before: " + healTarget.health);
				healTarget.calculateHealing(_currentlySelectedAttack.damage);

				//trace(this + ": " + healTarget + " after: " + healTarget.health);
			}

			if (healTarget == this) {
				//trace("reseting heal target");
				resetLogic();
			}
		}

		public function calculateHealing(healingPoints: int): void {
			_health += healingPoints;
			if (_health > _maxHealth) _health = _maxHealth;
			_healthBar.set(_health);
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




		public function get gold(): int {
			return _gold;
		}

		public function setStats2($starLevel: int): void {
			_starLevel = $starLevel;
			_gold = Math.random() * _starLevel * 100;
			//_abilities = _attacks;
		}

		public function set focusTarget(value: IGameUnit): void {
			_focusTarget = value;
		}

		public function get starLevel(): int {
			return _starLevel;
		}

		public function get masterGrid(): MasterGrid {
			return _masterGrid;
		}


		public function set gold(value: int): void {
			_gold = value;
		}

		public function get isFrozen(): Boolean {
			return _isFrozen;
		}


		public function get currentNode(): GraphicNode {
			return _currentNode;
		}

		public function set currentNode(value: GraphicNode): void {
			_currentNode = value;
		}

		override public function toString(): String {
			return (nameString + " @ " + _currentNode);
		}

		public function get abilities(): Array {
			return _attacks;
		}

		public function destroy(): void {

			////trace("	-	-	-	-	-	-	-	-	-	-	-	-	-	-	DESTROYING ADVENTURER - " + this);

			_statusEffects = null;

			//removeChildren();
			_statusGraphics = null;

			_dungeonEntrance = null;

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
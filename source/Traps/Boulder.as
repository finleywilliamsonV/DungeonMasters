package {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;

	public class Boulder extends MovieClip {

		private var _damage: int;
		private var _rollsUntilBreak: int;
		private var _unitsUntilBreak: int;
		private var _moveType: String;
		private var _currentNode: GraphicNode;

		private var _masterGrid: MasterGrid;
		private var _dm: DungeonMaster;
		
		private var _nameString:String = "Boulder";
		
		private var _weapon:IWeapon = Weapons.trap_Boulder;

		public var dexterity: int = 9999;

		public function Boulder(mg: MasterGrid): void {

			gotoAndStop(1);
			_masterGrid = mg;

			_damage = 2000;
			_rollsUntilBreak = 200;
			_unitsUntilBreak = 100;


			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			GlobalVariables.instance.timer.addEventListener(TimerEvent.TIMER, onTick);

			visible = false;

			
		}
		
		private function onAddedToStage(e: Event): void {
				removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				_moveType = calculateBestMoveType();
				
				if (_moveType == "LEFT") scaleX = -1;
				x = _currentNode.x + _masterGrid._nodeSize / 2;
				y = _currentNode.y + _masterGrid._nodeSize / 2;
				
				visible = true;
				
				//_currentNode.enterNode(this);
			}

		public function calculateBestMoveType(): String {

			var nextNode: GraphicNode;

			var longestLength: int = 0;
			var longestMoveType: String;

			for (var i: int = 0; i < 4; i++) {

				var currentLength: int = -1;

				nextNode = currentNode;

				//trace("\nNEXT NODE occ")
				//trace(nextNode.occupier);

				while (nextNode.isTraversable) {
					
					if (nextNode.hasStructure) {
						
						if ((nextNode.occupier is IDoor && IDoor(nextNode.occupier).isOpen == false) || nextNode.occupier is IChest || nextNode.occupier is SpawnPoint) break;
						
					}

					//trace("\nNEXT NODE in while")
					//trace(nextNode);

					currentLength++;

					if (i == 0) {
						nextNode = _masterGrid.gridArray[nextNode.col][nextNode.row - 1];
					} else if (i == 1) {
						nextNode = _masterGrid.gridArray[nextNode.col][nextNode.row + 1];
					} else if (i == 2) {
						nextNode = _masterGrid.gridArray[nextNode.col - 1][nextNode.row];
					} else if (i == 3) {
						nextNode = _masterGrid.gridArray[nextNode.col + 1][nextNode.row];
					}

					//trace("\nNEXT NODE occ2")
					//trace(nextNode.occupier);
				}

				if (currentLength > longestLength) {
					longestLength = currentLength

					if (i == 0) {
						longestMoveType = "UP";
					} else if (i == 1) {
						longestMoveType = "DOWN";
					} else if (i == 2) {
						longestMoveType = "LEFT";
					} else if (i == 3) {
						longestMoveType = "RIGHT";
					}
				}
			}

			trace("LONGEST MOVE TYPE: " + longestMoveType);

			return longestMoveType;
		}

		public function onTick(tE: TimerEvent): void {

			if (_masterGrid.gameplayScreen.dm.isPaused) return;
			
			if (parent) parent.setChildIndex(this, parent.numChildren - 1);
			else {
				destroy();
				return;
			}

			if (visible == false) {
				visible = true;
				calculateNode(_currentNode);
				return;

			} else if (currentFrame == 5) {
				destroy();
				return;

			} else if (_rollsUntilBreak == 0 || _unitsUntilBreak == 0) {
				gotoAndStop(5);
				return;

				// normal rolling
			} else if (currentFrame == 4) {
				gotoAndStop(1);

			} else {
				gotoAndStop(currentFrame + 1);
			}

			calculateNode(_currentNode);

			moveToNextNode();

			calculateNode(_currentNode);

			//trace("CURRENT FRAME: " + currentFrame);
		}

		public function moveToNextNode(): void {

			var nextNode: GraphicNode;

			
			// choose node, never out of bounds bc of walls
			if (_moveType == "UP") {
				nextNode = _masterGrid.gridArray[_currentNode.col][_currentNode.row - 1];
			} else if (_moveType == "DOWN") {
				nextNode = _masterGrid.gridArray[_currentNode.col][_currentNode.row + 1];
			} else if (_moveType == "LEFT") {
				nextNode = _masterGrid.gridArray[_currentNode.col - 1][_currentNode.row];
			} else if (_moveType == "RIGHT") {
				nextNode = _masterGrid.gridArray[_currentNode.col + 1][_currentNode.row];
			}

			if (nextNode.isTraversable == false || (nextNode.occupier is IDoor && IDoor(nextNode.occupier).isOpen == false) || nextNode.occupier is IChest || nextNode.occupier is SpawnPoint || nextNode.occupier is Boulder) {
				gotoAndStop(5);
				//return;
			}

			x = _currentNode.x + _masterGrid._nodeSize / 2;
			y = _currentNode.y + _masterGrid._nodeSize / 2;

			//_currentNode.exitNode(this);
			_currentNode = nextNode;
			

			_rollsUntilBreak--;
		}

		public function calculateNode(node: GraphicNode): void {

			var occs: Array = node.occupiers;
			trace("Boulder Calculate Node: " + node + "\nOccupiers: " + occs);
			
			if (!occs) return;
			//_currentNode.enterNode(this);

			for (var i: int = occs.length - 1; i >= 0; i--) {
				var adv: * = occs[i];

				if (adv is IAdventurer == false) continue;

				if (adv.calculateDamage(_weapon.damage, false) == false) {
					GlobalVariables.instance.dungeonAlertPanel.newAlert_AdventurerDefeatedByTrap(adv.nameString, _nameString);
					GlobalVariables.gameplayScreen.earnGold(adv.gold);
					_unitsUntilBreak--;
				}

			}
		}

		public function get currentNode(): GraphicNode {
			return _currentNode;
		}

		public function set currentNode(value: GraphicNode): void {
			_currentNode = value;
		}

		public function destroy(): void {
			
			trace("	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	DESTROYING THE BOULDER");

			GlobalVariables.instance.timer.removeEventListener(TimerEvent.TIMER, onTick);

			_masterGrid = null;
			_currentNode = null;
			parent.removeChild(this);
		}
	}
}
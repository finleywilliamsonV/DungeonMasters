package  {
	
	import flash.display.MovieClip;
	
	
	public class LockedDoor extends MovieClip implements IDoor, IPurchasable, IUpdatable {
		
		private var _masterGrid:MasterGrid;
		private var _isOpen:Boolean;
		private var _isLocked:Boolean;
		private var _lockTimer:int;
		
		private var _damage : int = 0;
		private var _difficulty : int = 10;
		private var _resetCost:int = 0;
		private var _timerLimit: int = 100;
		private var _goldCost: int = 20
		
		private var _ui_name:String = "Locked Door";
		private var _starLevel:int= 1;
		private var _trapTriggered:Boolean = false;
		
		private var _openFrame:int;
		private var _closedFrame:int;
		
		private var _weapon:IWeapon;
		
		public var dexterity = 9999;
		
		private var _currentNode : GraphicNode;
		
		public function LockedDoor(mg: MasterGrid, orientation:int = 1): void {
			
			if (orientation == 1) {
				_openFrame = 1;
				_closedFrame = 2;
			} else {
				_openFrame = 3;
				_closedFrame = 4;
			}
			
			_masterGrid = mg;
			_isOpen = false;
			gotoAndStop(_closedFrame);
			_isLocked = true;
			_trapTriggered = false;
			
			_lockTimer = _timerLimit;
		}
		
		public function setStats($ui_name:String, $difficulty:int, $timerLimit, $weapon, $goldCost) : void {
			_ui_name = $ui_name;
			_difficulty = $difficulty;
			_timerLimit = $timerLimit;
			_weapon = $weapon;
			_goldCost = $goldCost;
		}
		
		public function update():void {
			
			if (_isLocked == false) {
				_lockTimer --;
				
				if (_lockTimer == 0 && currentNode.occupiers.length == 0) {
					isLocked = true;
				}
			}
		}
		
		public function calculate(adv:IAdventurer) : Boolean {
			
			
			
			var aDex : int = adv.dexterity;
			var chance : Number = aDex/(aDex+_difficulty);
			/*
			trace("\nCalculating Door");
			trace("Difficulty: " + _difficulty);
			trace("Adv. Dex: " + aDex);
			trace("Open Chance: " + int(chance*100) + "%");
			*/
			var roll : Number = Math.random();
			//trace("Open Roll: " + (int(roll * 100) / 100));
			
			//trace("--> SUCCESS: " + (roll<chance));
			
			if (roll < chance) {
				isLocked = false;
				isOpen = true;
				_lockTimer = _timerLimit;
				
				if (_trapTriggered == false && _weapon) {
					adv.calculateDamage(_weapon.damage, false);
					if (_weapon.status) {
						adv.applyStatus(_weapon.status);
					}
					_trapTriggered = true;
				}
				
				return true;
			} else {
				return false;
			}
		}
		
		public function get weapon(): IWeapon {
			return _weapon;
		}

		
		public function get isOpen(): Boolean {
			return _isOpen;
		}
		
		public function set isOpen(value :Boolean) : void {
			_isOpen = value;
			
			if (_isOpen == true) {
				gotoAndStop(_openFrame);
				_masterGrid.obstacleMC.removeChild(this);
				_masterGrid.addChild(this);
				GlobalSounds.instance.setSound(6);
			} else {
				gotoAndStop(_closedFrame);
				_masterGrid.removeChild(this);
				_masterGrid.obstacleMC.addChild(this);
				_trapTriggered = false;
				GlobalSounds.instance.setSound(7);
			}
		}
		
		public function get isLocked(): Boolean {
			return _isLocked;
		}
		
		public function set isLocked(value :Boolean) : void {
			_isLocked = value;
			
			if (_isOpen) {
				isOpen = false;
			}
		}
		
		public function get currentNode(): GraphicNode {
			return _currentNode;
		}

		public function set currentNode(value: GraphicNode): void {
			_currentNode = value;
		}
		
		public function get ui_name() : String {
			return _ui_name;
		}
		
		public function get ui_graphic() : * {
			return null;
		}
		
		public function get starLevel() : int {
			return _starLevel;
		}
		
		public function get abilities() : Array {
			return new Array(_weapon);
		}
		
		public function get goldCost() : int {
			return _goldCost;
		}
		
		public function get difficulty() : int {
			return _difficulty;
		}
		public function get damage() : int {
			return _damage;
		}
		public function get resetCost() : int {
			return _resetCost;
		}
		public function get timerLimit() : int {
			return _timerLimit;
		}
		
		public function get ticksTillReset() : int {
			return (_lockTimer);
		}
		
		public function destroy(): void {
			_currentNode = null;
			_masterGrid = null;
		}
	}
	
}

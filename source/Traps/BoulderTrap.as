package  {
	
	import flash.display.MovieClip;
	
	
	public class BoulderTrap extends MovieClip implements ITrap, IUpdatable, IPurchasable {
		
		private var _masterGrid:MasterGrid;
		private var _isSet : Boolean;
		private var _setTimer : int;
		private var _timerLimit: int = 200;
		private var _difficulty : int;
		private var _damage : int = 200;
		private var _currentNode: GraphicNode;
		
		private var _goldCost: int = 10000;
		private var _resetCost: int = 1;
		private var _ui_name:String = "Boulder Trap";
		private var _starLevel:int= 7;
		
		private var _weapon: IWeapon;
		private var _nameString:String = "Boulder Trap";
		
		public var dexterity = 9999;
		
		public function BoulderTrap(mg:MasterGrid): void {
			
			gotoAndStop(1);
			_masterGrid = mg;
			isSet = true;
			_setTimer = _timerLimit;
			_difficulty = 100;
			_weapon = Weapons.trap_Boulder;
		}
		
		public function update():void {
			
			if (_isSet == false) {
				_setTimer --;
				if (_setTimer == 0) {
					isSet = true;
				}
			}
		}

		public function get weapon(): IWeapon {
			return _weapon;
		}
		
		public function calculate(adv:IAdventurer) : void {
			
			var aDex : int = adv.dexterity;
			var damage : int = 0;
			var chance : Number = aDex/(aDex+_difficulty);
			
			trace("\nCalculating Trap");
			trace("Difficulty: " + _difficulty);
			trace("Adv. Speed: " + aDex);
			trace("Escape Chance: " + int(chance*100) + "%");
			
			var roll : Number = Math.random();
			trace("Escape Roll: " + int(roll * 100));
			
			trace("--> SUCCESS: " + (roll<chance));
			
			if (roll > chance) {	// trap sprung
				damage = _weapon.damage;
				if (damage < 0) damage = 0;
				trace("Damage: " + damage);
			
				isSet = false;
				
				adv.calculateDamage(_weapon.damage, false);
			
				// set timer for reset trap
				_setTimer = _timerLimit;
				
				var boulder:Boulder = new Boulder(_masterGrid);
				boulder.currentNode = _currentNode;
				_masterGrid.addChild(boulder);
				
			} else {
				//gotoAndStop(3);
				isSet = true;		//once something has been occupied by adv, it cannot remain so after adv has left
			}
			
			
			// do damage in boulder
			
			//if (damage > 0) {
			//	if (adv.calculateDamage(damage, false) == false) {	
			//		//GameplayScreen(_masterGrid.parent).goldDisplay.gold += adv.gold;
			//	} else {
			//		//_masterGrid.gameplayScreen.dm.addPoison(adv, 10, 5);
			//	}
			//}
		}
		
		public function get isSet(): Boolean {
			return _isSet;
		}
		
		public function set isSet(value :Boolean) : void {
			_isSet = value;
			
			if (_isSet == true) {
				gotoAndStop(1);
			} else {
				gotoAndStop(2);
			}
		}
		
		public function get currentNode(): GraphicNode {
			return _currentNode;
		}

		public function set currentNode(value: GraphicNode): void {
			_currentNode = value;
		}
		
		// start ipurchase
		public function get ui_name(): String {
			return _ui_name;
		}
		public function get ui_graphic(): * {
			return null;
		}
		public function get starLevel(): int {
			return _starLevel;
		}
		public function get abilities(): Array {
			return new Array(_weapon);
		}
		public function get goldCost(): int {
			return _goldCost;
		}
		public function get resetCost(): int {
			return _resetCost;
		}
		public function get timerLimit(): int {
			return _timerLimit;
		}
		public function get difficulty(): int {
			return _difficulty;
		}
		public function get damage(): int {
			return _damage;
		}

		public function get ticksTillReset(): int {
			return (_setTimer);
		}
		
		public function destroy(): void {

			_masterGrid = null;
			_currentNode = null;
		}
	}
	
}

package  {
	
	import flash.display.MovieClip;
	
	// trap: damage, difficulty, reset time, reset cost
	
	public class T_SpikeTrap_Ice extends MovieClip implements ITrap, IUpdatable, IPurchasable, IAbility {
		
		private var _masterGrid:MasterGrid;
		private var _isSet : Boolean;
  		private var _setTimer : int;
		private var _currentNode: GraphicNode;
		
		private var _damage : int = 12;
		private var _difficulty : int = 8;
		private var _resetCost:int = 5;
		private var _timerLimit: int = 50;
		
		private var _weapon:IWeapon;
		
		// private var _damage: int; ?
		
		public var dexterity = 9999;
		
		public function T_SpikeTrap_Ice(mg:MasterGrid): void {
			
			gotoAndStop(1);
			_masterGrid = mg;
			isSet = true;
			_setTimer = _timerLimit;
			_weapon = Weapons.trap_Spikes_Ice;
		}
		
		public function update():void {
			
			if (_isSet == false) {
				_setTimer --;
				if (_setTimer == 0) {
					isSet = true;
				}
			}
		}
		
		public function get weapon():IWeapon {
			return _weapon;
		}
		
		public function calculate(adv:IAdventurer) : void {
			
			var aDex : int = adv.dexterity;
			//var damage : int = 0;
			var chance : Number = aDex/(aDex+_difficulty);
			
			/*trace("\nCalculating Trap");
			trace("Difficulty: " + _difficulty);
			trace("Adv. Speed: " + aDex);
			trace("Escape Chance: " + int(chance*100) + "%");*/
			
			var roll : Number = Math.random();
			//trace("Escape Roll: " + int(roll * 100));
			
			//trace("--> SUCCESS: " + (roll<chance));
			
			if (roll > chance) {	// trap sprung
				//damage = (_difficulty * 10) - ( int((aDex - _difficulty) * Math.random()) * 10 );
				//if (damage < 0) damage = 0;
				//trace("Damage: " + damage);
			
				isSet = false;
			
				// set timer for reset trap
				_setTimer = _timerLimit;
				
				if (_weapon.status) adv.applyStatus(_weapon.status);
				
			} else {
				//gotoAndStop(3);
				isSet = true;		//once something has been occupied by adv, it cannot remain so after adv has left
			}
			
			if (damage > 0) {
				if (adv.calculateDamage(damage, false) == false) {	
					GameplayScreen(_masterGrid.parent).earnGold(adv.gold);;
				} 
			}
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
		
		public function get ui_name() : String {
			return "Ice Spikes";
		}
		
		public function get ui_graphic() : * {
			return null;
		}
		
		public function get starLevel() : int {
			return 3;
		}
		
		public function get abilities(): Array {
			return new Array(_weapon);
		}
		
		public function get goldCost() : int {
			return 100;
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
			return (_setTimer);
		}
		
		
		public function abilityText(parentUnit:*) : String {
			return String("Fire Spikes:\n(" + _damage + ")  damage");
		}
		
		public function get graphicIndex() : int {
			return 1;
		}
		
		
		public function destroy(): void {

			_masterGrid = null;
			_currentNode = null;
		}
	}
	
}

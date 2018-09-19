package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Chest extends MovieClip implements IChest, IPurchasable {
		
		private var _isEmpty:Boolean;
		private var _isLocked:Boolean;
		
		private var _maxGold : int = 20000;
		
		private var _goldCost: int = 5000;
		private var _ui_name:String = "Basic Chest";
		private var _starLevel:int= 1;
		
		private var _weapon: IWeapon;
		
		private var _gold:int;
		
		private var _currentNode : GraphicNode;
		
		public function Chest(mg:MasterGrid): void {
			
			isEmpty = true;
			_isLocked = false;
			_gold = 0;
			
			//addGold(1000);
		}
		
		public function calculate(adv:IAdventurer) : Boolean {
			
			
				return true;
			
		}
		
		
		
		public function get isEmpty(): Boolean {
			return _isEmpty;
		}
		
		public function set isEmpty(value :Boolean) : void {
			_isEmpty = value;
			
			if (_isEmpty == true) {
				gotoAndStop(1);
			} else {
				gotoAndStop(2);
			}
		}
		
		public function get isLocked(): Boolean {
			return _isLocked;
		}
		
		public function set isLocked(value :Boolean) : void {
			_isLocked = value;
		}
		
		public function get gold(): int {
			return _gold;
		}

		public function set gold(value: int): void {
			_gold = value;
			if (_gold < 0) {
				_gold = 0;
				isEmpty = true;
			} else if (_gold == 0) {
				isEmpty = true;
			} else {
				isEmpty = false; 
			}
		}
		
		public function get weapon(): IWeapon {
			return _weapon;
		}
		
		public function removeGold() : int {
			var g : int = _gold;
			_gold = 0;
			isEmpty = true;
			return g;
		}
		
		public function addGold(newGold : int) : void {
			_gold += newGold;
			if (_gold > 0) {
				isEmpty = false;
			}
		}
		
		public function get currentNode(): GraphicNode {
			return _currentNode;
		}

		public function set currentNode(value: GraphicNode): void {
			_currentNode = value;
			trace("\nCHEST SET WITH value:" + _gold);
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
		
		public function get maxGold() : int {
			return _maxGold;
		}
		
		public function destroy(): void {


			_currentNode = null;
		}
	}
	
}

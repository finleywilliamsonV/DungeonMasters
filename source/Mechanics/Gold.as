package  {
	
	import flash.display.MovieClip;
	
	
	public class Gold extends MovieClip {

		private var _currentNode: GraphicNode;
		private var _masterGrid :MasterGrid;
		private var _value: int = 10;
		
		
		public function Gold(mg: MasterGrid): void {
			_masterGrid = mg;
		}
		
		public function get currentNode() : GraphicNode {
			return _currentNode;
		}
		
		public function get value() : int {
			return _value;
		}
		public function set value(val: int) : void {
			_value = val;
		}
		
		public function set currentNode(node:GraphicNode) :  void {
			_currentNode = node;
			_currentNode.enterNode(this);
		}
		
		public function calculate(obj:*) : void {
			obj.gold += _value;
			trace("\n-----\n" + obj + " gained " + _value + " gold, now has " + obj.gold + "\n-----\n");
			_masterGrid.removeGameElement(this);
		}
		
		public function destroy() : void {
			
			_currentNode = null;
			_masterGrid = null;
		}
		
		override public function toString() : String {
			
			return (" " + _value + " Gold");
		}
		
	}
	
}

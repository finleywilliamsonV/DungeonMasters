package  {
	
	import flash.display.MovieClip;
	
	
	public class EmptySlot extends MovieClip implements ISlot {
		
		private var _slotType : String;
		private var _currentOccupier:ISlotPiece;
		private var _currentNode : GraphicNode;
		
		private var _masterGrid:MasterGrid;
		
		
		public function EmptySlot($masterGrid:MasterGrid, $slotType:String): void {
			// constructor code
			_masterGrid = $masterGrid;
			slotType = $slotType;
		}
		
		
		
		public function get slotType(): String {	// "return monster", "trap", "chest", etc.
			return _slotType;
		}
		
		public function set slotType(value: String): void {
			_slotType = value;
			
			if (value == GlobalVariables.TYPE_MONSTER) gotoAndStop(1);
				
			if (value == GlobalVariables.TYPE_TRAP)	gotoAndStop(2);
				
			if (value == GlobalVariables.TYPE_DOOR) gotoAndStop(3);
				
			if (value == GlobalVariables.TYPE_CHEST) gotoAndStop(4);
		}
		
		
		// is this necessary?
		public function get currentOccupier(): ISlotPiece {
			return _currentOccupier;
		}
		public function set currentOccupier(value: ISlotPiece): void {
			_currentOccupier = value;
		}
		
		public function get currentNode(): GraphicNode {
			return _currentNode;
		}
		public function set currentNode(value: GraphicNode): void {
			_currentNode = value;
		}
		
		public function destroy() : void {
			_masterGrid = null;
			_currentNode = null;
			_currentOccupier = null;
		}
	}
	
}

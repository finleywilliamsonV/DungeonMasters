package  {
	
	// ISlotPiece includes Chest, SpawnPoint, Trap, Door, etc.
	// It does NOT include Adventurer, Monster, etc.
	
	public interface ISlotPiece {

		// Interface methods:
		function get slot() : ISlot;
		function set slot(newSlot:ISlot):void;
	}
	
}

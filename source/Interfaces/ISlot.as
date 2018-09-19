package  {
	
	public interface ISlot {

		// Interface methods:

		function get slotType(): String; // "return monster", "trap", "chest", etc.
		function set slotType(value:String):void;
		
		function get currentOccupier(): ISlotPiece;
		function set currentOccupier(value:ISlotPiece):void;
		
		function get currentNode() : GraphicNode;
		function set currentNode(value:GraphicNode) : void;
	}
	
}

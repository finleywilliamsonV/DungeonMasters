package  {
	
	public interface IChest {

		// Interface methods:
		function get isEmpty() : Boolean;
		function get isLocked() : Boolean;
		function calculate(adv:IAdventurer) : Boolean;
		function get gold() : int;
		function set gold(value : int) : void;
		function removeGold() : int;
		function addGold(value : int) : void;
		
	}
	
}

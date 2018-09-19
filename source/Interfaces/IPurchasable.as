package  {
	
	public interface IPurchasable {

		// Interface methods:
		
		function get ui_name() : String;
		function get ui_graphic() : *;
		function get starLevel() : int;
		
		function get abilities() : Array;	// array of IAbility
		
		function get goldCost() : int;
		
		function destroy(): void;
		
	}
	
}

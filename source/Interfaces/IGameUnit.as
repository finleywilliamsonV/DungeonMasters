package  {
	
	public interface IGameUnit {

		
		/* not created yet
		
		function get starLevel() : int;
		
		*/
		
		
		// Interface methods:
		function get maxHealth() : int;
		function get health() : int;
		function get maxMana() : int;
		function get mana() : int;
		function get attack() : int;
		function get magicAttack() : int;
		function get defense() : int;
		function get magicDefense() : int;
		function get dexterity() : int;
		
		function get sightDistance() : int;
		//function get gold() : int;			// needs to be in IAdventurer
		
		function get currentNode() : GraphicNode;

	}
	
}

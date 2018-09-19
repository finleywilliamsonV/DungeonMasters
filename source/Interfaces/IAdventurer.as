package  {
	
	public interface IAdventurer {
		
		
		/*
		
		
			- show current gold for Adventurers?
		
		
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
		function get gold() : int;
		
		function get currentNode() : GraphicNode;
		function applyStatus(newStatus: IStatus): void;

		
		/*function set maxHealth(value : int) : void;
		function set health(value : int) : void;
		function set maxMana(value : int) : void;
		function set mana(value : int) : void;
		function set attack(value : int) : void;
		function set magicAttack(value : int) : void;
		function set defense(value : int) : void;
		function set magicDefense(value : int) : void;
		function set dexterity(value : int) : void;
		
		function set sightDistance(value : int) : void;*/
		
		function set gold(value : int) : void;
		
		function addToGold(value : int) : void;
		
		//function set isPoisoned(value : Boolean) : void;
		
		//function get isFrozen():Boolean;
		//function set isFrozen(value : Boolean) : void;
		
		function calculateDamage(incomingAttack: int, isMagic:Boolean = false): Boolean;
		
		
	}
	
}

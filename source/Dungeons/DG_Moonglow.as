package  {
	
	public class DG_Moonglow extends Dungeon {

		public function DG_Moonglow() {
			// constructor code
			super();
			nameString = "Dungeon Moonglow";
			classString = "DG_Moonglow";
			goldCost = 25000;
			dungeonMapIndex = 3;
			description = "Now with Door Slots!";
			monsterSlots = 4;
			trapSlots = 5;
			doorSlots = 4;
			chestSlots = 0;
			dungeonLayout = DungeonLayouts.dungeon_03;
		}

	}
	
}

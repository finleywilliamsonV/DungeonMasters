package  {
	
	public class DG_Orchaus extends Dungeon {

		public function DG_Orchaus() {
			// constructor code
			super();
			nameString = "Dungeon Orchaus";
			classString = "DG_Orchaus";
			goldCost = 7500;
			dungeonMapIndex = 4;
			description = "With a Shiny New Chest.";
			monsterSlots = 5;
			trapSlots = 4;
			doorSlots = 4;
			chestSlots = 1;
			dungeonLayout = DungeonLayouts.dungeon_04;
		}

	}
	
}

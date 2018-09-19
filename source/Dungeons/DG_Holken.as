package  {
	
	public class DG_Holken extends Dungeon {

		public function DG_Holken() {
			// constructor code
			super();
			nameString = "Dungeon Holken";
			goldCost = 100;
			dungeonMapIndex = 6;
			description = "Biggest Yet.";
			monsterSlots = 10;
			trapSlots = 6;
			doorSlots = 9;
			chestSlots = 4;
			dungeonLayout = DungeonLayouts.dungeon_07;
		}

	}
	
}

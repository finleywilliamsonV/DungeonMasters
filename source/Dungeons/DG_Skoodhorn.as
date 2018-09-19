package  {
	
	public class DG_Skoodhorn extends Dungeon {

		public function DG_Skoodhorn() {
			// constructor code
			super();
			nameString = "Dungeon Skoodhorn";
			classString = "DG_Skoodhorn";
			goldCost = 10000;
			dungeonMapIndex = 2;
			description = "Two-bedroom suite equipped with a dividing wall, multi-purpose slime vaults, and two pressure-activated spike traps that glimmer in the candlelight.";
			monsterSlots = 2;
			trapSlots = 2;
			doorSlots = 0;
			chestSlots = 0;
			dungeonLayout = DungeonLayouts.dungeon_22;
		}

	}
	
}

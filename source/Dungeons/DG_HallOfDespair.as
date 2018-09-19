package  {
	
	public class DG_HallOfDespair extends Dungeon {

		public function DG_HallOfDespair() {
			// constructor code
			super();
			nameString = "Hall of Despair";
			classString = "DG_HallOfDespair";
			goldCost = 50000;
			dungeonMapIndex = 4;
			description = "Modern Dungeon with Character.";
			monsterSlots = 8;
			trapSlots = 6;
			doorSlots = 6;
			chestSlots = 1;
			dungeonLayout = DungeonLayouts.dungeon_05;
		}

	}
	
}

package  {
	
	public class DG_MultiEntrace extends Dungeon {

		public function DG_MultiEntrace() {
			// constructor code
			super();
			nameString = "Multi-Entrance";
			classString = "DG_MultiEntrace";
			goldCost = 100;
			dungeonMapIndex = 6;
			description = "See Name";
			monsterSlots = 10;
			trapSlots = 6;
			doorSlots = 9;
			chestSlots = 4;
			dungeonLayout = DungeonLayouts.dungeon_07;
		}

	}
	
}

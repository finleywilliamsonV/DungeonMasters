package  {
	
	public class DG_Glubmire extends Dungeon {

		public function DG_Glubmire() {
			// constructor code
			super();
			nameString = "Dungeon Glubmire";
			classString = "DG_Glubmire";
			goldCost = 1000;
			dungeonMapIndex = 1;
			description = "Your very first dungeon. This thing is ok.";
			monsterSlots = 2;
			trapSlots = 0;
			doorSlots = 0;
			chestSlots = 0;
			dungeonLayout = DungeonLayouts.dungeon_01;
		}

	}
	
}

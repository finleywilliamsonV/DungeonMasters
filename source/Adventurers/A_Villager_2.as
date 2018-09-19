package  {
	
	public class A_Villager_2 extends Adventurer {
		
		public static var level : int = 1;
		
		public function A_Villager_2(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.pitchfork);

			super.setStats(120, 0, 3, 0, 3, 0, 2, 4);
			
			super.nameString = "Villager";
			
			super.sex = GlobalVariables.SEX_FEMALE;
			
			super.setStats2(level);
		}
		
	}
	
}

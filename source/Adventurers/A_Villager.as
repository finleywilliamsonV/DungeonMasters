package  {
	
	public class A_Villager extends Adventurer {
		
		public static var level : int = 1;
		
		public function A_Villager(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.pitchfork);

			super.setStats(80, 0, 4, 0, 2, 2, 4, 3);
			
			super.nameString = "Villager";
			
			super.sex = GlobalVariables.SEX_FEMALE;
			
			super.setStats2(level);
		}
		
	}
	
}

package  {
	
	public class A_Villager_3 extends Adventurer {
		
		public static var level : int = 1;
		
		public function A_Villager_3(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.club);

			super.setStats(70, 0, 6, 0, 3, 1, 3, 3);
			
			super.nameString = "Villager";
			
			super.sex = GlobalVariables.SEX_MALE;
			
			super.setStats2(level);
		}
		
	}
	
}

package  {
	
	public class A_Archer extends Adventurer {
		
		public static var level : int = 3;
		
		public function A_Archer(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.bow);

			super.setStats(340, 0, 6, 0, 4, 3, 18, 6);
			
			super.nameString = "Archer";
			
			super.sex = GlobalVariables.SEX_FEMALE;
			
			super.setStats2(level);
		}
		
	}
	
}

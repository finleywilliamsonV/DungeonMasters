package  {
	
	public class A_LadyOfFire extends Adventurer {
		
		public static var level : int = 10;
		
		public function A_LadyOfFire(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.fireRitual);

			super.setStats(400, 200, 3, 45, 6, 18, 16, 5);
			
			super.nameString = "Lady of Fire";
			
			super.sex = GlobalVariables.SEX_FEMALE;
			
			super.setStats2(level);
		}
		
	}
	
}

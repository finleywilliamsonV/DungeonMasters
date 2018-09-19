package  {
	
	public class A_LadyOfWater extends Adventurer {
		
		public static var level : int = 10;
		
		public function A_LadyOfWater(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.waterRitual);

			super.setStats(500, 500, 3, 27, 13, 24, 18, 5);
			
			super.nameString = "Lady of Water";
			
			super.sex = GlobalVariables.SEX_FEMALE;
			
			super.setStats2(level);
		}
		
	}
	
}

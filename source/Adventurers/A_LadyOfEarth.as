package  {
	
	public class A_LadyOfEarth extends Adventurer {
		
		public static var level : int = 10;
		
		public function A_LadyOfEarth(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.earthRitual);

			super.setStats(1300, 100, 3, 12, 41, 53, 4, 4);
			
			super.nameString = "Lady of Earth";
			
			super.sex = GlobalVariables.SEX_FEMALE;
			
			super.setStats2(level);
		}
		
	}
	
}

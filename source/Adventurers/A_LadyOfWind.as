package  {
	
	public class A_LadyOfWind extends Adventurer {
		
		public static var level : int = 10;
		
		public function A_LadyOfWind(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.windRitual);

			super.setStats(450, 400, 3, 12, 8, 23, 22, 6);
			
			super.nameString = "Lady of Wind";
			
			super.sex = GlobalVariables.SEX_FEMALE;
			
			super.setStats2(level);
		}
		
	}
	
}

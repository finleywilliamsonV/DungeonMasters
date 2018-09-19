package  {
	
	public class A_Destroyer extends Adventurer {
		
		public static var level : int = 7;
		
		public function A_Destroyer(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.bigOlSword);

			super.setStats(1500, 0, 52, 0, 28, 0, 38, 4);
			
			super.nameString = "Destroyer";
			
			super.sex = GlobalVariables.SEX_MALE;
			
			super.setStats2(level);
		}
		
	}
	
}

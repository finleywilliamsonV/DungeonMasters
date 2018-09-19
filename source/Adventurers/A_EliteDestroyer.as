package  {
	
	public class A_EliteDestroyer extends Adventurer {
		
		public static var level : int = 13;
		
		public function A_EliteDestroyer(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.bigOlSword_2);

			super.setStats(1750, 0, 66, 0, 32, 16, 32, 5);
			
			super.nameString = "Elite Destroyer";
			
			super.sex = GlobalVariables.SEX_MALE;
			
			super.setStats2(level);
		}
		
	}
	
}

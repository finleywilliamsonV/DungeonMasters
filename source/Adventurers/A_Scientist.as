package  {
	
	public class A_Scientist extends Adventurer {
		
		public static var level : int = 5;
		
		public function A_Scientist(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.transmutePotion, Weapons.punch);

			super.setStats(90, 250, 1, 0, 2, 0, 3, 4);
			
			super.nameString = "Scientist";
			
			super.sex = GlobalVariables.SEX_MALE;
			
			super.setStats2(level);
		}
		
	}
	
}

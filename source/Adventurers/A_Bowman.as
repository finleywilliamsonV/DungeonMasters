package  {
	
	public class A_Bowman extends Adventurer {
		
		public static var level : int = 7;
		
		public function A_Bowman(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.poisonArrows);

			super.setStats(450, 0, 12, 3, 14, 12, 36, 6);
			
			super.nameString = "Bowman";
			
			super.sex = GlobalVariables.SEX_FEMALE;
			
			super.setStats2(level);
		}
		
	}
	
}

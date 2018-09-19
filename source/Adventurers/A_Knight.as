package  {
	
	public class A_Knight extends Adventurer {
		
		public static var level : int = 3;
		
		public function A_Knight(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.sword);

			super.setStats(380, 0, 9, 0, 15, 0, 6, 4);
			
			super.nameString = "Knight";
			
			super.sex = GlobalVariables.SEX_MALE;
			
			super.setStats2(level);
		}
		
	}
	
}

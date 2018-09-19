package  {
	
	public class A_Knight_2 extends Adventurer {
		
		public static var level : int = 3;
		
		public function A_Knight_2(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.bigHammer);

			super.setStats(420, 0, 12, 0, 12, 0, 5, 4);
			
			super.nameString = "Knight";
			
			super.sex = GlobalVariables.SEX_FEMALE;
			
			super.setStats2(level);
		}
		
	}
	
}

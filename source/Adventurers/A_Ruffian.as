package  {
	
	public class A_Ruffian extends Adventurer {
		
		public static var level : int = 2;
		
		public function A_Ruffian(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.throwingKnife);

			super.setStats(250, 0, 8, 0, 5, 0, 7, 4);
			
			super.nameString = "Ruffian";
			
			super.sex = GlobalVariables.SEX_MALE;
			
			super.setStats2(level);
		}
		
	}
	
}

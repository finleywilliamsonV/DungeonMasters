package  {
	
	public class A_Empress extends Adventurer {
		
		public static var level : int = 15;
		
		public function A_Empress(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.punch, Weapons.tossThrone);

			super.setStats(3500, 1000, 5, 2, 8, 12, 7, 6);
			
			super.nameString = "Empress";
			
			super.sex = GlobalVariables.SEX_FEMALE;
			
			super.setStats2(level);
		}
		
	}
	
}

package  {
	
	public class A_Wizard extends Adventurer {
		
		public static var level : int = 4;
		
		public function A_Wizard(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.magicBurst);

			super.setStats(410, 200, 3, 24, 2, 12, 8, 5);
			
			super.nameString = "Wizard";
			
			super.sex = GlobalVariables.SEX_MALE;
			
			super.setStats2(level);
		}
		
	}
	
}

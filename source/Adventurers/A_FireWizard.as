package  {
	
	public class A_FireWizard extends Adventurer {
		
		public static var level : int = 6;
		
		public function A_FireWizard(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.fireBall);

			super.setStats(300, 200, 6, 32, 4, 18, 10, 5);
			
			super.nameString = "Fire Wizard";
			
			super.sex = GlobalVariables.SEX_MALE;
			
			super.setStats2(level);
		}
		
	}
	
}

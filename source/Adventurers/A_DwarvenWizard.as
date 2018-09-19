package  {
	
	public class A_DwarvenWizard extends Adventurer {
		
		public static var level : int = 7;
		
		public function A_DwarvenWizard(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.rockSmash);

			super.setStats(320, 350, 6, 22, 7, 22, 8, 5);
			
			super.nameString = "Dwarven Wizard";
			
			super.sex = GlobalVariables.SEX_MALE;
			
			super.setStats2(level);
		}
		
	}
	
}

package  {
	
	public class A_Angel extends Adventurer {
		
		public static var level : int = 13;
		
		public function A_Angel(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.smite,Weapons.divineGrace);

			super.setStats(450, 800, 0, 48, 8, 72, 12, 6);
			
			super.nameString = "Angel";
			
			super.sex = GlobalVariables.SEX_FEMALE;
			
			super.setStats2(level);
		}
		
	}
	
}

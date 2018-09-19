package  {
	
	public class A_Rogue extends Adventurer {
		
		public static var level : int = 4;
		
		public function A_Rogue(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.dagger, Weapons.shuriken);

			super.setStats(480, 0, 16, 0, 6, 4, 21, 5);
			
			super.nameString = "Rogue";
			
			super.sex = GlobalVariables.SEX_MALE;
			
			super.setStats2(level);
		}
		
	}
	
}

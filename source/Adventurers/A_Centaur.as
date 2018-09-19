package  {
	
	public class A_Centaur extends Adventurer {
		
		public static var level : int = 11;
		
		public function A_Centaur(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.spear);

			super.setStats(1950, 0, 28, 0, 16, 16, 12, 5);
			
			super.nameString = "Centaur";
			
			super.sex = GlobalVariables.SEX_MALE;
			
			super.setStats2(level);
		}
		
	}
	
}

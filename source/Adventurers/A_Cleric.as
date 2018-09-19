package  {
	
	public class A_Cleric extends Adventurer {
		
		public static var level : int = 5;
		
		public function A_Cleric(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.minorHeal, Weapons.staff);

			super.setStats(240, 150, 4, 4, 2, 12, 10, 5);
			
			super.nameString = "Cleric";
			
			super.sex = GlobalVariables.SEX_MALE;
			
			super.setStats2(level);
		}
		
	}
	
}

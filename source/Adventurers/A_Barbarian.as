package  {
	
	public class A_Barbarian extends Adventurer {
		
		public static var level : int = 6;
		
		public function A_Barbarian(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.doubleLongSwords);

			super.setStats(640, 0, 34, 0, 12, 16, 22, 4);
			
			super.nameString = "Barbarian";
			
			super.sex = GlobalVariables.SEX_MALE;
			
			super.setStats2(level);
		}
		
	}
	
}

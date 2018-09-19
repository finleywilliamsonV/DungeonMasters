package  {
	
	public class A_Chef extends Adventurer {
		
		public static var level : int = 2;
		
		public function A_Chef(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.throwFood);

			super.setStats(190, 0, 4, 0, 2, 4, 12, 5);
			
			super.nameString = "Chef";
			
			super.sex = GlobalVariables.SEX_MALE;
			
			super.setStats2(level);
		}
		
	}
	
}

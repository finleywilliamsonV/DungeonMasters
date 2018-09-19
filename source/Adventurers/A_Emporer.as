package  {
	
	public class A_Emporer extends Adventurer {
		
		public static var level : int = 15;
		
		public function A_Emporer(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.swiftBonk);

			super.setStats(25000, 0, 4, 3, 9, 7, 6, 6);
			
			super.nameString = "Emporer";
			
			super.sex = GlobalVariables.SEX_MALE;
			
			super.setStats2(level);
		}
		
	}
	
}

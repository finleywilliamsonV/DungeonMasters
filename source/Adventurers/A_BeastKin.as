package  {
	
	public class A_BeastKin extends Adventurer {
		
		public static var level : int = 12;
		
		public function A_BeastKin(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.razorClaws, Weapons.callOfTheWild);

			super.setStats(600, 400, 8, 12, 8, 32, 9, 5);
			
			super.nameString = "Beast Kin";
			
			super.sex = GlobalVariables.SEX_MALE;
			
			super.setStats2(level);
		}
		
	}
	
}

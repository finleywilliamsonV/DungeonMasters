package  {
	
	public class A_Constable extends Adventurer {
		
		public static var level : int = 5;
		
		public function A_Constable(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.club, Weapons.bonkNoggin);

			super.setStats(770, 50, 24, 0, 4, 0, 6, 4);
			
			super.nameString = "Constable";
			
			super.sex = GlobalVariables.SEX_MALE;
			
			super.setStats2(level);
		}
		
	}
	
}

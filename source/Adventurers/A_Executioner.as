package  {
	
	public class A_Executioner extends Adventurer {
		
		public static var level : int = 9;
		
		public function A_Executioner(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.deathScythe);

			super.setStats(1180, 0, 36, 0, 28, 14, 22, 3);
			
			super.nameString = "Executioner";
			
			super.sex = GlobalVariables.SEX_MALE;
			
			super.setStats2(level);
		}
		
	}
	
}

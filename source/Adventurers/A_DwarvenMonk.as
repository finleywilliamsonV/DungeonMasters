package  {
	
	public class A_DwarvenMonk extends Adventurer {
		
		public static var level : int = 4;
		
		public function A_DwarvenMonk(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.focusPunch, Weapons.kiStrike);

			super.setStats(140, 50, 12, 4, 12, 4, 12, 4);
			
			super.nameString = "Dwarven Monk";
			
			super.sex = GlobalVariables.SEX_MALE;
			
			super.setStats2(level);
		}
		
	}
	
}

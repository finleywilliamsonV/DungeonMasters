package  {
	
	public class A_DwarvenHero extends Adventurer {
		
		public static var level : int = 12;
		
		public function A_DwarvenHero(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.swordOfTheDeep);

			super.setStats(1580, 0, 41, 0, 60, 22, 16, 4);
			
			super.nameString = "Dwarven Hero";
			
			super.sex = GlobalVariables.SEX_MALE;
			
			super.setStats2(level);
		}
		
	}
	
}

package  {
	
	public class A_AncientSage extends Adventurer {
		
		public static var level : int = 14;
		
		public function A_AncientSage(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.sword,Weapons.magicMissile);

			super.setStats(1580, 1100, 14, 68, 13, 37, 28, 5);
			
			super.nameString = "Ancient Sage";
			
			super.sex = GlobalVariables.SEX_MALE;
			
			super.setStats2(level);
		}
		
	}
	
}

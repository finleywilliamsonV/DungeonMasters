package  {
	
	public class A_DwarvenMiner extends Adventurer {
		
		public static var level : int = 8;
		
		public function A_DwarvenMiner(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.pickAxe);

			super.setStats(1025, 0, 42, 0, 36, 8, 9, 4);
			
			super.nameString = "Dwarven Miner";
			
			super.sex = GlobalVariables.SEX_MALE;
			
			super.setStats2(level);
		}
		
	}
	
}

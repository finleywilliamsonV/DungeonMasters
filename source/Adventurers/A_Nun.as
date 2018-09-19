package  {
	
	public class A_Nun extends Adventurer {
		
		public static var level : int = 9;
		
		public function A_Nun(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.divineLight, Weapons.blessing);

			super.setStats(450, 450, 4, 23, 6, 18, 12, 5);
			
			super.nameString = "Nun";
			
			super.sex = GlobalVariables.SEX_FEMALE;
			
			super.setStats2(level);
		}
		
	}
	
}

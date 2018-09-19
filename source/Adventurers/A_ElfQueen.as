package  {
	
	public class A_ElfQueen extends Adventurer {
		
		public static var level : int = 8;
		
		public function A_ElfQueen(mg:MasterGrid) {
			
			super(mg);

			super._attacks.push(Weapons.healingHerbs, Weapons.razorGrass, Weapons.tornado);

			super.setStats(450, 280, 4, 14, 8, 16, 18, 5);

			super.nameString = "Elf Queen";
			
			super.sex = GlobalVariables.SEX_FEMALE;

			super.setStats2(level);
		}
		
	}
	
}

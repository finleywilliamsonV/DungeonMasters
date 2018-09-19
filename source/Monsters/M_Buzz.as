package {

	public class M_Buzz extends Monster {

		public function M_Buzz(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.acidSpit);

			super.setStats(650, 240, 24, 14, 22, 16, 20, 5);

			super.nameString = "Buzz";
			
			super.description = "Super fly guy, just don't watch him eat.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Buzz", 8, 12500, 7);
			
			super.soundIndex = 35;

		}
	}

}

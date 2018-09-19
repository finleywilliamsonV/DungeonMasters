package {

	public class M_Lion extends Monster {

		public function M_Lion(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.razorClaws, Weapons.roar);

			super.setStats(410, 60, 38, 0, 12, 0, 26, 5);

			super.nameString = "Lion";
			
			super.description = "Very high attack. Can strike fear with a powerful roar.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Lion", 7, 12500, 7);
			
			super.soundIndex = 40;

		}
	}

}

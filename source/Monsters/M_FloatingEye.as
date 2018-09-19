package {

	public class M_FloatingEye extends Monster {

		public function M_FloatingEye(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.tearsOfSorrow);

			super.setStats(880, 0, 6, 32, 4, 18, 14, 6);

			super.nameString = "Floating Eye";
			
			super.description = "With no eyelashes to keep out irritants, its constantly sobbing. What a cruel joke.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Floating Eye", 7, 12500, 7);

		}
	}

}

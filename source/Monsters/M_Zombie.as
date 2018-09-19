package {

	public class M_Zombie extends Monster {

		public function M_Zombie(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.flailLimbs);

			super.setStats(410, 0, 24, 0, 6, 5, 3, 3);

			super.nameString = "Zombie";
			
			super.description = "A little more put together than the skeleton. Misguided, this Zombie actually craves 'Brians.'";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Zombie", 4, 12500, 7);

		}
	}

}

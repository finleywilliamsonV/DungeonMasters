package {

	public class M_Platino extends Monster {

		public function M_Platino(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.magicMissile);

			super.setStats(9000, 3000, 400, 400, 200, 120, 100, 15);

			super.nameString = "Platino";
			
			super.description = "ITS A ME, PLATINO!";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Platino", 15, 12500, 7);

		}
	}

}

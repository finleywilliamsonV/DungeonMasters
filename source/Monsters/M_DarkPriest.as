package {

	public class M_DarkPriest extends Monster {

		public function M_DarkPriest(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.forbiddenRitual, Weapons.energyTransfer);

			super.setStats(410, 880, 14, 24, 18, 42, 16, 5);

			super.nameString = "Dark Priest";
			
			super.description = "Just wants to do dark priest stuff with his friends... like turning adventurers into chickens.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Dark Priest", 14, 12500, 7);

		}
	}

}

package {

	public class M_NewtWitch extends Monster {

		public function M_NewtWitch(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.poisonGas, Weapons.poorHealing);

			super.setStats(515, 230, 12, 14, 4, 8, 6, 4);

			super.nameString = "Newt Witch";
			
			super._healthBar.y = super._healthBar.y - 3;
			
			super.description = "Mean and green. She can poison adventurers and heal friendly monsters, but isn't great at either.";
			
			super.setStats2("Newt Witch", 5, 12500, 7);

		}
	}

}

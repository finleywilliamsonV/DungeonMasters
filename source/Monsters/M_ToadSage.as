package {

	public class M_ToadSage extends Monster {

		public function M_ToadSage(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.trample, Weapons.greatHealing);

			super.setStats(400, 440, 8, 22, 12, 32, 16, 6);

			super.nameString = "Toad Sage";
			
			super.description = "A powerful ninja atop a giant toad, both an accomplished healer and notable attacker.";
			
			super._healthBar.y = super._healthBar.y - 8;
			
			super.setStats2("Toad Sage", 12, 12500, 7);

		}
	}

}

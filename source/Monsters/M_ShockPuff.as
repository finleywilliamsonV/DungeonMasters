package {

	public class M_ShockPuff extends Monster {

		public function M_ShockPuff(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.staticShock);

			super.setStats(320, 500, 4, 2, 4, 12, 8, 4);

			super.nameString = "Shock Puff";
			
			super.description = "A furry little guy with a lot built up. Shock Puff releases massive burst of energy, but takes a while to recharge.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Shock Puff", 7, 12500, 7);

		}
	}

}

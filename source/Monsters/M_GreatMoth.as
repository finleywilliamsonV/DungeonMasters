package {

	public class M_GreatMoth extends Monster {

		public function M_GreatMoth(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.moonDust, Weapons.gust);

			super.setStats(890, 110, 6, 32, 18, 22, 26, 5);

			super.nameString = "Great Moth";
			
			super.description = "Don't call it a butterfly. An established ranged attacker.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Great Moth", 8, 12500, 7);

		}
	}

}

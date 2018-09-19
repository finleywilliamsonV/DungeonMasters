package {

	public class M_Bat extends Monster {

		public function M_Bat(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.sonar, Weapons.bite);

			super.setStats(60, 5, 3, 0, 1, 0, 6, 5);

			super.nameString = "Bat";
			
			super.description = "Average cave bat. It's echolocation can disorient would-be attackers.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Bat", 1, 12500, 7);
			
			super.soundIndex = 33;

		}
	}

}

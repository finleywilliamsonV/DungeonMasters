package {

	public class M_Cyclops extends Monster {

		public function M_Cyclops(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.confuseRay_2, Weapons.halberd);

			super.setStats(540, 500, 28, 0, 26, 8, 12, 4);

			super.nameString = "Cyclops";
			
			super.description = "Its eye-beam confuse ray shatters the will of its foes.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Cyclops", 8, 12500, 7);
			
			super.soundIndex = 45;

		}
	}

}

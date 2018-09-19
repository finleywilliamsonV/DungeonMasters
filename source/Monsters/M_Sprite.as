package {

	public class M_Sprite extends Monster {

		public function M_Sprite(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.tinyFists, Weapons.naturalHealing);

			super.setStats(90, 300, 4, 4, 2, 12, 10, 5);

			super.nameString = "Sprite";
			
			super.description = "A dainty sprite with a mean streak. High healing and itty-bitty punches.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Sprite", 5, 12500, 7);

		}
	}

}

package {

	public class M_SproutBeast extends Monster {

		public function M_SproutBeast(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.vegetation, Weapons.poisonFist);

			super.setStats(790, 420, 28, 0, 31, 26, 22, 5);

			super.nameString = "Sprout Beast";
			
			super.description = "Ticked off at humans for destroying the planet, but hypocritaclly attacks by throwing entire trees.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Sprout Beast", 12, 12500, 7);
			
			super.soundIndex = 43;

		}
	}

}

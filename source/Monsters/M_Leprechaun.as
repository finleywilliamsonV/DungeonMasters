package {

	public class M_Leprechaun extends Monster {

		public function M_Leprechaun(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.sheleighly, Weapons.luckyDay); //

			super.setStats(360, 320, 13, 14, 10, 12, 8, 4);

			super.nameString = "Leprechaun";
			
			super.description = "Wide range of damage/healing, effectiveness depends on luck.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Leprechaun", 6, 12500, 7);

		}
	}

}

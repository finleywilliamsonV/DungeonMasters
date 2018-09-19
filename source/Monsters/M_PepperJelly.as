package {

	public class M_PepperJelly extends Monster {

		public function M_PepperJelly(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.burningSlime);

			super.setStats(260, 0, 2, 12, 2, 6, 3, 4);

			super.nameString = "Pepper Jelly";
			
			super.description = "Can you stand the heat? Best paired with brie. May cause burning.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Pepper Jelly", 3, 12500, 7);

		}
	}

}

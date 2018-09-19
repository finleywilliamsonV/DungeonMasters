package {

	public class M_Skeleton extends Monster {

		public function M_Skeleton(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.boneBash);

			super.setStats(230, 0, 6, 0, 2, 6, 4, 2);

			super.nameString = "Skeleton";
			
			super.description = "The old bones of lost adventurers, a lack of eyes gives it poor sight.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Skeleton", 2, 12500, 7);

		}
	}

}

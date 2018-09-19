package {

	public class M_Cthulian extends Monster {

		public function M_Cthulian(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.psychosis,Weapons.flood);

			super.setStats(1140, 2000, 38, 30, 26, 28, 32, 6);

			super.nameString = "Cthulian";
			
			super.description = "An ancient race of squidfolk. Melts brains into puddles of goo.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Cthulian", 13, 12500, 7);

		}
	}

}

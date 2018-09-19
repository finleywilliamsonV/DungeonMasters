package {

	public class M_Gargoyle extends Monster {

		public function M_Gargoyle(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.stoneFist);

			super.setStats(720, 0, 22, 0, 28, 6, 6, 3);

			super.nameString = "Gargoyle";
			
			super.description = "Remember the show from the 90's? That's some good stuff. High defense.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Gargoyle", 6, 12500, 7);

		}
	}

}

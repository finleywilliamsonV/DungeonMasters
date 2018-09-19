package {

	public class M_Hermit extends Monster {

		public function M_Hermit(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.forgottenRemedies);

			super.setStats(220, 600, 6, 0, 4, 12, 6, 5);

			super.nameString = "Hermit";
			
			super.description = "Fights in dungeons to support many local cats. His frail body crumples under stress, but incredible healing makes him worth protecting.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Hermit", 9, 12500, 7);

		}
	}

}

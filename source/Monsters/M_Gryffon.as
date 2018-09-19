package {

	public class M_Gryffon extends Monster {

		public function M_Gryffon(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.razorTallons, Weapons.massiveGust);

			super.setStats(980, 200, 32, 34, 28, 34, 38, 6);

			super.nameString = "Gryffon";
			
			super.description = "Goes by the name 'Big G.' Anyone managing past its gale-force winds will be ripped to shreds by its tallons.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Gryffon", 11, 12500, 7);

		}
	}

}

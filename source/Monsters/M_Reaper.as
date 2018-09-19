package {

	public class M_Reaper extends Monster {

		public function M_Reaper(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.lastWords);

			super.setStats(333, 1000, 3, 3, 3, 3, 3, 3);

			super.nameString = "Reaper";
			
			super.description = "Death incarnate. Excessively high burst damage with an excruciating recharge time.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Reaper", 13, 12500, 7);

		}
	}

}

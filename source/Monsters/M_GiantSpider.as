package {

	public class M_GiantSpider extends Monster {

		public function M_GiantSpider(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.shootWeb, Weapons.poisonBite);

			super.setStats(180, 110, 3, 0, 3, 1, 6, 5);

			super.nameString = "Giant Spider";
			
			super.description = "The Giant Spider is fragile, but makes up for it with poison fangs and a sticky web-shooter.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Giant Spider", 3, 12500, 7);

		}
	}

}

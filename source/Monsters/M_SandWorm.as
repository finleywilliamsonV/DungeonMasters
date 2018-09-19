package {

	public class M_SandWorm extends Monster {

		public function M_SandWorm(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.chomp);

			super.setStats(160, 0, 12, 0, 2, 4, 6, 4);

			super.nameString = "Sand Worm";
			
			super.description = "Don't underestimate this monster's size, it packs a massive bite.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Sand Worm", 2, 12500, 7);

		}
	}

}

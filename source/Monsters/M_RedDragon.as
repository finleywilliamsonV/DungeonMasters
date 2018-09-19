package {

	public class M_RedDragon extends Monster {

		public function M_RedDragon(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.sharpClaws, Weapons.fireBreath);

			super.setStats(850, 0, 28, 22, 22, 14, 12, 5);

			super.nameString = "Red Dragon";
			
			super.description = "A balanced unit that fits a variety of needs, dragons are a must-have for any respectable dungeon.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Red Dragon", 10, 12500, 7);
			
			super.soundIndex = 43;

		}
	}

}

package {

	public class M_ThunderGiant extends Monster {

		public function M_ThunderGiant(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.lightningFist, Weapons.endlessThunder);

			super.setStats(1280, 0, 52, 20, 44, 24, 30, 4);

			super.nameString = "Thunder Giant";
			
			super.description = "A fearsome beast, nicknamed 'Catatumbo.' Holds the internal charge of 1000 thunderstorms.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Thunder Giant", 12, 12500, 7);
			
			super.soundIndex = 45;

		}
	}

}

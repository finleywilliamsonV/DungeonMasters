package {

	public class M_StoneGolem extends Monster {

		public function M_StoneGolem(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.boulderBarrage,Weapons.oneTonFist);

			super.setStats(1740, 0, 12, 0, 55, 16, 12, 4);

			super.nameString = "Stone Golem";
			
			super.description = "50 tons of stone, reanimated for your enjoyment. Impervious to all but the strongest physical attacks.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Stone Golem", 11, 12500, 7);
			
			super.soundIndex = 45;

		}
	}

}

package {

	public class M_PirateOrc extends Monster {

		public function M_PirateOrc(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.scimitar, Weapons.lastHurrah);

			super.setStats(640, 80, 45, 0, 12, 8, 18, 4);

			super.nameString = "Pirate Orc";
			
			super.description = "Very high attack. Its healing is only useful in dire circumstances.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Pirate Orc", 10, 12500, 7);
			
			super.soundIndex = 45;

		}
	}

}

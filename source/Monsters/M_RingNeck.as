package {

	public class M_RingNeck extends Monster {

		public function M_RingNeck(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.mightyPeck);

			super.setStats(605, 0, 36, 0, 18, 12, 22, 5);

			super.nameString = "Ring Neck";
			
			super.description = "A suped-up relative of the cassowary. Mighty peck packs a mighty punch.";
			
			super._healthBar.y = super._healthBar.y - 3;
			
			super.setStats2("Ring Neck", 6, 12500, 7);
			
			super.soundIndex = 48;

		}
	}

}

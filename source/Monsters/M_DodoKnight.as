package {

	public class M_DodoKnight extends Monster {

		public function M_DodoKnight(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.halbird);

			super.setStats(1180, 0, 36, 0, 28, 14, 22, 3);

			super.nameString = "Dodo Knight";
			
			super.description = "Contrary to popular belief, dodos would have taken over the world if not driven to extinction.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Dodo Knight", 9, 12500, 7);
			
			super.soundIndex = 46;

		}
	}

}

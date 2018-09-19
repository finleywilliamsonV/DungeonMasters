package {

	public class M_IceKing extends Monster {

		public function M_IceKing(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.deepFreeze, Weapons.icyTouch);

			super.setStats(550, 600, 11, 48, 8, 42, 16, 5);

			super.nameString = "Ice King";
			
			super.description = "A powerful wizard, king of the snow. Can repeatedly freeze opponents for devastating results.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Ice King", 13, 12500, 7);

		}
	}

}

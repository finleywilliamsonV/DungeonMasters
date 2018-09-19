package {

	public class M_Genie extends Monster {

		public function M_Genie(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.badWish, Weapons.magicFist);

			super.setStats(450, 450, 4, 23, 6, 18, 12, 5);

			super.nameString = "Genie";
			
			super.description = "On loan from Aladdin. Less fairy godmother, more monkey's paw.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Genie", 9, 12500, 7);

		}
	}

}

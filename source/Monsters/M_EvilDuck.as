package {

	public class M_EvilDuck extends Monster {

		public function M_EvilDuck(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.beakPinch, Weapons.meanEyes);

			super.setStats(80, 20, 2, 0, 2, 2, 4, 4);

			super.nameString = "Evil Duck";
			
			super.description = "One bad quacker. You should have brought some bread."
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Evil Duck", 1, 12500, 7);
			
			super.soundIndex = 37;

		}
	}

}

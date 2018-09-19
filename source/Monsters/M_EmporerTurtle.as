package {

	public class M_EmporerTurtle extends Monster {

		public function M_EmporerTurtle(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.bite);

			super.setStats(850, 0, 6, 0, 16, 16, 2, 2);

			super.nameString = "Emporer Turtle";
			
			super.description = "500 years old, its shell is almost impenetrable.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Emporer Turtle", 5, 12500, 7);

		}
	}

}

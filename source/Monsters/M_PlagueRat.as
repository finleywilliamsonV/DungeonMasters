package {

	public class M_PlagueRat extends Monster {

		public function M_PlagueRat(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.spreadDisease);

			super.setStats(75, 0, 3, 0, 3, 0, 4, 3);

			super.nameString = "Plague Rat";
			
			super.description = "This critter fed on toxic garbage its whole life. Low stats, but its bite can inflict long-term damage. Sick.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Plague Rat", 2, 12500, 7);

		}
	}

}

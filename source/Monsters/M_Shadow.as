package {

	public class M_Shadow extends Monster {

		public function M_Shadow(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.pester);

			super.setStats(50, 0, 0, 1, 4, 4, 4, 4);

			super.nameString = "Shadow";
			
			super.description = "Its ephemeral body gives it high defense, but doesn't provide much for an attack.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Shadow", 1, 12500, 7);

		}
	}

}

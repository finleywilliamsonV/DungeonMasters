package {

	public class M_MudBeast extends Monster {

		public function M_MudBeast(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.dirtBall);

			super.setStats(690, 0, 4, 0, 6, 8, 2, 5);

			super.nameString = "Mud Beast";
			
			super.description = "Made entirely of angry dirt. High defense and a ranged attack.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Mud Beast", 4, 12500, 7);

		}
	}

}

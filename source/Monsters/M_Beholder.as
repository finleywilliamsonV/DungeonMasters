package {

	public class M_Beholder extends Monster {

		public function M_Beholder(mg: MasterGrid) {

			super(mg);

			super._attacks.push(Weapons.eyeRay_Magic, Weapons.eyeRay_Fire, Weapons.eyeRay_Ice, Weapons.eyeRay_Shock);

			super.setStats(1800, 720, 4, 62, 26, 32, 34, 6);

			super.nameString = "Beholder";
			
			super.description = "A terrifying monster from the depths of the void realm. The Beholder wields unmatched power, obliterating adventurers with a barrage of multi-element magic energy.";
			
			//super._healthBar.y = super._healthBar.y - 5;
			
			super.setStats2("Beholder", 15, 12500, 7);

		}
		
		override public function selectBestAttack() : void {
			
			super._currentlySelectedAttack = super.abilities[int(Math.random() * super.abilities.length)];
			
			
		}
	}

}

package  {
	
	public class D_FireDoor extends LockedDoor  {

		public function D_FireDoor(mg: MasterGrid) {
			// constructor code
			super(mg);
			super.setStats("Fire Door", 200, 500, Weapons.door_Fire, 1000);
		}

	}
	
}

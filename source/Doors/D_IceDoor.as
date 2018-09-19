package  {
	
	public class D_IceDoor extends LockedDoor  {

		public function D_IceDoor(mg: MasterGrid) {
			// constructor code
			super(mg);
			super.setStats("Ice Door", 200, 500, Weapons.door_Ice, 1000);
		}

	}
	
}

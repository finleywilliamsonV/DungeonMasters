package  {
	
	public class D_ConfuseDoor extends LockedDoor  {

		public function D_ConfuseDoor(mg: MasterGrid) {
			// constructor code
			super(mg);
			super.setStats("Confuse Door", 200, 50, Weapons.door_Confuse, 10000);
		}

	}
	
}

package  {
	
	public class M_ScaredyCat extends Monster {
		
		public function M_ScaredyCat(mg:MasterGrid) {
			
			super(mg);
			
			super._attacks.push(Weapons.softPaws);
			
			//super.setStats(40, 0, 6, 0, 2, 0, 8, 3);
			
			super.setStats(25, 0, 0, 0, 0, 0, 0, 5);
			
			super.nameString = "Kitty Kitty";
			
			//super.description = "Runs from everything. Useful as a distraction, Scaredy Cat only attacks when cornered.";
			
			super.description = "Terrible unit.";
			
			super.setStats2("Kitty Kitty", 1, 50, 1);
		}
		
		//override public function update():void {
		//	
		//	if (currentFrame == 1) gotoAndStop(2);
		//	else gotoAndStop(1);
		//	
		//	super.selectBestAttack();
		//	
		//	super.checkStatuses();
		//	
		//	if (super._logicIndex == 0) {

		//		super.lookForDanger();
		//		
		//	} else {
		//		
		//		followPath();
		//	}
		//	
		//}
		//
		//override public function tryUnoccupiedSpace(): Boolean {
		//	var tempArray: Array = DungeonPathfinder.getNodesInAreaUnoccupied(super.currentNode, super.masterGrid);
		//	//trace("					UNOCCUPIED SPACES " + tempArray);
		//	if (tempArray.length > 0) {
		//		super.setDestination(tempArray[int(Math.random() * tempArray.length)]);
		//		
		//	} else {
		//		return false;
		//	}

		//	super.currentNode.exitNode(this);
		//	super.currentNode = super.currentPath[super.pathIndex];
		//	super.currentNode.enterNode(this);
		//	
		//	return true;
		//}
		
	}
	
}

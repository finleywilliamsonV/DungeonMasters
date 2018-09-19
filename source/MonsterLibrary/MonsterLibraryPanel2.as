package  {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class MonsterLibraryPanel extends MovieClip {
		
		// above
		public var monsterBuyPanel:MonsterBuyPanel;
		
		// below
		public var currentMonsters:Array;
		public var libraryItems:Array;
		public var libraryPanel:Sprite;
		
		
		// constructor code
		public function MonsterLibraryPanel($monsterBuyPanel:MonsterBuyPanel) {			
			
			// parent
			monsterBuyPanel = $monsterBuyPanel;
			
			currentMonsters = [];
			libraryItems = [];
			
			// empty sprite to hold library items
			libraryPanel = new Sprite();
			//addChild(libraryPanel);
		}
		
		// setup library items
		
		public function setup($monstersToList:Array): void {
			
			for each (var monster:Monster in $monstersToList) {
				var newLibraryItem:MonsterLibraryItem = new MonsterLibraryItem(this, monster, false, false);
				libraryItems.push(newLibraryItem);
			}
			
			displayLibraryItems();
		}
		
		
		public function reset(): void {
			
			for (var i:int = libraryItems.length - 1; i >= 0 ; i--) {
				var currentItem:MonsterLibraryItem = libraryItems[i];
				libraryPanel.removeChild(currentItem);
				currentItem.destroy();
				libraryItems.pop();
			}
		}
		
		private function displayLibraryItems() : void {
			
			var col :int = 0;
			var row :int = 0;
			
			for (var i:int = 0; i < libraryItems.length; i++) {
				
				var currentItem:MonsterLibraryItem = libraryItems[i];

				libraryPanel.addChild(currentItem);
				
				currentItem.x = 100 * col;
				currentItem.y = 100 * row;
				
				trace("CURRENT ITEM - X: " + currentItem.x + " Y: " + currentItem.y);
				trace("CURRENT ITEM - STAGE: " + currentItem.stage + " VISIBLE: " + currentItem.visible + " PARENT: " + currentItem.parent);
				
				col ++;
				if (col == 4) {
					col = 0;
					row++;
				}
				
				if (GlobalUnlockTracker.instance.isUnlocked(GlobalVariables.instance.getClass(currentItem.monster))) currentItem.lockGraphic.visible = false;
				else currentItem.lockGraphic.visible = true;
			}
		}
	}
	
}

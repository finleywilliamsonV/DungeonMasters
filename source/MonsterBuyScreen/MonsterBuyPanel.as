package  {
	
	import flash.display.MovieClip;
	
	
	public class MonsterBuyPanel extends MovieClip {
		
		// above
		public var monsterBuyScreen:MonsterBuyScreen;
		
		// below
		public var monsterLibraryPanel:MonsterLibraryPanel;
		
		public var monsterInfoPanel:MonsterInfoPanel;
		
		
		// constructor code
		public function MonsterBuyPanel($monsterBuyScreen:MonsterBuyScreen) {
			
			monsterBuyScreen = $monsterBuyScreen;
			
			monsterLibraryPanel = new MonsterLibraryPanel(this);
			addChild(monsterLibraryPanel);
			monsterLibraryPanel.x = 0;
			monsterLibraryPanel.y = 100;
			setChildIndex(monsterLibraryPanel, 1);
			
			monsterInfoPanel = new MonsterInfoPanel(this);
			addChild(monsterInfoPanel);
			monsterInfoPanel.x = 500;
			monsterInfoPanel.y = 100;
			setChildIndex(monsterInfoPanel, 2);
			
			easyButton.newUnlockBubble.visible = false;
			mediumButton.newUnlockBubble.visible = false;
			hardButton.newUnlockBubble.visible = false;
			
			//easySelector.visible = false;
			//mediumSelector.visible = false;
			//hardSelector.visible = false;
		}
		
		public function setup($monstersToList:Array, $equipedMonster:Monster = null) :void {
			
			monsterLibraryPanel.reset();
			monsterLibraryPanel.setup($monstersToList, $equipedMonster);
			
			if ($equipedMonster) monsterInfoPanel.setSelected($equipedMonster);
			else monsterInfoPanel.setSelected($monstersToList[0]);
			
			monsterBuyScreen.selectedMonster = $monstersToList[0];
			
			GlobalUnlockTracker.instance.newUnlockBubbleHandler.register(easyButton);
			GlobalUnlockTracker.instance.newUnlockBubbleHandler.register(mediumButton);
			GlobalUnlockTracker.instance.newUnlockBubbleHandler.register(hardButton);
			
			var tempArray:Array = GlobalUnlockTracker.instance.newUnlockBubbleHandler.bubblesToShow;
			
			for each (var monsterClass:Class in tempArray) {
				var tempMonster : Monster = new monsterClass(GlobalVariables.instance.masterGrid);
				
				if (tempMonster.starLevel < 6) {
						easyButton.newUnlockBubble.visible = true;
					} else if (tempMonster.starLevel < 11) {
						mediumButton.newUnlockBubble.visible = true;
					} else {
						hardButton.newUnlockBubble.visible = true;
					}
				
				tempMonster.destroy();
			}
		}
		
		
		public function reset(): void {
			
			
		}
	}
	
}

package {

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;
	import flash.net.getClassByAlias;
	import flash.utils.getDefinitionByName;

	public class MonsterLibraryPanel extends MovieClip {

		// above
		public var monsterBuyPanel: MonsterBuyPanel;

		// below
		public var currentMonsters: Array;
		public var libraryItems: Array;
		public var libraryPanel: Sprite;
		
		private var backgroundSprite:Sprite;
		


		// constructor code
		public function MonsterLibraryPanel($monsterBuyPanel: MonsterBuyPanel) {

			// parent
			monsterBuyPanel = $monsterBuyPanel;

			currentMonsters = [];
			libraryItems = [];
			
			// create and add background sprite
			backgroundSprite = new Sprite();
			addChild(backgroundSprite);

			// empty sprite to hold library items
			libraryPanel = new Sprite();
			addChild(libraryPanel);
		}

		// setup library items

		public function setup($monstersToList: Array, $equipedMonster: Monster = null): void {

			trace("\nStarting monster library panel setup - equipped monster: " + $equipedMonster);
			var isEquipped: Boolean = false;

			if ($equipedMonster) {
				var equippedMonsterClass: Class = getDefinitionByName(getQualifiedClassName($equipedMonster)) as Class;
				trace("Equipped Monster: " + equippedMonsterClass);
			}



			for each(var monster: Monster in $monstersToList) {

				if ($equipedMonster && monster is equippedMonsterClass) isEquipped = true;
				else isEquipped = false;

				trace("\nMONSTER: " + monster + " - IS EQUIPPED: " + isEquipped);

				var newLibraryItem: MonsterLibraryItem = new MonsterLibraryItem(this, monster, false, isEquipped);
				libraryItems.push(newLibraryItem);

				GlobalUnlockTracker.instance.newUnlockBubbleHandler.register(newLibraryItem);
			}

			displayLibraryItems();
		}


		public function reset(): void {
			
			trace("\nStarting monster library panel reset");

			for (var i: int = libraryItems.length - 1; i >= 0; i--) {
				var currentItem: MonsterLibraryItem = libraryItems[i];
				
				trace("DESTROYING LIBRARY ITEM: " + currentItem.monsterClass);
				trace("Equipped Check (before): " + currentItem.isEquipped);
				
				libraryPanel.removeChild(currentItem);
				currentItem.destroy();
				libraryItems.pop();
				
				
				trace("Equipped Check (after): " + currentItem.isEquipped);
			}
			
			trace("Current Library Items after destroy(): " + libraryItems);

			GlobalUnlockTracker.instance.newUnlockBubbleHandler.resetRegisteredLibraryItems();
		}

		private function displayLibraryItems(): void {
			
			// color and add background sprite
			var categoryColor:uint;
			if (monsterBuyPanel.monsterBuyScreen.monsterCategory == "bronze") {
				categoryColor = 0x3F342C;
			} else if (monsterBuyPanel.monsterBuyScreen.monsterCategory == "silver") {
				categoryColor = 0x3B4444;
			} else {
				categoryColor = 0x6D6149;
			}
			
			trace("monsterBuyPanel.monsterBuyScreen.monsterCategory: " + monsterBuyPanel.monsterBuyScreen.monsterCategory);

			
			// clear and redraw backgroundSprite
			backgroundSprite.graphics.clear();
			backgroundSprite.graphics.beginFill(categoryColor);
			backgroundSprite.graphics.drawRect(0,0,500,610);
			//addChild(backgroundSprite);
			
			
			// add library items and arrange
			var col: int = 0;
			var row: int = 0;
			var equipped: MonsterLibraryItem;
			var selected: MonsterLibraryItem;

			for (var i: int = 0; i < libraryItems.length; i++) {
				var currentItem: MonsterLibraryItem = libraryItems[i];

				libraryPanel.addChild(currentItem);

				//trace("\nBUBBLES TO SHOW: " + GlobalUnlockTracker.instance.newUnlockBubbleHandler.bubblesToShow);

				// HANDLE UNLOCK BUBBLES
				if (GlobalUnlockTracker.instance.newUnlockBubbleHandler.bubblesToShow.indexOf(GlobalVariables.instance.getClass(currentItem.monster)) >= 0) {
					currentItem.newUnlockBubble.visible = true;
					
					if (currentItem.monster.starLevel < 6) {
						monsterBuyPanel.easyButton.newUnlockBubble.visible = true;
					} else if (currentItem.monster.starLevel < 11) {
						monsterBuyPanel.mediumButton.newUnlockBubble.visible = true;
					} else {
						monsterBuyPanel.hardButton.newUnlockBubble.visible = true;
					}
				} // END HANDLE UNLOCK BUBBLES

				currentItem.x = 125 * col;
				currentItem.y = 125 * row;

				//trace("CURRENT ITEM - X: " + currentItem.x + " Y: " + currentItem.y);
				//trace("CURRENT ITEM - STAGE: " + currentItem.stage + " VISIBLE: " + currentItem.visible + " PARENT: " + currentItem.parent);

				col++;
				if (col == 4) {
					col = 0;
					row++;
				}

				if (GlobalUnlockTracker.instance.isUnlocked(GlobalVariables.instance.getClass(currentItem.monster))) currentItem.lockGraphic.visible = false;
				else currentItem.lockGraphic.visible = true;

				if (currentItem.isEquipped) {
					equipped = currentItem;
					monsterBuyPanel.monsterBuyScreen.selectorGraphic.x = currentItem.x + monsterBuyPanel.y + monsterBuyPanel.monsterBuyScreen.y;
					monsterBuyPanel.monsterBuyScreen.selectorGraphic.y = currentItem.y + monsterBuyPanel.y + monsterBuyPanel.monsterBuyScreen.y + 100;
					monsterBuyPanel.monsterBuyScreen.selectorGraphic.visible = true;
				}


			}

			// set equipped to top of display list
			if (equipped) libraryPanel.setChildIndex(equipped, libraryPanel.numChildren - 1);
		}
	}

}
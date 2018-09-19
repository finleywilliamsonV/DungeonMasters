package {
	import flash.display.Sprite;

	public class NewUnlockBubbleHandler {


		public var buyNewButton: * ;
		public var mbs_EasyButton: * ;
		public var mbs_MediumButton: * ;
		public var mbs_HardButton: * ;

		public var monsterLibraryItems: Array = [];

		public var easyLibraryItemsWithBubble: Array = [];
		public var mediumLibraryItemsWithBubble: Array = [];
		public var hardLibraryItemsWithBubble: Array = [];

		public var bubblesToShow: Array;


		public function NewUnlockBubbleHandler() {
			// constructor code
		}


		// register()
		// stores the references of all objects requiring bubble handling
		// called from each object internally at runtime
		public function register(thisObject: * ) {

			if (thisObject is UI_SlotPanel_SellButton) { // buy new button
				buyNewButton = thisObject as UI_SlotPanel_SellButton;
			} else if (thisObject is MBS_EasyButton) {
				mbs_EasyButton = thisObject as MBS_EasyButton;
			} else if (thisObject is MBS_MediumButton) {
				mbs_MediumButton = thisObject as MBS_MediumButton;
			} else if (thisObject is MBS_HardButton) {
				mbs_HardButton = thisObject as MBS_HardButton;
			} else if (thisObject is MonsterLibraryItem) {
				monsterLibraryItems.push(thisObject);

				var thisMonster: Monster = thisObject.monster;

				if (thisMonster.starLevel < 6) {
					easyLibraryItemsWithBubble.push(thisObject);
				} else if (thisMonster.starLevel < 11) {
					mediumLibraryItemsWithBubble.push(thisObject);
				} else {
					hardLibraryItemsWithBubble.push(thisObject);
				}
			}

			//trace("REGISTERED ITEMS: " + monsterLibraryItems.length);
		}

		public function resetRegisteredLibraryItems(): void {
			monsterLibraryItems = [];
		}


		// registerUnlock()
		// adds (!) to library item, calculates/adds to buyNew & category button
		// called from UnlockCriteria || DungeonAlert
		public function registerUnlock(thisCriteria: UnlockCriteria): void {

			// add (!) to lib item

			bubblesToShow.push(thisCriteria.monsterToUnlock);
			trace("BUBBLES TO SHOW (handler): " + bubblesToShow);
			
			GlobalUnlockTracker.instance.saveBubbles(bubblesToShow);

			buyNewButton.newUnlockBubble.visible = true;

			// add item to appropriate array

			// add (!) to buyNew button

			// add (!) to category
		}



		// removeBubble()

		public function removeBubble(fromThis: MonsterLibraryItem): void {

			// remove (!) from lib item

			var stillEasy: Boolean = false;
			var stillMedium: Boolean = false;
			var stillHard: Boolean = false;
			var stillAny: Boolean = false;
			
			fromThis.newUnlockBubble.visible = false;
			
			bubblesToShow.splice(bubblesToShow.indexOf(fromThis.monsterClass),1);
			
			GlobalUnlockTracker.instance.saveBubbles(bubblesToShow);

			trace("\nSTART COMPUTING");
			trace("Bubbles to Show: " + bubblesToShow);

			for each(var bubbleClass: Class in bubblesToShow) {

				var tempMonster: Monster = new bubbleClass(GlobalVariables.instance.masterGrid);

				trace("\ntempMonster: " + tempMonster);
				trace("level: " + tempMonster.starLevel);

				if (tempMonster.starLevel < 6) { // bronze
					stillEasy = true;
				} else if (tempMonster.starLevel < 11) { // silver
					stillMedium = true;
				} else { // gold
					stillHard = true;
				}
				
				trace("stillEasy: " + stillEasy);
				trace("stillMedium: " + stillMedium);
				trace("stillHard: " + stillHard);

				tempMonster.destroy();
			}

			if (stillEasy || stillMedium || stillHard) stillAny = true;

			trace("\n\nDONE COMPUTING");
			trace("stillEasy: " + stillEasy);
			trace("stillMedium: " + stillMedium);
			trace("stillHard: " + stillHard);
			trace("stillAny: " + stillAny);

			if (!stillEasy) {
				mbs_EasyButton.newUnlockBubble.visible = false;
			}

			if (!stillMedium) {
				mbs_MediumButton.newUnlockBubble.visible = false;
			}

			if (!stillHard) {
				mbs_HardButton.newUnlockBubble.visible = false;
			}

			if (!stillAny) {
				buyNewButton.newUnlockBubble.visible = false;
			}

			// remove item from bubble arrays

			// check specific category array for remaining, if none, remove from category button

			// check category arrays for remaining, if none, remove from buy new button
		}


	}

}
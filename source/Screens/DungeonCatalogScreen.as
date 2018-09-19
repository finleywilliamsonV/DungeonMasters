package {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;


	public class DungeonCatalogScreen extends MovieClip {


		private var _gs: GameplayScreen;
		private var dungeon: Dungeon;
		
		private var _dungeonClasses:Array = GlobalVariables.dungeonClasses;
		private var _dIndex :int = 0;

		public function DungeonCatalogScreen($gameplayScreen: GameplayScreen) {
			// constructor code
			gotoAndStop(1);
			_gs = $gameplayScreen;

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
		}

		public function onAddedToStage(e: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true);

			_gs.dm.isPaused = true;
			
			_dIndex = _gs.currentDungeon.dungeonMapIndex - 1;

			// add onClick listener
			addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}

		public function onRemovedFromStage(e: Event): void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);

			// remove onClick listener
			removeEventListener(MouseEvent.CLICK, onClick);
		}


		public function onClick(e: MouseEvent = null): void {

			e.stopPropagation();

			trace("\nDungeon Catalog Click - " + e.target);

			var target = e.target;

			if (target is TextField) {
				target = target.parent;
			}

			if (target == purchaseButton) {

				trace(" - Purchase Button Clicked");

				if (_gs.gold < dungeon.goldCost) return;

				//_gs.goldDisplay.gold -= dungeon.goldCost;	find it

				_gs.purchaseDungeon(dungeon);
				
				_gs.saveData();

			}
			
			
			else if (target == nextButton) {

				_dIndex++;
				if (_dIndex >= _dungeonClasses.length) {
					_dIndex = 0;
				}
				setup();
				
			} else if (target == previousButton) {
				
				_dIndex--;
				if (_dIndex < 0) {
					_dIndex = _dungeonClasses.length-1;
				}
				setup();
				
			} else if (target == exitButton) {
				_gs.removeChild(this);
				_gs.dm.isPaused = false;
			}

		}

		public function setup() {
			
			var dungeonClass :Class = _dungeonClasses[_dIndex];
			dungeon = new dungeonClass();

			dungeonNameText.text = dungeon.nameString;
			playerGoldText.text = String(_gs.gold);
			dungeonMapDisplay.gotoAndStop(dungeon.dungeonMapIndex);
			mSlotText.text = String(dungeon.monsterSlots);
			tSlotText.text = String(dungeon.trapSlots);
			dSlotText.text = String(dungeon.doorSlots);
			cSlotText.text = String(dungeon.chestSlots);
			descriptionText.text = dungeon.description;
			goldCostText.text = String(dungeon.goldCost);
			
			//trace(_gs.currentDungeonName);
			//trace(dungeon.nameString);
			
			if (_gs.currentDungeonName == dungeon.nameString) {
				alreadyPurchasedGraphic.visible = true;
			} else {
				alreadyPurchasedGraphic.visible = false;
			}
		}

	}

}
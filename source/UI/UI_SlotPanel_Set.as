package {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class UI_SlotPanel_Set extends MovieClip {

		private var _slotType: String;
		private var _slot;
		private var _selected: * ;
		private var _unit: * ;
		
		private var _gs:GameplayScreen;
		
		private var _abilitiesBar : UI_AbilitiesBar;
		//private var _ui_unitViewer: UI_UnitViewer;

		private var _ui_unitViewer2: UI_UnitViewer;
		
		private var _starDisplay:StarDisplay;

		public function UI_SlotPanel_Set() {
			// constructor code
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			gotoAndStop(1);

			//_ui_unitViewer = new UI_UnitViewer();
			//addChild(_ui_unitViewer);

			/*_ui_unitViewer.scaleX = 1.5;
			_ui_unitViewer.scaleY = 1.5;
			
			_ui_unitViewer.x = 4;
			_ui_unitViewer.y = 47;*/
			
			_abilitiesBar = new UI_AbilitiesBar();
			
		}

		public function onAddedToStage(e: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true);
			
			_gs = GlobalVariables.instance.masterGrid.gameplayScreen;
			
			// add onClick listener
			addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}

		public function onRemovedFromStage(e: Event): void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);

			// reset / remove viewer 2 if still on stage
			if (_ui_unitViewer2 && _ui_unitViewer2.stage) {
				removeChild(_ui_unitViewer2);
				_ui_unitViewer2.reset();
			}

			// remove onClick listener
			removeEventListener(MouseEvent.CLICK, onClick);
		}

		public function setup(selected: * ): void { //TDC & SpawnPoint incoming

			_selected = selected;


			// monster
			if (selected is SpawnPoint) {
				_slotType = GlobalVariables.TYPE_MONSTER;
				gotoAndStop(1);

				_ui_unitViewer2 = new UI_UnitViewer();
				addChild(_ui_unitViewer2);

				_ui_unitViewer2.scaleX = 1.75;
				_ui_unitViewer2.scaleY = 1.75;

				_ui_unitViewer2.x = -8;
				_ui_unitViewer2.y = 21;
				
				
				addChild(_abilitiesBar);
				_abilitiesBar.x = 14.8;
				_abilitiesBar.y = 361.85;


				// may be different for unit info
				_unit = new _selected.unit(GlobalVariables.instance.masterGrid); // could be replaced by a call to database


				_abilitiesBar.setup(_unit);

			} /*else if (selected is ITrap) {
				_slotType = GlobalVariables.TYPE_TRAP;
				
				addChild(_abilitiesBar);
				_abilitiesBar.x = 11.65;
				_abilitiesBar.y = 280;
				_abilitiesBar.setup(_selected);
				
				gotoAndStop(2);
				
			} else if (selected is IDoor) {
				_slotType = GlobalVariables.TYPE_DOOR;
				addChild(_abilitiesBar);
				_abilitiesBar.x = 11.65;
				_abilitiesBar.y = 280;
				_abilitiesBar.setup(_selected);
				
				gotoAndStop(3);

			} else if (selected is IChest) {
				_slotType = GlobalVariables.TYPE_CHEST;
				if (_abilitiesBar.stage) removeChild(_abilitiesBar);
				gotoAndStop(4);
			}*/

			update();
		}

		public function update(): void {
			
			if(!_unit)return;

			if (_slotType == GlobalVariables.TYPE_MONSTER) {

				_ui_unitViewer2.update(_unit);

				
				//currentUnitsText.text = _selected.unitsSpawned.length;
				//maxUnitsText.text = _selected.spawnMax;

				maxHealthText.text = _unit.maxHealth;
				maxManaText.text = _unit.maxMana;
				attackText.text = _unit.attack;
				defenseText.text = _unit.defense;
				magicAttackText.text = _unit.magicAttack;
				magicDefenseText.text = _unit.magicDefense;
				dexterityText.text = _unit.dexterity;
				sightDistanceText.text = _unit.sightDistance;

				nameText.text = _unit.ui_name;
				//goldCostText.text = String(_unit.goldCost / 10);
				starDisplay.setStars(_unit.starLevel);
			}


			//} else if (_slotType == GlobalVariables.TYPE_TRAP) {

			//	resetTimeDisplay.text = _selected.ticksTillReset;

			//	if (_selected.isSet) {
			//		isSetText.text = "ACTIVE";
			//	} else {
			//		isSetText.text = "INACTIVE";
			//	}

			//	difficultyText.text = _selected.difficulty;
			//	resetTimeText.text = _selected.timerLimit;

			//	nameText.text = _selected.ui_name;
			//	//goldCostText.text = String(_selected.goldCost / 10);
			//	starDisplay.setStars(_selected.starLevel);

			//} else if (_slotType == GlobalVariables.TYPE_DOOR) {

			//	resetTimeDisplay.text = _selected.ticksTillReset;

			//	if (_selected.isLocked) {
			//		isSetText.text = "LOCKED";
			//	} else {
			//		isSetText.text = "UNLOCKED";
			//	}

			//	difficultyText.text = _selected.difficulty;
			//	resetTimeText.text = _selected.timerLimit;

			//	nameText.text = _selected.ui_name;
			//	//goldCostText.text = String(_selected.goldCost / 10);
			//	starDisplay.setStars(_selected.starLevel);


			//} else if (_slotType == GlobalVariables.TYPE_CHEST) {

			//	currentGoldText.text = _selected.gold;
			//	
			//	maxGoldText.text = _selected.maxGold;

			//	nameText.text = _selected.ui_name;
			//	
			//	//goldCostText.text = String((_selected.goldCost / 10) + _selected.gold);
			//	starDisplay.setStars(_selected.starLevel);
			//}





			//_ui_unitViewer.update(_selected);


		}

		public function reset(): void {

			// clear references
			_slotType = "";
			_selected = null;
			_unit = null;
		}

		public function get selected(): * {
			return _selected;
		}


		public function get unit(): * {
			return _unit;
		}

		public function onClick(e: MouseEvent = null): void {

			e.stopPropagation();

			trace("\nSlotPanel_Buy Clicked");
			trace("Target: " + e.target);
			
			

			if (e.target is UI_SlotPanel_SellButton) {
				// sell selected
				trace("\nUI_SlotPanel_SellButton Clicked - " + _selected);
				var gs: GameplayScreen = parent.parent as GameplayScreen;
				gs.toMonsterBuyScreen(_selected);
				
				GlobalSounds.instance.click();
				
				
			} else if (e.target is UI_SlotPanel_AddGold) {
				trace("\nAdding Gold");
				var goldToAdd:int = int(modGoldText.text);
				trace("goldToAdd: " + goldToAdd);
				if (goldToAdd + _selected.gold > _selected.maxGold) goldToAdd = _selected.maxGold - _selected.gold;
				//_gs.goldDisplay.gold -= goldToAdd; find it
				_selected.addGold(goldToAdd);
				update();
				modGoldText.text = "";
				
			} else if (e.target is UI_SlotPanel_RemoveGold) {
				trace("\nRemoving Gold");
				var goldToRemove:int = int(modGoldText.text);
				if (goldToRemove > _selected.gold) goldToRemove = _selected.gold;
				//_gs.goldDisplay.gold += goldToRemove;
				_selected.removeGold(goldToRemove);
				update();
				modGoldText.text = "";
			}

		}
	}

}
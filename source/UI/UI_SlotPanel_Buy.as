package {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;


	public class UI_SlotPanel_Buy extends MovieClip {

		private var _slotType: String;
		private var _selected: LibraryItem;

		private var _abilitiesBar: UI_AbilitiesBar;

		private var _ui_unitViewer: UI_UnitViewer;
		private var _purchaseLibrary: PurchaseLibrary;

		public function UI_SlotPanel_Buy() {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			gotoAndStop(1);

			_ui_unitViewer = new UI_UnitViewer();
			addChild(_ui_unitViewer);

			_ui_unitViewer.scaleX = 1.25;
			_ui_unitViewer.scaleY = 1.25;

			_ui_unitViewer.x = 9;
			_ui_unitViewer.y = 43;

			_purchaseLibrary = new PurchaseLibrary();
			addChild(_purchaseLibrary);

			_abilitiesBar = new UI_AbilitiesBar();
		}

		public function onAddedToStage(e: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true);

			// add onClick listener
			addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}

		public function onRemovedFromStage(e: Event): void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);

			// RESETTING PURCHASE LIB
			_purchaseLibrary.reset();

			// remove onClick listener
			removeEventListener(MouseEvent.CLICK, onClick);
		}

		public function setup(slotType: String): void {

			// move to appropriate buy panel frame (MTDC)

			// populate purchaseLibrary with all available units

			// set selected to first unit in library
			// update selection square [m]

			// set name
			// set stars
			// set stats (BY TYPE)
			// set ability bar --- needs own class
			// set gold cost

			_slotType = slotType;

			if (slotType == GlobalVariables.TYPE_MONSTER) {
				gotoAndStop(1);
				_purchaseLibrary.populate(slotType);
				_purchaseLibrary.y = 410;

				addChild(_abilitiesBar);
				_abilitiesBar.x = 11.65;
				_abilitiesBar.y = 274.65;

			} else if (slotType == GlobalVariables.TYPE_TRAP) {
				gotoAndStop(2);
				_purchaseLibrary.populate(slotType);
				_purchaseLibrary.y = 300;

				addChild(_abilitiesBar);
				_abilitiesBar.x = 11.65;
				_abilitiesBar.y = 163.5;

			} else if (slotType == GlobalVariables.TYPE_DOOR) {
				gotoAndStop(3);
				_purchaseLibrary.populate(slotType);
				_purchaseLibrary.y = 300;

				addChild(_abilitiesBar);
				_abilitiesBar.x = 11.65;
				_abilitiesBar.y = 163.5;
				setChildIndex(_abilitiesBar,numChildren-1);

			} else if (slotType == GlobalVariables.TYPE_CHEST) {
				gotoAndStop(4);
				_purchaseLibrary.populate(slotType);
				_purchaseLibrary.y = 343;

				if (_abilitiesBar.stage) removeChild(_abilitiesBar);
			}

			// !!! FIX WITH OBJ POOLING OR DATABASE OF BASE UNIT STATS !!!

			// select first unit
			trace("purchaseLibrary.gridArray[0][0]: " + _purchaseLibrary.gridArray[0][0].unit);

			trace("Current Frame: " + currentFrame);

			trace("Abilities Bar: " + _abilitiesBar);

			setSelected(_purchaseLibrary.gridArray[0][0]);

			setChildIndex(_purchaseLibrary, numChildren - 1);

			//// may be different for unit info
			//var unitClass :Class = Class(_selected.unit); // could be replaced by a call to database
			//var unit = new unitClass(GlobalVariables.instance.masterGrid);

			//abilitiesBar.setup(_selected.unit);

			//update();
		}

		public function update(): void {

			var unit = _selected.unit;

			nameText.text = unit.ui_name;

			if (_slotType == GlobalVariables.TYPE_MONSTER) {

				maxHealthText.text = unit.maxHealth;
				maxManaText.text = unit.maxMana;
				attackText.text = unit.attack;
				defenseText.text = unit.defense;
				magicAttackText.text = unit.magicAttack;
				magicDefenseText.text = unit.magicDefense;
				dexterityText.text = unit.dexterity;
				sightDistanceText.text = unit.sightDistance;

			} else if (_slotType == GlobalVariables.TYPE_TRAP) {

				difficultyText.text = unit.difficulty;
				resetTimeText.text = unit.timerLimit;

			} else if (_slotType == GlobalVariables.TYPE_DOOR) {
				difficultyText.text = unit.difficulty;
				resetTimeText.text = unit.timerLimit;

			} else if (_slotType == GlobalVariables.TYPE_CHEST) {

				//damageText.text = unit.damage;
				//difficultyText.text = unit.difficulty;
				maxGoldText.text = unit.maxGold;
			}

			goldCostText.text = unit.goldCost;

			_ui_unitViewer.update(unit);

			starDisplay.setStars(unit.starLevel);
		}

		public function reset(): void {

			// clear references
			_slotType = "";
			_selected = null;

			gotoAndStop(1);

			_purchaseLibrary.reset();
		}


		public function onClick(e: MouseEvent = null): void {

			e.stopPropagation();

			trace("\nSlotPanel_Buy Clicked");
			trace("Target: " + e.target);

			if (e.target is UI_SlotPanel_BuyButton) {
				// purchase selected
				trace("\nUI_SlotPanel_BuyButton Clicked");
				var gs: GameplayScreen = parent.parent as GameplayScreen;
				//gs.purchaseItem(_selected);

			} else if (e.target is LibraryItem) {

				setSelected(LibraryItem(e.target));
			}

		}


		public function setSelected(item: LibraryItem) {
			_selected = item;
			_purchaseLibrary.setSelected(_selected);
			update();

			if (item.unit is IPurchasable && item.unit is IChest == false) _abilitiesBar.setup(item.unit);
		}
	}

}
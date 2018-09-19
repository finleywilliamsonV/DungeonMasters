package {

	import flash.display.MovieClip;
	import flash.utils.getQualifiedClassName;
	import flash.events.MouseEvent;


	public class UI_UnitInfo extends MovieClip {

		private var _unit: *;
		private var _ui_unitViewer:UI_UnitViewer;
		
		private var _setupRequired :Boolean;

		public function UI_UnitInfo() {
			// constructor code
			gotoAndStop(1);
			
			// for abilities bar
			_setupRequired = true;
			
			_ui_unitViewer = new UI_UnitViewer();
			addChild(_ui_unitViewer);
			
			_ui_unitViewer.scaleX = 1.5;
			_ui_unitViewer.scaleY = 1.5;
			
			_ui_unitViewer.x = 5;
			_ui_unitViewer.y = 40;
		}
		
		

		public function update(unit: * ): void {

			_unit = unit;

			if (unit is IMonster || unit is IAdventurer) {

				gotoAndStop(1);

				nameText.text = unit.ui_name;

				_healthBar.setMaxHealth(unit.maxHealth);
				_healthBar.set(unit.health);

				_manaBar.setMaxMana(unit.maxMana);
				_manaBar.set(unit.mana);

				healthText.text = unit.health;
				maxHealthText.text = unit.maxHealth;
				manaText.text = unit.mana;
				maxManaText.text = unit.maxMana;
				attackText.text = unit.attack;
				defenseText.text = unit.defense;
				magicAttackText.text = unit.magicAttack;
				magicDefenseText.text = unit.magicDefense;
				dexterityText.text = unit.dexterity;
				sightDistanceText.text = unit.sightDistance;
				
				_ui_unitViewer.update(unit);
				setChildIndex(_ui_unitViewer, numChildren-1);
				
				if (_setupRequired) {
					abilitiesBar.setup(_unit);
					_setupRequired = false;
				}
				
				
				
				starDisplay.setStars(_unit.starLevel);
				
				

			} else if (_unit is SpawnPoint) {
				gotoAndStop(2);

				disp_name.text = String(getQualifiedClassName(_unit));
				disp_nextSpawn.text = String(_unit.timerLength - _unit.spawnTimer);
				disp_inQueue.text = _unit.unitsToSpawn.length.toString();
				starDisplay.setStars(_unit.starLevel);
			} else if (_unit is IChest) {
				gotoAndStop(3);
				disp_contents.text = "Gold: " + _unit.gold;
				starDisplay.setStars(_unit.starLevel);
			} else if (_unit is ISlot) {
				gotoAndStop(4);
				//trace("\nSlot Selected @ " + _unit.currentNode);
			}
		}

		public function reset(): void {
			
			// for abilities bar
			_setupRequired = true;

			// frame 1
			gotoAndStop(1);

			nameText.text = "";

			_healthBar.setMaxHealth(0);
			_healthBar.set(0);

			_manaBar.setMaxMana(0);
			_manaBar.set(0);

			healthText.text = "-";
			maxHealthText.text = "-";
			manaText.text = "-";
			maxManaText.text = "-";
			attackText.text = "-";
			defenseText.text = "-";
			magicAttackText.text = "-";
			magicDefenseText.text = "-";
			dexterityText.text = "-";
			sightDistanceText.text = "-";

			// frame 2
			gotoAndStop(2);
			disp_nextSpawn.text = "-";
			disp_inQueue.text = "-";
			
			// frame 3
			gotoAndStop(3);
			disp_contents.text = "";


			gotoAndStop(1);
		}
	}

}
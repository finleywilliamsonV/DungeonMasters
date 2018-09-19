package {
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;

	public class DungeonAlertPanel extends Sprite {

		// class variables
		private var _alertArray: Array;
		private var _lineMax: int;
		private var _alertTimer: Timer;

		private var _ticksSinceLast: int;
		private var _ticksSinceLastMax: int;
		private var _alertQueue: Array;

		// colors
		private static const ADVENTURER_COLOR: uint = 0x33FFFF;
		private static const MONSTER_COLOR: uint = 0xFF6464;
		private static const DUNGEON_COLOR: uint = 0x9999FF;
		private static const GOLD_COLOR: uint = 0xFFBE48;
		private static const NOTORIETY_COLOR: uint = 0xCC99FF;
		private static const UNLOCK_COLOR: uint = 0x33FF99;
		private static const TRAP_COLOR: uint = 0xFF4D4D;
		private static const UNPAUSED_COLOR: uint = 0xFFCE9A;
		private static const PAUSED_COLOR: uint = 0xFFB485;


		// constructor code
		public function DungeonAlertPanel() {

			// instantiate variables
			_alertArray = [];
			_lineMax = 10;
			_alertTimer = new Timer(25);
			_alertTimer.start();
			_alertTimer.addEventListener(TimerEvent.TIMER, update, false, 0, true);

			_alertQueue = [];
			_ticksSinceLastMax = 5;
			_ticksSinceLast = _ticksSinceLastMax; // start at max
		}

		// update
		public function update(tE: TimerEvent = null, overridePauseControl:Boolean = false): void {

			if (GlobalVariables.instance.dm.isPaused && overridePauseControl == false) return;

			// increment ticks till last counter
			if (_ticksSinceLast < _ticksSinceLastMax) {
				_ticksSinceLast++;
			}

			// if any are in the queue, shift(), unshift to alertArray, reset counter
			if (_alertQueue.length > 0) {

				// if at least (max) ticks since last display
				if (_ticksSinceLast >= _ticksSinceLastMax) {

					_alertArray.unshift(_alertQueue.shift());

					_ticksSinceLast = 0;
				}

			}

			// temporary alert object
			var tempAlert: DungeonAlert;

			// clear panel
			removeChildren();

			// trim array to line max
			while (_alertArray.length > _lineMax) {
				tempAlert = _alertArray.pop();
				tempAlert.destroy();
			}

			// update and display each alert
			for (var i: int = 0; i < _alertArray.length; i++) {
				tempAlert = _alertArray[i];
				tempAlert.update();
				addChild(tempAlert);
				tempAlert.y = -(tempAlert.textHeight * i);
			}
		}


		// ALERT TYPES

		// Game pause/unpause
		public function newAlert_PauseToggle(isPaused: Boolean) {

			// new alert object
			var newAlert: DungeonAlert = new DungeonAlert();

			// set text
			var pausedText: String;
			if (isPaused) pausedText = "Paused";
			else pausedText = "Unpaused";
			var newText: String = String("Game " + pausedText);
			newAlert.setText(newText);

			// COLOR TEXT
			var format1: TextFormat = newAlert.getTextFormat(0, 5 + pausedText.length);
			if (isPaused) format1.color = PAUSED_COLOR;
			else format1.color = UNPAUSED_COLOR;
			newAlert.setTextFormat(format1, 0, 5 + pausedText.length);
			
			/*var format2: TextFormat = newAlert.getTextFormat(adventurerName.length + 9, adventurerName.length + 16);
			format2.color = DUNGEON_COLOR;
			newAlert.setTextFormat(format2, adventurerName.length + 9, adventurerName.length + 16);*/

			// add alert to alert queue
			_alertQueue.push(newAlert);
			update(null, true);
		}

		// ADV enter dungeon
		public function newAlert_AdventurerEnterDungeon(adventurerName: String) {

			// new alert object
			var newAlert: DungeonAlert = new DungeonAlert();

			// set text
			var newText: String = String(adventurerName + " entered dungeon.");
			newAlert.setText(newText);

			// COLOR TEXT
			var format1: TextFormat = newAlert.getTextFormat(0, adventurerName.length);
			format1.color = ADVENTURER_COLOR;
			newAlert.setTextFormat(format1, 0, adventurerName.length);

			var format2: TextFormat = newAlert.getTextFormat(adventurerName.length + 9, adventurerName.length + 16);
			format2.color = DUNGEON_COLOR;
			newAlert.setTextFormat(format2, adventurerName.length + 9, adventurerName.length + 16);

			// add alert to alert queue
			_alertQueue.push(newAlert);
		}

		// new monster spawned
		public function newAlert_MonsterSpawned(monsterName: String) {

			// new alert object
			var newAlert: DungeonAlert = new DungeonAlert();

			// set text
			var newText: String = String("A new " + monsterName + " spawned.");
			newAlert.setText(newText);

			// COLOR TEXT
			var format1: TextFormat = newAlert.getTextFormat(6, 6 + monsterName.length);
			format1.color = MONSTER_COLOR;
			newAlert.setTextFormat(format1, 6, 6 + monsterName.length);

			// add alert to alert queue
			_alertQueue.push(newAlert);
		}

		// adventurer defeated by trap
		public function newAlert_AdventurerDefeatedByTrap(adventurerName: String, trapName: String) {

			// new alert object
			var newAlert: DungeonAlert = new DungeonAlert();

			// set text
			var newText: String = String(adventurerName + " defeated by " + trapName + ".");
			newAlert.setText(newText);

			// COLOR TEXT
			var format1: TextFormat = newAlert.getTextFormat(0, adventurerName.length);
			format1.color = ADVENTURER_COLOR;
			newAlert.setTextFormat(format1, 0, adventurerName.length);

			var format2: TextFormat = newAlert.getTextFormat(adventurerName.length + 13, adventurerName.length + 13 + trapName.length);
			format2.color = TRAP_COLOR;
			newAlert.setTextFormat(format2, adventurerName.length + 13, adventurerName.length + 13 + trapName.length);

			// add alert to alert queue
			_alertQueue.push(newAlert);
		}

		// adventurer defeated by status
		public function newAlert_AdventurerDefeatedByStatus(adventurerName: String, statusName: String) {

			// new alert object
			var newAlert: DungeonAlert = new DungeonAlert();

			// set text
			var newText: String = String(adventurerName + " died by " + statusName + ".");
			newAlert.setText(newText);

			// COLOR TEXT
			var format1: TextFormat = newAlert.getTextFormat(0, adventurerName.length);
			format1.color = ADVENTURER_COLOR;
			newAlert.setTextFormat(format1, 0, adventurerName.length);

			var format2: TextFormat = newAlert.getTextFormat(adventurerName.length + 9, adventurerName.length + 9 + statusName.length);
			format2.color = MONSTER_COLOR;
			newAlert.setTextFormat(format2, adventurerName.length + 9, adventurerName.length + 9 + statusName.length);

			// add alert to alert queue
			_alertQueue.push(newAlert);
		}

		// adventurer defeated monster
		public function newAlert_AdventurerDefeatedMonster(adventurerName: String, monsterName: String) {

			// new alert object
			var newAlert: DungeonAlert = new DungeonAlert();

			// set text
			var newText: String = String(adventurerName + " defeated " + monsterName + ".");
			newAlert.setText(newText);

			// COLOR TEXT
			var format1: TextFormat = newAlert.getTextFormat(0, adventurerName.length);
			format1.color = ADVENTURER_COLOR;
			newAlert.setTextFormat(format1, 0, adventurerName.length);

			var format2: TextFormat = newAlert.getTextFormat(adventurerName.length + 10, adventurerName.length + 10 + monsterName.length);
			format2.color = MONSTER_COLOR;
			newAlert.setTextFormat(format2, adventurerName.length + 10, adventurerName.length + 10 + monsterName.length);

			// add alert to alert queue
			_alertQueue.push(newAlert);
		}

		// monster defeated adventurer
		public function newAlert_MonsterDefeatedAdventurer(monsterName: String, adventurerName: String) {

			// new alert object
			var newAlert: DungeonAlert = new DungeonAlert();

			// set text
			var newText: String = String(monsterName + " defeated " + adventurerName + ".");
			newAlert.setText(newText);

			// COLOR TEXT
			var format1: TextFormat = newAlert.getTextFormat(0, monsterName.length);
			format1.color = MONSTER_COLOR;
			newAlert.setTextFormat(format1, 0, monsterName.length);

			var format2: TextFormat = newAlert.getTextFormat(monsterName.length + 10, monsterName.length + 10 + adventurerName.length);
			format2.color = ADVENTURER_COLOR;
			newAlert.setTextFormat(format2, monsterName.length + 10, monsterName.length + 10 + adventurerName.length);

			// add alert to alert queue
			_alertQueue.push(newAlert);
		}

		// monster defeated monster
		public function newAlert_MonsterDefeatedMonster(monsterName: String, monster2Name: String) {

			// new alert object
			var newAlert: DungeonAlert = new DungeonAlert();

			// set text
			var newText: String = String(monsterName + " defeated " + monster2Name + ".");
			newAlert.setText(newText);

			// COLOR TEXT
			var format1: TextFormat = newAlert.getTextFormat(0, monsterName.length);
			format1.color = MONSTER_COLOR;
			newAlert.setTextFormat(format1, 0, monsterName.length);

			var format2: TextFormat = newAlert.getTextFormat(monsterName.length + 10, monsterName.length + 10 + monster2Name.length);
			format2.color = MONSTER_COLOR;
			newAlert.setTextFormat(format2, monsterName.length + 10, monsterName.length + 10 + monster2Name.length);

			// add alert to alert queue
			_alertQueue.push(newAlert);
		}

		// adventurer defeated adventurer
		public function newAlert_AdventurerDefeatedAdventurer(adventurerName: String, adventurer2Name: String) {

			// new alert object
			var newAlert: DungeonAlert = new DungeonAlert();

			// set text
			var newText: String = String(adventurerName + " defeated " + adventurer2Name + ".");
			newAlert.setText(newText);

			// COLOR TEXT
			var format1: TextFormat = newAlert.getTextFormat(0, adventurerName.length);
			format1.color = ADVENTURER_COLOR;
			newAlert.setTextFormat(format1, 0, adventurerName.length);

			var format2: TextFormat = newAlert.getTextFormat(adventurerName.length + 10, adventurerName.length + 10 + adventurer2Name.length);
			format2.color = ADVENTURER_COLOR;
			newAlert.setTextFormat(format2, adventurerName.length + 10, adventurerName.length + 10 + adventurer2Name.length);

			// add alert to alert queue
			_alertQueue.push(newAlert);
		}

		// monster unlocked
		public function newAlert_MonsterUnlocked(monsterName: String) {

			// new alert object
			var newAlert: DungeonAlert = new DungeonAlert();

			// set text
			var newText: String = String(monsterName + " now available to purchase!");
			newAlert.setText(newText);

			// COLOR TEXT
			var format1: TextFormat = newAlert.getTextFormat(0, monsterName.length);
			format1.color = MONSTER_COLOR;
			newAlert.setTextFormat(format1, 0, monsterName.length);

			var format2: TextFormat = newAlert.getTextFormat(monsterName.length + 4, monsterName.length + 27);
			format2.color = UNLOCK_COLOR;
			newAlert.setTextFormat(format2, monsterName.length + 4, monsterName.length + 27);

			// add alert to alert queue
			_alertQueue.push(newAlert);
		}

		// adventurer left dungeon
		public function newAlert_AdventurerLeftDungeon(adventurerName: String) {

			// new alert object
			var newAlert: DungeonAlert = new DungeonAlert();

			// set text
			var newText: String = String(adventurerName + " left the dungeon.");
			newAlert.setText(newText);

			// COLOR TEXT
			var format1: TextFormat = newAlert.getTextFormat(0, adventurerName.length);
			format1.color = ADVENTURER_COLOR;
			newAlert.setTextFormat(format1, 0, adventurerName.length);

			var format2: TextFormat = newAlert.getTextFormat(adventurerName.length + 10, adventurerName.length + 17);
			format2.color = DUNGEON_COLOR;
			newAlert.setTextFormat(format2, adventurerName.length + 10, adventurerName.length + 17);

			// add alert to alert queue
			_alertQueue.push(newAlert);
		}

		// adventurer left dungeon
		public function newAlert_NotorietyIncrease(notorietyLevel: int) {

			// new alert object
			var newAlert: DungeonAlert = new DungeonAlert();

			// set text
			var newText: String = String("Notoriety increased to level " + notorietyLevel + ".");
			newAlert.setText(newText);

			// COLOR TEXT
			var format1: TextFormat = newAlert.getTextFormat(0, 9);
			format1.color = NOTORIETY_COLOR;
			newAlert.setTextFormat(format1, 0, 9);

			var format2: TextFormat = newAlert.getTextFormat(23, 29 + String(notorietyLevel).length);
			format2.color = NOTORIETY_COLOR;
			newAlert.setTextFormat(format2, 23, 29 + String(notorietyLevel).length);

			// add alert to alert queue
			_alertQueue.push(newAlert);
		}

		// adventurer left dungeon
		public function newAlert_EarnedGold(gold: int) {

			if (gold <= 0) return;

			// new alert object
			var newAlert: DungeonAlert = new DungeonAlert();

			// set text
			var newText: String = String("You earned " + gold + " gold.");
			newAlert.setText(newText);

			// COLOR TEXT
			var format1: TextFormat = newAlert.getTextFormat(11, 16 + String(gold).length);
			format1.color = GOLD_COLOR;
			newAlert.setTextFormat(format1, 11, 16 + String(gold).length);

			// add alert to alert queue
			_alertQueue.push(newAlert);
		}

		// destroy
		public function destroy(): void {

			removeChildren();

			for each(var alert: DungeonAlert in _alertArray) {
				alert.destroy();
			}

			_alertArray = null;

			for each(var alert: DungeonAlert in _alertQueue) {
				alert.destroy();
			}

			_alertQueue = null;

			_alertTimer.removeEventListener(TimerEvent.TIMER, update);
			_alertTimer = null;
		}
	}

}
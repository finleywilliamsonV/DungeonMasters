package  {
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class DungeonAlertPanel extends Sprite {
		
		// class variables
		private var _alertArray:Array;
		private var _lineMax:int;
		private var _alertTimer:Timer;
		
		// colors
		private static const ADV_COLOR : uint = 0x33FFFF;
		private static const MON_COLOR : uint = 0xFF6464;
		private static const DUNGEON_COLOR : uint = 0x9999FF;
		private static const GOLD_COLOR : uint = 0xFFBE48;
		private static const NOTORIETY_COLOR : uint = 0xCC99FF;
		private static const UNLOCK_COLOR : uint = 0x33FF99;
		
		
		// constructor code
		public function DungeonAlertPanel() {
			
			// instantiate variables
			_alertArray = [];
			_lineMax = 6;
			_alertTimer = new Timer(25);
			_alertTimer.start();
			_alertTimer.addEventListener(TimerEvent.TIMER, update, false, 0, true);
		}
		
		// update
		public function update(tE:TimerEvent = null) : void {
			
			if (GlobalVariables.instance.dm.isPaused) return;

			// temporary alert object
			var tempAlert:DungeonAlert;
			
			// clear panel
			removeChildren();
			
			// trim array to line max
			while (_alertArray.length > _lineMax) {
				tempAlert = _alertArray.pop();
				tempAlert.destroy();
			}
			
			// update and display each alert
			for (var i : int = 0; i < _alertArray.length; i++ ) {
				tempAlert = _alertArray[i];
				tempAlert.update();
				addChild(tempAlert);
				tempAlert.y = -(tempAlert.textHeight * i);
			}
		}
		
		
		// ALERT TYPES
		
		// ADV enter dungeon
		public function newAlert_AdventurerEnterDungeon(adventurerName:String) {
			
			// new alert object
			var newAlert:DungeonAlert = new DungeonAlert();
			
			// set text
			var newText : String = String(adventurerName + " entered dungeon.");
			newAlert.setText(newText);
			
			// COLOR TEXT
			//
			//
			//
			//
			
			// add alert to array
			_alertArray.unshift(newAlert);
		}
		
		// new monster spawned
		public function newAlert_MonsterSpawned(monsterName:String) {
			
			// new alert object
			var newAlert:DungeonAlert = new DungeonAlert();
			
			// set text
			var newText : String = String("A new " + monsterName + " spawned.");
			newAlert.setText(newText);
			
			// COLOR TEXT
			//
			//
			//
			//
			
			// add alert to array
			_alertArray.unshift(newAlert);
		}
		
		// adventurer defeated monster
		public function newAlert_AdventurerDefeatedMonster(adventurerName:String, monsterName:String) {
			
			// new alert object
			var newAlert:DungeonAlert = new DungeonAlert();
			
			// set text
			var newText : String = String(adventurerName + " defeated " + monsterName + ".");
			newAlert.setText(newText);
			
			// COLOR TEXT
			//
			//
			//
			//
			
			// add alert to array
			_alertArray.unshift(newAlert);
		}
		
		// monster defeated adventurer
		public function newAlert_MonsterDefeatedAdventurer(monsterName:String, adventurerName:String) {
			
			// new alert object
			var newAlert:DungeonAlert = new DungeonAlert();
			
			// set text
			var newText : String = String(monsterName + " defeated " + adventurerName + ".");
			newAlert.setText(newText);
			
			// COLOR TEXT
			//
			//
			//
			//
			
			// add alert to array
			_alertArray.unshift(newAlert);
		}
		
		// monster unlocked
		public function newAlert_MonsterUnlocked(monsterName:String) {
			
			// new alert object
			var newAlert:DungeonAlert = new DungeonAlert();
			
			// set text
			var newText : String = String(monsterName + " now available to purchase!");
			newAlert.setText(newText);
			
			// COLOR TEXT
			//
			//
			//
			//
			
			// add alert to array
			_alertArray.unshift(newAlert);
		}
		
		// adventurer left dungeon
		public function newAlert_AdventurerLeftDungeon(adventurerName:String) {
			
			// new alert object
			var newAlert:DungeonAlert = new DungeonAlert();
			
			// set text
			var newText : String = String(adventurerName + " left the dungeon.");
			newAlert.setText(newText);
			
			// COLOR TEXT
			//
			//
			//
			//
			
			// add alert to array
			_alertArray.unshift(newAlert);
		}
		
		// adventurer left dungeon
		public function newAlert_NotorietyIncrease(notorietyLevel:int) {
			
			// new alert object
			var newAlert:DungeonAlert = new DungeonAlert();
			
			// set text
			var newText : String = String("Notoriety increased to level " + notorietyLevel);
			newAlert.setText(newText);
			
			// COLOR TEXT
			//
			//
			//
			//
			
			// add alert to array
			_alertArray.unshift(newAlert);
		}
		
		// adventurer left dungeon
		public function newAlert_EarnedGold(gold:int) {
			
			// new alert object
			var newAlert:DungeonAlert = new DungeonAlert();
			
			// set text
			var newText : String = String("You earned " + gold + " gold.");
			newAlert.setText(newText);
			
			// COLOR TEXT
			//
			//
			//
			//
			
			// add alert to array
			_alertArray.unshift(newAlert);
		}
		
		// destroy
		public function destroy() : void {
			
			removeChildren();
			
			for each (var alert:DungeonAlert in _alertArray) {
				alert.destroy();
			}
			
			_alertTimer.removeEventListener(TimerEvent.TIMER, update);
			_alertTimer = null;
		}
	}
	
}

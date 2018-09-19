package {

	import flash.net.SharedObject;
	import flash.utils.getQualifiedClassName;
	import flash.net.getClassByAlias;
	import flash.utils.getDefinitionByName;

	public class GlobalSharedObject {

		private static var _instance: GlobalSharedObject;
		private static var _allowInstantiation: Boolean;

		private static var _sharedObject: SharedObject;
		public static var localString: String = "MasterOfDungeons14"


		// v v v v v
		// Stored:
		//


		public static function get instance(): GlobalSharedObject {

			if (!_instance) {
				_allowInstantiation = true;
				_instance = new GlobalSharedObject();
				_allowInstantiation = false;

				_sharedObject = SharedObject.getLocal(localString);
			}
			return _instance;
		}
		
		
		/*
			what do you need to save
			
			- gold first
			- current dungeon
			- spawn points
			- notoriety
		
			- SERIALIZE UNLOCK TRACKER
				- array of unlock progress
				- iterate through all unlocks
				- store completion data
				- aggregate all data
				- call register methods?
				OR
				- keep track of all progress in member variables
				- serialze from the member variables
		*/
		
		
		//	------------------------------------------------------------------------------------
		
		// check if music register exists
		public function isMutedMusicCheck() : void {
			if (_sharedObject.data.isMutedMusic == null) {
				_sharedObject.data.isMutedMusic = false;
				_sharedObject.flush();
			}
		}
		
		// get music muted
		public function get isMutedMusic() : Boolean {
			isMutedMusicCheck();
			return _sharedObject.data.isMutedMusic;
		}
		
		// set isMutedMusic
		public function set isMutedMusic(tf:Boolean) : void {
			_sharedObject.data.isMutedMusic = tf;
			_sharedObject.flush();
		}
		
		//	------------------------------------------------------------------------------------
		
		// check if sfx register exists
		public function isMutedSFXCheck() : void {
			if (_sharedObject.data.isMutedSFX == null) {
				_sharedObject.data.isMutedSFX = false;
				_sharedObject.flush();
			}
		}
		
		// get sfx muted
		public function get isMutedSFX() : Boolean {
			isMutedSFXCheck();
			return _sharedObject.data.isMutedSFX;
		}
		
		// set isMutedSFX
		public function set isMutedSFX(tf:Boolean) : void {
			_sharedObject.data.isMutedSFX = tf;
			_sharedObject.flush();
		}
		
		//	------------------------------------------------------------------------------------
		
		// check if gold register exists
		public function goldCheck() : void {
			if (_sharedObject.data.gold == null) {
				_sharedObject.data.gold = GlobalVariables.STARTING_GOLD;
				_sharedObject.flush();
			}
		}
		
		// get gold
		public function get gold() : int {
			goldCheck();
			return _sharedObject.data.gold;
		}
		
		//	------------------------------------------------------------------------------------
		
		// check if totalNotoriety exists
		public function totalNotorietyCheck() : void {
			if (_sharedObject.data.totalNotoriety == null) {
				_sharedObject.data.totalNotoriety = 0;
				_sharedObject.flush();
			}
		}
		
		// get totalNotoriety
		public function get totalNotoriety() : int {
			totalNotorietyCheck();
			return _sharedObject.data.totalNotoriety;
		}
		
		// set totalNotoriety
		public function set totalNotoriety(total:int) : void {
			_sharedObject.data.totalNotoriety = total;
			_sharedObject.flush();
		}
		
		
		//	------------------------------------------------------------------------------------
		
		// check if remainingNotoriety exists
		public function remainingNotorietyCheck() : void {
			if (_sharedObject.data.remainingNotoriety == null) {
				_sharedObject.data.remainingNotoriety = 0;
				_sharedObject.flush();
			}
		}
		
		// get totalNotoriety
		public function get remainingNotoriety() : int {
			remainingNotorietyCheck();
			return _sharedObject.data.remainingNotoriety;
		}
		
		// set totalNotoriety
		public function set remainingNotoriety(total:int) : void {
			_sharedObject.data.remainingNotoriety = total;
			_sharedObject.flush();
		}
		
		
		//	------------------------------------------------------------------------------------
		
		// check if notorietyLevel exists
		public function notorietyLevelCheck() : void {
			if (_sharedObject.data.notorietyLevel == null) {
				_sharedObject.data.notorietyLevel = 1;
				_sharedObject.flush();
			}
		}
		
		// get notorietyLevel
		public function get notorietyLevel() : int {
			notorietyLevelCheck();
			return _sharedObject.data.notorietyLevel;
		}
		
		// set notorietyLevel
		public function set notorietyLevel(level:int) : void {
			_sharedObject.data.notorietyLevel = level;
			_sharedObject.flush();
		}
		
		
		//	------------------------------------------------------------------------------------
		
		// check if currentDungeon register exists
		public function currentDungeonCheck() : void {
			if (_sharedObject.data.currentDungeon == null) {
				_sharedObject.data.currentDungeon = GlobalVariables.STARTING_DUNGEON;
				_sharedObject.flush();
				//trace("\n SAVING DATA - currentDungeon - " + _sharedObject.data.currentDungeon);
			}
		}
		
		// get current dungeon
		public function get currentDungeon() : Class {
			currentDungeonCheck();
			var classReference:Class = getDefinitionByName(_sharedObject.data.currentDungeon) as Class;
			return classReference;
		}
		
		
		//	------------------------------------------------------------------------------------
		
		// check if serializedSpawnPoints register exists
		public function serializedSpawnPointsCheck() : void {
			if (_sharedObject.data.serializedSpawnPoints == null) {
				_sharedObject.data.serializedSpawnPoints = [];
				_sharedObject.flush();
				//trace("\n SAVING DATA - currentDungeon - " + _sharedObject.data.serializedSpawnPoints);
			}
		}
		
		// get serializedSpawnPoints
		public function get serializedSpawnPoints() : Array {
			serializedSpawnPointsCheck();
			return _sharedObject.data.serializedSpawnPoints;
		}
		
		
		//	------------------------------------------------------------------------------------
		
		// reset stored spawn points
		public function resetSpawnPoints() : void {
			_sharedObject.data.serializedSpawnPoints = [];
			_sharedObject.flush();
		}
		
		// save data
		public function saveData($gold: int, $totalNotoriety:int, $remainingNotoriety:int, $notorietyLevel:int, $currentDungeon:Dungeon, $serializedSpawnPoints:Array) : void {
			
			//trace("\n - SAVING DATA - ");
			//trace("current gold: " + $gold);
			//trace("current totalNotoriety: " + $totalNotoriety);
			//trace("current remainingNotoriety: " + $remainingNotoriety);
			//trace("current notorietyLevel: " + $notorietyLevel);
			//trace("current dungeon (classString): " + $currentDungeon.classString);
			//trace("current spawn points (serialized): " + $serializedSpawnPoints);
			
			goldCheck();
			_sharedObject.data.gold = $gold;
			_sharedObject.flush();
			
			totalNotorietyCheck();
			_sharedObject.data.totalNotoriety = $totalNotoriety;
			_sharedObject.flush();
			
			remainingNotorietyCheck();
			_sharedObject.data.remainingNotoriety = $remainingNotoriety;
			_sharedObject.flush();
			
			trace("\nLOOKING AT REMAINING NOTORIETY");
			trace("(from params): " + $remainingNotoriety);
			trace("(stored): " + _sharedObject.data.remainingNotoriety);
			
			notorietyLevelCheck();
			_sharedObject.data.notorietyLevel = $notorietyLevel;
			_sharedObject.flush();
			
			currentDungeonCheck();
			_sharedObject.data.currentDungeon = $currentDungeon.classString;
			_sharedObject.flush();
			
			serializedSpawnPointsCheck();
			_sharedObject.data.serializedSpawnPoints = $serializedSpawnPoints;
			_sharedObject.flush();
			
			
			//trace(" - SAVED DATA: gold - " + _sharedObject.data.gold);
			//trace(" - SAVED DATA: totalNotoriety - " + _sharedObject.data.totalNotoriety);
			//trace(" - SAVED DATA: remainingNotoriety - " + _sharedObject.data.remainingNotoriety);
			//trace(" - SAVED DATA: notorietyLevel - " + _sharedObject.data.notorietyLevel);
			//trace(" - SAVED DATA: currentDungeon - " + _sharedObject.data.currentDungeon);
			//trace(" - SAVED DATA: serializedSpawnPoints - " + _sharedObject.data.serializedSpawnPoints);
		}

		// *** reset function ***

		public function resetSharedObject(): void {
			_sharedObject.clear();
			_sharedObject = SharedObject.getLocal(localString);
		}


		public function GlobalSharedObject(): void {
			if (!_allowInstantiation) {
				throw new Error("ERROR: STOP IT FOOL, DON'T INITIALIZE!!");
			}
		}

	}

}
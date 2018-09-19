package {
	import flash.net.SharedObject;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	import flash.net.getClassByAlias;

	public class GlobalUnlockTracker {

		private static var _instance: GlobalUnlockTracker;
		private static var _allowInstantiation: Boolean;

		private static var _sharedObject: SharedObject;
		public static var localString: String = "MasterOfUnlocks14"

		public var unlockCriteria: Array;

		// UNLOCK ALL
		private static const UNLOCK_ALL: Boolean = false;

		// unlock variables
		public var enemiesDefeated: int;
		public var goldEarned: int;
		public var goldSpent: int;
		public var totalHealing: int;

		// serialized data
		public var serializedArray: Array;
		
		// new unlock bubble handler
		public var newUnlockBubbleHandler:NewUnlockBubbleHandler;
		
		public function get newUnlockBubbles():Array {
			
			trace("\nSTARTING GET newUnlockBubbles");
			storedVariableCheck();
			
			var storedArray:Array = _sharedObject.data.newUnlockBubbles;
			var convertedArray:Array = [];
			
			trace("Stored Array: " + storedArray);
			
			for each (var monsterString : String in storedArray) {
				var tempClass : Class = getDefinitionByName(monsterString) as Class;
				convertedArray.push(tempClass);
			}
			
			trace("\nFETCHING BUBBLES: " + convertedArray);
			
			return convertedArray;
		}
		
		public function saveBubbles(bubblesToShow:Array):void {
			
			var convertedArray:Array = [];
			
			for each (var monsterClass : Class in bubblesToShow) {
				var tempString : String = getQualifiedClassName(monsterClass);
				convertedArray.push(tempString);
			}
			
			trace("\nSAVING BUBBLES: " + convertedArray);
			
			_sharedObject.data.newUnlockBubbles = convertedArray;
			_sharedObject.flush();
		}


		// return unlock criteria from class name
		public function getCriteriaFromClassName(monsterClass: Class): UnlockCriteria {
			//trace("\n	*	*	*	*	Accessing unlockCriteria array, looking for " + monsterClass);
			for each(var criteria: UnlockCriteria in unlockCriteria) {
				if (criteria.monsterToUnlock == monsterClass) {
					//trace("	*	*	*	*	class found, returning criteria");
					return criteria;
				}
			}
			//trace("	*	*	*	*	class not found, returning null");
			return null;
		}


		// register death
		public function registerDeath(adv: Adventurer): void {
			enemiesDefeated++;
			//trace("\n	*	*	*	*	GlobalUnlockTracker registerDeath(" + adv.ui_name + ") - total enemies defeated: " + enemiesDefeated);

			for each(var criteria: UnlockCriteria in unlockCriteria) {

				if (criteria.progressMethod != "kill") continue;
				//trace("	*	*	*	*	GlobalUnlockTracker checking progress of " + criteria.monsterToUnlock + " unlock");


				criteria.checkProgress(adv);
			}

			registerDefeatStarLevel(adv);
			
			_sharedObject.data.enemiesDefeated = enemiesDefeated;
			_sharedObject.flush();
		}


		// register kill with specific unit
		public function registerKillWith(monster: Monster): void {
			//trace("\n	*	*	*	*	GlobalUnlockTracker registerKillWith(" + monster.ui_name + ")");
			for each(var criteria: UnlockCriteria in unlockCriteria) {

				if (criteria.progressMethod != "killsWith") continue;
				//trace("	*	*	*	*	GlobalUnlockTracker checking progress of " + criteria.monsterToUnlock + " unlock");

				criteria.checkProgress(monster);
			}
		}

		// register increase in notoriety
		public function registerNotorietyIncrease(): void {
			var currentNotoriety: int = GlobalVariables.gameplayScreen.notorietyLevel;
			//trace("\n	*	*	*	*	GlobalUnlockTracker registerNotorietyIncrease() - current level: " + currentNotoriety);

			for each(var criteria: UnlockCriteria in unlockCriteria) {

				if (criteria.progressMethod != "notoriety") continue;
				//trace("	*	*	*	*	GlobalUnlockTracker checking progress of " + criteria.monsterToUnlock + " unlock");

				criteria.checkProgress();
			}
		}

		// register increase in gold
		public function registerGoldEarnedIncrease(increaseAmount: int): void {
			goldEarned += increaseAmount;
			//trace("\n	*	*	*	*	GlobalUnlockTracker registerGoldEarnedIncrease( " + increaseAmount + " ) - current gold earned: " + goldEarned);

			for each(var criteria: UnlockCriteria in unlockCriteria) {
				if (criteria.progressMethod != "goldEarned") continue;
				//trace("	*	*	*	*	GlobalUnlockTracker checking progress of " + criteria.monsterToUnlock + " unlock");
				criteria.checkProgress();
			}
			
			_sharedObject.data.goldEarned = goldEarned;
			_sharedObject.flush();
		}

		// register gold spent
		public function registerGoldSpent(amountSpent: int): void {
			goldSpent += amountSpent;
			//trace("\n	*	*	*	*	GlobalUnlockTracker registerGoldSpent( " + amountSpent + " ) - current gold spent: " + goldSpent);

			for each(var criteria: UnlockCriteria in unlockCriteria) {
				if (criteria.progressMethod != "goldSpent") continue;
				//trace("	*	*	*	*	GlobalUnlockTracker checking progress of " + criteria.monsterToUnlock + " unlock");
				criteria.checkProgress();
			}
		}


		// register purchase of dungeon
		public function registerDungeonPurchase(dungeonClass: Dungeon): void {
			//trace("\n	*	*	*	*	GlobalUnlockTracker registerDungeonPurchase( " + dungeonClass + " )");

			for each(var criteria: UnlockCriteria in unlockCriteria) {
				if (criteria.progressMethod != "dungeonPurchased") continue;
				//trace("	*	*	*	*	GlobalUnlockTracker checking progress of " + criteria.monsterToUnlock + " unlock");
				criteria.checkProgress(dungeonClass);
			}
		}


		// register purchase of dungeon
		public function registerStatus(statusString: String): void {
			//trace("\n	*	*	*	*	GlobalUnlockTracker registerStatus( " + statusString + " )");

			for each(var criteria: UnlockCriteria in unlockCriteria) {
				if (criteria.progressMethod == "inflictPoison") {
					//trace("	*	*	*	*	GlobalUnlockTracker checking progress of " + criteria.monsterToUnlock + " unlock");
					criteria.checkProgress(statusString);

				} else if (criteria.progressMethod == "inflictParalysis") {
					//trace("	*	*	*	*	GlobalUnlockTracker checking progress of " + criteria.monsterToUnlock + " unlock");
					criteria.checkProgress(statusString);

				} else if (criteria.progressMethod == "inflictFear") {
					//trace("	*	*	*	*	GlobalUnlockTracker checking progress of " + criteria.monsterToUnlock + " unlock");
					criteria.checkProgress(statusString);

				} else if (criteria.progressMethod == "inflictFreeze") {
					//trace("	*	*	*	*	GlobalUnlockTracker checking progress of " + criteria.monsterToUnlock + " unlock");
					criteria.checkProgress(statusString);

				} else if (criteria.progressMethod == "inflictBurn") {
					//trace("	*	*	*	*	GlobalUnlockTracker checking progress of " + criteria.monsterToUnlock + " unlock");
					criteria.checkProgress(statusString);

				} else if (criteria.progressMethod == "inflictConfuse") {
					//trace("	*	*	*	*	GlobalUnlockTracker checking progress of " + criteria.monsterToUnlock + " unlock");
					criteria.checkProgress(statusString);

				} else if (criteria.progressMethod == "inflictTransmute") {
					//trace("	*	*	*	*	GlobalUnlockTracker checking progress of " + criteria.monsterToUnlock + " unlock");
					criteria.checkProgress(statusString);
				}
			}
		}


		// register defeat star level
		public function registerDefeatStarLevel(adv: Adventurer): void {
			enemiesDefeated++;
			//trace("\n	*	*	*	*	GlobalUnlockTracker registerDefeatStarLevel(" + adv.starLevel + ")");

			for each(var criteria: UnlockCriteria in unlockCriteria) {

				if (criteria.progressMethod != "defeatStarLevel") continue;
				//trace("	*	*	*	*	GlobalUnlockTracker checking progress of " + criteria.monsterToUnlock + " unlock");

				criteria.checkProgress(adv);
			}
		}


		// register increase in heal
		public function registerTotalHealingIncrease(increaseAmount: int): void {
			totalHealing += increaseAmount;
			//trace("\n	*	*	*	*	GlobalUnlockTracker registerTotalHealingIncrease( " + increaseAmount + " ) - current total healing: " + totalHealing);

			for each(var criteria: UnlockCriteria in unlockCriteria) {
				if (criteria.progressMethod != "healAmount") continue;
				//trace("	*	*	*	*	GlobalUnlockTracker checking progress of " + criteria.monsterToUnlock + " unlock");
				criteria.checkProgress();
			}
			
			_sharedObject.data.totalHealing = totalHealing;
			_sharedObject.flush();
		}


		// -	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-

		// return whether monster is unlocked
		public function isUnlocked(monsterClass: Class): Boolean {
			var currentCriteria: UnlockCriteria = getCriteriaFromClassName(monsterClass);

			if (!currentCriteria) {
				//trace("\n	*	*	*	*	GlobalUnlockTracker - criteria for " + monsterClass + " not found. Returning true (unlocked).");
				return true;
			}

			//trace("\n	*	*	*	*	GlobalUnlockTracker checking if " + monsterClass + " is unlocked: " + currentCriteria.isUnlocked);
			//trace("	*	*	*	*	" + currentCriteria.unlockText);

			return currentCriteria.isUnlocked;
		}


		// remove criteria once unlocked, called from UnlockCriteria
		public function removeCriteria(thisCriteria: UnlockCriteria): void {
			if (thisCriteria.isUnlocked) {
				trace("\n	*	*	*	*	GlobalUnlockTracker, removeCriteria() - criteria met, removing, returning true");
				unlockCriteria.splice(unlockCriteria.indexOf(thisCriteria), 1);
				
				var tempClass :Class = Class(thisCriteria.monsterToUnlock);
				var tempGrid : MasterGrid = GlobalVariables.instance.masterGrid;
				var tempMonster : Monster = new tempClass(tempGrid);
				
				var storedArray:Array = _sharedObject.data.alertTracker;
				var classString:String = getQualifiedClassName(tempClass);
				var monsterIndex:int = GlobalVariables.purchasableMonsters.indexOf(tempClass);
				var alertStatus:Boolean = storedArray[monsterIndex];
				
				if (alertStatus == false){
					
					GlobalVariables.instance.dungeonAlertPanel.newAlert_MonsterUnlocked(tempMonster.nameString);
					
					// remove from alertTracker
					_sharedObject.data.alertTracker[monsterIndex] = true;
					_sharedObject.flush();
				
					
					trace("\n *** GlobalUnlockTracker: registerUnlock - " + thisCriteria.monsterToUnlock);
					newUnlockBubbleHandler.registerUnlock(thisCriteria);
				}
				
				tempMonster.destroy();
			}
		}


		// get instance
		public static function get instance(): GlobalUnlockTracker {
			if (!_instance) {
				_allowInstantiation = true;
				_instance = new GlobalUnlockTracker();
				_allowInstantiation = false;
			}
			return _instance;
		}


		// SHARED OBJECT

		// check all stored vars
		public function storedVariableCheck(): void {
			
			//trace("	5	5	5	5	5	5	5	5	5	5	5	5	5	5	5	5	5	5	5	");
			//trace("storedVariableCheck");
			
			//trace("_sharedObject.data.serializedData: " + _sharedObject.data.serializedData);
			//trace("_sharedObject.data.initialStorageComplete: " + _sharedObject.data.initialStorageComplete);
			//trace("_sharedObject.data.enemiesDefeated: " + _sharedObject.data.enemiesDefeated);
			//trace("_sharedObject.data.goldEarned: " + _sharedObject.data.goldEarned);
			//trace("_sharedObject.data.totalHealing: " + _sharedObject.data.totalHealing);
			
			//serializedData
			if (_sharedObject.data.serializedData == null) {
				_sharedObject.data.serializedData = [];
				_sharedObject.flush();
			}
			
			
			//initialStorageComplete
			if (_sharedObject.data.initialStorageComplete == null) {
				_sharedObject.data.initialStorageComplete = false;
				_sharedObject.flush();
			}
			
			
			//enemiesDefeated
			if (_sharedObject.data.enemiesDefeated == null) {
				_sharedObject.data.enemiesDefeated = 0;
				_sharedObject.flush();
			}
			
			
			//goldEarned
			if (_sharedObject.data.goldEarned == null) {
				_sharedObject.data.goldEarned = 0;
				_sharedObject.flush();
			}
			
			
			//totalHealing
			if (_sharedObject.data.totalHealing == null) {
				_sharedObject.data.totalHealing = 0;
				_sharedObject.flush();
			}
			
			
			// new unlock bubbles
			if (_sharedObject.data.newUnlockBubbles == null) {
				_sharedObject.data.newUnlockBubbles = [];
				_sharedObject.flush();
			}
			
			
			//alertTracker
			if (_sharedObject.data.alertTracker == null) {
				//_sharedObject.data.alertTracker = new Array("M_PlagueRat", "M_SandWorm", "M_Skeleton", "M_GiantSpider", "M_PepperJelly", "M_MudBeast", "M_Zombie", "M_NewtWitch", "M_Sprite", "M_EmporerTurtle", "M_RingNeck", "M_Leprechaun", "M_Gargoyle", "M_Lion", "M_FloatingEye", "M_ShockPuff", "M_Buzz", "M_Cyclops", "M_GreatMoth", "M_Genie", "M_DodoKnight", "M_Hermit", "M_PirateOrc", "M_RedDragon","M_Gryffon", "M_StoneGolem", "M_SproutBeast", "M_ToadSage", "M_ThunderGiant", "M_Reaper", "M_IceKing", "M_Cthulian", "M_DarkPriest", "M_Beholder");
				_sharedObject.data.alertTracker = new Array(false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false);
				_sharedObject.flush();
			}
			
			//trace("_sharedObject.data.serializedData: " + _sharedObject.data.serializedData);
			//trace("_sharedObject.data.initialStorageComplete: " + _sharedObject.data.initialStorageComplete);
			//trace("_sharedObject.data.enemiesDefeated: " + _sharedObject.data.enemiesDefeated);
			//trace("_sharedObject.data.goldEarned: " + _sharedObject.data.goldEarned);
			//trace("_sharedObject.data.totalHealing: " + _sharedObject.data.totalHealing);
		}

		public function serializeData(): void {

			//trace("\n\n\n	7	7	7	7	7	7	7	7	Beginning Serialize Data (Unlocks)");

			serializedArray = [];

			for each(var u: UnlockCriteria in unlockCriteria) {
				var monsterClassString : String = getQualifiedClassName(u.monsterToUnlock);
				serializedArray.push(monsterClassString, u.progressTracker);
			}

			//trace("serializedData: " + serializedArray);

			// store values
			_sharedObject.data.serializedData = serializedArray;
			_sharedObject.flush();

			//trace("STORED: " + _sharedObject.data.serializedData);
		}

		public function fetchData(monsterClass: Class): int {
			//trace("\n\n\n	6	6	6	6	6	6	6	6	Beginning Fetch Data (Unlocks) - " + monsterClass);
			var currentData: Array = _sharedObject.data.serializedData;
			var monsterClassString : String = getQualifiedClassName(monsterClass);
			var monsterIndex: int = currentData.indexOf(monsterClassString);
			

			if (monsterIndex >= 0) {
				var currentProgress = currentData[monsterIndex + 1];
				//trace("Data Fetched for " + monsterClass);
				//trace("Progress: " + currentProgress);
				return currentProgress;
			} else {
				return -1;
			}
		}

		public function resetSharedObject(): void {
			_sharedObject.clear();
			_sharedObject = SharedObject.getLocal(localString);
		}

		public function checkAllStoredProgress(): void {
			for each(var u: UnlockCriteria in unlockCriteria) {
				u.checkStoredProgress();
			}
		}

		// empty constructor
		public function GlobalUnlockTracker() {
			if (!_allowInstantiation) {
				throw new Error("ERROR: STOP IT FOOL, DON'T INITIALIZE!!");
			}
			
			//resetSharedObject();

			// instantiate shared object
			_sharedObject = SharedObject.getLocal(localString);

			// instantiate serializedArray
			serializedArray = [];

			// check stored vars
			storedVariableCheck();

			// instantiate variables
			enemiesDefeated = _sharedObject.data.enemiesDefeated;
			goldEarned = _sharedObject.data.goldEarned;
			goldSpent = 0;	// not used
			totalHealing = _sharedObject.data.totalHealing;
			unlockCriteria = [];

			// check for unlock all
			if (UNLOCK_ALL) return;

			// KILL (GENERIC)
			unlockCriteria.push(new UnlockCriteria(M_PlagueRat, "kill", Adventurer, 10));
			unlockCriteria.push(new UnlockCriteria(M_ShockPuff, "kill", Adventurer, 100));
			unlockCriteria.push(new UnlockCriteria(M_Reaper, "kill", Adventurer, 333));

			// KILL (SPECIFIC)
			unlockCriteria.push(new UnlockCriteria(M_PepperJelly, "kill", A_Chef, 10));
			unlockCriteria.push(new UnlockCriteria(M_Gargoyle, "kill", A_DwarvenMonk, 5));
			unlockCriteria.push(new UnlockCriteria(M_GreatMoth, "kill", A_ElfQueen, 3));
			unlockCriteria.push(new UnlockCriteria(M_StoneGolem, "kill", A_Destroyer, 5));
			unlockCriteria.push(new UnlockCriteria(M_DarkPriest, "kill", A_Angel, 10));

			// GOLD EARNED
			unlockCriteria.push(new UnlockCriteria(M_SandWorm, "goldEarned", null, 2500));
			unlockCriteria.push(new UnlockCriteria(M_EmporerTurtle, "goldEarned", null, 10000));
			unlockCriteria.push(new UnlockCriteria(M_PirateOrc, "goldEarned", null, 25000));
			unlockCriteria.push(new UnlockCriteria(M_Cthulian, "goldEarned", null, 100000));

			// GET KILLS WITH
			unlockCriteria.push(new UnlockCriteria(M_Zombie, "killsWith", M_Skeleton, 25));
			unlockCriteria.push(new UnlockCriteria(M_RingNeck, "killsWith", M_Bat, 30));
			unlockCriteria.push(new UnlockCriteria(M_Lion, "killsWith", M_ScaredyCat, 10));
			unlockCriteria.push(new UnlockCriteria(M_Cyclops, "killsWith", M_FloatingEye, 40));
			unlockCriteria.push(new UnlockCriteria(M_Gryffon, "killsWith", M_GreatMoth, 50));

			// GOLD SPENT
			//unlockCriteria.push(new UnlockCriteria(M_SandWorm, "goldSpent", null, 1000));

			// NOTORIETY REACHED
			unlockCriteria.push(new UnlockCriteria(M_Skeleton, "notoriety", null, 3));
			unlockCriteria.push(new UnlockCriteria(M_FloatingEye, "notoriety", null, 8));

			// UNLOCK SPECIFIC DUNGEON
			unlockCriteria.push(new UnlockCriteria(M_Leprechaun, "dungeonPurchased", DG_Skoodhorn, 1));
			unlockCriteria.push(new UnlockCriteria(M_DodoKnight, "dungeonPurchased", DG_Moonglow, 1));
			unlockCriteria.push(new UnlockCriteria(M_IceKing, "dungeonPurchased", DG_HallOfDespair, 1));

			// DEFEAT ADV OF CERTAIN STAR LEVEL
			unlockCriteria.push(new UnlockCriteria(M_GiantSpider, "defeatStarLevel", null, 3));
			unlockCriteria.push(new UnlockCriteria(M_Genie, "defeatStarLevel", null, 12));
			unlockCriteria.push(new UnlockCriteria(M_Beholder, "defeatStarLevel", null, 15));

			// INFLICT POISON
			unlockCriteria.push(new UnlockCriteria(M_NewtWitch, "inflictPoison", null, 25));
			unlockCriteria.push(new UnlockCriteria(M_Buzz, "inflictPoison", null, 100));
			unlockCriteria.push(new UnlockCriteria(M_SproutBeast, "inflictPoison", null, 250));

			// INFLICT PARALYSIS
			unlockCriteria.push(new UnlockCriteria(M_ThunderGiant, "inflictParalysis", null, 100));

			// INFLICT BURN
			unlockCriteria.push(new UnlockCriteria(M_RedDragon, "inflictBurn", null, 100));

			// INFLICT CONFUSE
			unlockCriteria.push(new UnlockCriteria(M_MudBeast, "inflictConfuse", null, 30));

			// HEAL (AMOUNT) OF DAMAGE
			unlockCriteria.push(new UnlockCriteria(M_Sprite, "healAmount", null, 250));
			unlockCriteria.push(new UnlockCriteria(M_Hermit, "healAmount", null, 2000));
			unlockCriteria.push(new UnlockCriteria(M_ToadSage, "healAmount", null, 10000));


			//trace("\n\n\n\n	9	9	9	9	9	9	9	9	9	9	START ANNOYING UNLOCK PROBLEM");
			//trace("initialStorageComplete: " + _sharedObject.data.initialStorageComplete);
			//trace("stored serialized data: " + _sharedObject.data.serializedData);
			
			if (_sharedObject.data.initialStorageComplete == false) {
				serializeData();
				_sharedObject.data.initialStorageComplete = true;
				_sharedObject.flush();
			}
			
			// instantiate reference to newUnlockBubbleHander
			newUnlockBubbleHandler = new NewUnlockBubbleHandler();
			newUnlockBubbleHandler.bubblesToShow = newUnlockBubbles;
			
			//trace("AFTER INITIAL STORAGE CHECK");
			//trace("initialStorageComplete: " + _sharedObject.data.initialStorageComplete);
			//trace("stored serialized data: " + _sharedObject.data.serializedData);

			for each(var u: UnlockCriteria in unlockCriteria) {
				
				var storedProgress: int = fetchData(u.monsterToUnlock);

				if (storedProgress >= 0) {
					u.progressTracker = storedProgress;
				} else {
					u.progressTracker = u.progressCompletion;
				}
			}
		}
	}
}
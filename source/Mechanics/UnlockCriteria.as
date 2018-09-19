package {

	/* IDEAS
	- kills with traps
	- (apply status) to # of adventurers/ # of times
	- kill (# of stars) level adventurer(s) 				+++
	- unlock (# of monsters)
	- kill (# of adventurers) with a single monster
	- kill (# of adventurers) with spells / (specific spell)
	- purchase (# of different monsters)
	
	- inflict (amount) of (status) damage
	- heal (amount) of damage
	- have certain (amount of gold) saved
	- play for (amount of time)
	- spawn (# of specific monster)
	*/

	public class UnlockCriteria {

		public var monsterToUnlock: Class;
		public var progressMethod: String;
		public var progressTarget: Class;
		public var progressCompletion: int;

		public var progressTracker: int;

		public function UnlockCriteria($monsterToUnlock: Class, $progressMethod: String, $progressTarget: * , $progressCompletion: int) {
			// constructor code
			monsterToUnlock = $monsterToUnlock;
			progressMethod = $progressMethod;
			progressTarget = $progressTarget;
			progressCompletion = $progressCompletion;

			progressTracker = 0;
			
			// !!!
			// set progressTracker = fetchData(monsterToUnlock);
			// !!!
			//		*** IF REGISTRY DOESNT EXIST, UNLOCK MONSTER (or remove)
			

			if (progressMethod == "notoriety") {
				progressTracker = GlobalVariables.gameplayScreen.notorietyLevel;
			}
		}
		
		public function checkStoredProgress():void {
			var storedProgress : int = GlobalUnlockTracker.instance.fetchData(monsterToUnlock);
			
			if (storedProgress >= 0) {
				progressTracker = storedProgress;
			} else {
				progressTracker = progressCompletion;
			}
		}


		// Check progress of unlocks

		public function checkProgress(target: * = null): void {

			//trace("\n	*	*	*	*	UnlockCriteria checkProgress() - " + monsterToUnlock);

			if (progressMethod == "kill") {
				if (target && target is progressTarget) progressTracker++;

			} else if (progressMethod == "notoriety") {
				progressTracker = GlobalVariables.gameplayScreen.notorietyLevel;

			} else if (progressMethod == "goldEarned") {
				progressTracker = GlobalUnlockTracker.instance.goldEarned;

			} else if (progressMethod == "goldSpent") {
				progressTracker = GlobalUnlockTracker.instance.goldSpent;

			} else if (progressMethod == "killsWith") {
				if (target && target is progressTarget) progressTracker++;

			} else if (progressMethod == "dungeonPurchased") {
				if (target && target is progressTarget) progressTracker++;

			} else if (progressMethod == "defeatStarLevel") {
				if (target && target.starLevel > progressTracker) progressTracker = target.starLevel;

			} else if (progressMethod == "inflictPoison") {
				if (target && target == GlobalVariables.TYPE_STATUS_POISON) progressTracker++;

			} else if (progressMethod == "inflictParalysis") {
				if (target && target == GlobalVariables.TYPE_STATUS_PARALYZE) progressTracker++;

			} else if (progressMethod == "inflictFear") {
				if (target && target == GlobalVariables.TYPE_STATUS_FEAR) progressTracker++;

			} else if (progressMethod == "inflictFreeze") {
				if (target && target == GlobalVariables.TYPE_STATUS_FREEZE) progressTracker++;

			} else if (progressMethod == "inflictBurn") {
				if (target && target == GlobalVariables.TYPE_STATUS_BURN) progressTracker++;

			} else if (progressMethod == "inflictConfuse") {
				if (target && target == GlobalVariables.TYPE_STATUS_CONFUSE) progressTracker++;

			} else if (progressMethod == "inflictTransmute") {
				if (target && target == GlobalVariables.TYPE_STATUS_TRANSMUTE) progressTracker++;

			} else if (progressMethod == "healAmount") {
				
				progressTracker = GlobalUnlockTracker.instance.totalHealing;

			}

			//trace("	*	*	*	*	Progress Tracker: " + progressTracker);
			//trace("	*	*	*	*	Progress Completion: " + progressCompletion);
			
			if (isUnlocked) GlobalUnlockTracker.instance.removeCriteria(this);
			
			GlobalUnlockTracker.instance.serializeData();
		}

		public function get isUnlocked(): Boolean {
			if (progressTracker >= progressCompletion) {
				//trace("\n *** UnlockCriteria: checking isUnlocked(), returning TRUE - " + monsterToUnlock);
				return true;
			}
			else return false;
		}

		public function get unlockText(): String {
			var returnString: String = "";

			// defeat enemies
			if (progressMethod == "kill") {

				returnString += "Defeat " + progressCompletion;

				var tempAdv = new progressTarget(GlobalVariables.instance.masterGrid);

				if (progressTarget == Adventurer) {
					returnString += " Enemies.";
				} else {
					returnString += String(" " + tempAdv.ui_name);

					if (progressCompletion == 1) returnString += ".";
					else returnString += "s.";
				}
			}

			// reach a certain notoriety level			
			else if (progressMethod == "notoriety") {
				returnString += "Reach Notoriety Level " + progressCompletion;
			}


			// earn a certain amount of gold
			else if (progressMethod == "goldEarned") {
				returnString += "Earn " + progressCompletion + " gold.";
			}

			// spend a certain amount of gold
			else if (progressMethod == "goldSpent") {
				returnString += "Spend " + progressCompletion + " gold.";
			}


			/*
				- becomes complicated with whether statuses cause kills
			*/

			// get kills with a certain unit
			else if (progressMethod == "killsWith") {
				returnString += "Defeat " + progressCompletion + " adventurers with a " + progressTarget + ".";
			}

			// purchase a specific dungeon
			else if (progressMethod == "dungeonPurchased") {
				returnString += "Purchase " + progressTarget + ".";
			}

			// defeat adventurer with a certain star level
			else if (progressMethod == "defeatStarLevel") {
				returnString += "Defeat an adventurer with a star level of at least " + progressCompletion + ".";
			}

			// inflict poison on certain # of adventurers
			else if (progressMethod == "inflictPoison") {
				returnString += "Inflict poison on " + progressCompletion + " adventurer";
				if (progressCompletion  == 1) returnString += ".";
				else returnString += "s.";
			}
			
			// inflict paralysis on certain # of adventurers
			else if (progressMethod == "inflictParalysis") {
				returnString += "Inflict paralysis on " + progressCompletion + " adventurer";
				if (progressCompletion  == 1) returnString += ".";
				else returnString += "s.";
			}
			
			// inflict fear on certain # of adventurers
			else if (progressMethod == "inflictFear") {
				returnString += "Inflict fear on " + progressCompletion + " adventurer";
				if (progressCompletion  == 1) returnString += ".";
				else returnString += "s.";
			}
			
			// inflict freeze on certain # of adventurers
			else if (progressMethod == "inflictFreeze") {
				returnString += "Inflict freeze on " + progressCompletion + " adventurer";
				if (progressCompletion == 1) returnString += ".";
				else returnString += "s.";
			}
			
			// inflict burn on certain # of adventurers
			else if (progressMethod == "inflictBurn") {
				returnString += "Inflict burns on " + progressCompletion + " adventurer";
				if (progressCompletion == 1) returnString += ".";
				else returnString += "s.";
			}
			
			// confuse certain # of adventurers
			else if (progressMethod == "inflictConfuse") {
				returnString += "Confuse " + progressCompletion + " adventurer";
				if (progressCompletion == 1) returnString += ".";
				else returnString += "s.";
			}
			
			// transmute certain # of adventurers
			else if (progressMethod == "inflictTransmute") {
				returnString += "Transmute " + progressCompletion + " adventurer";
				if (progressCompletion == 1) returnString += ".";
				else returnString += "s.";
			}
			
			// heal certain amount of damage
			else if (progressMethod == "healAmount") {
				returnString += "Heal " + progressCompletion + " points of damage.";
			}

			return returnString;
		}

	}

}
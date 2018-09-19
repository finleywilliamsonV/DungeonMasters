package {

	public class AdvLevelData {

		public var data: Array;
		public var availableLevels: Array;

		public static const USE_OFFSET: Boolean = true;
		public static const OFFSET_SIZE: int = 4;

		private var advTeams: AdvTeams;
		private var advTeam: Array;

		private var _selectedClasses: Array = [];
		private var _selectedClassCount: Array = [];

		public function AdvLevelData() {
			// constructor code
			data = new Array(15); // max adv level 15
			availableLevels = [];

			advTeams = new AdvTeams();
			advTeam = [];

			populate();
		}

		public function populate(): void {

			var classes: Array = GlobalVariables.advClasses;
			var classLevel: int;

			for (var i: int = 0; i < classes.length; i++) {

				classLevel = classes[i].level;

				if (data[classLevel - 1] == null) {
					//trace("Adding new array to level " + (classLevel - 1));
					data[classLevel - 1] = new Array(classes[i]);
					availableLevels.push(classLevel - 1);
				} else {
					data[classLevel - 1].push(classes[i]);
				}

				trace("Current data: " + data);
			}

			availableLevels.sort(Array.NUMERIC);

			trace("--------------------------------------");
			for (var j: int = data.length - 1; j >= 0; j--) {
				if (data[j] == null) continue;
				trace("Level " + (j + 1) + ": " + data[j]);
			}
			trace();
			trace(availableLevels);
		}

		// used with advAddButton
		public function calculateSingleAdventurer(dungeonNotorietyLevel: int): Adventurer {

			//trace("\n\n	8	8	8	8	8	8	8	8	8	8	8	8	8	8	8	8	8");
			//trace("\nStarting Calculate Single Adventurer");



			var randomLevel: int = int(Math.random() * dungeonNotorietyLevel);

			if (randomLevel > 14) randomLevel = 14;

			//trace("Random Level: " + randomLevel);

			//trace("Random Level Classes: " + data[randomLevel]);

			var randomClassIndex: int = int(Math.random() * data[randomLevel].length);

			//trace("Random Class Index: " + randomClassIndex);

			var randomClass: Class = data[randomLevel][randomClassIndex];

			//trace("Random Class: " + randomClass);

			processClass(randomClass);

			return new randomClass(GlobalVariables.instance.masterGrid);
		}


		public function calculateAdvTeam(dungeonNotoriety: int, maxAdvLevel: int = -1): Array {

			////trace("\nSTART CALCULATE ADV TEAM");

			//	while (remainingNotoriety > 0)
			//
			//		for (start at highest, work down)
			//
			//			if 25 x level > remaining notoriety
			//				set maxIndex = level - 1
			//
			//				if maxIndex == -1 {
			//					return;
			//				}
			//
			//			else break; --> all levels below are valid
			//
			// 		- - - - - FINISHED FOR LOOP - - - - -
			//
			//		randomly select one of the available levels, add to advTeam[]
			//
			//		repeat


			var remainingNotoriety: int = dungeonNotoriety;

			var maxIndex: int;
			if (maxAdvLevel >= 0) {
				maxIndex = maxAdvLevel;
			} else {
				maxIndex = availableLevels.length - 1;
			}

			var currentAvailableLevel: int;

			var selectedLevel: int;
			var selectedClass: Class;

			var r1: int;
			var r2: int;

			advTeam = [];

			//		availableLevels[] = {0,1,2}
			//		maxIndex = 2

			while (remainingNotoriety > 0) {

				trace("---------------------------");
				////trace("remainingNotoriety: " + remainingNotoriety);
				////trace("availableLevels: " + availableLevels);
				////trace("maxIndex: " + maxIndex);
				////trace("---------------------------");

				var advTeamToAdd: Array = advTeams.search(remainingNotoriety);
				trace("advTeamToAdd: " + advTeamToAdd);

				if (Math.random() < .25) {
					while (advTeamToAdd.length > 0) {

						var currentCost: int = advTeamToAdd[0];
						var trimmedTeam: Array = advTeamToAdd.slice(1); // advTeams.search returns cost as element 0

						for each(var advClass: Class in trimmedTeam) {
							advTeam.push(advClass);
							processClass(advClass);
							trace("Adding: " + advClass);
							/*var cost: int = advClass.level * 25;
							remainingNotoriety -= cost;*/
						}

						remainingNotoriety -= currentCost;

						advTeamToAdd = advTeams.search(remainingNotoriety);
					}
				}

				for (var i: int = maxIndex; i >= 0; i--) {

					currentAvailableLevel = availableLevels[i];
					////trace("currentAvailableLevel: " + (currentAvailableLevel + 1));

					if (25 * (currentAvailableLevel + 1) > remainingNotoriety) {

						////trace((25 * (currentAvailableLevel + 1)) + " is greater than " + remainingNotoriety);
						maxIndex = i - 1;
						////trace("maxIndex: " + maxIndex);

					} else {
						////trace("BREAK: all levels below are valid");
						break; // all levels below are valid
					}
				}

				if (maxIndex < 0) {
					////trace("MAX INDEX < 0, returning advTeam[]: " + advTeam);
					////trace("Team Size: " + advTeam.length);
					advTeam = advTeam.sortOn('level', Array.DESCENDING);
					////trace("sorted team: " + advTeam);
					for each(var c: Class in advTeam) {
						//trace(c.level);
					}
					return advTeam;
				}


				// RANDOM ADV SELECTION



				var offset: int = 0;

				if (USE_OFFSET) {
					if (maxIndex + 1 > OFFSET_SIZE) {
						offset = (maxIndex + 1) - OFFSET_SIZE;
					}
				}

				r1 = Math.random() * (maxIndex + 1 - offset); // offset
				r1 += offset;

				////trace("Choose btw levels " + offset + " and " + (maxIndex + 1));

				selectedLevel = availableLevels[r1];
				if (data[selectedLevel].length > 1) {
					r2 = Math.random() * data[selectedLevel].length;
					selectedClass = data[selectedLevel][r2];
				} else {
					selectedClass = data[selectedLevel][0];
				}


				//// START WITH HIGHEST LEVEL ADVs ALWAYS
				//selectedLevel = availableLevels[maxIndex];
				//if (data[selectedLevel].length > 1) {
				//	r2 = Math.random() * data[selectedLevel].length;
				//	selectedClass = data[selectedLevel][r2];
				//} else {
				//	selectedClass = data[selectedLevel][0];
				//}

				////trace("----------------------");
				////trace("selectedLevel: " + (selectedLevel + 1));
				////trace("selectedClass: " + selectedClass);
				////trace("Adding to advTeam[]");

				advTeam.push(selectedClass);

				processClass(selectedClass);

				////trace("advTeam: " + advTeam);

				remainingNotoriety -= (selectedLevel + 1) * 25;

				if (advTeam.length > 12) remainingNotoriety = 0;

			}

			////trace("REACHED END OF WHILE LOOP, returning advTeam: " + advTeam);
			advTeam = advTeam.sortOn('level', Array.DESCENDING);
			////trace("sorted team: " + advTeam);
			for each(var c: Class in advTeam) {
				////trace(c.level);
			}
			////trace("Team Size: " + advTeam.length);
			return advTeam;

		}

		public function processClass(advClass: Class): void {
			
			return;

			//var selectedIndex: int = _selectedClasses.indexOf(advClass);
			//var selectedClassesString: String = "";

			//if (selectedIndex == -1) {
			//	_selectedClasses.push(advClass);
			//	_selectedClassCount[_selectedClasses.length - 1] = 1;
			//} else {
			//	_selectedClassCount[selectedIndex]++;
			//}

			////trace("\n	0	0	0	0	0	0	0	0	0	0	0	0	0	");
			////trace("\n- Class Count -");

			//for (var i: int = 0; i < _selectedClasses.length; i++) {
			//	selectedClassesString += _selectedClasses[i].toString() + ": " + _selectedClassCount[i].toString() + "\n";
			//}

			////trace(selectedClassesString);

			//GlobalVariables.gameplayScreen._UI.selectedClassesText.text = selectedClassesString;
		}
	}

}
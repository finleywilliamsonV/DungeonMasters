package  {
	
	public class AdvTeams {
		
		public var teamData:Array;
		
		private var _returnArray;

		public function AdvTeams() {
			// constructor code
			teamData = new Array();
			
			teamData.push([50,A_Villager, A_Villager_2, A_Villager_3]);
			teamData.push([50, A_Chef, A_Villager_3]);
			teamData.push([75,A_Ruffian, A_Ruffian]);
			teamData.push([100,A_Villager_3, A_Ruffian, A_Chef]);
			teamData.push([200,A_Constable, A_Constable]);
			teamData.push([250,A_Archer, A_Archer, A_Bowman]);
			teamData.push([275,A_Knight_2, A_Scientist, A_Scientist]);
			teamData.push([275,A_Barbarian, A_Bowman]);
			teamData.push([300,A_Archer, A_Wizard, A_Rogue, A_Knight]);
			teamData.push([400,A_Rogue, A_Rogue, A_Rogue, A_Rogue]);
			teamData.push([425,A_DwarvenWizard, A_Wizard, A_FireWizard]);
			teamData.push([500,A_ElfQueen, A_Barbarian, A_Barbarian]);
			teamData.push([500,A_LadyOfFire, A_LadyOfWater]);
			teamData.push([500,A_LadyOfWater, A_LadyOfWind]);
			teamData.push([500,A_LadyOfWind, A_LadyOfEarth]);
			teamData.push([500,A_LadyOfEarth, A_LadyOfFire]);
			teamData.push([750,A_Emporer, A_Empress]);
			teamData.push([750,A_ElfQueen, A_Centaur, A_Centaur]);
			teamData.push([775, A_DwarvenHero, A_DwarvenMonk, A_DwarvenWizard, A_DwarvenMiner]);
			teamData.push([775, A_Destroyer, A_Destroyer, A_Destroyer]);
			teamData.push([1000,A_LadyOfFire, A_LadyOfWater, A_LadyOfWind, A_LadyOfEarth]);
			teamData.push([1000,A_EliteDestroyer, A_AncientSage, A_Angel]);
			
			//trace("\nTEAM DATA: " + teamData.length, teamData);
		}
		

		// search through teamData[] and return a random team below given notoriety
		// input: 
		public function search(teamNotoriety:int) : Array {
			trace("\nSTARTING ADVTEAM SEARCH @ " + teamNotoriety + " NOTORIETY.");
			_returnArray = [];
			
			var currentTeam:Array;
			var currentCost:int;
			var affordableTeams:Array = [];
			
			for (var i:int = 0; i < teamData.length; i++) {
				currentTeam = teamData[i];
				currentCost = currentTeam[0];
				
				if (currentCost <= teamNotoriety && currentCost >= teamNotoriety/2) {
					affordableTeams.push(currentTeam);
					trace("AFFORDABLE TEAMS(" + affordableTeams.length + "): " + affordableTeams);
				}
			}
			
			if (affordableTeams.length > 0) {
				_returnArray = affordableTeams[int(Math.random() * affordableTeams.length)];
			}
			
			trace("\nENDING ADVTEAM SEARCH @ " + teamNotoriety + " NOTORIETY.");
			trace("RETURNING: " + _returnArray);
			return _returnArray;
		}

	}
	
}

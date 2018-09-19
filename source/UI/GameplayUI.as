package  {
	
	import flash.display.MovieClip;
	
	
	public class GameplayUI extends MovieClip {
		
		private var _dungeonAlertPanel:DungeonAlertPanel;
		
		public function GameplayUI() {
			// constructor code
			
			_dungeonAlertPanel = new DungeonAlertPanel();
			addChild(_dungeonAlertPanel);
			_dungeonAlertPanel.x = 5;
			_dungeonAlertPanel.y = 585;
			
			// give reference to GlobalVariables

			GlobalVariables.instance.dungeonAlertPanel = _dungeonAlertPanel;
			
			/*
			_dungeonAlertPanel.newAlert_AdventurerEnterDungeon("Shit Benis");
			_dungeonAlertPanel.update();
			
			_dungeonAlertPanel.newAlert_AdventurerEnterDungeon("Shit Benis 2");
			_dungeonAlertPanel.update();
			
			_dungeonAlertPanel.newAlert_AdventurerEnterDungeon("Shit Benis 3");
			_dungeonAlertPanel.update();
			
			_dungeonAlertPanel.newAlert_AdventurerEnterDungeon("Shit Benis 4");
			_dungeonAlertPanel.update();*/
		}
		
		public function get dungeonAlertPanel() : DungeonAlertPanel {
			return _dungeonAlertPanel;
		}
	}
	
}

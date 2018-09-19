package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.display.DisplayObject;
	
	public class DocClass extends MovieClip {
		
		private var _TS : TitleScreen;
		private var _GS : GameplayScreen;
		private var _MBS : MonsterBuyScreen;
		
		private var _storedPauseState:Boolean;

		public function DocClass() {
			
			_TS = new TitleScreen();
			_GS = new GameplayScreen();
			_MBS = new MonsterBuyScreen(this);
			
			GlobalVariables.gameplayScreen = _GS;
			
			trace("FROM DOC CLASS: " + GlobalSharedObject.instance.remainingNotoriety);
		
			startGame();
		}
		
		public function startGame() : void {

			// Title Screen
			//addChild(_TS);
			//_TS.setup(this);
			TStoGS();
			
			GlobalSounds.instance.playBGM();
			GlobalSounds.instance.setMuted_Music(true);
			
		}
		
		public function TStoGS() : void {
			
			//removeChild(_TS);
			
			// Gameplay Screen
			addChild(_GS);
			_GS.setup(this);
			
			addChild(new Border21());
			
			//removeChild(_GS);
			
			//addChild(_MBS);
		}
		
		
		public function addMonsterBuyScreen($selected:* = null) : void {
			_storedPauseState = GlobalVariables.instance.dm.isPaused;
			
			_GS.pause(false);
			_MBS.setup(null, _GS.gold, null, $selected);
			addChild(_MBS);
		}
		
		public function removeMonsterBuyScreen() : void {
			//_GS.unpause();
			removeChild(_MBS);
			
			if (_storedPauseState == false) _GS.unpause(false);
		}
		
		public function diffInWidths(a:DisplayObject, b:DisplayObject): int {
			
			return Math.abs(a.width - b.width);
		}
		
		public function diffInHeights(a:DisplayObject, b:DisplayObject): int {
			
			return Math.abs(a.height - b.height);
		}

	}
	
}

package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class RedButton extends MovieClip {
		
		public var _gs:GameplayScreen;
		
		public function RedButton() {
			// constructor code
			gotoAndStop(1);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
		}
		
		public function onMouseDown(mE:MouseEvent) : void {
			trace("RedButton - DOWN");
			gotoAndStop(2);
			//GlobalSounds.instance.setSound(61);
		}
		
		public function onMouseUp(mE:MouseEvent) : void {
			trace("RedButton - UP");
			gotoAndStop(1);
			GlobalSounds.instance.setSound(61);
			
			//_gs.addOneAdventurer();
			if (_gs.masterGrid.advCount == 0) _gs.fillAdvProgressBar();
			else if (int(_gs.masterGrid.advCount + _gs.masterGrid.entrance.spawnPoint.unitsToSpawn.length) < 6) _gs.addOneAdventurer();
			
			if (GlobalVariables.instance.dm.isPaused) _gs.unpause();
		}
	}
	
}

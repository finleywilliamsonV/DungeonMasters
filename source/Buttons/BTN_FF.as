package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class BTN_FF extends MovieClip {
		
		private var _gs:GameplayScreen;
		private var _gameSpeeds:Array = new Array(300,150,60,30,25);
		
		
		public function BTN_FF() {
			// constructor code
			gotoAndStop(1);
			
			addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}
		
		
		
		
		public function onClick(mE:MouseEvent = null) : void {
			
			GlobalSounds.instance.click();
			
			var next : int = currentFrame + 1;
			if (next > totalFrames) next = 1;
			
			
			// LIMIT TO 1x, 2x, & 5x	// ADDING 10x (!!!)
			if (next == 5) next = 1;
			
			gotoAndStop(next);
			
			GlobalVariables.modTimer(_gameSpeeds[next-1]);
		}
	}
}

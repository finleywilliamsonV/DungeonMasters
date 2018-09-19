package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	
	
	public class Floor_Decor_Candle extends MovieClip {
		
		public function Floor_Decor_Candle() {
			// constructor code
			
			gotoAndPlay(int(Math.random() * totalFrames));
			
			//trace(1);
			
			//addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
		}
		
		public function onAddedToStage(e:Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			trace(1);
			GlobalVariables.instance.timer.addEventListener(TimerEvent.TIMER, onTick, false, 0, true);
			
			//addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true);
		}
		
		public function onRemovedFromStage(e:Event) : void {
			trace(1);
			GlobalVariables.instance.timer.removeEventListener(TimerEvent.TIMER,onTick);
			
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		public function onTick(tE:TimerEvent) : void {
			
			trace("HERE");
			if (currentFrame < totalFrames) {
				gotoAndStop(currentFrame + 1);
			} else {
				gotoAndStop(1);
			}
		}
	}
	
}

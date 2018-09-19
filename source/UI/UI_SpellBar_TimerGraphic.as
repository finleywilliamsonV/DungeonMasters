package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	
	
	public class UI_SpellBar_TimerGraphic extends MovieClip {
		
		
		private var _tickCounter:int;
		private var _ticksTillRemove:int;
		private var _ticksTillNextSection:int;
		
		
		public function UI_SpellBar_TimerGraphic($ticksTillRemove:int = 16) {
			// constructor code
			gotoAndStop(1);
			
			_tickCounter = 0;
			_ticksTillRemove = $ticksTillRemove;
			_ticksTillNextSection = $ticksTillRemove/8;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
		}
		
		public function onAddedToStage(e:Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true);
			GlobalVariables.instance.timer.addEventListener(TimerEvent.TIMER, onTick, false, 0, true);
		}
		
		public function onRemovedFromStage(e:Event): void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			GlobalVariables.instance.timer.removeEventListener(TimerEvent.TIMER, onTick);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
		}
		
		public function onTick(tE:TimerEvent) : void {
			
			_tickCounter++;
			
			var next : int;
			
			if (GlobalVariables.instance.dm.isPaused) return;
			
			if (_tickCounter == _ticksTillNextSection) {
				_tickCounter = 0;
				next = currentFrame + 1;
				
				if (next > totalFrames) {
					destroy();
				} else {
					gotoAndStop(next);
				}
			}
			
			
		}
		
		public function destroy(): void {
			parent.removeChild(this);
			gotoAndStop(1);
		}
		
	}
	
}

package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	
	public class UI_AdvProgressBar extends MovieClip {
		
		public var gs:GameplayScreen;
		public var maxTicks:int;
		public var currentTicks:int;
		
		private var _timer:Timer;
		
		public static const BAR_LENGTH : int = 693;
		public static const MARKER_START_X:int = 94;
		public static const MARKER_START_Y:int = 52;
		
		public function UI_AdvProgressBar($gs : GameplayScreen, $maxTicks : int) {
			// constructor code
			gotoAndStop(1);
			
			x = 223;
			y = 633;
			
			
			gs = $gs;
			maxTicks = $maxTicks;
			currentTicks = 0;
			
			marker.x = MARKER_START_X;
			marker.y = MARKER_START_Y;
			
			marker.visible = false;
			timerDisplay.visible = false;
			
			//_timer = new Timer(GlobalVariables.instance.timer.delay/4);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
		}

		public function onAddedToStage(e: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true);
			
			// add timer & listener
			//_timer.start();
			//_timer.addEventListener(TimerEvent.TIMER, onTick, false, 0, true);
			
		}
		
		public function onRemovedFromStage(e: Event): void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			
			// remove timer & listener
			///_timer.stop()
			//_timer.removeEventListener(TimerEvent.TIMER, onTick);
		}
		
		/*public function onTick(tE:TimerEvent) : void {
			
			trace("Tick");
			update(gs.advSpawnTimer);
			
		}*/
		
		public function update($currentTicks:int) : void {
			
			currentTicks = $currentTicks;
			
			// show marker if not visible
			if (!marker.visible) marker.visible = true;
			if (!timerDisplay.visible) timerDisplay.visible = true;
			
			// update bar
			var progPercent : Number = currentTicks/maxTicks;
			var progDistance: int = BAR_LENGTH * progPercent;
			
			// update timer
			var timerDelay : int = GlobalVariables.instance.timer.delay;
			var ticksPerSecond : int = 1000/timerDelay;
			var ticksRemaining : int = maxTicks - currentTicks;
			//var secondsRemaining:Number = int(100 * ticksRemaining/ticksPerSecond)/100;
			var secondsRemaining:int = ticksRemaining/ticksPerSecond;
			
			
			// check for adv in dungeon
			if (progDistance > BAR_LENGTH || gs.masterGrid.adventurers.length > 0) {
				progDistance = BAR_LENGTH;
				timerDisplay.timerText.text = "ATTACK!";
			} else {
				timerDisplay.timerText.text = String(secondsRemaining) + "s";
			}
			
			marker.x = MARKER_START_X + progDistance;
			
		}
	}
	
}

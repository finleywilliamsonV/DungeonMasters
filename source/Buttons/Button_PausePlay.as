package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class Button_PausePlay extends MovieClip {
		
		
		public function Button_PausePlay() {
			// constructor code
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			gotoAndStop(1);
		}

		public function onAddedToStage(e: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true);
			
			// add onClick listener
			addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}
		
		public function onRemovedFromStage(e: Event): void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			
			// remove onClick listener
			removeEventListener(MouseEvent.CLICK, onClick);
		}
		
		
		public function onClick(e:MouseEvent = null) : void {
			
			e.stopPropagation();
			
			var switchFrame:int;
			
			if (currentFrame == 1) switchFrame = 2;
			if (currentFrame == 2) switchFrame = 1;
			
			gotoAndStop(switchFrame);
			
			if (switchFrame == 1) trace("\nPLAY GAME");
			if (switchFrame == 2) trace("\nPAUSE GAME");
			
		}
		
		
	}
	
}

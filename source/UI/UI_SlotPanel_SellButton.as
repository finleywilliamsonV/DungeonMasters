package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class UI_SlotPanel_SellButton extends MovieClip {
		
		
		public function UI_SlotPanel_SellButton() {
			// constructor code
			GlobalUnlockTracker.instance.newUnlockBubbleHandler.register(this);
			newUnlockBubble.visible = false;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
		}
		
		public function onAddedToStage(e:Event) : void {
			
			if (GlobalUnlockTracker.instance.newUnlockBubbles.length > 0) {
				newUnlockBubble.visible = true;
			} else {
				newUnlockBubble.visible = false;
			}
		}
	}
	
}

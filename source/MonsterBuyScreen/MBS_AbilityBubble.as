package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class MBS_AbilityBubble extends MovieClip {
		
		public var abilitiesBar :*;
		public var abilityText : String = "DEFAULT TEXT";
		
		public function MBS_AbilityBubble() {
			// constructor code
			
			reset();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			gotoAndStop(1);
		}

		public function onAddedToStage(e: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true);
			
			abilitiesBar = parent as MBS_AbilitiesBar;
			
			// add onDown listener
			addEventListener(MouseEvent.MOUSE_DOWN, onDown, false, 0, true);
		}
		
		public function onRemovedFromStage(e: Event): void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			
			reset();
			
			// remove onDown listener
			removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
		}
		
		
		public function onDown(e:MouseEvent = null) : void {
			
			e.stopPropagation();
		
			trace("\nUI_AbilityBubble Down - " + e.target);
			
			abilitiesBar.infoPanel.visible = true;
			abilitiesBar.infoPanel.infoText.text = abilityText;
			
			selector.visible = true;
			
			// remove onDown listener
			removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			// add onUp listener
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp, false, 0, true);
		}

		public function onUp(e:MouseEvent = null) : void {
			
			e.stopPropagation();
		
			trace("\nUI_AbilityBubble Up - " + e.target);

			abilitiesBar.infoPanel.visible = false;
			selector.visible = false;
			
			// remove onUp listener
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			// add onDown listener
			addEventListener(MouseEvent.MOUSE_DOWN, onDown, false, 0, true);
		}
		
		public function setup($graphicIndex:int, $abilityText:String) : void {
			
			//set bubble graphic
			gotoAndStop($graphicIndex);
			
			//store ability text
			abilityText = $abilityText;
			
			//trace("\nSETTING UP ABILITIES BUBBLE WITH: " + abilityText);
		}
		
		public function reset() : void {
			abilitiesBar = null;
			selector.visible = false;
		}
	}
	
}

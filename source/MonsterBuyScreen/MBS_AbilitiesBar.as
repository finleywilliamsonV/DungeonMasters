package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class MBS_AbilitiesBar extends MovieClip {
		
		public var abilities:Array;
		
		public function MBS_AbilitiesBar() {
			// constructor code
			
			reset();
			
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
		
			//trace("\nUI_AbilitiesBar Clicked - " + e.target);
		}
		
		public function setup($purchasable:*) : void {	//MTDC incoming
			
			slot1.visible = false;
			slot2.visible = false;
			slot3.visible = false;
			slot4.visible = false;
			
			//trace("\nSETTING UP ABILITIES BAR WITH: " + $purchasable);
			abilities = $purchasable.abilities;
			
			//trace("W/ these abilities: " + abilities);
			
			//trace("Stage: " + this.stage);
			
			if(abilities.length > 0) {
				if (!abilities[0]) return;
				slot1.visible = true;
				slot1.setup(abilities[0].graphicIndex,abilities[0].abilityText($purchasable));
			}
			if(abilities.length > 1) {
				slot2.visible = true;
				slot2.setup(abilities[1].graphicIndex,abilities[1].abilityText($purchasable));
			}
			if(abilities.length > 2) {
				slot3.visible = true;
				slot3.setup(abilities[2].graphicIndex,abilities[2].abilityText($purchasable));
			}
			if(abilities.length > 3) {
				slot4.visible = true;
				slot4.setup(abilities[3].graphicIndex,abilities[3].abilityText($purchasable));
			}
		}
		
		public function reset() : void {
			abilities = [];
			infoPanel.visible = false;
			
			slot1.visible = false;
			slot2.visible = false;
			slot3.visible = false;
			slot4.visible = false;
		}
	}
	
}

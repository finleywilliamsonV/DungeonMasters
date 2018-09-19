package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	
	public class UI_SpellBar extends MovieClip {
		
		public var spellSelected : UI_SpellBar_SpellSlot;
		
		public function UI_SpellBar() {
			// constructor code
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
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
		
			trace("\nSpellBar Clicked - " + e.target);
			
			var target = e.target;
			
			if (target is UI_SpellBar_SpellSlot) {
				// change panel
				trace("\nSpell Button Clicked");
				
				
				deselectAll();
				
				spellSelected = target;
				
				target.setSelected(!target.isSelected);
				
				var gs:GameplayScreen = parent.parent as GameplayScreen;
				
				//gs.
			}
			
		}
		
		public function deselectAll() : void {
			if (spellSelected) {
					spellSelected.setSelected(false);
					spellSelected = null;
			}
		}
	}
	
}

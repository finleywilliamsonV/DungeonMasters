package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.GameInput;
	import flash.text.TextField;
	
	
	public class UI_SlotPanel_Empty extends MovieClip {
		
		private var _slotType : String;
		
		public function UI_SlotPanel_Empty() {
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
		
			trace("\nSlotPanel_Empty Clicked - " + e.target);
			
			var target = e.target;
			
			if (target is TextField) {
				target = target.parent;
			}
			
			if (target is UI_SlotPanel_SetButton) {
				// change panel
				trace("\nSetButton Clicked");
				
				var gs:GameplayScreen = parent.parent as GameplayScreen;
				
				gs.addSlotPanel_Buy()
			}
		}
		
		public function setup(slotType:String) : void {
			_slotType = slotType;
				
			if (slotType == GlobalVariables.TYPE_MONSTER) {
				gotoAndStop(1);
				setButton.setUnitText.text = "Set Monster";
			} else if (slotType == GlobalVariables.TYPE_TRAP) {
				gotoAndStop(2);
				setButton.setUnitText.text = "Set Trap";
			} else if (slotType == GlobalVariables.TYPE_DOOR) {
				gotoAndStop(3);
				setButton.setUnitText.text = "Set Door";
			} else if (slotType == GlobalVariables.TYPE_CHEST) {
				gotoAndStop(4);
				setButton.setUnitText.text = "Set Chest";
			}
		}
		
		public function reset() : void {
			_slotType = "";
		}
	}
	
}

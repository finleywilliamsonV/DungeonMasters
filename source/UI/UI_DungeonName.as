package  {
	
	import flash.display.MovieClip;
	import flash.filters.DropShadowFilter;
	import flash.events.Event;
	
	
	public class UI_DungeonName extends MovieClip {
		
		public var backgroundSprite:UI_DungeonName_BackgroundSprite;
		
		
		public function UI_DungeonName() {
			// constructor code
			gotoAndStop(1);
			
			//nameText.filters = [new DropShadowFilter()];
			
			//addEventListener(Event.ADDED_TO_STAGE, onAdded, false, 0, true);
		}
		
		//public function onAdded(e:Event) : void {
		//	if (!backgroundSprite) {
		//		//trace("ADDING BACKGROUND SPRITE TO DUNGEON NAME");
		//		backgroundSprite = new UI_DungeonName_BackgroundSprite();
		//		addChild(backgroundSprite);
		//		setChildIndex(backgroundSprite, 0);
		//	}
		//}
	}
	
}

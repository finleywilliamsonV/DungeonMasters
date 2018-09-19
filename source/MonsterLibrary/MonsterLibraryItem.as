package {

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;

	public class MonsterLibraryItem extends MovieClip {

		// above
		public var monsterLibraryPanel: MonsterLibraryPanel;

		// below
		public var monster: Monster;
		public var isSelected: Boolean;
		public var isEquipped: Boolean;

		// for unlocks
		public var unlockCriteria;
		public var isUnlocked: Boolean;
		
		// empty sprite for clicking
		private var emptySprite:Sprite;
		
		// newUnlockBubble
		public var newUnlockBubble: NewUnlockBubble;
		
		public function MonsterLibraryItem($monsterLibraryPanel:MonsterLibraryPanel, $monster:Monster, $isSelected:Boolean, $isEquipped:Boolean) {
			monsterLibraryPanel = $monsterLibraryPanel;
			monster = $monster;
			isSelected = $isSelected;
			isEquipped = $isEquipped;
			
			monsterSprites.gotoMonster($monster);
			
			/*isUnlocked = GlobalUnlockTracker.instance.isUnlocked(GlobalVariables.instance.getClass($monster));
			
			if (isUnlocked) lockGraphic.visible = false;
			else lockGraphic.visible = true;*/
			
			if (isEquipped) equippedGraphic.visible = true;
			else equippedGraphic.visible = false;
			
			
			newUnlockBubble = new NewUnlockBubble();
			addChild(newUnlockBubble);
			newUnlockBubble.x = 102;
			newUnlockBubble.y = 8;
			newUnlockBubble.visible = false;
			
			emptySprite = new Sprite();
			emptySprite.graphics.beginFill(0x000000, 0);
			emptySprite.graphics.drawRect(0,0,100,100);
			addChild(emptySprite);
			
			
		}
		
		public function setSelected(tf:Boolean) :void {
			if (tf) {
				isSelected = true;
				//selectedGraphic.visible = true;
			} else {
				isSelected = false;
				//selectedGraphic.visible = false;
			}
		}
		
		public function get monsterClass() : Class {
			return GlobalVariables.instance.getClass(monster);
		}
		
		public function destroy():void {
			monsterLibraryPanel = null;
			monster.destroy();
			monster = null;
			unlockCriteria = null;
			emptySprite.graphics.clear();
			emptySprite = null;
			
			isEquipped = false;
			isSelected = false;
		}
	}

}
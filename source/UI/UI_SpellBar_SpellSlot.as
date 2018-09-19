package  {
	
	import flash.display.MovieClip;
	
	
	public class UI_SpellBar_SpellSlot extends MovieClip {
		
		public var spellClass : Class;
		public var isSelected:Boolean;
		public var spellTimer:UI_SpellBar_TimerGraphic;
		
		public function UI_SpellBar_SpellSlot() {
			// constructor code
			gotoAndStop(1);
			spellTimer = new UI_SpellBar_TimerGraphic();
		}
		
		public function setSelected(tf:Boolean) : void {

			trace("Setting " + this + " selected to: " + tf);
			isSelected = tf;
			
			if (tf) gotoAndStop(2);
			else gotoAndStop(1);
		}
		
		public function addSpellTimer() : void {
			addChild(spellTimer);
			spellTimer.x = 0;
			spellTimer.y = 0;
		}
	}
	
}

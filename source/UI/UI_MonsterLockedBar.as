package  {
	
	import flash.display.MovieClip;
	
	
	public class UI_MonsterLockedBar extends MovieClip {
		
		/*private var _currentNotoriety:;
		private var _notoriety:;
		private var _:;
		private var _:;*/
		
		
		
		public function UI_MonsterLockedBar() {
			// constructor code
			gotoAndStop(1);
		}
		
		public function setup(): void {
			
		}
		
		public function update(percent :Number): void {
			
		
			bar.scaleX = percent;
			//trace("	-	-	-	-	-	-	--		-	-	-	-	-	--	bar.scaleX: " + bar.scaleX);
			
			trackerSlider.x = bar.width;
			
		}
		
		public function calculate() : void {
			
			
		}
	}
	
}

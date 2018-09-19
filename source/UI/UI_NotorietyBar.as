package  {
	
	import flash.display.MovieClip;
	
	
	public class UI_NotorietyBar extends MovieClip {
		
		/*private var _currentNotoriety:;
		private var _notoriety:;
		private var _:;
		private var _:;*/
		
		
		
		public function UI_NotorietyBar() {
			// constructor code
			gotoAndStop(1);
			
			x = 223;
			y = 707;
		}
		
		public function setup(): void {
			
		}
		
		public function update(percent :Number): void {
			
		
			bar.scaleX = percent;
			//trace("	-	-	-	-	-	-	--		-	-	-	-	-	--	bar.scaleX: " + bar.scaleX);
		}
		
		public function calculate() : void {
			
			
		}
	}
	
}

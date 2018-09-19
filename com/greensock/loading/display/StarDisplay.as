package  {
	
	import flash.display.MovieClip;
	
	
	public class StarDisplay extends MovieClip {
		
		
		public function StarDisplay() {
			// constructor code
			gotoAndStop(1);
		}
		
		public function setStars(numOfStars:int) : void {
			//trace("Set stars at " + numOfStars);
			gotoAndStop(numOfStars);
		}
	}
	
}

package  {
	
	import flash.display.MovieClip;
	
	
	public class Wall_Decor_CracksAndVines extends MovieClip {
		
		
		public function Wall_Decor_CracksAndVines() {
			// constructor code
			
			gotoAndStop(int(Math.random() * totalFrames) + 1);
		}
	}
	
}

package  {
	
	import flash.display.MovieClip;
	
	
	public class Floor_Decor_Object extends MovieClip implements IDecor {
		
		
		public function Floor_Decor_Object() {
			// constructor code
			gotoAndStop(1);
			x = 16;
			y = 16;
		}
	}
	
}

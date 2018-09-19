package  {
	
	import flash.display.MovieClip;
	
	
	public class Floor_L_MC extends MovieClip implements IFloor {
		
		
		public function Floor_L_MC($graphicIndex:int = -1) {
			// constructor code
			
			if ($graphicIndex > 0) gotoAndStop($graphicIndex);
			else gotoAndStop(1);
		}
	}
	
}

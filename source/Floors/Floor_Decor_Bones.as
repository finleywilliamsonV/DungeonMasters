﻿package  {
	
	import flash.display.MovieClip;
	
	
	public class Floor_Decor_Bones extends MovieClip {
		
		
		public function Floor_Decor_Bones() {
			// constructor code
			gotoAndStop(int(Math.random() * totalFrames)+1);
			x = 16;
			y = 16;
			
			//x += int(Math.random() * 16);
			//y += int(Math.random() * 16);
		}
	}
	
}
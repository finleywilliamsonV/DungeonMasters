package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Floor_Decor_Fountain extends MovieClip {
		
		
		public function Floor_Decor_Fountain() {
			gotoAndPlay(int(Math.random() * totalFrames));
			//x = -8;
			//y = -8;
			
			//addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
		}
		
		/*public function onEnterFrame(e:Event) : void {
			
			if (Math.random() < .01 && !GlobalVariables.instance.dm._isPaused) {
				gotoAndStop(int(Math.random() * totalFrames));
			}
		}*/
	}
	
}

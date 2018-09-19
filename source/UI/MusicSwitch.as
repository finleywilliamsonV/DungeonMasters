package  {
	
	import flash.display.MovieClip;
	
	
	public class MusicSwitch extends MovieClip {
		
		public function MusicSwitch() {
			// constructor code
			if (GlobalSharedObject.instance.isMutedMusic) gotoAndStop(2);
			else gotoAndStop(1);
		}
	}
	
}

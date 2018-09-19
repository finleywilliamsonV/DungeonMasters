package  {
	
	import flash.display.MovieClip;
	
	
	public class SFXSwitch extends MovieClip {
		
		public function SFXSwitch() {
			// constructor code
			if (GlobalSharedObject.instance.isMutedSFX) gotoAndStop(2);
			else gotoAndStop(1);
		}
	}
	
}

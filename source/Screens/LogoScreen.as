package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	
	public class LogoScreen extends MovieClip {
		
		
		public function LogoScreen() {
			// constructor code
			addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}
		
		public function onClick(mE:MouseEvent) {
			trace(mE);
		}
	}
	
}

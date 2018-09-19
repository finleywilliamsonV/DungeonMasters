package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	
	public class TitleScreen extends MovieClip {
		
		private var _docClass : DocClass;
		
		public function TitleScreen() {
			// constructor code
		}
		
		public function setup(doc:DocClass):  void {
			_docClass = doc;
			stage.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		public function onClick(mE:MouseEvent):void {
			
			if (mE.target is TS_StartButton) {
				stage.removeEventListener(MouseEvent.CLICK, onClick);
				
				_docClass.TStoGS();
				
			}
			
		}
		
		public function destroy(): void {
			_docClass = null;
		}
	}
	
}

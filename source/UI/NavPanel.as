package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	
	public class NavPanel extends MovieClip {
		
		
		private var _masterGrid :MasterGrid;
		private var _pixelWidth :int = 40;
		
		private var _button;
		private var _buttonHeld : Boolean;
		
		public function NavPanel(mg:MasterGrid) {
			_masterGrid = mg;
			
			x = 1034;
			y = 375;
			
			//addEventListener(MouseEvent.MOUSE_DOWN, onDown, false, 0, true);
		}
		
		public function onDown(mE:MouseEvent) : void {
			
			removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			
			_buttonHeld = true;
			_button = mE.target;
			
			addEventListener(Event.ENTER_FRAME, onEnter, false, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, onUp, false, 0, true);
		}
		
		public function onUp(mE:MouseEvent) : void {
			
			_buttonHeld = false;
			_button = null;
			
			removeEventListener(Event.ENTER_FRAME, onEnter);
			removeEventListener(MouseEvent.MOUSE_UP, onUp);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onDown, false, 0, true);
		}
		
		public function onEnter(e:Event) : void {
			
			if (_button is NavPanel_Up && _masterGrid.upSide < _pixelWidth*2) {
				_masterGrid.y += _pixelWidth/4;
			} else if (_button is NavPanel_Down && _masterGrid.downSide > 750 - _pixelWidth*2) {
				_masterGrid.y -= _pixelWidth/4;
			} else if (_button is NavPanel_Left && _masterGrid.leftSide < _pixelWidth*3) {
				_masterGrid.x += _pixelWidth/4;
			} else if (_button is NavPanel_Right && _masterGrid.rightSide > 1134 -_pixelWidth*3) {
				_masterGrid.x -= _pixelWidth/4;
			}
		}
		
		
		
	}
	
}

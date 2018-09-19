package {

	import flash.display.MovieClip;

	public class UI_ManaBar extends MovieClip {

		// class variables

		public var _maxMana: int;
		public var _currentMana: int;
		public var _percentMana: Number;

		// constructor

		public function UI_ManaBar(): void {
			gotoAndStop(1);
		}
		
		public function setMaxMana(maxMana: int): void {
			_maxMana = maxMana;

			_currentMana = _maxMana;

			_percentMana = 1;
		}
		
		public function set(value :int ): void {
			_currentMana = value;
			_percentMana = _currentMana / _maxMana;
			
			bar.scaleX = _percentMana;
		}
	}

}
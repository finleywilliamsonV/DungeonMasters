package {

	import flash.display.MovieClip;

	public class UI_HealthBar extends MovieClip {

		// class variables

		public var _maxHealth: int;
		public var _currentHealth: int;
		public var _percentHealth: Number;

		// constructor

		public function UI_HealthBar(): void {
			gotoAndStop(1);
		}
		
		public function setMaxHealth(maxHealth: int): void {
			_maxHealth = maxHealth;

			_currentHealth = _maxHealth;

			_percentHealth = 1;
		}
		
		public function set(value :int ): void {
			_currentHealth = value;
			_percentHealth = _currentHealth / _maxHealth;
			
			//trace("Setting _percentHealth = " + _percentHealth);
			
			bar.scaleX = _percentHealth;
		}
	}

}
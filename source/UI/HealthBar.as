package {

	import flash.display.MovieClip;

	public class HealthBar extends MovieClip {

		// class variables

		public var _maxHealth: int;
		public var _currentHealth: int;
		public var _percentHealth: int;

		// constructor

		public function HealthBar(): void {
			gotoAndStop(1);
		}
		
		public function setMaxHealth(maxHealth: int): void {
			_maxHealth = maxHealth;

			_currentHealth = _maxHealth;

			_percentHealth = 100;

			gotoAndStop(11);
		}


		// Update object
		public function addSub(modHealthBy: int): Boolean {

			_currentHealth += modHealthBy;
			_percentHealth = 100 * _currentHealth / _maxHealth;

			if (_currentHealth <= 0) {
				gotoAndStop(0);
				return false;
			}

			gotoAndStop(int(10 * _currentHealth / _maxHealth) + 1);

			return true;
		}
		
		
		public function set(value :int ): void {
			
			if (value < 0) value = 0;
			if (value > _maxHealth) value = _maxHealth;
			
			_currentHealth = value;
			
			_percentHealth = _currentHealth / _maxHealth * 100;
			
			//trace("Setting _percentHealth = " + _percentHealth);
			
			gotoAndStop(int(10 * _currentHealth / _maxHealth) + 1);
		}


	}

}
package {

	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class DungeonMaster {

		private var _gameplayScreen: GameplayScreen;
		private var _masterGrid: MasterGrid;
		
		private var _saveTimer:int = _saveTimerMax;
		private var _saveTimerMax:int = 20;

		private var _timer: Timer;
		public var _gameElements: Array = [];
		public var _updatableElements: Array = [];
		public var _statusArray: Array = [];
		
		private var _residualGoldTimer:int = 0;
		private var _residualGoldTimerMax:int = GlobalVariables.RESIDUAL_GOLD_TIMER_MAX;

		private var _isPaused: Boolean = true;
		
		public var playPause:UI_PlayPause;


		public function DungeonMaster(gs: GameplayScreen): void {

			_gameplayScreen = gs;
			_masterGrid = _gameplayScreen.masterGrid;
			_gameElements = _masterGrid.gameElements;
			_updatableElements = _masterGrid.updatableElements;

			_isPaused = true;

			_timer = GlobalVariables.instance.timer;
		}

		public function awaken(): void {
			_timer.addEventListener(TimerEvent.TIMER, onTick);
			_timer.start();
			
		}

		public function sleep(): void {
			_timer.removeEventListener(TimerEvent.TIMER, onTick);
			_timer.stop();
		}

		public function destroy(): void {
			sleep();
			_gameplayScreen = null;
			_masterGrid = null;
			_gameElements = null;
			_updatableElements = null;
			_timer = null;
		}

		public function onTick(tE: TimerEvent): void {

			if (_isPaused == false) {
				
				//isPaused = true;
				
				//GlobalSounds.instance.playAllSounds();
				
				var statusTicks = _statusArray.length - 1;
				for (var i: int = statusTicks; i >= 0; i--) {
					_statusArray[i].update();
				}
				
				var ticks = _updatableElements.length - 1;
				
				//trace("_updatableElements: " + _updatableElements);

				for (var j: int = ticks; j >= 0; j--) {
					_updatableElements[j].update();
				}
				
				_gameplayScreen.updateUI();
				
				//if (_residualGoldTimer > _residualGoldTimerMax) {
					//_gameplayScreen.earnGold(_gameplayScreen.residualGold);
					//_residualGoldTimer = 0;
				//} else {
					//_residualGoldTimer ++;
				//}
				
				
				if (_saveTimer == 0) {
					_saveTimer = _saveTimerMax
					_gameplayScreen.saveData();
				} else {
					_saveTimer --;
				}
				
				
			}
		}
		
		public function get residualGoldTimerMax() : int {
			return _residualGoldTimerMax;
		}

		public function pauseSwitch(): void {
			if (_isPaused) _isPaused = false;
			else _isPaused = true;
		}

		public function get timer(): Timer {
			return _timer;
		}
		public function get gameplayScreen(): GameplayScreen {
			return _gameplayScreen;
		}

			public function get isPaused() : Boolean {
				return _isPaused;
			}
			
		public function set isPaused(tf:Boolean) : void {
			_isPaused = tf;
			
			if (_isPaused) {
				//trace("TARR");
				_timer.stop();
				GlobalVariables.instance.graphicsTimer.stop();
			} else {
				//trace("SHOWE");
				_timer.start();
				GlobalVariables.instance.graphicsTimer.start();
			}
		}



	}

}
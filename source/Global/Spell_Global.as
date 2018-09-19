package {

	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class Spell_Global extends MovieClip {

		public var _masterGrid: MasterGrid;
		public var _dm: DungeonMaster;

		public var _animationTimer: Timer;

		public var _targetNode: GraphicNode;


		public function Spell_Global(targetNode: GraphicNode) {
			_targetNode = targetNode;
			var tempTimer: Timer = GlobalVariables.instance.timer;
			var tempDivisor: int = 1;

			if (tempTimer.delay > 200) {
				tempDivisor = 8;
			} else if (tempTimer.delay > 100) {
				tempDivisor = 4;
			} else if (tempTimer.delay > 50) {
				tempDivisor = 2;
			}

			width = 32;
			height = 32;

			_animationTimer = new Timer(tempTimer.delay / tempDivisor);

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_animationTimer.addEventListener(TimerEvent.TIMER, onTick);


		}

		public function onAddedToStage(e: Event): void {
			_masterGrid = GlobalVariables.instance.masterGrid;
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			_dm = GlobalVariables.instance.dm;

			this.x = _targetNode.x + _targetNode.width / 2;
			this.y = _targetNode.y + _targetNode.height / 2;

			this.gotoAndStop(1);
			
			_animationTimer.start();
		}


		public function onTick(te: TimerEvent): void {

			if (_dm.isPaused) {
				return;
			}

			scaleX += .25;
			scaleY += .25;

			for each(var a: Adventurer in _masterGrid.adventurers) {

				if (PixelPerfectCollisionDetection.isColliding(this, a, _masterGrid, true, 0)) {

					applySpellStatus(a);
				}
			}

			if (currentFrame < totalFrames) {
				gotoAndStop(currentFrame + 1);
			} else {
				gotoAndStop(1);
			}
			
			if (scaleX > 2) {
				destroy();
			}
		}
		
		public function applySpellStatus($target:*):void {
			trace("NEEDS OVERRIDE");
		}

		public function destroy(): void {

			parent.removeChild(this);
			_animationTimer.removeEventListener(TimerEvent.TIMER, onTick);
			_targetNode = null;
			_animationTimer = null;
			_masterGrid = null;
		}

	}
}
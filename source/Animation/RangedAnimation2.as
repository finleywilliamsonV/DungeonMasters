package {

	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class RangedAnimation extends MovieClip {

		public var _masterGrid: MasterGrid;
		public var _dm: DungeonMaster;

		public var _graphicClass: Class; // graphics

		public var _animationPath: Array;
		public var _animationTimer: Timer;

		public var _animationIndex: int;
		public var _animationGraphics: MovieClip;

		public var _aggressor: MovieClip;
		public var _target: MovieClip;
		public var _targetX: int;
		public var _targetY: int;
		public var _occupier: DisplayObjectContainer;

		public var _divisorX: int;
		public var _divisorY: int;
		
		private var _divisor : int = 8;

		public function RangedAnimation(graphicClass: Class, aggressor: MovieClip, target: MovieClip) {
			_aggressor = aggressor;
			_target = target;
			_targetX = target.x;
			_targetY = target.y;
			_occupier = _target.currentNode.occupier;
			_animationTimer = new Timer(GlobalVariables.instance.timer.delay / _divisor);

			_graphicClass = graphicClass;

			_animationIndex = 0;

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_animationTimer.addEventListener(TimerEvent.TIMER, onTick);

			//trace("												RANGED ANIMATION CREATED!!!");
		}

		public function onAddedToStage(e: Event): void {
			_masterGrid = _target.currentNode.parent as MasterGrid;
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			_dm = GameplayScreen(_masterGrid.parent).dm;

			var tGraphics = new _graphicClass();
			_animationGraphics = tGraphics;

			_masterGrid.addChild(_animationGraphics);
			//trace(x,y);
			_animationGraphics.x = _aggressor.x;
			_animationGraphics.y = _aggressor.y;

			_divisorX = (_targetX - _aggressor.x) / _divisor;
			_divisorY = (_targetY - _aggressor.y) / _divisor;

			_animationGraphics.gotoAndStop(1);

			_animationTimer.start();
			
			
		}

		private function getCurrentAngle(a:MovieClip, b:MovieClip): Number {
			var perpendicular: Number = (a.y + 16) - (b.y + 16);
			var base: Number = (a.x+(16)) - (b.x+(16));
			var theta: Number = Math.atan2(perpendicular, base); // in radians  
			return (theta * 180 / Math.PI); // in degrees  
		}

		public function onTick(te: TimerEvent): void {

			if (_dm._isPaused) {
				return;
			}

			_animationIndex++;

			
			
			


					if (_animationIndex <= _divisor) {

						_animationGraphics.x += _divisorX;
						_animationGraphics.y += _divisorY;
						
						if (_animationGraphics is Anim_Shuriken) {
				trace(_animationGraphics);
				trace(_animationGraphics.rotation);
				_animationGraphics.rotation += 90;
				trace(_animationGraphics.rotation);
			}

					} else {
						destroy();
						return;
					}
				}

				public function destroy(): void {

					//_masterGrid.removeChild(_animationGraphics);

					parent.removeChild(this);
					//_animationTimer.stop();
					_animationTimer.removeEventListener(TimerEvent.TIMER, onTick);
					_target = null;
					_occupier = null;
					_animationTimer = null;
					_animationGraphics = null;

					_masterGrid = null;
				}

			}
		}
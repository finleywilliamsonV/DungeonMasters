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

		public var _aggressorNode: GraphicNode;
		public var _target: * ;
		public var _targetNode: GraphicNode;
		public var _targetX: int;
		public var _targetY: int;
		public var _occupier: * ;

		public var _divisorX: int;
		public var _divisorY: int;

		private var _weaponClass: IWeapon;

		private var _divisor: int = 8;

		public function RangedAnimation(graphicClass: Class, aggressorNode: GraphicNode, targetNode: * , target: * , weaponClass: IWeapon) {
			_aggressorNode = aggressorNode;
			_targetNode = targetNode;

			_target = target;
			
			//trace("RANGED ANIMATION CREATED: " + graphicClass + " @ " + targetNode);

			_targetX = _targetNode.x + _targetNode.width / 2;
			_targetY = _targetNode.y + _targetNode.height / 2;
			_animationTimer = new Timer(GlobalVariables.instance.timer.delay / _divisor);

			_graphicClass = graphicClass;
			_weaponClass = weaponClass;
			_animationIndex = 0;

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_animationTimer.addEventListener(TimerEvent.TIMER, onTick);

			//trace("												RANGED ANIMATION CREATED!!!");
		}

		public function onAddedToStage(e: Event): void {
			_masterGrid = GlobalVariables.instance.masterGrid;
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			_dm = GlobalVariables.instance.dm;

			var tGraphics = new _graphicClass();
			_animationGraphics = tGraphics;

			_masterGrid.addChild(_animationGraphics);
			//trace(x,y);
			_animationGraphics.x = _aggressorNode.x + _aggressorNode.width / 2;
			_animationGraphics.y = _aggressorNode.y + _aggressorNode.height / 2;

			_divisorX = (_targetX - (_aggressorNode.x + _aggressorNode.width / 2)) / _divisor;
			_divisorY = (_targetY - (_aggressorNode.y + _aggressorNode.height / 2)) / _divisor;

			_animationGraphics.gotoAndPlay(1);

			if (_animationGraphics is Anim_Food) {
				_animationGraphics.gotoAndStop(int(Math.random() * _animationGraphics.totalFrames));
			}

			_animationTimer.start();

			if (_animationGraphics is Anim_Tornado_Large == false && _animationGraphics is Anim_RazorGrass == false && _animationGraphics is Anim_HeavyRain == false && _animationGraphics is Anim_Snowflake == false && _animationGraphics is Anim_Skull == false &&_animationGraphics is Anim_Tornado_Large == false &&  _animationGraphics is Anim_Tornado == false && _animationGraphics is Anim_Food == false && _animationGraphics is Anim_ThrowPebbles == false&& _animationGraphics is Anim_MeanEyes == false) {

				_animationGraphics.rotation = getCurrentAngle(_aggressorNode, _targetNode);
				//trace("Angle: " + _animationGraphics.rotation);
			}
		}

		private function getCurrentAngle(a: MovieClip, b: MovieClip): Number {
			var perpendicular: Number = (a.y + 32) - (b.y + 32);
			var base: Number = (a.x + (32)) - (b.x + (32));
			var theta: Number = Math.atan2(perpendicular, base); // in radians  
			return (theta * 180 / Math.PI); // in degrees  
		}

		public function onTick(te: TimerEvent): void {

			//trace("\nRangedAnimation: " + _animationGraphics + " - current frame: " + _animationGraphics.currentFrame);

			
			if (_dm.isPaused) {
				return;
			}
			
			parent.setChildIndex(this, parent.numChildren -1);
			
			/*if (_dm.isPaused) {
				_animationGraphics.stop();
				return;
			} else {
				if (_animationGraphics is Anim_Food == false) {
					if (_animationGraphics.isPlaying == false) {
						_animationGraphics.gotoAndPlay(int(Math.random() * _animationGraphics.totalFrames));
					}
				}
			}*/

			if (PixelPerfectCollisionDetection.isColliding(this, _target, parent, true, 0)) {
				destroy();
				return;
			}


			_targetX = _targetNode.x + _targetNode.width / 2;
			_targetY = _targetNode.y + _targetNode.height / 2;
			_divisorX = (_targetX - (_aggressorNode.x + _aggressorNode.width / 2)) / _divisor;
			_divisorY = (_targetY - (_aggressorNode.y + _aggressorNode.height / 2)) / _divisor;


			_animationIndex++;

			if (_animationIndex <= _divisor) {

				_animationGraphics.x += _divisorX;
				_animationGraphics.y += _divisorY;

				if (_animationGraphics is Anim_Throne ||_animationGraphics is Anim_Vegetation ||_animationGraphics is Anim_Shuriken || _animationGraphics is Anim_ThrowingKnife || _animationGraphics is Anim_Transmute) {
					_animationGraphics.rotation += 33;
				}

			} else {
				destroy();
				return;
			}
		}

		public function destroy(): void {

			_masterGrid.removeChild(_animationGraphics);

			parent.removeChild(this);
			//_animationTimer.stop();
			_animationTimer.removeEventListener(TimerEvent.TIMER, onTick);
			_targetNode = null;

			_target = null;

			_animationTimer = null;
			_animationGraphics = null;

			_aggressorNode = null;


			_masterGrid = null;
		}

	}
}
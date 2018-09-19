package {

	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class Animation_Dynamic extends MovieClip {

		public var _masterGrid: MasterGrid;

		public var _graphicClass: Class; // graphics

		public var _animationPath: Array;
		public var _animationTimer: Timer;

		public var _animationIndex: int;
		public var _animationGraphics: MovieClip;

		public var _targetNode: GraphicNode;
		public var _occupier: DisplayObjectContainer;

		private var _delay: int = 1;
		private var _delayMax: int = 1;
		
		private var _displayCount: int = 0;

		public function Animation_Dynamic(graphicClass: Class, targetNode: GraphicNode) {
			_targetNode = targetNode;

			if (_targetNode.occupier == null) {
				_targetNode = null;
				parent.removeChild(this);
				return;
			}

			_occupier = _targetNode.occupier;
			_animationTimer = GlobalVariables.instance.graphicsTimer;

			_graphicClass = graphicClass;

			_animationIndex = 1;

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_animationTimer.addEventListener(TimerEvent.TIMER, onTick);
		}

		public function onAddedToStage(e: Event): void {
			_masterGrid = GlobalVariables.instance.masterGrid;
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			var tGraphics = new _graphicClass();
			_animationGraphics = tGraphics;

			_masterGrid.addChild(_animationGraphics);
			_animationGraphics.x = _targetNode.x + _targetNode.width / 2;
			_animationGraphics.y = _targetNode.y + _targetNode.height / 2;

			_animationGraphics.gotoAndStop(1);

			//_animationGraphics.gotoAndStop(int(Math.random() * 2 )+ 1);

			//_animationTimer.start();
		}

		public function onTick(te: TimerEvent): void {

			if (GlobalVariables.instance.dm.isPaused) return;

			//trace("\nAnimation_Dynamic: " + _animationGraphics + " - current frame: " + _animationGraphics.currentFrame);

			//parent.setChildIndex(this, parent.numChildren - 1);
			
			if (_delay == 0) {

				_delay = _delayMax;

				_animationIndex++;

				_animationGraphics.visible = true;
				
				if (_animationIndex > _animationGraphics.totalFrames || _animationTimer.delay < 50) {
					destroy();
					return;

				} else {

					_animationGraphics.gotoAndStop(_animationIndex);
					//trace(_animationGraphics, _animationIndex,_animationGraphics.currentFrame);
				}

			} else {

				_delay--;
				_animationGraphics.visible = false;
			}
			
			_displayCount ++;
			
		}

		public function destroy(): void {

			_masterGrid.removeChild(_animationGraphics);

			parent.removeChild(this);
			//_animationTimer.stop();
			_animationTimer.removeEventListener(TimerEvent.TIMER, onTick);
			_targetNode = null;
			_occupier = null;
			_animationTimer = null;
			_animationGraphics = null;

			_masterGrid = null;
		}

	}
}
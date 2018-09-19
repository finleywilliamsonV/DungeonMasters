package {

	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class Animation extends MovieClip {

		public var _masterGrid:MasterGrid;
		
		public var _graphicClass : Class; // graphics

		public var _animationPath: Array;
		public var _animationTimer: Timer;

		public var _animationIndex: int;
		public var _animationGraphics: MovieClip;

		public var _targetNode: GraphicNode;
		public var _occupier: DisplayObjectContainer;

		public function Animation(graphicClass : Class, targetNode: GraphicNode) {
			_targetNode = targetNode;
			
			//trace("ANIMATION CREATED: " + graphicClass + " @ " + targetNode);
			
			if (_targetNode.occupier == null) {
				_targetNode = null;
				parent.removeChild(this);
				return;
			}
			
			_occupier = _targetNode.occupier;
			_animationTimer = GlobalVariables.instance.graphicsTimer;
			
			_graphicClass = graphicClass;

			_animationIndex = 0;

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
			
			_animationGraphics.gotoAndStop(int(Math.random() * 2 )+ 1);
			
			//_animationTimer.start();
		}

		public function onTick(te: TimerEvent): void {

			if (_masterGrid.gameplayScreen.dm.isPaused) return;
			
			_animationIndex++;

			if (_animationIndex == 0) {


			} else if (_animationIndex == 1 && GlobalVariables.instance.timer.delay > 50) {
				
				
				
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
			_occupier = null;
			_animationTimer = null;
			_animationGraphics = null;

			_masterGrid = null;
		}

	}
}
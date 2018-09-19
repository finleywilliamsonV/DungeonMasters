package {

	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class DieGhost extends MovieClip {

		public var _masterGrid:MasterGrid;
		
		public var _graphicClass : Class; // graphics

		public var _animationPath: Array;
		public var _animationTimer: Timer;

		public var _animationIndex: int;
		public var _animationGraphics: MovieClip;

		public var _targetNode: GraphicNode;
		public var _occupier: DisplayObjectContainer;

		public function DieGhost(targetNode: GraphicNode) {
			
			if (!targetNode) return;
			
			_targetNode = targetNode;
			_animationTimer = new Timer(GlobalVariables.instance.timer.delay / 4);

			_animationIndex = 0;

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_animationTimer.addEventListener(TimerEvent.TIMER, onTick);
		}

		public function onAddedToStage(e: Event): void {
			_masterGrid = GlobalVariables.instance.masterGrid;
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			_animationGraphics = new Anim_Ghost();
			
			_masterGrid.addChild(_animationGraphics);
			_animationGraphics.x = _targetNode.x + _targetNode.width / 2;
			_animationGraphics.y = _targetNode.y + _targetNode.height / 2;
			
			_animationTimer.start();
		}

		public function onTick(te: TimerEvent): void {
			//trace(_animationGraphics.currentFrame);
			//trace(1);
			if (_masterGrid.gameplayScreen.dm.isPaused) return;

			_animationIndex++;
			//trace(2);

			if (_animationGraphics.currentFrame == 6) {
				//trace(4);
				destroy();
				return;
				
			} else {
				//trace(3);
				_animationGraphics.gotoAndStop(_animationGraphics.currentFrame + 1);
			}
		}

		public function destroy(): void {
			
			_masterGrid.removeChild(_animationGraphics);
			
			parent.removeChild(this);
			_animationTimer.stop();
			_animationTimer.removeEventListener(TimerEvent.TIMER, onTick);
			_targetNode = null;
			_occupier = null;
			_animationTimer = null;
			_animationGraphics = null;

			_masterGrid = null;
		}

	}
}
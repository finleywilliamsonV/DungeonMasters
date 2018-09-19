package {

	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class Spell extends MovieClip {

		public var _masterGrid: MasterGrid;
		public var _dm: DungeonMaster;

		public var _graphicClass: Class; // graphics

		public var _animationPath: Array;
		public var _animationTimer: Timer;

		public var _animationIndex: int;
		public var _animationGraphics: MovieClip;

		public var _targetNode: GraphicNode;
		public var _occupier: DisplayObjectContainer;

		private var _divisor: int = 8;

		public function Spell(graphicClass: Class, targetNode: GraphicNode) {
			_targetNode = targetNode;

			_animationTimer = new Timer(GlobalVariables.instance.timer.delay / _divisor);

			_graphicClass = graphicClass;

			_animationIndex = 0;

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_animationTimer.addEventListener(TimerEvent.TIMER, onTick);
		}

		public function onAddedToStage(e: Event): void {
			_masterGrid = GlobalVariables.instance.masterGrid;
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			_dm = GlobalVariables.instance.dm;

			var tGraphics = new _graphicClass();
			_animationGraphics = tGraphics;

			_masterGrid.addChild(_animationGraphics);
			_animationGraphics.x = _targetNode.x + _targetNode.width / 2;
			_animationGraphics.y = _targetNode.y + _targetNode.height / 2;

			_animationGraphics.gotoAndStop(1);

			_animationTimer.start();
		}


		public function onTick(te: TimerEvent): void {

			if (_dm.isPaused) {
				return;
			}

			if (_animationGraphics.currentFrame == _animationGraphics.totalFrames) {
				destroy();
				return;
			}

			if (_animationGraphics.currentFrame == 1) {
				var AoE: Array = DungeonPathfinder.getNodesInArea(_targetNode, 3);
				AoE.push(_targetNode);
				//trace("\nStart Spell Graphics");
				trace(AoE);
				var targets: Array = [];
				for (var i: int = 0; i < AoE.length; i++) {
					//trace("Node: " + AoE[i] + "Occ: " + AoE[i].occupiers);
					for (var j: int = 0; j < AoE[i].occupiers.length; j++) {
						
						var target = AoE[i].occupiers[j];
						//trace(target);
						if (target is Adventurer) {
							
							if (target.health <= 0) destroy();
							
							//trace("Target is adv");
							if (_graphicClass == Anim_Area_IceBlast) {
								target.applyStatus(Statuses.freeze_MAX);
							} else if (_graphicClass == Anim_Area_FireBlast) {
								target.calculateDamage(100);
								if (target.health > 0) target.applyStatus(Statuses.burn_MAX);
							} else if (_graphicClass == Anim_Area_Transmute) {
								target.applyStatus(Statuses.transmute_MAX);
							} else if (_graphicClass == Anim_Area_Poison) {
								target.applyStatus(Statuses.poison_MAX);
							} 
							
						} else if (target is Monster && _graphicClass == Anim_Area_Heal) {
								target.addChild(new Animation(Anim_Heal, target.currentNode));
								target.calculateHealing(target.maxHealth / 2);
							}
						

					}
				}
			}

			_animationGraphics.gotoAndStop(_animationGraphics.currentFrame + 1);
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
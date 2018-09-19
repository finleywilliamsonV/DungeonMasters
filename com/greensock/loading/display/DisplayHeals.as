package {

	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	public class DisplayHeals extends MovieClip {
		
		public var _healTimer: Timer;
		
		public var _healIndex: int;
		public var _healGraphics: Heals;
		
		public var _target : Sprite;
		public var _healAmount: int;

		public function DisplayHeals(target: Sprite, timer: Timer, healAmount : int) {
			_target = target;
			_healTimer = new Timer(timer.delay/6);
			_healAmount = healAmount;
			
			_healIndex = 0;

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_healTimer.addEventListener(TimerEvent.TIMER, onTick);
		}

		public function onAddedToStage(e: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_healTimer.start();
		}

		public function onTick(te: TimerEvent): void {

			if (_healIndex == 0) {
				var tHeals: Heals = new Heals(_target);
				_healGraphics = tHeals;
				_target.addChild(tHeals);
				
			} else if (_healIndex == 5) {
			
				destroy();
				return;
					
			} else {
				
				_healGraphics.update();
				
			}
			
			_healIndex++;
		}

		public function destroy(): void {
			
			_target.removeChild(_healGraphics);
			
			parent.removeChild(this);
			_healTimer.stop();
			_healTimer.removeEventListener(TimerEvent.TIMER, onTick);
			_target = null;
			_healTimer = null;
			_healGraphics = null;
		}

	}
}
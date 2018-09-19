package  {
	
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	
	
	public class Heals extends MovieClip {
		
		public var _startFrame:int;
		public var _endFrame:int;
		
		public function Heals(target:DisplayObject):void {
			
			//x = target.x;
			//y = target.y;
			
			gotoAndStop(1);
		}
		
		public function update(): void {
			
			gotoAndStop(currentFrame + 1);
			
		}

	}
}

package  {
	
	import flash.display.MovieClip;
	
	
	public class ResidualGoldDisplay extends MovieClip {
		
		private var _residualGold : Number;
		
		public function ResidualGoldDisplay() {
			
			//set method
			_residualGold = 0;
			x = 42;
			y = 130;
		}
		
		public function modifyGold(newAmt : int) : void {
			
		}
		
		public function get residualGold () : int {
			return _residualGold;
		}
		
		public function set residualGold (newAmt : int) : void {
			
			var timerDelay : int = GlobalVariables.instance.timer.delay;
			var ticksPerSecond : int = 1000/timerDelay;
			
			_residualGold = newAmt;
			var finalGold : Number = _residualGold * ticksPerSecond;
			
			finalGold = int(finalGold * 100) / 100
			displayText.text = finalGold.toString();
			
		}
	}
	
}

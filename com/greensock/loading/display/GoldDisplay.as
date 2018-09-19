package  {
	
	import flash.display.MovieClip;
	
	
	public class GoldDisplay extends MovieClip {
		
		private var _gold : int;
		
		public function GoldDisplay() {
			
			//set method
			gold = 0;
			x = 15;
			y = 65;
		}
		
		public function modifyGold(newAmt : int) : void {
			
		}
		
		public function get gold () : int {
			return _gold;
		}
		
		public function set gold (newAmt : int) : void {
			
			_gold = newAmt;
			displayText.text = _gold.toString();
		}
		
	}
	
}

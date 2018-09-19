package  {
	
	public class DiceRoll {
		
		public static function roll(numOfDice:int, numOfSides:int) : int {
			
			var total : int = 0;
			
			for (var d : int = 0; d < numOfDice; d++) {
				
				//trace("Rolling die number " + (d+1));
				
				var roll :int = 1 + (Math.random() * numOfSides);
				//trace("Rolling from 1 - " + numOfSides + "... result: " + roll);
				total += roll;
			}
			
			//trace("total: " + total);
			return total
		}

	}
	
}

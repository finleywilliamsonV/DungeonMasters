package  {
	
	import flash.display.MovieClip;
	
	
	public class MonsterSprites extends MovieClip {
		
		
		public function MonsterSprites() {
			// constructor code
			gotoAndStop(1);
		}
		
		public function gotoMonster($monster:Monster) {
			var tempMonsterClass : Class = GlobalVariables.instance.getClass($monster);
			var tempClassString :String = String(tempMonsterClass);
			var shortenedClassString:String = tempClassString.substr(7);
			shortenedClassString = shortenedClassString.substring(0, shortenedClassString.length-1);
			gotoAndStop(shortenedClassString);
		}
	}
	
}

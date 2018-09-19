package  {
	
	import flash.display.MovieClip;
	
	
	public class Spell_Global_Ice extends Spell_Global {
		
		
		public function Spell_Global_Ice($targetNode: GraphicNode) {
			// constructor code
			super($targetNode);
		}
		
		override public function applySpellStatus($target:*):void {
			trace("ICE OVERRIDE");
			
			$target.applyStatus(Statuses.freeze_MAX);
		}
	}
	
}

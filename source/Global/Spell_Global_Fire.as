package  {
	
	import flash.display.MovieClip;
	
	
	public class Spell_Global_Fire extends Spell_Global {
		
		
		public function Spell_Global_Fire($targetNode: GraphicNode) {
			// constructor code
			super($targetNode);
		}
		
		override public function applySpellStatus($target:*):void {
			trace("FIRE OVERRIDE");
			
			$target.calculateDamage(100);
			if ($target.health > 0) $target.applyStatus(Statuses.burn_MAX);
		}
	}
	
}

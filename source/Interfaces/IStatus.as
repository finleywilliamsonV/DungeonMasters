package  {
	import flash.display.DisplayObjectContainer;
	
	public interface IStatus {

		// Interface methods:
		
		function get statusType() : String;
		function get graphic():Class
		function get percentChance():Number;
		function get damagePerTurn():int;
		function get duration():int;
		function get durationTimer():int;
		function set duration(value:int):void;
		function set durationTimer(value:int):void;
		function get stopsTargetMovement():Boolean;
		function get confusesTarget():Boolean;
		function get fearsTarget():Boolean;

	}
	
}

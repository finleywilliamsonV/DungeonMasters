package  {
	import flash.display.DisplayObjectContainer;
	
	public class Status implements IStatus {

		private var _statusType:String;
		private var _graphic:Class;
		private var _percentChance:Number;
		private var _damagePerTurn:int;
		private var _duration:int;
		private var _stopsTargetMovement:Boolean;
		private var _confusesTarget:Boolean;
		private var _fearsTarget:Boolean;
		
		private var _durationTimer: int;
		
		public function Status($statusType:String, $graphic:Class, $percentChance:Number, $damagePerTurn:int, $duration:int,$stopsTargetMovement:Boolean, $confusesTarget:Boolean, $fearsTarget:Boolean) {
			// constructor code
			_statusType = $statusType;
			_percentChance = $percentChance;
			_graphic = $graphic;
			_duration = $duration;
			_damagePerTurn = $damagePerTurn;
			_stopsTargetMovement = $stopsTargetMovement;
			_confusesTarget = $confusesTarget;
			_fearsTarget = $fearsTarget;
			
			_durationTimer = _duration;
		}
		
		public function get statusType():String {
			return _statusType;
		}
		
		public function get graphic():Class {
			return _graphic;
		}
		
		public function get percentChance():Number {
			return _percentChance;
		}
		
		public function get damagePerTurn():int {
			return _damagePerTurn;
		}
		
		public function get duration():int {
			return _duration;
		}
		
		public function set duration(value:int):void {
			_duration = value;
		}
		
		public function get durationTimer():int {
			//if (_durationTimer < 0) {
			//	_durationTimer = _duration;
			//}
			return _durationTimer;
		}
		
		public function set durationTimer(value:int):void {
			_durationTimer = value;
		}
		
		public function get stopsTargetMovement():Boolean {
			return _stopsTargetMovement;
		}
		
		public function get confusesTarget():Boolean {
			return _confusesTarget;
		}
		
		public function get fearsTarget():Boolean {
			return _fearsTarget;
		}

	}
	
}

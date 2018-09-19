package {

	public class Statuses {

		private static var _instance: Statuses;
		private static var _allowInstantiation: Boolean;

		public static function get instance(): Statuses {

			if (!_instance) {
				_allowInstantiation = true;
				_instance = new Statuses();
				_allowInstantiation = false;
			}

			return _instance;
		}

		public function Statuses() {
			if (!_allowInstantiation) {
				throw new Error("ERROR: STOP IT FOOL, DON'T INITIALIZE!!");
			}
		}
		
		public static function cloneStatus(s:IStatus) : IStatus {
			var returnStatus = new Status(s.statusType, s.graphic, s.percentChance, s.damagePerTurn, s.duration, s.stopsTargetMovement, s.confusesTarget, s.fearsTarget);
			return returnStatus;
		}
		
		
		// poison
		public static function get poison_1(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_POISON, Anim_Poison, .1,  1, 20, false, false, false);
		}
		public static function get poison_2(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_POISON, Anim_Poison, .15,  2, 20, false, false, false);
		}
		public static function get poison_3(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_POISON, Anim_Poison, .2,  4, 20, false, false, false);
		}
		public static function get poison_4(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_POISON, Anim_Poison, .25,  8, 20, false, false, false);
		}
		public static function get poison_5(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_POISON, Anim_Poison, .5,  10, 20, false, false, false);
		}
		public static function get poison_MAX(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_POISON, Anim_Poison, 1,  4, 50, false, false, false);
		}
		
		//burn
		public static function get burn_1(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_BURN, Anim_Poison, .25,  3, 5, false, false, false);
		}
		public static function get burn_2(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_BURN, Anim_Poison, .35,  5, 5, false, false, false);
		}
		public static function get burn_3(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_BURN, Anim_Poison, .45,  9, 5, false, false, false);
		}
		public static function get burn_4(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_BURN, Anim_Poison, .6,  17, 5, false, false, false);
		}
		public static function get burn_5(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_BURN, Anim_Burn, .75,  32, 10, false, false, false);
		}
		public static function get burn_MAX(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_BURN, Anim_Burn, 1,  6, 30, false, false, false);
		}
		
		//paralyze
		public static function get paralyze_1(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_PARALYZE, Anim_Paralyze, .1,  0, 2, false, false, false);
		}
		public static function get paralyze_2(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_PARALYZE, Anim_Paralyze, .15,  0, 2, false, false, false);
		}
		public static function get paralyze_3(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_PARALYZE, Anim_Paralyze, .2,  0, 4, false, false, false);
		}
		public static function get paralyze_4(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_PARALYZE, Anim_Paralyze, .25,  0, 4, false, false, false);
		}
		public static function get paralyze_5(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_PARALYZE, Anim_Paralyze, .3,  0, 8, false, false, false);
		}
		public static function get paralyze_MAX(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_PARALYZE, Anim_Paralyze, 1,  0, 50, false, false, false);
		}
		
		// freeze
		public static function get freeze_1(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_FREEZE, Anim_Freeze, .05,  5, 2, true, false, false);
		}
		public static function get freeze_2(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_FREEZE, Anim_Freeze, .1,  10, 4, true, false, false);
		}
		public static function get freeze_3(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_FREEZE, Anim_Freeze, .15,  15, 6, true, false, false);
		}
		public static function get freeze_4(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_FREEZE, Anim_Freeze, .2,  20, 8, true, false, false);
		}
		public static function get freeze_5(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_FREEZE, Anim_Freeze, .25,  25, 10, true, false, false);
		}
		public static function get freeze_MAX(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_FREEZE, Anim_Freeze, 1,  10, 10, true, false, false);
		}
		
		// confuse
		public static function get confuse_1(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_CONFUSE, Anim_Confuse, .05,  0, 2, false, false, true);
		}
		public static function get confuse_2(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_CONFUSE, Anim_Confuse, .1,  0, 4, false, false, true);
		}
		public static function get confuse_3(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_CONFUSE, Anim_Confuse, .15,  0, 6, false, false, true);
		}
		public static function get confuse_4(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_CONFUSE, Anim_Confuse, .2,  0, 8, false, false, true);
		}
		public static function get confuse_5(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_CONFUSE, Anim_Confuse, .25,  0, 10, false, false, true);
		}
		public static function get confuse_MAX(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_CONFUSE, Anim_Confuse, 1,  0, 30, false, false, true);
		}
		
		// fear
		public static function get fear_1(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_FEAR, Anim_Fear, .1,  0, 5, false, false, true);
		}
		public static function get fear_2(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_FEAR, Anim_Fear, .1,  0, 5, false, false, true);
		}
		public static function get fear_3(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_FEAR, Anim_Fear, .15,  0, 10, false, false, true);
		}
		public static function get fear_4(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_FEAR, Anim_Fear, .2,  0, 10, false, false, true);
		}
		public static function get fear_5(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_FEAR, Anim_Fear, .25,  0, 20, false, false, true);
		}
		public static function get fear_MAX(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_FEAR, Anim_Fear, 1,  0, 20, false, false, true);
		}
		
		// transmute
		public static function get transmute_1(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_TRANSMUTE, Anim_Chicken, 1,  0, 10, false, false, true);
		}
		public static function get transmute_2(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_TRANSMUTE, Anim_Chicken, 1,  0, 30, false, false, true);
		}
		public static function get transmute_MAX(): Status {
			return new Status(GlobalVariables.TYPE_STATUS_TRANSMUTE, Anim_Chicken, 1,  0, 20000, false, false, true);
		}
		
		/*public static function get random_MAX() : Status {
			return new Status(GlobalVariables.TYPE_STATUS_TRANSMUTE, Anim_Chicken, 1,  0, 20000, false, false, true);
		}*/
		

	}
}
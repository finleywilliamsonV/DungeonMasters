package {
	import flash.utils.Timer;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.text.TextFormat;
	import flash.text.Font;

	public class GlobalVariables {

		private static var _instance: GlobalVariables;
		private static var _allowInstantiation: Boolean;

		private static var _timer: Timer;
		private static var _graphicsTimer: Timer;

		private static const TIMER_LENGTH: int = 500;

		public static const SPAWN_DELAY: int = 40;
		
		public static const STARTING_GOLD: int = 200;
		public static const STARTING_DUNGEON: String = "DG_Glubmire";
		
		public static const SEX_MALE:String = "male";
		public static const SEX_FEMALE:String = "female";
		public static const SEX_NEUTRAL:String = "neutral";

		public static const TYPE_MONSTER: String = "monster";
		public static const TYPE_TRAP: String = "trap";
		public static const TYPE_CHEST: String = "chest";
		public static const TYPE_DOOR: String = "door";
		public static const TYPE_ADVENTURER: String = "adventurer";
		
		public static const TYPE_STATUS_BURN: String = "burning";
		public static const TYPE_STATUS_POISON: String = "poison";
		public static const TYPE_STATUS_FREEZE: String = "freezing";
		public static const TYPE_STATUS_CONFUSE: String = "confusion";
		public static const TYPE_STATUS_FEAR: String = "fear";
		public static const TYPE_STATUS_PARALYZE: String = "paralysis";
		public static const TYPE_STATUS_TRANSMUTE: String = "transmutation";
		//public static const TYPE_STATUS_RANDOM: String = "random";
		
		public static const TIMER_LENGTH_1x:int = 300;
		public static const TIMER_LENGTH_2x:int = 150;
		public static const TIMER_LENGTH_5x:int = 60;
		public static const TIMER_LENGTH_10x:int = 30;
		public static const TIMER_LENGTH_20x:int = 25;
		
		public static const DEFAULT_FONT: Font = new GlobalFont_PoorRichard();
		
		public static const RESIDUAL_GOLD_TIMER_MAX: int = 1;
		public static const RESIDUAL_GOLD_DIVISOR: int = 1000;

		public static const dungeonClasses: Array = new Array(DG_Glubmire, DG_Skoodhorn, DG_Moonglow, DG_HallOfDespair);
		
		//public static const advClasses: Array = new Array(A_Ruffian, A_Scientist, A_Chef, A_AncientSage,A_Destroyer, A_ElfQueen, A_DwarvenMonk, A_Sorceress, A_Cleric, A_Knight, A_Knight_2, A_Rogue, A_Wizard, A_FireWizard, A_Archer, A_Villager, A_Villager_2, A_Villager_3, A_DwarvenHero, A_Barbarian, A_Warrior);
		public static const advClasses: Array = new Array(A_AncientSage, A_Wizard, A_Villager_3, A_Villager_2, A_Villager, A_Scientist, A_Ruffian, A_Rogue, A_Nun, A_LadyOfWind, A_LadyOfWater, A_LadyOfFire, A_Knight_2, A_Knight, A_FireWizard, A_Executioner, A_Empress, A_Emporer, A_ElfQueen, A_EliteDestroyer, A_DwarvenWizard, A_DwarvenMonk, A_DwarvenMiner, A_Destroyer, A_Constable, A_Cleric, A_Chef, A_Centaur, A_Bowman, A_BeastKin,A_DwarvenHero, A_Barbarian, A_Archer, A_AncientSage, A_Angel);

		public static const purchasableMonsters: Array = new Array(M_EvilDuck, M_Bat, M_Shadow, M_ScaredyCat, M_PlagueRat, M_SandWorm, M_Skeleton, M_GiantSpider, M_PepperJelly, M_MudBeast, M_Zombie, M_NewtWitch, M_Sprite, M_EmporerTurtle, M_RingNeck, M_Leprechaun, M_Gargoyle, M_Lion, M_FloatingEye, M_ShockPuff, M_Buzz, M_Cyclops, M_GreatMoth, M_Genie, M_DodoKnight, M_Hermit, M_PirateOrc, M_RedDragon,M_Gryffon, M_StoneGolem, M_SproutBeast, M_ToadSage, M_ThunderGiant, M_Reaper, M_IceKing, M_Cthulian, M_DarkPriest, M_Beholder);
		//public static const purchasableTraps: Array = new Array(BoulderTrap, T_SpikeTrap, T_SpikeTrap_Fire, T_SpikeTrap_Ice, T_ArrowTrap, T_ArrowTrap_Poison, T_ArrowTrap_Paralyze);
		//public static const purchasableDoors: Array = new Array(LockedDoor, D_IceDoor, D_FireDoor, D_ConfuseDoor);
		//public static const purchasableChests: Array = new Array(Chest);


		public var masterGrid: MasterGrid;
		public static var gameplayScreen:GameplayScreen
		public static var advLevelData: AdvLevelData;
		public var dungeonAlertPanel:DungeonAlertPanel;
		public var dm:DungeonMaster;

		public static function get instance(): GlobalVariables {
			if (!_instance) {
				_allowInstantiation = true;
				_instance = new GlobalVariables();
				_allowInstantiation = false;

				_timer = new Timer(TIMER_LENGTH);
				_graphicsTimer = new Timer(TIMER_LENGTH/2);

				advLevelData = new AdvLevelData();
			}

			return _instance;
		}

		public static function modTimer(newInterval: int): void {
			_timer.delay = newInterval;
			
			if (newInterval > 50) _graphicsTimer.delay = newInterval/2;
			else _graphicsTimer.delay = newInterval;
		}

		public function GlobalVariables() {
			if (!_allowInstantiation) {
				throw new Error("ERROR: STOP IT FOOL, DON'T INITIALIZE!!");
			}
		}
		
		public static function clone(source: Object): * {
			var myBA: ByteArray = new ByteArray();
			myBA.writeObject(source);
			myBA.position = 0;
			return (myBA.readObject());
		}

		public function get timer(): Timer {
			/*_timer.reset();
			_timer.stop();*/
			return _timer;
		}

		public function get graphicsTimer(): Timer {
			/*_timer.reset();
			_timer.stop();*/
			return _graphicsTimer;
		}
		
		public function getClass(obj: Object): Class {
			return Class(getDefinitionByName(getQualifiedClassName(obj)));
		}

	}

}
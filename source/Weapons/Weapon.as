package {
	import flash.display.MovieClip;
	import flash.media.Sound;

	public class Weapon implements IWeapon, IAbility {

		private var _name: String;
		private var _animation: Class;
		private var _isRanged: Boolean;
		private var _range: int;
		private var _isMagic: Boolean;
		private var _manaCost: int;
		private var _numDice: int;
		private var _numSides: int;
		private var _status: IStatus;
		private var _graphicIndex: int;
		private var _soundIndex:int;

		public function Weapon(nam3: String, animationClass: Class, ranged: Boolean, rangeDist: int, magic: Boolean, mCost: int, nDice: int, nSides: int, statusEffect: IStatus, abilityBubbleGraphicIndex: int, soundIndex:int = -1): void {
			_name = nam3;
			_animation = animationClass;
			_isRanged = ranged;
			_range = rangeDist;
			_isMagic = magic;
			_manaCost = mCost;
			_numDice = nDice;
			_numSides = nSides;
			_status = statusEffect;
			_graphicIndex = abilityBubbleGraphicIndex;
			_soundIndex = soundIndex;
		}
		
		public function get isHealing() : Boolean {
			//trace(_animation == Anim_Heal);
				return (_animation == Anim_Heal);
		}

		public function animate(aggressor: MovieClip, target: MovieClip): void {

			var targetNode: GraphicNode;

			if (target is Boss) {
				targetNode = target.getClosestNode(aggressor.currentNode);
				trace("				!!!!! " + targetNode);
			} else {
				targetNode = target.currentNode;
			}

			if (_animation == Anim_Throne ||_animation == Anim_Smite ||_animation == Anim_Arrow_Poison ||_animation == Anim_DivineLight ||_animation == Anim_Vegetation ||_animation == Anim_Tornado_Large ||_animation == Anim_SmallFireball ||_animation == Anim_Skull ||_animation == Anim_ThrowBoulder || _animation == Anim_StaticShock ||_animation == Anim_AcidSpit ||_animation == Anim_PoisonGas ||_animation == Anim_DirtBall ||_animation == Anim_BurningSlime ||_animation == Anim_ShootWeb || _animation == Anim_MeanEyes || _animation == Anim_SoundWave || _animation == Anim_RazorGrass || _animation == Anim_HeavyRain ||_animation == Anim_Venom ||_animation == Anim_Transmute ||_animation == Anim_Tornado ||_animation == Anim_ThrowingKnife ||_animation == Anim_MagicMissile ||_animation == Anim_Fireball ||_animation == Anim_Food || _animation == Anim_Shuriken || _animation == Anim_Arrow || _animation == Anim_Snowflake|| _animation == Anim_ThrowPebbles ||_animation == Anim_Bolt) {
				target.parent.addChild(new RangedAnimation(_animation, aggressor.currentNode, targetNode, target, this));
			} else {
				target.parent.addChild(new Animation_Dynamic(_animation, targetNode));
			}
			
			if (_soundIndex == -1) {
				return;
			} else if (_soundIndex <= 2) { // sounds 0, 1, 2
				GlobalSounds.instance.randomSwing();
			} else {
				GlobalSounds.instance.playSound(_soundIndex);
			}
			

		}

		public function get graphicIndex(): int {
			return _graphicIndex;
		}

		public function abilityText(parentUnit: * ): String {
			var returnString: String = "";

			var damageMod: int;

			if (parentUnit is ITrap || parentUnit is IDoor) {
				returnString = String(_name + ":\n(" + parentUnit.weapon.damage + ")  damage");
				if (_status) {
					var tStatus:IStatus = _status;
					returnString += "\n\n" + (tStatus.percentChance * 100) + "% chance to " + tStatus.statusType;
					
					if(tStatus.damagePerTurn > 0) returnString += ",\n" + "dealing " + tStatus.damagePerTurn + " damage/turn";
					
					if (tStatus.duration > 0) returnString += "\n\nDuration: " + tStatus.duration + " turns";
				}
				
			} else {

				if (parentUnit is IMonster || parentUnit is IAdventurer) damageMod = parentUnit.attack;
				else damageMod = 0;
				

				if (_isRanged) damageMod = parentUnit.dexterity;

				if (_isMagic) damageMod = parentUnit.magicAttack;


				var lowerBound: int = numDice + damageMod;
				var upperBound: int = (numDice * numSides) + damageMod;
				
				var damageType:String = "Damage: ";
				if (animation == Anim_Heal) damageType = "Healing: ";

				if (lowerBound == upperBound) {
					returnString = String(" - " + _name + "\n	" + damageType + upperBound);
				} else {
					returnString = String(" - " + _name + "\n	" + damageType + lowerBound + "-" + upperBound);
				}
				
				if (manaCost > 0) returnString += String("\n	Mana Cost: " + manaCost);
				
				returnString += String("\n	Range: " + range);
				
				if (_status) {
					var tStatus:IStatus = _status;
					returnString += "\n\n" + (tStatus.percentChance * 100) + "% chance to " + tStatus.statusType;
					
					if(tStatus.damagePerTurn > 0) returnString += ",\n" + "dealing " + tStatus.damagePerTurn + " damage/turn";
					
					if (tStatus.duration > 0) returnString += "\n\nDuration: " + tStatus.duration + " turns";
				}
			}

			return returnString;
		}

		public function get animation(): Class {
			return _animation;
		}
		public function get isRanged(): Boolean {
			return _isRanged;
		}

		public function get range(): int {
			return _range;
		}

		public function get isMagic(): Boolean {
			return _isMagic;
		}

		public function get manaCost(): int {
			return _manaCost;
		}

		public function get damage(): int {
			return DiceRoll.roll(_numDice, _numSides);
		}

		public function get status(): IStatus {
			return _status;
		}

		public function get numDice(): int {
			return _numDice;
		}

		public function get numSides(): int {
			return _numSides;
		}

		public function toString(): String {
			return _name;
		}

	}

}
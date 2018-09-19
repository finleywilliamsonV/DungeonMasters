package {
	import flash.display.MovieClip;

	public interface IWeapon {

		function animate(aggressor:MovieClip, target:MovieClip):void;
		function get animation(): Class;
		function get isRanged(): Boolean;
		function get range(): int;
		function get isMagic(): Boolean;
		function get manaCost(): int;
		function get damage(): int; // call to DiceRoll
		function get status(): IStatus;
		
		function get isHealing():Boolean;

	}

}
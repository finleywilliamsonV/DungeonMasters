package {
	import flash.display.DisplayObjectContainer;

	public interface INode {
		
		function get f(): Number;
		function get g(): Number;
		function get h(): Number;
		function get row(): int;
		function get col(): int;
		function get parentNode(): INode;
		function get parentGrid(): *;
		function get isTraversable(): Boolean;
		function get isOccupied(): Boolean;
		function get occupier(): DisplayObjectContainer;
		function get connectedNodes() : Array;
		function set f(value: Number): void;
		function set g(value: Number): void;
		function set h(value: Number): void;
		function set row(value: int): void;
		function set col(value: int): void;
		function set parentNode(value: INode): void;
		function set parentGrid(value: *): void;
		function set isTraversable(value: Boolean): void;
		function set isOccupied(value: Boolean): void;
		//function set occupier(value: DisplayObject): void;
		
	}

}
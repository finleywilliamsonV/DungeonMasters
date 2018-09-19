package  {
	
	import flash.display.MovieClip;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	//------------------------------------------------------------------------------ import Scroller
	import com.doitflash.consts.Orientation;
	import com.doitflash.consts.Easing;
	import com.doitflash.events.ScrollEvent;
	import com.doitflash.starling.utils.scroller.Scroller;
	import flash.geom.Point;
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	// function populate takes in an array of IPurchasable
	// 
	
	
	public class PurchaseLibrary extends MovieClip {
		
		
		private var _libraryItems : Array = [];
		private var _itemPanel : Sprite;
		
		//public var 
		
		private var _gridArray: Array = [];
		private var _columns: int;
		private var _rows: int;
		
		private var _selected : LibraryItem;
		
		// scroller variables
		private var _scroller: Scroller;
		private var _body: Sprite;
		private var _mask: Sprite;
		public static const MASK_WIDTH: Number = 200;
		public static const MASK_HEIGHT: Number = 175;
		private var _mouseOver: Boolean = false;
		private var _content: * ;
		
		
		
		public function PurchaseLibrary() {
			// constructor code
			_itemPanel = new Sprite();
			addChild(_itemPanel);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
		}
		
		public function onAddedToStage(e: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			/*if (GlobalVariables.isMobile) {
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
				addEventListener(TouchEvent.TOUCH_TAP, onTap);
			} else {*/
				//addEventListener(MouseEvent.CLICK, onClick);
			//}
			
			if (!_body) _body = new Sprite();
			this.addChild(_body);

			setScroller();
			onResize();
		}

		public function onRemovedFromStage(e: Event): void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			/*if (GlobalVariables.isMobile) {
				removeEventListener(TouchEvent.TOUCH_TAP, onTap);
			} else {*/
				//removeEventListener(MouseEvent.CLICK, onClick);
			//}
			
			_content.removeEventListener(MouseEvent.MOUSE_DOWN, onTouchDown);
			_content.removeEventListener(MouseEvent.MOUSE_MOVE, onTouchMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onTouchUp);
		}
		
		public function populate(libraryType:String) {
			
			trace("\nPOPULATING PURCHASE LIBRARY W/ TYPE - " + libraryType);
			
			if (libraryType == GlobalVariables.TYPE_MONSTER) {
				_libraryItems = GlobalVariables.purchasableMonsters;
			} else if (libraryType == GlobalVariables.TYPE_TRAP) {
				//_libraryItems = GlobalVariables.purchasableTraps;
			} else if (libraryType == GlobalVariables.TYPE_DOOR) {
				//_libraryItems = GlobalVariables.purchasableDoors;
			} else if (libraryType == GlobalVariables.TYPE_CHEST) {
				//_libraryItems = GlobalVariables.purchasableChests;
			} 
			
			
			
			trace("_libraryItems set to: " + _libraryItems);
			trace("_libraryItems.length: " + _libraryItems.length);
			
			// measure list length and create 2D array accordingly

			var numItems : int = _libraryItems.length;
			
			if (numItems <= 3) _columns = numItems;
			else _columns = 3;
			
			_rows = Math.ceil(numItems/3);
			
			
			// initialize the empty grid w/ columns, rows
			initializeGrid();
			
			for each ( var itemClass : Class in _libraryItems ) {
				trace(itemClass);
			}
			
			if (_content) _content.y = 0;
			
		}
		
		// populate grid
		private function initializeGrid(): void {
			trace("\n * * * INITIALIZING GRID * * *");
			trace(" * * * COLUMNS: " + _columns);
			trace(" * * * ROWS: " + _rows);
			
			var itemCount:int = 0;
			
			for (var r: int = 0; r < _rows; r++) {
			
				_gridArray[r] = [];

				for (var c: int = 0; c < _columns; c++) {

					
					if (itemCount == _libraryItems.length) return;
					
					var newLibItem = new LibraryItem(_libraryItems[itemCount]);	// this is the unit class from list of all
					_itemPanel.addChild(newLibItem);
					
					_gridArray[r][c] = newLibItem;
					trace(" * * * Setting (" + c + ", " + r + ") to " + newLibItem);
					
					// calc column spacing
					var numBuffersBefore: int = c + 1;
					var numSpacesBefore: int = c;
					newLibItem.x = (numBuffersBefore * 12.5) + (numSpacesBefore * 50);
					
					// calc row spacing
					numBuffersBefore = r + 1;
					numSpacesBefore = r;
					newLibItem.y = (numBuffersBefore * 12.5) + (numSpacesBefore * 50);
					
					itemCount++;
					
				}
			}
		}
		
		public function setSelected(item:LibraryItem): void {
			
			if (_selected) {
				_selected.selected = false;
			}
			
			item.selected = true;
			_selected = item;
		}
		
		public function reset(): void {
			_gridArray = [];
			_itemPanel.removeChildren();
			_libraryItems = [];
		}
		
		public function get gridArray(): Array {
			return _gridArray;
		}
		
		
		private function setScroller(): void {
			// set the mask
			if (!_mask) _mask = new Sprite();
			_mask.y = 0;

			if (!_content) _content = _itemPanel;

			_content.mask = _mask;
			//_content.txt.autoSize = TextFieldAutoSize.LEFT;
			//_content.txt.addEventListener(Event.CHANGE, onTextChange);
			_content.addEventListener(MouseEvent.MOUSE_DOWN, onTouchDown);
			_content.addEventListener(MouseEvent.MOUSE_MOVE, onTouchMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onTouchUp);

			_body.addChild(_mask);
			_body.addChild(_content);

			//------------------------------------------------------------------------------ set Scroller
			if (!_scroller) _scroller = new Scroller();
			_scroller.content = _content; // you MUST set scroller content before doing anything else
			_scroller.orientation = Orientation.VERTICAL; // accepted values: Orientation.AUTO, Orientation.VERTICAL, Orientation.HORIZONTAL
			_scroller.easeType = Easing.Expo_easeOut;
			//_scroller.duration = .1;
			_scroller.holdArea = 0;
			_scroller.isStickTouch = false;

			_scroller.yPerc = 0;
		}
		
		private function onTouchDown(e: MouseEvent): void {
			if (!_mouseOver) {
				var pos: Point = new Point(e.stageX, e.stageY);
				_scroller.startScroll(pos); // on touch begin and move
				_mouseOver = true;
			}
		}

		private function onTouchMove(e: MouseEvent): void {
			if (_mouseOver) {
				var pos: Point = new Point(e.stageX, e.stageY);
				_scroller.startScroll(pos); // on touch begin and move
			}

		}

		private function onTouchUp(e: MouseEvent): void {
			_scroller.fling(); // on touch ended
			_mouseOver = false;
		}

		private function onResize(e: *= null): void {
			if (_mask) drawRect(_mask, 0x000000, 1, MASK_WIDTH, MASK_HEIGHT);

			if (_scroller) {
				_scroller.boundWidth = MASK_WIDTH;
				_scroller.boundHeight = MASK_HEIGHT - 25;
			}

			if (_body && _scroller) {
				//_body.x = (stage.stageWidth / 2) - (_scroller.boundWidth / 2);
				//_body.y = (stage.stageHeight / 2) - (_scroller.boundHeight / 2);
			}
		}

		private function drawRect($target: * , $color: uint, $alpha: Number, $width: Number, $height: Number): void {
			$target.graphics.clear();
			//$target.graphics.lineStyle(5, 0x0000FF, .5, false);
			$target.graphics.beginFill($color, $alpha);
			$target.graphics.drawRect(0, 0, $width, $height);
			$target.graphics.endFill();
		}

		
	}	
}

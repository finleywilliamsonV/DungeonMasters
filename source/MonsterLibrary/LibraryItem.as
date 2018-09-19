package  {
	import flash.display.MovieClip;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	
	public class LibraryItem extends MovieClip {
		
		public var unitClass: Class;
		public var unit:IPurchasable;
		
		private var _bitmapData : BitmapData;
		private var _bitmap:Bitmap;
		private static var _pixelWidth : int = 40;
		private static var _rect:Rectangle = new Rectangle(0,0,_pixelWidth,_pixelWidth);

		
		public function LibraryItem(newUnitClass:Class) {
			// constructor code
			unitClass = newUnitClass;
			unit = new unitClass(GlobalVariables.instance.masterGrid);
			
			selectionSquare.visible = false;
			
			_bitmapData = new BitmapData(_pixelWidth, _pixelWidth, true, 0x000000);	// pixel width
			_bitmap = new Bitmap(_bitmapData);
			addChild(_bitmap);
			
			scaleX = 1.25;
			scaleY = 1.25;
			
			update(MovieClip(unit));
		}
		
		public function update(mc:MovieClip) : void {
			
			// reset bitmap
			_bitmapData.fillRect(_rect, 0x000000);
			
			/*if (mc is M_Cyclops || mc is M_FireDragon) {
				var mat :Matrix = new Matrix(1, 0, 0, 1, -mc.getBounds(mc).x, -mc.getBounds(mc).y+5);
			} else {*/
				var mat :Matrix = new Matrix(1, 0, 0, 1, -mc.getBounds(mc).x + 10, -mc.getBounds(mc).y + 10);
			//}
			
			_bitmapData.draw(mc,mat); 
		}
		
		public function reset() : void {
			//unit = null;
			
		}
		
		public function set selected(tf:Boolean) : void {
			selectionSquare.visible = tf;
		}
		
		public function destroy() : void {
			unit.destroy();
			unit = null;
			_bitmapData = null;
			_bitmap = null;
		}

	}
	
}

package FlxerGallery.main {
    import flash.display.Graphics;
    import flash.display.Shape;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	
	public class DrawerFunc {
		public function DrawerFunc() {
		}
		public static function drawer(trgt,xx,yy,w,h,col,o_col,aa) {
			
			if (aa == undefined) {
				aa=1;
			}
			with (trgt) {
				if (o_col != null) {
					graphics.lineStyle(0,o_col,aa);
				}
				if (col != null) {
					graphics.beginFill(col,aa);
				}
				graphics.moveTo(xx,yy);
				graphics.lineTo(w+xx,yy);
				graphics.lineTo(w+xx,h+yy);
				graphics.lineTo(xx,h+yy);
				graphics.lineTo(xx,yy);
			}
		}
		public static function textureDrawer(t, w, h) {
			t.graphics.clear();
			t.graphics.beginBitmapFill(new texture(w,h));
			t.graphics.drawRect(0,0,w,h);
		}
	}
}
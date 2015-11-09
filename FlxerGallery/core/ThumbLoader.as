package FlxerGallery.core {
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import FlxerGallery.main.BitmapDataToBinaryPNG
	import FlxerGallery.main.ByteArrayUploader
	public class ThumbLoader extends Sprite {
		var w
		var h
		var c
		/*var myKeyL;
		var noImg;
		var t*/
		var bd
		var bm
		var shot
		var ok
		var no
		var swfLoader
		public function ThumbLoader(file) {
			x = 0;
			y = Preferences.pref.testaH;
			//this.y = 0;
			w = Preferences.pref.w
			h = Preferences.pref.h-Preferences.pref.testaH-Preferences.pref.piedeH;
			this.swfLoader = new Loader();
			this.addChild(swfLoader);
			swfLoader.contentLoaderInfo.addEventListener(Event.INIT, initHandler);
			this.swfLoader.load(new URLRequest(file));
		}
		function initHandler(event) {
			parent.myToolbar.visualizzappBig()
			resizza();
		}
		public function resizza() {
			parent.myToolbar.piede.contr.playpause.enable();
			parent.myToolbar.piede.contr.playpause.avvia({fnz:parent.myToolbar.myRemoveThumb,fnzOut:parent.myToolbar.myRemoveThumb2,alt:Preferences.pref.playpauseAlt});/**/
			w = Preferences.pref.w
			h = Preferences.pref.h-Preferences.pref.testaH-Preferences.pref.piedeH;
			swfLoader.width = w;
			swfLoader.height = h;
			if (swfLoader.scaleY>swfLoader.scaleX) {
				swfLoader.scaleY = swfLoader.scaleX;
			} else {
				swfLoader.scaleX = swfLoader.scaleY;
			}
			swfLoader.x = (w-swfLoader.width)/2
			swfLoader.y = (h-swfLoader.height)/2
		}
		function errorHandler(event) {
			trace("errorHandler "+event)
		}
		public function myPlaypause(t) {
			parent.parent.home.childNodes[0].attributes.autostop = "false";
			parent.myToolbar.piede.contr.playpause.avvia({fnz:parent.myToolbar.myPlaypause,alt:Preferences.pref.playpauseAlt});
			parent.mySuperPlayer.avvia(0)
			var myLoader = new URLLoader(new URLRequest(Preferences.pref.myViPath+parent.mySuperPlayer.currMov));
			parent.removeChild(this);
		}
	}
}
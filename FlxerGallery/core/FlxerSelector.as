package FlxerGallery.core {
	import flash.display.Sprite;
	
	import FlxerGallery.comp.ButtonSelector;
	public class FlxerSelector extends Sprite {
		var w:Number;
		var h:Number;
		var tw:Number;
		var th:Number;
		/*
		var lista:XML;
		var resizza_onoff;
		var noImg
		*/
		//var obj;

		var thumbPage;
		var thumbNx;
		var thumbNy;
		var pageDn;
		var pageUp;
		public function FlxerSelector() {
			thumbPage = 0
			this.y = Preferences.pref.testaH;
		}
		public function resetta() {
			thumbPage = 0;
			this.visible = false;
			rimuovi(this.numChildren)
		}
		public function rimuovi(nn) {
			for (var a = 0; a<nn;a++) {
				this.removeChildAt(0);
				//this["puls"+a] = undefined
			}
		}
		public function avvia() {
			this.visible = true;
			this.pageDn = new FwRw();
			this.pageUp = new FwRw();
			this.pageDn.rotation = 180;
			this.pageDn.scaleX = this.pageDn.scaleY = this.pageUp.scaleX = this.pageUp.scaleY = 3
			pageDn.avvia({fnzOut:pager,alt:Preferences.pref.pageDn,param:-1});
			pageUp.avvia({fnzOut:pager,alt:Preferences.pref.pageUp,param:1});
			thumbDrawer();
		}
		function setPos() {
			w = Preferences.pref.w;
			h = Preferences.pref.h;
			thumbPage = 0;
			thumbDrawer();
		}
		function thumbDrawer() {
			rimuovi(this.numChildren);
			var obj = {};
			w = Preferences.pref.w
			h = Preferences.pref.h-Preferences.pref.testaH-Preferences.pref.piedeH;
			tw = Preferences.pref.tw
			th = Preferences.pref.th
			pageDn.x = 45;
			pageDn.y = int((h-33)/2)+33;
			pageUp.x = w-45;
			pageUp.y = int((h-33)/2);

			//resetta()
			var contaX = 0;
			var contaY = 0;
			thumbNx = int(w/tw);
			thumbNy = int(h/th);
			var marginX = (w-(thumbNx*tw))/(thumbNx-1);
			var marginY = (h-(thumbNy*th))/(thumbNy-1);
			for (var a=0; a<thumbNx*thumbNy; a++) {
				if (parent.parent.home.childNodes[0].childNodes[a+thumbPage]) {
					var myX = (tw+marginX)*contaX;
					var myY = (th+marginY)*contaY;
					var tmp = parent.parent.home.childNodes[0].childNodes[a+thumbPage].childNodes[0].childNodes[0].toString();
					var tipo = tmp.substring(tmp.lastIndexOf(".")+1, tmp.length).toLowerCase();
					obj["puls"+a] = new ButtonSelector(myX, myY, myOnPress, a, tipo, parent.parent.home.childNodes[0].childNodes[a+thumbPage].childNodes[2].childNodes[0].toString(),(a+thumbPage+1)+"/"+parent.parent.home.childNodes[0].childNodes.length+" "+parent.parent.home.childNodes[0].childNodes[a+thumbPage].childNodes[1].childNodes[0].toString());
					this.addChild(obj["puls"+a]);
					contaX++;
					if (contaX == thumbNx) {
						contaX = 0;
						contaY++;
					}
					if (contaY == thumbNy+1) {
						contaY = 0;
					}
				}
			}
			if (thumbPage>0) {
				this.addChild(pageDn)
				pageDn.avvia({fnzOut:pager,alt:Preferences.pref.pageDn,param:-1});
			}/* else {
				this.removeChild(pageDn)
			}*/
			if (thumbPage+(thumbNx*thumbNy)<parent.parent.home.childNodes[0].childNodes.length) {
				this.addChild(pageUp)
				pageUp.avvia({fnzOut:pager,alt:Preferences.pref.pageUp,param:1});
			} /*else {
				this.removeChild(pageUp)
			}*/
			//this.pageDn.swapDepths(this.getNextHighestDepth());
			//this.pageUp.swapDepths(this.getNextHighestDepth());
			/**/
		}
		public function pager(a) {
			thumbPage += a*(thumbNx*thumbNy);
			thumbDrawer();
		}
		function myOnPress(a) {
			this.parent.myToolbar.avviaSP(a+thumbPage);
		}
	}
}
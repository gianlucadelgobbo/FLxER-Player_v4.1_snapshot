package FlxerGallery.core {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.external.ExternalInterface;
	
	import FlxerGallery.main.BitmapDataToBinaryPNG
	import FlxerGallery.main.ByteArrayUploader
	public class ThumbSaver extends Sprite {
		var w
		var h
		var c
		var bd:BitmapData;
		var bm:Bitmap;
		public var newT:Sprite;
		public var shot:Sprite;
		var ok:Sprite;
		var no:Sprite;
		// ThumbSaver param
		var trgt;
		var fileName;
		//
/*pagina da chiamare quando invii i dati
riceve solo lo stream che si chiama myfile
DEVI ESSERE LOGGATO SU ECODE
/ecode2/flxerPlayer/fpUp.php

restituisce 
esito=0&res=devi autenticarti& //se non sei loggato

&esito=0&res=tipo di file errato&  //se il file non è png

&esito=0&res=errore2& // se non riesce a fare l'upload

&esito=1&nfile=".$_FILES["myfile"]["name"]."&  //se va tutto ok*/
		public function ThumbSaver() {
			x = 0;
			y = Preferences.pref.testaH;
			//this.y = 0;
			w = Preferences.pref.w
			h = Preferences.pref.h-Preferences.pref.testaH-Preferences.pref.piedeH;
		}
		public function avvia() {
			bd = new BitmapData(w,h,false,0xFF00FF);
			bm = new Bitmap(bd);
			this.addChild(bm);
			bm.visible = false;
			
			newT = new Button();
			newT.avvia({fnzOut:newThumb,txt:"MAKE NEW THUMB",alt:Preferences.pref.makeShot});
			newT.scaleX = newT.scaleY = 2;
			newT.x = int(w-newT.width)-10
			newT.y = int(h)-35
			shot = new Button();
			shot.avvia({fnzOut:scattaThumb,txt:"MAKE THUMB",alt:Preferences.pref.makeShot});
			shot.scaleX = shot.scaleY = 2;
			shot.x = int(w-shot.width)-10
			shot.y = int(h)-35
			if (Preferences.pref.autostop) {
				this.addChild(newT);
			} else {
				this.addChild(shot);
			}
			ok = new Button();
			ok.avvia({fnz:saveThumb,txt:"SAVE THUMB",alt:Preferences.pref.saveShot});
			ok.scaleX = ok.scaleY = 2;
			no = new Button();
			no.avvia({fnzOut:cancelThumb,txt:"CANCEL",alt:Preferences.pref.delShot});
			no.scaleX = no.scaleY = 2;
			ok.x = int((w-ok.width-20-no.width)/2)
			ok.y = int(h/2)-10
			no.x = int(ok.width+ok.x+20)
			no.y = int(h/2)-10
		}
		function newThumb(t) {
			this.parent.myToolbar.myRemoveThumb2(null)
		}
		function rimuoviPuls(t) {
		}
		function scattaThumb(t) {
			bd.draw(this.parent.mySuperPlayer);
			this.bm.visible = true;
			this.addChild(ok);
			this.addChild(no);
			this.removeChild(shot);
		}
		function lampeggia() {
			ok.visible = !ok.visible;
			ok.disable();
		}
		function saveThumb(t) {
			no.disable();
			ok.disable();
			c = setInterval(lampeggia, 500);
			var ba = BitmapDataToBinaryPNG.getPNG(bd);
			var myUploader = new ByteArrayUploader();
			//
			var tmp = this.parent.mySuperPlayer.currMov;
			fileName = tmp.substring(tmp.lastIndexOf("/")+1, tmp.length-3)+"png";
			//
			myUploader.setParameters({_listener:this, _fileDataFieldName:"myfile", _fileName:fileName, _targetUrl:Preferences.pref.fpUpPath,_usePOST:true});
			myUploader.sendBinary(ba);
		}
		function cancelThumb(t) {
			this.removeChild(ok);
			this.removeChild(no);
			this.addChild(shot);
			this.bm.visible = false;
		}
		public function securityErrorHandler(obj) {
			trace("securityErrorHandler");
		}
		public function onByteArrayUploader_open(a,b) {
			trace("onByteArrayUploader_open");
		}
		public function onByteArrayUploader_progress(a,b) {
			trace("onByteArrayUploader_progress");
		}
		public function onByteArrayUploader_httpStatus(a,b) {
			trace("onByteArrayUploader_httpStatus");			
		}
		public function onByteArrayUploader_complete(a,b) {
			trace("onByteArrayUploader_complete");			
			clearInterval(c)
			ok.avvia({fnz:saveThumb,txt:"THUMBNAIL SAVED",alt:Preferences.pref.saveShot});
			ok.x = int(w-ok.width)/2
			ok.y = int(h/2)-10
			ok.visible = true;
			ok.disable();
			this.removeChild(no);
			if (ExternalInterface.available) {
				//trace("====================================="+Preferences.pref.fpUpJsOk);
				//ExternalInterface.call("alert", Preferences.pref.fpUpJsOk);
				//ExternalInterface.call("cazzo", Preferences.pref.fpUpJsOk);
				ExternalInterface.call(Preferences.pref.fpUpJsOk, Preferences.pref.id, Preferences.pref.id_file);
				//ExternalInterface.call("writeSnapshotOk", null);
			} else {
				navigateToURL(new URLRequest("javascript:"+Preferences.pref.fpUpJsOk+"()"),"_self");
			}
			//navigateToURL(new URLRequest(path),"_self");
		}
		public function onByteArrayUploader_allEvents(a,b) {			
			trace("onByteArrayUploader_allEvents");
		}
		public function onByteArrayUploader_failure() {
			//questo viene eseguito
			trace("onByteArrayUploader_failure");
		}
		public function onByteArrayUploader_ioError(a,b) {
			trace("onByteArrayUploader_ioError");
		}
		public function onByteArrayUploader_success() {
			trace("onByteArrayUploader_success\n");
		}
	}
}
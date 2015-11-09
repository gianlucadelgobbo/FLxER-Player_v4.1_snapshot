package {
	import flash.display.MovieClip;
	import flash.display.StageAlign;
    import flash.display.StageScaleMode;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.external.ExternalInterface;
	

	import FlxerGallery.core.FlxerGallery;
	import FlxerGallery.comp.Alt;
	
	public class StarterGalleryEmbed extends MovieClip {
		var myFlxerGallery;
		var myLoader
		public var home;
		public var myAlt;
		public function StarterGalleryEmbed(xx,yy,w,h,cnt) {
			x = xx;
			y = yy;
			Preferences.createPref(w,h)
			this.myFlxerGallery  = new FlxerGallery();
			this.addChild(myFlxerGallery)
			this.myAlt  = new Alt();
			this.addChild(myAlt);
			Preferences.pref.myAlt = myAlt;
			this.avviaJs(cnt);
		}
		public function resetta() {
			myFlxerGallery.mySuperPlayer.resetta()
		}
		public function avviaJs(cnt) {
			// TEST LOCALE
			if (!cnt) {
				// single
				cnt = "http://www.flxer.net/warehouse/_flxer/library/no_hole/test_motion_0.swf,test+motion";
				// multifoto
				cnt = "http://dev.gentecult.it/_fp/fpGallery.php?id=p140";
				// single foto
				cnt = "http://dev.flxer.net/_fp/fpGallery.php?id=p6143";
				// single flv
				cnt = "http://dev.flxer.net/warehouse/_videos/lpmenzimi.flv,test+motion";
				// single swf user
				cnt = "http://dev.flxer.net/warehouse/_flxer/library/no_hole/test_motion_0.swf,test+motion,1,15112,6509";
				// multifoto + video
				cnt = "http://dev.flxer.net/_fp/fpGallery.php?id=a78";
				// solo video
				cnt = "http://www.flxer.net/_fp/fpGallery.php?id=p5600";
				// mp3
				cnt = "http://dev.flxer.net/_fp/fpGallery.php?id=p220";
				// multifoto + video
				cnt = "http://dev.flxer.net/_fp/fpGallery.php?id=a1";
				// multifoto + video
				cnt = "http://dev.flxer.net/_fp/fpGallery.php?id=a78";
				// multi swf
				cnt = "http://www.flxer.net/_fp/fpGallery.php?id=m1";
				// solo video avm1
				cnt = "http://www.bjcem.org/_fp/fpGallery.aspx?cnt=5102";
				// solo video avm1
				cnt = "http://www.flxer.net/_fp/fpGallery.php?id=p6090";
				//
				cnt = "http://tasia.flyer.it/_fp/fpGallery.php?id=p-9-4";
				cnt = "http://tasia.flyer.it/_fp/fpGallery.php?id=p-9-1";
				cnt = "http://www.liveperformersmeeting.net/warehouse/lpmgallery/2007/PreviewPalazzo.xml";
				cnt = "http://tasia.ecode.it/warehouse/_videos/the_end_sunset.flv,make+your+snapshot";
				cnt = "http://livevisuals.flyer.it/_fp/fpGallery.php?id=av-280-13";
				// solo video avm2
				cnt = "http://www.flxer.net/_fp/fpGallery.php?id=p6640";
				cnt = "http://jenet.flyer.it/warehouse/_audio/il_pranzo__servito.mp3";
				cnt = "http://www.liveperformersmeeting.net/warehouse/lpmgallery/selecta.xml";
				cnt = "http://tasia.flyer.it/_fp/fpGallery.php?id=p-9-1";
			}
			Preferences.updatePref(cnt)
			//getURL("javascript:alert('"+cnt+"');")
			var tmp = cnt.split(",");
			var tmp2 = tmp[0].substring(tmp[0].length-3, tmp[0].length).toLowerCase();
			home = new XMLDocument();
			home.ignoreWhite = true;
			if (tmp2 == "flv" || tmp2 == "mp3" || tmp2 == "swf" || tmp2 == "jpg" || tmp2 == "png" || tmp2 == "gif") {
				if (tmp[2]) {
					xmlStr = "<root autostop=\"false\"><item page_url=\""+tmp[2]+"\"><file>"+tmp[0]+"</file><data><tit>"+tmp[1]+"</tit></data></item></root>";
					//home = new XMLDocument("<ul autostop=\"false\"><li page_url=\""+tmp[2]+"\"><a>"+tmp[0]+"</a><tit>"+tmp[1]+"</tit></li></ul>");
				} else {
					xmlStr = "<root autostop=\"false\"><item><file>"+tmp[0]+"</file><data><tit>"+tmp[1]+"</tit></data></item></root>";
					//home = new XMLDocument("<ul autostop=\"false\"><li><a>"+tmp[0]+"</a><tit>"+tmp[1]+"</tit></li></ul>");
				}
				home.parseXML(xmlStr);
				this.myFlxerGallery.avvia();
			} else {
				/*if (tmp.indexOf("http://") != -1) {
					_root.myPath = _root.mySitePath;
				}
				var tmp = myReplace(cnt, ",", "&");
				if (tmp.indexOf("http://") == -1) {
					tmp = _root.myPath+tmp;
				}*/
				myLoader = new URLLoader(new URLRequest(cnt));
				myLoader.addEventListener("complete", avviaMyFlxerGallery);
				myLoader.addEventListener("ioError", loadErr);
			}
		}
		// PREFERENZE
		function loadErr(event) {
			if (ExternalInterface.available) {
				ExternalInterface.call("alert", "Error loading content.");
			} else {
				navigateToURL(new URLRequest("javascript:alert('Error loading content.')"));
			}
		}
		function avviaMyFlxerGallery(event) {
			home.parseXML(myLoader.data);
			if (event.type == "complete") {
				for (var a = 0; a<home.childNodes[0].childNodes.length; a++) {
					home.childNodes[0].childNodes[a].childNodes[0].childNodes[0].nodeValue = Preferences.pref.myPath+home.childNodes[0].childNodes[a].childNodes[0].childNodes[0].toString();
					home.childNodes[0].childNodes[a].childNodes[2].childNodes[0].nodeValue = Preferences.pref.myPath+home.childNodes[0].childNodes[a].childNodes[2].childNodes[0].toString();
				}
				for (var item in home.childNodes[0].attributes) {
					val = home.childNodes[0].attributes[item]
					if (val == parseFloat(val).toString()) {
						val = parseFloat(val);
					} else if (val == "true") {
						val = true;
					} if (val == "false") {
						val = false;
					}
					Preferences.pref[item] = val;
					trace("NEW "+item+" "+Preferences.pref[item])
				}
				this.myFlxerGallery.avvia();
			} else {
				trace("xmlLoadError");
			}
		}
		public static function myReplace(str, search, replace) {
			var temparray = str.split(search);
			str = temparray.join(replace);
			return str;
		}
	}
}
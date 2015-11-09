package FlxerGallery.core {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.utils.*;
   	import flash.events.*;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Shape;

	import FlxerGallery.main.DrawerFunc;
	import FLxER.core.Player;

	public class FlxerPlayer extends Sprite {
		var ssInt;
		public var myloaded:Boolean;
		public var h;
		//
		var fondo;
		var myPlayer;
		var myMask;
		public var currMov;
		public function FlxerPlayer() {
			this.y = Preferences.pref.testaH;
			//this.y = 0;
			h = Preferences.pref.h-Preferences.pref.testaH-Preferences.pref.piedeH;
			w = Preferences.pref.w
			trace("Larghezza Schermo: "+w);
			trace("Altezza Schermo: "+h);
			if (Preferences.pref.playerBackgroundColor) {
				fondo = new Sprite();
				DrawerFunc.drawer(fondo,0,0,w,h,Preferences.pref.playerBackgroundColor,null,1);
			} else {
				fondo = new Shape();
				textureDrawer(fondo, w, h);
			}
			this.addChild(fondo);
			this.myPlayer = new Player(1,w,h);
			this.myMask = new Sprite();
			DrawerFunc.drawer(myMask,-int(w/2),-int(h/2),w,h,0x000000,null,1);
			this.myPlayer.x = this.myMask.x = int(w/2);
			this.myPlayer.y = this.myMask.y = int(h/2);
			this.addChild(myPlayer);
			this.addChild(myMask);
			this.myPlayer.mask = myMask;
			//}
			play_status = false;
		}
		public function avvia(i) {
			this.parent.myToolbar.disable();
			this.parent.myToolbar.avvia("player");
			resetta();
			this.visible = true;
			index = i;
			firstTime = true;
			firstTime2 = true;
			var tmp = parent.parent.home.childNodes[0].childNodes[index].childNodes[0].childNodes[0].toString();
			Preferences.pref.tipo = tmp.substring(tmp.lastIndexOf(".")+1, tmp.length).toLowerCase();
			this["avvia_"+Preferences.pref.tipo](index);
		}
		function resetta() {
			//this.parent.myToolbar.resetta();
			mbuto(getTimer()+",eject,0");
			myloaded = mcLoaded=swf_started=play_status=false;
			l = 0;
			n = 0;
			clearInterval(this.ssInt);
			this.visible = false;
		}
		public function mbuto(azione) {
			trace("MMmbuto"+azione);
			var myAction = azione.split(",");
			this.myPlayer[myAction[1]](myAction);
		}
		/* SWF /////////////////*/
		function avvia_swf(index) {
			if (parent.parent.home.childNodes[0].childNodes[index].attributes.page_url) {
				if (parent.parent.home.childNodes[0].childNodes[index].attributes.page_url.length>0) {
					Preferences.pref.page_url = parent.parent.home.childNodes[0].childNodes[index].attributes.page_url;
					parent.myToolbar.fondo.addEventListener(MouseEvent.MOUSE_DOWN, vaiUserURL);
					parent.myToolbar.fondo.buttonMode=true;
				}
			}
			var tmp = parent.parent.home.childNodes[0].childNodes[index].childNodes[0].childNodes[0].toString();
			if (tmp.lastIndexOf("cnt=") != -1) {
				tmp = tmp.substring(tmp.lastIndexOf("cnt=")+4, tmp.length);
			}
			load_jpg_swf(tmp);
			this.parent.myToolbar.tit = parent.parent.home.childNodes[0].childNodes[index].childNodes[1].childNodes[0].toString();
			this.parent.myToolbar.lab_i.htmlText = this.parent.myToolbar.tit;
		}
		/* MP3 /////////////////*/
		function avvia_mp3(index) {
			if (parent.parent.home.childNodes[0].childNodes[index].attributes.page_url) {
				if (parent.parent.home.childNodes[0].childNodes[index].attributes.page_url.length>0) {
					Preferences.pref.page_url = parent.parent.home.childNodes[0].childNodes[index].attributes.page_url;
					parent.myToolbar.fondo.addEventListener(MouseEvent.MOUSE_DOWN, vaiUserURL);
					parent.myToolbar.fondo.buttonMode=true;
				}
			}
			currMov = parent.parent.home.childNodes[0].childNodes[index].childNodes[0].childNodes[0].toString();
			mbuto(getTimer()+",load_mp3,0,"+currMov+","+Preferences.pref.tipo+","+parent.myToolbar.piede.contr.volume_ctrl.getVal());
			this.parent.myToolbar.tit = parent.parent.home.childNodes[0].childNodes[index].childNodes[1].childNodes[0].toString();
			this.parent.myToolbar.lab_i.htmlText = this.parent.myToolbar.tit;
		}
		function initHandlerMP3(e) {
			myPlayer.myStopStatus = false;
			this.parent.myToolbar.piede.contr.playpause.simb.gotoAndStop(2);
			this.parent.myToolbar.enable()
			this.parent.myToolbar.avvia_indice();
		}
		/* FLV /////////////////*/
		public function avvia_flv(index) {
			if (parent.parent.home.childNodes[0].childNodes[index].attributes.page_url) {
				if (parent.parent.home.childNodes[0].childNodes[index].attributes.page_url.length>0) {
					Preferences.pref.page_url = parent.parent.home.childNodes[0].childNodes[index].attributes.page_url;
					parent.myToolbar.fondo.addEventListener(MouseEvent.MOUSE_DOWN, vaiUserURL);
					parent.myToolbar.fondo.buttonMode=true;
				}
			}
			this.parent.myToolbar.tit = parent.parent.home.childNodes[0].childNodes[index].childNodes[1].childNodes[0].toString();
			this.parent.myToolbar.lab_i.htmlText = this.parent.myToolbar.tit+": Buffering...";
			var tmp = parent.parent.home.childNodes[0].childNodes[index].childNodes[0].childNodes[0].toString();
			if (tmp.lastIndexOf("cnt=") != -1) {
				tmp = tmp.substring(tmp.lastIndexOf("cnt=")+4, tmp.length);
			}
			//this.parent.myToolbar.bottoni(false);     
			currMov = tmp;
			//this.parent.myToolbar.disable()
			mbuto(getTimer()+",load_flv,0,"+currMov+","+parent.myToolbar.piede.contr.volume_ctrl.getVal());
		}
		public function initHandlerFLV(event) {
			switch (event.info.code) {
				case "NetStream.Buffer.Full" :
					if (firstTime2) {
						firstTime2 = false;
						this.parent.myToolbar.lab_i.htmlText = this.parent.myToolbar.tit;
					}
					break;
				case "NetStream.Play.Start" :
					if (firstTime) {
						this.parent.myToolbar.enable()
						this.parent.myToolbar.avvia_indice();
						resizza();
						firstTime = false;
						myPlayer.myStopStatus = false;
						this.parent.myToolbar.piede.contr.playpause.simb.gotoAndStop(2);
						//nsclosed = false;
					}
					resizza();
					break;
				case "NetStream.Play.Stop" :
					if (Preferences.pref.myLoop) {
						myPlayer.NS.seek(0);
					} else {
						if (parent.parent.home.childNodes[0].childNodes.length>1) {
							this.parent.myToolbar.avvia("selector");
						} else {
							myPlayer.NS.seek(0);
							this.parent.myToolbar.myPlaypause(null);
						}
					}
					break;
				case "NetStream.Play.StreamNotFound" :
					/*if (nLoadErr<1 && FlxerStarter.myPrefSO.data.flxerPref.childNodes[0].childNodes[1].attributes.use == "true") {
						nLoadErr++;
						this.clipPath = FlxerStarter.myPrefSO.data.flxerPref.childNodes[0].childNodes[1].attributes.value+this.clip;
						this.play(this.clipPath);
						if (parent != _level0.monitor.mon) {
							parent.parent.parent.myMovie.val.text = "SEARCHING ON THE NET";
							parent.parent.parent.myMovie.val.textColor = 0xFF0000;
						}
					} else if (parent != _level0.monitor.mon) {
						parent.parent.parent.myMovie.val.text = "FILE NOT FOUND";
						parent.parent.parent.myMovie.val.textColor = 0xFF0000;
					}*/
					break;
			}
		}
		/* IMMAGINI /////////////////*/
		function avvia_jpg(index) {
			listaSS = [];
			generaListaSS();
			for (var a = 0; a<listaSS.length; a++) {
				if (parent.parent.home.childNodes[0].childNodes[index].childNodes[0].childNodes[0].toString() == parent.parent.home.childNodes[0].childNodes[listaSS[a]].childNodes[0].childNodes[0].toString()) {
					index = a;
				}
			}
			if (index != undefined || index == 0) {
				this.parent.myToolbar.piede.contr.playpause.simb.gotoAndStop(2);
				n = index;
				play_status = true;
			} else {
				this.parent.myToolbar.mRoot.customItems[0].enabled = true;
				play_status = false;
			}
			//this.parent.myToolbar.piede.indice.curs.puls.enabled = false;
			load_foto();
		}
		function generaListaSS() {
			for (var a = 0; a<parent.parent.home.childNodes[0].childNodes.length; a++) {
				var tmp = parent.parent.home.childNodes[0].childNodes[a].childNodes[0].childNodes[0].toString();
				tmp = tmp.substring(tmp.length-3, tmp.length);
				if (tmp == "jpg") {
					listaSS.push(a);
				}
			}
		}
		function load_prev_foto() {
			if (n>1) {
				n-=2;
			} else if (n == 0) {
				n = listaSS.length-2;
			} else {
				n = listaSS.length-1;
			}
			load_foto()
		}
		public function load_foto() {
			////this.parent.myToolbar.disable()
			clearInterval(this.ssInt);
			/*
			this.myPlayer.createEmptyMovieClip("foto_"+l,this.myPlayer.getNextHighestDepth());
			this.myPlayer["foto_"+l].alpha = 0;
			if (Preferences.pref.playerBackgroundColorFoto != undefined) {
				DrawerFunc.drawer(this.myPlayer["foto_"+l],"fondo",0,0,w,h,Preferences.pref.playerBackgroundColorFoto,null,100);
			}
			*/
			if (parent.parent.home.childNodes[0].childNodes[listaSS[n]].attributes.page_url) {
				if (parent.parent.home.childNodes[0].childNodes[listaSS[n]].attributes.page_url.length>0) {
					Preferences.pref.page_url = parent.parent.home.childNodes[0].childNodes[listaSS[n]].attributes.page_url;
					parent.myToolbar.fondo.addEventListener(MouseEvent.MOUSE_DOWN, vaiUserURL);
					parent.myToolbar.fondo.buttonMode=true;
				}
			}
			var tmp = parent.parent.home.childNodes[0].childNodes[listaSS[n]].childNodes[0].childNodes[0].toString();
			if (tmp.lastIndexOf("cnt=") != -1) {
				tmp = tmp.substring(tmp.lastIndexOf("cnt=")+4, tmp.length);
			}
			currMov = tmp;
			//load_jpg_swf(tmp,this.myPlayer["foto_"+l]);
			load_jpg_swf(tmp);
			if (parent.parent.home.childNodes[0].childNodes.length>1) {
				this.parent.myToolbar.tit = (n+1)+" / "+listaSS.length+" - "+parent.parent.home.childNodes[0].childNodes[listaSS[n]].childNodes[1].childNodes[0].toString();
				//this.parent.myToolbar.tit = parent.parent.home.childNodes[listaSS[n]].childNodes[1].childNodes[0].toString();
				this.parent.myToolbar.piede.indice.counter.htmlText = (n+1)+" / "+listaSS.length;
				this.parent.myToolbar.piede.indice.curs.x = (((this.parent.myToolbar.barr_width)/(listaSS.length-1))*n);
				l++;
			} else {
				this.parent.myToolbar.piede.indice.counter.htmlText = (n+1)+" / "+listaSS.length;
				this.parent.myToolbar.tit = parent.parent.home.childNodes[0].childNodes[listaSS[n]].childNodes[1].childNodes[0].toString();
			}
			this.parent.myToolbar.lab_i.htmlText = this.parent.myToolbar.tit;
		}
		function load_jpg_swf(mov) {
			//trgt.mcl = new main.mcLoader(mov, trgt, this, "MovieClipLoader_succes", "MovieClipLoader_progress");
			currMov = mov;
			mbuto(getTimer()+",load_movie,0,"+currMov+","+Preferences.pref.tipo+","+parent.myToolbar.piede.contr.volume_ctrl.getVal());
		}
		function loadNext() {
			if (Preferences.pref.tipo == "jpg" && listaSS.length>0 && !this.parent.mySuperPlayer.myPlayer.myStopStatus) {
				load_foto();
			}
		}
		function avviaSelector() {
			clearInterval(this.ssInt);
			this.parent.myToolbar.avviaSelector(null);
		}
		public function initHandlerSWF(trgt) {
			clearInterval(this.ssInt);
			if (Preferences.pref.tipo == "jpg" && listaSS.length>1) {
				if (n>listaSS.length-2) {
					if (Preferences.pref.myLoop) {
						n = 0;
						this.ssInt = setInterval(loadNext, Preferences.pref.ss_time);
					} else {
						this.ssInt = setInterval(avviaSelector, Preferences.pref.ss_time);
					}
				} else {
					n++;
					this.ssInt = setInterval(loadNext, Preferences.pref.ss_time);
				}
				this.parent.myToolbar.enable()
			} else {
				myPlayer.myStopStatus = false;
				if(trgt is flash.display.MovieClip) {
					this.parent.myToolbar.piede.contr.playpause.simb.gotoAndStop(2);
					this.parent.myToolbar.enable()
					this.parent.myToolbar.piede.contr.volume_ctrl.disable();
					this.parent.myToolbar.avvia_indice();
				}
			}
			resizza();
		}
		function setPos() {
			h = Preferences.pref.h-Preferences.pref.testaH-Preferences.pref.piedeH;
			w = Preferences.pref.w;
			if (Preferences.pref.playerBackgroundColor) {
				fondo.width = myMask.width = w;
				fondo.height = myMask.height = h;
			} else {
				textureDrawer(fondo, w, h);
				myMask.width = w;
				myMask.height = h;
			}
			myPlayer.x = myMask.x = int(w/2);
			myPlayer.y = myMask.y = int(h/2);
			resizza();
		}
		function resizza() {
			if (myPlayer.oldTipo) {
				h = Preferences.pref.h-Preferences.pref.testaH-Preferences.pref.piedeH;
				w = Preferences.pref.w
				var tmpTrgt;
				var item;
				if (myPlayer.oldTipo == "flv") {
					tmpTrgt = this.myPlayer.myVideo;
				} else {
					tmpTrgt = this.myPlayer.swfTrgt;
				}
				//
				if (Preferences.pref.resizza_onoff) {
					if (myPlayer.oldTipo == "flv") {
						if ((tmpTrgt.videoWidth/tmpTrgt.videoHeight)>(w/h)) {
							tmpTrgt.width = w
							tmpTrgt.scaleY = tmpTrgt.scaleX;
						} else {
							tmpTrgt.height = h
							tmpTrgt.scaleX = tmpTrgt.scaleY;
						}
					} else if (myPlayer.oldTipo == "jpg") {
						if ((tmpTrgt.width/tmpTrgt.height)>(w/h)) {
							tmpTrgt.width = w
							tmpTrgt.scaleY = tmpTrgt.scaleX;
						} else {
							tmpTrgt.height = h
							tmpTrgt.scaleX = tmpTrgt.scaleY;
						}
					} else if (myPlayer.oldTipo == "swf") {
						tmpTrgt = this.myPlayer.swfTrgt;
						tmpTrgt.scaleX = w/Preferences.pref.swfW;
						tmpTrgt.scaleY = h/Preferences.pref.swfH;
						if ((Preferences.pref.swfW/Preferences.pref.swfH)>(w/h)) {
							tmpTrgt.scaleX = tmpTrgt.scaleY=(w/Preferences.pref.swfW);
						} else {
							tmpTrgt.scaleY = tmpTrgt.scaleX=(h/Preferences.pref.swfH);
						}
					}
				} else {
					if (myPlayer.oldTipo == "flv") {
						tmpTrgt = this.myPlayer.myVideo;
						tmpTrgt.width = tmpTrgt.videoWidth;
						tmpTrgt.height = tmpTrgt.videoHeight;
					} else if (myPlayer.oldTipo == "jpg" || myPlayer.oldTipo == "swf") {
						this.myPlayer.swfTrgt.scaleY = this.myPlayer.swfTrgt.scaleX = 1;
					}
				}
				if (Preferences.pref.centra_onoff) {
					if (myPlayer.oldTipo == "swf") {
						tmpTrgt.x = -(Preferences.pref.swfW*tmpTrgt.scaleX)/2;
						tmpTrgt.y = -(Preferences.pref.swfH*tmpTrgt.scaleY)/2;
					} else {
						tmpTrgt.x = -tmpTrgt.width/2;
						tmpTrgt.y = -tmpTrgt.height/2;
					}
				} else {
					tmpTrgt.x = -w/2;
					tmpTrgt.y = -h/2;
				}
				tmpTrgt.visible = true;
			}
		}
		public function vaiUserURL(t) {
			navigateToURL(new URLRequest(Preferences.pref.page_url),"_self")
		}
		function textureDrawer(t, w, h) {
			t.graphics.clear();
			t.graphics.beginBitmapFill(new texture(w,h));
			t.graphics.drawRect(0,0,w,h);
		}
	}
}
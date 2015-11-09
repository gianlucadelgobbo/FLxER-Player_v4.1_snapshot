package FlxerGallery.core {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.utils.*;
   	import flash.events.*;
	import flash.net.*;
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
		var index
		var swf_status
		public var currMov;
		public function FlxerPlayer() {
			this.y = Preferences.pref.testaH;
			//this.y = 0;
			h = Preferences.pref.h-Preferences.pref.testaH-Preferences.pref.piedeH;
			w = Preferences.pref.w
			trace("Larghezza Schermo: "+w);
			trace("Altezza Schermo: "+h);
			if (Preferences.pref.playerBackground != null) {
				fondo = new Sprite();
				DrawerFunc.drawer(fondo,0,0,w,h,Preferences.pref.playerBackground,null,1);
			} else {
				fondo = new Shape();
				DrawerFunc.textureDrawer(fondo, w, h);
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
		}
		public function avviaCommon(i) {
			this.parent.myToolbar.avvia("player");
			resetta();
			this.visible = true;
			index = i;
			firstTime = true;
			firstTime2 = true;
			this.parent.myToolbar.disable();
		}
		public function avvia(i) {
			var tmp = parent.parent.home.childNodes[0].childNodes[i].childNodes[0].childNodes[0].toString();
			Preferences.pref.tipo = tmp.substring(tmp.lastIndexOf(".")+1, tmp.length).toLowerCase();
			if (Preferences.pref.tipo == "png" || Preferences.pref.tipo == "gif") {
				Preferences.pref.tipo = "jpg";
				this.parent.myToolbar.piede.counter.lab.htmlText = "00 / 00";
			} else {
				this.parent.myToolbar.piede.counter.lab.htmlText = "00:00 / 00:00";
			}
			this.parent.myToolbar.setPos();
			avviaCommon(i);
			this["avvia_"+Preferences.pref.tipo](index);
		}
		public function avviaSS(i) {
			Preferences.pref.tipo = "jpg";
			avviaCommon(i);
			avvia_jpg(index);
		}
		public function resetta() {
			//this.parent.myToolbar.resetta();
			mbuto(getTimer()+",eject,0");
			//myloaded = mcLoaded=swf_started=false;
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
			swf_status = false;
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
			load_swf(tmp);
			//this.parent.myToolbar.tit = parent.parent.home.childNodes[0].childNodes[index].childNodes[1].childNodes[0].toString();
			this.parent.myToolbar.tit = parent.parent.home.childNodes[0].childNodes[index].childNodes[1].childNodes[0].childNodes[0].toString();
			this.parent.myToolbar.lab_i.htmlText = this.parent.myToolbar.tit;
		}
		/* TXT /////////////////*/
		function avvia_txt(index) {
			if (parent.parent.home.childNodes[0].childNodes[index].attributes.page_url) {
				if (parent.parent.home.childNodes[0].childNodes[index].attributes.page_url.length>0) {
					Preferences.pref.page_url = parent.parent.home.childNodes[0].childNodes[index].attributes.page_url;
					parent.myToolbar.fondo.addEventListener(MouseEvent.MOUSE_DOWN, vaiUserURL);
					parent.myToolbar.fondo.buttonMode=true;
				}
			}
			Preferences.pref.txtFile = parent.parent.home.childNodes[0].childNodes[index].childNodes[0].childNodes[0].toString();
			load_swf(Preferences.pref.myPath+"/_fp/reader.swf");
			currMov = Preferences.pref.txtFile;
			//this.parent.myToolbar.tit = parent.parent.home.childNodes[0].childNodes[index].childNodes[1].childNodes[0].toString();
			this.parent.myToolbar.tit = parent.parent.home.childNodes[0].childNodes[index].childNodes[1].childNodes[0].childNodes[0].toString();
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
			var currThumb = parent.parent.home.childNodes[0].childNodes[index].childNodes[2].childNodes[0].toString();
			trace("currThumbcurrThumb "+currThumb);
			mbuto(getTimer()+",load_mp3,0,"+currMov+","+Preferences.pref.tipo+","+parent.myToolbar.piede.contr.volume_ctrl.getVal()+","+currThumb);
			//this.parent.myToolbar.tit = parent.parent.home.childNodes[0].childNodes[index].childNodes[1].childNodes[0].toString();
			this.parent.myToolbar.tit = parent.parent.home.childNodes[0].childNodes[index].childNodes[1].childNodes[0].childNodes[0].toString();
			this.parent.myToolbar.lab_i.htmlText = this.parent.myToolbar.tit;
		}
		public function initHandlerMP3(e) {
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
			//this.parent.myToolbar.tit = parent.parent.home.childNodes[0].childNodes[index].childNodes[1].childNodes[0].toString();
			this.parent.myToolbar.tit = parent.parent.home.childNodes[0].childNodes[index].childNodes[1].childNodes[0].childNodes[0].toString();
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
			} else {
				this.parent.myToolbar.mRoot.customItems[0].enabled = true;
			}
			//this.parent.myToolbar.piede.indice.curs.puls.enabled = false;
			load_foto();
		}
		function generaListaSS() {
			for (var a = 0; a<parent.parent.home.childNodes[0].childNodes.length; a++) {
				var tmp = parent.parent.home.childNodes[0].childNodes[a].childNodes[0].childNodes[0].toString();
				tmp = tmp.substring(tmp.length-3, tmp.length);
				if (tmp == "jpg" || tmp == "png" || tmp == "gif") {
					listaSS.push(a);
				}
			}
		}
		public function load_prev_foto() {
			if (n>1) {
				n-=2;
			} else if (n == 0) {
				n = listaSS.length-2;
			} else {
				n = listaSS.length-1;
			}
			load_foto()
		}
		function loadNext() {
			if (Preferences.pref.tipo == "jpg" && listaSS.length>0 && !this.parent.mySuperPlayer.myPlayer.myStopStatus) {
				load_foto();
			}
		}
		public function load_foto() {
			this.parent.myToolbar.disable()
			clearInterval(this.ssInt);
			/*
			this.myPlayer.createEmptyMovieClip("foto_"+l,this.myPlayer.getNextHighestDepth());
			this.myPlayer["foto_"+l].alpha = 0;
			if (Preferences.pref.playerBackground != undefined) {
				DrawerFunc.drawer(this.myPlayer["foto_"+l],"fondo",0,0,w,h,Preferences.pref.playerBackground,null,100);
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
			//load_swf(tmp,this.myPlayer["foto_"+l]);
			mbuto(getTimer()+",load_img,0,"+currMov+","+Preferences.pref.tipo+","+parent.myToolbar.piede.contr.volume_ctrl.getVal());
			if (parent.parent.home.childNodes[0].childNodes.length>1) {
				//this.parent.myToolbar.tit = (n+1)+" / "+listaSS.length+" - "+parent.parent.home.childNodes[0].childNodes[listaSS[n]].childNodes[1].childNodes[0].toString();
				trace("currMov "+parent.parent.home.childNodes[0].childNodes[listaSS[n]])
				this.parent.myToolbar.tit = (n+1)+" / "+listaSS.length+" - "+parent.parent.home.childNodes[0].childNodes[listaSS[n]].childNodes[1].childNodes[0].childNodes[0].toString();
				//this.parent.myToolbar.tit = parent.parent.home.childNodes[listaSS[n]].childNodes[1].childNodes[0].toString();
				trace("currMov "+this.parent.myToolbar.piede.indice)
				this.parent.myToolbar.piede.counter.lab.htmlText = (n+1)+" / "+listaSS.length;
				this.parent.myToolbar.piede.indice.curs.x = (((this.parent.myToolbar.barr_width)/(listaSS.length-1))*n);
				l++;
			} else {
				this.parent.myToolbar.piede.counter.lab.htmlText = (n+1)+" / "+listaSS.length;
				//this.parent.myToolbar.tit = parent.parent.home.childNodes[0].childNodes[listaSS[n]].childNodes[1].childNodes[0].childNodes[0].toString();
				this.parent.myToolbar.tit = parent.parent.home.childNodes[0].childNodes[listaSS[n]].childNodes[1].childNodes[0].childNodes[0].toString();
				//this.parent.myToolbar.tit = parent.parent.home.childNodes[0].childNodes[listaSS[n]].childNodes[1].childNodes[0].toString();
			}
			this.parent.myToolbar.lab_i.htmlText = this.parent.myToolbar.tit;
		}
		public function initHandlerJPG(trgt) {
			clearInterval(this.ssInt);
			if (listaSS.length>1) {
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
				//this.parent.myToolbar.piede.indice.curs.disable()
			}
		}
		function load_swf(mov) {
			//trgt.mcl = new main.mcLoader(mov, trgt, this, "MovieClipLoader_succes", "MovieClipLoader_progress");
			currMov = mov;
			mbuto(getTimer()+",load_movie,0,"+currMov+","+Preferences.pref.tipo+","+parent.myToolbar.piede.contr.volume_ctrl.getVal());
		}
		function avviaSelector() {
			clearInterval(this.ssInt);
			this.parent.myToolbar.avviaSelector(null);
		}
		public function initHandlerSWF(trgt) {
			if (Preferences.pref.tipo == "txt") {
				trgt.avvia(Preferences.pref.txtFile)
			}
			swf_status = true;
			myPlayer.myStopStatus = false;
			if(trgt is flash.display.MovieClip) {
				this.parent.myToolbar.piede.contr.playpause.simb.gotoAndStop(2);
				this.parent.myToolbar.enable()
				this.parent.myToolbar.piede.contr.volume_ctrl.disable();
				this.parent.myToolbar.avvia_indice();
			}
			resizza();
		}
		function setPos() {
			h = Preferences.pref.h-Preferences.pref.testaH-Preferences.pref.piedeH;
			w = Preferences.pref.w;
			if (Preferences.pref.playerBackground) {
				fondo.width = myMask.width = w;
				fondo.height = myMask.height = h;
			} else {
				DrawerFunc.textureDrawer(fondo, w, h);
				myMask.width = w;
				myMask.height = h;
			}
			myPlayer.x = myMask.x = int(w/2);
			myPlayer.y = myMask.y = int(h/2);
			resizza();
		}
		public function resizza() {
			trace("resizza"+myPlayer.oldTipo)
			if (myPlayer.oldTipo) {
				h = Preferences.pref.h-Preferences.pref.testaH-Preferences.pref.piedeH;
				w = Preferences.pref.w
				var tmpTrgt;
				var item;
				if (myPlayer.oldTipo == "flv") {
					tmpTrgt = this.myPlayer.myVideo;
				} else if (myPlayer.oldTipo == "jpg") {
					tmpTrgt = this.myPlayer.imgToShow;
				} else if (myPlayer.oldTipo == "swf" || myPlayer.oldTipo == "txt") {
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
					} else if (myPlayer.oldTipo == "swf" || myPlayer.oldTipo == "txt") {
						if (swf_status) {
							trace("bella")
							trace(tmpTrgt.scaleX)
							tmpTrgt.scaleX = w/Preferences.pref.swfW;
							tmpTrgt.scaleY = h/Preferences.pref.swfH;
							if ((Preferences.pref.swfW/Preferences.pref.swfH)>(w/h)) {
								tmpTrgt.scaleX = tmpTrgt.scaleY=(w/Preferences.pref.swfW);
							} else {
								tmpTrgt.scaleY = tmpTrgt.scaleX=(h/Preferences.pref.swfH);
							}
						}
					}
				} else {
					if (myPlayer.oldTipo == "flv") {
						tmpTrgt = this.myPlayer.myVideo;
						tmpTrgt.width = tmpTrgt.videoWidth;
						tmpTrgt.height = tmpTrgt.videoHeight;
					} else if (myPlayer.oldTipo == "jpg" || myPlayer.oldTipo == "swf" || myPlayer.oldTipo == "txt") {
						this.myPlayer.swfTrgt.scaleY = this.myPlayer.swfTrgt.scaleX = 1;
					}
				}
				if (Preferences.pref.centra_onoff) {
					if (myPlayer.oldTipo == "swf" || myPlayer.oldTipo == "txt") {
						if (swf_status) {
							tmpTrgt.x = -(Preferences.pref.swfW*tmpTrgt.scaleX)/2;
							tmpTrgt.y = -(Preferences.pref.swfH*tmpTrgt.scaleY)/2;
							tmpTrgt.visible = true;
						}
					} else if (myPlayer.oldTipo == "jpg" || myPlayer.oldTipo == "flv") {
						tmpTrgt.x = -tmpTrgt.width/2;
						tmpTrgt.y = -tmpTrgt.height/2;
						tmpTrgt.visible = true;
					}
				} else if (myPlayer.oldTipo == "jpg" || myPlayer.oldTipo == "flv" || myPlayer.oldTipo == "swf" || myPlayer.oldTipo == "txt") {
					tmpTrgt.x = -w/2;
					tmpTrgt.y = -h/2;
					tmpTrgt.visible = true;
				}
			}
		}
		public function vaiUserURL(t) {
			navigateToURL(new URLRequest(Preferences.pref.page_url),"_self")
		}
	}
}
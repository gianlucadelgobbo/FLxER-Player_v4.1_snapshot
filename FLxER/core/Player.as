package FLxER.core {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.media.Video;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	import flash.events.*;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.display.AVM1Movie;
	import flash.net.LocalConnection;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	//import flash.net.ObjectEncoding;
	//import FLxER.comp.ButtonRett;

	//import flash.events.NetStatusEvent;
	//import flash.utils.*;
	public class Player extends Sprite {
		var ch;
		var w;
		var h;
		//var c
		//
		var mySo;
		public var oldTipo:String;
		public var myVideo;
		var fondo;
		var swfLoader;
		var NC:NetConnection;
		var LC:LocalConnection;
		public var NS:NetStream;
		var swfSound:SoundMixer;
		var flvSound:SoundMixer;
		public var mp3Sound:Sound;
		var transformSound:SoundTransform;
		public var swfTrgt;
		var loadSwfAction;
		public var myDuration:Number;
		/*var CF:Color;
		var CM:Color;
		var CFT:Object;
		var CMT:Object;
		var txtKS:TextFormat;
		var my_mcl:MovieClipLoader;
		var my_wipesl:MovieClipLoader;
		var ch:Number;
		var my_mclL:Object;
		var my_wipeslL:Object;
		var owner:Object;*/
		public var myStopStatus:Boolean;
		public var song:SoundChannel;
		var avm1customloader;
		public var sliderVal;
		public var imgToShow, imgToRemove, imgLoader0, imgLoader1, myTweenA, myTweenS;
		public function Player(a, ww, hh) {
			ch = a;
			w = ww;
			h = hh;
			myStopStatus = false;
			this.fondo = new Sprite();
            fondo.graphics.beginFill(0xFF00FF);
            fondo.graphics.drawRect(0, 0, w, h);
            fondo.graphics.endFill();
            //addChild(fondo);

			this.myVideo = new Video();
			this.myVideo.smoothing = true;
			this.NC = new NetConnection();
			NC.addEventListener(NetStatusEvent.NET_STATUS, NCHandler);
			NC.connect(null);
			avm1customloader = false; /* SERVE PER NON CARICARE IL CONTENITORE AVM1 */
			if (avm1customloader) {
				LC = new LocalConnection();
				LC.allowDomain("*");
				LC.addEventListener(StatusEvent.STATUS, onStatus);
				LC.client = this;
	
				LCreceive = new LocalConnection();
				LCreceive.allowDomain("*");
				LCreceive.addEventListener(StatusEvent.STATUS, onStatus);
				LCreceive.client = this;
				LCreceive.connect("lcreceive");
			}

			this.swfLoader = new Loader();
			swfLoader.contentLoaderInfo.addEventListener(Event.INIT, initHandler);
            swfLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
            swfLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);

			fondo.x = this.myVideo.x = swfLoader.x = -w/2;
			fondo.y = this.myVideo.y = swfLoader.y = -h/2;/**/
			
			this.swfSound = new SoundMixer();
			/*swfChannel = swfSound.play();
			transformSound = swfChannel.soundTransform;
            transformSound.volume = 0;
            swfChannel.soundTransform = transformSound;*/
			transformSound = new SoundTransform();
			
			this.flvSound = new SoundMixer();
			
			this.mp3Sound = new Sound();
			mp3Sound.addEventListener(Event.COMPLETE, soundCompleteHandler);
			mp3Sound.addEventListener(flash.events.ProgressEvent.PROGRESS, soundProgressHandler);

			
			//
			
			/*this.txtKS = new TextFormat();
			this.txtKS.font = "myFont2";
			this.txtKS.size = 48;
			this.txtKS.color = 0x000000;
			this.txtKS.align = "center";
			_root.mdf.tdw(vid, "txt", -600, -41, 1200, 100, "");
			vid.txt.setTextFormat(this.txtKS);
			vid.txt.setNewTextFormat(this.txtKS);

			this.CM = new Color(vid);
			this.CMT = new Object();
			this.CMT.rb = 0;
			this.CMT.gb = 0;
			this.CMT.bb = 0;
			this.CM.setTransform(this.CMT);
			this.CF = new Color(this["cnt"].fondo);
			this.CFT = new Object();
			this.CFT.rb = 0;
			this.CFT.gb = 0;
			this.CFT.bb = 0;
			this.CF.setTransform(this.CFT);
			//////
			this["effects"].visible = false;
			this["effects"].channel = this;
			this["effects"].ch = ch;
			this["effects"].video = vid;
			this["effects"]["mask"] = this["mask"];
			this["effects"].channelPreview = _root.myCtrl[this.name].monitor.mon.ch_0;
			this["effects"].effectUpdate = function(trgt, param) {
				_root.monitor.mbuto((getTimer()-_root.myGlobalCtrl.myRecorder.last_time)+",effectUpdate,"+this.ch+","+trgt+","+param);
			};
			this["effects"].videoPreview = _root.myCtrl[this.name].monitor.mon.ch_0["cnt"].vid;
			this["effects"].maskPreview = _root.myCtrl[this.name].monitor.mon.ch_0["mask"];
			this["effects"].myPanel = _root.myCtrl[this.name].myEffects["effects"];*/
		}
		public function connectStream() {
			NS = new NetStream(NC);
			customClient = new Object();
			customClient.onMetaData = onMetaData;
			//customClient.onCuePoint = onCuePoint;
			//customClient.onPlayStatus = onPlayStatus;
			NS.client = customClient;
			NS.addEventListener(NetStatusEvent.NET_STATUS, NSHandler);
			this.myVideo.attachNetStream(NS);
		}
		public function load_mp3(myAction) {
			if (oldTipo != myAction[4] && oldTipo != null) {
				this[oldTipo+"Reset"]();
			}
			oldTipo = "mp3";
			sliderVal = parseFloat(myAction[5]);
			/*if (this.parent == _level0.monitor.mon) {
				this.mp3Sound.loadSound(myAction[3], false);
				//this.mp3Sound.setVolume(parseFloat(myAction[5]));
			}*/
			var slc = new SoundLoaderContext(1, false); 
			this.mp3Sound.load(new URLRequest(myAction[3]),slc);
            transformSound.volume = sliderVal;
			song = mp3Sound.play(0,1, transformSound);
			song.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler2);
			parent.initHandlerMP3(null)
				this.imgLoader0 = new Loader();
				imgLoader0.x = -w/2;
				imgLoader0.y = -h/2;
				imgLoader0.alpha = 0;
				this.addChild(imgLoader0)
				imgLoader0.contentLoaderInfo.addEventListener(Event.INIT, initHandlerImg);
				imgLoader0.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
				imgLoader0.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				imgToShow = this.imgLoader0;
				imgLoader0.load(new URLRequest(myAction[6]));
		}
		function soundProgressHandler(event) {
			trace("bella"+mp3Sound.bytesLoaded)
		}
		function soundCompleteHandler(event) {
		}
		function soundCompleteHandler2(event) {
			song = mp3Sound.play(0);
			song.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler2);
		}
		public function setVol(myAction) {
			setVolAct(parseFloat(myAction[3]))
		}
		function setVolAct(v) {
            transformSound.volume = v;
			if (oldTipo == "flv") {
				NS.soundTransform = transformSound;
			} else if (oldTipo == "swf") {
				swfTrgt.soundTransform = transformSound;
			} else if (oldTipo == "mp3") {
				song.soundTransform = transformSound;
			}
		};
		// FLV LOADER //
		public function load_flv(myAction) {
			if (oldTipo != null) {
				this[oldTipo+"Reset"]();
			}
			oldTipo = "flv";
			nLoadErr = 0;
			this.NS.play(myAction[3]);
			transformSound.volume = parseFloat(myAction[4]);
			NS.soundTransform = transformSound;
			this.addChild(this.myVideo);
		}
		public function NCHandler(event:NetStatusEvent):void {
			trace(event.info.code);
			switch (event.info.code) {
				case "NetConnection.Connect.Success" :
					connectStream();
					break;
			}
		}
		public function NSHandler(event:NetStatusEvent):void {
			// SOLO SUPERPLAYER //
			parent.initHandlerFLV(event)
		}
		public function onMetaData(info:Object):void {
			myDuration = info.duration;
		}
		//
		public function load_img(myAction) {
			if (oldTipo != null && oldTipo != "jpg") {
				this[oldTipo+"Reset"]();
			}
			oldTipo = myAction[4];
			loadPicAction = myAction;
			nLoadErr = 0;
			if (this.imgLoader0 == null) {
				this.imgLoader0 = new Loader();
				imgLoader0.x = -w/2;
				imgLoader0.y = -h/2;
				imgLoader0.alpha = 0;
				this.addChild(imgLoader0)
			}
			if (this.imgLoader1 == null) {
				this.imgLoader1 = new Loader();
				imgLoader1.x = -w/2;
				imgLoader1.y = -h/2;
				imgLoader1.alpha = 0;
				this.addChild(imgLoader1)
			}
			if (this.imgLoader0.content == null) {
				imgLoader0.contentLoaderInfo.addEventListener(Event.INIT, initHandlerImg);
				imgLoader0.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
				imgLoader0.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				imgToShow = this.imgLoader0;
				imgLoader0.load(new URLRequest(myAction[3]));
			} else {
				imgLoader1.contentLoaderInfo.addEventListener(Event.INIT, initHandlerImg);
				imgLoader1.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
				imgLoader1.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				imgToShow = this.imgLoader1;
				imgLoader1.load(new URLRequest(myAction[3]));
			}
		}
		function initHandlerImg(event) {
			if (imgToRemove != null) {
				sparisci();
			} else {
				appare();
			}
        }
		function sparisci() {
			appare()
			myTweenS=new Tween(imgToRemove,"alpha",Strong.easeIn,1,0,.5,true);
			myTweenS.useSeconds = true;
			myTweenS.addEventListener(TweenEvent.MOTION_FINISH, motionSparisciFinish);
        }
		function motionSparisciFinish(event) {
			imgToRemove.unload()
			myTweenS.removeEventListener(TweenEvent.MOTION_FINISH, motionSparisciFinish);
        }
		function appare() {
			parent.resizza();
			myTweenA = new Tween(imgToShow,"alpha",Strong.easeIn,0,1,1,true);
			myTweenA.useSeconds = true;
			myTweenA.addEventListener(TweenEvent.MOTION_FINISH, motionAppareFinish);
        }
		function motionAppareFinish(event) {
			if (oldTipo != "mp3") {
				parent.initHandlerJPG(imgToShow);
				imgToRemove = imgToShow;
			}
			myTweenA.removeEventListener(TweenEvent.MOTION_FINISH, motionAppareFinish);
        }
		public function load_movie(myAction) {
			if (oldTipo != null) {
				this[oldTipo+"Reset"]();
			}
			oldTipo = myAction[4];
			loadSwfAction = myAction;
			/*
			this.my_mclL.myVolume = parseFloat(myAction[5]);
			*/
			nLoadErr = 0;
			this.swfLoader = new Loader();
			swfLoader.contentLoaderInfo.addEventListener(Event.INIT, initHandler);
			swfLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			swfLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);

			swfLoader.x = -w/2;
			swfLoader.y = -h/2;
			swfLoader.load(new URLRequest(myAction[3]));
		}
        private function onStatus(event:StatusEvent):void {
            switch (event.level) {
                case "status":
                    trace("LocalConnection.send() succeeded");
                    break;
                case "error":
						//LC.send("avm1customloader"+ch, "carica", loadSwfAction[3]);
                    trace("LocalConnection.send() failed");
                    break;
            }
        }
		function initHandler(event) {
			this.swfTrgt = null;
			if(this.swfLoader.content is AVM1Movie) {
				if (avm1customloader) {
					//swfLoader.load(new URLRequest("avm1customloader"+ch+".swf"));
					//swfLoader.load(new URLRequest("http://www.flxer.net/warehouse/_flxer/plug-in/dv_in/avm1customloader"+ch+"_0.swf"));
					//swfLoader.load(new URLRequest("/warehouse/_flxer/plug-in/dv_in/avm1customloader"+ch+"_0.swf"));
					swfLoader.load(new URLRequest("/_fp/avm1customloader"+ch+"_0.swf"));
				} else {
					swfTrgt = this.swfLoader.content;
					this.addChild(swfTrgt);
					// SOLO SUPERPLAYER //
					parent.initHandlerSWF(swfTrgt);
				}
			} else {
				swfTrgt = MovieClip(this.swfLoader.content); 
				this.addChild(swfTrgt);
				if (myStopStatus) {
					functionSTOP(null);
				}
				// SOLO SUPERPLAYER //
				parent.initHandlerSWF(swfTrgt);
			}
			
			/*swfChannel = swfSound.play();
			transformSound = swfChannel.soundTransform;
			transformSound.volume = this.myVolume;
			swfChannel.soundTransform = transformSound;
			*/
			/*if (t) {
			}
			if (parent != _level0.monitor.mon) {
				parent.parent.parent.myMovie.val.text = this.clipPath;
				parent.parent.parent.myMovie.val.textColor = 0x000000;
			}*/
		}
		public function sendToAvm1() {
			trace("sendToAvm1 "+loadSwfAction[3])
			LC.send("avm1customloader"+ch, "carica", loadSwfAction[3]);
        }
		function errorHandler(event) {
			trace("errorHandler "+event)
			/*if (nLoadErr<1 && FlxerStarter.myPrefSO.data.flxerPref.childNodes[0].childNodes[1].attributes.use == "true") {
				nLoadErr++;
				this.clipPath = FlxerStarter.myPrefSO.data.flxerPref.childNodes[0].childNodes[1].attributes.value+this.clip;
				my_mcl.loadClip(this.clipPath, owner["cnt"].trgt);
				if (parent != _level0.monitor.mon) {
					parent.parent.parent.myMovie.val.text = "SEARCHING ON THE NET";
					parent.parent.parent.myMovie.val.textColor = 0xFF0000;
				}
			} else if (parent != _level0.monitor.mon) {
				parent.parent.parent.myMovie.val.text = "FILE NOT FOUND";
				parent.parent.parent.myMovie.val.textColor = 0xFF0000;
			}*/
		}
		//// SEQUENCER ////
		public function functionPLAY(myAction) {
			if (myStopStatus) {
				this.cacheAsBitmap = this.myStopStatus=false;
				this["functionPLAY"+oldTipo]();
			}
		}
		public function functionSTOP(myAction) {
			this.cacheAsBitmap = this.myStopStatus=true;
			this["functionSTOP"+oldTipo]();
		}
		public function functionREWIND(myAction) {
			this["functionREWIND"+oldTipo]();
		}
		public function functionFORWARD(myAction) {
			this["functionFORWARD"+oldTipo]();
		}
		function functionHIDE() {
			this.visible = false;
		}
		function functionSHOW() {
			this.visible = true;
		}
		//
		function dragga(myAction) {
			this.x = myAction[3];
			this.y = myAction[4];
			vid.x = myAction[5];
			vid.y = myAction[6];
		}
		function scala(myAction) {
			vid.scaleX = myAction[3];
			vid.scaleY = myAction[4];
		}
		function ruota(myAction) {
			vid.rotation = myAction[3];
		}
		function resetta(myAction) {
			/*if (!_root["myTreDengine"].active) {
				this.x = 0;
				this.y = 0;
				this["mask"].scaleX = 100;
				this["mask"].scaleY = 100;
			}*/
			vid.x = 200;
			vid.y = 150;
			vid.rotation = 0;
			vid.scaleX = 100;
			vid.scaleY = 100;
		}
		/// LOADER //
		function preTxt() {
			if (oldTipo != null) {
				this[oldTipo+"Reset"]();
			}
			oldTipo = "txt";
		}
		function flvReset() {
			this.NS.close();
			this.myVideo.clear();
			this.removeChild(myVideo);
		}
		function mp3Reset() {
			this.song.stop();
			jpgReset();
		}
		/*function jpgReset() {
			imgLoader0.content.unload();
			imgLoader1.content.unload();
			myTweenA
			myTweenS
			this.removeChild(swfTrgt);
			this.removeChild(swfTrgt);			
		}*/
		function swfReset() {
			//this.swfLoader.content.unload();
			this.removeChild(swfTrgt);
		}
		function jpgReset() {
			imgLoader0.unload();
			imgLoader1.unload();
			if (myTweenA) {
				myTweenA.stop()
				myTweenA.removeEventListener(TweenEvent.MOTION_FINISH, motionAppareFinish);
			}
			if (myTweenS) {
				myTweenS.stop()
				myTweenS.removeEventListener(TweenEvent.MOTION_FINISH, motionSparisciFinish);
			}
			this.removeChild(imgLoader0);
			this.removeChild(imgLoader1);
			imgLoader0 = null;
			imgLoader1 = null;
		}
		function txtReset() {
			vid.txt.text = "";
		}
		public function eject(myAction) {
			if (oldTipo) {
				this[oldTipo+"Reset"]();
			}
			oldTipo = undefined;
		}
		//// MP3
		function functionREWINDmp3() {
			song.stop();
			soundCompleteHandler2(null);
		}
		function functionFORWARDmp3() {
			song.stop();
			song = mp3Sound.play(song.position+((mp3Sound.length-song.position)/10));
			song.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler2);
		}
		public function scratchmp3(myAction) {
			var tmp = (((mp3Sound.length)*(parseFloat(myAction[3])/800)))/1000;
			song.stop();
			song = mp3Sound.play(parseFloat(myAction[3])*mp3Sound.length);
			song.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler2);
		}
		function functionSTOPmp3() {
			song.stop();
		}
		function functionPLAYmp3() {
			song = mp3Sound.play(song.position);
			song.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler2);
		}
		//// JPG
		function functionSTOPjpg() {
		}
		function functionPLAYjpg() {
			parent.load_foto()
		}
		function functionREWINDjpg() {
			//this.myStopStatus = true;
			parent.load_prev_foto()
		}
		function functionFORWARDjpg() {
			//this.myStopStatus = true;
			parent.load_foto()
		}
		//// TXT
		
		function functionFORWARDtxt() {
			swfTrgt.forwardTxt();
		}
		function functionREWINDtxt() {
			swfTrgt.rewindTxt();
			//_root.myCtrl[this.name].myTxtEditor.currentReaderMode.myRewind(_root.myCtrl[this.name].myTxtEditor);
		}
		function functionSTOPtxt() {
			swfTrgt.stopTxt();
			//_root.myCtrl[this.name].myTxtEditor.currentReaderMode.myStop(_root.myCtrl[this.name].myTxtEditor);
		}
		function functionPLAYtxt() {
			swfTrgt.playTxt();
			//_root.myCtrl[this.name].myTxtEditor.currentReaderMode.myPlay(_root.myCtrl[this.name].myTxtEditor);
		}
		/**/
		//// SWF
		function scratchswf(myAction) {
			//trgt.gotoAndPlay(int(((trgt.totalFrames-1)*(parseFloat(myAction[3])/800))+1));
			var tmp
			if (myStopStatus) {
				tmp = "gotoAndStop";
			} else {
				tmp = "gotoAndPlay";
			}
			swfTrgt[tmp](int(((swfTrgt.totalFrames-1)*parseFloat(myAction[3]))+1));
		}
		function functionREWINDswf() {
			var act;
			if (myStopStatus) {
				act = "gotoAndStop";
			} else {
				act = "gotoAndPlay";
			}
			if (avm1customloader) {
				LC.send("avm1customloader"+ch, "avm1controlRewFww", act, 1);
			} else {
				recursiveSwfActParam(swfTrgt, act, 1);
			}
			
		}
		function functionFORWARDswf() {
			var act;
			if (myStopStatus) {
				act = "gotoAndStop";
			} else {
				act = "gotoAndPlay";
			}
			if (avm1customloader) {
				LC.send("avm1customloader"+ch, "avm1controlRewFww", act, 0);
			} else {
				recursiveSwfActParam(swfTrgt, act, int(swfTrgt.currentFrame+((swfTrgt.totalFrames-swfTrgt.currentFrame)/2)));
			}
		}
		function functionSTOPswf() {
			if (avm1customloader) {
				LC.send("avm1customloader"+ch, "avm1controlStopPlay", "stop");
			} else {
				recursiveSwfAct(swfTrgt, "stop");
			}
		}
		function functionPLAYswf() {
			if (avm1customloader) {
				LC.send("avm1customloader"+ch, "avm1controlStopPlay", "play");
			} else {
				recursiveSwfAct(swfTrgt, "play");
			}
		}
		function recursiveSwfAct(trgt, act) {
			trgt[act]();
			for (var a=0;a<trgt.numChildren;a++) {
				if (trgt.getChildAt(a) is MovieClip) {
					trgt.getChildAt(a)[act]();
					recursiveSwfAct(trgt.getChildAt(a), act);
				}
			}
		}
		function recursiveSwfActParam(trgt, act, p) {
			trgt[act](p);
			var item;
			for (item in trgt) {
				if (trgt[item].totalFrames) {
					trgt[item][act](p);
					recursiveSwfActParam(trgt[item], act, p);
				}
			}
		}
		//// FLV
		function functionREWINDflv() {
			NS.seek(0);
		}
		function functionFORWARDflv() {
			var tmp2 = int((NS.time)+(myDuration/10));
			if (tmp2>myDuration) {
				tmp2 = myDuration;
			}
			NS.seek(tmp2);
		}
		public function scratchflv(myAction) {
			NS.seek(int(myDuration*parseFloat(myAction[3])));
		}
		function functionSTOPflv() {
			NS.pause();
		}
		function functionPLAYflv() {
			NS.resume();
		}
		/*function effectUpdate(myAction) {
			var tmp = "";
			for (var a = 4; a<myAction.length; a++) {
				tmp += myAction[a];
				if (a<myAction.length-1) {
					tmp += ",";
				}
			}
			eval(myAction[3]).avvia(tmp);
		}
		function changeBlend(myAction) {
			this.blendMode = myAction[3];
		}
		function placeObjectIn3D(myAction) {
			this.alpha = myAction[3];
			this.x = myAction[4];
			this.y = myAction[5];
			this.scaleX = this.scaleY=myAction[6];
			this["mask"].scaleX = this["mask"].scaleY=this["cnt"]["fondo"].scaleX=this["cnt"]["fondo"].scaleY=myAction[7];
		}
		function insertEffectMovie(myAction) {
			this["effects"].createEmptyMovieClip("e"+myAction[3], parseFloat(myAction[3]));
			this["effects"]["livee"+myAction[3]] = myAction[5];
			this.my_wipeslL.errore = 0;
			this.my_wipeslL.clip = this["effects"]["e"+myAction[3]];
			this.my_wipesl.loadClip(myAction[4], this["effects"]["e"+myAction[3]]);
		}
		function removeEffectMovie(myAction) {
			this["effects"]["e"+myAction[3]].resetta();
			this["effects"]["e"+myAction[3]].removeMovieClip();
		}
		function mySwapDepth(myAction) {
			this.swapDepths(parseFloat(myAction[3]));
		}
		function reset_col(myAction) {
			this.CMT.rb = 0;
			this.CMT.gb = 0;
			this.CMT.bb = 0;
			this.CFT.rb = 0;
			this.CFT.gb = 0;
			this.CFT.bb = 0;
			this.CM.setTransform(this.CMT);
			this.CF.setTransform(this.CFT);
		}
		function reset_trans(myAction) {
			trace("reset_trans");
			vid.x = 0;
			vid.y = 0;
			this.x = 0;
			this.y = 0;
			vid.scaleX = 100;
			vid.scaleY = 100;
			this.rotation = 0;
		}
		function applicaLive(myAction) {
			this[myAction[3]](["a", "b", myAction[4], myAction[5], myAction[6], myAction[7]]);
			if (!_root["myTreDengine"].active) {
				this.x = myAction[8];
				this.y = myAction[9];
				slide_wipe(["a", "b", "c", myAction[15], myAction[16]]);
			}
			vid.x = myAction[10];
			vid.y = myAction[11];
			vid.scaleX = myAction[12];
			vid.scaleY = myAction[13];
			vid.rotation = myAction[14];
			colorizing(["a", "b", "c", myAction[17], myAction[18], myAction[19], myAction[20]]);
			colorizing(["a", "b", "c", myAction[21], myAction[22], myAction[23], myAction[24]]);
			colorizing(["a", "b", "c", myAction[25], myAction[26], myAction[27], myAction[28]]);
			bkgOnOff(["a", "b", "c", myAction[29]]);
			mySwapDepth(["a", "b", "c", myAction[30]]);
			changeBlend(["a", "b", "c", myAction[31]]);
			if (myAction[32]) {
				colorizing(["a", "b", "c", myAction[32], myAction[33], myAction[34], myAction[35]]);
				colorizing(["a", "b", "c", myAction[36], myAction[37], myAction[38], myAction[39]]);
				colorizing(["a", "b", "c", myAction[40], myAction[41], myAction[42], myAction[43]]);
			}
		}
		function colorizing(myAction) {
			this[myAction[4]][myAction[5]] = myAction[6];
			this.mySetTrasform(myAction);
		}
		function mySetTrasform(myAction) {
			this[myAction[3]].setTransform(this[myAction[4]]);
		}
		function bkgOnOff(myAction) {
			if (myAction[3] == "true") {
				this["cnt"].fondo.visible = true;
			} else {
				this["cnt"].fondo.visible = false;
			}
		}
		function txtAlign(myAction) {
			this.txtKS.align = myAction[3];
			if (this.txtKS.align == "right") {
				vid.txt.x = -1000;
			} else if (this.txtKS.align == "left") {
				vid.txt.x = -200;
			} else {
				vid.txt.x = -600;
			}
			vid.txt.setTextFormat(this.txtKS);
			vid.txt.setNewTextFormat(this.txtKS);
		}
		function txtFont(myAction) {
			if (myAction[3] == "hooge 05_55") {
				this.txtKS.font = "myFont";
				vid.txt.embedFonts = true;
			} else if (myAction[3] == "standard 07_53") {
				this.txtKS.font = "myFont2";
				vid.txt.embedFonts = true;
			} else {
				this.txtKS.font = myAction[3];
				vid.txt.embedFonts = false;
			}
			vid.txt.setTextFormat(this.txtKS);
			vid.txt.setNewTextFormat(this.txtKS);
			vid.y -= 1;
		}
		function set_txt(myAction) {
			vid.txt.text = myAction[3];
			//vid.txt.setTextFormat(this.txtKS);
		}
		function set_txtArea(myAction) {
			vid.txt.width = myAction[3];
		}
		function changeWipe(myAction) {
			this["mask"].trgt2.clear();
			this.my_wipeslL.errore = 0;
			this.my_wipeslL.clip = this["mask"].trgt;
			this.my_wipesl.loadClip(myAction[3], this["mask"].trgt);
		}
		function redrawWipe(myAction) {
			this.my_wipesl.unloadClip(this["mask"].trgt);
			_root.mdf.drawer(this["mask"], "trgt2", -200, -150, 400, 300, 0xFFFF00, false, 0x000000);
		}
		function slide_wipe(myAction) {
			if (this.parent == _level0.monitor.mon) {
				this[oldTipo+"Sound"].setVolume(myAction[3]);
			}
			if (myAction[4] == "WIPE NONE (MIX)") {
				this["mask"].scaleX = 100;
				this["mask"].scaleY = 100;
				this.alpha = myAction[3];
			} else if (myAction[4] == "HORIZONTAL") {
				this["mask"].scaleX = myAction[3];
				this["mask"].scaleY = 100;
				this.alpha = 100;
			} else if (myAction[4] == "VERTICAL") {
				this["mask"].scaleX = 100;
				this["mask"].scaleY = myAction[3];
				this.alpha = 100;
			} else {
				this["mask"].scaleX = myAction[3];
				this["mask"].scaleY = myAction[3];
				this.alpha = 100;
			}
		}*/
	}
}
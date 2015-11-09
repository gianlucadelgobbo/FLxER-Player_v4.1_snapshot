class main.flvPlayer extends MovieClip {
	var w, h, trgtF, meta, stat;
	var nc, ns, mp3player,myOwner;
	function flvPlayer() {
		nc = new NetConnection();
		nc.connect(null);
		ns = new NetStream(nc);
		ns.myOwner = this;
		ns["onMetaData"] = function (obj:Object) {
			myOwner.trgtF[myOwner.meta](this, obj);
		};
		ns.onStatus = function(obj) {
			myOwner.trgtF[myOwner.stat](this, obj);
		};
		ns.setBufferTime(1);
		this.attachMovie("video","myVideo",this.getNextHighestDepth());
		this["myVideo"].vid_flv._width = w;
		this["myVideo"].vid_flv._height = h;
		this["myVideo"].vid_flv.attachVideo(ns);
		this["myVideo"].vid_flv.smoothing = true;
		this["myVideo"].vid_flv._parent.attachAudio(ns);
		mp3player = new Sound(this["myVideo"].vid_flv._parent);
	}
}
class main.drawerFunc extends MovieClip {
	var playerColors:TextFormat;
	var toolsColors:TextFormat;
	var testo:TextFormat;
	var styles:TextField.StyleSheet;
	//
	function drawerFunc(trgt, myName, x, y, w, h, col) {
		/////
		/* NAT GEO ADVENTURE 
		playerColors["colorBkg"] = 0x000000;
		playerColors["colorBkg2"] = 0x000000;
		playerColors["colorBkgOver"] = 0xEFC700;
		playerColors["colorBkgPlayer"] = 0x6D6D6D;
		playerColors["colorBkgPlayerFoto"] = 0xDCE1E7;
		toolsColors["colorBkg"] = 0x000000;
		toolsColors["colorBkg2"] = 0x000000;
		toolsColors["colorBkgOver"] = 0x808080;
		testo["colorBorder"] = 0xFFFFFF;
		testo["colorBkg"] = 0x000000;
		testo["colorBkgOver"] = 0xFF0000;
		styles.setStyle(".playerMenu", {fontFamily:'Verdana', fontSize:'10px', color:'#FFFFFF', marginLeft:'3px'});
		styles.setStyle(".typeLabel", {fontFamily:'myFont', fontSize:'12px', color:'#FFFFFF', marginLeft:'3px'});
		styles.setStyle("a:link", {color:'#FFFFFF'});
		styles.setStyle("a:visited", {color:'#FFFFFF'});
		styles.setStyle("a:active", {color:'#FFFFFF'});
		styles.setStyle("a:hover", {color:'#EFC700'});
		styles.setStyle("div", {color:'#999999'});*/
	}
	function textDrawerSP(trgt, myName, txt, x, y, w, h, myEmbed) {
		trgt.createTextField(myName, trgt.getNextHighestDepth(), x, y, w, h);
		with (trgt[myName]) {
			background = true;
			border = true;
			html = true;
			multiline = true;
			selectable = false;
			wordWrap = true;
			embedFonts = myEmbed;
			//htmlText = txt;
		}
		trgt[myName].backgroundColor = testo["colorBkg"];
		trgt[myName].borderColor = testo["colorBorder"];
		trgt[myName].styleSheet = styles;
		trgt[myName].htmlText = txt;
	}
	function drawer(trgt, myName, x, y, w, h, col, o_col, alpha) {
		trgt.createEmptyMovieClip(myName, trgt.getNextHighestDepth());
		if (alpha == undefined) {
			alpha = 100;
		}
		with (trgt[myName]) {
			if (o_col != null) {
				lineStyle(0, o_col, alpha);
			}
			beginFill(col, alpha);
			moveTo(0, 0);
			lineTo(w, 0);
			lineTo(w, h);
			lineTo(0, h);
			lineTo(0, 0);
			_x = x;
			_y = y;
		}
	}
}

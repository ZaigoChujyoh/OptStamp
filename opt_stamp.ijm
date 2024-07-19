//Ver1.0---------------------------------------------------------------------

//---------------------------------------------------------------------------

//作業ディレクトリの選択
showMessage("Select Open Folder");
dir = getDirectory("Choose a Directory");
list = getFileList(dir); //作業ディレクトリの中にあるファイルのリスト

//データ保存用のディレクトリを作成
savedir = dir + "analysis\\";
if(!File.exists(savedir)){
	File.makeDirectory(savedir);
}

//スタンプ
function stamp(){
	setFont("SansSerif", 35, "bold");
	setJustification("left");
	
	for(i=1; i<=nSlices; i++){
	 	setSlice(i);
	 	if ((600 <= i && i <= 750) || (1200 <= i && i <= 1350) || (1800 <= i && i <= 1950)){
	 	//if ((750 <= i && i <= 1050) || (1500 <= i && i <= 1800) || (2250 <= i && i <= 2550) || (3000 <= i && i <= 3300)) {
	 		setColor("red");
	 		//setColor("green");
	 		drawString("On",30,60);
	 	} else {
	 		setColor("white");
	 		drawString("Off",30,60);
	 	} 	
	}
}

//main
for(j=0; j<list.length; j++){
	name = list[j];
	open(dir+name);
	extention = indexOf(name, ".");
	sub = substring(name, 0, extention); //元データは"sub.avi"
	saveAs("tiff", savedir + sub + ".tiff"); //open(filePath)でaviを開くと virtual stack で開いてしまう（スタンプが押せない）ので、一旦tiffに変換する
	close(); //tiffもvirtual stackになっているので、一旦閉じて再度開く
	open(savedir + sub + ".tiff");
	stamp();
	saveAs("avi", savedir + sub + "_stamp.avi");
	close();
}
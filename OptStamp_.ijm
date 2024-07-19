//Ver1.3.1---------------------------------------------------------------------

//---------------------------------------------------------------------------

//作業ディレクトリの選択
showMessage("Select Open Folder");
dir = getDirectory("Choose a Directory");
list = getFileList(dir); //作業ディレクトリの中にあるファイルのリスト
list_read = Array.filter(list, ".avi"); //.aviファイルのみのリスト

//データ保存用のディレクトリを作成
savedir = dir + "analysis\\";
if(!File.exists(savedir)){
	File.makeDirectory(savedir);
}

//刺激プロトコル（時間）と色の指定
Dialog.create("Enter yor protocols");
Dialog.addMessage("Enter your stimulation protocols")
Dialog.addNumber("ON duration [s]", "0");
Dialog.addNumber("OFF duration [s]", "0");
Dialog.addNumber("Delay [s]", "0");	

Dialog.addMessage("What color do you want “ON” to be?")
items_color = newArray("red", "green", "blue", "white");
Dialog.addRadioButtonGroup("", items_color, 4, 1,"red");
Dialog.show;

ON = Dialog.getNumber();
OFF = Dialog.getNumber();
delay = Dialog.getNumber();
color = Dialog.getRadioButton();

//プロトコル情報
num_period = 5; //繰り返しの回数
start = newArray(num_period);
end = newArray(num_period);
for(i=0; i<num_period; i++){
	start[i] = i*(ON+OFF) + delay;
	end[i] = i*(ON+OFF) + delay + ON;
}

//スタンプ
function stamp(){
	setFont("SansSerif", 35, "bold");
	setJustification("left");
	fps = Stack.getFrameRate();
	
	for(i=1; i<=nSlices; i++){
	 	setSlice(i);
	 	key = false;
	 	for(k = 0; k<num_period; k++){
		 	if(start[k]*fps <= i && i <= end[k]*fps){
		 		key = true;
		 	}
	 	}
	 	if(key == true){
	 		setColor(color);
	 		drawString("On",30,60);
	 	} else {
	 		setColor("white");
	 		drawString("Off",30,60);
	 	} 
	}
}

//main
for(j=0; j<list_read.length; j++){
	name = list_read[j];
	run("AVI...", "select="+dir+name+" avi="+dir+name); //virtual stackで開かないようにする（open(path)だとvirtual stackで開く）
	run("RGB Color");
	extension = indexOf(name, "."); //拡張子(.を含む)
	namewithoutextension = substring(name, 0, extension); //元データは"namewithoutextension + extension"
	stamp();
	saveAs("avi", savedir + namewithoutextension + "_stamp.avi");
	close();
}

Dialog.create("Finished");
Dialog.addMessage("All files have been successfully stamped!");
Dialog.show;

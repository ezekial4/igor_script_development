#pragma rtGlobals=3		// Use modern global access method and strict wave access.\
#include <Axis Utilities>
#include <Graph Utility Procs>
menu "Graph"
	"GraphControl",/q, GraphControlInit()
end

menu "AllTracesPopup" 
	"GraphControl",/q,GraphControlInit()
end

menu "TracePopup" 
	"GraphControl",/q,GraphControlInit()
end

//creates the graphcontrol panel and initializes the graphcontrol directory
function GraphControlInit()
	string DF=getdatafolder(1)
	newdatafolder/o/s root:graphcontrol
	make/o/n=0/t listtext,listtitle
	make/o/n=0 listselect
	make/o/n=9/t listcol={"Pos","Color","Y wave","X Wave","Y DF","X DF","Error Bars","Y Axis","X Axis"}
	make/o/n=9 listcolselect=1
	string/g axisleft,axisbottom
	PauseUpdate; Silent 1		// building window...
	dowindow /k GraphControl
	NewPanel /k=1/W=(563,57,1136,458)/n=GraphControl/flt=0 as "Graph Contol" 
	ShowTools/A
	PopupMenu TRACE_COL,pos={150,92},size={50,21},disable=1,proc=TRACE_PARAMS
	PopupMenu TRACE_COL,mode=1,popColor= (0,0,0),value= #"\"*COLORPOP*\""
	PopupMenu TRACE_LINE,pos={96,92},size={50,21},bodyWidth=50,disable=1,proc=TRACE_PARAMS
	PopupMenu TRACE_LINE,mode=1,value= #"\"*LINESTYLEPOP*\""
	PopupMenu TRACE_MARKER,pos={96,126},size={50,21},disable=1,proc=TRACE_PARAMS
	PopupMenu TRACE_MARKER,mode=6,value= #"\"*MARKERPOP*\""
	PopupMenu TRACE_MODE,pos={6,56},size={140,21},bodyWidth=140,disable=1,proc=TRACE_PARAMS
	PopupMenu TRACE_MODE,mode=1,popvalue="Lines",value= #"\"Lines;Sticks to zero;Dots;Markers;Lines and markers;Bars;Cityscape;Fill to zero;Sticks and markers\""
	SetVariable TRACE_LINESIZE,pos={8,94},size={80,16},disable=1,proc=TRACE_VAR,title="Line size:"
	SetVariable TRACE_LINESIZE,limits={0,10,1},value= _NUM:1
	SetVariable TRACE_TRANS_VAR,pos={102,186},size={47,16},disable=1,proc=TRANS_VAR,title="%"
	SetVariable TRACE_TRANS_VAR,limits={0,100,10},value= _NUM:50
	PopupMenu TRACE_TRANS_GROUP,pos={151,183},size={60,21},bodyWidth=60,disable=1,proc=TRANSP_GROUP
	PopupMenu TRACE_TRANS_GROUP,mode=2,popvalue="To zero",value= #"\"To next;To zero;To bottom\""
	PopupMenu TRANS_RES,pos={218,42},size={113,21},bodyWidth=60,proc=TRANSRES,title="Resolution"
	PopupMenu TRANS_RES,mode=2,popvalue="1X",value= #"\"0.5X (fast);1X;2X;5X (slow)\""
	GroupBox TRANSPARENCY_GB1,pos={216,1},size={120,87},title="Transparency"
	PopupMenu TRACE_MARKERCOLSTROKE,pos={96,148},size={50,21},disable=1,proc=TRACE_PARAMS
	PopupMenu TRACE_MARKERCOLSTROKE,mode=1,popColor= (0,0,0),value= #"\"*COLORPOP*\""
	SetVariable TRACE_MARKERSIZE,pos={8,128},size={60,16},disable=1,proc=TRACE_VAR,title="Size:"
	SetVariable TRACE_MARKERSIZE,limits={0,10,1},value= _NUM:0
	SetVariable TRACE_MARKERTHICK,pos={8,150},size={70,16},disable=1,proc=TRACE_VAR,title="Thick:"
	SetVariable TRACE_MARKERTHICK,limits={0,10,1},value= _NUM:0.5
	CheckBox TRACE_MARKEROPAQUE,pos={150,130},size={56,14},disable=1,proc=TRACE_CHECK,title="Opaque"
	CheckBox TRACE_MARKEROPAQUE,value= 1
	CheckBox TRACE_MARKERSTROKE,pos={150,152},size={49,14},disable=1,proc=TRACE_CHECK,title="Stroke"
	CheckBox TRACE_MARKERSTROKE,value= 1
	PopupMenu TRACE_FILLTYPEplus,pos={20,126},size={126,21},bodyWidth=60,disable=1,proc=TRACE_PARAMS,title="\\W600 Fill type:"
	PopupMenu TRACE_FILLTYPEplus,mode=1,popvalue="None",value= #"\"None;Erase;Solid;75%;50%;25%\""
	PopupMenu TRACE_COLFILLplus,pos={150,126},size={50,21},disable=1,proc=TRACE_PARAMS
	PopupMenu TRACE_COLFILLplus,mode=1,popColor= (65535,0,0),value= #"\"*COLORPOP*\""
	CheckBox TRACE_FILLCOLORplus,pos={6,130},size={16,14},disable=1,proc=TRACE_CHECK,title=""
	CheckBox TRACE_FILLCOLORplus,value= 0
	PopupMenu TRACE_FILLTYPEneg,pos={20,150},size={126,21},bodyWidth=60,disable=1,proc=TRACE_PARAMS,title="\\W609 Fill type:"
	PopupMenu TRACE_FILLTYPEneg,mode=1,popvalue="Same",value= #"\"Same;None;Erase;Solid;75%;50%;25%\""
	PopupMenu TRACE_COLFILLneg,pos={150,150},size={50,21},disable=1,proc=TRACE_PARAMS
	PopupMenu TRACE_COLFILLneg,mode=1,popColor= (65535,0,0),value= #"\"*COLORPOP*\""
	CheckBox TRACE_FILLCOLORneg,pos={6,154},size={16,14},disable=1,proc=TRACE_CHECK,title=""
	CheckBox TRACE_FILLCOLORneg,value= 0
	Button TRACEINFO_COPY,pos={147,56},size={31,32},disable=1,proc=INFOCOPY,title="Copy"
	Button TRACEINFO_PASTE,pos={177,56},size={35,32},disable=1,proc=INFOPASTE,title="Paste"
	Button TRACE_REMOVE,pos={49,15},size={45,25},disable=1,proc=TRACEREMOVE,title="Remove"
	Button buttonTRACE_APPEND,pos={5,15},size={45,25},proc=TRACEAPPEND,title="Append"
	Button TRACE_COPY,pos={93,15},size={60,25},disable=1,proc=TRACECOPY,title="Copy trace"
	Button buttonTRACE_PASTE,pos={152,15},size={60,25},proc=TRACE_PASTE,title="Paste trace"
	GroupBox TRACE_GBline,pos={2,78},size={213,179},disable=1,title="Line",fSize=8
	GroupBox TRACE_GBline,frame=0
	GroupBox TRACE_GBfill,pos={2,112},size={213,149},disable=1,title="Fill",fSize=8
	GroupBox TRACE_GBfill,frame=0
	Slider TRACE_TRANS_SLIDER,pos={37,185},size={64,19},disable=1,proc=TRANS_SLIDER
	Slider TRACE_TRANS_SLIDER,limits={0,100,10},value= 50,side= 2,vert= 0,ticks= 0
	CheckBox TRANS_LIVE,pos={226,21},size={41,14},proc=TRANSUPDATE,title="Live "
	CheckBox TRANS_LIVE,value= 1
	CheckBox TRACE_TRANS_DO,pos={8,187},size={16,14},disable=1,proc=TRANS_DOFILL,title=""
	CheckBox TRACE_TRANS_DO,value= 1
	Button TRANS_DO,pos={269,18},size={60,20},proc=TRANS_UPDATE,title="Update"
	GroupBox TRACE_GBmarker,pos={2,112},size={213,127},disable=1,title="Marker"
	GroupBox TRACE_GBmarker,fSize=8,frame=0
	GroupBox TRACE_TRANSGB,pos={2,169},size={213,86},disable=1,title="Transparency"
	GroupBox TRACE_TRANSGB,frame=0
	GroupBox TRACE_GBselected,pos={2,42},size={213,213},disable=1,title="Selected"
	GroupBox TRACE_GBselected,fSize=8,frame=0
	GroupBox GBTRACES,pos={2,1},size={213,210},title="Traces"
	TitleBox TRACE_INFO,pos={150,42},size={52,13},disable=1,title="Recreation"
	TitleBox TRACE_INFO,frame=0
	SetVariable PLOT_TOP,pos={362,19},size={65,16},proc=PLOTSIZE,title="Top"
	SetVariable PLOT_TOP,valueBackColor=(56576,56576,56576)
	SetVariable PLOT_TOP,limits={-1,1000,10},value= _NUM:20
	SetVariable PLOT_BOTTOM,pos={347,61},size={80,16},proc=PLOTSIZE,title="Bottom"
	SetVariable PLOT_BOTTOM,valueBackColor=(56576,56576,56576)
	SetVariable PLOT_BOTTOM,limits={-1,1000,10},value= _NUM:40
	SetVariable PLOT_LEFT,pos={341,40},size={40,16},proc=PLOTSIZE
	SetVariable PLOT_LEFT,valueBackColor=(56576,56576,56576)
	SetVariable PLOT_LEFT,limits={-1,1000,10},value= _NUM:40
	SetVariable PLOT_Right,pos={418,40},size={40,16},proc=PLOTSIZE
	SetVariable PLOT_Right,valueBackColor=(56576,56576,56576)
	SetVariable PLOT_Right,limits={-1,1000,10},value= _NUM:20
	TitleBox PLOT_LEFTtitle,pos={341,26},size={18,13},title="Left",frame=0
	TitleBox PLOT_RIGHTtitle,pos={432,26},size={25,13},title="Right",frame=0
	SetVariable PLOT_SIZEH,pos={487,19},size={70,16},proc=PLOTSIZE,title="Width"
	SetVariable PLOT_SIZEH,valueBackColor=(56576,56576,56576)
	SetVariable PLOT_SIZEH,limits={-1,1000,10},value= _NUM:200
	SetVariable PLOT_SIZEV,pos={482,39},size={75,16},proc=PLOTSIZE,title="Height"
	SetVariable PLOT_SIZEV,valueBackColor=(56576,56576,56576)
	SetVariable PLOT_SIZEV,limits={-1,1000,10},value= _NUM:200
	PopupMenu PLOT_AXIS_LEFT,pos={341,101},size={122,21},bodyWidth=100,proc=PLOTAXISSEL,title="Axis"
	PopupMenu PLOT_AXIS_LEFT,mode=1,popvalue="left",value= #"getaxistype(0)"
	PopupMenu PLOT_AXIS_BOTTOM,pos={341,158},size={122,21},bodyWidth=100,proc=PLOTAXISSEL,title="Axis"
	PopupMenu PLOT_AXIS_BOTTOM,mode=1,popvalue="bottom",value= #"getaxistype(1)"
	SetVariable PLOT_BOTTOM_MAX,pos={493,179},size={39,16},proc=PLOTSIZE,frame=0
	SetVariable PLOT_BOTTOM_MAX,value= _NUM:999
	SetVariable PLOT_BOTTOM_MIN,pos={493,160},size={31,16},proc=PLOTSIZE,frame=0
	SetVariable PLOT_BOTTOM_MIN,value= _NUM:0
	SetVariable PLOT_LEFT_MAX,pos={493,122},size={31,16},proc=PLOTSIZE
	SetVariable PLOT_LEFT_MAX,labelBack=(60928,60928,60928),frame=0,value= _NUM:5
	SetVariable PLOT_LEFT_MIN,pos={493,103},size={35,16},proc=PLOTSIZE
	SetVariable PLOT_LEFT_MIN,labelBack=(60928,60928,60928),frame=0,value= _NUM:-2
	CheckBox TRANS_IMAGE,pos={224,67},size={47,14},proc=TRANSSELECT,title="Image"
	CheckBox TRANS_IMAGE,value= 1,mode=1
	CheckBox TRANS_DRAWING,pos={276,67},size={57,14},proc=TRANSSELECT,title="Drawing"
	CheckBox TRANS_DRAWING,value= 0,mode=1
	SetVariable ERROR_YP,pos={230,108},size={50,16},disable=1
	SetVariable ERROR_YP,labelBack=(60928,60928,60928),frame=0
	SetVariable ERROR_YP,valueBackColor=(60928,60928,60928)
	SetVariable ERROR_YP,limits={0,10,1},value= _STR:"",noedit= 1
	CheckBox ERROR_YP_CHECK,pos={218,111},size={16,14},disable=1,proc=ERRORBARS_CHECK,title=""
	CheckBox ERROR_YP_CHECK,value= 0,mode=2,side= 1
	SetVariable ERROR_YN,pos={230,122},size={50,16},disable=1
	SetVariable ERROR_YN,labelBack=(60928,60928,60928),frame=0
	SetVariable ERROR_YN,valueBackColor=(60928,60928,60928)
	SetVariable ERROR_YN,limits={0,10,1},value= _STR:"",noedit= 1
	CheckBox ERROR_YN_CHECK,pos={218,125},size={16,14},disable=1,proc=ERRORBARS_CHECK,title=""
	CheckBox ERROR_YN_CHECK,value= 1,mode=2,side= 1
	SetVariable ERROR_XP,pos={289,108},size={50,16},disable=1
	SetVariable ERROR_XP,labelBack=(60928,60928,60928),frame=0
	SetVariable ERROR_XP,valueBackColor=(60928,60928,60928)
	SetVariable ERROR_XP,limits={0,10,1},value= _STR:"",noedit= 1
	CheckBox ERROR_XP_CHECK,pos={278,111},size={16,14},disable=1,proc=ERRORBARS_CHECK,title=""
	CheckBox ERROR_XP_CHECK,value= 0,mode=2,side= 1
	SetVariable ERROR_XN,pos={289,122},size={50,16},disable=1
	SetVariable ERROR_XN,labelBack=(60928,60928,60928),frame=0
	SetVariable ERROR_XN,valueBackColor=(60928,60928,60928)
	SetVariable ERROR_XN,limits={0,10,1},value= _STR:"",noedit= 1
	CheckBox ERROR_XN_CHECK,pos={278,125},size={16,14},disable=1,proc=ERRORBARS_CHECK,title=""
	CheckBox ERROR_XN_CHECK,value= 1,mode=2,side= 1
	TitleBox ERROR_Y,pos={223,97},size={5,13},disable=1,title="y",frame=0
	TitleBox ERROR_X,pos={283,97},size={5,13},disable=1,title="x",frame=0
	SetVariable ERROR_CAPH,pos={219,138},size={60,16},proc=ERR_VISUAL,title="Cap |"
	SetVariable ERROR_CAPH,limits={0,10,1},value= _NUM:1
	SetVariable ERROR_CAPW,pos={278,138},size={55,16},proc=ERR_VISUAL,title="\\W609"
	SetVariable ERROR_CAPW,limits={0,10,1},value= _NUM:4
	SetVariable ERROR_BAR,pos={219,156},size={60,16},proc=ERR_VISUAL,title="Bar:"
	SetVariable ERROR_BAR,limits={0,10,1},value= _NUM:1
	TitleBox PLOT_INFO,pos={439,72},size={52,13},title="Recreation",frame=0
	Button PLOTINFO_COPY,pos={492,56},size={31,32},proc=PLOTINFOCOPY,title="Copy"
	Button PLOTINFO_PASTE,pos={522,56},size={35,32},proc=PLOTINFOPASTE,title="Paste"
	SetVariable PLOT_BOTTOM_LABEL,pos={390,193},size={160,16},proc=PLOT_LABEL,title="Title:"
	SetVariable PLOT_BOTTOM_LABEL,frame=0,value= _STR:""
	CheckBox TRANS_HIDE_BOTTOM,pos={340,195},size={40,14},proc=AXISHIDE,title="Hide"
	CheckBox TRANS_HIDE_BOTTOM,value= 0

	SetVariable PLOT_LEFT_LABEL,pos={390,137},size={160,16},proc=PLOT_LABEL,title="Title:"
	SetVariable PLOT_LEFT_LABEL,labelBack=(60928,60928,60928),frame=0
	SetVariable PLOT_LEFT_LABEL,value= _STR:""
	CheckBox TRANS_HIDE_LEFT,pos={340,138},size={40,14},proc=AXISHIDE,title="Hide"
	CheckBox TRANS_HIDE_LEFT,value= 0

	GroupBox ERRORBARS_GB,pos={216,86},size={120,90},title="Error bars"
	GroupBox PLOT_AXES,pos={337,78},size={225,174},title="Axes",fSize=8,frame=0
	GroupBox PLOT_GBmargins,pos={337,1},size={225,247},title="Plot Area",fSize=8
	ListBox PLOTLIST,pos={2,210},size={572,128},proc=TRACELIST,frame=2
	ListBox PLOTLIST,listWave=root:graphcontrol:listtext
	ListBox PLOTLIST,selWave=root:graphcontrol:listselect
	ListBox PLOTLIST,titleWave=root:graphcontrol:listtitle,mode= 9
	ListBox PLOTLIST,widths={31,44,85,122,137,75,199},userColumnResize= 1
	CheckBox PLOT_LEFT_MODE_LINEAR,pos={341,123},size={47,14},proc=PLOTAXISMODE,title="Linear"
	CheckBox PLOT_LEFT_MODE_LINEAR,value= 1,mode=1
	CheckBox PLOT_LEFT_MODE_LOG,pos={392,123},size={36,14},proc=PLOTAXISMODE,title="Log"
	CheckBox PLOT_LEFT_MODE_LOG,value= 0,mode=1
	CheckBox PLOT_LEFT_MODE_LOG2,pos={431,123},size={42,14},proc=PLOTAXISMODE,title="Log2"
	CheckBox PLOT_LEFT_MODE_LOG2,value= 0,mode=1
	CheckBox PLOT_BOTTOM_MODE_LINEAR,pos={341,180},size={47,14},proc=PLOTAXISMODE,title="Linear"
	CheckBox PLOT_BOTTOM_MODE_LINEAR,value= 1,mode=1
	CheckBox PLOT_BOTTOM_MODE_LOG,pos={392,180},size={36,14},proc=PLOTAXISMODE,title="Log"
	CheckBox PLOT_BOTTOM_MODE_LOG,value= 0,mode=1
	CheckBox PLOT_BOTTOM_MODE_LOG2,pos={431,180},size={42,14},proc=PLOTAXISMODE,title="Log2"
	CheckBox PLOT_BOTTOM_MODE_LOG2,value= 0,mode=1
	Button PLOT_LEFT_AUTO_MIN,pos={478,103},size={16,16},proc=AUTOAXIS,title="*"
	Button PLOT_LEFT_AUTO_MAX,pos={478,121},size={16,16},proc=AUTOAXIS,title="*"
	Button PLOT_BOTTOM_AUTO_MIN,pos={478,160},size={16,16},proc=AUTOAXIS,title="*"
	Button PLOT_BOTTOM_AUTO_MAX,pos={478,178},size={16,16},proc=AUTOAXIS,title="*"
	SetWindow kwTopWin,hook(newgraphcontrol)=GraphControlPanelHook	
	
	setdatafolder DF	
	execute/q /p "transliveupdate()"
	updatetracelist(0)
	execute "updatetracecontrols(-1)"	
end


//converts waves to relative scale, saves them into xwaverel and ywaverel. Used to describe the waves on plot for transparency
function findpolywaves(plotname,grouping,tnum)
	string plotname
	variable grouping,tnum //grouping 1-to next,2-to zero,3-to botom of the plot;tnum-trace number
	wave colors
	make/o/n=3 tcolors
	variable pnt,mode,i
	string tracename=stringfromlist(tnum,TraceNameList(plotname, ";", 1 ))	
	string info =traceinfo(plotname,tracename,0)
	//need to know the axes
	string lax=stringbykey("YAXIS",info,":"),bax=stringbykey("XAXIS",info,":")
	string col=StringByKey("rgb(x)",info,"=",";")
 
	mode=numberbykey("mode(x)",info,"=",";")
	execute "tcolors="+replacestring(")",replacestring("(",col,"{"),"}")
	for(i=0;i<3;i+=1)
		colors[tnum][i]=tcolors[i]		
	endfor
	make/o /n=2 offset ,muloffset
	execute "offset="+stringbykey("offset(x)",info,"=")
	execute "muloffset="+stringbykey("muloffset(x)",info,"=")
	if(muloffset[0]==0)
		muloffset[0]=1
	endif
	if(muloffset[1]==0)
		muloffset[1]=1
	endif
	wave/wave ywaveref,xwaveref

	duplicate/o ywaveref[tnum],ywave
	if(waveexists(xwaveref[tnum])==0)//no xwave
		duplicate/o ywave,xwave
		xwave=leftx(ywave)+deltax(ywave)*p
	else
		duplicate/o xwaveref[tnum],xwave
	endif
	duplicate/o xwave,xwaverel,ywaverel
	if (mode==6)//cityscape
		make/o/n=(numpnts(xwave)*2) xwaverel,ywaverel
	endif
	for (pnt=0;pnt<numpnts(ywave);pnt+=1)
		if ((mode==6))//cityscape
			xwaverel[pnt*2]=axis2rel(plotname,bax,xwave[pnt],muloffset[0],offset[0])
			ywaverel[pnt*2]=axis2rel(plotname,lax,ywave[pnt],muloffset[1],offset[1])
			if(pnt==numpnts(ywave)-1)
				xwaverel[pnt*2+1]=axis2rel(plotname,bax,(xwave[pnt]+1-xwave[pnt-1]*0),muloffset[0],offset[0])			
				ywaverel[pnt*2+1]=ywaverel[pnt*2]
			else				
				xwaverel[pnt*2+1]=axis2rel(plotname,bax,xwave[pnt+1],muloffset[0],offset[0])
				ywaverel[pnt*2+1]=axis2rel(plotname,lax,ywave[pnt],muloffset[1],offset[1])
			endif
		else
			xwaverel[pnt]=axis2rel(plotname,bax,xwave[pnt],muloffset[0],offset[0])
			ywaverel[pnt]=axis2rel(plotname,lax,ywave[pnt],muloffset[1],offset[1])
		endif
	endfor
	insertpoints numpnts(xwaverel),2,xwaverel,ywaverel
	ywaverel[numpnts(xwaverel)-2]=0 
	if (grouping==2)//to zero
		ywaverel[numpnts(xwaverel)-2]=axis2rel(plotname,lax,0,1,0)
	endif
	ywaverel[numpnts(xwaverel)-1]=ywaverel[numpnts(xwaverel)-2]
	xwaverel[numpnts(xwaverel)-2]=xwaverel[numpnts(xwaverel)-3]
	xwaverel[numpnts(xwaverel)-1]=xwaverel[0]
	ywaverel=1-ywaverel
	killwaves/z tcolors
end

//converts axis coordinates to relative ones
function axis2rel(plotname,axis,pnt,mul,offset)
	string axis,plotname
	variable pnt,mul,offset//mul offset-multiplicative and linear offset
	variable islog=numberbykey("log(x)",AxisInfo(plotname, axis ),"=")
	GetAxis /W=$plotname /Q $axis
	if(islog==0)	
		return (pnt*mul+offset-V_min)/(V_max-V_min)
	else
		 return (log(pnt*mul+offset)-log(V_min))/(log(V_max)-log(V_min)) //may not work well with offset
	endif
end

//converts relative axis to axis coordinates
function rel2axis(plotname,relaxis,axis,pnt)
	string axis,plotname,relaxis
	variable pnt
	GetAxis /W=$plotname /Q $relaxis
	pnt=(pnt-V_min)/(V_max-V_min)
	GetAxis /W=$plotname /Q $axis	
	return (pnt)*(V_max-V_min)+V_min
end

//generates the trasparency by eitehr adding a background image or polygon shapes
function transparentplot(plotname,res)
	string plotname
	variable res //resolution in pixels, 1 usually works well, set higher for better quality
	variable tracesnum=itemsinlist(TraceNameList(plotname, ";", 1 )),i,tnum,pnt,xpnt,ypnt,gpnt,found,tnum2,mode
	string tracename
	found=0
	for (tnum=0;tnum<tracesnum;tnum+=1)	//go over the traces
		tracename=stringfromlist(tnum,TraceNameList(plotname, ";", 1 ))
		if(getTdata(tracename,"dotransfill")==1)	//do transparency 
			found=1
		endif
	endfor
	if (found)
		string DF=getdatafolder(1)
		setdatafolder root:graphcontrol:	
		getwindow $plotname psizeDC
		make/o/n=(abs(V_right-V_left)*res,abs(V_bottom-V_top)*res,3) timage=2^15*2-1 //rgb image
		variable/g doingtrans=1
		nvar image0drawing1
		if(strlen(getuserdata(plotname,"","plotimage"))) //remove previous transparent images, if any
			RemoveImage/z /w=$plotname $getuserdata(plotname,"","plotimage")
			RemoveImage/z /w=$plotname timage
			killwaves/z $getuserdata(plotname,"","plotimage")
		endif
		AppendImage/w=$plotname/L=limage/B=bimage timage
		ModifyGraph/w=$plotname nticks(limage)=0,axThick(limage)=0
		ModifyGraph/w=$plotname nticks(bimage)=0,axThick(bimage)=0
		make/o/n=(tracesnum,3) colors=0
		make/o/n=0 order
		wave M_ROIMask
		make/o  xwaverel,ywaverel
		for (tnum=0;tnum<tracesnum;tnum+=1)	//go over the traces
			tracename=stringfromlist(tnum,TraceNameList(plotname, ";", 1 ))
			if(getTdata(tracename,"dotransfill")==1)	//do transparency 
				insertpoints 0,1, order
				order[0]=tnum
				findpolywaves(plotname,getTdata(tracename,"transgroup") ,tnum)
				setdrawlayer/w=$plotname progfront
				drawaction/w=$plotname  delete			
				SetDrawEnv/w=$plotname  fillfgc=(0,0,0),linethick= .00,xcoord=prel,ycoord=prel
				duplicate/o xwaverel,polyx
				duplicate/o ywaverel,polyy
				drawpoly/w=$plotname/abs 0,0,1,1, polyx,polyy
				if((getTdata(tracename,"transgroup")==1)&&(tnum<tracesnum-1))//to next, erase the next wave
					findpolywaves(plotname,3,tnum+1)		
					SetDrawEnv/w=$plotname  fillfgc=(0,0,0),linethick= .00,fillpat= -1,xcoord=prel,ycoord=prel
					drawpoly/w=$plotname/abs 0,0,1,1, xwaverel,ywaverel			//generate a mask	
				endif
				imageGenerateROIMask /W=$plotname/e=0/i=1 timage	//generate a mask	
				if(waveexists(M_ROIMask))	
					duplicate /o M_ROIMask,$"mask"+num2str(tnum)	//save the mask
				else
					make/b/o/n=(dimsize(timage,0),dimsize(timage,1)) $"mask"+num2str(tnum)
				endif			
				drawaction/w=$plotname  delete	
			endif
		endfor
		string tcol
		variable opacity,remainingopacity,ncol,transparent
		wave M_ImagePlane
		for (tnum=0;tnum<numpnts(order);tnum+=1)
			duplicate/o timage,tempimage
			duplicate/o ,$"mask"+num2str(order[tnum]),tmask
			tracename=stringfromlist(order[tnum],TraceNameList(plotname, ";", 1 ))
			transparent=getTdata(tracename,"transparent")
			for (i=0;i<3;i+=1)
				make/o M_ImagePlane
				imagetransform/p=(i) getplane tempimage
				duplicate/o M_ImagePlane,saveplane
				M_ImagePlane*=tmask*transparent/100
				M_ImagePlane+=tmask*(1-transparent/100)*colors[order[tnum]][i]
				saveplane=saveplane*(1-tmask)+M_ImagePlane
				imagetransform/p=(i)/d=saveplane setplane timage
			endfor
		endfor
		if (image0drawing1==1)
			imagetopoly(plotname,timage,res)	//draw the transparency
		else
			duplicate/o timage,$plotname+"_TRANS"	//transparency by background image
			AppendImage/w=$plotname/L=limage/B=bimage $plotname+"_TRANS"
			setwindow $plotname,userdata(plotimage)=plotname+"_TRANS"	
			setdrawlayer /w=$plotname progback
			DrawAction /w=$plotname getgroup=transdraw
			DrawAction /w=$plotname delete =V_startPos , V_endPos
			setdrawlayer /w=$plotname userfront
		endif
		RemoveImage/z /w=$plotname timage
		for (tnum=0;tnum<numpnts(order);tnum+=1)
		 	killwaves $"mask"+num2str(order[tnum])
		endfor
		killwaves/z xwaverel,ywaverel,polyx,polyy,order,colors,timage,muloffset,offset,tmask,saveplane,tempimage,xwave,ywave//M_ImagePlane,M_ColorIndex,M_IndexImage,M_ROIMask,M_SelectColor
		doingtrans=2
		CtrlNamedBackground delay, period=res*60*2, proc=delaytrans
		CtrlNamedBackground delay, start
		setdatafolder DF	
	endif
end

function delaytrans(s)
	STRUCT WMBackgroundStruct &s
	nvar doingtrans=root:graphcontrol:doingtrans
	doingtrans-=1
	return (doingtrans==0)
end

//get 3d image, output is poly drawings according to image colors
function imagetopoly(plotname,timage,res)
	string plotname
	wave timage
	variable res
	make/o/n=(dimsize(timage,0),dimsize(timage,1)) maskimage=0
	make/o/n=0 cR,cG,cB
	make/o/n=3 colwave
	variable i,j,col,found
	make/o M_ColorIndex,M_SelectColor
	imagetransform /NCLR=256  rgb2cmap	 timage
	wave W_BoundaryY , W_BoundaryX
	setdrawlayer /w=$plotname progback
	DrawAction /w=$plotname getgroup=transdraw
	DrawAction /w=$plotname delete =V_startPos , V_endPos
	SetDrawEnv/w=$plotname gstart,gname= transdraw
	doupdate	
	for (col=0;col<dimsize(M_ColorIndex,0);col+=1)	
		if (numtype(M_ColorIndex[col][0])==0)
			if ((M_ColorIndex[col][0]<2^16-1)||(M_ColorIndex[col][1]<2^16-1)||(M_ColorIndex[col][2]<2^16-1))
				imagetransform /E={(M_ColorIndex[col][0]),(M_ColorIndex[col][1]),(M_ColorIndex[col][2]),1,1} selectcolor timage
				M_SelectColor=255-M_SelectColor
				ImageAnalyzeParticles/Q/B /W stats M_SelectColor
				SetDrawEnv/w=$plotname  fillfgc=((M_ColorIndex[col][0]),(M_ColorIndex[col][1]),(M_ColorIndex[col][2])),linefgc=((M_ColorIndex[col][0]),(M_ColorIndex[col][1]),(M_ColorIndex[col][2])),linethick= 1/res+.5,fillpat=1,xcoord=bottom,ycoord=left,save
				if (numpnts(W_BoundaryX))
					drawpoly/w=$plotname /abs 0,0,1,1, {rel2axis(plotname,"bimage","bottom",W_BoundaryX[0] ), rel2axis(plotname,"limage","left",W_BoundaryY[0])}
					for(i=0;i<numpnts(W_BoundaryX);i+=1)
						drawpoly/w=$plotname /a {rel2axis(plotname,"bimage","bottom",W_BoundaryX[i] ), rel2axis(plotname,"limage","left",W_BoundaryY[i])}
					endfor
				endif
				doupdate
			endif
		endif
	endfor
	SetDrawEnv/w=$plotname gstop
	setdrawlayer /w=$plotname userfront
	killwaves /z maskimage, cR,cG,cB, colwave
end

//get transparent information from plot user data
function getTdata(tracename,userdata)
	string tracename,userdata
	string US=getuserdata(winname(0,1),"",userdata)
	if (numtype(numberbykey(tracename,US,"="))==0)
		return numberbykey(tracename,US,"=")
	else
		return -1
	endif
end

//saves transparent information to user data
function	setTdata(tracename,userdata,value)
	string tracename,userdata
	variable value
	string newuserdata=getuserdata(winname(0,1),"",userdata)
	newuserdata=ReplaceNumberByKey(tracename,newuserdata,value,"=")
	execute "setwindow "+winname(0,1)+" userdata("+userdata+")=\""+newuserdata+"\""
end

//checks that the traces are on the plot
function updateTuserdata()
	string userdata=getuserdata(winname(0,1),"","transparent"),tempdata
	string USdotrans=getuserdata(winname(0,1),"","dotransfill")
	string UStransgroup=getuserdata(winname(0,1),"","transgroup")
	string tracelist=tracenamelist("",";",1)
	variable tnum
	for(tnum=0;tnum>itemsinlist(userdata);tnum+=1)
		tempdata=stringfromlist(tnum,userdata)
		tempdata=tempdata[0,strsearch(tempdata,"=",0)]
		if(WhichListItem(tempdata,tracelist)==-1)
			userdata=RemoveByKey(tempdata,userdata)
			USdotrans=RemoveByKey(tempdata,USdotrans)
			UStransgroup=RemoveByKey(tempdata,UStransgroup)			
		endif
	endfor
	setwindow $winname(0,1) userdata(transparent)=userdata
	setwindow $winname(0,1) userdata(dotransfill)=USdotrans
	setwindow $winname(0,1) userdata(transgroup)=UStransgroup	
end

//updates the trace information according to selection 
function updatetracelist(event)
	variable event
	string DF=getdatafolder(1)
	setdatafolder root:graphcontrol:
	wave listcolselect 
	variable colnum=sum(	listcolselect)	,stop=0
	dowindow GraphControl	
	if(V_flag==1) //graph control exists
		if((event==2)||(event==15))//kill or hide target window
			make/o/n=(1,colnum) listselect=0
			make/o/t/n=(1,colnum) listtext
			stop=1						
		endif
		if ((strlen(winname(0,1)))&&(stop==0))//target windows exists
			DoWindow/T GraphControl,"Graph Contol - "+winname(0,1)
			SetWindow $winname(0,1) hook(newgraphcontrol)=GraphControlHook
			
			variable tracesnum=itemsinlist(TraceNameList("", ";", 1 ))
			if((event==0)||(event==16))//activate or unhide
				make/o/n=(tracesnum,colnum) listselect=0
				make/o/WAVE/n=(tracesnum) ywaveref,xwaveref
			endif
			Redimension/N=(tracesnum,colnum) listselect
			Redimension/N=(tracesnum) ywaveref,xwaveref
			updateplotparams()
			//fill the information
			make/o/t/n=(tracesnum,colnum) listtext
			make/o/t/n=(colnum) listtitle
			wave/t listcol
			variable tnum,ncol
			string st 
			for (tnum=0;tnum<tracesnum;tnum+=1)
				ncol=0
				string tracename=stringfromlist(tnum,TraceNameList("", ";", 1 ))	
				string info =traceinfo("",tracename,0)
				ywaveref[tnum]=waverefindexed("",tnum,1)
				xwaveref[tnum]=XWaveRefFromTrace("", tracename )
				if(getTdata(tracename,"transparent")==-1)//no transparent information
					setTdata(tracename,"transparent",0)
					setTdata(tracename,"dotransfill",0)
					setTdata(tracename,"transgroup",1)
				endif
				
				if (listcolselect[0])//pos
					listtext[tnum][ncol]=num2str(tnum+1)
					if((tnum==0)&&(tnum<tracesnum-1))
						listtext[tnum][ncol]+="\W523"//+"\W522"506
					endif					
					if((tnum>0)&&(tnum<tracesnum-1))
						listtext[tnum][ncol]+="\W529"//+"\W522"506
					endif
					if(tnum==tracesnum-1)
						listtext[tnum][ncol]+="\W517"
					endif
					listtitle[ncol]=listcol[0]
					ncol+=1
				endif
				if (listcolselect[1])//color
					listtext[tnum][ncol]="\\JC\\k"+stringbykey("rgb(x)",info,"=")+"\\W509"//\W516"
					listtitle[ncol]=listcol[1]		
					listselect[tnum][ncol]=0	
					ncol+=1
				endif
				if (listcolselect[2])//y wave
					listtext[tnum][ncol]=tracename
					listtitle[ncol]=listcol[2]		
					listselect[tnum][ncol]=6	
					ncol+=1
				endif
				if (listcolselect[3])//x wave
					listtext[tnum][ncol]=stringbykey("XWAVE",info,":")
					listselect[tnum][ncol]=6
					if(strlen(stringbykey("XWAVE",info,":"))==0)
						listtext[tnum][ncol]=""
						listselect[tnum][ncol]=0
					endif			
					listtitle[ncol]=listcol[3]			
					ncol+=1
				endif
				if (listcolselect[4])//y df
					listtext[tnum][ncol]=GetWavesDataFolder(WaveRefIndexed("", tnum, 1 ),1)
					listtitle[ncol]=listcol[4]			
					ncol+=1
				endif
				if (listcolselect[5])//x df
					if(waveexists(XWaveRefFromTrace("",tracename)))
						listtext[tnum][ncol]=GetWavesDataFolder(XWaveRefFromTrace("",tracename),1)
					else
						listtext[tnum][ncol]=""
					endif
					listtitle[ncol]=listcol[5]			
					ncol+=1
				endif		
				if (listcolselect[6])//error
					st=stringbykey("ERRORBARS",info,":",";")
					st=replacestring("ERRORBARS ",st,"")
					st=replacestring(tracename+" ",st,"")
					variable del=strsearch(st,"X",0)
					if(del==-1)
						del=strsearch(st,"Y",0)
					endif
					st=replacestring(st[0,del-1],st,"")					
					listtext[tnum][ncol]=st
					listtitle[ncol]=listcol[6]			
					ncol+=1
				endif
				if (listcolselect[7])//y axis
					listtext[tnum][ncol]=stringbykey("YAXIS",info,":")
					listtitle[ncol]=listcol[7]	
					listselect[tnum][ncol]=6		
					ncol+=1
				endif	
				if (listcolselect[8])//x axis
					listtext[tnum][ncol]=stringbykey("XAXIS",info,":")
					listtitle[ncol]=listcol[8]		
					listselect[tnum][ncol]=6	
					ncol+=1
				endif							
			endfor
		else //no top plot
			colnum=sum(listcolselect)	
			make/o/n=(0,colnum) listselect=0
			make/o/t/n=(0,colnum) listtext
			make/o/t/n=(colnum) listtitle
		endif
	endif
	setdatafolder DF	
end

//executes edit of selected wave
function editwaves(row)
	variable row
	string wavey=GetWavesDataFolder(WaveRefIndexed("", row, 1 ),2)
	string tracename=stringfromlist(row,TraceNameList("", ";", 1 ))
	if(waveexists(XWaveRefFromTrace("",tracename)))
		string wavex=GetWavesDataFolder(XWaveRefFromTrace("",tracename),2)
		edit/k=1 $wavey,$wavex
	else
		edit/k=1 $wavey
	endif
end

//opens a dialog to replace the selected wave
function replacewavedialog(tracename,y0x1)
	string tracename
	variable y0x1
	string DF=getdatafolder(1)
	setdatafolder root:DFselect:	
	svar wavesel,savedDF	
	if(strlen(wavesel))
		if(y0x1==0)
			replacewave trace=$tracename,$wavesel
		else
			replacewave/X trace=$tracename,$wavesel
		endif
	endif
	transliveupdate()	
	setdatafolder DF	
end

//reorders the selected waves
function reorder(waveref,p1,p2)
	wave waveref
	variable p1,p2
	variable num
	num=waveref[p1]
	waveref[p1]=	waveref[p2]
	waveref[p2]=num
end

//the graphs are now lnked to graphcontrol panel
function GraphControlHook(s)
	STRUCT WMWinHookStruct &s
	if (s.eventcode==6)
		updateplotparams()
	endif
	if ((s.eventcode==0)||(s.eventcode==2)||(s.eventcode==8)||(s.eventcode==15)||(s.eventcode==16))
		//0-activate;2-kill;8-change;hide-15;unhide-16
		nvar doingtrans=root:graphcontrol:doingtrans
		if(doingtrans==0)
			updatetracelist(s.eventcode)
			execute "updatetracecontrols(-1)"
			execute/q /p "transliveupdate()"
		endif
	endif
End

//events that happen when graphcontrol panel is activated or resized
function GraphControlPanelHook(s)
	STRUCT WMWinHookStruct &s
	if ((s.eventcode==0)&&(strlen(winname(0,1))))//activate
		getwindow $winname(0,1) hook(newgraphcontrol)
		if(strlen(S_value)==0)
			execute/q /p "transliveupdate()"
			updatetracelist(0)
			execute "updatetracecontrols(-1)"
		endif		
	endif
	if (s.eventcode==6)//resize
		getwindow GraphControl wsize
		if(V_bottom-V_top<200)
			MoveWindow /w=GraphControl V_left,V_top,V_right,V_top+200
			getwindow GraphControl wsize
		endif
		getwindow GraphControl wsizeDC
		ListBox PLOTLIST size={V_right-V_left-5,V_bottom-V_top-220}
	endif
End

//finds the user selected trace
function gettracenumber(number)
	variable number	//if -1 searches for the first selected row
	variable tnum,found
	string DF=getdatafolder(1)
	setdatafolder root:graphcontrol:	
	wave listselect
	if(number==-1)
		found=0
		for (tnum=0;tnum<dimsize(listselect,0);tnum+=1)
			if ((listselect[tnum][0])&&(found==0))
				found=1
				number=tnum
			endif
		endfor	
	endif
	setdatafolder DF	
	return number	//row number or -1 if none was selected
end
	
//changes the trace controls on graphcontrol panel accordingly to selected trace
function updatetracecontrols(number)
	variable number
	string DF=getdatafolder(1)
	setdatafolder root:graphcontrol:	
	string/g enablelist="",disablelist=""
	string info="",tracename
	variable found,tnum,i
	number=gettracenumber(number)
	dowindow GraphControl
	if(v_flag==1)
		enablelist=ControlNameList("GraphControl", ";", "TRACE*")+ControlNameList("GraphControl", ";", "ERROR*")//ControlNameList("GraphControl", ";", "*")//+ControlNameList("GraphControl", ";", "ERROR*")
		if(number==-1)
			disablelist=ControlNameList("GraphControl", ";", "TRACE*")+ControlNameList("GraphControl", ";", "ERROR*")
		endif

		if(number>=0) //trace selected
			tracename=stringfromlist(number,TraceNameList("", ";", 1 ))
			info =traceinfo("",tracename,0)		
			UpdateControl("popupmenu", "TRACE_MODE","mode",numberbykey("mode(x)",info,"=")+1,"","GraphControl" , "")
			UpdateControl("popupmenu", "TRACE_FILLTYPEplus","mode",numberbykey("hbFill(x)",info,"=")+1,"","GraphControl" , "")
			UpdateControl("popupmenu", "TRACE_FILLTYPEneg","mode",numberbykey("hBarNegFill(x)",info,"=")+1,"","GraphControl" , "")
			UpdateControl("popupmenu", "TRACE_LINE","mode",numberbykey("lstyle(x)",info,"=")+1,"","GraphControl" , "")
			UpdateControl("popupmenu", "TRACE_MARKER","mode",numberbykey("marker(x)",info,"=")+1,"","GraphControl" , "")
			UpdateControl("popupmenu", "TRACE_TRANS_GROUP","mode",getTdata(tracename,"transgroup"),"","GraphControl" , "")
			UpdateControl("popupmenu", "TRACE_COL","popcolor",nan,stringbykey("rgb(x)",info,"="),"GraphControl" , "")
			UpdateControl("popupmenu", "TRACE_MARKERCOLSTROKE","popcolor",nan,stringbykey("mrkStrokeRGB(x)",info,"="),"GraphControl" , "")
			UpdateControl("popupmenu", "TRACE_COLFILLplus","popcolor",nan,stringbykey("plusRGB(x)",info,"="),"GraphControl" , "")
			UpdateControl("popupmenu", "TRACE_COLFILLneg","popcolor",nan,stringbykey("negRGB(x)",info,"="),"GraphControl" , "")
			UpdateControl("SetVariable", "TRACE_LINESIZE","value",numberbykey("lsize(x)",info,"="),"","GraphControl" , "_NUM:")
			UpdateControl("SetVariable", "TRACE_MARKERSIZE","value",numberbykey("msize(x)",info,"="),"","GraphControl" , "_NUM:")
			UpdateControl("SetVariable", "TRACE_MARKERTHICK","value",numberbykey("mrkThick(x)",info,"="),"","GraphControl" , "_NUM:")
			UpdateControl("CheckBox", "TRACE_MARKERSTROKE","value",numberbykey("useMrkStrokeRGB(x)",info,"="),"","GraphControl","")
			UpdateControl("CheckBox", "TRACE_MARKEROPAQUE","value",numberbykey("opaque(x)",info,"="),"","GraphControl","")
			UpdateControl("CheckBox", "TRACE_FILLCOLORplus","value",numberbykey("usePlusRGB(x)",info,"="),"","GraphControl","")
			UpdateControl("CheckBox", "TRACE_FILLCOLORneg","value",numberbykey("usenegRGB(x)",info,"="),"","GraphControl","")
			UpdateControl("SetVariable", "TRACE_TRANS_VAR","value",getTdata(tracename,"transparent"),"","GraphControl" , "_NUM:")
			UpdateControl("slider", "TRACE_TRANS_SLIDER","value",getTdata(tracename,"transparent"),"","GraphControl","")
			UpdateControl("CheckBox", "TRACE_TRANS_DO","value",getTdata(tracename,"dotransfill"),"","GraphControl","")

			updateerrorbars(info,stringfromlist(number,TraceNameList("", ";", 1 )),1)
			controlinfo/w=GraphControl TRACE_MODE 
			if((V_value!=6)&&(V_value!=8))
				disablelist+=ControlNameList("GraphControl", ";", "*fill*")
			else
				disablelist+=ControlNameList("GraphControl", ";", "trace_trans*")			
			endif
			if((V_value<4)||(V_value>5))
				disablelist+=ControlNameList("GraphControl", ";", "*MARKER*") 
			endif
			UpdateControl("popupmenu", "PLOT_AXIS_LEFT","mode",whichlistitem(stringbykey("YAXIS",info,":"),getaxistype(0))+1,"","GraphControl" , "")
			UpdateControl("popupmenu", "PLOT_AXIS_BOTTOM","mode",whichlistitem(stringbykey("XAXIS",info,":"),getaxistype(1))+1,"","GraphControl" , "")
			updateplotparams()
		else	//no trace selected
			controlinfo/w=graphcontrol PLOT_AXIS_LEFT
			if(stringmatch(s_value,stringfromlist(0,getaxistype(0)))==0)
				popupmenu PLOT_AXIS_LEFT mode=1,win= graphcontrol 	
			endif
			controlinfo/w=graphcontrol PLOT_AXIS_BOTTOM
			if(stringmatch(s_value,stringfromlist(0,getaxistype(1)))==0)
				popupmenu PLOT_AXIS_BOTTOM mode=1,win= graphcontrol 
			endif
			UpdateControl("popupmenu", "PLOT_AXIS_LEFT","mode",1,"","GraphControl" , "")
			UpdateControl("popupmenu", "PLOT_AXIS_BOTTOM","mode",1,"","GraphControl" , "")
		endif
		
		for(i=0;i<itemsinlist(enablelist);i+=1)	//disable controls not in use
			variable dis=(WhichListItem( stringfromlist(i,enablelist), disablelist)>-1)
			controlinfo /w=GraphControl  $stringfromlist(i,enablelist)
			if(dis!=v_disable)
				modifycontrollist stringfromlist(i,enablelist) disable=dis,win=GraphControl 
			endif
		endfor
	endif
	setdatafolder DF
end

//update of the axis and plot controls
function updateplotparams()
	string DF=getdatafolder(1)
	setdatafolder root:graphcontrol:		
	svar disablelist,axisleft,axisbottom
	variable updatelabel=0,vmin,vmax
	string labelname
	getwindow $winname(0,1) gsize
	variable left=v_left,right=v_right,top=v_top,bottom=v_bottom
	getwindow $winname(0,1) psize
	left+=v_left;right-=v_right;top+=v_top;bottom-=v_bottom
	UpdateControl("SetVariable", "PLOT_LEFT","value",round(left),"","GraphControl","_NUM:")
	UpdateControl("SetVariable", "PLOT_RIGHT","value",round(right),"","GraphControl","_NUM:")
	UpdateControl("SetVariable", "PLOT_TOP","value",round(top),"","GraphControl","_NUM:")
	UpdateControl("SetVariable", "PLOT_BOTTOM","value",round(bottom),"","GraphControl","_NUM:")
	UpdateControl("SetVariable", "PLOT_SIZEH","value",round(v_right-v_left),"","GraphControl","_NUM:")
	UpdateControl("SetVariable", "PLOT_SIZEV","value",round(v_bottom-v_top),"","GraphControl","_NUM:")
	

	
	controlinfo/w=GraphControl PLOT_AXIS_BOTTOM
	getaxis/w=$winname(0,1)/q $S_value
	labelname=S_value
	updatelabel+=((stringmatch(s_value,AxisLabelText(winname(0,1),labelname))==0))
	UpdateControl("SetVariable", "PLOT_BOTTOM_MIN","value",(V_min),"","GraphControl","_NUM:")
	UpdateControl("SetVariable", "PLOT_BOTTOM_MIN","width",round(strlen(num2str(V_min))*4+27),"","GraphControl","")
	UpdateControl("SetVariable", "PLOT_BOTTOM_MAX","value",(V_max),"","GraphControl","_NUM:")
	UpdateControl("SetVariable", "PLOT_BOTTOM_MAX","width",round(strlen(num2str(V_max))*4+27),"","GraphControl","")
	UpdateControl("SetVariable", "PLOT_BOTTOM_LABEL","value",nan,"\""+AxisLabel(winname(0,1),labelname)+"\"","GraphControl","_str:")
	UpdateControl("checkbox", "PLOT_BOTTOM_MODE_LINEAR","value",numberbykey("log(x)",axisinfo("",s_value),"=")==0,"","GraphControl","")
	UpdateControl("checkbox", "PLOT_BOTTOM_MODE_LOG","value",numberbykey("log(x)",axisinfo("",s_value),"=")==1,"","GraphControl","")
	UpdateControl("checkbox", "PLOT_BOTTOM_MODE_LOG2","value",numberbykey("log(x)",axisinfo("",s_value),"=")==2,"","GraphControl","")
	if(stringmatch(axisbottom,AxisLabel(winname(0,1),labelname))==0)
	 	axisbottom=AxisLabel(winname(0,1),labelname)
	endif
	controlinfo/w=GraphControl PLOT_AXIS_LEFT
	getaxis/w=$winname(0,1)/q $S_value
	labelname=S_value	
	updatelabel+=((stringmatch(s_value,AxisLabel(winname(0,1),labelname))==0))
	UpdateControl("SetVariable", "PLOT_LEFT_MIN","value",(V_min),"","GraphControl","_NUM:")
	UpdateControl("SetVariable", "PLOT_LEFT_MIN","width",round(strlen(num2str(V_min))*4+27),"","GraphControl","")
	UpdateControl("SetVariable", "PLOT_LEFT_MAX","value",(V_max),"","GraphControl","_NUM:")
	UpdateControl("SetVariable", "PLOT_LEFT_MAX","width",round(strlen(num2str(V_max))*4+27),"","GraphControl","")
	UpdateControl("SetVariable", "PLOT_LEFT_LABEL","value",nan,"\""+AxisLabel(winname(0,1),labelname)+"\"","GraphControl","_str:")
	UpdateControl("checkbox", "PLOT_LEFT_MODE_LINEAR","value",numberbykey("log(x)",axisinfo("",s_value),"=")==0,"","GraphControl","")
	UpdateControl("checkbox", "PLOT_LEFT_MODE_LOG","value",numberbykey("log(x)",axisinfo("",s_value),"=")==1,"","GraphControl","")
	UpdateControl("checkbox", "PLOT_LEFT_MODE_LOG2","value",numberbykey("log(x)",axisinfo("",s_value),"=")==2,"","GraphControl","")

	if(stringmatch(axisleft,AxisLabel(winname(0,1),labelname))==0)
	 	axisleft=AxisLabel(winname(0,1),labelname)
	endif	
	setdatafolder DF
end

//determines if controls needs updating- used to prevent flicker
function UpdateControl(ctrl,name,keyword,var,str,win ,modstr)
	string ctrl,name,keyword,str,win,modstr
	variable var
	dowindow GraphControl
	if(v_flag)
		if((stringmatch(keyword,"width")))
			controlinfo/w=$win $name
			if(v_width!=var)
				execute ctrl+" "+name+",size={"+modstr+num2str(var)+","+num2str(v_height)+"},win="+win
			endif
		else	
			if(numtype(var)==0) //numeric
				controlinfo/w=$win $name
				if(v_value!=var)
					execute ctrl+" "+name+","+keyword+"="+modstr+num2str(var)+",win="+win
				endif
			else	
				if(strlen(str))
						//string
					controlinfo/w=$win $name					
					if(stringmatch(replacestring("\"",str,""),s_value)==0)
						execute ctrl+" "+name+","+keyword+"="+modstr+""+str+",win="+win
					endif
				endif
			endif
		endif
	endif
end

//checks if there is a live update 
function transliveupdate()
	controlinfo/w=GraphControl TRANS_LIVE
	if (v_value)
	 	drawTRANS()
	 endif
end

//starts transparency calculation
function drawTRANS()
	if (strlen(winname(0,1)))
		CtrlNamedBackground TRANS, period=100, proc=DotransparentcyF,dialogsOK=0
		CtrlNamedBackground TRANS, start		
	endif
end
// This is the function that will be called periodically to generate transparency
Function DotransparentcyF(s)		
	STRUCT WMBackgroundStruct &s
	string plotname
	variable grouping,res
	controlinfo/w=GraphControl TRANS_RES
	switch (V_Value)
		case 1:		
			res=0.5
			break
		case 2:		
			res=1
			break
		case 3:		
			res=2
			break
		case 4:		
			res=5
	endswitch
	transparentplot(winname(0,1),res)
	return 1	// Stop
End

Function Dotransparentcy()
	CtrlNamedBackground TRANS, period=100, proc=DotransparentcyF,dialogsOK=0
	CtrlNamedBackground TRANS, start
End

function settransparams(tval)
	variable tval
	string DF=getdatafolder(1)
	setdatafolder root:graphcontrol:	
	variable	tnum
	wave listselect
	for (tnum=0;tnum<dimsize(listselect,0);tnum+=1)
		if (listselect[tnum][0])
			setTdata(stringfromlist(tnum,TraceNameList("", ";", 1 )),"transparent",tval)
		endif
	endfor
	setdatafolder DF
end

//--------------------error bars functions----------------------//
function/s EBdata(type,help)
	string type,help
	help=stringbykey(type,help,"=",";")
	help=replacestring("(",help,"")
	help=replacestring(")",help,"")	
	return help
end	

//update error bars according to selected trace
function updateerrorbars(info,tracename,docapbar)
	string info,tracename
	variable docapbar
	string DF=getdatafolder(1)
	setdatafolder root:graphcontrol:		
	svar disablelist
	string st,yp="",yn="",xp="",xn="",help=""
	st=stringbykey("ERRORBARS",info,":",";")
	st=replacestring("ERRORBARS",st,"")	
	if(docapbar)
		if(numtype(numberbykey("/T",st,"="))==0)
			UpdateControl("SetVariable", "ERROR_CAPH","value",numberbykey("/T",st,"="),"","GraphControl","_Num:")
		endif
		if(numtype(numberbykey("/Y",st,"="))==0)
			UpdateControl("SetVariable", "ERROR_CAPW","value",numberbykey("/Y",st,"="),"","GraphControl","_Num:")
		endif
		if(numtype(numberbykey("/L",st,"="))==0)
			UpdateControl("SetVariable", "ERROR_BAR","value",numberbykey("/L",st,"="),"","GraphControl","_Num:")
		endif
	endif
	st=replacestring(tracename+" ",st,"")
	variable del=strsearch(st,"X",0)
	if(del==-1)
		del=strsearch(st,"Y",0)
	endif
	st=replacestring(st[0,del-1],st,"")

	if (stringmatch(st,"XY*"))
		st=replacestring(",wave",st,";xwave",0,1)	
		st=replacestring(",wave",st,";ywave",0,1)	
	else
		if (stringmatch(st,"Y*"))
			st=replacestring(",wave",st,";ywave",0,1)	
		else			
			st=replacestring(",wave",st,";xwave",0,1)	
		endif
	endif
	yp=stringfromlist(0,EBdata("ywave",st),",")
	yn=stringfromlist(1,EBdata("ywave",st),",")
	xp=stringfromlist(0,EBdata("xwave",st),",")
	xn=stringfromlist(1,EBdata("xwave",st),",")
	UpdateControl("SetVariable", "ERROR_YP","value",nan,"\""+yp+"\"","GraphControl","_STR:")
	UpdateControl("SetVariable", "ERROR_YN","value",nan,"\""+yn+"\"","GraphControl","_STR:")
	UpdateControl("SetVariable", "ERROR_XP","value",nan,"\""+xp+"\"","GraphControl","_STR:")
	UpdateControl("SetVariable", "ERROR_XN","value",nan,"\""+xn+"\"","GraphControl","_STR:")
	UpdateControl("CheckBox", "ERROR_XP_CHECK","value",0,"","GraphControl","")
	UpdateControl("CheckBox", "ERROR_XN_CHECK","value",1,"","GraphControl","")
	if(strlen(stringbykey("XWAVE",info,":",";"))==0)
		disablelist+="ERROR_XP;"
		disablelist+="ERROR_XN;"
		disablelist+="ERROR_XP_CHECK;"
		disablelist+="ERROR_XN_CHECK;"
		disablelist+="ERROR_X;"
	endif	
	setdatafolder DF
end

//reads the error bar information to controls
function errobars_update(controlname,docapbar)
	string controlname
	variable docapbar
	setdatafolder root:DFselect:	
	svar wavesel,savedDF
	setdatafolder root:graphcontrol:	
	wave listselect
	variable tnum,tracesnum=1
	setdatafolder savedDF
	
	updateerrorbars(traceinfo("",stringfromlist(gettracenumber(-1),TraceNameList("", ";", 1 ))	,0),stringfromlist(gettracenumber(-1),TraceNameList("", ";", 1 )),docapbar)	
	if(strlen(controlname))
		SetVariable $replacestring("_CHECK",controlname,"") win=graphcontrol,value= _STR:wavesel
	endif
	string st="",yp="",yn="",xp="",xn="",xwaves="",ywaves="",cap="",bar=""
	controlinfo/w=graphcontrol ERROR_YP
	yp=s_value	
	controlinfo/w=graphcontrol ERROR_YN
	yn=s_value
	controlinfo/w=graphcontrol ERROR_XP
	xp=s_value
	controlinfo/w=graphcontrol ERROR_XN
	xn=s_value
	controlinfo/w=graphcontrol ERROR_CAPH
	cap="/T="+num2str(v_value)	
	controlinfo/w=graphcontrol ERROR_CAPW
	cap+="/Y="+num2str(v_value)	
	controlinfo/w=graphcontrol ERROR_BAR
	bar="/L="+num2str(v_value)
	if((strlen(xp)||(strlen(xn)))&&(V_disable==0))
		st="X"
		xwaves=", wave=( "+xp+","+xn+")"
	endif
	if(strlen(yp)||(strlen(yn)))
		st+="Y"
		ywaves=", wave=( "+yp+","+yn+")"
	endif
	st+=xwaves+ywaves
	if(strlen(st)==0)
		st="OFF"
	endif
	for (tnum=0;tnum<dimsize(listselect,0);tnum+=1)
		if (listselect[tnum][0])
			execute "errorbars "+cap+bar+" "+stringfromlist(tnum,TraceNameList("", ";", 1 ))+" "+st
			print "errorbars "+cap+bar+" "+stringfromlist(tnum,TraceNameList("", ";", 1 ))+" "+st
		endif
	endfor	
End

//*************************************************************CONTROLS*********************************************//
Function TRACE_PARAMS(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	changetraceparams(ctrlName,popNum,popStr)
End
Function TRACE_CHECK(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	changetraceparams(ctrlName,checked,"")
End
Function TRACE_VAR(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	changetraceparams(ctrlName,varNum,varStr)
End

//updates the selected traces according to the selected control
function changetraceparams(ctrlName,Num,Str)
	String ctrlName
	Variable Num
	String Str
	string DF=getdatafolder(1)
	setdatafolder root:graphcontrol:
	variable tnum
	wave listselect
	for (tnum=0;tnum<dimsize(listselect,0);tnum+=1)
		if (listselect[tnum][0])
			string tracename=stringfromlist(tnum,TraceNameList("", ";", 1 ))	
			if (stringmatch(ctrlName,"*mode"))//mode style
				ModifyGraph mode($tracename)=Num-1			
				//update the display according to selected mode
				if((Num==6)||(Num==8))//bars,fill to zero
					setTdata(tracename,"dotransfill",0)
				endif							
			endif
			if (stringmatch(ctrlName,"*col"))//color
				execute "ModifyGraph rgb("+tracename+")="+Str
			endif	
			if (stringmatch(ctrlName,"*marker"))//marker type
				ModifyGraph marker($tracename)=Num-1
			endif		
			if (stringmatch(ctrlName,"*filltypeplus"))//fill type+
				ModifyGraph hbFill($tracename)=Num-1
			endif
			if (stringmatch(ctrlName,"*filltypeneg"))//fill type-
				ModifyGraph useNegPat($tracename)=(num>1)
				ModifyGraph hBarNegFill($tracename)=Num-2
			endif			
			if (stringmatch(ctrlName,"*fillcolorplus"))//fill color check
				ModifyGraph usePlusRGB($tracename)=Num
			endif
			if (stringmatch(ctrlName,"*fillcolorneg"))//fill color check
				ModifyGraph usenegRGB($tracename)=Num
			endif
			if (stringmatch(ctrlName,"*colfillplus"))//fill color 
				execute "ModifyGraph plusRGB("+tracename+")="+Str
				CheckBox TRACE_FILLCOLORplus value=1,win=GraphControl
				ModifyGraph usePlusRGB($tracename)=1
			endif													
			if (stringmatch(ctrlName,"*colfillneg"))//fill color 
				execute "ModifyGraph negRGB("+tracename+")="+Str
				CheckBox TRACE_FILLCOLORneg value=1,win=GraphControl
				ModifyGraph usenegRGB($tracename)=1
			endif													
			if (stringmatch(ctrlName,"*line"))//linestyle
				ModifyGraph lstyle($tracename)=Num-1
			endif	
			if (stringmatch(ctrlName,"*linesize"))//line size
				ModifyGraph lsize($tracename)=Num
			endif				
			if (stringmatch(ctrlName,"*MARKERSIZE"))//mode style
				ModifyGraph msize($tracename)=Num
			endif
			if (stringmatch(ctrlName,"*thick"))//stroke thick style
				ModifyGraph mrkThick($tracename)=Num
			endif	
			if (stringmatch(ctrlName,"*COLSTROKE"))//stroke color style
				ModifyGraph useMrkStrokeRGB($tracename)=1
				execute "ModifyGraph mrkStrokeRGB("+tracename+")="+Str
				CheckBox TRACE_MARKERSTROKE value=1,win=GraphControl
			endif	
			if (stringmatch(ctrlName,"*STROKE"))//stroke
				ModifyGraph useMrkStrokeRGB($tracename)=Num
			endif	
			if (stringmatch(ctrlName,"*opaque"))//stroke
				ModifyGraph opaque($tracename)=Num
			endif																			
		endif
	endfor
	setdatafolder DF		
end

//removes selected trace(s)
Function TRACEREMOVE(ctrlName) : ButtonControl
	String ctrlName
	string DF=getdatafolder(1)
	setdatafolder root:graphcontrol:	
	variable	tnum,i
	wave listselect
	svar recreation
	string st=""
	for (tnum=0;tnum<dimsize(listselect,0);tnum+=1)
		if (listselect[tnum][0])
			st+=stringfromlist(tnum,TraceNameList("", ";", 1 ))+","
		endif
	endfor
	execute "removefromgraph "+removeending(st)
	updateTuserdata()
	transliveupdate()
	updatetracelist(0)
	setdatafolder DF
End

//adds a new trace
Function TRACEAPPEND(ctrlName) : ButtonControl
	String ctrlName	
	string DF=getdatafolder(1)
	setdatafolder root:graphcontrol:	
	variable	found=0,tnum
	DFdialog("","appendtographdialog()",1,-1,1,1)
	setdatafolder DF
End

//opens a dialog to select a wave
function appendtographdialog()
	string DF=getdatafolder(1)
	setdatafolder root:DFselect:
	svar wavesel
	//if(strlen(wavesel))
	variable i
	for (i=0;i<itemsinlist(wavesel);i+=1)
		appendtograph $stringfromlist(i,wavesel)
	endfor
	//endif
	setdatafolder DF
end

//copies the trace appearance information
Function INFOCOPY(ctrlName) : ButtonControl
	String ctrlName
	string DF=getdatafolder(1)
	setdatafolder root:graphcontrol:	
	variable	found=0,tnum
	wave listselect
	for (tnum=0;tnum<dimsize(listselect,0);tnum+=1)
		if ((listselect[tnum][0])&&(found==0))
			string tracename=stringfromlist(tnum,TraceNameList("", ";", 1 ))
			string info=traceinfo("",tracename,0)
			found=1
			string/g recreation=replacestring("RECREATION:",info[strsearch(info,"RECREATION",0),strlen(info)-1],"")
			variable/g transrecreation=getTdata(tracename,"dotransfill")*1000+getTdata(tracename,"transparent")+getTdata(tracename,"transgroup")*10000
		endif
	endfor
	setdatafolder DF
End

//pastes trace info saved before
Function INFOPASTE(ctrlName) : ButtonControl
	String ctrlName
	string DF=getdatafolder(1)
	setdatafolder root:graphcontrol:	
	variable	tnum,i
	wave listselect
	svar recreation
	nvar transrecreation
	string st
	for (tnum=0;tnum<dimsize(listselect,0);tnum+=1)
		if (listselect[tnum][0])
			string tracename=stringfromlist(tnum,TraceNameList("", ";", 1 ))
			setTdata(tracename,"transparent",mod(transrecreation,1000))
			setTdata(tracename,"dotransfill",floor(mod(transrecreation,10000)/1000))
			setTdata(tracename,"transgroup",floor(transrecreation/10000))
			for(i=0;i<itemsinlist(recreation,";");i+=1)
				execute "ModifyGraph "+replacestring("(x)",stringfromlist(i,recreation),"("+tracename+")")		
			endfor
			execute "updatetracecontrols("+num2str(tnum)+")"
		endif
	endfor
	drawTRANS()
	setdatafolder DF
End

//copies trace  for other graphs
Function TRACECOPY(ctrlName) : ButtonControl
	String ctrlName
	string DF=getdatafolder(1)
	setdatafolder root:graphcontrol:	
	variable	tnum
	wave listselect
	make/o/t/n=0 tracecopyrecreation ,tracecopyY
	make/o/n=0 tracetranscopy
	for (tnum=0;tnum<dimsize(listselect,0);tnum+=1)
		if (listselect[tnum][0])
			string tracename = stringfromlist(tnum,TraceNameList("", ";", 1 ))
			insertpoints 0,1,tracecopyrecreation,tracecopyY,tracetranscopy
			tracecopyrecreation[0]=traceinfo("",tracename,0)
			tracecopyY[0]=GetWavesDataFolder(WaveRefIndexed("", tnum, 1 ),2)
			tracetranscopy[0]=getTdata(tracename,"dotransfill")*1000+getTdata(tracename,"transparent")+getTdata(tracename,"transgroup")*10000
		endif
	endfor
	setdatafolder DF
End

//paste the selected traces, used to duplicate traces to the same or other plots
function pastetrace(laxisname,baxisname)
	string laxisname,baxisname
	string DF=getdatafolder(1)
	setdatafolder root:graphcontrol:	
	wave/t  tracecopyrecreation ,tracecopyY
	wave tracetranscopy,listselect
	variable	tnum,location=itemsinlist(TraceNameList("", ";", 1 )),i
	string recreation,laxis,baxis,tracename="",newtrace
	for (tnum=0;tnum<dimsize(listselect,0);tnum+=1)
		if(listselect[tnum][0]==1)
			location=tnum
			tracename=stringfromlist(tnum,tracenamelist("",";",1))
		endif
	endfor
	for (tnum=0;tnum<numpnts(tracecopyY);tnum+=1)
		location+=1
		if(strlen(laxisname)==0)
			laxisname=stringbykey("YAXIS",tracecopyrecreation[tnum],":")
		endif
		if (stringmatch(laxisname,"*right*"))
			laxis="/R="+laxisname
		else
			laxis="/L="+laxisname
		endif
		if(strlen(baxisname)==0)
			baxisname=stringbykey("XAXIS",tracecopyrecreation[tnum],":")
		endif		
		if (stringmatch(baxisname,"*top*"))
			baxis="/T="+baxisname
		else
			baxis="/B="+baxisname
		endif		
		if(strlen(stringbykey("XWAVE",tracecopyrecreation[tnum],":")))
			execute "appendtograph "+laxis+baxis+" "+ tracecopyY[tnum]+" vs "+(stringbykey("XWAVEDF",tracecopyrecreation[tnum],":"))+(stringbykey("XWAVE",tracecopyrecreation[tnum],":"))
		else
			execute "appendtograph "+laxis+baxis +" "+ tracecopyY[tnum]
		endif
		string newtracename=stringfromlist(itemsinlist(TraceNameList("", ";", 1 ))-1,TraceNameList("", ";", 1 ))
		setTdata(newtracename,"transparent",mod(tracetranscopy[tnum],1000))
		setTdata(newtracename,"dotransfill",floor(mod(tracetranscopy[tnum],10000)/1000))
		setTdata(newtracename,"transgroup",floor(tracetranscopy[tnum]/10000))		
		if (strlen(tracename))
			 reordertraces $tracename, {$newtracename}
		endif
		updatetracelist(0)
		recreation=tracecopyrecreation[tnum]
		recreation=replacestring("RECREATION:",recreation[strsearch(recreation,"RECREATION",0),strlen(recreation)-1],"")
		for(i=0;i<itemsinlist(recreation,";");i+=1)
			execute "ModifyGraph "+replacestring("(x)",stringfromlist(i,recreation),"("+stringfromlist(location-1,TraceNameList("", ";", 1 ))+")")		
		endfor
	endfor	
	updatetracelist(0)		
	execute "updatetracecontrols(-1)"
	execute/q /p "transliveupdate()"
	setdatafolder DF
end

//pastes traces saved before
Function TRACE_PASTE(ctrlName) : ButtonControl
	String ctrlName
	pastetrace("","")
End

//transparency slider value
Function TRANS_SLIDER(ctrlName,sliderValue,event) : SliderControl
	String ctrlName
	Variable sliderValue
	Variable event	
	if(event %& 0x1)	
		SetVariable TRACE_TRANS_VAR value= _NUM:sliderValue,win=GraphControl
		settransparams(sliderValue)
		transliveupdate()
	endif	
	return 0
End

//transparency  value
Function TRANS_VAR(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	Slider TRACE_TRANS_SLIDER value=varnum,win=GraphControl
	settransparams(varnum)
	transliveupdate()
End

Function TRANSUPDATE(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	transliveupdate()
End

//user decides whether to use an image or a drawing for transparency
Function TRANSSELECT(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	string DF=getdatafolder(1)
	setdatafolder root:graphcontrol:		
	variable/g image0drawing1
	if(stringmatch(ctrlName,"*drawing*"))
	 	CheckBox TRANS_IMAGE value=0,win=GraphControl	
	 	image0drawing1=1
	endif
	if(stringmatch(ctrlName,"*image*"))
	 	image0drawing1=0	
	 	CheckBox TRANS_DRAWING value=0,win=GraphControl		
	endif
	transliveupdate()
	setdatafolder DF
End

//selected traces will be transparent
Function TRANS_DOFILL(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	string DF=getdatafolder(1)
	setdatafolder root:graphcontrol:	
	variable	tnum
	wave listselect
	for (tnum=0;tnum<dimsize(listselect,0);tnum+=1)
		if (listselect[tnum][0])
			setTdata(stringfromlist(tnum,TraceNameList("", ";", 1 )),"dotransfill",checked)
		endif
	endfor
	transliveupdate()

	setdatafolder DF
End

//resolution
Function TRANSRES(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	transliveupdate()
End

//transparency type 1-to next,2-to zero, 3-to bottom
Function TRANSP_GROUP(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	string DF=getdatafolder(1)
	setdatafolder root:graphcontrol:	
	variable	tnum
	wave listselect
	for (tnum=0;tnum<dimsize(listselect,0);tnum+=1)
		if (listselect[tnum][0])
			setTdata(stringfromlist(tnum,TraceNameList("", ";", 1 )),"transgroup",popnum)
		endif
	endfor
	transliveupdate()
	setdatafolder DF
End

//manual transparency update
Function TRANS_UPDATE(ctrlName) : ButtonControl
	String ctrlName
	 drawTRANS()
End

//update of the plot and axis parameters
Function PLOTSIZE(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	variable minval,maxval
	string side="print 0" ,st
	if(stringmatch(ctrlName,"*left*"))
		side="ModifyGraph/w="+winname(0,1)+" margin(left)="+varstr
		side="ModifyGraph margin(left)="+varstr
	endif
	if(stringmatch(ctrlName,"*top*"))
		side="ModifyGraph/w="+winname(0,1)+" margin(top)="+varstr
		side="ModifyGraph margin(top)="+varstr
	endif
	if(stringmatch(ctrlName,"*bottom*"))
		side="ModifyGraph/w="+winname(0,1)+" margin(bottom)="+varstr
		side="ModifyGraph margin(bottom)="+varstr
	endif
	if(stringmatch(ctrlName,"*right*"))
		side="ModifyGraph/w="+winname(0,1)+" margin(right)="+varstr
		side="ModifyGraph margin(right)="+varstr
	endif	
	if(stringmatch(ctrlName,"*sizev"))
		side="ModifyGraph/w="+winname(0,1)+" height="+varstr
		side="ModifyGraph height="+varstr
	endif		
	if(stringmatch(ctrlName,"*sizeh"))
		side="ModifyGraph/w="+winname(0,1)+" width="+varstr
		side="ModifyGraph width="+varstr
	endif		
	if(stringmatch(ctrlName,"*bottom_max*"))
		controlinfo/w=GraphControl PLOT_AXIS_BOTTOM
		getaxis/w=$winname(0,1)/q $S_value
		side="SetAxis  /w="+winname(0,1)+" "+S_value+" "+num2str(V_min)+" ,"+varstr
		side="SetAxis "+S_value+" "+num2str(V_min)+" ,"+varstr
	endif
	if(stringmatch(ctrlName,"*bottom_min*"))
		controlinfo/w=GraphControl PLOT_AXIS_BOTTOM
		getaxis/w=$winname(0,1)/q $S_value
		side="SetAxis  /w="+winname(0,1)+" "+S_value+" "+varstr+","+num2str(V_max)
		side="SetAxis "+S_value+" "+varstr+","+num2str(V_max)
	endif	
	if(stringmatch(ctrlName,"*left_max*"))
		controlinfo/w=GraphControl PLOT_AXIS_LEFT
		getaxis/w=$winname(0,1)/q $S_value
		side="SetAxis  /w="+winname(0,1)+" "+S_value+" "+num2str(V_min)+" ,"+varstr
		side="SetAxis "+S_value+" "+num2str(V_min)+" ,"+varstr
	endif
	if(stringmatch(ctrlName,"*left_min*"))
		controlinfo/w=GraphControl PLOT_AXIS_LEFT
		getaxis/w=$winname(0,1)/q $S_value
		side="SetAxis  /w="+winname(0,1)+" "+S_value+" "+varstr+","+num2str(V_max)
		side="SetAxis  "+S_value+" "+varstr+","+num2str(V_max)
	endif	
		
	if (strlen(winname(0,1)))
		execute side
		print side	//user can then use the command window to duplicate commans
		transliveupdate()
		updateplotparams()		
	endif
End

//selection of an axis
Function PLOTAXISSEL(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	updateplotparams()
End

//selects the vertical or the horizontal axes
function/s getaxistype(left0bottom1)
	variable left0bottom1
	variable i
	string result=""
	for(i=0;i<itemsinlist(axislist(winname(0,1)));i+=1)
		if((stringmatch( stringbykey("AXTYPE",AxisInfo(winname(0,1), stringfromlist(i,axislist(winname(0,1)))) ,":"),"*left*")) ||(stringmatch( stringbykey("AXTYPE",AxisInfo(winname(0,1), stringfromlist(i,axislist(winname(0,1)))) ,":"),"*right*")))
			if((left0bottom1==0)&&(stringmatch(stringfromlist(i,axislist(winname(0,1))),"*limage*")==0))
				result+=stringfromlist(i,axislist(winname(0,1)))+";"
			endif
		endif
		if((stringmatch( stringbykey("AXTYPE",AxisInfo(winname(0,1), stringfromlist(i,axislist(winname(0,1)))) ,":"),"*bottom*")) ||(stringmatch( stringbykey("AXTYPE",AxisInfo(winname(0,1), stringfromlist(i,axislist(winname(0,1)))) ,":"),"*top*")))
			if((left0bottom1==1)&&(stringmatch(stringfromlist(i,axislist(winname(0,1))),"*bimage*")==0))
				result+=stringfromlist(i,axislist(winname(0,1)))+";"
			endif
		endif
	endfor
	return result
end

function adderrorbar(ctrlName,checked,tnum)
	String ctrlName
	Variable checked,tnum
	controlinfo/w=graphcontrol $replacestring("_CHECK",ctrlName,"")
	string info =traceinfo("",stringfromlist(tnum,TraceNameList("", ";", 1 ))	,0)	
	info=stringbykey("ERRORBARS",info,":",";")
	//print info
end

//opens a dialog for new error bars
Function ERRORBARS_CHECK(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	CheckBox $ctrlName value=1-checked	, win=graphcontrol	
	if(gettracenumber(-1)>=0)
		setdatafolder root:graphcontrol:			
		controlinfo/w=graphcontrol $replacestring("_CHECK",ctrlName,"")
		string DFnew=""
		if (strsearch(s_value,":",1))
		 	DFnew=s_value[0,strsearch(s_value,":",1)]
		endif
	 
		DFdialog(DFnew,"errobars_update(\""+ctrlName+"\",1)",1,numpnts(WaveRefIndexed("", gettracenumber(-1),1)),1,0)
	endif
end	

//updates error bars
Function ERR_VISUAL(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	errobars_update("",0)
End

//copies the plot and axis information
Function PLOTINFOCOPY(ctrlName) : ButtonControl
	String ctrlName
	string DF=getdatafolder(1)
	setdatafolder root:graphcontrol:	
	make/o/n=6 plotval
	make/t/o/n=(0,3) axesval
	variable i
	for (i=0;i<itemsinlist(AxisList("" ));i+=1)
		insertpoints/m=0 0,1, axesval
		axesval[0][0]=stringfromlist(i,axislist(""))
		axesval[0][1]=AxisInfo("", axesval[0][0])
		axesval[0][2]=AxisLabelText(winname(0,1),axesval[0][0])
	endfor	
	controlinfo /w=GraphControl PLOT_LEFT
	plotval[0]=v_value
	controlinfo /w=GraphControl PLOT_RIGHT
	plotval[1]=v_value
	controlinfo /w=GraphControl PLOT_TOP
	plotval[2]=v_value
	controlinfo /w=GraphControl PLOT_BOTTOM
	plotval[3]=v_value
	controlinfo /w=GraphControl PLOT_SIZEH
	plotval[4]=v_value
	controlinfo /w=GraphControl PLOT_SIZEV
	plotval[5]=v_value		
	setdatafolder DF
End

//paste plot and axis information
Function PLOTINFOPASTE(ctrlName) : ButtonControl
	String ctrlName
	string DF=getdatafolder(1)
	setdatafolder root:graphcontrol:	
	wave plotval
	wave/t  axesval	
	variable i,items
	for (i=0;i<dimsize(axesval,0);i+=1)	
		if (whichlistitem(axesval[i][0],AxisList("" ))>=0)//axis exists
			execute stringbykey("SETAXISCMD", axesval[i][1],":")
			string info=axesval[i][1]
			string recreation=replacestring("RECREATION:",info[strsearch(info,"RECREATION",0),strlen(info)-1],"")
			for (items=0;items<itemsinlist(recreation);items+=1)
				execute "ModifyGraph "+ReplaceString("(x)",stringfromlist(items,recreation),"("+axesval[i][0]+")",1)	
			endfor	
			label $axesval[i][0] axesval[i][2]
		endif
	endfor
	ModifyGraph/w=$winname(0,1) margin(left)=plotval[0],margin(right)=plotval[1],margin(top)=plotval[2],margin(bottom)=plotval[3],width=plotval[4],height=plotval[5]
	setdatafolder DF
End

//changes plot label
Function PLOT_LABEL(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	if(stringmatch(ctrlName,"*bottom*"))
		controlinfo/w=GraphControl PLOT_AXIS_BOTTOM
	else
		controlinfo/w=GraphControl PLOT_AXIS_LEFT
	endif
	getaxis/w=$winname(0,1)/q $S_value	
 	label $S_value varStr 
End

//selects a new axis mode -linear,log,log2
Function PLOTAXISMODE(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	string axname="BOTTOM"
	controlinfo/w=GraphControl PLOT_AXIS_BOTTOM
	if(stringmatch(ctrlName,"*left*"))
		axname="LEFT"
		controlinfo/w=GraphControl PLOT_AXIS_LEFT
	endif
	if(stringmatch(ctrlName,"*linear*"))
		ModifyGraph log($s_value)=0
	endif
	if(stringmatch(ctrlName,"*log"))
		ModifyGraph log($s_value)=1
	endif
	if(stringmatch(ctrlName,"*log2"))
		ModifyGraph log($s_value)=2
	endif
End

Function AUTOAXIS(ctrlName) : ButtonControl
	String ctrlName
	if((stringmatch(ctrlName,"*left*")))
		controlinfo/w=GraphControl PLOT_AXIS_LEFT
	else
		controlinfo/w=GraphControl PLOT_AXIS_BOTTOM
	endif
	getaxis/w=$winname(0,1)/q $S_value
	if((stringmatch(ctrlName,"*auto_min*")))
		setaxis $S_value *,v_max
		print "setaxis "+S_value+" *,"+num2str(v_max)
	endif
	if((stringmatch(ctrlName,"*auto_max")))
		setaxis $S_value v_min,*
		print "setaxis "+S_value+" "+num2str(v_min)+",*"
	endif
End

//unshows or shows the selected axis
Function AXISHIDE(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	if((stringmatch(ctrlName,"*left*")))
		controlinfo/w=GraphControl PLOT_AXIS_LEFT
	else
		controlinfo/w=GraphControl PLOT_AXIS_BOTTOM
	endif
	if(checked)
		ModifyGraph nticks($S_value)=0,axThick($S_value)=0
	else
		ModifyGraph nticks($S_value)=5,axThick($S_value)=1
	endif
End

//find the label of the axis
Function/S AxisLabel(graphName, axisName, [SuppressEscaping])
	String graphName, axisName
	Variable SuppressEscaping
	
	if (ParamIsDefault(SuppressEscaping))
		SuppressEscaping = 0
	endif
	
	String axisLabel=""
	String info= WinRecreation(graphName,0)
	Variable start= strsearch(info, "Label "+axisName+" ", 0)
	if( start >= 0 )
		start = strsearch(info, "\"", start)+1
		Variable theEnd= strsearch(info, "\"", start)-1
		axisLabel= info[start,theEnd]
	endif
	if (SuppressEscaping)
		start = 0
		do
			start = strsearch(axisLabel, "\\\\", start)	// search for double backslash
			if (start >= 0)
				string newLabel = axisLabel[0,start-1]
				newLabel += axisLabel[start+1, strlen(axisLabel)-1]
				axisLabel = newLabel
			else
				break
			endif
		while(1)
	endif
	return axisLabel
End

//user selection on tracelist listbox
Function TRACELIST(LB_Struct) : ListBoxControl
	STRUCT WMListboxAction &LB_Struct
	Variable row=LB_Struct.row
	Variable col=LB_Struct.col
	Variable event=LB_Struct.eventcode	
	
	string DF=getdatafolder(1)
	setdatafolder root:graphcontrol:
	wave listcolselect,listselect 
	wave/t listcol	,listtext,listtitle
	wave/wave ywaveref,xwaveref

	variable i,tnum,found
	variable/g selectedrow
	wave selectrows
	if ((event==1)&&(row>=-1))//mouse down, used for reorder	,replace waves
		if(row<0)//header
			if(LB_Struct.eventMod==16)//right mouse click
				string listdata="\\M1"
				for(i=0;i<numpnts(listcol);i+=1)
					listdata+=listcol[i]
					if(listcolselect[i])
						listdata+="!"+ num2char(18)
					endif
					listdata+=";\\M1"
				endfor
				PopupContextualMenu listdata
				if(V_flag>0)
					listcolselect[V_flag-1]=1-listcolselect[V_flag-1]
					execute/p/q "updatetracelist(0)"
				endif
			else //left mouse click
				listselect=floor(listselect/2)*2+1-mod(listselect,2)
			endif
		else	//main body
			selectedrow=-1
			if(LB_Struct.eventMod==16)//right mouse click,replace
				if(stringmatch(listtitle[col],"Y axis"))
					PopupContextualMenu getaxistype(0)
					tracecopy("")
					traceremove("")
					if(row<dimsize(listselect,0))
						listselect[row][0]=floor(listselect[row][0]/2)*2+1
					endif
					pastetrace(stringfromlist(V_flag-1,getaxistype(0)),"")
				endif
				if(stringmatch(listtitle[col],"X axis"))
					PopupContextualMenu getaxistype(1)
					tracecopy("")
					traceremove("")
					if(row<dimsize(listselect,0))
						listselect[row][0]=floor(listselect[row][0]/2)*2+1
					endif
					pastetrace("",stringfromlist(V_flag-1,getaxistype(1)))
				endif
				if(stringmatch(listtitle[col],"Y wave"))
					PopupContextualMenu "Edit;Replace"
					if(V_flag==1)
						editwaves(row)
					endif
					if(V_flag==2)
						DFdialog(DF,"replacewavedialog(\""+listtext[row][col]+"\",0)",1,-1,1,0)
					endif
				endif
				if(stringmatch(listtitle[col],"X wave"))
					PopupContextualMenu "Edit;Replace;Remove"
					if(V_flag==1)
						editwaves(row)
					endif
					if((V_flag==2))
						DFdialog(DF,"replacewavedialog(\""+stringfromlist(row,TraceNameList("", ";", 1 ))+"\",1)",1,numpnts(WaveRefIndexed("", row, 1)),1,0)
					endif
					if((V_flag==3))
						execute "ReplaceWave/w="+winname(0,1)+"/X trace="+stringfromlist(row,TraceNameList("", ";", 1 ))+", $\"\" "
						transliveupdate()
					endif
				endif
			else	

			endif
		endif
	endif

	variable mousev
	if (event==2)//mouse up
		if(stringmatch(listtitle[col],"Pos"))
			mousev=LB_Struct.mouseloc.v
			if((mousev-226)-row*16<8)//move up
				if(row>0)	
					reordertraces /w=$winname(0,1) $stringfromlist(row-1,TraceNameList("", ";", 1 )),{$stringfromlist(row,TraceNameList("", ";", 1 ))}
					listselect[row][]=floor(listselect[row][q]/2)*2+1-mod(listselect[row][q],2)
					listselect[row-1][]=floor(listselect[row-1][q]/2)*2+1-mod(listselect[row-1][q],2)			
				endif
			else	//move down
				if(row<dimsize(listselect,0)-1)						
					reordertraces /w=$winname(0,1) $stringfromlist(row,TraceNameList("", ";", 1 )),{$stringfromlist(row+1,TraceNameList("", ";", 1 ))}
					listselect[row][]=floor(listselect[row][q]/2)*2+1-mod(listselect[row][q],2)
					listselect[row+1][]=floor(listselect[row+1][q]/2)*2+1-mod(listselect[row+1][q],2)
				endif
			endif
			execute /p/q "updatetracelist(8)"
			execute/p/q "transliveupdate()"	
		endif
		execute /p/q "updatetracecontrols(-1)"
	endif	

	if ((event==12))//&&(listselect[row][col]==6))//double click
		if(row==43)//add
			TRACEAPPEND("")
		endif
		if((row==127)||(row==43))//delete
			TRACEREMOVE("")
		endif
	endif
	string newwave
	if (event==7)//finish edit double click
		if(stringmatch(listtitle[col],"Y axis"))	
			string axisname=listtext[row][col]
			tracecopy("")
			traceremove("")
			if(row<dimsize(listselect,0))
				listselect[row][0]=floor(listselect[row][0]/2)*2+1
			endif
			pastetrace(axisname,"")
		endif
		if(stringmatch(listtitle[col],"X axis"))	
			axisname=listtext[row][col]
			tracecopy("")
			traceremove("")
			if(row<dimsize(listselect,0))
				listselect[row][0]=floor(listselect[row][0]/2)*2+1
			endif
			pastetrace("",axisname)
		endif		
		if(stringmatch(listtitle[col],"Y wave"))						
			newwave=GetWavesDataFolder(WaveRefIndexed("", row, 1 ),1)+listtext[row][col]
			if(exists(newwave))
				listtext[row][col]=stringfromlist(row,TraceNameList("", ";", 1 ))
			else
				rename $GetWavesDataFolder(WaveRefIndexed("", row, 1 ),2),$listtext[row][col]
			endif		
		endif
		if(stringmatch(listtitle[col],"X wave"))						
			newwave=GetWavesDataFolder(XWaveRefFromTrace("",stringfromlist(row,TraceNameList("", ";", 1 )) ),1)+listtext[row][col]
			if(exists(newwave))
				listtext[row][col]=nameofwave(XWaveRefFromTrace("",stringfromlist(row,TraceNameList("", ";", 1 ))))
			else
				rename $GetWavesDataFolder(XWaveRefFromTrace("",stringfromlist(row,TraceNameList("", ";", 1 ))),2),$listtext[row][col]
			endif		
		endif		
	endif
	setdatafolder DF
	return 0
End


//=============================data folder wave selector===========================//
//=============================data folder wave selector===========================//
//=============================data folder wave selector===========================//
//=============================data folder wave selector===========================//

//opens the selection dialog window
function DFdialog(newDF,stcommand,ndim1,npoint1,wtype1,multiple)
	variable ndim1,npoint1,wtype1,multiple //filter waves by the number of dimensions / points /type (1 num, 2-txt)-1-accept all; multiple-allow multiple selection
	string newDF,stcommand//the datafolder of the requested wave selection
	//the execution command when the user clicks on ok
	if(strlen(newDF)==0)
		newDF="root:"
	endif
	setdatafolder newDF
	string DF=getdatafolder(1)
	newdatafolder/o/s root:DFselect
	string/g savedDF=DF
	string/g wavesel=""
	string/g command=stcommand
	variable/g ndim=ndim1	//1-only 1d waves
	variable/g npoint=npoint1
	variable/g wtype=wtype1
	make/o/n=(1,2) DFselect=0
	make/o/t/n=(1,2) DFname=""
	DFname[0][1]="_None_"	
	setdatafolder DF		
	dowindow/k DataFolderDialog
	//getmouse -can be used on igor 6.3
	GetWindow/z kwFrameOuter wsizeDC
	variable left=v_left,top=v_top
	GetWindow/z kwTopWin wsizeOuter
	v_left+=left+100
	v_top+=top+100
	newpanel/n=DataFolderDialog/FLT=1/k=1/W=(v_left,v_top,v_left+300,v_top+330)as "Select a wave"
	//newpanel/n=DataFolderDialog/FLT=1/k=1/W=(100,100,100+300,100+330) as "Select a wave"
	ListBox DFselect,pos={2,28},size={150,300},proc=DFSELECTListBoxProc
	ListBox DFselect,labelBack=(56576,56576,56576)
	ListBox DFselect,appearance={native,Win},listWave=root:DFselect:DFname
	ListBox DFselect,selWave=root:DFselect:DFselect,mode= 6+multiple*4,widths={11,60}
	PopupMenu DFparents,pos={2,5},size={150,21},bodyWidth=150,proc=DFselctecPopMenuProc
	PopupMenu DFparents,mode=2,popvalue="graphcontrol",value= #"replacestring(\":\",getdatafolder(1),\";\")"
	Button DFOK,pos={160,300},size={60,25},proc=DFOK,title="OK"
	Button DFcancel,pos={226,300},size={60,25},title="Cancel",proc=DFcancel
	Display/W=(157,6,292,288)/HOST=# /N=waveplay
	setwindow DataFolderDialog hook(resize)=DataFolderDialoghook
	ModifyPanel/w=DataFolderDialog fixedSize=0	
	SetActiveSubwindow _endfloat_
	wavesinDF()
end

//hook to resize
Function DataFolderDialoghook(s)
	STRUCT WMWinHookStruct &s
	if(s.eventcode==6)//resize
		getwindow DataFolderDialog wsize
		if(V_bottom-V_top<100)
			getwindow DataFolderDialog wsize
			MoveWindow /w=DataFolderDialog V_left,V_top,V_right,V_top+100					
		endif	
		getwindow DataFolderDialog wsizeDC		
		ListBox DFselect size={150,V_bottom-30},win=DataFolderDialog
		Button DFOK,pos={160,V_bottom-30},win=DataFolderDialog
		Button DFcancel,pos={226,V_bottom-30},win=DataFolderDialog
		MovesubWindow /w=DataFolderDialog#waveplay fnum=(157,6,292,V_bottom-42)							
	endif
end

//gets the wave names in curretn datafolder
Function wavesinDF()
	string DF=getdatafolder(1)
	setdatafolder root:DFselect:
	make/o/n=(1,2) DFselect=0
	make/o/t/n=(1,2) DFname=""
	DFname[0][1]="_None_"

	nvar ndim,npoint,wtype	//modifiers ndim-number of dimentions,npoint-number of points,wtype-type of wave
	setdatafolder DF
	if(itemsinlist(getdatafolder(1),":")>1)
		DFname[0][0]="\\W547"	//can go up
	endif		
	variable numDF=CountObjects("", 4 )
	variable numwave=CountObjects("", 1 )
	variable wnum
	string waveref
	for(wnum=0;wnum<numDF;wnum+=1)
		insertpoints/m=0 dimsize(DFname,0),1, DFname,DFselect
		DFname[dimsize(DFname,0)-1][1]= GetIndexedObjName("", 4, wnum)
		DFname[dimsize(DFname,0)-1][0]= ""
		DFselect[dimsize(DFname,0)-1][0]=64		
	endfor
	for(wnum=0;wnum<numwave;wnum+=1)
		waveref=GetIndexedObjName("", 1, wnum)
		if((WaveType($waveref,1)==wtype )||(wtype==-1))
			if ((ndim==-1)||(WaveDims($waveref)==ndim))
				if((numpnts($waveref)==npoint)||(npoint==-1))
					insertpoints/m=0 dimsize(DFname,0),1, DFname,DFselect
					DFname[dimsize(DFname,0)-1][1]= waveref
					DFname[dimsize(DFname,0)-1][0]= ""
				endif
			endif
		endif
	endfor
//	ListBox DFselect mode=6,selWave=DFselect,win=DataFolderDialog
	PopupMenu DFparents mode=itemsinlist(getdatafolder(1),":"),win=DataFolderDialog	
	DFselectok(0,"")
End

//events that occur when user click the listbox
Function DFSELECTListBoxProc(ctrlName,row,col,event) : ListBoxControl
	String ctrlName
	Variable row
	Variable col
	Variable event	
	string DF=getdatafolder(1)
	setdatafolder root:DFselect:
	wave DFselect
	wave/t  DFname
	variable i
	setdatafolder DF	
	//print col,row,event
	if((event<8)&&(row<dimsize(DFselect,0)))
		if((col==0)&&(row==0)&&(event>0))//go up one level
			DFselect[][]=0
			if(itemsinlist(getdatafolder(1),":")>1)
				setdatafolder ::
			endif
			wavesinDF()
		endif
		if((col==0)&&(row>0)&&(event>0))
			DFselect[][1]=0
			DFselect[row][0]=floor(DFselect[row][0]/2)*2
			DFselect[row][1]=1
		endif
		if((event==2)&&(DFselect[row][col]==80))
			setdatafolder DFname[row][1]
			DFselect[row][1]=0
			wavesinDF()		
		endif
		if((event==3)&&(DFselect[row][0]>0))//double click
			setdatafolder DFname[row][1]
			DFselect[0][1]=0
			wavesinDF()
		endif	
		if(row<dimsize(DFselect,0))
			DFselectok(((DFselect[row][0]==0)&&(DFselect[row][1]>0)),DFname[row][1] )
		endif
	endif
	return 0
End

//can ok button be visible, based on user selection
function DFselectok(ok,trace)
	variable ok
	string trace
	variable i	
	Button DFOK,win=DataFolderDialog, disable=2
	for(i=0;i<itemsinlist(tracenamelist("DataFolderDialog#waveplay",";",1));i+=1)
		removefromgraph/z/w=DataFolderDialog#waveplay $stringfromlist(0,tracenamelist("DataFolderDialog#waveplay",";",1))
	endfor
	if((ok))
		Button DFOK,win=DataFolderDialog, disable=0
		if (stringmatch(trace,"_None_")==0)
			appendtograph/w=DataFolderDialog#waveplay $trace
			ModifyGraph/w=DataFolderDialog#waveplay rgb=(0,0,0)
		endif
	endif
end	

//data folder selection
Function DFselctecPopMenuProc(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	variable i
	string DFname=""
	for(i=0;i<popnum;i+=1)
		DFname+=stringfromlist(i,getdatafolder(1),":")+":"
	endfor
	setdatafolder DFname
	wavesinDF()
End

//ok button
Function DFOK(ctrlName) : ButtonControl
	String ctrlName
	string DF=getdatafolder(1)
	setdatafolder root:DFselect:
	wave DFselect
	wave/t  DFname
	svar wavesel,command
	svar savedDF
	setdatafolder DF			
	variable i	
	killwindow DataFolderDialog
	wavesel=""		
	for(i=0;i<dimsize(DFselect,0);i+=1)
		if(DFselect[i][1])
			if(strlen(wavesel))
				wavesel+=";"
			endif
			wavesel+=getdatafolder(1)+DFname[i][1]
			if(stringmatch(DFname[i][1],"_none_"))
				wavesel=""
			endif
		endif
	endfor
	execute command
End

//cancel button
Function DFcancel(ctrlName) : ButtonControl
	String ctrlName
	killwindow DataFolderDialog
	setdatafolder root:DFselect:
	svar wavesel
	svar savedDF
	wavesel=""
	setdatafolder savedDF	
End

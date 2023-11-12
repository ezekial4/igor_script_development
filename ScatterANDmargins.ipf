#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

Function ScatterAndMarginals(XData,YData)
    Wave XData,YData

    Display YData vs XData
    Make /o/n=25 XHist,YHist // Create histogram waves.    

    GetAxis /Q bottom // Get the limits of the data based on the axis limits.  Use this  
    SetScale x,V_min,V_max,XHist // Use these limits to set the limit of the histogram.  
        Histogram /B=2 XData,XHist // Build this histogram.  
    AppendToGraph/R=XHistAxis XHist // Plot the histogram.  
   
    GetAxis /Q left
        SetScale x,V_min,V_max,YHist
    Histogram /B=2 YData,YHist
    AppendToGraph/VERT/T=YHistAxis YHist
   
        // A bunch of stuff to align the axes and make things look nice.  
       String yDataName=NameOfWave(YData)
    ModifyGraph mode($yDataName)=2,mode(XHist)=5,mode(YHist)=5
    ModifyGraph lSize($yDataName)=2
    ModifyGraph noLabel(XHistAxis)=2,noLabel(YHistAxis)=2
    ModifyGraph axThick(XHistAxis)=0,axThick(YHistAxis)=0
    ModifyGraph freePos(XHistAxis)={0.2,kwFraction}
    ModifyGraph freePos(YHistAxis)={0.2,kwFraction}
    ModifyGraph axisEnab(left)={0,0.8},axisEnab(bottom)={0,0.8}
    ModifyGraph axisEnab(XHistAxis)={0.8,1},axisEnab(YHistAxis)={0.8,1}
End
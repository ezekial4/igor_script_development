#pragma rtGlobals=1		// Use modern global access method.
	
Macro Do_gen_exp_fit(fitname)	
	String fitname = "nev3"
	
	CurveFit/N/Q/W=0/NTHR=0 exp_XOffset  $fitname[pcsr(A),pcsr(B)] /X=$"time_"+fitname /W=$fitname+"_sdev" /I=1 /D 

	Print "Free parameters = " + num2str(v_npnts-5)
	Print "Chisq = " + num2str(v_chisq)
	Print "Reduced chisq = " + num2str(V_chisq/(v_npnts-5))
	
	Variable free_param = v_npnts-5
	Variable Prob = gammq(V_chisq/2,free_param/2)
	String Prob_str = num2str(Prob)
	
	Print "Probablity of exceeding by chance = "+Prob_str
	
	String red_chisq = num2str(V_chisq/(v_npnts-5))
	String leg_str1 = num2str(W_coef[0])
	String leg_str2 = num2str(W_coef[1])
	String leg_str3 = num2str(W_coef[2])
	String leg_str5 = num2str(W_sigma[2])
	String leg_str4 = num2str(W_fitConstants[0])
     
     String LegeName = "CF_"+fitname
       TextBox/C/N=LegeName/F=0/B=(61166,61166,61166)/Y=10/X=15"\\F'Century Gothic'\\JC\\f01Curve Fit Results\r\\f00"
       AppendText/N=LegeName "\\JLModel = y0 + A*exp[-(x-x0)/\\F'Symbol't\\F'Century Gothic'\\Beff\\M]"
	AppendText/N=LegeName "\ty0 \t= " + leg_str1
	AppendText/N=LegeName "\tA  \t= " + leg_str2
	AppendText/N=LegeName  "\t\\F'Symbol't\\F'Century Gothic'\\Beff\\M\t= " + leg_str3 + "  +/-" + leg_str5
	AppendText/N=LegeName  "\tx0\t= " + leg_str4
	AppendText/N=LegeName "\\F'Century Gothic'Reduced\\F'Symbol' c\\F'Century Gothic'\\S2\\M:"	
	AppendText/N=LegeName "\\F'Symbol'         c\\F'Century Gothic'\\S2\\M/\\F'Symbol'n\\F'Century Gothic' = " + red_chisq
	AppendText/N=LegeName "Prob. to exceed \F'Symbol' c\\F'Century Gothic'\\S2\\M by chance = "+Prob_str

EndMAcro
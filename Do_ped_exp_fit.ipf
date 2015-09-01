#pragma rtGlobals=1		// Use modern global access method.

Macro Do_ped_exp_fit()	
	
	CurveFit/N/Q/W=0/NTHR=0 exp_XOffset  neped_cm[pcsr(A),pcsr(B)] /X=time_neped /W=neped_err_cm /I=1 /D 

	Print "Free parameters = " + num2str(v_npnts-5)
	Print "Chisq = " + num2str(v_chisq)
	Print "Reduced chisq = " + num2str(V_chisq/(v_npnts-5))
	
	String red_chisq = num2str(V_chisq/(v_npnts-5))
	
	String leg_str1 = num2str(W_coef[0])
	String leg_str2 = num2str(W_coef[1])
	String leg_str3 = num2str(W_coef[2])
	String leg_str5 = num2str(W_sigma[2])
	String leg_str4 = num2str(W_fitConstants[0])

       TextBox/C/N=CF_neped_cm/F=0/B=(61166,61166,61166)/Y=60/X=15"\\F'Century Gothic'\\JC\\f01neped Curve Fit Results\r\\f00"
       AppendText/N=CF_neped_cm "\\JLModel = y0+A*exp[(x-x0); Z = (x-x0)/\\F'Symbol't\\F'Century Gothic'\\Beff_neped\\M]"
	AppendText/N=CF_neped_cm "\ty0 \t= " + leg_str1
	AppendText/N=CF_neped_cm "\tA  \t= " + leg_str2
	AppendText/N=CF_neped_cm  "\t\\F'Symbol't\\F'Century Gothic'\\Beff_neped\\M\t= " + leg_str3 + "  +/-" + leg_str5
	AppendText/N=CF_neped_cm  "\tx0\t= " + leg_str4
	AppendText/N=CF_neped_cm "\\F'Century Gothic'Reduced\\F'Symbol' c\\F'Century Gothic'\\S2\\M:"	
	AppendText/N=CF_neped_cm "\\F'Symbol'         c\\F'Century Gothic'\\S2\\M/\\F'Symbol'n\\F'Century Gothic' = " + red_chisq	
EndMAcro
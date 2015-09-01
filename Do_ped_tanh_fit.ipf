#pragma rtGlobals=1		// Use modern global access method.

Macro Do_ped_tanh_fit(fitname,alf,x0,A,B,tau)	
	String fitname = "nev3"
	Variable alf=0.0002
	Variable x0=2500
	Variable A=8e12
	Variable B=5e13
	Variable tau=10
	
	Make/D/N=5/O W_coef
	W_coef[0] = {alf,x0,A,B,tau}
	FuncFit/N/Q/NTHR=0 modtanh W_coef  $fitname[pcsr(A),pcsr(B)] /X=$"time_"+fitname /W=$fitname+"_sdev" /I=1 /D 

// to hold tau add: /H="00001"
		
	Print "Free parameters = " + num2str(v_npnts-6)
	Print "Chisq = " + num2str(v_chisq)
	Print "Reduced chisq = " + num2str(V_chisq/(v_npnts-6))
	
	Variable free_param = v_npnts-6
	Variable Prob = gammq(V_chisq/2,free_param/2)
	String Prob_str = num2str(Prob)
	
	Print "Probablity of exceeding by chance = "+Prob_str
	
	String red_chisq = num2str(V_chisq/(v_npnts-5))
	String leg_str1 = num2str(W_coef[0])
	String leg_str2 = num2str(W_coef[2])
	String leg_str3 = num2str(W_coef[4])
	String leg_str5 = num2str(W_sigma[4])
	String leg_str4 = num2str(W_coef[1])
	String leg_str6 = num2str(W_coef[3])
	
	String LegeName = "CF+"+fitname
       TextBox/C/N=LegeName/F=0/B=(61166,61166,61166)/Y=5/X=5"\\F'Century Gothic'\\JC\\f01ModTanh Curve Fit Results\r\\f00"
       AppendText/N=LegeName "\\JLModel = A*(1-\F'Symbol'a\F'Century Gothic'Z)*tanh[Z]+B; Z = (x-x0)/\\F'Symbol't\\F'Century Gothic'\\Beff\\M"
       AppendText/N=LegeName "\t\F'Symbol'a\F'Century Gothic' \t=     " + leg_str1
	AppendText/N=LegeName "\tA  \t=     " + leg_str2
	AppendText/N=LegeName "\tB  \t=     " + leg_str6
	AppendText/N=LegeName  "\t\\F'Symbol't\\F'Century Gothic'\\Beff_neped\\M\t= " + leg_str3 + "  +/-" + leg_str5
	AppendText/N=LegeName  "\tx0\t= " + leg_str4
	AppendText/N=LegeName "\\F'Century Gothic'Reduced\\F'Symbol' c\\F'Century Gothic'\\S2\\M:"	
	AppendText/N=LegeName "\\F'Symbol'         c\\F'Century Gothic'\\S2\\M/\\F'Symbol'n\\F'Century Gothic' = " + red_chisq
	AppendText/N=LegeName "Prob. to exceed \F'Symbol' c\\F'Century Gothic'\\S2\\M by chance = "+Prob_str
EndMAcro
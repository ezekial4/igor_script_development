#pragma rtGlobals=1		// Use modern global access method.

//*********************************************
//	In general, this procedure will find the spline interpolation 
//	points given an input array. 
//	Calls: Spline Fuction -- below this one
//  
//	Input: xa   = input x array
//		    ya   = input y array
//		    y2a = 2nd derivatives of y; gotten form Spline function
//		    x     = needed x-values
//		    nat  = natural boundarys? 0 = not, 1 = yes
//
//	Output: y
//*********************************************

Function Splint(xa,ya,x,nat)
	Wave xa,ya
	Variable x
	Variable nat
	
	Wavestats/Q/W/M=1 xa
	Wave M_WaveStats
	Variable n= M_WaveStats[0]
	Killwaves M_WaveStats
	
	Spline(xa,ya,n,nat,nat)
	Wave y2
	
	Variable k,khi,klo
	Variable a,b,h
	
	klo=1
	khi=n
	
	Do 
		k = (khi+klo)/2
		if(xa[k] > x)
			khi=k
		else
			klo=k
		endif
	While((khi-klo) > 1)

	h=xa[khi-1]-xa[klo-1]
	
	if(h <= 0)
		Abort "Aborted, x-values must be distinct."
	endif

	a=(xa[khi]-x)/h
	b=(x-xa[klo])/h
	
	Variable y
	y=a*ya[klo]+b*ya[khi]+((a^3-a)*y2[klo]+(b^3-b)*y2[khi])*h^2/6
	print x,y
	Killwaves y2
End

//**********************************************
//	This is a function for Spline interpolation taken from Numerical 
//	Recipes in FORTRAN pg. 109
//
//	Inputs: xwave = (array) x values
//		      ywave = (array) y values
//			pnt     = number of points 
//			yp1    = first derivative of first point
//			ypn    = first derivative of last point 
//	 Output: y2      = (array) second derivatives
//**********************************************

Function Spline(xwave,ywave,pnts,yp1,ypn)
	Variable pnts, yp1,ypn
	Wave xwave,ywave

	Variable nmax =500

	Variable p,qn,sig,un
	Make/O/N=(nmax) u
	Make/O/N=(pnts) y2 =0
	
	if (pnts <= 0)
		pnts = 10
	endif	

	if (yp1 == 0)
		y2[0] = 0
		u[0] = 0
	else 
		y2[0] = -0.5
		u[0] = (3/(xwave[1]-xwave[0]))*((ywave[1]-ywave[0])/(xwave[1]-xwave[0])-yp1)
	endif

	Variable i,k
	
	for(i=1;i <= (pnts-2);i+=1)
		sig = (xwave[i]-xwave[i-1])/(xwave[i+1]-xwave[i-1])
		p= sig*y2[i-1]+2
		y2[i]=(sig-1)/p
		u[i]= (6*((ywave[i+1]-ywave[i])/(xwave[i+1]-xwave[i])-(ywave[i]-ywave[i-1])/(xwave[i]-xwave[i-1]))/(xwave[i+1]-xwave[i-1])-sig*u[i-1])/p
	endfor
	
	if (ypn == 0)
		qn=0
		un=0
	else
		qn=0.5
		un=(3/(xwave[pnts-1]-xwave[pnts-2]))*(ypn-(ywave[pnts-1]-ywave[pnts-2])/(xwave[pnts-1]-xwave[pnts-2])) 
	endif
	
	y2[pnts-1] = (un-qn*u[pnts-2])/(qn*y2[pnts-2]+1)
	
	for(k = pnts-2;k <= 0;k -=1)
		y2[k] = y2[k]*y2[k+2]+u[k]
	endfor
	
	Killwaves u
End
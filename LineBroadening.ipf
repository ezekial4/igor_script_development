#pragma rtGlobals=1		// Use modern global access method.
#pragma version = 1.1

// Version 1.0
// Procedures for convolution and convolution based line broadening with awareness of X-scaling in waveform data.
//
// The procedures are based on the built in function "Convolve" which is FFT based, and thus fast for large data sets, but is 
// ignorant of waveform x-scaling.  Meaninful results from use of Convolve with X-scaling awareness require that any two input waves 
// (srcWaveName (kernal) and DestWaveName in the "Convolve" documentation) have the same delta X property.  The x_0 value also needs to be set correctly
// depending on the nature of the broadening and which Convolve flags are used.  The other important consideration handled by these procedures is 
// normalization.  If you are familiar with "Convolution" as a calculus concept, it is usually described as a single integral over the product of two functions, 
// and if a function is broadened with a kernal with unit area (integral = 1) then the output will preserve its normalization of the destination.  
// This is how we spectroscopists typically conceptualize "Convolve".  Because the integral has an x-spacing component to it which Igor's built-in Convolve ignores,
// normalization in the "desired sense" (meaning area returned from an integration) is preserved by scaling the kernal so its SUM over all elements is 1, 
// rather than its area (integration).   
//
// This procedure file also supplies a conversion function called "FillDestWave" (and wrapper procedure) for converting X,Y pairs to waveforms.  This conversion differs from 
// the wavemetrics supplied package "XY to waveform" in the assumption of the nature of the X,Y data.  Igor's built in "XY to waveform" assumes that the X,Y
// pairs reflect a smooth function of Y vs X with points sampled at uneven intervals, and the application is just re-sampling to a constant X spacing so
// the data can be displayed as a waveform.  If you would typically plot the X,Y data as a "lines between points" and the converted waveform produces an
// identical or very close recreation then the built in XY to Waveform is an appropriate conversion.  FillDestWave assumes the input X,Y data represents a series of
// delta functions: infinitely narrow peaks with a finite area underneath.  This comes up in spectroscopy simulations frequently because calculation of line strength and
// position is often done first and simple to apply before application of line shape.  I typically plot this data type as "Sticks to Zero" as it best visually 
// represents the data.  The difference in output is readily apparent wherever there are gaps in the X data significantly larger than the output waveform spacing.  The FillDestWave
// is similar to a weighted histogram (although there is bleeding of intensity into the nearest bin to better handle X values that are not perfectly centered in a bin)
// , where line data are summed into small(ish) bins so that the new waveform has an area integral from x = a to b matching the sum of Y values from the X,Y data for points a < X < b.
// 
// The functions supplied (FillDestWave and <shape>convolve) can all be run multiple times on the same output wave with meaningful results:  
//  The FillDestWave function can be called on the same
//  destination wave and the results will be added to existing content (makes it possible to include multiple pairs of X,Y waves into a single combined destination wave
// without needing to run a concatentation).  Calling a <shape>convolve function on an already broadened function gives the results of cumulative broadenings.  I.E., if 
// the starting data is a scan from a high resolution instrument that is already stored as a waveform, and you want to simulate a lower resolution, the additional convolution will work.
//
//  The <shape>Broaden functions, for which this procedure was originally worked out combine FillDestWave and <shape>convolve to produce line broadened waveform data from X,Y inputs
//
//  Version 1.0
//  Ian Konen
//  iankonen@gmail.com
//
//
// Updates for Version 1.1
//
// FASTER FILL ALGORITHM FOR LINE BROADENING in function 
// Added option to use the built in Igor Histogram operation (with the weighted histogram option) in the "FillDestWave" function.
// This significantly speeds up the fill process which is usually the rate limiting step if there are many lines present in the X,Y data. 
// It is slightly less accurate on a peak by peak basis:
// The built in weighted histogram only allows each line to accumulate into a single bin, while the original algorithm splits the intensity between two
// adjascent bins by interpolation.  This handles X value digitization error a little bit better (modeling a peak centered halfway between output points), but at the expense of 
// having to explicitly loop through each X,Y data pair in function code which is much slower than using the built in operation. 
//
// For data with discrete, recognizeable peaks and perhaps some desire to fit linewidths and/or positional offsets, it is probably better to stick to the
// original, more accurate algorithm.  For faster simulations, though, the built in weighted histrogram crushes the more accurate algorithm, and since this line broadening method
// was originally programmed specifically to speed up a the line broadening process, I'm tempted to make the histogram method the new default.  
// For now, I'm leaving the default as the old algorithm for backwards compatibility.
//
// Both algorithms suffer digitization error that gets worse when you increase the point spacing relative to the linewidth, with the relative errors of both methods diverging.  
// For data with large sets of (X,Y) pairs you may find that at constant calculation speed, the increased point density allowed with the faster fill algorithm ends up just as accurate as the
// the slower but more accurate algorithm with larger point spacing.  Some experimentation is required.  
//
// NEW FUNCTIONS: GenFuncConvolve(...), GenFuncBroaden(...), GenFuncGuessExtent(...)
//
// Similar in usage to the pre-defined *Convolve and *Broaden functions, but with the ability to pass a function reference describing the peak shape to use 
// (use the same form as Igor peak fitting functions:  function mypeakfunc(coefs, X). For more details, see comments on the GenFuncConvolve functions.
//
// Bug Fix:
// Corrected formula Gaussian to produce correct half-widths (this had been off by sqrt(2), and also affected the width of the Voigt function)


static constant DEFPPHW = 5	                       // Default Points Per Half Width for setting the output wave X-scaling in <PeakShape>Broaden Functions 
static constant DEFGAUSSHWS = 5		   //  Default Halfwidths for gaussian broadening, tail truncates at 1.5e-8 peak value
static constant DEFLORHWS = 1000              // Default halfwidths for Lorentzian broadening, tail truncates at 0.001 peak value
static constant GSIG2HWHM = 1.177410023   //  convert gaussian "sigma" parameter (standard deviation) to a halfwidth.  Exact value = sqrt(2*ln(2))
static constant MAXPOINTSCONV = 1e7	   // when automatically calculating point spacing over a fixed range, don't make waves longer than this number
static constant DEFFILLMETHOD = 0		   // if fillmethod optional argument is not supplied, use older interpolated fill vs. faster histogram method
static constant DEFEXTTHRESH = 1e-6		   // default extend threshhold for General Function broadening (uses kernel wave wide enough for function to fall off by this factor)

Menu "Line Broadening"
	 	"Gauss Convolve", GaussConvolveWrapper()
		"Lorentzian Convolve", LorConvolveWrapper()
		"Voigt Convolve", VoigtConvolveWrapper()
		"Fill Destination", FillDestWrapper()
		"Gauss Broaden", GaussBroadenWrapper()
		"Lorentzian Broaden", LorBroadenWrapper()
		"Voigt Broaden", VoigtBroadenWrapper()
End

//  Wrapper procedures for menu selection:
Proc GaussConvolveWrapper(sourcewavenm, destinationwavenm, HWHM, downsample)
	string sourcewavenm
	prompt sourcewavenm, "Source Wave", popup, WaveList("*",";","DIMS:1,TEXT:0")
	string DestinationWavenm
	prompt DestinationWavenm, "Destination (empty overwrites source)"
	variable HWHM
	prompt HWHM, "Half Width at Half Max"
	variable downsample = 1
	prompt downsample, "Down Sampling (1 for no change)"
	if (strlen(DestinationWavenm))
		GaussConvolve($sourcewavenm,hwhm,outwavename = DestinationWavenm, downsample = downsample)
	else
		GaussConvolve($sourcewavenm,hwhm, downsample = downsample)
	endif
EndMacro

Proc LorConvolveWrapper(sourcewavenm, destinationwavenm, HWHM, downsample)
	string sourcewavenm
	prompt sourcewavenm, "Source Wave", popup, WaveList("*",";","DIMS:1,TEXT:0")
	string DestinationWavenm
	prompt DestinationWavenm, "Destination (empty overwrites source)"
	variable HWHM
	prompt HWHM, "Half Width at Half Max"
	variable downsample = 1
	prompt downsample, "Down Sampling (1 for no change)"
	if (strlen(DestinationWavenm))
		LorConvolve($sourcewavenm,hwhm,outwavename = DestinationWavenm, downsample = downsample)
	else
		LorConvolve($sourcewavenm,hwhm, downsample = downsample)
	endif
EndMacro

Proc VoigtConvolveWrapper(sourcewavenm, destinationwavenm, L_HWHM, G_HWHM, downsample)
	string sourcewavenm
	prompt sourcewavenm, "Source Wave", popup, WaveList("*",";","DIMS:1,TEXT:0")
	string DestinationWavenm
	prompt DestinationWavenm, "Destination (empty overwrites source)"
	variable L_HWHM
	prompt L_HWHM, "Lorentzian Width (HWHM)"
	variable G_HWHM
	prompt G_HWHM, "Guassian Width (HWHM)"
	variable downsample = 1
	prompt downsample, "Down Sampling (1 for no change)"
	if (strlen(DestinationWavenm))
		VoigtConvolve($sourcewavenm,L_hwhm,G_hwhm,outwavename = DestinationWavenm, downsample = downsample)
	else
		VoigtConvolve($sourcewavenm,L_hwhm,G_hwhm, downsample = downsample)
	endif
End

Proc GaussBroadenWrapper(Xdata, Ydata, outwavenm, HWHM)
	string Xdata
	prompt Xdata, "Wave of Line X values", popup, WaveList("*",";","DIMS:1,TEXT:0")
	string Ydata
	prompt Ydata, "Wave of Line Y values", popup, WaveList("*",";","DIMS:1,TEXT:0")
	string outwavenm = ""
	prompt outwavenm, "Name of Output Wave"
	variable HWHM
	prompt HWHM, "Width (HWHM)"
	GaussBroaden($Xdata, $Ydata, outwavenm, HWHM)
End

Proc LorBroadenWrapper(Xdata, Ydata, outwavenm, HWHM)
	string Xdata
	prompt Xdata, "Wave of Line X values", popup, WaveList("*",";","DIMS:1,TEXT:0")
	string Ydata
	prompt Ydata, "Wave of Line Y values", popup, WaveList("*",";","DIMS:1,TEXT:0")
	string outwavenm = ""
	prompt outwavenm, "Name of Output Wave"
	variable HWHM
	prompt HWHM, "Width (HWHM)"
	LorBroaden($Xdata, $Ydata, outwavenm, HWHM)
End

Proc VoigtBroadenWrapper(Xdata, Ydata, outwavenm, L_HWHM, G_HWHM)
	string Xdata
	prompt Xdata, "Wave of Line X values", popup, WaveList("*",";","DIMS:1,TEXT:0")
	string Ydata
	prompt Ydata, "Wave of Line Y values", popup, WaveList("*",";","DIMS:1,TEXT:0")
	string outwavenm = ""
	prompt outwavenm, "Name of Output Wave"
	variable L_HWHM
	prompt L_HWHM, "Lorentzian Width (HWHM)"
	variable G_HWHM
	prompt G_HWHM, "Gaussian Width (HWHM)"
	VoigtBroaden($Xdata, $Ydata, outwavenm, L_HWHM, G_HWHM)
End

Proc FillDestWrapper(sourceX, sourceY, destinationwavenm, xspacing, xextension)
	string sourceX
	prompt sourceX, "X data", popup, WaveList("*",";","DIMS:1,TEXT:0")
	string sourceY
	prompt sourceY, "Y data", popup, WaveList("*",";","DIMS:1,TEXT:0")
	string destinationwavenm
	prompt destinationwavenm, "Destination Wave"
	variable xspacing = 1
	prompt xspacing, "Destination X Spacing"
	variable xextension = 1
	prompt xextension, "Extend Destination X scale by "
	variable destminx = wavemin($sourceX) - xextension
	variable destmaxx = wavemax($sourceX) + xextension
	variable destnpnts = (destmaxx - destminx) / xspacing + 1
	make /d /o /n = (destnpnts) $destinationwavenm
	SetScale /P x, (destminx), (xspacing), $destinationwavenm
	$destinationwavenm = 0
	FillDestWave($sourceX, $sourceY, $destinationwavenm)
End
 
// END Wrapper Functions
//


//  CONVOLVE FUNCTIONS

// In the following functions, the built-in Igor operation "convolve" is used
// to, well, convolve "startwave" with a peak function kernel (I've coded Gaussian, Lorentzian and Voight, but the principle can 
// be applied to any peak function.  These functions just coerce the scaling to be appropriate for waveform data (the 
// built-in Convolve operation ignores x-scaling and does everything point-to-point) and fix the normalization (to preserve Area normalization).
//
// Startwave could be an initial waveform from FillDestWave, or an already broadened wave (input an "intrinsic" signal and
// apply an instrument resolution function, for example).
//
// If the optional string "outwavename" is not supplied, the startwave is overwritten.  
// Extendhws is a measure of how may half-widths the kernel should be.  The smaller the kernel, the faster and less memory 
// intensive is the broadening operation, but tail-effects will truncated.  The default values I supplied in the constants tuncate
// the tails at < 1% maximum.  
//
//  Use downsample to decimate the wave (default behavior preserves points)
//   A negative downsample is applied BEFORE convolution (might be slightly less accurate, but better memory conservation)
//   Should use built-in low pass filtering of Resample to preserve normalization and not miss peaks even if applied before 

// COMMON OPTIONAL ARGUMENTS
//
// 

// Convolves an existing waveform with a [further] Gaussian function.  
Function GaussConvolve(startwave,hwhm,[extendhws,outwavename,downsample])
	wave startwave
	variable hwhm
	variable extendhws
	string outwavename
	variable downsample
	if (paramisdefault(extendhws))
		extendhws = DEFGAUSSHWS
	endif
	
	if (paramisdefault(outwavename))
		wave outwave = startwave
	else
		duplicate /o startwave, $outwavename
		wave outwave = $outwavename
	endif	
	
	if (!paramisdefault(downsample))
		if (downsample < 0)			// downsample before convolution
			Resample /DOWN=(-downsample)  outwave
		endif
	endif

	variable hwpnts = ceil(extendhws*hwhm / deltax(outwave))	// halfwidth in integer data points
	make /FREE /d /n = (2*hwpnts + 1) tempgauss
	setscale /p x, (-hwpnts*deltax(outwave)), (deltax(outwave)), "", tempgauss

//	multithread tempgauss = GSIG2HWHM/sqrt(pi)/ hwhm*deltax(outwave) * exp(-(x * GSIG2HWHM / hwhm)^2)			// arg...buggy expression
	multithread tempgauss = GSIG2HWHM/sqrt(2*pi)/ hwhm*deltax(outwave) * exp(-(x * GSIG2HWHM / (sqrt(2) * hwhm))^2)	// correctly produces desired halfwidth
//	multithread tempgauss = Gauss(x,0,hwhm / GSig2HWHM)
//	print "fiilled temp"
	Convolve /A tempgauss, outwave
	if (!paramisdefault(downsample))
		if (downsample > 0)			// downsample after convolution
 			Resample/DOWN=(downsample) outwave
		endif
	endif

	return 1
End

// Convolves an existing waveform with a [further] Lorentzian function.  
Function LorConvolve(startwave,hwhm,[extendhws,outwavename,downsample])
	wave startwave
	variable hwhm
	variable extendhws
	string outwavename
	variable downsample
	if (paramisdefault(extendhws))
		extendhws = DEFLORHWS
	endif
	if (paramisdefault(outwavename))
		wave outwave = startwave
	else
		duplicate /o startwave, $outwavename
		wave outwave = $outwavename
		SetFormula outwave, ""
	endif
	
	if (!paramisdefault(downsample))
		if (downsample < 0)			// downsample before convolution
			Resample /DOWN=(-downsample)  outwave
		endif
	endif

	variable hwpnts = ceil(extendhws*hwhm / deltax(outwave))	// halfwidth in integer data points
	if (hwpnts > MAXPOINTSCONV)
		DoAlert 0, "Convolution requires " + num2str(2*hwpnts + 1) + "points."
		return 0
	endif
	make /FREE /d /n = (2*hwpnts + 1) templor
	setscale /p x, (-hwpnts*deltax(outwave)), (deltax(outwave)), "", templor
	templor = 1/(x^2 + hwhm^2)
	variable thesum = sum(templor)
	templor /= thesum
	Convolve /A templor, outwave
	if (!paramisdefault(downsample))
		if (downsample > 0)			// downsample before convolution
			
 			Resample/DOWN=(downsample) outwave
		endif
	endif
	return 1
End

// Actually a combined convolution of Lorentzian and Guassian (which is where the Voight function comes from).  
// Note that the input shape parameters are Gaussian width and Lorentzian width as opposed to the separate width and shape 
// parameters used by VoigtFit (from the multipeak fitting XOP).  

Function VoigtConvolve(startwave,L_hwhm,G_hwhm,[Lextendhws,Gextendhws,outwavename,downsample])
	wave startwave
	variable L_hwhm,G_hwhm
	variable Lextendhws,Gextendhws
	string outwavename
	variable downsample
	
	if (paramisdefault(Lextendhws))
		Lextendhws = DEFLORHWS
	endif
	if (paramisdefault(Gextendhws))
		Gextendhws = DEFGAUSSHWS
	endif

	if (paramisdefault(outwavename))
		wave outwave = startwave
	else
		duplicate /o startwave, $outwavename
		wave outwave = $outwavename
	endif
	
	if (!paramisdefault(downsample))
		if (downsample < 0)			// downsample before convolution
			Resample /DOWN=(-downsample) outwave
		endif
	endif

	variable hwpnts = ceil(Lextendhws*L_hwhm / deltax(startwave))	// halfwidth in integer data points, rounded up.  
	make /FREE /d /n = (2*hwpnts + 1) templor
	setscale /p x, (-hwpnts*deltax(startwave)), (deltax(startwave)), "", templor	
	
	templor = 1/(x^2 + L_hwhm^2)

	hwpnts = ceil(Gextendhws*G_hwhm / deltax(startwave))	// halfwidth in integer data points
	make /FREE /d /n = (2*hwpnts + 1) tempgauss
	setscale /p x, (-hwpnts*deltax(startwave)), (deltax(startwave)), "", tempgauss	
	
//	tempgauss = exp(-(x * GSIG2HWHM / G_hwhm)^2)				// wrong!
	tempgauss = exp(-(x * GSIG2HWHM / (sqrt(2) * G_hwhm))^2)
	Convolve tempgauss,templor		// templor is now really a tempVoight
	variable thesum = sum(templor)	
	templor /= thesum				// Now it's a normalization preserving Voight
	Convolve /A templor, outwave
	
	if (!paramisdefault(downsample))
		if (downsample > 0)			// downsample after convolution			
 			Resample/DOWN=(downsample) outwave
		endif
	endif

	return 1
End


// GenFuncConvolve:  The idea with this function is to generalize the process used above for Gaussian, Lorentzian and Voight functions to any function
// that describes peak shape using arguments of the form 
//
// Function MyPeakShape(coefficients, X)
//	wave coefficients
//	variable X
//
//
// Typically a function like this will have an intensity coefficient (It might equal peak area, or peak maximum, or it may just be proportional to either but it only scales the shape up or down
// if modified) and a peak center coefficient (X0, used to create a peak centered about X0.)  If these are clearly identifiable:
//
// X0 should probably be set to 0 (perhaps another appropriate number makes more sense but it should be set to whatever value places the peak horizontally at 0).
// Intensity should be fixed and not modified (perhaps set to 1 but not required, see the normalizationmethod parameter below) 
//
// Essentially these are replaced by the x and y coordinates of the convolve destination.  
// Some assumptions built in to those previous peak shapes are not generally valid for an arbitrary peak shape (namely the fact that they're all symmetric about 0, and 
// the fall-off rate which affects accuracy far from a peak center is knowable), so this function requires more parameters filling in the gaps.  
//
//
// normalizationmethod = 0 for no modification (not really recommended, chances are if you think your input function is "normalized" you want option 1.), 
// 1 for assume FuncRef and coefs will produce an area normalized peak and correct for x spacing.
// 2 re-normalize by calculating peak sum regardless of coefficient (assume area normalization is desired even if supplied kernel function is NOT area normalized)
//    option 2 is does not attempt to integrate the peak function over all X...it just normalizes the total kernel wave set by ExtendXplus and ExtendXminus, so if a 
//    significant portion of peak area is removed by setting these too close to zero, it will affect the output normalization.  
//
// ExtendXplus is an optional argument (but I highly recommend manually setting it) that sets the size of the kernel wave used in the convolution.  
// You want to use a large enough value that your peak function has decayed sufficiently close to 0.  It is set in the same units as the input wave's x scaling
// (note this is different from the equivalent argument for the predefined peak shapes, which extend out to a multiple of halfwidths).
// If not set, it calls a function "GenFuncGuessExtent" which will attempt to include enough width for the peak to decay to 1e-6 (controlled by the constant DEFEXTTHRESH)
// of the peak value at 0 (possibly the maximum but hopefully at least near it).  GenFuncGuessExtent() makes a few assumptions about the peak function being "well behaved", namely 
// the maximum being relatively near the center (and set to X = 0 or near it), and assymptotically and monotonically approaching 0 away from the peak center (I can see it having problems with
// a Bessel function, e.g.).  It's also an iterative search so it may become a significant speed bottleneck.  
//
// ExtendXminus is optional, and is set to equal ExtendXplus by default.  Use a *positive* number.  Note that if it is NOT equal to ExtendXplus, it will adjust the x offset of the 
// output wave to preserve the correct x scale (i.e. the first data point in the output wave will start at a different X value than the source wave).  
// You may wish to use the same extent regardless of peak assymmetry if you wish to avoid this behavior.  
//
// If the optional string "outwavename" is not supplied, the startwave is overwritten.  
//
//  Use downsample to decimate the wave (default behavior preserves points)
//   A negative downsample is applied BEFORE convolution (might be slightly less accurate, but better memory conservation)
//   Should use built-in low pass filtering of Resample to preserve normalization and not miss peaks.

Function GenFuncConvolve(startwave,peakfunc,coefs,normalizationmethod, [ExtendXplus,ExtendXminus,outwavename,downsample])
	wave startwave
	FUNCREF PFtemplate peakfunc
	wave coefs
	variable normalizationmethod
	variable  ExtendXplus, ExtendXminus
	string outwavename
	variable downsample	
	if (paramisdefault(ExtendXplus))
		variable width
		GenFuncGuessExtent(peakfunc,coefs,DEFEXTTHRESH, ExtendXplus, ExtendXminus, width)
		ExtendXminus *= -1
	else		
		if (paramisdefault(ExtendXminus))
			ExtendXminus = ExtendXplus		
		endif
	endif

	if (paramisdefault(outwavename))
		wave outwave = startwave
	else
		duplicate /o startwave, $outwavename
		wave outwave = $outwavename
	endif
	if (ExtendXminus != ExtendXplus)
		setscale /p x, (leftx(outwave) + (ExtendXplus - ExtendXminus) / 2), deltax(outwave), "", outwave
	endif

	if (!paramisdefault(downsample))
		if (downsample < 0)			// downsample before convolution
			Resample /DOWN=(-downsample) outwave
		endif
	endif
	
	variable kernelpoints = (ExtendXplus + ExtendXminus) / deltax(startwave) + 1
	if (kernelpoints > MAXPOINTSCONV)
		DoAlert 0, "Convolution requires " + num2str(kernelpoints) + "points."
		return 0
	endif
	make /FREE /d /n = (kernelpoints) kernelwave
//	make /o /d /n = (kernelpoints) kernelwave
	setscale /P x, (-ExtendXminus),(deltax(startwave)), "", kernelwave
	kernelwave = peakfunc(coefs,x)			// can I do multithread with compiler conditionals?
	variable normfix
	switch (normalizationmethod)
		case 1:
			kernelwave *= deltax(startwave)			// Converts area normalized to sum normalized for use in Convolve
			break
		case 2:
			normfix = 1/sum(kernelwave)
			kernelwave *= normfix
			break
	Endswitch
	Convolve /A kernelwave, outwave	
			
	if (!paramisdefault(downsample))
		if (downsample > 0)			// downsample after convolution			
 			Resample/DOWN=(downsample) outwave
		endif
	endif
		
	return 1
End

Function PFtemplate(coefs,ex)
	wave coefs
	variable ex
	return 0
End

// Iteratively searches for a threshhold crossing by increasing by a power of 2 each time.
// For this to work, it is critical that the peak value at 0 be nearly the maximum (the threshhold is a fraction of
// the peak value evaluated at x = 0.).  For asymmetric peaks, you may prefer 0 to divide the area in half, or be the first moment (average x value) of the peak.
// All fine, but this function doesn't know that so it goes with 0, and your effective threshhold will be scaled down.  
//
// Generally speaking, not really sure it's worth using this function.  It will add a lot of calculation time because of the iterative
// process of sussing out width parameters of an arbitrary peak shape.
//
//  You're probably better off using your own estimates and setting optional extendX parameters.  

Function GenFuncGuessExtent(peakfunc, coefs, threshhold, highbracket, lowbracket, width)
	FUNCREF PFtemplate peakfunc
	wave coefs
	variable threshhold
	variable &highbracket, &lowbracket, &width
	variable peakmax = peakfunc(coefs,0)
	variable cutoff = threshhold*peakmax
	highbracket = 1
	lowbracket = -1
	if (peakfunc(coefs,highbracket) > cutoff)	
		do
			highbracket = highbracket*2
		while (peakfunc(coefs,highbracket) > cutoff)
	else
		do
			highbracket = highbracket / 2
		while (peakfunc(coefs,highbracket) < cutoff)
		highbracket *= 2
	endif
	if (peakfunc(coefs,lowbracket) > cutoff)	
		do
			lowbracket = lowbracket*2
		while (peakfunc(coefs,lowbracket) > cutoff)
	else
		do
			lowbracket = lowbracket / 2
		while (peakfunc(coefs,lowbracket) < cutoff)
		lowbracket *= 2
	endif
	FindRoots /L = (lowbracket) /H=(highbracket) /Q /Z=(peakmax*0.5) peakfunc, coefs
	width = min(abs(V_Root2),abs(V_Root))	// minimum halfwidth for assymetric shape.
	return 1
End


// END CONVOLVE FUNCTIONS



// BROADENING FUNCTIONS
//
// Functions of the form <peaktype>broaden are written to convert pairwise x,y peak data to waveform data with uniform peak shapes by creating an 
// initial wavef


// NOTE : destination wave is not pre-cleared by setting it to 0.  This should typically be done by the programmer or user
// previous to calling this function, but it is possible to call this multiple times using
// different X,Y pairs to build up the contents of a dest wave that represents a total signature.
//
// Update Version 1.1
// optional variable method determines the algorithm used: 0 for the more accurate but slower interpolated fill, and 1 for the built in weighted histogram operation.  

Function FillDestWave(pos, inten, dest, [fillmethod])
	wave pos, inten, dest
	variable fillmethod
	if (paramisdefault(fillmethod))
		fillmethod = DEFFILLMETHOD
	endif
	variable cnt = 0, plow, lowint, highint
	switch (fillmethod)
		case 0:			// original algorithm
			variable leftex = leftx(dest)
			variable deltaex = deltax(dest)
			variable endex = rightx(dest) - deltaex

			variable loopmax = min(numpnts(pos),numpnts(inten))
			for (cnt = 0; cnt < loopmax; cnt += 1)
				if (!(pos[cnt] < leftex || pos[cnt] > endex))
					plow = (pos[cnt] - leftx(dest))/deltaex
		//			highint = inten[cnt]*(plow - floor(plow))
		//			lowint = inten[cnt] - highint
					highint = inten[cnt]*(plow - floor(plow))/deltaex
					lowint = inten[cnt]/deltaex - highint
					plow = floor(plow)
					dest[plow] += lowint
					dest[plow + 1] += highint
				endif
			endfor
			break
		case 1:			// use Histogram operation
			duplicate /free dest tempdest
			Histogram /B=2 /W=inten pos, tempdest
			Multithread dest += tempdest * (1 / deltax(dest))		// Would prefer to use /A accumulate flag, but scaling is wrong.
			break
	EndSwitch
End


Function GaussBroaden(Xwave, Ywave, outwavenm, hwhm, [LowX, HighX, Xspacing, extendhws, fillmethod])
	wave Xwave, Ywave
	string outwavenm
	variable hwhm
	variable LowX, HighX, Xspacing, extendhws, fillmethod
	if (ParamIsDefault(LowX))
		LowX = WaveMin(Xwave) - hwhm*5
	endif
	if (ParamIsDefault(HighX))
		HighX = WaveMax(Xwave) + hwhm*5
	endif
	if (ParamIsDefault(Xspacing))
		Xspacing = hwhm / DEFPPHW
	endif
	if (ParamIsDefault(extendhws))
		extendhws = DEFGAUSSHWS
	endif	
	if (ParamIsDefault(fillmethod))
		fillmethod = DEFFILLMETHOD
	endif
	variable numpoints = (HighX - LowX) / Xspacing + 1
	if (numpoints > MAXPOINTSCONV)
		print "Output Wave requires ", numpoints, " points."
		print "Override defaults to make a smaller wave, or manually fill and broaden."
		return 0
	endif
	make /o /d /n = (numpoints) $outwavenm
	wave outwave = $outwavenm
	multithread outwave = 0
	SetScale /P x, (LowX), (Xspacing), "", outwave
	FillDestWave(Xwave, Ywave, outwave, fillmethod=fillmethod)
	GaussConvolve(outwave,hwhm,extendhws = extendhws)
	return 1
End

Function LorBroaden(Xwave, Ywave, outwavenm, hwhm, [LowX, HighX, Xspacing, extendhws, fillmethod])
	wave Xwave, Ywave
	string outwavenm
	variable hwhm
	variable LowX, HighX, Xspacing,extendhws, fillmethod
	if (ParamIsDefault(LowX))
		LowX = WaveMin(Xwave) - hwhm*5
	endif
	if (ParamIsDefault(HighX))
		HighX = WaveMax(Xwave) + hwhm*5   
	endif
	if (ParamIsDefault(Xspacing))
		Xspacing = hwhm / DEFPPHW
	endif
	if (ParamIsDefault(extendhws))
		extendhws = DEFLORHWS
	endif
	if (ParamIsDefault(fillmethod))
		fillmethod = DEFFILLMETHOD
	endif
	variable numpoints = (HighX - LowX) / Xspacing + 1
	if (numpoints > MAXPOINTSCONV)
		print "Default Output results in ", numpoints, " points."
		print "Override defaults to make a smaller wave, or manually fill and broaden."
		return 0
	endif
	make /o /d /n = (numpoints) $outwavenm
	wave outwave = $outwavenm
	multithread outwave = 0
	SetScale /P x, (LowX), (Xspacing), "", outwave
	FillDestWave(Xwave, Ywave, outwave, fillmethod = fillmethod)
	LorConvolve(outwave,hwhm,extendhws = extendhws)
	return 1
End

Function VoigtBroaden(Xwave, Ywave, outwavenm, l_hwhm, g_hwhm, [LowX, HighX, Xspacing, fillmethod])
	wave Xwave, Ywave
	string outwavenm
	variable l_hwhm, g_hwhm
	variable LowX, HighX, Xspacing, fillmethod
	variable v_hwhm = 0.5*l_hwhm + sqrt(0.25*l_hwhm^2 + g_hwhm^2)	// hardly need this, could just use a minmax argument
	if (ParamIsDefault(LowX))
		LowX = WaveMin(Xwave) - v_hwhm*5
	endif
	if (ParamIsDefault(HighX))
		HighX = WaveMax(Xwave) + v_hwhm*5
	endif
	if (ParamIsDefault(Xspacing))
		Xspacing = v_hwhm / DEFPPHW
	endif
	if (ParamIsDefault(fillmethod))
		fillmethod = DEFFILLMETHOD
	endif
	variable numpoints = (HighX - LowX) / Xspacing + 1
	if (numpoints > MAXPOINTSCONV)
		print "Default Output results in ", numpoints, " points."
		print "Override defaults to make a smaller wave, or manually fill and broaden."
		return 0
	endif
	make /o /d /n = (numpoints) $outwavenm
	wave outwave = $outwavenm
	multithread outwave = 0
	SetScale /P x, (LowX), (Xspacing), "", outwave
	FillDestWave(Xwave, Ywave, outwave, fillmethod = fillmethod)
	VoigtConvolve(outwave,l_hwhm, g_hwhm)
	return 1
End

// See documentation for GenFuncConvolve regarding optional arguments ExtendXplus, ExtendXminus and GenFuncGuessExtent()
//
//
Function GenFuncBroaden(Xwave, Ywave, outwavenm, peakfunc, coefs, normalizationmethod, [LowX, HighX, ExtendXplus, ExtendXminus, Xspacing, fillmethod])
	wave Xwave, Ywave
	string outwavenm
	FUNCREF PFtemplate peakfunc
	wave coefs
	variable normalizationmethod
	variable LowX, HighX, ExtendXplus, ExtendXminus, Xspacing, fillmethod
	if (ParamIsDefault(ExtendXplus) || ParamIsDefault(Xspacing))
		variable tempextendplus,tempextendminus, tempwidth
		GenFuncGuessExtent(peakfunc, coefs, DEFEXTTHRESH, tempextendplus, tempextendminus, tempwidth)
		if (paramisdefault(ExtendXplus))
			ExtendXplus = tempextendplus
			ExtendXMinus = -tempextendminus
		else
			if (paramisdefault(ExtendXminus))
				ExtendXminus = ExtendXplus		
			endif
		endif
		if (paramisdefault(Xspacing))
			Xspacing = tempwidth / 5
		endif
	else
		if (paramisdefault(ExtendXminus))
			ExtendXminus = ExtendXplus		
		endif	
	endif	
	if (ParamIsDefault(LowX))
		LowX = WaveMin(Xwave) - Xspacing*25
	endif
	if (ParamIsDefault(HighX))
		HighX = WaveMax(Xwave) + Xspacing*25
	endif
	if (ParamIsDefault(fillmethod))
		fillmethod = DEFFILLMETHOD
	endif
	variable numpoints = (HighX - LowX) / Xspacing + 1
	if (numpoints > MAXPOINTSCONV)
		print "Default Output results in ", numpoints, " points."
		print "Override defaults to make a smaller wave, or manually fill and broaden."
		return 0
	endif
	
	make /o /d /n = (numpoints) $outwavenm
	wave outwave = $outwavenm
	multithread outwave = 0
	SetScale /P x, (LowX), (Xspacing), "", outwave
	FillDestWave(Xwave, Ywave, outwave, fillmethod = fillmethod)
	GenFuncConvolve(outwave,peakfunc,coefs,normalizationmethod,ExtendXplus = ExtendXplus,ExtendXMinus = ExtendXMinus)
	return 1

End
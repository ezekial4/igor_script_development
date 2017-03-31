#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

// AssignWave(SourceWave,DestWave,IndexWave,Mode)
// Quick wave assignment according to an index wave.
// Mode specifies how to interpret the index wave and assign values.
// Mode = 1: DestWave[i] = SourceWave[i]
//                          N(Source) = N(Dest) (IndexWave ignored - just pass a null reference)
// Mode = 2: DestWave[i] = SourceWave[IndexWave[i]]
//                          N(Source) = N(Dest) = N(Index)
// Mode = 3: DestWave[IndexWave[i]] = SourceWave[IndexWave[i]]
//                          N(Source) = N(Dest)
// Mode = 4: DestWave[IndexWave[i]] = SourceWave[i]
//                          N(Source) = N(Index)
// 
// For Modes 1 and 2, IndexWave is the index into SourceWave.
// For Modes 3 and 4, IndexWave is the index into DestWave.
Function AssignWave(SourceWave,DestWave,IndexWave,Mode)
	WAVE DestWave,SourceWave
	WAVE IndexWave
	Variable Mode
	switch (Mode)
		case 1: // Functional equivalent to DestWave[i] = SourceWave[i]
			if (WaveType(DestWave,1)==2) // text wave; no MatrixOp support
				DestWave = SourceWave
			else // Faster than: DestWave = SourceWave[IndexWave]
				if (WaveType(DestWave) & 0x01) // is complex?
					FastOp/C DestWave = SourceWave
				else
					FastOp DestWave = SourceWave				
				endif
			endif
			break
		case 2: // Functional equivalent to DestWave[i] = SourceWave[IndexWave[i]]
			if (WaveType(DestWave,1)==2) // text wave; no MatrixOp support
				DestWave = SourceWave[IndexWave]
			else // Faster than: DestWave = SourceWave[IndexWave]
				if (WaveType(DestWave) & 0x01) // is complex?
					MatrixOp/O/C DestWave = waveMap(SourceWave,IndexWave)
				else
					MatrixOp/O DestWave = waveMap(SourceWave,IndexWave)
				endif
			endif
			break
		case 3: // Functional equivalent to DestWave[IndexWave[i]] = SourceWave[IndexWave[i]]
			if (WaveType(DestWave,1)==2) // text wave
				Make/T/O/N=(numpnts(IndexWave))/FREE DummyDestText
				DummyDestText = AssignWave_WaveMapText(SourceWave,DestWave,IndexWave,IndexWave)
			else // real or complex
				Make/O/N=(numpnts(IndexWave))/FREE DummyDestNum
				DummyDestNum = AssignWave_WaveMapNum(SourceWave,DestWave,IndexWave,IndexWave)
			endif
			break
		case 4: // Functional equivalent to DestWave[IndexWave[i]] = SourceWave[i]
			Make/O/N=(numpnts(SourceWave))/FREE SourceIndexWave = p
			if (WaveType(DestWave,1)==2) // text wave
				Make/T/O/N=(numpnts(IndexWave))/FREE DummyDestText
				DummyDestText = AssignWave_WaveMapText(SourceWave,DestWave,SourceIndexWave,IndexWave)
			else // real or complex
				Make/O/N=(numpnts(IndexWave))/FREE DummyDestNum
				DummyDestNum = AssignWave_WaveMapNum(SourceWave,DestWave,SourceIndexWave,IndexWave)				
			endif
			break
	endswitch
End
 
// Maps a source value into a destination value.
// Used by AssignWave (Modes 3 or 4).  (For mode 3, srcidx = destidx)
// Suggested by Fernando on the Igor discussion list (7/20-21/12)
Function AssignWave_WaveMapNum(wSource, wDest, srcidx, destidx)
	Wave/C wSource, wDest // complex, in general; also works for real
	Variable srcidx,destidx
 
	wDest[destidx] = wSource[srcidx]
End
 
Function/S AssignWave_WaveMapText(wSource, wDest, srcidx, destidx)
	Wave/T wSource, wDest
	Variable srcidx, destidx
 
	wDest[destidx] = wSource[srcidx]
End
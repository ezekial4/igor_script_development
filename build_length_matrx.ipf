#pragma rtGlobals=1		// Use modern global access method.
Function Build_length_matrix(imax,jmax,out_radius,tanj_radius)
	Variable imax
	Variable jmax
	Wave out_radius
	Wave tanj_radius
	
	Make/O/N=(imax,jmax) Length_matrix =2
	
	Variable i,j
	for (i=0;i<imax;i+=1)
		for(j=0;j<jmax;j+=1)	
			if (i==j)
				Length_matrix[i][j] = 2*sqrt(out_radius[j]^2-tanj_radius[i]^2)
			else
				Length_matrix[i][j] = 2*sqrt(out_radius[j]^2-tanj_radius[i]^2)-2*sqrt(out_radius[j-1]^2-tanj_radius[i]^2)
			endif 		
			if (out_radius[j] < tanj_radius[i])
				Length_matrix[i][j] = 0
			endif 
		endfor
	endfor
	
//	Length_matrix *=100
End	
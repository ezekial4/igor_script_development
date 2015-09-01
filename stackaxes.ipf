#pragma rtGlobals=1		// Use modern global access method.
Menu "Graph"
	"Stack Axes", stackaxes()
	help= {"Stack all left axes in the current graph."}
end

function stackaxes()
// Align and stack the left axes in a graph
// James Allan, APRG, UMIST
// james.allan@physics.org
	string axeslist=sortlist(axislist("")),leftlist="",axis
	variable sep=10,n,i,pos=nan,a1,a2,b1,b2
	prompt sep,"Percentage Separation"
	n=itemsinlist(axeslist)
	for (i=0;i<n;i+=1)
		axis=stringfromlist(i,axeslist)
		if (stringmatch(stringbykey("AXTYPE",axisinfo("",axis)),"left"))
			leftlist+=axis+";"
		endif
	endfor
	n=itemsinlist(leftlist)
	if (n>0)
		doprompt "Stack Left Axes", sep
		if (!v_flag)
			sep/=100
			a1=n+(sep*n)-sep
			for (i=0;i<n;i+=1)
				a2=(sep+1)*(n-i-1)
				axis=stringfromlist(i,leftlist)
				b1=a2/a1
				if (b1<0)
					b1=0
				endif
				b2=(a2+1)/a1
				if (b2>1)
					b2=1
				endif
				ModifyGraph axisEnab($axis)={b1,b2}
				ModifyGraph freePos($axis)=0
				if (numtype(pos)!=0)
					pos=numberbykey("lblPos(x)",axisinfo("",axis),"=")
				else
					ModifyGraph lblPos($axis)=pos
				endif
			endfor
		endif
	endif
end

function alignaxes(axis1,axis2)
// Align axis 2 with axis 1
// James Allan, APRG, UMIST
// james.allan@physics.org
	string axis1, axis2
	string axlist=axislist("")
	if (strsearch(axlist,axis1,0)>-1 && strsearch(axlist,axis2,0)>-1)
		execute ("modifygraph axisEnab("+axis2+")="+stringbykey("axisEnab(x)",axisinfo("", axis1),"="))
	endif
end
		
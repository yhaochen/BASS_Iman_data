# This script plots the radial plots for the sensitivity analysis.

#Hosseini-Shakib, I., Sharma, S., Lee, B.S., Srikrishnan, V.A., 
# Nicholas, R., & Keller, K. (2022). Uncertainties surrounding flood hazard 
# estimates is the primary driver of riverine flood risk projections. preprint

#Owner of the data: Iman Hoseeini-Shakib (ishakib@gmail.com)

#Author of the scripts: Haochen Ye (hxy46@psu.edu)

# This script is modified based on "12-radial_plot_risk.R"
#More details about the study: https://github.com/imshakib/Hosseini-Shakib_etal_2022_preprint

rm(list = ls())
graphics.off()
library(plotrix)

#Set the working directory
folder <- "./BASS_Iman_data"
setwd(folder)

#------------------------------ parameters to change
m <- "Hazard" # or "Risk"
seed <- 1
size <- 10000
# Below are the two indices that represent the samples in the sensitivity analysis results
#    that you treat as converged. (For example, S records 90 samples after burn-in period, 
#    you may take the mean of sample 80 to sample 90 as the true sensitivity index)
ind_start <- 80
ind_end <- 90
#---------------------------------

# Load the sensitivity analysis results (may need to change these parameters based on your results)
load(paste("sensitivity_", m, "_", seed, "_", size, sep=""))

# Parameters and names
if (m == "Hazard"){
  n_params <- 6
  names <- c("Q","Z","W",
             "n_ch","n_fp","DEM")
}
if (m == "Risk"){
  n_params <- 8
  names <- c("Q","Z","W","n_ch","n_fp","DEM","V","X")
}

# A threshold that determines which indices are statistical significant
#   in the order of: first-order, total-order, second-order indices
thres <- c(0.05,0.05,0.05)

# Settings for the radial plot
cent_x=0
cent_y=0.2
radi=0.6
alph=360/8 # or use n_params

# A function to create an upper diagonal matrix for 2nd-order indices
upper.diag <- function(x){
  m<-(-1+sqrt(1+8*length(x)))/2+1
  X<-lower.tri(matrix(NA,m,m),diag=FALSE)
  X[X==TRUE]<-x
  X
}

# Each index is the mean of the last saved MCMC iterations (you may choose how many samples to use)
# Total-order indices:
st <- colMeans(S$T[c(ind_start:ind_end), ])
    
# First-order indices:
s1 <- colMeans(S$S[c(ind_start:ind_end),c(1:6)])
    
# second-order indices:
s2 <- colMeans(S$S[c(ind_start:ind_end),c(7:21)])
s2 <- upper.diag(s2)
    
pdfname <- paste("radial_plot_Hazard.pdf",sep="")
pdf(pdfname, width =3.94, height =3.94)
    
par(cex=0.5,mai=c(0.1,0.1,0.1,0.1))
plot(c(-1,1),c(-1,1),bty="n",xlab="",ylab="",xaxt="n",yaxt="n",type="n")
draw.circle(0,.2,0.5,border = NA,col="gray90")
    
for(j in 1:(n_params)){
  i=j-1
  cosa=cospi(alph*i/180)
  sina=sinpi(alph*i/180)
  text(cent_x+cosa*(radi+radi*.15),cent_y+sina*(radi+radi*.15),
    names[j],srt=0,cex=1,col="darkgreen")
  myX=cent_x+cosa*(radi-0.2*radi)
  myY=cent_y+sina*(radi-0.2*radi)
  if (j < n_params){
    for (z in (j+1):n_params){ #Second-order interactions 
      if (s2[z,j]>=thres[3]){
        g <- z-1
        cosaa=cospi(alph*g/180)
        sinaa=sinpi(alph*g/180)
        EndX=cent_x+cosaa*(radi-0.2*radi)
        EndY=cent_y+sinaa*(radi-0.2*radi)
        lines(c(myX,EndX),c(myY,EndY),col='darkblue',
                  lwd=qunif(s2[z,j]/max(s2),0,5))
      }
    }
  }
      
  if(st[j]>=thres[2]){ #Total-order nodes 
    draw.circle(cent_x+cosa*(radi-0.2*radi),cent_y+sina*(radi-0.2*radi),
                radius = qunif(st[j]/max(st),0.03,0.1),col="black")
  }
      
  if(s1[j]>=thres[1]){ #First-order nodes 
    draw.circle(cent_x+cosa*(radi-0.2*radi),cent_y+sina*(radi-0.2*radi),
                radius = qunif(s1[j]/max(s1),0.01,0.08),
                col=rgb(1, 102/255, 102/255,1),border = NA)
  }
}
    
# Plot the box below the plot 
x1=0.3
y1=0
draw.circle(x1+-0.9,y1+-0.97,0.08,border = NA,col=rgb(1, 102/255, 102/255,1))
draw.circle(x1+-0.7,y1+-0.97,0.01,border = NA,col=rgb(1, 102/255, 102/255,1))
text(x1+-0.9,y1+-0.83,paste(round(100*max(s1)),'%',sep=""))
text(x1+-0.7,y1+-0.83,paste(round(100*max(min(s1),thres[1])),'%',sep=""))
text(x1+-0.8,y1+-0.75,'First-order')
    
draw.circle(x1+-0.4,y1+-0.97,0.1,col="black")
draw.circle(x1+-0.2,y1+-0.97,0.03,col="black")
text(x1+-0.4,y1+-0.83,paste(round(100*max(st)),'%',sep=""))
text(x1+-0.2,y1+-0.83,paste(round(100*max(min(s1),thres[2])),'%',sep=""))
text(x1+-0.3,y1+-0.75,'Total-order')
    
lines(c(x1+0.1,x1+0.2),c(y1+-0.97,y1+-0.97),lwd=5,col="darkblue")
text(x1+0.15,y1+-0.83,paste(round(100*max(s2,na.rm=T)),'%',sep=""))
text(x1+0.15,y1+-0.75,'Second-order')
    
#title of used samples and seed
x2=0
y2=1
text(x2,y2,"")
dev.off()
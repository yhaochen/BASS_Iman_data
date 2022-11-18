#A toy example of the BASS sensitivity analysis
# Note: the Sobol analysis in this script directly uses the function in 
#  "BASS" package instead of sensobol package

#Author: Haochen Ye (hxy46@psu.edu)

rm(list = ls())
graphics.off()
library(BASS)
library(lhs)

#Set the working directory
folder <- "./BASS_Iman_data"
setwd(folder)

#A simple bivariate function example
f <- function (x,y){
  return (x^2 + 2*x*y^2)
}

#Inputs with 100 samples:
a <-  randomLHS(100, 2)

#Outputs:
b <- f(a[ ,1], a[ ,2])

#Step 1 of BASS analysis: fit a BASS emulator
#Users may set related parameters for the emulator structure and MCMC
# see more detailed information in bass() function documentation.
#The emulator consists of a series MCMC samples
bass_model <- bass(a, b)

#Step 2 of BASS analysis: calculate Sobol' indices based on the emulator
#Sensitivity indices for each MCMC sample will be calculated.
S <- sobol(bass_model)

#Plot the sensitivity indices to check its convergence
#Currently, there isn't a quantitative method to check convergence easily,
# we can treat the results as convergence if there is no obvious trend and
# the width of the variation is within 0.05.
plot(c(1:1000),S$S[ ,1],type="l",xlab="MCMC iteration",ylab="First-order sensitivity of x")

#Users can approximate the mean of sensitivity indices (after burn-in period) as the true sensitivity.
#First-order sensitivity:
S_x <- mean(S$S[ ,1])
S_y <- mean(S$S[ ,2])

#Second-order sensitivity:
S_xy <- mean(S$S[ ,3])

#Total-order sensitivity:
T_x <- mean(S$T[ ,1])
T_y <- mean(S$T[ ,2])
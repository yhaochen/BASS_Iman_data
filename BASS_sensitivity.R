#This script is a BASS sensitivity analysis performed on data from:

#Hosseini-Shakib, I., Sharma, S., Lee, B.S., Srikrishnan, V.A., 
# Nicholas, R., & Keller, K. (2022). Uncertainties surrounding flood hazard 
# estimates is the primary driver of riverine flood risk projections. preprint

#Owner of the data: Iman Hoseeini-Shakib (ishakib@gmail.com)

#Author of the scripts: Haochen Ye (hxy46@psu.edu)

#More details about the study: https://github.com/imshakib/Hosseini-Shakib_etal_2022_preprint

rm(list = ls())
graphics.off()
library(BASS)

#Set the working directory
folder <- "/storage/work/h/hxy46/Sensitivity/Iman_test"
setwd(folder)

#------------------------------Parameters that users need to set
seed <- 1
size <- 10000
# in which metric? "Hazard" or "Risk"
m <- "Hazard" #"Risk"
# 3 important parameters in MCMC setting:
# total MCMC length
nmcmc <- 1000000
# BASS records the results every 'thin' iterations
thin <- 10000
# burn-in period, only record the results after this many iterations
nburn <- 10000
#------------------------------------

set.seed(seed)
#Load data
load("BASS_param_set.RData")
selected_index <- sample(1:30000, size, replace=F)

# In the dataframe, the 9th parameter is hazard, the 10th parameter is risk.
# Hazard analysis needs 6 parameters, risk analysis needs 8 parameters.
if (m == "Hazard"){
  m_index <- 9
  npara <- 6
}
if (m == "Risk"){
  m_index <- 10
  npara <- 8
}
Metric <- BASS_param_set[selected_index, m_index]
Param <- BASS_param_set[selected_index, c(1:npara)]
# Note we allow the max interactions to be 3 and the max basis function numbers to be 200.
# Users may also change these settings.
BASS_model <- bass(Param, Metric, nmcmc = nmcmc, nburn = nburn, thin = thin, maxInt = 3, maxBasis = 200)
S <- sobol(BASS_model, verbose = TRUE)
save(S,file = paste("sensitivity_", m, "_", seed, "_", size, sep=""))





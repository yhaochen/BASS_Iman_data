# BASS_Iman_data

This repository is a sensitivity analysis using Bayesian Adaptive Spline Surface (BASS) method (Francom et al., 2020) based on the data from another study:

Hosseini-Shakib, I., Sharma, S., Lee, B.S., Srikrishnan, V.A., Nicholas, R., & Keller, K. (2022). Uncertainties surrounding flood hazard estimates is the primary driver of riverine flood risk projections. preprint 

See more details about this study in: https://github.com/imshakib/Hosseini-Shakib_etal_2022_preprint

## Below is a description to each file in the repository.

`BASS_toy_example.R` is a toy example showing how BASS method works in global sensitivity analysis.

`BASS_param_set.RData` is an ensemble of 30,000 parameter samples after pre-calibration. 

`BASS_sensitivity.R` uses the BASS method to fit an emulator and perform sensitivity analysis using the dataset.

`wheel_plot.R` uses the sensitivity indices to make a "wheel diagram" to visualize the sensitivity analysis results.

## Note for users:

1. Clone this repo to a local folder (whose name should be the same as the repository name).

2. BASS method requires parameter setting for the emulator (mainly including MCMC chain length, burn-in period and the frequency of results saving). Users are welcome to change these parameters within `BASS_sensitivity.R`.

3. For this application example, users also can choose a different initial sample size and random seed to compare the results. Hazard and risk are the two metrics (or model outputs) that users can choose. These parameters can also be changed within `BASS_sensitivity.R`.

4. When making the wheel diagram, users need to decide which part of the MCMC chain to use (by providing the starting and ending indices of the chain). These parameters can be changed within `wheel_plot.R`

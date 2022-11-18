# BASS_Iman_data

This repository is a sensitivity analysis using Bayesian Adaptive Spline Surface (BASS) method (Francom et al., 2020) based on the data from another study:

Hosseini-Shakib, I., Sharma, S., Lee, B.S., Srikrishnan, V.A., Nicholas, R., & Keller, K. (2022). Uncertainties surrounding flood hazard estimates is the primary driver of riverine flood risk projections. preprint 

See more details about this study in: https://github.com/imshakib/Hosseini-Shakib_etal_2022_preprint

## Below is a description to each file in the repository.

`BASS_param_set.RData` is an ensemble of 30,000 parameter samples after pre-calibration. 

`BASS_sensitivity.R` uses the BASS method to fit an emulator and perform sensitivity analysis using the dataset.

`wheel_plot.R` uses the sensitivity indices to make a "wheel diagram" to visualize the sensitivity analysis results.

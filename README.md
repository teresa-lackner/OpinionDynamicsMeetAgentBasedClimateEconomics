# Opinion Dynamics meet Agent-based Climate Economics: An Integrated Analysis of Carbon Taxation
This repository contains the NetLogo source code, data and scenarios of the follwing paper:

Lackner, T., Fierro, L. E., & Mellacher, P. (2025). Opinion dynamics meet agent-based climate economics: An integrated analysis of carbon taxation. Journal of Economic Behavior & Organization, 229, 106816.

DOI: https://doi.org/10.1016/j.jebo.2024.106816

## Usage
The file *OD model.nlogo* contains the opinion dynamics model. For calibration, the model requries empirical data as input which are collected in the folder *Calibration*.  


To replicate opinion dynamics of the 133 policy scenarios combining different carbon tax schemes and revenue recycling mechanisms, the model requires empirical data to initialize households and scenario-specific outputs of the DSK integrated assessment model which are collected in the folder *Policy scenarios*.
- The file *workers_details19_w.csv* (*workers_details19_w_new.csv*) is used for initialization of households in the main analysis (sensitivity analysis for alternative definition of opinion types, see section 5.2 in the paper).
- DSK outputs of the analyzed policy scenarios are found in the subfolder *carbon tax schemes*. The file name indicates the scenario where *ts* denotes introduction time of the carbon tax, *sl* its linear trend, *red* the share of earmarked carbon tax revenues and *sub* the green subsidies (comp. Table 4 in the paper). Note that timesteps 200, 221, 241, 261 and 281 correspond to years 2020, 2025, 2030, 2035 and 2040, respectively. E.g. *ts200_sl1e-04_red10e-01_sub8e-01.csv* includes data for the scenario which fares best in terms of public support: a carbon tax introduced early in 2020, with high linear trend parameter 10^(-4), where all revenues are earmarked for redistribution and green subisidies are high at 0.8.  
- DSK outputs of the sensitivity analysis regarding emission pathways of the rest of the world are collected in the subfolder *sensitivity to global emissions*. Again, the file name corresponds to the investigated scenario where *emiss_G* denotes the slope parameter describing the emission trajectory of the rest of the world. Unless specified differently, alternative values for *emiss_G* are applied to the carbon tax scheme with highest public support (see above). The other files include outputs of the DSK model assuming different values of *emiss_G* for alternative pure carbon tax schemes without revenue recycling, identified by the linear trend *sl*. 

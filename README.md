# DynamicTreadmillAnalysisCode

Our lab developed and has run several experiments with a dynamic treadmill controller that can selectively change gait symmetry by changing the speed of a conventional treadmill within a single stride. Here is all the analysis code and the accompanying data for our current projects. All of the raw data were compiled into MATLAB structures and are posted here as mat files. For all our analyses, we used the individual and group averages for all of our gait parameters of interest over the last 30 strides. These data were loaded into RStudio, where all our analyses were run. Treadmill speeds were set at a 2:1 ratio of 0.5m/s to 1.0m/s.

We have included the following code files: spatiotemporals, forces_code, calc_impulse_interlimb, CompileCode_ControlDynTread, averages_all, groundreactionforce_calc, CooPhase, COO_phasing_compileAvgs, InterlimbBiomechanicsAnalysis, COO_Phasing, phaseShiftasymmetryCorrelations, and all their respective function files. Below, you will find further descriptions of all the scripts and their necessary functions. 

The workflow and data are as follows:
  Post-process the motion capture and force plate data:
    Spatiotemporals.m 
    Forces_code.m
    Calc_impulse_interlimb.m 
  Functions needed in the same path:
    Get_trajectories_tied_markerset.m
    Calc_angle.m
    Edit_events.m
  Compile the data into easy to navigate structures:
    CompileCode_ControlDynTread.mlx
      The structures are organized as struct > participant > trial> spatiotemporal/forces > gait parameter > side 
  Calculate individual and group averages and standard errors of the mean:
    Averages_all.mlx 
  Calculate individual and group ground reaction force averages
    Groundreactionforce_calc.m
  Calculate phase shift and center of oscillation values:
    CooPhase.m
  Calculate phase shift and center of oscillation average and standard error of the mean values:
    COO_phasing_compileAvgs.m 
  Two-way repeated measures ANOVA to understand how the gait parameters differ by leg and trial:
    InterlimbBiomechanicsAnalysis.Rmd 
  One-way repeated measures ANOVA to understand how center of oscillation, center of oscillation difference, and phase shift differ by trial   and by leg (only for center of oscillation difference): 
    COO_Phasing.Rmd
  Pearson’s correlations between phase shift and center of oscillation difference on relevant gait parameter asymmetries:
    phaseShiftasymmetryCorrelations.Rmd



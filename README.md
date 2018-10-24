# DyDE

This folder contains the code that has been used to compare the accuracy of the network reconstruction performed by DyDE and by the algorithm proposed by (Huanfei Ma et al., 2014).

To rerun the analysis, please run “main.m”.

- Main.m contains the main routine that will load the benchmark dataset (millar10.mat) generated with the Pokhilko et al., 2010 model of the circadian clock of Arabidopsis. The latter has been simulated 50 times with the same noise level. Being stochastic simulations, the performances of each algorithm are changing for each run.

The following functions are associated with our algorithm:
- “just_tfest.m”
- “pcs.m”

The following functions are associated with Huanfei Ma et al., 2014 algorithm:
- “CMS_xy.m”
- “huanfeiRBF.m”
- “l1eq_pd.m”

The following functions are associated with the evaluation of results:
- “negative_millar_causality.m”
- “ROC_Millar10.m”
- “true_millar_causality.m”

The following functions are associated with the display of results:
- “ciplot.m”
- “plotROC_overExperiments.m”
- “uniquePairs.m”

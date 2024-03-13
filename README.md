This repository can be used to estimate time-resolved Drift and Stochasticity in non-stationary timeseries, as introduced in 
"Characterizing Time-Resolved Stochasticity in Non-Stationary Time Series", Rahvar et. al., (2024).


Note: The following R package is required to run the codes:

'stats'


Estimate the bandwidth: To choose a proper value for the bandwidth 'h', one can use different bandwidth selectors in 'stats' package.
For example,
    
    h=bw.nrd(x = x)

where x is the given timeseries. For a great review, see https://bookdown.org/egarpor/NP-UC3M/kde-i-bwd.html


Estimate the Markov–Einstein (ME) time scale: To check the Markovianity of the process and to estimate the corresponding ME time scale (with p-value < 0.05 and different lags [1,20]) run the Markov.R function as follows:

    Markov(x,seq(1,20,1),0.05)


Time-Resolved Drift and Stochasticity: 

    Stochasticity(x,0.1,51,1,PLOT=TRUE,ERR=FALSE,alpha=0.05)

Please, see the corresponding parameters in the Stochasticity.R file.


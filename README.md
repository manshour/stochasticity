## Description:


This repository contains the codes needed for estimating time-resolved Drift and Stochasticity in non-stationary timeseries, as introduced in "Characterizing Time-Resolved Stochasticity in Non-Stationary Time Series", Rahvar et. al., (2024).

## Dependencies:

The R package 'stats' is required to run the codes:

    install.packages('stats')
    library('stats')


## Estimate the bandwidth: 
To choose a proper value for the bandwidth 'h', one can use different bandwidth selectors in 'stats' package.
For example,
    
    h=bw.nrd(x = x)

where x is the given timeseries. For a great review, see [[1]].


## Estimate the Markov–Einstein (ME) time scale: 
To check the Markovianity of the process and to estimate the corresponding ME time scale (for example, with p-value < 0.05 and different lags 1 to 20) run the Markov.R function as follows:

    source('The location of Markov.R file/Markove.R')
    Markov(x,seq(1,20,1),0.05)




## Time-Resolved Drift and Stochasticity: 

    source('The location of Stochasticity.R file/Stochasticity.R')
    Stochasticity(x,0.1,51,1,PLOT=TRUE,ERR=FALSE,alpha=0.05)

Please, see the parameters' description in the Stochasticity.R file.

## Correspondence:
To send requests and bug reports about the code, please contact 
    Pouya Manshour at (manshour@cs.cas.cz).

To whom correspondence should be addressed, please contact 
    Pouya Manshour at (manshour@cs.cas.cz) 
    or 
    M. Reza Rahimitabar at (mohammed.r.rahimi.tabar@uni-oldenburg.de).


## Acknowledgments:
P. Manshour acknowledges support from the Czech Academy of Sciences, Praemium Academiae awarded to M. Paluš. M. R. Rahimitabar acknowledges Institute for Advanced Study (the Hanse-Wissenschaftskolleg) for their financial support.


[1]: https://bookdown.org/egarpor/NP-UC3M/kde-i-bwd.html


This repository can be used to estimate time-resolved Drift and Stochasticity in non-stationary timeseries, as introduced in 
"Characterizing Time-Resolved Stochasticity in Non-Stationary Time Series", Rahvar et. al., (2024).


Note: The following R package is required to run the codes:

'stats'


For choosing a proper value for the bandwidth 'h', one can use different bandwidth selectors in 'stats' package.
For example,
    
    h=bw.nrd(x = x)

where x is the given timeseries.
  
For a great review, see https://bookdown.org/egarpor/NP-UC3M/kde-i-bwd.html

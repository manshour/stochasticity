
# Code for the paper "Characterizing Time-Resolved Stochasticity in Non-Stationary Time Series" by S. Rahvar, et al. 




# Step 1: Read the (1dimensional) data of type double;                              timeseries = scan("insert_the_location_of_your_data.txt") 

# Step 2: Choose the bandwidth;                                                     Default -->  h    = 0.1   

# Step 3: Set the number of bins for kernel estimations of F and M;                 Default -->  n    = 51 

# Step 4: Choose the sampling interval of data (dt);                                Default -->  dt   = 1  

# Step 5: Set PlOT as TRUE to plot F and M vs. time and vs. x;                      Default -->  PLOT = TRUE 

# Step 6: Set ERR as TRUE to compute confidence intervals for F and M;              Default -->  PLOT = TRUE 

# Step 7: alpha is the significance level used to compute the confidence interval;  Default -->  alpha= 0.05

# For example:
                 # output = stochasticity(timeseries,h=0.1,n=51,dt=0.01,PLOT=TRUE,ERR=TRUE,alpha=0.05)
                 
                 # output$t         ---> time
                 # output$F_t       ---> Drift         vs time
                 # output$M_t       ---> Stochasticity vs time

                 # output$binned_ts ---> binned values (x) of the given timeseries
                 # output$F_x       ---> Drift         vs x
                 # output$M_x       ---> Stochasticity vs x

                 # output$F_t_low   ---> lower limit of confidence level for Drift vs t
                 # output$F_t_up    ---> upper limit of confidence level for Drift vs t
                 # output$F_x_low   ---> lower limit of confidence level for Drift vs x
                 # output$F_x_up    ---> upper limit of confidence level for Drift vs x
                  
                 # output$M_t_low   ---> lower limit of confidence level for Stoch.vs t
                 # output$M_t_up    ---> upper limit of confidence level for Stoch.vs t
                 # output$M_x_low   ---> lower limit of confidence level for Stoch.vs x
                 # output$M_x_up    ---> upper limit of confidence level for Stoch.vs x



#Please note that in Step 4, you need to insert the value of the chosen sampling interval (dt). The rest of the code remains the same, and you can use it to analyze your time series data as described in the paper. Regenerate response



Stochasticity <- function(timeseries=rnorm(1e4),h=0.1,n=51,dt=1,PLOT=TRUE,ERR=FALSE,alpha=0.05)  {
	require(KernSmooth)

  timeseries[is.na(timeseries)] <- 0
  bw    <- h*sd(timeseries) 
  N=length(timeseries)
  
	dx=diff(timeseries);
	binned_ts  <- seq(min(timeseries),max(timeseries),length.out=n)
	Kmat <- matrix(0,n,N-1); for(i in 1:(N-1)) {Kmat[,i] <- (1/sqrt(2*pi*bw^2)) * exp(-0.5 * (timeseries[i]-binned_ts)^2 / bw^2 )}
	F_x=rep(0,n);M_x=F_x;
	for(i in 1:n) {
	  Ksum    <- sum(Kmat[i,])
	  F_x[i] <-     (1/dt)*sum(Kmat[i,]*dx  )/Ksum;
	  M_x[i] <-     (1/dt)*sum(Kmat[i,]*dx^2)/Ksum;
	}
	
	F_t    <- approx(x=binned_ts,y=F_x ,xout=timeseries)$y;
	M_t    <- approx(x=binned_ts,y=M_x ,xout=timeseries)$y;
	
	t=c(1:N)*dt;
	

	if (ERR == TRUE){
	  norm_K=(2*sqrt(pi))^-1
	  f_x=M_x;M2_x=M_x;M_x_up=M_x;M_x_low=M_x;F2_x=M2_x;F_x_up=M2_x;F_x_low=M2_x
	  for(i in 1:n) {
	    Ksum        <- sum(Kmat[i,])
	    f_x     [i] <- sum(Kmat[i,])/N
	    F2_x    [i] <- sum(Kmat[i,] * (   (dx/dt) -  F_x[i] )^2    ) / Ksum;
	    M2_x    [i] <- sum(Kmat[i,] * (   (dx^2/dt) -  M_x[i] )^2  ) / Ksum;
	    D_M           <- (1-alpha/2)*sqrt (norm_K* M2_x[i] /  ( N * bw * f_x[i])    ) 
	    D_F           <- (1-alpha/2)*sqrt (norm_K* F2_x[i] /  ( N * bw * f_x[i])    ) 
	    M_x_up  [i] <- M_x[i] + D_M; M_x_low [i] <- M_x[i] - D_M
	    F_x_up  [i] <- F_x[i] + D_F; F_x_low [i] <- F_x[i] - D_F
	  }
	  M_t_low    <- approx(x=binned_ts,y=M_x_low ,xout=timeseries)$y;M_t_up     <- approx(x=binned_ts,y=M_x_up  ,xout=timeseries)$y;
	  F_t_low    <- approx(x=binned_ts,y=F_x_low ,xout=timeseries)$y;F_t_up     <- approx(x=binned_ts,y=F_x_up  ,xout=timeseries)$y;

	  if (PLOT==TRUE){
	    dev.new(noRStudioGD = TRUE)
	    par(mfrow=c(3,2),mar=c(3, 3, 2, 2),mgp=c(1.5,0.5,0),oma=c(1,1,1,1))
	    
	    layout(matrix(c(1,1,2,3,4,5), ncol = 2, byrow = TRUE))
	    
	    
	    
	    plot( t         , timeseries    ,type='l',lwd=1         ,col='black',xlab='t',ylab='x(t)'  )
	    plot( binned_ts , F_x           ,type='p',pch=20       ,col='black',xlab='x',ylab='F(x,t)')
	    lines(binned_ts , F_x_up        ,lwd=1 ,col='red');lines(binned_ts , F_x_low ,lwd=1,col='red')
	    
	    plot( t         , F_t           ,type='p',pch=20       ,col='black',xlab='t',ylab='F(x,t)')
	    arrows(t, F_t_up, t, F_t_low, angle=90, code=3, length=0.02, col="red")
	    

	    plot( binned_ts , M_x           ,type='p',pch=20      ,col='black',xlab='x',ylab='M(x,t)')
	    lines(binned_ts , M_x_up        ,lwd=1 ,col='red');lines(binned_ts , M_x_low ,lwd=1,col='red')
	    
	    plot( t         , M_t           ,type='p',pch=20       ,col='black',xlab='t',ylab='M(x,t)')
	    arrows(t, M_t_up, t, M_t_low, angle=90, code=3, length=0.02, col="red")
	    
	  }
	  return(list("t"=t,"F_t"=F_t,"M_t"=M_t,"F_t_low"=F_t_low,"F_t_up"=F_t_up,"F_x_low"=F_x_low,"F_x_up"=F_x_up,"M_t_low"=M_t_low,"M_t_up"=M_t_up,"x"=binned_ts,"F_x"=F_x,"M_x"=M_x,"M_x_low"=M_x_low,"M_x_up"=M_x_up))
	         
	  
  }else{
    
    if (PLOT==TRUE){
      dev.new(noRStudioGD = TRUE)
      par(mfrow=c(3,2),mar=c(3, 3, 2, 2),mgp=c(1.5,0.5,0),oma=c(1,1,1,1))
      layout(matrix(c(1,1,2,3,4,5), ncol = 2, byrow = TRUE))
      
      plot( t         , timeseries    ,type='l',lwd=1         ,col='black',xlab='t',ylab='x(t)'  )
      plot( binned_ts , F_x           ,type='p',pch=20       ,col='black',xlab='x',ylab='F(x,t)')
      plot( t         , F_t           ,type='p',pch=20       ,col='black',xlab='t',ylab='F(x,t)')
      plot( binned_ts , M_x           ,type='p',pch=20       ,col='black',xlab='x',ylab='M(x,t)')
      plot( t         , M_t           ,type='p',pch=20       ,col='black',xlab='t',ylab='M(x,t)')
    }
    return(list("t"=t,"F_t"=F_t,"M_t"=M_t,"x"=binned_ts,"F_x"=F_x,"M_x"=M_x))
    
  }
	
	
	

}


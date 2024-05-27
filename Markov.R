# This code estimates the Markov-Einstein length using Wilcoxon test

# Step 1: Read the (1dimensional) data of type double;  timeseries = scan("insert_the_location_of_your_data.txt") 

# Step 2: Set the range of needed lags;                 Default -->  Lag_range    = seq(1,20,1)   

# Step 3: Set the significance level alpha;             Default -->  alpha        = 0.05 

# needs package 'stats', so install it before use

Markov=function (timeseries,Lag_range=seq(1,20,1),alpha=0.05){
  
  OO=1;p_value=rep(0,length(LAG_range))
  
  for (LAG in LAG_range){
    
    a=seq(from=1,to=length(timeseries),by=LAG);
    variableData=a;for (i  in 1:length(a)) {variableData[i]=timeseries[a[i]]}
    variableData <- variableData - mean(variableData)
    labels <- as.numeric(factor(variableData, levels = unique(variableData)))
    differences <- diff(labels)
    p_value[OO] <- wilcox.test(differences)$p.value
    OO=OO+1
  }
  
  plot(LAG_range,p_value,pch = 20,xlab = "lag",ylab = "P-Value",ylim = c(0,1));abline(h=alpha)
  
  idx=which(p_value<=alpha)[1]
  if (is.na(idx)){
    cat("Data is not Markov for the chosen time lags! \n")
  }else{
    xx=LAG_range[idx];yy=p_value[idx];points(xx,yy,cex=2,col="red",lw=3)
    cat("Data is Markov for time lag =",xx," \n \n")
    cat("with P-Value:               =",yy)
  }
  
}

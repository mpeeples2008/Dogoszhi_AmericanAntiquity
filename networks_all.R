require(sqldf)
require(compiler)
require(reshape)
require(msm)
require(snowfall)
require(parallel)
require(statnet)
library(igraph)
library(vegan)


load('apportioned.RData')

############ SETUP INTERVALS

wareapp2 <- wareapp

per.list2 <- c('AD900','AD950','AD1000','AD1050','AD1100','AD1150')
lookup.list <- list(c(8:9),c(10:11),c(12:13),c(14:15),c(16:17),c(18:19))

for (i in 1:length(per.list2)) {
  warevar <- wareapp2[,1:3]
  cer <- wareapp2[,lookup.list[[i]]]
  if (!is.null(ncol(cer))) {cer <- rowSums(cer)}
  cer <- cbind(warevar,cer)
  out <- cast(cer,Site~SWSN_Ware,fun.aggregate = sum)
  out[is.na(out)] <- 0
  rownames(out) <- out[,1]
  
  assign(paste(per.list2[i]),out)}


####################################################################################################
###TRIM AND RENAME CERAMIC AND ATTRIBUTE DATA FRAMES BY PERIOD######################################
####################################################################################################

cer.output <- list(AD900,AD950,AD1000,AD1050,AD1100,AD1150)

for (i in 1:length(per.list2)) {
  cer <- (cer.output[[i]])
  cer <- cer[,-1]
  trim <- which(rowSums(as.matrix(cer))>=10)
  cer <- cer[trim,]
  cer2 <- as.matrix(cer[,which(colSums(cer)>0)])
  colnames(cer2) <- colnames(cer)[which(colSums(cer)>0)]
  row.names(cer2) <- row.names(cer)
  assign(paste((per.list2[i]),"cer",sep=""),cer2)
}


####################################################################################################
### CREATE SIMILARITY MATRICES AND NETWORKS BY PERIOD  #############################################
####################################################################################################

sim.mat <- function(x) {
  names <- row.names(x)
  x <- na.omit(x)
  x <- prop.table(as.matrix(x),1)*100
  rd <- dim(x)[1]
  results <- matrix(0,rd,rd)
  for (s1 in 1:rd) {
    for (s2 in 1:rd) {
      x1Temp <- as.numeric(x[s1, ])
      x2Temp <- as.numeric(x[s2, ])
      results[s1,s2] <- 200 - (sum(abs(x1Temp - x2Temp)))}}
  row.names(results) <- names
  colnames(results) <- names
  results <- results/200
  results <- round(results,3)
  return(results)}


AD900sim <- sim.mat(AD900cer)
AD950sim <- sim.mat(AD950cer)
AD1000sim <- sim.mat(AD1000cer)
AD1050sim <- sim.mat(AD1050cer)
AD1100sim <- sim.mat(AD1100cer)
AD1150sim <- sim.mat(AD1150cer)

####################################################################################################
###EIGENVECTOR CENTRALITY###########################################################################
####################################################################################################

## calculate eigenvector centraility and standardize on star network

AD900ev <- as.matrix(sna::evcent(AD900sim))
AD900ev <- sqrt((AD900ev^2) * length(AD900ev))

AD950ev <- as.matrix(sna::evcent(AD950sim))
AD950ev <- sqrt((AD950ev^2) * length(AD950ev))

AD1000ev <- as.matrix(sna::evcent(AD1000sim))
AD1000ev <- sqrt((AD1000ev^2) * length(AD1000ev))

AD1050ev <- as.matrix(sna::evcent(AD1050sim))
AD1050ev <- sqrt((AD1050ev^2) * length(AD1050ev))

AD1100ev <- as.matrix(sna::evcent(AD1100sim))
AD1100ev <- sqrt((AD1100ev^2) * length(AD1100ev))

AD1150ev <- as.matrix(sna::evcent(AD1150sim))
AD1150ev <- sqrt((AD1150ev^2) * length(AD1150ev))


AD900cent <- as.data.frame(cbind(row.names(AD900cer),AD900ev))
colnames(AD900cent) <- c('Site','EV_900')
AD900cent[,2] <- as.numeric(as.vector(AD900cent[,2]))

AD950cent <- as.data.frame(cbind(row.names(AD950cer),AD950ev))
colnames(AD950cent) <- c('Site','EV_950')
AD950cent[,2] <- as.numeric(as.vector(AD950cent[,2]))

AD1000cent <- as.data.frame(cbind(row.names(AD1000cer),AD1000ev))
colnames(AD1000cent) <- c('Site','EV_1000')
AD1000cent[,2] <- as.numeric(as.vector(AD1000cent[,2]))

AD1050cent <- as.data.frame(cbind(row.names(AD1050cer),AD1050ev))
colnames(AD1050cent) <- c('Site','EV_1050')
AD1050cent[,2] <- as.numeric(as.vector(AD1050cent[,2]))

AD1100cent <- as.data.frame(cbind(row.names(AD1100cer),AD1100ev))
colnames(AD1100cent) <- c('Site','EV_1100')
AD1100cent[,2] <- as.numeric(as.vector(AD1100cent[,2]))

AD1150cent <- as.data.frame(cbind(row.names(AD1150cer),AD1150ev))
colnames(AD1150cent) <- c('Site','EV_1150')
AD1150cent[,2] <- as.numeric(as.vector(AD1150cent[,2]))


rm(AD900,AD950,AD1000,AD1050,AD1100,AD1150,cer,cer.output,lookup.list,out,wareapp2,warevar,i,per.list2,trim,
   AD900ev,AD950ev,AD1000ev,AD1050ev,AD1100ev,AD1150ev,cer2)

save.image('network.RData')

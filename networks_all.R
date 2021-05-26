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

per.list2 <- c('AD900_950','AD950_1000','AD1000_1050','AD1050_1100','AD1100_1150','AD1150_1200')
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

cer.output <- list(AD900_950,AD950_1000,AD1000_1050,AD1050_1100,AD1100_1150,AD1150_1200)

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


AD900_950sim <- sim.mat(AD900_950cer)
AD950_1000sim <- sim.mat(AD950_1000cer)
AD1000_1050sim <- sim.mat(AD1000_1050cer)
AD1050_1100sim <- sim.mat(AD1050_1100cer)
AD1100_1150sim <- sim.mat(AD1100_1150cer)
AD1150_1200sim <- sim.mat(AD1150_1200cer)

####################################################################################################
###EIGENVECTOR CENTRALITY###########################################################################
####################################################################################################

AD900_950ev <- as.matrix(sna::evcent(AD900_950sim))
AD900_950ev <- sqrt((AD900_950ev^2) * length(AD900_950ev))

AD950_1000ev <- as.matrix(sna::evcent(AD950_1000sim))
AD950_1000ev <- sqrt((AD950_1000ev^2) * length(AD950_1000ev))

AD1000_1050ev <- as.matrix(sna::evcent(AD1000_1050sim))
AD1000_1050ev <- sqrt((AD1000_1050ev^2) * length(AD1000_1050ev))

AD1050_1100ev <- as.matrix(sna::evcent(AD1050_1100sim))
AD1050_1100ev <- sqrt((AD1050_1100ev^2) * length(AD1050_1100ev))

AD1100_1150ev <- as.matrix(sna::evcent(AD1100_1150sim))
AD1100_1150ev <- sqrt((AD1100_1150ev^2) * length(AD1100_1150ev))

AD1150_1200ev <- as.matrix(sna::evcent(AD1150_1200sim))
AD1150_1200ev <- sqrt((AD1150_1200ev^2) * length(AD1150_1200ev))


AD900cent <- as.data.frame(cbind(row.names(AD900_950cer),AD900_950ev))
colnames(AD900cent) <- c('Site','EV_900')
AD900cent[,2] <- as.numeric(as.vector(AD900cent[,2]))

AD950cent <- as.data.frame(cbind(row.names(AD950_1000cer),AD950_1000ev))
colnames(AD950cent) <- c('Site','EV_950')
AD950cent[,2] <- as.numeric(as.vector(AD950cent[,2]))

AD1000cent <- as.data.frame(cbind(row.names(AD1000_1050cer),AD1000_1050ev))
colnames(AD1000cent) <- c('Site','EV_1000')
AD1000cent[,2] <- as.numeric(as.vector(AD1000cent[,2]))

AD1050cent <- as.data.frame(cbind(row.names(AD1050_1100cer),AD1050_1100ev))
colnames(AD1050cent) <- c('Site','EV_1050')
AD1050cent[,2] <- as.numeric(as.vector(AD1050cent[,2]))

AD1100cent <- as.data.frame(cbind(row.names(AD1100_1150cer),AD1100_1150ev))
colnames(AD1100cent) <- c('Site','EV_1100')
AD1100cent[,2] <- as.numeric(as.vector(AD1100cent[,2]))

AD1150cent <- as.data.frame(cbind(row.names(AD1150_1200cer),AD1150_1200ev))
colnames(AD1150cent) <- c('Site','EV_1150')
AD1150cent[,2] <- as.numeric(as.vector(AD1150cent[,2]))


rm(AD900_950,AD950_1000,AD1000_1050,AD1050_1100,AD1100_1150,AD1150_1200,cer,cer.output,lookup.list,out,wareapp2,warevar,i,per.list2,trim)

save.image('network.RData')

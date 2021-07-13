####################################################################################################
###SETUP REQUIRED LIBRARIES#########################################################################
####################################################################################################

require(sqldf)
require(compiler)
require(reshape)
require(msm)
require(snowfall)
require(parallel)

p.beg <- 800
p.end <- 1300
interval <- 25

nperiods <- (p.end-p.beg)/interval
c.lab <- NULL
for (i in 1:nperiods) {c.lab[i] <- p.beg + ((i-1)*interval)} # Create column labels for apportioned  matrix
a.lab <- NULL
for (i in 1:length(c.lab)) {
  a.lab[i] <- paste('P',c.lab[i],sep='')}
cer.lab <- NULL
for (i in 1:length(c.lab)) {
  cer.lab[i] <- paste('CER',c.lab[i],sep='')}
midpts <- NULL
for (i in 1:length(c.lab)) {
  midpts[i] <- round(c.lab[i]+(interval/2),0)}


####################################################################################################
###SETUP ERROR CHECKING#############################################################################
####################################################################################################

error.chk <- function(x) {
tmp <- rep(0,length=nrow(x))
for (j in 1:nrow(x)) {
w0 <- x$BegType[j]  # Begining date for ware/type
w1 <- x$EndType[j]  # End date for ware/type
s0 <- x$BegAge[j]   # Beginning date for site occupation
s1 <- x$EndAge[j]   # End date for site occupation
	if (w1 <= s0) {tmp[j] <- 1}
	if (w0 >= s1) {tmp[j] <- 1}}
return(as.matrix(tmp))}

####################################################################################################
###SETUP APPORTIONING SCRIPT########################################################################
####################################################################################################

apportion <- function(x) {

require(msm)
  
  p.beg <- 800
  p.end <- 1300
  interval <- 25
  
  nperiods <- (p.end-p.beg)/interval
  c.lab <- NULL
  for (i in 1:nperiods) {c.lab[i] <- p.beg + ((i-1)*interval)} # Create column labels for apportioned  matrix

Site <- as.vector(x[['SWSN_Site']])
Type <- as.vector(x[['Type']])
ct <- x[['Count']]
w0 <- x[['BegType']]
w1 <- x[['EndType']]
s0 <- x[['BegAge']]
s1 <- x[['EndAge']]
id <- x[['SWSN_ID']]


zsd <- 2  # set truncation points
beg.date <- p.beg # set beginning date for period considered
end.date <- p.end # set end date for period considered

mat <- matrix(0,nrow(x),nperiods)
colnames(mat) <- c.lab

unapportioned <- rep(0,nrow(x)) # create variable for sherds not apportioned to period considered

######  round site occupation length to multiples of interval
for (i in 1:length(s0)) {if ((s0[i]/interval) != (round(s0[i]/interval,0))) {s0[i] <- interval*floor(s0[i]/interval)}}
for (i in 1:length(s1)) {if ((s1[i]/interval) != (round(s1[i]/interval,0))) {s1[i] <- interval*ceiling(s1[i]/interval)}}

for (j in 1:nrow(x)) {

ware_seq <- seq(w0[j],w1[j],by=1)
zscore <- seq(-zsd,zsd,by=0.0001)
pdist <- ptnorm(zscore,0,1,-zsd,zsd)

g <- w1[j]-w0[j]
m <- mean(ware_seq)

site_seq <- seq(s0[j],s1[j])

ws_overlap <- intersect(ware_seq,site_seq)
vj0 <- min(ws_overlap)
vj1 <- max(ws_overlap)

z20 <- (vj0 - m)/(g/(2*zsd))
z21 <- (vj1 - m)/(g/(2*zsd))
i0 <- which(abs(zscore-z20)==min(abs(zscore-z20)))
i1 <- which(abs(zscore-z21)==min(abs(zscore-z21)))
z_phi20 <- pdist[i0]
z_phi21 <- pdist[i1]

for (i in 1:nperiods) {
if (length(intersect(seq(c.lab[i],(c.lab[i]+interval-1)),ws_overlap[1:length(ws_overlap)-1]))>0) {
zj0 <- (c.lab[i] - m)/(g/(2*zsd))
zj1 <- ((c.lab[i]+interval)-m)/(g/(2*zsd))
i0 <- which(abs(zscore-zj0)==min(abs(zscore-zj0)))
i1 <- which(abs(zscore-zj1)==min(abs(zscore-zj1)))
z_phi0 <- pdist[i0]
z_phi1 <- pdist[i1]
pjt_1a <- (z_phi1-z_phi0)/(z_phi21-z_phi20)
mat[j,i] <- pjt_1a * ct[j]}}

if (s0[j] < p.beg || s1[j] > p.end) {unapportioned[j] <- ct[j] - sum(mat[j,])}}

mat <- round(mat,4)
unapportioned <- round(unapportioned,4)
mat <- cbind(id,Site,Type,unapportioned,mat)
mat <- as.data.frame(mat)
return(mat) 
} ## end function

####################################################################################################
###SETUP IPF SCRIPT#################################################################################
####################################################################################################
# Iterative proportional fitting code edited from Alaska Department of Labor and Workforce Development, 2009
# (Updated April 2011) - EDITED BY PEEPLES FOR SWSN DATA

ipf <- function(rowcontrol, colcontrol, seed, maxiter=50, closure=0.0000001, debugger=FALSE){
   # input data checks: 
if(debugger)print("checking inputs")
#sum of marginal totals equal and no zeros in marginal totals
if(debugger){print("checking rowsum=colsum")}
   if(round(sum(rowcontrol),4) != round(sum(colcontrol),4)) 
stop("sum of rowcontrol must equal sum of colcontrol")
if(debugger){print("checking rowsums for zeros")}
   if(any(rowcontrol==0)){
      numzero <- sum(rowcontrol==0)
      rowcontrol[rowcontrol==0] <- 0.0000001
      warning(paste(numzero, "zeros in rowcontrol argument replaced with 0.000001", sep=" "))
      }
if(debugger){print("Checking colsums for zeros")}
   if(any(colcontrol==0)){
      numzero <- sum(colcontrol==0)
      colcontrol[colcontrol==0] <- 0.0000001
      warning(paste(numzero, "zeros in colcontrol argument replaced with 0.0001", sep=" "))
      }
if(debugger){print("Checking seed for zeros")}
   if(any(seed==0)){
      numzero <- sum(seed==0)
      seed[seed==0] <- 0.0000001
      warning(paste(numzero, "zeros in seed argument replaced with 0.0001", sep=" "))
      }
   # set initial values
   result <- seed
   rowcheck <- 1
   colcheck <- 1
   checksum <- 1
   iter <- 0
   # successively proportion rows and columns until closure or iteration criteria are met
##########
if(debugger){print(checksum > closure);print(iter < maxiter)}
   while((checksum > closure) && (iter < maxiter))
      {
#########
if(debugger){print(paste("(re)starting the while loop, iteration=",iter)) }

 coltotal <- colSums(result)
 colfactor <- colcontrol/coltotal
 result <- sweep(as.matrix(result), 2, as.matrix(colfactor), "*")
if(debugger){
print(paste("column factor = ",colfactor))
print(result)}

 rowtotal <- rowSums(result)
 rowfactor <- rowcontrol/rowtotal
 result <- sweep(as.matrix(result), 1, as.matrix(rowfactor), "*")
if(debugger){
print(paste("row factor = ",rowfactor))
print(result)}

       rowcheck <- sum(abs(1-rowfactor))
 colcheck <- sum(abs(1-colfactor))
         checksum <- max(rowcheck,colcheck)
 iter <- iter + 1
#print(paste("Ending while loop, checksum > closure",checksum > closure,"iter < maxiter",iter < maxiter))
      }#End while loop

   out <- list(fitted.table=result, number.iterations=iter, tolerance=checksum)
   result}

####################################################################################################
###SETUP VARIABLES AND READ FILES###################################################################
####################################################################################################

Ceramic_type_master <- read.table(file='Ceramic_type_master.csv',sep=',',header=T)
preapportion <- read.table(file='preapportion.csv',sep=',',header=T)
dim(preapportion)

exclude <- error.chk(preapportion)
dat.cln <- preapportion[which(exclude==0),]
dim(dat.cln)

dat.cln2 <- split(dat.cln, rep(1:nrow(dat.cln), each = 1))

pop <- matrix(0,nrow(dat.cln),length(c.lab))
colnames(pop) <- a.lab

for (j in 1:nrow(dat.cln)) {
  for (i in 1:length(c.lab)) {
    if (dat.cln[j,]$BegAge<(midpts[i]+1) & dat.cln[j,]$EndAge>(midpts[i]-1)) {
      pop[j,i] <- (midpts[i]-dat.cln[j,]$BegAge)/(dat.cln[j,]$EndAge-dat.cln[j,]$BegAge)
      pop[j,i] <- ((-0.64646*pop[j,i]^3-0.75844*pop[j,i]^2+1.79582*pop[j,i]+0.3803)*10)*1.4923*10^-0.1592
    }}}



####################################################################################################
###RUN APPORTIONING SCRIPT AND CHECK VALUES#########################################################
####################################################################################################

apportion2 <- cmpfun(apportion)

cl <- makeSOCKcluster(detectCores())
apptab <- parLapply(cl,dat.cln2,fun=apportion2)
stopCluster(cl)
apptab <- do.call(rbind,apptab)
colnames(apptab) <- c('SWSN_ID','Site','Type','unapportioned',a.lab)

check.sum <- matrix(0,nrow(apptab))
for (i in 1:nrow(apptab)) {
z <- apptab[i,4:(nperiods+4)]
z <- sum(as.numeric(as.vector(as.matrix(z))))
check.sum[i] <- round(dat.cln$Count[i] - z,0)}
max(check.sum)
min(check.sum)

####################################################################################################
###RUN IPF ON APPORTIONED DATA BASED ON ROOM COUNTS#################################################
####################################################################################################

room.adj <- function(x) {
x_app <- x[,5:(nperiods+4)]
pop2 <- x[1,(nperiods+5):ncol(x)]
pop2 <- pop2/sum(pop2)
col.m <- pop2*sum(x_app)
row.m <- as.vector(rowSums(x_app))
room.app <- ipf(row.m,col.m,x_app)
return(room.app)}

room.adj2 <- cmpfun(room.adj)

app4ipf <- cbind(apptab,pop)
write.table(app4ipf,file='app_init.csv',sep=',',row.names=F)
app4ipf <- read.table(file='app_init.csv',sep=',',header=T)
room.array <- by(app4ipf,app4ipf$SWSN_ID,room.adj2)
roomapp <- as.matrix(as.data.frame(room.array[1]))
for (i in 2:dim(room.array)) {
temp <- as.matrix(as.data.frame(room.array[i]))
roomapp <- round(rbind(roomapp,temp),4)}
roomapp <- cbind(apptab[,1:4],roomapp) ## room apportioned data

####################################################################################################
###WRITE INITIAL AND ROOM ADJUSTED APPORTIONED DATA#################################################
####################################################################################################

write.table(apptab,file='app_init.csv',sep=',')
write.table(roomapp,file='app_room.csv',sep=',')
app.init <- read.table(file='app_init.csv',sep=',',header=T)
app.room <- read.table(file='app_room.csv',sep=',',header=T)

####################################################################################################
###CHECK FOR ERRORS IN IPF PROCEDURE################################################################
####################################################################################################

apportion.check <- function(x) {
test.mat <- matrix(0,nrow(x))
for (i in 1:nrow(x)) {
ware_seq <- seq(x[i,1],x[i,2])
for (j in 1:nperiods) {
if (sum(intersect(seq(c.lab[j]+1,(c.lab[j]+interval)),ware_seq))==0) {
if (as.numeric(x[i,j+6]) > 0) {test.mat[1:nrow(x),] <- 1}}}}
return(test.mat)}

app.room2 <- cbind(dat.cln$BegType,dat.cln$EndType,app.room)

ap.chk <- by(app.room2,app.room2$SWSN_ID,apportion.check)
output2 <- as.matrix(as.data.frame(ap.chk[1]))
for (i in 2:dim(ap.chk)) {
temp2 <- as.matrix(as.data.frame(ap.chk[i]))
output2 <- rbind(output2,temp2)}
colnames(output2) <- c('rm_adj_err')

####################################################################################################
###GROUP APPORTIONED DATA BASED ON IPF ERROR CHECK##################################################
####################################################################################################

group.periods <- function(x,y,appchecker) {
  GRP <- matrix(0,nrow(x),(ncol(x)-4))
  names <- x[,1:4]
  x <- x[,5:ncol(x)]
  y <- y[,5:ncol(y)]
  for (i in 1:nrow(x)) {
    if (appchecker[i,1]==0) {
      for (j in 1:ncol(x)) {GRP[i,j] <- x[i,j]}}
    else {
      for (j in 1:ncol(x)) {GRP[i,j] <- y[i,j]}}}
  out <- cbind(names,GRP)
  return(out)}

final <- group.periods(app.room,app.init,output2)
colnames(final) <- colnames(apptab)


####################################################################################################
###CONVERT TYPE DATA TO WARES ######################################################################
####################################################################################################

sqltext <- 'SELECT final.SWSN_ID, final.Site, Ceramic_type_master.SWSN_Ware, '
for (i in 1:length(a.lab)) {
  sqltext <- paste(sqltext,"sum(final.",a.lab[i],")*1 AS ",a.lab[i],", ",sep="")}
sqltext <- substr(sqltext,1,nchar(sqltext)-2)
sqltext <- paste(sqltext,"FROM Ceramic_type_master INNER JOIN final ON Ceramic_type_master.SWSN_Type = final.Type
                   WHERE (Ceramic_type_master.Decoration='bichrome' Or Ceramic_type_master.Decoration='polychrome' Or Ceramic_type_master.Decoration='undifferentiated dec') AND (Ceramic_type_master.SWSN_Ware Not Like 'Undiff%')
                   GROUP BY final.SWSN_ID, final.Site, Ceramic_type_master.SWSN_Ware")


sqlall <- 'SELECT final.SWSN_ID, final.Site, Ceramic_type_master.SWSN_Ware, '
for (i in 1:length(a.lab)) {
  sqlall <- paste(sqlall,"sum(final.",a.lab[i],")*1 AS ",a.lab[i],", ",sep="")}
sqlall <- substr(sqlall,1,nchar(sqlall)-2)
sqlall <- paste(sqlall,"FROM Ceramic_type_master INNER JOIN final ON Ceramic_type_master.SWSN_Type = final.Type
                  GROUP BY final.SWSN_ID, final.Site, Ceramic_type_master.SWSN_Ware")


sqltype <- 'SELECT final.SWSN_ID, final.Site, Ceramic_type_master.SWSN_Type, '
for (i in 1:length(a.lab)) {
  sqltype <- paste(sqltype,"sum(final.",a.lab[i],")*1 AS ",a.lab[i],", ",sep="")}
sqltype <- substr(sqltype,1,nchar(sqltype)-2)
sqltype <- paste(sqltype,"FROM Ceramic_type_master INNER JOIN final ON Ceramic_type_master.SWSN_Type = final.Type
                  GROUP BY final.SWSN_ID, final.Site, Ceramic_type_master.SWSN_Type")


wareapp <- sqldf(sqltext)
wareall <- sqldf(sqlall)
typeapp <- sqldf(sqltype)

rm(a.lab,c.lab,cer.lab,i,interval,j,midpts,nperiods,p.beg,p.end,sqlall,sqltext,sqltype,z,apportion,apportion.check,apportion2,error.chk,group.periods,ipf,
   room.adj,room.adj2,ap.chk,app.init,app.room,app.room2,app4ipf,apptab,check.sum,cl,dat.cln,dat.cln2,exclude,final,output2,pop,room.array,roomapp,temp,temp2)


save.image('apportioned.RData')


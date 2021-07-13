library(tidyverse)
library(forcats)
library(ggplot2)
library(ggpubr)


load('network.RData')

mancos <- 0.4 # set the proportion of Mancos that is in Dogoszhi style

### Read in data files
types <- read.csv('types.csv',header=T)
site_attr <- read.csv('sites.csv',header=T)
dat <- typeapp

### filter input to only include painted ceramics with specific type designations
dat <- dat %>%
  left_join(types, by=c('SWSN_Type' = 'SWSN_Type')) %>%
  filter(Include!=0)

### run the analysis for each time period and join
source('Dogoszhi_900.R')
source('Dogoszhi_950.R')
source('Dogoszhi_1000.R')
source('Dogoszhi_1050.R')
source('Dogoszhi_1100.R')
source('Dogoszhi_1150.R')

all_ceramics <- Ceramics_900 %>%
  full_join(Ceramics_950) %>%
  full_join(Ceramics_1000) %>%
  full_join(Ceramics_1050) %>%
  full_join(Ceramics_1100) %>%
  full_join(Ceramics_1150)

full <- all_ceramics %>%
  left_join(site_attr, by = c('Site' = 'SWSN_Site'))


write.csv(full,'All_Analysis.csv',row.names=F)

source('figures.R')

rm(Painted_900,Painted_950,Painted_1000,Painted_1050,Painted_1100,Painted_1150,
   BlackMesa_900,BlackMesa_950,BlackMesa_1000,BlackMesa_1050,BlackMesa_1100,BlackMesa_1150,
   Dogoszhi_900,Dogoszhi_950,Dogoszhi_1000,Dogoszhi_1050,Dogoszhi_1100,Dogoszhi_1150,
   Ceramics_900,Ceramics_950,Ceramics_1000,Ceramics_1050,Ceramics_1100,Ceramics_1150,
   Ceramics_900,Ceramics_950,Ceramics_1000,Ceramics_1050,Ceramics_1100,Ceramics_1150,
   site_attr,types,mancos,p1,p2,p3,p4)

save.image("All_Analysis.Rdata")
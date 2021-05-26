library(tidyverse)

### Read in data files
types <- read.csv('types.csv',header=T)
site_attr <- read.csv('sites.csv',header=T)
dat <- read.csv('Apportioning.csv',header=T,row.names=1)

### filter input to only include painted ceramics with specific type designations
dat <- dat %>%
  left_join(types, by=c('Type' = 'SWSN_Type')) %>%
  filter(Include!=0)

### Summarize total painted ceramic type count by Site for the 1200-1100 interval
Ceramics_1200 <- dat %>%
  group_by(Site) %>%
  summarize(Painted_1200 = sum(P1200,P1225)) 

### Summarize Dogoszhi style painted ceramic types count by Site for the 1200-1100 interval
Dogoszhi_1200 <- dat %>%
  filter(Dogoszhi == 1) %>%
  group_by(Site) %>%
  summarize(Dogoszhi_1200 = sum(P1200,P1225))

### Summarize Black Mesa style painted ceramic types count by Site for the 1200-1100 interval
BlackMesa_1200 <- dat %>%
  filter(Black.Mesa == 1) %>%
  group_by(Site) %>%
  summarize(BlackMesa_1200 = sum(P1200,P1225))

### Summarize Mancos Black-on-white count by Site for the 1200-1100 interval
Mancos_1200 <- dat %>%
  filter(Type == 'Mancos Black-on-white') %>%
  group_by(Site) %>%
  summarize(Mancos_1200 = sum(P1200,P1225))

### Join results into a single object and filter for sites with greater than or equal to 20 sherds
Ceramics_1200 <- Ceramics_1200 %>%
  left_join(Dogoszhi_1200) %>%
  replace_na(list(Dogoszhi_1200 = 0))
Ceramics_1200 <- Ceramics_1200 %>%
  left_join(BlackMesa_1200) %>%
  replace_na(list(BlackMesa_1200 = 0))
Ceramics_1200 <- Ceramics_1200 %>%
  left_join(Mancos_1200) %>%
  replace_na(list(Mancos_1200 = 0)) %>%
  filter(Painted_1200 >= 0)


### Add variables with Proportions
Ceramics_1200 <- Ceramics_1200 %>% 
  mutate(DogoProp_1200 = Dogoszhi_1200/Painted_1200) %>%
  mutate(BMProp_1200 = BlackMesa_1200/Painted_1200) %>%
  mutate(DogoRed_1200 = (Dogoszhi_1200-(Mancos_1200*0.5))/Painted_1200) # reduce Dogoszhi by proportion of Mancos Black-on-white

Ceramics_1200 <- Ceramics_1200 %>%
  left_join(site_attr, by=c('Site' = 'SWSN_Site'))

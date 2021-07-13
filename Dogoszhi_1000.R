
### Summarize total painted ceramic type count by Site for the respective interval
Painted_1000 <- dat %>%
  group_by(Site) %>%
  summarize(P_1000 = sum(P1000,P1025)) 

### Summarize Dogoszhi style painted ceramic types count by Site for the respective interval
Dogoszhi_1000 <- dat %>%
  filter(Dogoszhi == 1) %>%
  group_by(Site) %>%
  summarize(DOG_1000 = sum(P1000,P1025))

### Summarize Black Mesa style painted ceramic types count by Site for the respective interval
BlackMesa_1000 <- dat %>%
  filter(Black.Mesa == 1) %>%
  group_by(Site) %>%
  summarize(BM_1000 = sum(P1000,P1025))

### Summarize Mancos Black-on-white count by Site for the respective interval
Mancos_1000 <- dat %>%
  filter(SWSN_Type == 'Mancos Black-on-white') %>%
  group_by(Site) %>%
  summarize(M_1000 = sum(P1000,P1025))

### Join results into a single object and filter for sites with greater than or equal to 20 sherds
Ceramics_1000 <- Painted_1000 %>%
  left_join(Dogoszhi_1000) %>%
  replace_na(list(DOG_1000 = 0))
Ceramics_1000 <- Ceramics_1000 %>%
  left_join(BlackMesa_1000) %>%
  replace_na(list(BM_1000 = 0))
Ceramics_1000 <- Ceramics_1000 %>%
  left_join(Mancos_1000) %>%
  replace_na(list(M_1000 = 0))

### Add variables with Proportions
Ceramics_1000 <- Ceramics_1000 %>% 
  mutate(DOG_P_1000 = DOG_1000/P_1000) %>%
  mutate(BM_P_1000 = BM_1000/P_1000) %>%
  mutate(DOG_R_1000 = (DOG_1000-(M_1000*(1-mancos)))/P_1000) # reduce Dogoszhi by proportion of Mancos Black-on-white


### Add Eigenvector Centraility
Ceramics_1000 <- Ceramics_1000 %>%
  left_join(AD1000cent)
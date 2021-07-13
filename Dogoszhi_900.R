
### Summarize total painted ceramic type count by Site for the respective interval
Painted_900 <- dat %>%
  group_by(Site) %>%
  summarize(P_900 = sum(P900,P925)) 

### Summarize Dogoszhi style painted ceramic types count by Site for the respective interval
Dogoszhi_900 <- dat %>%
  filter(Dogoszhi == 1) %>%
  group_by(Site) %>%
  summarize(DOG_900 = sum(P900,P925))

### Summarize Black Mesa style painted ceramic types count by Site for the respective interval
BlackMesa_900 <- dat %>%
  filter(Black.Mesa == 1) %>%
  group_by(Site) %>%
  summarize(BM_900 = sum(P900,P925))

### Summarize Mancos Black-on-white count by Site for the respective interval
Mancos_900 <- dat %>%
  filter(SWSN_Type == 'Mancos Black-on-white') %>%
  group_by(Site) %>%
  summarize(M_900 = sum(P900,P925))

### Join results into a single object and filter for sites with greater than or equal to 20 sherds
Ceramics_900 <- Painted_900 %>%
  left_join(Dogoszhi_900) %>%
  replace_na(list(DOG_900 = 0))
Ceramics_900 <- Ceramics_900 %>%
  left_join(BlackMesa_900) %>%
  replace_na(list(BM_900 = 0))
Ceramics_900 <- Ceramics_900 %>%
  left_join(Mancos_900) %>%
  replace_na(list(M_900 = 0))

### Add variables with Proportions
Ceramics_900 <- Ceramics_900 %>% 
  mutate(DOG_P_900 = DOG_900/P_900) %>%
  mutate(BM_P_900 = BM_900/P_900) %>%
  mutate(DOG_R_900 = (DOG_900-(M_900*(1-mancos)))/P_900) # reduce Dogoszhi by proportion of Mancos Black-on-white


### Add Eigenvector Centraility
Ceramics_900 <- Ceramics_900 %>%
  left_join(AD900cent)


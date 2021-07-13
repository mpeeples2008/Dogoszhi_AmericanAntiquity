
### Summarize total painted ceramic type count by Site for the respective interval
Painted_1100 <- dat %>%
  group_by(Site) %>%
  summarize(P_1100 = sum(P1100,P1125)) 

### Summarize Dogoszhi style painted ceramic types count by Site for the respective interval
Dogoszhi_1100 <- dat %>%
  filter(Dogoszhi == 1) %>%
  group_by(Site) %>%
  summarize(DOG_1100 = sum(P1100,P1125))

### Summarize Black Mesa style painted ceramic types count by Site for the respective interval
BlackMesa_1100 <- dat %>%
  filter(Black.Mesa == 1) %>%
  group_by(Site) %>%
  summarize(BM_1100 = sum(P1100,P1125))

### Summarize Mancos Black-on-white count by Site for the respective interval
Mancos_1100 <- dat %>%
  filter(SWSN_Type == 'Mancos Black-on-white') %>%
  group_by(Site) %>%
  summarize(M_1100 = sum(P1100,P1125))

### Join results into a single object and filter for sites with greater than or equal to 20 sherds
Ceramics_1100 <- Painted_1100 %>%
  left_join(Dogoszhi_1100) %>%
  replace_na(list(DOG_1100 = 0))
Ceramics_1100 <- Ceramics_1100 %>%
  left_join(BlackMesa_1100) %>%
  replace_na(list(BM_1100 = 0))
Ceramics_1100 <- Ceramics_1100 %>%
  left_join(Mancos_1100) %>%
  replace_na(list(M_1100 = 0))

### Add variables with Proportions
Ceramics_1100 <- Ceramics_1100 %>% 
  mutate(DOG_P_1100 = DOG_1100/P_1100) %>%
  mutate(BM_P_1100 = BM_1100/P_1100) %>%
  mutate(DOG_R_1100 = (DOG_1100-(M_1100*(1-mancos)))/P_1100) # reduce Dogoszhi by proportion of Mancos Black-on-white


### Add Eigenvector Centraility
Ceramics_1100 <- Ceramics_1100 %>%
  left_join(AD1100cent)
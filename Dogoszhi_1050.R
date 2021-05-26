
### Summarize total painted ceramic type count by Site for the respective interval
Painted_1050 <- dat %>%
  group_by(Site) %>%
  summarize(P_1050 = sum(P1050,P1075)) 

### Summarize Dogoszhi style painted ceramic types count by Site for the respective interval
Dogoszhi_1050 <- dat %>%
  filter(Dogoszhi == 1) %>%
  group_by(Site) %>%
  summarize(DOG_1050 = sum(P1050,P1075))

### Summarize Black Mesa style painted ceramic types count by Site for the respective interval
BlackMesa_1050 <- dat %>%
  filter(Black.Mesa == 1) %>%
  group_by(Site) %>%
  summarize(BM_1050 = sum(P1050,P1075))

### Summarize Mancos Black-on-white count by Site for the respective interval
Mancos_1050 <- dat %>%
  filter(SWSN_Type == 'Mancos Black-on-white') %>%
  group_by(Site) %>%
  summarize(M_1050 = sum(P1050,P1075))

### Join results into a single object and filter for sites with greater than or equal to 20 sherds
Ceramics_1050 <- Painted_1050 %>%
  left_join(Dogoszhi_1050) %>%
  replace_na(list(DOG_1050 = 0))
Ceramics_1050 <- Ceramics_1050 %>%
  left_join(BlackMesa_1050) %>%
  replace_na(list(BM_1050 = 0))
Ceramics_1050 <- Ceramics_1050 %>%
  left_join(Mancos_1050) %>%
  replace_na(list(M_1050 = 0))

### Add variables with Proportions
Ceramics_1050 <- Ceramics_1050 %>% 
  mutate(DOG_P_1050 = DOG_1050/P_1050) %>%
  mutate(BM_P_1050 = BM_1050/P_1050) %>%
  mutate(DOG_R_1050 = (DOG_1050-(M_1050*(1-mancos)))/P_1050) # reduce Dogoszhi by proportion of Mancos Black-on-white


### Add Eigenvector Centraility
Ceramics_1050 <- Ceramics_1050 %>%
  left_join(AD1050cent)
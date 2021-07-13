
### Summarize total painted ceramic type count by Site for the respective interval
Painted_950 <- dat %>%
  group_by(Site) %>%
  summarize(P_950 = sum(P950,P975)) 

### Summarize Dogoszhi style painted ceramic types count by Site for the respective interval
Dogoszhi_950 <- dat %>%
  filter(Dogoszhi == 1) %>%
  group_by(Site) %>%
  summarize(DOG_950 = sum(P950,P975))

### Summarize Black Mesa style painted ceramic types count by Site for the respective interval
BlackMesa_950 <- dat %>%
  filter(Black.Mesa == 1) %>%
  group_by(Site) %>%
  summarize(BM_950 = sum(P950,P975))

### Summarize Mancos Black-on-white count by Site for the respective interval
Mancos_950 <- dat %>%
  filter(SWSN_Type == 'Mancos Black-on-white') %>%
  group_by(Site) %>%
  summarize(M_950 = sum(P950,P975))

### Join results into a single object and filter for sites with greater than or equal to 20 sherds
Ceramics_950 <- Painted_950 %>%
  left_join(Dogoszhi_950) %>%
  replace_na(list(DOG_950 = 0))
Ceramics_950 <- Ceramics_950 %>%
  left_join(BlackMesa_950) %>%
  replace_na(list(BM_950 = 0))
Ceramics_950 <- Ceramics_950 %>%
  left_join(Mancos_950) %>%
  replace_na(list(M_950 = 0))

### Add variables with Proportions
Ceramics_950 <- Ceramics_950 %>% 
  mutate(DOG_P_950 = DOG_950/P_950) %>%
  mutate(BM_P_950 = BM_950/P_950) %>%
  mutate(DOG_R_950 = (DOG_950-(M_950*(1-mancos)))/P_950) # reduce Dogoszhi by proportion of Mancos Black-on-white


### Add Eigenvector Centraility
Ceramics_950 <- Ceramics_950 %>%
  left_join(AD950cent)
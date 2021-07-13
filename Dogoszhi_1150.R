
### Summarize total painted ceramic type count by Site for the respective interval
Painted_1150 <- dat %>%
  group_by(Site) %>%
  summarize(P_1150 = sum(P1150,P1175)) 

### Summarize Dogoszhi style painted ceramic types count by Site for the respective interval
Dogoszhi_1150 <- dat %>%
  filter(Dogoszhi == 1) %>%
  group_by(Site) %>%
  summarize(DOG_1150 = sum(P1150,P1175))

### Summarize Black Mesa style painted ceramic types count by Site for the respective interval
BlackMesa_1150 <- dat %>%
  filter(Black.Mesa == 1) %>%
  group_by(Site) %>%
  summarize(BM_1150 = sum(P1150,P1175))

### Summarize Mancos Black-on-white count by Site for the respective interval
Mancos_1150 <- dat %>%
  filter(SWSN_Type == 'Mancos Black-on-white') %>%
  group_by(Site) %>%
  summarize(M_1150 = sum(P1150,P1175))

### Join results into a single object and filter for sites with greater than or equal to 20 sherds
Ceramics_1150 <- Painted_1150 %>%
  left_join(Dogoszhi_1150) %>%
  replace_na(list(DOG_1150 = 0))
Ceramics_1150 <- Ceramics_1150 %>%
  left_join(BlackMesa_1150) %>%
  replace_na(list(BM_1150 = 0))
Ceramics_1150 <- Ceramics_1150 %>%
  left_join(Mancos_1150) %>%
  replace_na(list(M_1150 = 0))

### Add variables with Proportions
Ceramics_1150 <- Ceramics_1150 %>% 
  mutate(DOG_P_1150 = DOG_1150/P_1150) %>%
  mutate(BM_P_1150 = BM_1150/P_1150) %>%
  mutate(DOG_R_1150 = (DOG_1150-(M_1150*(1-mancos)))/P_1150) # reduce Dogoszhi by proportion of Mancos Black-on-white


### Add Eigenvector Centraility
Ceramics_1150 <- Ceramics_1150 %>%
  left_join(AD1150cent)
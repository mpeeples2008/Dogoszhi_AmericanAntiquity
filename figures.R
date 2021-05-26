

source('Dogoszhi_900.R')
source('Dogoszhi_950.R')
source('Dogoszhi_1000.R')
source('Dogoszhi_1050.R')
source('Dogoszhi_1100.R')
source('Dogoszhi_1150.R')
source('Dogoszhi_1200.R')

full <- merge(merge(merge(merge(merge(Ceramics_900, Ceramics_950), merge(Ceramics_1000,Ceramics_1050)),Ceramics_1100),Ceramics_1150),Ceramics_1200)






Ceramics_1050 %>% 
  filter(CSN_macro_group %in% c('Central San Juan Basin','Chaco Canyon','Chuska Slope','Lobo Mesa/Red Mesa Valley','Defiance Plateau',
                                'Cibola','Middle San Juan','Rio Puerco of the West','San Juan Foothills','Silver Creek','Southeast Utah')) %>%
  ggplot(aes(x=fct_reorder(CSN_macro_group,DogoProp_1050), y=DogoProp_1050, fill=CSN_macro_group)) +
  geom_boxplot()



gapminder %>% 
  ggplot(aes(x= fct_reorder(continent,lifeExp), y=lifeExp, fill=continent)) +
  geom_boxplot() +
  geom_jitter(width=0.1,alpha=0.2)  +
  xlab("Continent")


ggplot(Ceramics_1050, aes(x=reorder(Ceramics_1050$CSN_macro_group, Ceramics_1050$DogoProp_1050, FUN=median), y = Ceramics_1050$DogoProp_1050)) + geom_boxplot()



Ceramics_1050$CSN_macro_group <- factor(Ceramics_1050$CSN_macro_group , levels = Ceramics_1050$CSN_macro_group[])


Ceramics_1050 %>% 
  filter(Size_Class >0) %>%
  ggplot(aes(y=DogoRed_1050,x=as.factor(Size_Class))) +
  geom_boxplot()



Ceramics_1050 %>% 
  ggplot(aes(y=DogoProp_1050,x=as.factor(GK_Count+GH_Count+Dshp_Count+Biwall_Count+Triwall_Count))) +
  geom_boxplot()





Ceramics_950 %>% 
  filter(CSN_macro_group %in% c('Central San Juan Basin','Chaco Canyon','Chuska Slope','Lobo Mesa/Red Mesa Valley','Defiance Plateau',
                                'Cibola','Middle San Juan','Rio Puerco of the West','San Juan Foothills','Silver Creek','Southeast Utah')) %>%
  ggplot(aes(y=BMProp_950,x=CSN_macro_group)) +
  geom_boxplot()


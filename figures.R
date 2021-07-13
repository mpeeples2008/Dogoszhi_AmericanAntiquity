#### Create figures

### Figure 5

figure_5 <- full %>% 
  filter(Size_Class >0) %>%
  filter(P_1050 > 25) %>%
  ggplot(aes(y=DOG_R_1050,x=as.factor(Size_Class))) +
  geom_boxplot() +
  ylim(0,1) +
  geom_point(color="black", size=2, alpha=0.9) +
  labs(x="Size Class",y="Proportion of Dogoszhi Style") +
  theme_bw()

#### Figure 6

p1 <- full %>%
  filter(P_900 > 20) %>%
  ggplot(aes(x=Mean_Rooms, BM_P_900)) +
  geom_point() +
  theme_bw() +
  theme(text=element_text(family="Arial Unicode MS")) +
  labs(title=paste('A.D. 900-950, \u03c1 =',round(cor(full$Mean_Rooms,full$BM_P_900,method='spearman',use = "na.or.complete"),2)), x="Site Size", y="Black Mesa Style")
p2 <- full %>%
  filter(P_950 > 20) %>%
  ggplot(aes(x=Mean_Rooms,BM_P_950)) +
  geom_point() +
  theme_bw() +
  theme(text=element_text(family="Arial Unicode MS")) +
  labs(title=paste('A.D. 950-1000, \u03c1 =',round(cor(full$Mean_Rooms,full$BM_P_950,method='spearman',use = "na.or.complete"),2)), x="Site Size", y="Black Mesa Style")
p3 <- full %>%
  filter(P_1050 > 20) %>%
  ggplot(aes(x=Mean_Rooms,DOG_P_1050)) +
  geom_point() +
  theme_bw() +
  theme(text=element_text(family="Arial Unicode MS")) +
  labs(title=paste('A.D. 1050-1100, \u03c1 =',round(cor(full$Mean_Rooms,full$DOG_P_1050,method='spearman',use = "na.or.complete"),2)), x="Site Size", y="Dogoszhi Style")
p4 <- full %>%
  filter(P_1100 > 20) %>%
  ggplot(aes(x=Mean_Rooms,DOG_P_1100)) +
  geom_point() +
  theme_bw() +
  theme(text=element_text(family="Arial Unicode MS")) +
  labs(title=paste('A.D. 1100-1150, \u03c1 =',round(cor(full$Mean_Rooms,full$DOG_P_1100,method='spearman',use = "na.or.complete"),2)), x="Site Size", y="Dogoszhi Style")

figure_6 <- ggarrange(p1,p2,p3,p4, ncol = 2, nrow = 2)

#### Figure 7

p1 <- full %>%
  filter(P_900 > 20) %>%
  ggplot(aes(x=EV_900,BM_P_900)) +
  geom_point() +
  theme_bw() +
  labs(title=paste('A.D. 900-950, \u03c1 =',round(cor(full$EV_900,full$BM_P_900,method='spearman',use = "na.or.complete"),2)), x="Eigenvector Centrality", y="Black Mesa Style")
p2 <- full %>%
  filter(P_950 > 20) %>%
  ggplot(aes(x=EV_950,BM_P_950)) +
  geom_point() +
  theme_bw() +
  labs(title=paste('A.D. 950-1000, \u03c1 =',round(cor(full$EV_950,full$BM_P_950,method='spearman',use = "na.or.complete"),2)), x="Eigenvector Centrality", y="Black Mesa Style")
p3 <- full %>%
  filter(P_1050 > 20) %>%
  ggplot(aes(x=EV_1050,DOG_P_1050)) +
  geom_point() +
  theme_bw() +
  labs(title=paste('A.D. 1050-1100, \u03c1 =',round(cor(full$EV_1050,full$DOG_P_1050,method='spearman',use = "na.or.complete"),2)), x="Eigenvector Centrality", y="Dogoszhi Style")
p4 <- full %>%
  filter(P_1100 > 20) %>%
  ggplot(aes(x=EV_1100,DOG_P_1100)) +
  geom_point() +
  theme_bw() +
  labs(title=paste('A.D. 1100-1150, \u03c1 =',round(cor(full$EV_1100,full$DOG_P_1100,method='spearman',use = "na.or.complete"),2)), x="Eigenvector Centrality", y="Dogoszhi Style")

figure_7 <- ggarrange(p1,p2,p3,p4, ncol = 2, nrow = 2)


#### Figure 8

figure_8 <- full %>% 
  filter(CSN_macro_group %in% c('Central San Juan Basin','Chaco Canyon','Chuska Slope','Lobo Mesa',
                                'Middle San Juan','Rio Puerco of the West','San Juan Foothills','Southeast Utah')) %>%
  ggplot(aes(x=CSN_macro_group, y=BM_P_950)) +
  geom_boxplot() +
  labs(title="Proportion of Black Mesa Style: AD 950-1000", x ="", y = "Proportion") +
  theme_bw()


#### Figure 9

figure_9 <- full %>% 
  filter(CSN_macro_group %in% c('Acoma','Central San Juan Basin','Chaco Canyon','Chuska Slope','Lobo Mesa','Defiance Plateau',
                                'Cibola','Middle San Juan','Rio Puerco of the West','San Juan Foothills','Silver Creek','Southeast Utah')) %>%
  ggplot(aes(x=CSN_macro_group, y=DOG_R_1050)) +
  geom_boxplot() +
  labs(title="Proportion of Dogoszhi Style: AD 1050-1100", x ="", y = "Proportion") +
  theme_bw()


### Figure 10

figure_10 <- full %>%
  ggplot(aes(x=EASTING,y=NORTHING,size=DOG_R_1050))+
  stat_density2d(aes(fill = stat(level)), geom="polygon", alpha=0.5)+
  geom_point() +
  xlim(min(full$EASTING),max(full$EASTING)) +
  ylim(min(full$NORTHING),max(full$NORTHING)) +
  theme_bw() +
  labs(x='',y='',title='Dogoszhi Style: A.D. 1050-1100')

### Figure 11

figure_11 <- full %>%
  ggplot(aes(x=EASTING,y=NORTHING,size=BM_P_950))+
  stat_density2d(aes(fill = stat(level)), geom="polygon", alpha=0.5)+
  geom_point() +
  xlim(min(full$EASTING),max(full$EASTING)) +
  ylim(min(full$NORTHING),max(full$NORTHING)) +
  theme_bw() +
  labs(x='',y='',title='Black Mesa Style: A.D. 950-1000')

ggsave(filename="Figure_5.pdf", plot = figure_5, width = 200, height = 200, units = c("mm"), dpi = 600)
ggsave(filename="Figure_6.png", plot = figure_6, width = 200, height = 200, units = c("mm"), dpi = 600)
ggsave(filename="Figure_7.png", plot = figure_7, width = 200, height = 200, units = c("mm"), dpi = 600)
ggsave(filename="Figure_8.pdf", plot = figure_8, width = 400, height = 200, units = c("mm"), dpi = 600)
ggsave(filename="Figure_9.pdf", plot = figure_9, width = 400, height = 200, units = c("mm"), dpi = 600)
ggsave(filename="Figure_10.pdf", plot = figure_10, width = 400, height = 400, units = c("mm"), dpi = 600)
ggsave(filename="Figure_11.pdf", plot = figure_11, width = 400, height = 400, units = c("mm"), dpi = 600)
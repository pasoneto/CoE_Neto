source('/Users/pdealcan/Documents/github/doc_suomi/code/utils.R')
setwd('/Users/pdealcan/Documents/github/CoE/code/analysis/')

accels = c()
for(i in 1:3){
  mocap = fread(paste("../../data/mocapVSphone/MocapAccel", i, ".csv", sep = ""))
  phone = fread(paste("../../data/mocapVSphone/PhoneAccel", i, ".csv", sep = ""))

  colnames(mocap) = c("accel")
  colnames(phone) = c("accel")

  mocap$dance = paste("dance", i, sep = "")
  phone$dance = paste("dance", i, sep = "")

  mocap$frame = 1:length(mocap$dance)
  phone$frame = 1:length(phone$dance)

  mocap$source = "mocap" 
  phone$source = "phone" 

  dt = bind_rows(mocap, phone)
  accels = bind_rows(dt, accels)
}

periods = c()
for(i in 1:3){
  mocap = fread(paste("../../data/mocapVSphone/MocapPeriods", i, ".csv", sep = ""))
  phone = fread(paste("../../data/mocapVSphone/PhonePeriods", i, ".csv", sep = ""))

  colnames(mocap) = c("periods")
  colnames(phone) = c("periods")

  mocap$dance = paste("dance", i, sep = "")
  phone$dance = paste("dance", i, sep = "")

  mocap$window = 1:length(mocap$dance)
  phone$window = 1:length(phone$dance)

  mocap$source = "mocap" 
  phone$source = "phone" 

  dt = bind_rows(mocap, phone)
  periods = bind_rows(dt, periods)
}

accels %>%
  filter(frame > 200) %>%
  filter(frame < 500) %>%
  ggplot(aes(x = frame, y = accel, color = source)) +
    facet_wrap(~dance)+
    geom_path()

ggsave("../reports/MocapAccell/accels.png")

periods %>% 
  filter(window > 0) %>%
  filter(window < 25) %>%
  ggplot(aes(x = window, y = periods, color = source)) +
    facet_wrap(~dance)+
    geom_path()

ggsave("../reports/MocapAccell/periods.png")

periods %>% 
  ggplot(aes(x = periods, color = source)) +
    facet_wrap(~dance)+
    geom_density()

ggsave("./periodDistribution.png")

#Correlations

#Acceleration correlations
pd1 = accels %>% filter(source == 'phone') %>% filter(dance == "dance1")
pd2 = accels %>% filter(source == 'phone') %>% filter(dance == "dance2")
pd3 = accels %>% filter(source == 'phone') %>% filter(dance == "dance3")
  
md1 = accels %>% filter(source == 'mocap') %>% filter(dance == "dance1")
md2 = accels %>% filter(source == 'mocap') %>% filter(dance == "dance2")
md3 = accels %>% filter(source == 'mocap') %>% filter(dance == "dance3")

cor.test(pd1$accel[1:3532], md1$accel)
cor.test(pd2$accel[1:3579], md2$accel)
cor.test(pd3$accel, md3$accel[1:3488])

#Periods correlation
pd1 = periods %>% filter(source == 'phone') %>% filter(dance == "dance1")
pd2 = periods %>% filter(source == 'phone') %>% filter(dance == "dance2")
pd3 = periods %>% filter(source == 'phone') %>% filter(dance == "dance3")
  
md1 = periods %>% filter(source == 'mocap') %>% filter(dance == "dance1")
md2 = periods %>% filter(source == 'mocap') %>% filter(dance == "dance2")
md3 = periods %>% filter(source == 'mocap') %>% filter(dance == "dance3")

cor.test(pd1$periods, md1$periods[1:55])
cor.test(pd2$periods, md2$periods[1:56])
cor.test(pd3$periods[1:55], md3$periods)


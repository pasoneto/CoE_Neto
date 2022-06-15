source("/Users/pdealcan/Docments/github/doc_suomi/code/utils.R")
library(dplyr)
library(ggplot2)
require(jsonlite)

filepath<-"./trial_data_2.json"
content<-readLines(filepath)
res<-lapply(content,fromJSON)

dt = data.frame(res)

#Time elapsed and sr
time_elapsed = max(dt$thist) - min(dt$thist) #time elapsed from global time-system

#Difference between time elapsed from audio-time and global-time-system
time_elapsed - ((max(dt$audiohist) - min(dt$audiohist))*1000)

sampling_frequency = 60
expected_sr = 1000/sampling_frequency
actual_sr = (1000*length(dt$thist))/time_elapsed #16.42 samples per second

#Difference between expected and actual sampling rate
expected_sr - actual_sr

#Deviation of timing between samples
difs = c()
for(i in 1:(length(dt$thist)-1)){
  difs = c(difs, dt$thist[i+1] - dt$thist[i])
}

#Checking consistency of inter-sampling timing
sum(difs) == time_elapsed
mean(difs) #mean time (ms) between samples. Expected was 60.
sd(difs) #sd of sampling_frequency
max(difs)
min(difs)

dt %>%
  melt(id.vars = c("thist", "audiohist")) %>%
  ggplot(aes(x = audiohist, y = value))+
    facet_wrap(~variable)+
    geom_path()+
    ylab("Accelerometer")+
    xlab("Audio timing (s)")

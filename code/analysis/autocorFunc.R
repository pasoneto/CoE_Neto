library("dplyr")
library("ggridges")
library("stringr")
library("evobiR")
library("runner")
library("soundgen")
library("pracma")
library("TSA")
library("zoo")
library("spectral")
library("perARMA")
library("ggplot2")
source("/Users/pdealcan/Documents/github/doc_suomi/code/utils.R")
path_dance = "/Users/pdealcan/Documents/github/doc_suomi/text/CoE/project/data/collection"

#Autocor and half-wave rectification
half_waving = function(x, max_lag = 3){
  autocor = acf(x, lag.max = sr*max_lag, plot = FALSE)$acf
  autocor = pmax(autocor, 0)
  return(autocor)   
}
#Time scaling and subtraction
scaling = function(x, factor = 2){
  time = 1:length(x)
  time_scale = time*factor
  scaled = x[time_scale]
  scaled[is.na(scaled)] <- 0
  x = x-scaled
  return(x) 
}
enhancedAutocor = function(signal, max_lag){
  autocor = half_waving(signal, 2)
  autocor = scaling(autocor)
  return(autocor)
}
beat_to_sample = function(beat, sr){
  r = (60*sr)/beat
  return(r) #Returns samples that 1 beat takes
}
period = function(autocor_result, sr, plot = FALSE){
    peaks = findpeaks(as.numeric(autocor_result), minpeakheight = 0.2)
    bpmLow = beat_to_sample(10, sr)
    bpmHigh = beat_to_sample(300, sr) 
    periods = peaks[,2] #Periods in units of sampling
    if(plot == TRUE){
      plot(1:length(autocor_result), autocor_result, xlim = c(1, length(autocor_result)), ylim = c(-1, 2), col = "blue", type = "ls")
      par(new = TRUE)
      plot(peaks[,2], peaks[,1], xlim = c(1, length(autocor_result)), ylim = c(-1, 2), col = "red")
    }
    viable_periods = which(periods < bpmLow & periods > bpmHigh)
    return(periods[viable_periods])
}
period_filter = function(periods, filter_bpm){ 
  increment = filter_bpm*0.1
  isBetween = function(x){ (x < filter_bpm+increment) && (x > filter_bpm-increment) } 
  bol_array = lapply(periods, isBetween)
  return(unlist(bol_array))
}
#Function returns periods found within signal
doit = function(signal, sr){
  autocor = enhancedAutocor(signal)
  periods = period(autocor, sr)
  periods = periods/sr
  return(periods)
}
#windowing function
wraper = function(signal, sr = 203, window = 3, step = 0.5){
  window = sr*window
  step = round(window*step)
  steps = seq(1, length(signal$z)-window, step)
  periods= c()
  for(i in steps){
    w = 1:(i+window-2)
    pb = doit(signal$z[w], sr)
    periods = c(periods, pb)
  }
  data = data.frame(periods = c(periods),
                    file = c(rep(unique(signal$file), length(periods)) )
  )
  return(data)
}
#function to change names
a = function(x){
  if(x == TRUE){
    return("binary")
  }else{ 
    return("ternary")
  }
}

########Read data begins
files = list.files(path_dance); sr = 203
data = c()
for(i in files){
  f = fread(paste(path_dance, i, sep = "/")) 
  f = f$gFx
  b = 1*sr
  e = 11*sr 
  f = f[b:e]
  f = data.frame(z = f)
  f$file = i
  data = c(data, list(f))
}

#Applying
processed = bind_rows(lapply(data, wraper)) #analysing periods
processed$condition = str_detect(processed$file, "binary") #changing variable names
processed$condition = unlist(lapply(processed$condition, a)) #changing variable names

processed %>%
  ggplot(aes(x = periods, y = condition, fill = condition)) +
  facet_wrap(~file, scale = "free")+
  geom_density_ridges(fill = "lightblue", alpha = 0.5)

processed %>%
  ggplot(aes(x=periods, y=periods) ) +
    stat_density_2d(aes(fill = ..density..), geom = "raster", contour = "white") +
    scale_x_continuous(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0)) +
    theme(
      legend.position='none'
    )

#Calculating probabilities 
#probability calculation = 
# for each bin, extract all periodicities within 30 and 300 bpm,
# for each participant, percentage of bins within 5% of period hypothesized period
processed %>%
  group_by(file) %>%
  mutate(binary_prob = period_filter(periods, 1),
         ternary_prob = period_filter(periods, 1.5)) %>%
  summarise(condition = unique(condition),
            binary_prob = sum(binary_prob)/length(binary_prob),
            ternary_prob = sum(ternary_prob)/length(ternary_prob)) %>%
  melt() %>%
  ggplot(aes(x = value, y = variable, fill = variable)) +
    facet_wrap(~condition, scale = "free")+
    geom_density_ridges(stat = "binline")

o = data[[3]]$z

time = 1:length(o)
time_scale = time*2
s = o[time_scale]
s[is.na(s)] <- 0

plot(time, o, xlim = c(500, length(o)), ylim = c(0, 0.3), col = "blue", type = "ls")
par(new = TRUE)
plot(time, s, xlim = c(500, length(o)), ylim = c(0, 0.3), col = "green", type = "ls")


plot(time, o-s, xlim = c(500, length(o)), ylim = c(0, 0.3), col = "blue", type = "ls")

x = x-scaled

autocor = enhancedAutocor(data[[3]]$z)
periods = period(autocor, 203, plot = TRUE)




#In the ternary metric, it we would not expect to see 








#11 windows of 4 s each, with a 2-s overlap
#with each window being separately subjected
#to periodicity estimation using auto-correlation (Eerola et al., 2006).

#y half-wave rectifying the autocorrelation function,
#time-scaling it by a factor of two, and subtracting the thus
#obtained function from the original half-wave rectified function.

#Period locking per window by comparing the period estimate of the movement to four different metrical levels—half the beat period, beat period, two times the beat period, and four times the beat period—within a 5% tolerance.

#period-locking probability per metrical level was assessed by calculating the average of the period-locking occurrences per window and metrical level.


#Analysis
#acceleration in three dimensions of six joints using numerical differentiation 
#Butterworth smoothing filter (second-order zero-phase digital filter)



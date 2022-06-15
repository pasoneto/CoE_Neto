source('/Users/pdealcan/Documents/github/doc_suomi/code/utils.R')
library(dplyr)

dt = fread('../../data/dataAccel.txt')
colnames(dt) = c('x', 'y', 'z', 't')

dt %>%
  melt(id.vars = "t") %>%
  filter(t > 5000) %>%
  filter(t < 10000) %>%
  ggplot(aes(x = t, y = value, color = variable))+
    facet_wrap(~variable, scale = "free")+
    geom_path()

ggsave('../../data/accel.png')


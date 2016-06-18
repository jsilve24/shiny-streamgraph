library(streamgraph)
library(shiny)
library(babynames)
library(dplyr)
library(tidyr)

setwd('~/Research/streamgraph/')

data.wide <- babynames %>%
  filter(grepl("^Kr", name)) %>%
  group_by(year, name) %>%
  tally(wt=n) %>% 
  spread(name, n)
data.wide[is.na(data.wide)] <- 0 
write.csv(data.wide, file='babynames.kr.wide.csv', row.names = F)


data.long <- babynames %>% 
  filter(grepl("^Kr", name)) %>%
  group_by(year, name) %>%
  tally(wt=n)
write.csv(data.long, file='babynames.kr.long.csv', row.names=F)
    
sg <- babynames %>%
  filter(grepl("^Kr", name)) %>%
  group_by(year, name) %>%
  tally(wt=n) %>% 
  streamgraph('name', 'n', 'year')


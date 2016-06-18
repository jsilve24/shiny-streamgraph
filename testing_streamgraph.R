library(streamgraph)
library(shiny)
library(babynames)
library(dplyr)
library(tidyr)

data.wide <- babynames %>%
  filter(grepl("^Kr", name)) %>%
  group_by(year, name) %>%
  tally(wt=n) %>% 
  spread(name, n)
data.wide[is.na(data.wide)] <- 0 



data.long <- babynames %>% 
  filter(grepl("^Kr", name)) %>%
  group_by(year, name) %>%
  tally(wt=n)

sg <- babynames %>%
  filter(grepl("^Kr", name)) %>%
  group_by(year, name) %>%
  tally(wt=n) %>% 
  streamgraph('name', 'n', 'year')


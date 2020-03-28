library(ggmap)
library(ggplot2)
library(ggrepel)
library(haven)
library(leaflet)
library(lubridate)
library(mapedit)
library(maptools)
library(RColorBrewer)
library(rgdal)
library(sf)
library(tidycensus)
library(tidyverse)
library(tigris)
library(zoo)

setwd('/Users/ben.bubnick/projects/covid-19-data')

counties <- read_csv('us-counties.csv')

counties %>% filter(state=='Ohio') %>%
  pivot_wider(names_from = c('date'),
              values_from = c('cases','deaths')) %>%
  View()

ohio_counties <- counties %>%
  filter(state=='Ohio')

cases_gt50 <- ohio_counties %>% filter(county %in%
                                         c(ohio_counties %>%
                                             group_by(county) %>%
                                             summarize(n_sum = sum(cases)) %>%
                                             filter(n_sum >50) %>%
                                             .$county))

get_xgt50 <- function(x){
  y <- x%>% filter(county %in%
                     c(x %>%
                         group_by(county) %>%
                         summarize(n_sum = sum(cases)) %>%
                         filter(n_sum >50) %>%
                         .$county))
  return(y)
}

growth <- function(x)x/(lag(x)-1)

calculate_growth_rate <- function(x){
  y <- cases_gt50 %>%
    mutate(date = date) %>%
    mutate(cumsum = cumsum(cases)) %>%
    complete( fill = list(cases = 0)) %>%
    mutate(cum_rolling = rollapplyr(cases, width = 10, FUN = sum, partial = TRUE)) %>%
    drop_na(cumsum)
  return(y)
}

growth_rate_plot<- function(x) {
  x %>%
    group_by(county) %>%
    mutate_each(growth, cases, deaths)  %>% 
    ggplot() +
    geom_line(aes(x=date, y = cases, color = county))+
    facet_wrap(~county) +
    labs(y='cases growth rate')
}


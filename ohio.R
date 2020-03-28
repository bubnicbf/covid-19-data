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


library(leaflet)
library(geojsonio)
library(sf)
library(here)
library(tidyverse)
library(dplyr)
worlddata <- st_read(here("Homework4World_Countries_(Generalized)_9029012925078512962.geojson"))

leaflet(worlddata) %>%
  addTiles() %>%
  addPolygons()


mycsv2010 <-  read_csv(here("Homework4hdr-data 2010.csv"))
mycsv2010 <- mycsv2010 %>% rename(value_2010 = value)

mycsv2019 <-  read_csv(here("Homework4hdr-data 2019.csv"))
mycsv2019 <- mycsv2019 %>% rename(value_2019 = value)

merged_data <- left_join(mycsv2010, mycsv2019, by = "country")

merged_data <- merged_data %>%
  mutate(diff = value_2019 - value_2010)

merged_data <- merged_data %>% rename(COUNTRY = country)

Final_data <- left_join(worlddata, merged_data, by = "COUNTRY")
Final_data$diff <- round(Final_data$diff, 2)

leaflet(Final_data) %>%
  addTiles() %>%
  addPolygons(fillColor = ~colorFactor(c("red", "green"), Final_data$diff)(diff),
              color = "black", weight = 1, opacity = 1, fillOpacity = 0.7) %>%
  addLegend("bottomright", pal = colorFactor(c("red", "green"), Final_data$diff), values = Final_data$diff,
            title = "Data Legend", opacity = 1)



# Packages ----------------------------------------------------------------

library(tidyverse)
library(here)
library(janitor)
library(ggmap)
library(sf)
library(rnaturalearth)
library(lubridate)
library(conflicted)
library(countrycode)
library(extrafont)


conflict_prefer("here", "here")



# Get Data + Geocode ----------------------------------------------------------------

# orders <- read_csv(here("getting-started-orders-map", "orders.csv")) %>%
#   clean_names() %>%
#   mutate(country_name = countrycode(country_code_billing, "iso2c", "country.name")) %>% # Convert country code to name to make geocoding more accurate
#   mutate(address = str_glue("{city_billing}, {state_code_billing} {postcode_billing} {country_name}")) %>%
#   distinct(address, .keep_all = TRUE) %>%
#   mutate_geocode(address)

# Save to CSV so we don't have to geocode again

write_csv(orders,
          here("getting-started-orders-map", "orders-geocoded.csv"))


# Plot --------------------------------------------------------------------

loadfonts()

conflict_prefer("filter", "dplyr")

orders_geocoded <- read_csv(here("getting-started-orders-map", "orders-geocoded.csv")) %>% 
  drop_na(lon) %>% 
  mutate(date = mdy_hm(order_date)) %>% 
  mutate(order_month = month(date)) %>% 
  st_as_sf(coords = c("lon", "lat"), crs = 4326) 

country_shapefiles <- ne_countries(returnclass='sf') %>% 
  filter(sovereignt != "Antarctica")

ggplot(country_shapefiles) + 
  geom_sf(fill = "#6CABDD",
          color = "#eeeeee") +
  geom_sf(data = orders_geocoded,
          color = "#FFC659",
          size = 2,
          alpha = 0.85) +
  coord_sf(datum = NA) +
  theme_void() +
  theme(text = element_text(family = "Karla",
                            color = "white"),
        plot.title = element_text(size = 20,
                                  face = "bold",
                                  hjust = 0.5),
        plot.caption = element_text(size = 13,
                                    face = "italic"),
        plot.background = element_rect(fill = "#6CABDD"),
        plot.margin = margin(10, 10, 10, 10, "pt")) +
  labs(caption = "Learn more at rfortherestofus.com",
       title = "Users from around the world have signed up for Getting Started with R") 


ggsave(here("getting-started-orders-map", "orders.png"), 
       width = 10,
       height = 5)

# API access: "https://api.turfgame.com/v5/zones"

# load the tidy universe packages
library(tidyverse)

# load R package for HTTP requests
library(httr2)

# load package for
library(sf)

# load package for maps
library(leaflet)

# load package for city geocoding
library(tidygeocoder)

source("R/turf_request.R")

# zones_all <-
#   turf_zones_all()

# saveRDS(zones_all, "data/zones_all.rds")

# reading saved all zones data if present
if (file.exists("zones_all.rds")){
  zones_all <- readRDS("data/zones_all.rds")
}




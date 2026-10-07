# demo

if (file.exists("zones_all.rds")){
  zones_all <- readRDS("extra/zones_all.rds")
}


focus_address <- "Oskarshamn"

display_zones_and_active_players(address=focus_address , show_players = TRUE, show_zones = TRUE, turfarea_radius = 20)



























locations <-
  tibble(
    name = c(
      "Stockholm",
      "Göteborg",
      "Malmö",
      "Linköping",
      "Norrköping",
      "Borensberg"
    )
  )


locations_pos<-
  locations |>
  pull(name) |>
  get_geo_pos()

locations |>
  pull(name) |>
  get_geo_pos(prio_addresstype = "village")


linkoping_koord <-
  locations_pos |>
  filter(name == "Linköping") |>
  select(lat, long) |>
  unlist()

linkoping_koord

linkoping_center <-
  get_sf_point_from_koord(linkoping_koord)

linkoping_zones <-
linkoping_center|>
  zones_around( 20, zones_all)

map_positions(linkoping_zones)

players_linkoping <-
  all_active_players() |>
  active_players_in_area(linkoping_center, dist = 20000)


map_positions(linkoping_zones, players = players_linkoping)




stockholm_koord <-
  locations_pos |>
  filter(name == "Stockholm") |>
  select(lat, long) |>
  unlist()

stockholm_center <-
  get_sf_point_from_koord(stockholm_koord)

stockholm_zones <-
  stockholm_center |>
  zones_around(30, zones_all)

players_stockholm <-
  all_active_players() |>
  active_players_in_area(stockholm_center, dist = 20000)

map_positions(stockholm_zones, players = players_stockholm)

################################################################################
if (file.exists("data/zones_all.rds")){
  zones_all <- readRDS("data/zones_all.rds")
}





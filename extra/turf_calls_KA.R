

################################################################################
# ON THE MAP
################################################################################


# retrieve geodata
cities <-
  cities |>
  geocode(city, method = "osm")

# zones_sf |>
#   slice(1:100) |>
#   leaflet() |>
#   addTiles() |>
#   addCircleMarkers()
#
#
# zones_sf |>
#   slice(1:100) |>
#   leaflet() |>
#   addTiles() |>
#   addCircleMarkers(
#     radius = 4,
#     popup = ~name
#   )
#
# linkoping_box <- st_bbox(
#   c(
#     xmin = 15.4,
#     xmax = 15.9,
#     ymin = 58.3,
#     ymax = 58.5
#   ),
#   crs = st_crs(4326)
# )
#
# linkoping_box <- st_as_sfc(linkoping_box)
#
# linkoping <-
#   zones_sf[
#   st_intersects(zones_sf, linkoping_box, sparse = FALSE)[, 1],
# ]
#
#
linkoping_center <-
  st_sfc(
  st_point(c(15.62, 58.41)), # long, lat
  crs = 4326
)

stockholm_center <-
  st_sfc(
    st_point(c(18.07, 59.33)), # long, lat
    crs = 4326
  )

#
# linkoping <-
#   zones_sf[
#   st_is_within_distance(
#     zones_sf,
#     linkoping_center,
#     dist = 20000, # meters
#     sparse = FALSE
#   )[, 1],
# ]
#
#
# linkoping |>
#   leaflet() |>
#   addTiles() |>
#   addCircleMarkers(
#     radius = 3,
#     popup = ~name
#   )
#
#
# linkoping_buffer <-
#   st_buffer(
#   linkoping_center,
#   dist = 20000
# )
#
# leaflet() |>
#   addTiles() |>
#   addPolygons(
#     data = linkoping_buffer,
#     fill = FALSE
#   ) |>
#   addCircleMarkers(
#     data = linkoping,
#     radius = 3,
#     popup = ~name
#   )


zones_around <- function(zones, lon, lat, km) {

  center <- st_sfc(
    st_point(c(lon, lat)),
    crs = 4326
  )

  zones[
    st_is_within_distance(
      zones,
      center,
      dist = km * 1000,
      sparse = FALSE
    )[, 1],
  ]
}




on_the_map <- function(data){
  leaflet() |>
    addTiles() |>
    addPolygons(
      data = linkoping_buffer,
      color = "blue",
      weight = 2,
      fillColor = "lightblue",
      fillOpacity = 0.2
    ) |>
    addCircleMarkers(
      data = linkoping,
      radius = 3,
      color = "red",
      fillColor = "red",
      fillOpacity = 0.8,
      popup = ~name
    )
}


leaflet() |>
  addTiles() |>
  addPolygons(
    data = linkoping_buffer,
    color = "blue",
    weight = 2,
    fillColor = "lightblue",
    fillOpacity = 0.2
  ) |>
addCircleMarkers(
  data = linkoping,
  radius = 4,
  stroke = FALSE,
  fillColor = "red",
  fillOpacity = 0.8,
  popup = ~name
)

# color = "#2C7FB8"
# fillColor = "#7FCDBB"

################################################################################
# MAPPING DATA
################################################################################

pal_continuous <-
  colorNumeric(
  palette = "inferno",
  domain = linkoping$pointsPerHour
)

# continuous colors
linkoping |>
  leaflet() |>
  addTiles() |>
  addCircleMarkers(
    radius = 5,
    stroke = FALSE,
    fillColor = ~pal(pointsPerHour),
    fillOpacity = 0.8,
    popup = ~paste(
      name,
      "<br>PPH:", pointsPerHour
    )
  ) |>
  addLegend(
    pal = pal_continuous,
    values = ~pointsPerHour,
    title = "Points per hour"
  )

# discrete color scale
pph_colors <-
  c(
  "1" = "#4575B4",
  "2" = "#74ADD1",
  "3" = "#ABD9E9",
  "4" = "#E0F3F8",
  "5" = "#FFFFBF",
  "6" = "#FEE090",
  "7" = "#FDAE61",
  "8" = "#F46D43",
  "9" = "#D73027"
)

pal <-
  colorFactor(
  palette = pph_colors,
  domain = 1:9
)

linkoping |>
  leaflet() |>
  addTiles() |>
  addCircleMarkers(
    radius = 5,
    stroke = FALSE,
    fillColor = ~pal(pointsPerHour),
    fillOpacity = 0.9,
    popup = ~paste(
      "<b>", name, "</b>",
      "<br>PPH:", pointsPerHour
    )
  ) |>
  addLegend(
    pal = pal,
    values = 1:9,
    title = "Points per hour"
  )

################################################################################
# ACTIVE PLAYERS
################################################################################

# active players
players <-
  request("https://api.turfgame.com/v5/users/location") |>
  req_perform() |>
  resp_body_json(simplifyVector = TRUE) |>
  as_tibble()



players_sf <-
  players |>
  st_as_sf(
    coords = c("longitude", "latitude"),
    crs = 4326,
    remove = FALSE
  )

players_linkoping <-
  players_sf[
    st_is_within_distance(
      players_sf,
      linkoping_center,
      dist = 20000,
      sparse = FALSE
    )[, 1],
  ]

players_linkoping |>
  select(name, longitude, latitude)

players_stockholm <-
  players_sf[
    st_is_within_distance(
      players_sf,
      stockholm_center,
      dist = 20000,
      sparse = FALSE
    )[, 1],
  ]

players_stockholm |>
  select(name, longitude, latitude)

# map positions
map_positions <- function(area_data, players,
                          show_zones = TRUE,
                          show_players = TRUE,
                          show_legend = TRUE) {

  pph_colors <- c(
    "1" = "#4575B4",
    "2" = "#74ADD1",
    "3" = "#ABD9E9",
    "4" = "#E0F3F8",
    "5" = "#FFFFBF",
    "6" = "#FEE090",
    "7" = "#FDAE61",
    "8" = "#F46D43",
    "9" = "#D73027"
  )

  pal <- colorFactor(
    palette = pph_colors,
    domain = 1:9
  )

  m <- leaflet() |>
    addTiles()

  # Zones
  if (show_zones) {
    m <- m |>
      addCircleMarkers(
        data = area_data,
        radius = 5,
        stroke = FALSE,
        fillColor = ~pal(pointsPerHour),
        fillOpacity = 0.8,
        popup = ~paste(
          "<b>", name, "</b>",
          "<br>PPH:", pointsPerHour
        )
      )
  }

  # Players
  if (show_players) {
    m <- m |>
      addCircleMarkers(
        data = players,
        radius = 8,
        color = "black",
        weight = 2,
        fillColor = "white",
        fillOpacity = 1,
        popup = ~paste(
          "<b>", name, "</b>"
        )
      )
  }

  # Legend
  if (show_zones && show_legend) {
    m <- m |>
      addLegend(
        pal = pal,
        values = 1:9,
        title = "Points per hour"
      )
  }

  return(m)
}


################################################################################

stockholm <- zones_around(
  zones_sf,
  lon = 18.07,
  lat = 59.33,
  km = 20
)

linkoping_zones <-
  zones_around(zones_sf,15.62, 58.41, 20)

map_positions(
  stockholm,
  players_stockholm,
  show_legend = FALSE
)

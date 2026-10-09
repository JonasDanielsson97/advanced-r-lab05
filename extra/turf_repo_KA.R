################################################################################
# GENERAL STATISTICS
################################################################################

# sequential
req <- request("https://api.turfgame.com/v5/statistics")
resp <- req_perform(req)

data <- resp_body_json(resp, simplifyVector = TRUE)

data

# piped
data <-
  request("https://api.turfgame.com/v5/statistics") |>
  req_perform() |>
  resp_body_json(simplifyVector = TRUE)

data

################################################################################
# ZONES
################################################################################
# zone info
zone <-
  request("https://api.turfgame.com/v5/zones") |>
  req_body_json(
    list(
      list(id = 138)
    )
  ) |>
  req_perform() |>
  resp_body_json(simplifyVector = TRUE)

zone


# multiple zones
zone_ids <- c(138, 139, 140)

zones <-
  request("https://api.turfgame.com/v5/zones") |>
  req_body_json(
    map(zone_ids, \(x) list(id = x))
  ) |>
  req_perform() |>
  resp_body_json(simplifyVector = TRUE)


# all zones

# zones_all <-
#   request("https://api.turfgame.com/v5/zones/all") |>
#   req_perform() |>
#   resp_body_json(simplifyVector = TRUE) |>
#   as_tibble()


################################################################################
# USERS
################################################################################
# user info
user <-
  request("https://api.turfgame.com/v5/users") |>
  req_body_json(
    list(
      list(name = "karinalfrida")
    )
  ) |>
  req_perform() |>
  resp_body_json(simplifyVector = TRUE)

user

# multiple users
user_names <- c("karinalfrida", "radagast", "phrumpel")

user_name_list <-
  map(user_names, \(x) list(name = x))

users <-
  request("https://api.turfgame.com/v5/users") |>
  req_body_json(user_name_list) |>
  req_perform() |>
  resp_body_json(simplifyVector = TRUE)

users


map_positions <- function(area_data,
                          players = NULL,
                          show_zones = TRUE,
                          show_players = !is.null(players),
                          show_legend = TRUE) {

  # Colors for points per hour
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

  # Base map
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
        color = "#222222",
        weight = 3,
        fillColor = "#FFFFFF",
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

if (isTRUE(utils::askYesNo("Fetching all zones data can not be done more than once per 30 minutes.\n Do you want to proceed?",
                           default = FALSE))) {
  message("Fetching all zones data")
  z_all <- "zone tibble return, sf and time stamp added" # XXXXX turf_zones_all()
  return(z_all)
}

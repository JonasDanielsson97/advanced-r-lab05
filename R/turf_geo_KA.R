

#' Get geocoder data for an address, e.g. city or street
#' (HIDDEN)
#'
#' @param address A character string or character vector
#'
#'
#' @returns A tibble with geocode data for the address
#'
#' @examples get_geo_tibble("Linköping")
#'
get_geo_tibble <- function(address){
  geo_tibble <-
    tidygeocoder::geo(
      address = address,
      method = "osm",
      limit = 10,
      full_results = TRUE,
      custom_query = list(addressdetails = 1))

  return(geo_tibble)
}


#' Get latitude and longitude for an address,
#' e.g. city or street
#'
#' @param address
#' @param prio_addresstype
#'
#' @returns A tibble with the name of the address,
#' and its latitude and longitude
#' @export
#'
#' @examples get_geo_pos("Linköping")
#' get_geo_pos(c("Stockholm", "Göteborg", "Malmö", "Uppsala", "Linköping"))
#'
#'
get_geo_pos<- function(address, prio_addresstype = NA_character_) {
  prio <- c("city", "town", "village", "hamlet", "road")

  stopifnot("address must be a character string or vector"
            = is_character(address),
            "If prioritized address type is give, it must be one of: city, town, village, hamlet, or road"
            = (is.na(prio_addresstype) | (prio_addresstype %in% prio)))

  # prioritize location types
  prio <- c("city", "town", "village", "hamlet", "road")
  if (!is.na(prio_addresstype)) {
    # forcing to a specific type of location
    prio <- prio_addresstype
  }

  geo_pos <-
    get_geo_tibble(address) |>
    filter(addresstype %in% prio) |>
    mutate(prio = match(addresstype, prio)) |>
    group_by(address) |>
    slice_min(prio, n = 1, with_ties = FALSE) |>
    ungroup() |>
    select(name, osm_address.country, lat, long) |>
    rename(country = osm_address.country)

  return(geo_pos)
}


#' Gets zones within a given radius distance from
#' a specified point
#'
#' @param zones A tibble with all zones data
#' @param lon Number, longitude for the center point
#' @param lat Number, longitude for the center point
#' @param km Number, radius distance to cover
#'
#' @returns
#' @export
#'
#' @examples
zones_around <- function(center, km, zones) {

  zones[
    st_is_within_distance(
      zones,
      center,
      dist = km * 1000,
      sparse = FALSE
    )[, 1],
  ]
}



#' Get a geometric point from koordinates
#'
#' @param lat_long_vec
#'
#' @returns
#' @export
#'
#' @examples
get_sf_point_from_koord <- function(lat_long_vec){
    st_sfc(
      st_point(c(lat_long_vec[2], lat_long_vec[1])), # long, lat
      crs = 4326
    )
}




# map positions
#' Title
#'
#' @param area_data
#' @param players
#' @param show_zones
#' @param show_players
#' @param show_legend
#'
#' @returns
#' @export
#'
#' @examples


map_positions <- function(area_data,
                          players = NULL,
                          show_zones = TRUE,
                          show_players = !is.null(players),
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
      addLabelOnlyMarkers(
        data = players,
        label = "😎",
        labelOptions = labelOptions(
          noHide = TRUE,
          direction = "center",
          textOnly = TRUE,
          textsize = "24px",
          style = list(
            "font-size" = "24px"
          )
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

map_positions(linkoping_zones, players = players_linkoping)

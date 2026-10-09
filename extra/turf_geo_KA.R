# -*- coding: utf-8 -*-

#' #' (HIDDEN) Helper to get_geo_pos
#' #'
#' #' @param address A character string or character vector
#' #'
#' #' @returns A tibble with geocode data for the address
#' get_geo_tibble <- function(address){
#'   geo_tibble <-
#'     tidygeocoder::geo(
#'       address = address,
#'       method = "osm",
#'       limit = 10,
#'       full_results = TRUE,
#'       custom_query = list(addressdetails = 1))
#'
#'   return(geo_tibble)
#' }


#' Get latitude and longitude for an address
#'
#' @param address An address haracter string or vector
#' @param prio_addresstype Optional string for prioritized address type
#'
#' @returns A tibble with the name of the address,
#' and its latitude and longitude
# get_geo_pos <- function(address, prio_addresstype = NA_character_) {
#   prio <- c("city", "town", "village", "hamlet", "road")
#
#   stopifnot("address must be a character string or vector"
#             = is.character(address),
#             "If prioritized address type is give, it must be one of: city, town, village, hamlet, or road"
#             = (is.na(prio_addresstype) | (prio_addresstype %in% prio)))
#
#   # prioritize location types
#   prio <- c("city", "town", "village", "hamlet", "road")
#   if (!is.na(prio_addresstype)) {
#     # forcing to a specific type of location
#     prio <- prio_addresstype
#   }
#
#   geo_pos <-
#     get_geo_tibble(address) |>
#     dplyr::filter(addresstype %in% prio) |>
#     dplyr::mutate(prio = match(addresstype, prio)) |>
#     dplyr::group_by(address) |>
#     dplyr::slice_min(prio, n = 1, with_ties = FALSE) |>
#     dplyr::ungroup() |>
#     dplyr::select(name, osm_address.country, lat, long) |>
#     dplyr::rename(country = osm_address.country)
#
#   return(geo_pos)
# }


#' Gets zones within a given radius distance from
#' a specified point
#'
#' @param center A sf point for center point of area in focus
#' @param zones A tibble with all zones data the center point
#' @param km A number, radius distance to cover in kilometers
#'
#' @returns A sf table
#' @export
#'
#'
# zones_around <- function(center, km, zones) {
#
#   zones[
#     sf::st_is_within_distance(
#       zones,
#       center,
#       dist = km * 1000,
#       sparse = FALSE
#     )[, 1],
#   ]
# }







#'
#'
#'
#' ################################################################################
#' # DISPLAY ON MAP ALL IN ONE
#' ################################################################################
#' #' Title
#' #'
#' #' @param address A character string or vector
#' #' @param all_zones A tibble with info on all Turfgame zones
#' #' @param turfarea_radius A number, radius of area to cover
#' #' @param show_zones TRUE or FALSE
#' #' @param show_players TRUE or FALSE
#' #'
#' #' @returns Displays zones and active players
#' #' @export
#' #'
#' display_zones_and_active_players <- function(address,
#'                                              all_zones,
#'                                              turfarea_radius = 20,
#'                                              show_zones = TRUE,
#'                                              show_players = TRUE){
#'
#'   turfarea_pos <- get_geo_pos(address)
#'
#'   turfarea_koord <-
#'     turfarea_pos |>
#'     select(lat, long) |>
#'     unlist()
#'
#'   turfarea_center <-
#'     get_sf_point_from_koord(turfarea_koord)
#'
#'   turfarea_zones <-
#'     turfarea_center|>
#'     zones_around(turfarea_radius, zones_all)
#'
#'   turfarea_active_players <-
#'     all_active_players() |>
#'     active_players_in_area(turfarea_center, dist = turfarea_radius*1000)
#'
#'   show_zones <- TRUE
#'   show_players <- TRUE
#'
#'   map_positions(turfarea_zones,
#'                 turfarea_active_players,
#'                 show_zones = show_zones,
#'                 show_players = (show_players &!is.null(turfarea_active_players)),
#'                 show_legend = TRUE)
#'
#'
#' }

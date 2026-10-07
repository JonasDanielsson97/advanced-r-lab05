

#' Get all zones
#'
#' NOTE: maximum one call per 30 minutes
#'
#' @return A tibble with info on all zones,
#' vector geometry data added using sf:: package
#' time of request saved in tibble
#' @export
#'
turf_zones_all <- function(){
  turf_get("zones/all") |>
    as_tibble() |>
    # adding time of data retrieval
    mutate(time_of_request = Sys.time()) |>
    # adding vector geometry
    st_as_sf(
      coords = c("longitude", "latitude"),
      crs = 4326,
      remove = FALSE
    )
}

load_all_zones <- function(){
  # zones_all <-
  #   turf_zones_all()

  # saveRDS(zones_all, "data/zones_all.rds")

  # reading saved all zones data if present
  if (file.exists("zones_all.rds")){
    zones_all <- readRDS("data/zones_all.rds")
  }
  return(zones_all)
}



################################################################################
# ACTIVE PLAYERS
################################################################################

# active players
all_active_players <- function(){
  turf_get("users/location") |>
  as_tibble() |>
    st_as_sf(
      coords = c("longitude", "latitude"),
      crs = 4326,
      remove = FALSE
    ) |>
    select(name, id, latitude, longitude, geometry)
  }


active_players_in_area <-  function(active_players, centerpoint, dist=20000){
    active_players[
      st_is_within_distance(active_players,
                            centerpoint,
                            dist = dist,
                            sparse = FALSE)[,1],
      ]
}

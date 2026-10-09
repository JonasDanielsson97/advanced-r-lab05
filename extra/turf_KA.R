

#' Get all zones
#'
#' NOTE: maximum one call per 30 minutes
#'
#' @return A tibble with info on all zones,
#' vector geometry data added using sf:: package
#' time of request saved in tibble
#' @export
#'


load_all_zones <- function(){
  # zones_all <-
  #   turf_zones_all()

  # saveRDS(zones_all, "extra/zones_all.rds")

  # reading saved all zones data if present
  if (file.exists("zones_all.rds")){
    zones_all <- readRDS("extra/zones_all.rds")
  }
  return(zones_all)
}




################################################################################
# ACTIVE PLAYERS
################################################################################


active_players_in_area <-  function(active_players, centerpoint, dist=20000){
  active_players[
    sf::st_is_within_distance(active_players,
                              centerpoint,
                              dist = dist,
                              sparse = FALSE)[,1],
  ]
}

##### ALL ZONES  #####
#' All zones data from turf database stored in package,
#' data is updated if current data was retieved more than 31 minutes ago
#' When data is updated, polygonal locations, calculated using sf:: package,
#' and retrieval time stamp are added
#'
#' (NOTE: All zones data retrieval is allowed by the turfgame API MAX ONCE PER 30 MINUTES)
#'
#' @returns A tibble with zone data with polygonal locations and retrieval time stamp
#' @export
#'
# turf_allzones_data <-  function(update = TRUE) {}
# stopifnot("All zones data file missing! Report problem!" = !file.exists("zones_all.rds"))
# zones_all <- readRDS("data/zones_all.rds")
# if (time_of_request - Sys.time()){
#   message("Data on all turfgame zones is being updated. This may take a while, please be patient.")
# }
#   zones_all <- turf_zones_all()
#   return(zones_all)
# }


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


get_geo_pos<- function(address, prio_addresstype = NA_character_) {
  pos_tibble <-
    get_geo_tibble(address) |>
    filter(class !="boundary")

  if (is.na(prio_addresstype)) {
    prio <- c("city", "town", "village", "hamlet", "road")
    prio_type <-
      prio[prio %in% pos_tibble$type][1]}

  mpos <-
    pos_tibble |>
    filter(type == prio_type) |>
    select(
      name,
      lat,
      long
    )
  return(mpos)
}


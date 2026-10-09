#' Get current game statistics
#'
#' @return A list with statistics such as `totalUsers` and `usersOnline`.
#' @export
#' @examples
#' \dontrun{
#' turf_statistics()
#' }
turf_statistics <- function() {
  turf_get("statistics")
}

#' Get all regions
#'
#' @return A data frame with one row per region.
#' @export
#' @examples
#' \dontrun{
#' turf_regions()
#' }
turf_regions <- function() {
  turf_get("regions")
}

#' Get users by name
#'
#' @param names A character vector of user names.
#' @param warn If `TRUE` (default), give a warning listing the names that
#'   were not found. Set to `FALSE` to suppress it.
#' @return A data frame with one row per user that was found, or an empty
#'   list if none were found.
#' @export
#' @examples
#' \dontrun{
#' turf_users(c("fredrick", "ingrid"))
#' turf_users("not_a_player", warn = FALSE)
#' }
turf_users <- function(names, warn = TRUE) {
  stopifnot(is.character(names), length(names) > 0)
  stopifnot(is.logical(warn), length(warn) == 1, !is.na(warn))

  # Convert string vector to one list per name, returned as list.
  # makes names into a list of lists basicly
  body <- lapply(names, function(name) list(name = name))
  users <- turf_post("users", body)

  # The API silently drops unknown names and matches case-insensitively
  missing <- names[!tolower(names) %in% tolower(users$name)]
  if (warn && length(missing) > 0) {
    warning("User(s) not found: ", paste(missing, collapse = ", "), call. = FALSE)
  }
  users
}

#' Get the top list of users
#'
#' @param from First place to include.
#' @param to Last place to include.
#' @param country Optional country code, e.g. `"se"`.
#' @param region Optional region name, e.g. `"kalmar"`.
#' @return A data frame with one row per user, ordered by place.
#' @export
#' @examples
#' \dontrun{
#' turf_top(1, 10)
#' turf_top(1, 10, country = "se")
#' }
turf_top <- function(from = 1, to = 50, country = NULL, region = NULL) {
  stopifnot(is.numeric(from), is.numeric(to), from <= to)

  body <- list(from = from, to = to)
  body$country <- country
  body$region <- region
  turf_post("users/top", body)
}

#' Get zones by name
#'
#' @param names A character vector of zone names.
#' @return A data frame with one row per zone that was found.
#' @export
#' @examples
#' \dontrun{
#' turf_zones(c("Kårallen", "Östergötland"))
#' }
turf_zones <- function(names) {
  stopifnot(is.character(names), length(names) > 0)

  # makes names into a list of lists
  body <- lapply(names, function(name) list(name = name))
  turf_post("zones", body)
}

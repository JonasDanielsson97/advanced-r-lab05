# devtools::load_all()


object <- turf_get("statistics")
test <- turf_get("statistics")$usersOnline
turf_statistics()$usersOnline == test


# turf_statistics()
stats <- turf_statistics()
stats$usersOnline
stats$totalUsers

# turf_regions()
regions <- turf_regions()
nrow(regions)
head(regions$name)
regions |>
  dplyr::filter(country == "se") |>
  dplyr::pull(name)

# test turf_user()
users <- turf_users(c("John", "Jivet"))
users[, c("name", "points", "place", "taken")]
users$region
users$region$name

# User that does not exist
turf_users("NonExisting_fdisopfhdfjka")
# This returns an empty list
# Perhaps we should make a warning

# Top list
turf_top(1, 10)[, c("place", "name", "points")]
turf_top(1, 5, country = "se")[, c("place", "name")]
turf_top(1, 5, region = "kalmar")[, c("place", "name")]

# Zones by name
?turf_zones()
zones <- turf_zones(c("Kårallen", "Östergötland"))
zones[, c("name", "totalTakeovers", "takeoverPoints", "pointsPerHour")]
zones$currentOwner$name



# --- Things that should fail ---

try(turf_top(10, 1))          # from > to
try(turf_users(123))          # Not a character vector
try(turf_users(character()))  # Empty vector
try(turf_post("users", "not valid"))  # The API's own error message

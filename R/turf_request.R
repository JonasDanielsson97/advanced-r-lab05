# Internal helpers that are ment to talk to the Turf API.

turf_base_url <- "https://api.turfgame.com/v5" # Start of URL

# Creates request object
## Endpoint is the end of URL like: "statistics" or "regions"
turf_request <- function(endpoint) {
  httr2::request(turf_base_url) |>            # Base URL
    httr2::req_url_path_append(endpoint) |>   # Adds endpoint
    httr2::req_throttle(rate = 1) |>          # Limit to 1 request per second
    httr2::req_error(body = function(resp) {  # Show API error message
      httr2::resp_body_json(resp)$errorMessage 
    })
}

# Send a GET request and return the parsed JSON.
turf_get <- function(endpoint) {
  turf_request(endpoint) |>                       # Prepare request with turf_request()
    httr2::req_perform() |>                       # Send request (GET)
    httr2::resp_body_json(simplifyVector = TRUE)  # JSON to R objects
}

# Send a POST request with `body` as JSON and return the parsed JSON.
turf_post <- function(endpoint, body) {
  turf_request(endpoint) |>                       # Prepare request with turf_request()
    httr2::req_body_json(body) |>                 # Convert (body) from R object to JSON
    httr2::req_perform() |>                       # Send request (POST)
    httr2::resp_body_json(simplifyVector = TRUE)  # JSON to R objects
}

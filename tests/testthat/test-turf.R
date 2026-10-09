# Input checks (no API call needed)

# turf_users() errors when names is not a character vector or is empty
test_that("turf_users rejects bad input", {
  expect_error(turf_users(123))
  expect_error(turf_users(character(0)))
})

# turf_users() errors when warn is not a single TRUE/FALSE
test_that("turf_users rejects bad warn argument", {
  expect_error(turf_users("a", warn = "yes"))
  expect_error(turf_users("a", warn = NA))
  expect_error(turf_users("a", warn = c(TRUE, FALSE)))
})

# Missing users (API mocked: returns only the names it "knows")
fake_users_api <- function(endpoint, body) {
  known <- c("Fredrick", "Ingrid")
  requested <- vapply(body, function(x) x$name, character(1))
  found <- known[tolower(known) %in% tolower(requested)]
  if (length(found) == 0) return(list()) # API returns an empty list
  data.frame(name = found)
}

# No warning when every user is found, also when the case differs
# ("fredrick" vs "Fredrick")
test_that("turf_users gives no warning when all users exist", {
  local_mocked_bindings(turf_post = fake_users_api)
  expect_no_warning(res <- turf_users(c("fredrick", "Ingrid")))
  expect_equal(nrow(res), 2)
})

# Warning names the missing user(s), both when some and when all are missing,
# and the users that were found are still returned
test_that("turf_users warns about users that do not exist", {
  local_mocked_bindings(turf_post = fake_users_api)
  expect_warning(res <- turf_users(c("Fredrick", "nobody")), "nobody")
  expect_equal(res$name, "Fredrick")

  expect_warning(res <- turf_users(c("nobody", "noone")), "nobody, noone")
  expect_length(res, 0)
})

# warn = FALSE gives no warning but still returns the same result
test_that("turf_users warn = FALSE suppresses the warning", {
  local_mocked_bindings(turf_post = fake_users_api)
  expect_no_warning(res <- turf_users(c("Fredrick", "nobody"), warn = FALSE))
  expect_equal(res$name, "Fredrick")
  expect_no_warning(turf_users("nobody", warn = FALSE))
})

# turf_top() errors when from is larger than to
test_that("turf_top rejects from > to", {
  expect_error(turf_top(10, 1))
})

# Live API call (skipped if offline)

# turf_statistics() returns a list that contains totalUsers
test_that("turf_statistics returns a list", {
  skip_on_cran()
  skip_if_offline()

  stats <- turf_statistics()
  expect_type(stats, "list")
  expect_true("totalUsers" %in% names(stats))
})

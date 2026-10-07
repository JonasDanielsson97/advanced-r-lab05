# Input checks (no API call needed)
test_that("turf_users rejects bad input", {
  expect_error(turf_users(123))
  expect_error(turf_users(character(0)))
})

test_that("turf_top rejects from > to", {
  expect_error(turf_top(10, 1))
})

# Live API call (skipped if offline)
test_that("turf_statistics returns a list", {
  skip_on_cran()
  skip_if_offline()

  stats <- turf_statistics()
  expect_type(stats, "list")
  expect_true("totalUsers" %in% names(stats))
})

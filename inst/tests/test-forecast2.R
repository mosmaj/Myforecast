# A unit test for forecast2.R
if(require(fpp) & require(testthat))
{
  test_that("test meanf()", {
    meanfc <- mean(wineind)
    expect_true(all(meanf(wineind)$mean == meanfc))
    bcforecast <- meanf(wineind, lambda = -0.5)$mean
    expect_true(max(bcforecast) == min(bcforecast))
    expect_true(all(meanf(wineind, fan = TRUE)$mean == meanfc))
    expect_error(meanf(wineind, level = -10))
    expect_error(meanf(wineind, level = 110))
  })
  
  test_that("test thetaf()", {
    thetafc <- thetaf(austa)$mean
    expect_true(all(thetafc == thetaf(austa, fan = TRUE)$mean))
    expect_error(thetaf(austa, level = -10))
    expect_error(thetaf(austa, level = 110))
  })
  
  test_that("test rwf()", {
    rwfc <- rwf(oil)$mean
    expect_true(all(rwfc == naive(oil)$mean))
    expect_true(all(rwfc < rwf(oil, drift = TRUE)$mean))
    expect_true(all(rwf(oil, fan = TRUE)$mean == rwfc))
    expect_true(length(rwf(oil, lambda = 0.15)$mean) == 10)
  })
  
  test_that("test forecast.HoltWinters()", {
    hwmod <- stats::HoltWinters(cafe)
    forecast(hwmod, fan = TRUE)$mean == forecast(hwmod)$mean
    expect_error(forecast(hwmod, level = -10))
    expect_error(forecast(hwmod, level = 110))
    # Forecasts transformed manually with Box-Cox should match
    # forecasts when lambda is passed as an argument
    hwmodbc <- stats::HoltWinters(BoxCox(cafe, lambda = 0.2))
    hwfc <- forecast(hwmodbc, lambda = 0.2)$mean
    hwbcfc <- InvBoxCox(forecast(hwmodbc)$mean, lambda = 0.2)
    expect_true(all(hwfc == hwbcfc))
  })
  
  test_that("test croston()", {
    set.seed(1234)
    expect_error(croston(rnorm(100)))
    expect_true(all(croston(rep(0, 100))$mean == 0))
  })
  
  test_that("test naive() and snaive()", {
    # austa has frequency = 1, so naive and snaive should match
    expect_true(all(snaive(austa, h = 10)$mean == naive(austa)$mean))
    expect_true(all(snaive(austa, h = 10)$upper == naive(austa)$upper))
    expect_true(all(snaive(austa, h = 10)$lower == naive(austa)$lower))
  })
}

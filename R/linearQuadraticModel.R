#' linearQuadraticModel: fits linear-quadratic model to dose-survival fraction data
#' @param D vector of radiation doses
#' @param SF vector of survival fractions corresponding to the doses
#' @param lower_bounds vector of length 2 containing minimum allowed values of fitted alpha and beta, respectively
#' @param upper_bounds vector of length 2 containing maximum allowed values of fitted alpha and beta, respectively
#' @param scale parameter of the assumed error distribution of the data; see details
#' @param family family of distributions of the error terms in the data
#' @param median_n see details
#' @param SF_as_log should SF be expressed in log10 on the graph? Defaults to TRUE.
#' @param trunc should survival fractions be truncated downward to 1? Defaults to FALSE.
#' @param verbose see details
#' @export
#' plotCurve()

linearQuadraticModel <- function (D,
                                  SF,
                                  lower_bounds = c(0, 0),
                                  upper_bounds = c(0.3, 0.3),
                                  scale = 0.07,
                                  family = c("normal", "Cauchy"),
                                  median_n = 1,
                                  SF_as_log = TRUE,
                                  trunc = FALSE,
                                  verbose = FALSE) {
  match.arg(family)
  
  if (!SF_as_log) {
    SF <- log(SF)
  }
  
  if (trunc) {
    SF[which(SF > 0)] <- 0
  }
  
  gritty_guess <- .makeGrittyGuess(lower_bounds = lower_bounds,
                                   upper_bounds = upper_bounds,
                                   D = D,
                                   SF = SF)
  
  guess <- CoreGx:::.fitCurve(x = D,
                              y = SF,
                              f = RadioGx:::.linearQuadratic,
                              density = c(100, 100),
                              step = c(0.005, 0.005),
                              precision = 0.005,
                              lower_bounds = lower_bounds,
                              upper_bounds = upper_bounds,
                              scale = scale,
                              family = family,
                              median_n = median_n,
                              trunc = trunc,
                              verbose = verbose,
                              gritty_guess = gritty_guess,
                              span = 0.1)
  
  return(list(alpha = guess[1], beta = guess[2]))
}
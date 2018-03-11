######
### internal machinery of inepdata package
####

# default value for package parameters
default.download.page.url <- "http://portal.inep.gov.br/web/guest/microdados"
default.temp.path  <- "./temp"
default.max.paralell.downloads <- Inf
default.mean.wait <- 0.005 # time in seconds

# package parameters
zip.path <- ""
download.page.url <- default.download.page.url
temp.path  <- default.temp.path
max.paralell.downloads <- default.max.paralell.downloads
mean.wait <- default.mean.wait
keep.download <- FALSE
verbose <- FALSE

# package working variables
zip.files <- NULL
programs.loaded <- FALSE

#####
## Auxiliary functions
###

#' Evaluates if an URL exists
#'
#' @param url URL to be verified
#'
#' @return logical
#'
is.url.valid <- function(url){
    return(RCurl::url.exists(url))
    # defining this basic function in only one place for quick replacement if needed
}

#' Verifies internet connection state
#'
#' @return logical
#'
is.internet.ok <- function() {
    return(is.url.valid("https://www.google.com/")) # if google is down, the world has ended XD
}

#' Checks whether internet is up or down
#'
check.internet <- function() {
    if (!is.internet.ok())
        stop("Will need to download files, ",
             "but no internet connection has been found.",
             "\n\n",
             "Try again when connection established.")
}

#' String concatenation written short
#'
`%+%` <- function(a, b) {
    return(stringr::str_c(a, b))
}

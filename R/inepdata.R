#####
## Auxiliary functions
###

# Prints verbose information
#
# @param ...
#
# @examples
Verbose_ <- function(...) if (.options$verbose) cat(..., sep = "")
Verbose  <- function(...) Verbose_(..., "\n")

# Evaluates if an URL exists
#
# @param url URL to be verified
#
# @return logical
#
is.url.valid <- function(url){
    valid <- RCurl::url.exists(url)
    Verbose("is.url.valid == ", valid)
    return(valid)
    # defining this basic function in only one place for quick replacement if needed
}

# Verifies internet connection state
#
# @return logical
#
is.internet.ok <- function() {
    ok <- is.url.valid("https://www.google.com/") # if google is down, then the world has ended XD
    Verbose("is.internet.ok == ", ok)
    return(ok)
}

# Checks whether internet is up or down
#
check.internet <- function() {
    if (!is.internet.ok())
        stop("Will need to download files, ",
             "but no internet connection has been found.",
             "\n\n",
             "Try again when connection established.")
}

# String concatenation written short
#
`%+%` <- function(a, b) {
    return(stringr::str_c(a, b))
}

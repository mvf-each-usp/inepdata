# TODO: document à la roxygen2 the following


zip.urls <- NULL
default.download.page.url <- "http://portal.inep.gov.br/web/guest/microdados"

are.urls.ok <- function(download.page.url) {
    if (exists("zip.urls") && !is.null(zip.urls))
        return(TRUE)
    else
        fetch.urls(download.page.url)
}

fetch.urls <- function(download.page.url) {
    if(is.null(download.page.url))
        download.page.url <- default.download.page.url
    # TODO: check if `download.page.url` is actually accessible and has a valid HTML page
    curl::curl(download.page.url, "r")
    # TODO: download HTML from `download.page.url` and check if it has valid links to ZIP files
    # TODO: extracts all links to ZIP files and stores them into `zip.urls`
}

is.path.ok <- function(zip.files.path) {
    # TODO: check if there is a directory AND if it has ZIP files
}

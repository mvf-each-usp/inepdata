# storing options for the package

# default value for package parameters
default.download.page.url <- "http://portal.inep.gov.br/web/guest/microdados"
default.temp.path  <- "./temp"

# package parameters
.options <- new.env(parent = emptyenv())
.options$zip.path <- ""
.options$download.page.url <- default.download.page.url
.options$temp.path  <- default.temp.path
.options$keep.download <- FALSE
.options$verbose <- FALSE

# # maybe in version 2.0 I will introduce parallel processing, but not today
# default.max.paralell.downloads <- parallel::detectCores() - 1
# default.mean.wait <- 0.005 # time in seconds
# .options$max.paralell.downloads <- default.max.paralell.downloads
# .options$mean.wait <- default.mean.wait

#' Options for package `inepdata`
#'
#' @param ... these dots are here just to force parameters to be explicitly named
#' @param zip.path path to directory where the downloaded zip files are located,
#'     so that those zip files will not be downloaded if available locally.
#'     If you are not going to work with already downloaded ZIP files,
#'     then set `zip.path` to "".
#' @param download.page.url external HTML page from which the ZIP URLs will be scraped.
#'     It is there just in case the package fails to fetch the correct URL
#'     from INEP's site -- which can occur when INEP alters its site structure,
#'     for instance.
#'     (Should you detect this kind of occurrence, please contact this package's author,
#'     just in case he haven't noticed that yet.)
#'     If you do not want to seek any download page, then set `download.page.url` to "".
#'     If you want `download.page.url` back to its default value,
#'     then set `download.page.url` to `NULL`.
# #' @param max.paralell.downloads number of maximum parallel downloads to be realized.
# #'     Default is the number of CPUs minus 1 and you can simply do
# #'     `max.paralell.downloads = NULL` to set `max.paralell.downloads` back to it.
#' @param temp.path where should the microdata ZIP files be downloaded and decompressed?
#'     It cannot be set "" and, if attempted, it is set to its default value "./temp".
#' @param keep.download whether to keep or purge the downloaded packed microdata files
#' @param verbose do you want know what is going on under the hood while these functions
#'      are running? (currently, not implemented)
#'
#' @export
#' @md
#'
#' @examples
#' # in case INEP microdata download page changes:
#' options(download.page.url = "http://inep.hypothetical.new.page/microdata")
#' # if you have part of your data already downloaded
#' options(zip.path = "./zipfiles.I.already.downloaded/")
#' # if you only want to work with the data you already downloaded, without looking at INPE's page
#' options(download.page.url = "", zip.path = "./zipfiles.I.already.downloaded/") #
#' options(temp.path = "/tmp/")     # Unix example
#' options(keep.download = TRUE, temp.path = "./store.zip.files.here/")
#'
Options <- function(..., zip.path, download.page.url, temp.path,
                    # max.paralell.downloads, mean.wait,
                    keep.download, verbose) {
    if (!identical(list(),list(...)))
        stop("Could not handle option(s): ", paste0(names(list(...)), collapse = ", "))
    if (
        missing(zip.path) && missing(download.page.url) && missing(temp.path) &&
        missing(keep.download) && missing(verbose)
    ) {
        return(as.list(.options))
    }
    zip.path.null <- FALSE
    download.page.url.null <- FALSE
    Verbose("parsing `zip.path`")
    if (!missing(zip.path)) {
        if (!is.character(zip.path))
            stop("Parameter `zip.path` must be character.")
        if (length(zip.path) > 1)
            stop("Length of parameter `zip.path` must be 1.")
        if(zip.path != "") {
            zip.path <- normalizePath(zip.path)
            if (!dir.exists(zip.path))
                stop("Directory given in `zip.path` does not exist.")
            if (length(list.files(path = zip.path, pattern = "*.zip")) == 0)
                stop("No ZIP file found in directory given in `zip.path`.")
        } else {
            zip.path.null <- TRUE
        }
        .options$zip.path <- zip.path
    }
    Verbose("parsing `download.page.url`")
    if (!missing(download.page.url)) {
        if (is.null(download.page.url)) {
            .options$download.page.url <- default.download.page.url
            check.internet()
            if(!is.url.valid(default.download.page.url))
                stop("The original INEP microdata download page URL <",
                     default.download.page.url,
                     "> is not working.",
                     "\n\n",
                     "The URL may have actually changed, ",
                     "but it is also possible that you are experiencing internet restrictions.",
                     "\n\n",
                     "If that URL is really no longer valid ",
                     "(e.g., manually verifying it at an internet browser),\n",
                     "    then check if the package 'inepdata' needs update.\n",
                     "If it is update,\n",
                     "    then please inform the creator of the package.",
                     "\n\n",
                     "In the mean time, if you know an alternative or new URL, ",
                     "you can inform it through the parameter 'download.page.url'")
        } else {
            if (!is.character(download.page.url))
                stop("Parameter `download.page.url` must be character.")
            if (length(download.page.url) > 1)
                stop("Length of parameter `download.page.url` must be 1.")
            if(download.page.url != "") {
                check.internet()
                if (!is.url.valid(download.page.url))
                    stop("URL given in `download.page.url` is not valid.",
                         "Have you tried the package's default URL, ",
                         "setting `download.page.url` to NULL?")
                if (
                    xml2::read_html(download.page.url) %>%
                    rvest::html_nodes("a") %>%
                    rvest::html_attr("href") %>%
                    stringr::str_subset("\\.zip") %>%
                    length() == 0
                )
                    stop("No ZIP file links were found on URL given in `download.page.url`.")
            } else {
                download.page.url.null <- TRUE
            }
            .options$download.page.url <- download.page.url
        }
    }
    if (zip.path.null && download.page.url.null)
        stop("Parameters `zip.path` and `download.page.url` cannot be both \"\".")
    if (!missing(download.page.url) || !missing(zip.path)) {
        Verbose("loading programs again")
        load.programs()
    }
    Verbose("parsing `temp.path`")
    if (!missing(temp.path)){
        if (!is.character(temp.path))
            stop("Parameter `temp.path` must be character.")
        if (length(temp.path) > 1)
            stop("Length of parameter `temp.path` must be 1.")
        if(temp.path != "") {
            temp.path <- normalizePath(temp.path)
            if (!dir.exists(temp.path))
                dir.create(temp.path)
            .options$temp.path <- temp.path
        } else {
            warning("Parameter `` cannot be \"\". Coerced to \"./temp\".")
        }
    }
    # if (!missing(max.paralell.downloads)){
    #     if (is.null(max.paralell.downloads)) {
    #         .options$max.paralell.downloads <- default.max.paralell.downloads
    #     } else {
    #         if (!is.integer(max.paralell.downloads))
    #             stop("Parameter `max.paralell.downloads` must be integer.")
    #         if (length(max.paralell.downloads) > 1)
    #             stop("Length of parameter `max.paralell.downloads` must be 1.")
    #         if (max.paralell.downloads < 1)
    #             stop("Parameter `max.paralell.downloads` must be at least 1.")
    #         .options$max.paralell.downloads <- max.paralell.downloads
    #     }
    # }
    # if (!missing(mean.wait)){
    #     if (is.null(mean.wait)) {
    #         .options$mean.wait <- default.mean.wait
    #     } else {
    #         if (!is.numeric(mean.wait))
    #             stop("Parameter `mean.wait` must be numeric.")
    #         if (length(mean.wait) > 1)
    #             stop("Length of parameter `mean.wait` must be 1.")
    #         if (mean.wait <= 0)
    #             stop("Parameter `mean.wait` must be positive.")
    #         .options$mean.wait <- mean.wait
    #     }
    # }
    Verbose("parsing `keep.download`")
    if (!missing(keep.download)){
        if (!is.logical(keep.download))
            stop("Parameter `keep.download` must be logical.")
        if (length(keep.download) > 1)
            stop("Length of parameter `keep.download` must be 1.")
        .options$keep.download <- keep.download
    }
    if (!missing(verbose)){
        if (!is.logical(verbose))
            stop("Parameter `verbose` must be logical.")
        if (length(verbose) > 1)
            stop("Length of parameter `verbose` must be 1.")
        .options$verbose <- verbose
    }
}

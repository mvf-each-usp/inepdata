# storing options for the package

# default value for package parameters
default.zip.path <- ""
default.offline <- FALSE
default.download.page.url <- "http://portal.inep.gov.br/web/guest/microdados"
default.temp.path  <- "./temp"
default.keep.download <- FALSE
default.verbose <- FALSE


# package parameters
.options <- new.env(parent = emptyenv())
.options$zip.path <- default.zip.path
.options$offline <- default.offline
.options$download.page.url <- default.download.page.url
.options$temp.path  <- default.temp.path
.options$keep.download <- default.keep.download
.options$verbose <- default.verbose

# development version default value of the above options
# comment out before issuing any release
.options$zip.path <- default.temp.path
.options$offline <- TRUE
.options$verbose <- TRUE

# # maybe in version 2.0 I will introduce parallel processing, but not today
# default.max.paralell.downloads <- parallel::detectCores() - 1
# default.mean.wait <- 0.005 # time in seconds
# .options$max.paralell.downloads <- default.max.paralell.downloads
# .options$mean.wait <- default.mean.wait

#' Options for package `inepdata`
#'
#' @param ...
#'     these dots are here just to force parameters to be explicitly named
#' @param zip.path
#'     paths to directories where the downloaded zip files are located,
#'         so that those zip files will not be downloaded if available locally.
#'     If you are not going to work with already downloaded ZIP files,
#'         then set `zip.path` to `NULL` or to `""`.
#'
#'     **Important**: the filenames must be equal to the corresponding file in INEP site.
#'
#'     Default value: `""`
#' @param offline
#'     whether you want to work only with ZIP files already downloaded at `zip.path`
#'         or work scrape ZIP file links in INEP microdata download page at `download.page.url`.
#'     If `offline` is `TRUE`, then `zip.path` will need to be set to a value other than `""`
#'
#'     Default value: `FALSE`
#' @param download.page.url
#'     external HTML page from which the ZIP URLs will be scraped if `offline` is false.
#'     It is there just in case the package fails to fetch the correct URL
#'         from INEP's site -- which can occur when INEP alters its site structure,
#'         for instance.
#'     (_Should you detect this kind of occurrence, please contact this package's author,
#'         just in case he haven't noticed that yet._)
#'     If you want `download.page.url` back to its default value,
#'         then set `download.page.url` to `NULL` or to `""`.
#'
#'     Default Value: `"http://portal.inep.gov.br/web/guest/microdados"`
# #' @param max.paralell.downloads
# #'     number of maximum parallel downloads to be realized.
# #'     If your want to set it back to its default value, then you can set to `NULL`.
# #'
# #'     Default value: number of CPUs minus 1
#' @param temp.path where should the microdata ZIP files be downloaded and decompressed?
#'     It cannot be set "" and, if attempted, it is set to its default value "./temp".
#'
#'     Default value: `"./temp"`
#' @param keep.download whether to keep or purge the downloaded packed microdata files
#'
#'     Default value: `FALSE`
#' @param verbose do you want know what is going on under the hood while these functions
#'      are running?
#'
#'      Default value: `FALSE`
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
Options <- function(..., zip.path, offline, download.page.url, temp.path,
                    # max.paralell.downloads, mean.wait,
                    keep.download, verbose) {
    if (!identical(list(),list(...)))
        stop("Could not handle option(s): ", paste0(names(list(...)), collapse = ", "))
    if (
        missing(zip.path) && 
        missing(offline) && 
        missing(download.page.url) && 
        missing(temp.path) &&
        missing(keep.download) && 
        missing(verbose)
    ) {
        return(as.list(.options))
    }
    if (!missing(zip.path)) {
        Verbose("parsing `zip.path`")
        if (is.null(zip.path))
            zip.path <- default.zip.path
        if (!is.character(zip.path))
            stop("Parameter `zip.path` must be character.")
        # if (length(zip.path) > 1)
        #     stop("Length of parameter `zip.path` must be 1.")
        if (!identical(zip.path, "")) {
            if (!all(dir.exists(zip.path)))
                stop("One or more directories given in `zip.path` does not exist.")
            zip.path <- normalizePath(zip.path)
            if (length(list.files(path = zip.path, pattern = "*.zip")) == 0)
                stop("No ZIP file found in directories given in `zip.path`.")
        }
        .options$zip.path <- zip.path
    }
    if (!missing(offline)) {
        Verbose("parsing `offline`")
        if (is.null(offline))
            offline <- default.offline
        if (!is.logical(offline))
            stop("Parameter `offline` must be logical.")
        if (length(offline) > 1)
            stop("Length of parameter `offline` must be 1.")
        .options$offline <- offline
        if (offline == TRUE) {
            if (.options$zip.path == "") # zip.path já foi processado
                warning(
                    "The parameter `offline` is set to TRUE, ",
                    "but the parameter `zip.path` is set to \"\".\n",
                    "You will need to provide some path with ZIP files in it through `zip.path`\n",
                    "in order to the package `inepdata` perform any work at all."
                )
        } else { # por sua vez, download.page.url ainda não foi processado
            if(missing(download.page.url) && !is.url.valid(.options$download.page.url)) {
                warning(
                    "The parameter `offline` is set to FALSE, ",
                    "but `download.page.url` is not valid.\n",
                    "You will need to provide a valid URL or set it to default value."
                )
            }
        }
    }
    if (!missing(download.page.url)) {
        Verbose("parsing `download.page.url`")
        if (is.null(download.page.url))
            .options$download.page.url <- default.download.page.url
        if (!is.character(download.page.url))
            stop("Parameter `download.page.url` must be character.")
        if (length(download.page.url) > 1)
            stop("Length of parameter `download.page.url` must be 1.")
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
        .options$download.page.url <- download.page.url
    }
    if (!missing(download.page.url) || !missing(zip.path)) {
        Verbose("loading programs again")
        load.programs()
    }
    if (!missing(temp.path)){
        Verbose("parsing `temp.path`")
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
    if (!missing(keep.download)){
        Verbose("parsing `keep.download`")
        if (!is.logical(keep.download))
            stop("Parameter `keep.download` must be logical.")
        if (length(keep.download) > 1)
            stop("Length of parameter `keep.download` must be 1.")
        .options$keep.download <- keep.download
    }
    if (!missing(verbose)){
        Verbose("parsing `verbose`")
        if (!is.logical(verbose))
            stop("Parameter `verbose` must be logical.")
        if (length(verbose) > 1)
            stop("Length of parameter `verbose` must be 1.")
        .options$verbose <- verbose
    }
}

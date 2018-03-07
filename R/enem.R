#' Gets Data from ENEM (Exame Nacional de Ensino Médio)
#'
#' Downloads, unpacks, imports, organizes and formats microdata from ENEM editions
#'
#' @param years years to get from INEP site or from the directory informed in `zip.files.path` below;
#'     it should be a vector of either integers or strings
#' @param zip.files.path path to directory where the downloaded zip files are located;
#'     if `zip.files.path` is provided, no download will be attempted
#' @param download.page.url external http link from where to download.
#'     It is there just in case the package fails to fetch the correct URL
#'     from INEP's site -- which can occur when INEP alters its site structure,
#'     for instance.
#'     (Should you detect this kind of occurrence, please contact this package's author,
#'     just in case he haven't noticed that yet.)
#' @param temp.path where should the packed microdata file(s) be downloaded?
#' @param keep.download whether to keep or purge the downloaded packed microdata files
#' @param verbose do you want know what is going on while this function works?
#'
#' @return
#' A list of lists, indexed by the years present in `year` that could be processed.
#'
#' For each year in `years`, either one list is returned in case of success (total or
#' partial) or `NULL` is returned in case of complete lack of success.
#'
#' In case of success, the item for each year will be a list containing the following
#' fields:
#' - `last.successful.step` -- a string; either "download", "unpack", "import", "organize" or "format"
#' - `download.url` -- URL used to download the packed archive
#' - `data.frame` -- what you are really looking for; it will be here in case of full
#'     success; it will be either one single data frame or a list of data frames or `NULL`
#'
#' There might be one or more of the following additional fields in the following
#' conditions:
#' - If `keep.download == TRUE` or if `last.successful.step == download`,
#'     - `downloaded.file` -- path and name of the downloaded packed file
#' - If `last.successful.step == unpack`,
#'     - `unpacked.files` -- path of the directory where the archive was unpacked
#' - If `last.successful.step == import`,
#'     - `raw.data.frames` -- it will be either one single data frame or a list of data frames
#'
#' @details
#' `enem()` will scrape the adequate files in
#'     [INEP's microdata page](http://portal.inep.gov.br/web/guest/microdados).
#'
#' @examples
#' # getting data from years 2014 to 2016
#' enem(2014:2016)
#'
#' @export
#' @md
#'
enem <- function(years, zip.files.path, download.page.url = NULL, temp.path = "./tmp",
                 keep.download = FALSE, verbose = FALSE){
    if (missing(years))
        stop("You need to provide at least one year")
    years <- as.numeric(years)
    if (missing(zip.files.path)) { # need to download all files
        if (!are.urls.ok(download.page.url))
            stop("Could not fetch URLs to ZIP files. Try informing a valid URL")
        if (!curl::has_internet())
            stop("Will need to download files, but no internet connection has been found")
        # TODO: download files here
        # TODO: set up `temp.path`
    } else {  # files downloaded already; no longer need to download
        if (!is.path.ok(zip.files.path)) {
            stop("No ZIP files found at the path provided in 'zip.files.path'")
        }
        # TODO: set up `temp.path`
    }
    # TODO: unpack ZIP files %in% `years`
    # TODO: import unpacked files %in% `years`
    # TODO: organize imported data.frames
    # TODO: format organized data.frames
}

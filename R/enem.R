#' Gets Data from ENEM (Exame Nacional de Ensino Médio)
#'
#' Downloads, unpacks, imports, organizes and formats microdata from ENEM editions
#'
#' @param years years to get from INEP site; should be a vector of integers
#' @param link external http link from where to download.  It is there just in case the
#'     package fails to fetch the correct URL from INEP's site -- which can occur when
#'     INEP alters its site structure, for instance.
#'     (Should you detect this kind of occurrence, please contact this package's author,
#'     just in case he haven't noticed that yet.)
#' @param temp.path where should the packed microdata file(s) be downloaded?
#' @param keep.download whether to keep or purge the downloaded packed microdata files
#' @param verbose do you want know what is going on while this function works?
#'
#' @return
#' A list of lists, indexed by the years present in \code{years} that could be processed.
#'
#' For each year in \code{years}, either one list is returned in case of success (total or
#' partial) or \code{NULL} is returned in case of complete lack of success.
#'
#' In case of success, the item for each year will be a list containing the following
#' fields:
#'
#' - \code{data.frame} -- what you are really looking for; it will be here in case of full
#'     success; it will be either one single data frame or a list of data frames
#'
#' - \code{last.successfull.step} -- a string; either "download", "unpack", "import",
#'     "organize" or "format"
#'
#' Case \code{keep.download == TRUE},
#'
#' - \code{downloaded.file} path and name of the downloaded packed file
#'
#' @examples
#' # getting data from years 2014 to 2016
#' enem(2014:2016)
#'
#' @export
#'
enem <-
    function(years, link = NULL, temp.path = ".", keep.download = FALSE, verbose = FALSE){

    }

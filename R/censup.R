#' Gets Data from CenSup (Censo da Educação Superior)
#'
#' Downloads, unpacks, imports, organizes and formats microdata from CenSup editions
#'
#' @param years years to get from INEP site informed in `download.page.url` or
#'     from the directory informed in `zip.path`, both parameters of
#'     [Options()] function.
#'     It should be a vector of either integers or strings.
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
#' @examples
#' # getting data from years 2014 to 2016
#' enem(2014:2016)
#'
#' @export
#' @md
#' @importFrom magrittr "%>%"
#' @importFrom magrittr "%<>%"
#'
censup <- function(years){
    Verbose("Getting CenSup microdata")
    fetched <- fetch.archives("censup", years)
    # TODO: extract ZIP files present in both `temp.path` and `years` each in a different subdir
    decompressed <- decompress(fetched)
    # TODO: parse SPSS or SAS syntax to get column types right
    metadata <- parse.metadata(decompressed)
    # TODO: import data.frames with metadata parsed from syntax
    imported <- import(decompressed, metadata)
    # TODO: format imported data.frames
    formatted <- format(imported)
    # TODO: organize formated data.frames
    organized <- organize(formated)
    # TODO: after all is running smooth, change it to a pipe
    # TODO: remove extracted files
    # TODO: remove ZIP files if `keep.download` is FALSE
}

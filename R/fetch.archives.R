# Fetches ZIP files for a specific program
#
# @param program any value in `available.programs$program`
# @param years any set of values in `available.programs$years[[program]]`
#
# @md
#
# @examples
# fetch.archives("enem", 2000)
# fetch.archives("enade", 2005:2008)
fetch.archives <- function(Program, years){
    # assumption checking
    if (!Program %in% inepdata::available.programs$program)
        stop("Parameter 'program' must be one of 'available.programs$program' possibilities.")
    if (any(is.na(suppressWarnings(as.numeric(years)))))
        stop("Parameter 'years' must be numeric or at least coercible to.")
    fetch.years <- intersect(years, inepdata::available.programs$years[[Program]])
    if (length(fetch.years) == 0)
        stop("Parameter 'years' contains no year with available microdata for the selected program.")
    # let's start working
    if (!.data$programs.loaded)
        load.programs()
    Verbose("filtering which program and years to fetch")
    program.2b.fetched <-
        .data$zip.files %>%
        dplyr::filter(program == Program) %>%
        dplyr::filter(year %in% fetch.years)
    if (program.2b.fetched %>% dplyr::filter(is.url) %>% dplyr::count() > 0) {
        Verbose("downloading ZIP files")
        program.2b.fetched %>%
        dplyr::filter(is.url) %>%
        magrittr::extract("location") %>%
        download.zip()
    }
    if (program.2b.fetched %>% dplyr::filter(!is.url) %>% dplyr::count() > 0) {
        Verbose("copying local ZIP files")
        program.2b.fetched %>%
        dplyr::filter(!is.url) %>%
        magrittr::extract("location") %>%
        copy.zip()
    }
}

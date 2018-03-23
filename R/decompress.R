# Decompresses ZIP files
#
# @param fetched list of data about the ZIP files
#
# @return tibble with aditional info about the files extracted from the ZIP files
# @md
#
decompress <- function(fetched) {
    # assumption checking
        # TODO
    # back to work
    # TODO: include Verbose() messages
    fetched %>%
        dplyr::mutate(
            unzipped.where =
                normalizePath(inepdata:::.options$temp.path) %+% "/" %+% program %+% "/" %+% year,
            create.dir.ok = sapply(unzipped.where, dir.create, recursive = T, showWarnings = F)
        ) %>%
        dplyr::mutate(
            extracted =
                purrr::map2(filename, unzipped.where, ~ unzip(zipfile = .x, exdir = .y))
        )
}

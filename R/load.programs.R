# package working variables
.data <- new.env(parent = emptyenv())
.data$zip.files <- NULL
.data$programs.loaded <- FALSE

#' Loads available programs
#'
#' Loads programs available in download page given by `download.page.url` and available
#' locally as zip files given by `zip.path`
#'
#' @export
#' @md
#' @importFrom magrittr "%>%"
#' @importFrom magrittr "%<>%"
#' @importFrom dplyr row_number
#'
load.programs <- function() {
    null.zip.files <-
        data.frame(
            location = as.character(NULL),
            is.url = as.logical(NULL),
            stringsAsFactors = FALSE
        )
    # scrape ZIP links in INEP microdata page `download.page.url`
    if (.options$download.page.url != "") {
        check.internet()
        Verbose("scraping ZIP links")
        download.page <- url(.options$download.page.url)
        remote.zip.files <-
            dplyr::data_frame(
                location =
                    download.page %>%
                    xml2::read_html(verbose = .options$Verbose) %>%
                    rvest::html_nodes("a") %>%
                    rvest::html_attr("href") %>%
                    stringr::str_subset("\\.zip") %>%
                    stringr::str_replace(" .*", ""), # o 24o link tem um espaço em branco por engano
                is.url = TRUE
            ) %>%
            dplyr::mutate(
                size =
                    sapply(
                        location,
                        function(loc)
                            as.integer(httr::HEAD(loc)$headers$`content-length`)
                    )
            )
        close(download.page)
    } else remote.zip.files <- null.zip.files
    # search for ZIP files locally in `zip.path` if any
    if (.options$zip.path != ""){
        Verbose("looking for local ZIP files")
        local.zip.files <-
            dplyr::data_frame(
                location =
                    .options$zip.path %+% "/" %+%
                    list.files(path = .options$zip.path, pattern = "*.zip") %>%
                    normalizePath(),
                is.url = FALSE
            ) %>%
            dplyr::mutate(size = file.info(location)$size)
    } else local.zip.files <- null.zip.files
    # join both
    Verbose("joining remote ZIP links with local ZIP files")
    zip.files <- rbind(remote.zip.files, local.zip.files)
    if (nrow(zip.files) == 0)
        stop("Could not fetch ZIP files neither locally nor remotely.")
    # process both urls and local filenames
    zip.files %<>%
        dplyr::mutate(
            filename = location %>%
                stringr::str_replace(".*/([^/]*)\\.zip$", "\\1"),
            year = filename %>%
                stringr::str_replace("[A-Za-z_]*([0-9]{4}).*", "\\1"),
            program = filename %>%
                stringr::str_replace("([A-Za-z_]*)_?[0-9]{4}.*", "\\1") %>%
                stringr::str_replace_all(
                    c(
                        ".*(superior).*" = "censup",
                        ".*(cpm).*" = "cpm",
                        ".*(censo).*(escolar).*" = "censo_escolar",
                        ".*(enade).*" = "enade",
                        ".*(enem|ENEM).*" = "enem",
                        ".*(discriminat).*" = "padae",
                        ".*(pnera).*" = "pnera",
                        ".*(saeb|aneb).*" = "aneb",
                        ".*(prova).*(brasil).*" = "anresc",
                        ".*(provao).*" = "enc",
                        ".*(ana).*" = "ana",
                        ".*(idd).*" = "idd"
                    )
                ) %>%
                factor(levels = levels(available.programs$program))
        ) %>%
        dplyr::arrange(program, year, is.url) %>%
        dplyr::group_by(program, year) %>%
        dplyr::filter(row_number() == 1) %>%
        dplyr::ungroup()
    Verbose("programs loaded")
    .data$zip.files <- zip.files
    .data$programs.loaded <- TRUE
}

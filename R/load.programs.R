#' Loads available programs
#'
#' Loads programs available in download page given by `download.page.url` and available
#' locally as zip files given by `zip.path`
#'
#' @export
#' @md
#' @importFrom magrittr "%>%"
#' @importFrom magrittr "%<>%"
#'
load.programs <- function() {
    null.zip.files <-
        data.frame(
            location = as.character(NULL),
            is.url = as.logical(NULL),
            stringsAsFactors = FALSE
        )
    # scrape ZIP links in INEP microdata page `download.page.url`
    if (download.page.url != "") {
        check.internet()
        remote.zip.files <-
            data.frame(
                location = xml2::read_html(download.page.url) %>%
                    rvest::html_nodes("a") %>%
                    rvest::html_attr("href") %>%
                    stringr::str_subset("\\.zip"),
                is.url = TRUE,
                stringsAsFactors = FALSE
            )
    } else {
        remote.zip.files <- null.zip.files
    }
    # search for ZIP files locally in `zip.path` if any
    if (zip.path != ""){
        local.zip.files <-
            data.frame(
                location = list.files(zip.path %+% "/*.zip"),
                is.url = FALSE,
                stringsAsFactors = FALSE
            )
    } else {
        local.zip.files <- null.zip.files
    }
    # join both
    zip.files <- rbind(remote.zip.files, local.zip.files)
    if (nrow(zip.files) == 0)
        # TODO HERE
        stop("")
    # process both urls and local filenames
    zip.files %<>%
        dplyr::mutate(
            filename = location %>%
                stringr::str_replace(".*/([^/]*)\\.zip.*$", "\\1"),
            year = filename %>%
                stringr::str_replace("[A-Za-z_]*([0-9]{4}).*", "\\1"),
            program = filename %>%
                stringr::str_replace("([A-Za-z_]*)_?[0-9]{4}.*", "\\1") %>%
                # stringr::str_replace("micro(dados)?_?(.*)", "\\2") %>%
                # stringr::str_replace("(.*)_", "\\1") %>%
                # pegando os programas específicos
                stringr::str_replace(".*(superior).*", "censup") %>%
                stringr::str_replace(".*(cpm).*", "cpm") %>%
                stringr::str_replace(".*(censo).*(escolar).*", "censo_escolar") %>%
                stringr::str_replace(".*(enade).*", "enade") %>%
                stringr::str_replace(".*(enem|ENEM).*", "enem") %>%
                stringr::str_replace(".*(discriminat).*", "padae") %>%
                stringr::str_replace(".*(pnera).*", "pnera") %>%
                stringr::str_replace(".*(saeb|aneb).*", "aneb") %>%
                stringr::str_replace(".*(prova).*(brasil).*", "anresc") %>%
                stringr::str_replace(".*(provao).*", "enc") %>%
                stringr::str_replace(".*(ana).*", "ana") %>%
                stringr::str_replace(".*(idd).*", "idd") %>%
                factor(levels = levels(available.programs$program))
        ) %>%
        dplyr::group_by(program, year) %>%
        # years with microdata already downloaded will show up here in the form of
        #   duplicated lines: the first with `is.url == F` and the second with `is.url == T`
        # TODO: test whether this muthafucka actually works or not
        dplyr::filter(dplyr::row_number() == 1)
    inepdata:::zip.files <- zip.files
    inepdata:::programs.loaded <- TRUE
}

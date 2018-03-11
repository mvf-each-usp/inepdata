#' Programs with microdata available for download
#'
#' This is a list of INEP programs (censuses, national exams and nation wide surveys)
#' whose microdata were made available by INEP for download
#'
#' @export
# this data frame is public
# needed the weird `available.programs <- (function(){})()` for this data frame,
#   because its last column/variable is a list of numeric
#   and that was the only way I found to put it into the data.frame
available.programs <-
    (
        function() {
            programs <-
                data.frame(
                    program =
                        factor(
                            c(
                                "censup",
                                "cpm",
                                "censo_escolar",
                                "enade",
                                "enem",
                                "padae",
                                "pnera",
                                "anresc",
                                "aneb",
                                "ana",
                                "enc",
                                "idd"
                            )
                        ),
                    name = c(
                        "Censo da Educação Superior",
                        "Censo dos Profissionais do Magistério",
                        "Censo Escolar",
                        "Exame Nacional de Desempenho de Estudantes",
                        "Exame Nacional de Ensino Médio",
                        "Pesquisa de Ações Discriminatórias no Âmbito Escolar",
                        "Pesquisa Nacional da Educação na Reforma Agrária",
                        "Avaliação Nacional do Rendimento Escolar",
                        "Avaliação Nacional da Educação Básica",
                        "Avaliação Nacional da Alfabetização",
                        "Exame Nacional de Cursos",
                        "Indicador da Diferença entre os Desempenhos Observado e Esperado"
                    ),
                    nickname = c(
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "Prova Brasil",
                        "Saeb/Prova Brasil",
                        "",
                        "Provão Brasil",
                        ""
                    ),
                    acronym = c(
                        "CenSup",
                        "CPM",
                        "",
                        "ENADE",
                        "ENEM",
                        "",
                        "PNERA",
                        "ANRESC",
                        "ANEB",
                        "ANA",
                        "ENC",
                        "IDD"
                    ),
                    translation = c(
                        "Census of Higher Education",
                        "Census of Teaching Professionals",
                        "Census of Basic Education",
                        "Higher Education Student Performance National Exam",
                        "High School National Exam",
                        "Survey of Discriminatory Actions in School",
                        "National Survey of Education in Agrarian Reform",
                        "National Evaluation of School Performance",
                        "National Evaluation of Basic Education",
                        "Alphabetization National Exam",
                        "Course National Exam",
                        "Indicator of Difference between Observed and Expected Performances"
                    ),
                    about = c(
                        "Censo da Educação Superior",
                        "Censo dos Profissionais do Magistério",
                        "Censo Escolar",
                        "Exame Nacional de Desempenho de Estudantes",
                        "Exame Nacional de Ensino Médio",
                        "Pesquisa de Ações Discriminatórias no Âmbito Escolar",
                        "Pesquisa Nacional da Educação na Reforma Agrária",
                        "Avaliação Nacional do Rendimento Escolar",
                        "Avaliação Nacional da Educação Básica",
                        "Avaliação Nacional da Alfabetização",
                        "Exame Nacional de Cursos",
                        "Indicador da Diferença entre os Desempenhos Observado e Esperado"
                    ),
                    stringsAsFactors = FALSE
                )
            # and here, the only way to store a list as a column in a data.frame
            # note to self:
            #   that "only way" is the reason for the weird syntax
            #   `available.programs <- (function() {})()`
            years <-
                list(
                    1995:2016,
                    2003,
                    1995:2017,
                    2004:2016,
                    1998:2016,
                    2008,
                    2004,
                    seq(2007, 2011, 2),
                    seq(1995, 2015, 2),
                    seq(2014, 2016, 2),
                    1997:2003,
                    2014:2016
                )
            names(years) <- programs$program
            programs$years <- years
            return(programs)
        }
    )()

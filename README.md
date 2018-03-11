# inepdata

Microdata from INEP 

This package downloads, decompresses, imports, formats and organizes microdata about Brazilian educational system that was made available by INEP (<http://www.inep.gov.br/>).

INEP stands for *Instituto Nacional de Estudos e Pesquisas Educacionais Anísio Teixeira* (National Institute for Educational Studies and Research "Anísio Teixeira"; see <http://portal.inep.gov.br/web/guest/about-inep>) is a Brazilian federal research agency responsible for assessing basic and higher education nationally through a series of censuses, national exams and nation wide surveys, collectively called *programs* at INEP.

The microdata download page currently makes available data from the following programs, 
each with different combinations of years of availability:

| Program Name                                                      | Acronym   | Translation                                           | Year Span                 |
|-------------------------------------------------------------------|:---------:|-------------------------------------------------------|-------------------        |
| Censo da Educação Superior                                        | CenSup    | Census of Higher Education                            | 1995 -- 2016              |
| Censo dos Profissionais do Magistério                             | CPM       | Census of Teaching Professionals                      | 2003                      |
| Censo Escolar                                                     |           | Census of Basic Education                             |                           |
| Exame Nacional de Desempenho de Estudantes                        | ENADE     | Higher Education Student Performance National Exam    | 2004 -- 2016              |
| Exame Nacional de Ensino Médio                                    | ENEM      | High School National Exam                             | 1998 -- 2016              |
| Pesquisa de Ações Discriminatórias no Âmbito Escolar              |           | Survey of Discriminatory Actions in School            | 2008                      |
| Pesquisa Nacional da Educação na Reforma Agrária                  | PNERA     | National Survey of Education in Agrarian Reform       | 2004                      |
| Avaliação Nacional do Rendimento Escolar (Prova Brasil)           | ANRESC    |                                                       | 2007 -- 2011 (biannual)   |
| Provão                                                            |           |                                                       | 1997 -- 2003              |
| Sistema de Avaliação da Educação Básica (Saeb/Aneb/Prova Brasil)  | SAEB      |                                                       | 1995 -- 2015 (biannual)   |
|  Avaliação Nacional da Alfabetização | ANA | Alphabetization National Exam | 2014 --2016 (biannual) |
| Indicado da Diferença entre os Desempenhos Observado e Esperado

# available.programs %>% pander::pander()

That information, the ZIP archives names and URLs are scraped from [this page](http://portal.inep.gov.br/web/guest/microdados).

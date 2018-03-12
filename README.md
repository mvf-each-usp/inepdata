# inepdata

Microdata from INEP 

This package downloads, decompresses, imports, formats and organizes microdata about Brazilian educational system that was made available by INEP (<http://www.inep.gov.br/>).

INEP stands for *Instituto Nacional de Estudos e Pesquisas Educacionais Anísio Teixeira* (National Institute for Educational Studies and Research "Anísio Teixeira"; see <http://portal.inep.gov.br/web/guest/about-inep>) is a Brazilian federal research agency responsible for assessing basic and higher education nationally through a series of censuses, national exams and nation wide surveys, collectively called *programs* at INEP.

The microdata download page currently makes available data from the following programs, 
each with different combinations of years of availability:

<!-- available.programs %>% pander::pander(split.table = 200) -->

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    program                   name                    nickname        acronym            translation                        about                            years             
--------------- -------------------------------- ------------------- --------- ------------------------------- -------------------------------- -------------------------------
    censup         Censo da Educação Superior                         CenSup     Census of Higher Education       Censo da Educação Superior     1995, 1996, 1997, 1998, 1999, 
                                                                                                                                                 2000, 2001, 2002, 2003, 2004, 
                                                                                                                                                 2005, 2006, 2007, 2008, 2009, 
                                                                                                                                                 2010, 2011, 2012, 2013, 2014, 
                                                                                                                                                          2015, 2016           

      cpm          Censo dos Profissionais do                           CPM          Census of Teaching           Censo dos Profissionais do                 2003              
                           Magistério                                                   Professionals                     Magistério                                           

 censo_escolar           Censo Escolar                                            Census of Basic Education             Censo Escolar            1995, 1996, 1997, 1998, 1999, 
                                                                                                                                                 2000, 2001, 2002, 2003, 2004, 
                                                                                                                                                 2005, 2006, 2007, 2008, 2009, 
                                                                                                                                                 2010, 2011, 2012, 2013, 2014, 
                                                                                                                                                       2015, 2016, 2017        

     enade        Exame Nacional de Desempenho                         ENADE      Higher Education Student       Exame Nacional de Desempenho    2004, 2005, 2006, 2007, 2008, 
                         de Estudantes                                            Performance National Exam             de Estudantes            2009, 2010, 2011, 2012, 2013, 
                                                                                                                                                       2014, 2015, 2016        

     enem        Exame Nacional de Ensino Médio                        ENEM       High School National Exam     Exame Nacional de Ensino Médio   1998, 1999, 2000, 2001, 2002, 
                                                                                                                                                 2003, 2004, 2005, 2006, 2007, 
                                                                                                                                                 2008, 2009, 2010, 2011, 2012, 
                                                                                                                                                    2013, 2014, 2015, 2016     

     padae             Pesquisa de Ações                                          Survey of Discriminatory            Pesquisa de Ações                      2008              
                   Discriminatórias no Âmbito                                         Actions in School           Discriminatórias no Âmbito                                   
                            Escolar                                                                                        Escolar                                             

     pnera       Pesquisa Nacional da Educação                         PNERA    National Survey of Education    Pesquisa Nacional da Educação                2004              
                       na Reforma Agrária                                            in Agrarian Reform               na Reforma Agrária                                       

    anresc           Avaliação Nacional do          Prova Brasil      ANRESC    National Evaluation of School       Avaliação Nacional do              2007, 2009, 2011        
                       Rendimento Escolar                                                Performance                  Rendimento Escolar                                       

     aneb        Avaliação Nacional da Educação   Saeb/Prova Brasil    ANEB     National Evaluation of Basic    Avaliação Nacional da Educação   1995, 1997, 1999, 2001, 2003, 
                             Básica                                                       Education                         Básica               2005, 2007, 2009, 2011, 2013, 
                                                                                                                                                             2015              

      ana            Avaliação Nacional da                              ANA     Alphabetization National Exam       Avaliação Nacional da                 2014, 2016           
                         Alfabetização                                                                                  Alfabetização                                          

      enc           Exame Nacional de Cursos        Provão Brasil       ENC         Course National Exam           Exame Nacional de Cursos      1997, 1998, 1999, 2000, 2001, 
                                                                                                                                                          2002, 2003           

      idd         Indicador da Diferença entre                          IDD        Indicator of Difference       Indicador da Diferença entre          2014, 2015, 2016        
                   os Desempenhos Observado e                                   between Observed and Expected     os Desempenhos Observado e                                   
                            Esperado                                                    Performances                       Esperado                                            
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



That information, the ZIP archives names and URLs are scraped from [this page](http://portal.inep.gov.br/web/guest/microdados).

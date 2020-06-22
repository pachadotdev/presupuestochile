#' Presupuestos (2012-2020)
#' Contiene el valor asignado al Presupuesto de la Nacion por anio.
#' @name presupuestos
#' @docType data
#' @author Direccion de Presupuestos (DIPRES)
#' @usage presupuestos
#' @format Un tibble de 9 filas y 8 columnas
#' @references \url{http://presupuesto.bcn.cl/presupuesto/api}
#' @keywords data
NULL

#' Partidas (2012-2020)
#' Contiene el valor asignado al Presupuesto de la Nacion para cada partida, es
#' decir para el Poder Judicial, Contraloria, etc.
#' @name partidas
#' @docType data
#' @author Direccion de Presupuestos (DIPRES)
#' @usage partidas
#' @format Un tibble de 246 filas y 9 columnas
#' @references \url{http://presupuesto.bcn.cl/presupuesto/api}
#' @keywords data
#' @examples
NULL

#' Capitulos (2012-2020)
#' Contiene el valor asignado al Presupuesto de la Nacion para cada capitulo, es
#' decir para el Senado y Camara de Diputados que pertenecen al Congreso
#' Nacional, etc.
#' @name capitulos
#' @docType data
#' @author Direccion de Presupuestos (DIPRES)
#' @usage capitulos
#' @format Un tibble de 1903 filas y 17 columnas
#' @references \url{http://presupuesto.bcn.cl/presupuesto/api}
#' @keywords data
#' @examples
#' \dontrun{
#' capitulos %>%
#'     left_join(partidas %>% select(nombre_partida, id_partida)) %>%
#'     select(nombre_partida, everything())
#' }
NULL

#' Programas (2012-2020)
#' Contiene el valor asignado al Presupuesto de la Nacion para cada programa, es
#' decir para la Academia Judicial y la Corporacion Administrativa del
#' Poder Judicial, etc.
#' @name programas
#' @docType data
#' @author Direccion de Presupuestos (DIPRES)
#' @usage programas
#' @format Un tibble de 2874 filas y 17 columnas
#' @references \url{http://presupuesto.bcn.cl/presupuesto/api}
#' @keywords data
#' @examples
#' \dontrun{
#' programas %>%
#'   left_join(capitulos %>% select(id_capitulo, id_partida)) %>%
#'   left_join(partidas %>% select(nombre_partida, id_partida)) %>%
#'   select(nombre_partida, everything())
#' }
NULL

#' Subtitulos (2012-2020)
#' Contiene el valor asignado al Presupuesto de la Nacion para cada subtitulo, es
#' decir para el aporte fiscal, gastos en personal, saldo de caja de cada programa
#' del Poder Judicial, etc.
#' @name subtitulos
#' @docType data
#' @author Direccion de Presupuestos (DIPRES)
#' @usage subtitulos
#' @format Un tibble de 33852 filas y 13 columnas
#' @references \url{http://presupuesto.bcn.cl/presupuesto/api}
#' @keywords data
#' @examples
#' \dontrun{
#' subtitulos %>%
#'   left_join(programas %>% select(id_programa, id_capitulo)) %>%
#'   left_join(capitulos %>% select(id_capitulo, id_partida)) %>%
#'   left_join(partidas %>% select(nombre_partida, id_partida)) %>%
#'   select(nombre_partida, everything())
#' }
NULL

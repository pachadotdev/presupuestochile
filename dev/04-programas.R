if (!require("jsonlite")) install.packages("jsonlite")
if (!require("dplyr")) install.packages("dplyr")
if (!require("lubridate")) install.packages("lubridate")
if (!require("stringr")) install.packages("stringr")

programas <- list.files("data-programa-json", full.names = T)

programas <- purrr::map_df(
  programas,
  function(x) {
    c <- gsub("programa", "capitulo", x)
    c <- paste0(str_sub(c, 1, 27), ".json")
    dc <- fromJSON(c)
    dp <- fromJSON(x)

    d <- tibble(
      anio = as.integer(dp$anio),
      marca_temporal = dp$timestamp,
      nombre_programa = dp$nombre,
      id_capitulo = dc$id,
      id_programa = dp$id,
      numero_programa = dp$numero,
      uri_programa = dp$uri,
      valor_asignado_programa = as.numeric(dp$valorAsignado),
      variacion_anual_programa = as.numeric(dp$variacionAnual),
      mes_ultima_ejecucion_programa = dp$UltimaEjecucionGasto$Mes$id,
      mes_ultima_ejecucion_valor_vigente_programa = dp$UltimaEjecucionGasto$valorVigente,
      mes_ultima_ejecucion_valor_ejecutado_programa = dp$UltimaEjecucionGasto$valorEjecutado,
      mes_ultima_ejecucion_ingreso_programa = dp$UltimaEjecucionIngreso$Mes$id,
      mes_ultima_ejecucion_ingreso_valor_vigente_programa = dp$UltimaEjecucionIngreso$valorVigente,
      mes_ultima_ejecucion_ingreso_valor_ejecutado_programa = dp$UltimaEjecucionIngreso$valorEjecutado,
      tiene_glosas = as.logical(dp$tieneGlosas),
      cantidad_programas = length(dp$Programas)
    )

    d <- d %>% mutate(
      marca_temporal = lubridate::as_datetime(marca_temporal),
      nombre_programa = as.factor(nombre_programa),
      id_capitulo = str_pad(id_capitulo, width = 4, pad = "0"),
      id_programa = str_pad(id_programa, width = 4, pad = "0"),
      numero_programa = str_pad(numero_programa, width = 2, pad = "0"),
      mes_ultima_ejecucion_programa = str_pad(mes_ultima_ejecucion_programa, width = 2, pad = "0"),
      mes_ultima_ejecucion_ingreso_programa = str_pad(mes_ultima_ejecucion_ingreso_programa, width = 2, pad = "0")
    )
  }
)

usethis::use_data(programas, compress = "xz", overwrite = T)

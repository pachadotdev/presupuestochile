if (!require("jsonlite")) install.packages("jsonlite")
if (!require("dplyr")) install.packages("dplyr")
if (!require("lubridate")) install.packages("lubridate")
if (!require("stringr")) install.packages("stringr")

capitulos <- list.files("data-capitulo-json", full.names = T)

capitulos <- purrr::map_df(
  capitulos,
  function(x) {
    p <- gsub("capitulo", "partida", x)
    p <- paste0(str_sub(p, 1, 24), ".json")
    dp <- fromJSON(p)
    dc <- fromJSON(x)

    d <- tibble(
      anio = as.integer(dc$anio),
      marca_temporal = dc$timestamp,
      nombre_capitulo = dc$nombre,
      id_partida = dp$id,
      id_capitulo = dc$id,
      numero_capitulo = dc$numero,
      uri_capitulo = dc$uri,
      valor_asignado_capitulo = as.numeric(dc$valorAsignado),
      variacion_anual_capitulo = as.numeric(dc$variacionAnual),
      mes_ultima_ejecucion_capitulo = dc$UltimaEjecucionGasto$Mes$id,
      mes_ultima_ejecucion_valor_vigente_capitulo = dc$UltimaEjecucionGasto$valorVigente,
      mes_ultima_ejecucion_valor_ejecutado_capitulo = dc$UltimaEjecucionGasto$valorEjecutado,
      mes_ultima_ejecucion_ingreso_capitulo = dc$UltimaEjecucionIngreso$Mes$id,
      mes_ultima_ejecucion_ingreso_valor_vigente_capitulo = dc$UltimaEjecucionIngreso$valorVigente,
      mes_ultima_ejecucion_ingreso_valor_ejecutado_capitulo = dc$UltimaEjecucionIngreso$valorEjecutado,
      tiene_glosas = as.logical(dc$tieneGlosas),
      cantidad_programas = length(dc$Programas)
    )

    d %>% mutate(
      marca_temporal = lubridate::as_datetime(marca_temporal),
      nombre_capitulo = as.factor(nombre_capitulo),
      id_partida = str_pad(id_partida, width = 3, pad = "0"),
      id_capitulo = str_pad(id_capitulo, width = 4, pad = "0"),
      numero_capitulo = str_pad(numero_capitulo, width = 3, pad = "0"),
      mes_ultima_ejecucion_valor_vigente_capitulo = str_pad(mes_ultima_ejecucion_valor_vigente_capitulo, width = 3, pad = "0"),
      mes_ultima_ejecucion_ingreso_valor_vigente_capitulo = str_pad(mes_ultima_ejecucion_ingreso_valor_vigente_capitulo, width = 3, pad = "0")
    )
  }
)

usethis::use_data(capitulos, compress = "xz", overwrite = T)

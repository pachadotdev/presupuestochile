if (!require("jsonlite")) install.packages("jsonlite")
if (!require("dplyr")) install.packages("dplyr")
if (!require("lubridate")) install.packages("lubridate")
if (!require("stringr")) install.packages("stringr")

subtitulos <- list.files("data-subtitulo-json", full.names = T)

subtitulos <- purrr::map_df(
  subtitulos,
  function(x) {
    s <- gsub("subtitulo", "programa", x)
    s <- paste0(str_sub(s, 1, 29), ".json")
    ds <- fromJSON(s)
    dsu <- fromJSON(x)

    d <- tibble(
      anio = as.integer(dsu$anio),
      marca_temporal = dsu$timestamp,
      nombre_subtitulo = dsu$nombre,
      id_programa = ds$id,
      id_subtitulo = dsu$id,
      numero_subtitulo = dsu$numero,
      uri_subtitulo = dsu$uri,
      valor_asignado_subtitulo = as.numeric(dsu$valorAsignado),
      variacion_anual_subtitulo = as.numeric(dsu$variacionAnual),
      mes_ultima_ejecucion_subtitulo = dsu$UltimaEjecucion$Mes$id,
      mes_ultima_ejecucion_valor_vigente_subtitulo = dsu$UltimaEjecucion$valorVigente,
      mes_ultima_ejecucion_valor_ejecutado_subtitulo = dsu$UltimaEjecucion$valorEjecutado,
      tiene_glosas = as.logical(dsu$tieneGlosas)
    )

    d <- d %>% mutate(
      marca_temporal = lubridate::as_datetime(marca_temporal),
      nombre_subtitulo = as.factor(nombre_subtitulo),
      id_programa = str_pad(id_programa, width = 4, pad = "0"),
      id_subtitulo = str_pad(id_subtitulo, width = 5, pad = "0"),
      numero_subtitulo = str_pad(numero_subtitulo, width = 2, pad = "0"),
      mes_ultima_ejecucion_subtitulo = str_pad(mes_ultima_ejecucion_subtitulo, width = 2, pad = "0")
    )
  }
)

subtitulos <- subtitulos %>%
  mutate(
    nombre_subtitulo = as.factor(toupper(iconv(as.character(nombre_subtitulo), to = "ASCII//TRANSLIT")))
  )

usethis::use_data(subtitulos, compress = "xz", overwrite = T)

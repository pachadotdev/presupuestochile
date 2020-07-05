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
      numero_capitulo = str_pad(numero_capitulo, width = 2, pad = "0"),
      mes_ultima_ejecucion_capitulo = str_pad(mes_ultima_ejecucion_capitulo, width = 2, pad = "0"),
      mes_ultima_ejecucion_ingreso_capitulo = str_pad(mes_ultima_ejecucion_ingreso_capitulo, width = 2, pad = "0")
    )
  }
)

capitulos <- capitulos %>%
  mutate(
    nombre_capitulo = as.character(nombre_capitulo),
    nombre_capitulo = case_when(
      nombre_capitulo == "SUBSECRETARÍA DE RELACIONES ECONÓMICAS INTERNACIONALES" ~ "Subsecretaría de Relaciones Económicas Internacionales",
      nombre_capitulo == "SUBSECRETARIA DE CIENCIA, TECNOLOGÍA, CONOCIMIENTO E INNOVACIÓN" ~ "Subsecretaria de Ciencia, Tecnología, Conocimiento e Innovación",
      nombre_capitulo == "SERVICIO ELECTORAL" ~ "Servicio Electoral",
      nombre_capitulo == "INSTITUTO NACIONAL DESARROLLO SUSTENTABLE PESCA ARTESANAL Y ACUICULTURA" ~ "Instituto Nacional Desarrollo Sustentable Pesca Artesanal y Acuicultura",
      nombre_capitulo == "DIRECCIÓN GENERAL DE PROMOCIÓN DE EXPORTACIONES" ~ "Dirección General de Promoción de Exportaciones",
      nombre_capitulo == "DIRECCIÓN GENERAL DE CONCESIONES DE OBRAS PÚBLICAS" ~ "Dirección General de Promoción de Exportaciones",
      nombre_capitulo == "DIRECCIÓN GENERAL DE CONCESIONES DE OBRAS PÚBLICAS" ~ "Dirección General de Concesiones de Obras Públicas",
      nombre_capitulo == "DIRECCIÓN DE BIBLIOTECAS, ARCHIVOS Y MUSEOS" ~ "Dirección de Bibliotecas, Archivos y Museos",
      nombre_capitulo == "CONSEJO NACIONAL DE LA CULTURA Y LAS ARTES" ~ "Consejo Nacional de la Cultura y las Artes",
      TRUE ~ nombre_capitulo
    )
  )

capitulos <- capitulos %>%
  mutate(
    nombre_capitulo = as.factor(toupper(iconv(nombre_capitulo, to = "ASCII//TRANSLIT")))
  )

usethis::use_data(capitulos, compress = "xz", overwrite = T)

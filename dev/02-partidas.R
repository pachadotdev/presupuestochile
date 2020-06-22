if (!require("jsonlite")) install.packages("jsonlite")
if (!require("dplyr")) install.packages("dplyr")
if (!require("lubridate")) install.packages("lubridate")
if (!require("stringr")) install.packages("stringr")

partidas <- list.files("data-partida-json", full.names = T)

partidas <- purrr::map_df(
  partidas,
  function(x) {
    d <- fromJSON(x)

    d2 <- tibble(
      anio = as.integer(d$anio),
      marca_temporal = d$timestamp,
      nombre_partida = d$nombre,
      id_partida = d$id,
      numero_partida = d$numero,
      uri_partida = d$uri,
      valor_asignado_partida = as.numeric(d$valorAsignado),
      variacion_anual_partida = as.numeric(d$variacionAnual),
      cantidad_capitulos = length(d$Capitulos)
    )

    d2 %>% mutate(
      marca_temporal = lubridate::as_datetime(marca_temporal),
      nombre_partida = as.factor(nombre_partida),
      id_partida = str_pad(id_partida, width = 3, pad = "0"),
      numero_partida = str_pad(numero_partida, width = 2, pad = "0")
    )
  }
)

usethis::use_data(partidas, compress = "xz", overwrite = T)

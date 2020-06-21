if (!require("jsonlite")) install.packages("jsonlite")
if (!require("dplyr")) install.packages("dplyr")
if (!require("lubridate")) install.packages("lubridate")
if (!require("stringr")) install.packages("stringr")

presupuestos <- list.files("data-presupuesto-json", full.names = T)

presupuestos <- purrr::map_df(
  presupuestos,
  function(x) {
    d <- fromJSON(x)

    d2 <- tibble(
      anio = as.integer(d$anio),
      marca_temporal = d$timestamp,
      nombre_presupuesto = d$nombre,
      id_presupuesto = d$id,
      uri_presupuesto = d$uri,
      valor_asignado_presupuesto = as.numeric(d$valorAsignado),
      variacion_anual_presupuesto = as.numeric(d$variacionAnual),
      cantidad_partidas = length(d$Partidas)
    )

    d2 %>% mutate(
      marca_temporal = lubridate::as_datetime(marca_temporal),
      nombre_presupuesto = as.factor(nombre_presupuesto),
      id_presupuesto = str_pad(id_presupuesto, width = 2, pad = "0")
    )
  }
)

usethis::use_data(presupuestos, compress = "xz", overwrite = T)

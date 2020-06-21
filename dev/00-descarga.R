# options(HTTPUserAgent = sprintf("R/%s R (%s)", getRversion(), paste(getRversion(), R.version$platform, R.version$arch, R.version$os)))
# options(HTTPUserAgent = "Mozilla/5.0 (Android 4.4; Mobile; rv:41.0) Gecko/41.0 Firefox/41.0")

if (!require("jsonlite")) install.packages("jsonlite")
if (!require("readr")) install.packages("readr")
if (!require("purrr")) install.packages("purrr")

# if (!require("furrr")) install.packages("furrr")
# library(furrr)
# future::plan(multiprocess)

anios <- 2012:2020

# carpetas ----

carpeta_links <- "links-descarga"
try(dir.create(carpeta_links))

carpeta_presupuesto <- "data-presupuesto-json/"
try(dir.create(carpeta_presupuesto))

carpeta_partida <- "data-partida-json/"
try(dir.create(carpeta_partida))

carpeta_capitulo <- "data-capitulo-json/"
try(dir.create(carpeta_capitulo))

carpeta_programa <- "data-programa-json/"
try(dir.create(carpeta_programa))

carpeta_subtitulo <- "data-subtitulo-json/"
try(dir.create(carpeta_subtitulo))

# descargar presupuestos ----

urls_presupuesto <- paste0("https://www.bcn.cl/presupuesto/periodo/", anios, ".json")

archivos_presupuesto <- paste0(carpeta_presupuesto, anios, ".json")

purrr::map2(
  .x = archivos_presupuesto, .y = urls_presupuesto,
  function(x,y) { if (!file.exists(x)) try(download.file(y,x)) }
)

readr::write_csv(
  purrr::map2_df(
    .x = archivos_presupuesto, .y = urls_presupuesto,
    function(x,y) { tibble::tibble(archivo = x, url = y) }
  ),
  sprintf("%s/archivos-presupuesto.csv", carpeta_links)
)

# descargar partidas ----

links_partidas <- sprintf("%s/archivos-partida.csv", carpeta_links)

if (!file.exists(links_partidas)) {
  readr::write_csv(
    purrr::map_df(
      archivos_presupuesto,
      function(x) {
        d <- fromJSON(x)
        urls_partida <- paste0(d$Partidas, ".json")
        archivos_partida <- gsub(".*/", carpeta_partida, urls_partida)
        archivos_partida <- gsub("/", paste0("/", d$anio), archivos_partida)

        purrr::map2_df(
          .x = archivos_partida, .y = urls_partida,
          function(x,y) { tibble::tibble(archivo = x, url = y) }
        )
      }
    ),
    links_partidas
  )
}

urls_partidas <- readr::read_csv(links_partidas) %>%
  dplyr::select(url) %>%
  dplyr::pull()

purrr::map(
  archivos_presupuesto,
  function(x) {
    d <- fromJSON(x)
    urls_partida <- paste0(d$Partidas, ".json")
    archivos_partida <- gsub(".*/", carpeta_partida, urls_partida)
    archivos_partida <- gsub("/", paste0("/", d$anio), archivos_partida)

    purrr::map2(
      .x = archivos_partida, .y = urls_partida,
      function(x,y) { if (!file.exists(x)) try(download.file(y,x)) }
    )
  }
)

archivos_partida <- list.files(carpeta_partida, full.names = T)

# descargar capitulos ----

links_capitulos <- sprintf("%s/archivos-capitulo.csv", carpeta_links)

if (!file.exists(links_capitulos)) {
  readr::write_csv(
    purrr::map_df(
      archivos_partida,
      function(x) {
        d <- fromJSON(x)
        urls_capitulo <- paste0(d$Capitulos, ".json")
        archivos_capitulo <- gsub(".*/", carpeta_capitulo, urls_capitulo)
        archivos_capitulo <- gsub("/", paste0("/", d$anio, d$numero), archivos_capitulo)

        purrr::map2_df(
          .x = archivos_capitulo, .y = urls_capitulo,
          function(x,y) { tibble::tibble(archivo = x, url = y) }
        )
      }
    ),
    links_capitulos
  )
}

urls_capitulos <- readr::read_csv(links_capitulos) %>%
  dplyr::select(url) %>%
  dplyr::pull()

purrr::map(
  archivos_partida,
  function(x) {
    d <- fromJSON(x)
    urls_capitulo <- paste0(d$Capitulos, ".json")
    archivos_capitulo <- gsub(".*/", carpeta_capitulo, urls_capitulo)
    archivos_capitulo <- gsub("/", paste0("/", d$anio, d$numero), archivos_capitulo)

    purrr::map2(
      .x = archivos_capitulo, .y = urls_capitulo,
      function(x,y) { if (!file.exists(x)) try(download.file(y,x)) }
    )
  }
)

archivos_capitulo <- list.files(carpeta_capitulo, full.names = T)

# descargar programas ----

links_programas <- sprintf("%s/archivos-programa.csv", carpeta_links)

if (!file.exists(links_programas)) {
  readr::write_csv(
    purrr::map_df(
      archivos_capitulo,
      function(x) {
        d <- fromJSON(x)
        urls_programa <- paste0(d$Programas, ".json")
        if (length(d$Programas) == 0) {
          NULL
        } else {
          archivos_programa <- gsub("/partida/|/capitulo/|/programa/", "", urls_programa)
          archivos_programa <- gsub(".*/", carpeta_programa, archivos_programa)

          purrr::map2_df(
            .x = archivos_programa, .y = urls_programa,
            function(x,y) { tibble::tibble(archivo = x, url = y) }
          )
        }
      }
    ),
    links_programas
  )
}

urls_programas <- readr::read_csv(links_programas) %>%
  dplyr::select(url) %>%
  dplyr::pull()

purrr::map(
  archivos_capitulo,
  function(x) {
    d <- fromJSON(x)
    urls_programa <- paste0(d$Programas, ".json")
    if (length(d$Programas) == 0) {
      NULL
    } else {
      archivos_programa <- gsub("/partida/|/capitulo/|/programa/", "", urls_programa)
      archivos_programa <- gsub(".*/", carpeta_programa, archivos_programa)

      purrr::map2(
        .x = archivos_programa, .y = urls_programa,
        function(x,y) {
          if (!file.exists(x)) try(download.file(y,x))
        }
      )
    }
  }
)

archivos_programa <- list.files(carpeta_programa, full.names = T)

# descargar subtitulos ----

links_subtitulos <- sprintf("%s/archivos-subtitulo.csv", carpeta_links)

if (!file.exists(links_subtitulos)) {
  readr::write_csv(
    purrr::map_df(
      archivos_programa,
      function(x) {
        d <- fromJSON(x)
        urls_subtitulo <- paste0(d$Subtitulos, ".json")
        if (length(d$Subtitulos) == 0) {
          NULL
        } else {
          archivos_subtitulo <- gsub("/partida/|/capitulo/|/programa/|/subtitulo/", "", urls_subtitulo)
          archivos_subtitulo <- gsub(".*/", carpeta_subtitulo, archivos_subtitulo)

          purrr::map2_df(
            .x = archivos_subtitulo, .y = urls_subtitulo,
            function(x,y) { tibble::tibble(archivo = x, url = y) }
          )
        }
      }
    ),
    links_subtitulos
  )
}

urls_subtitulos <- readr::read_csv(links_subtitulos) %>%
  dplyr::select(url) %>%
  dplyr::pull()

purrr::map(
  archivos_programa,
  function(x) {
    d <- fromJSON(x)
    urls_subtitulo <- paste0(d$Subtitulos, ".json")
    if (length(d$Subtitulos) == 0) {
      NULL
    } else {
      archivos_subtitulo <- gsub("/partida/|/capitulo/|/subtitulo/|/programa/", "", urls_subtitulo)
      archivos_subtitulo <- gsub(".*/", carpeta_subtitulo, archivos_subtitulo)

      purrr::map2(
        .x = archivos_subtitulo, .y = urls_subtitulo,
        function(x,y) {
          if (!file.exists(x)) try(download.file(y,x))
        }
      )
    }
  }
)

archivos_subtitulo <- list.files(carpeta_subtitulo, full.names = T)

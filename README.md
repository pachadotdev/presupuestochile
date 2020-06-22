# presupuestochile

<!-- badges: start -->
[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
<!-- badges: end -->

Proporciona los datos del Presupuesto de la Nacion de Chile en formato Tidy Data.

Toma mas de 38.000 archivos JSON del sitio web de la Biblioteca del Congreso y 
los lleva a cinco tablas segun los siguiente niveles de desagregacion de menor
a mayor nivel de detalle:

* Presupuesto
* Partida
* Capitulo
* Programa
* Subtitulo

## Instalacion

Se puede instalar desde GitHub con el siguiente comando:
``` r
source("https://install-github.me/pachamaltese/presupuestochile")
```

## Fuentes

Todos los datos en bruto son generados por DIPRES y están disponibles en <http://presupuesto.bcn.cl/presupuesto/api>.

Para evitar colapsar el repositorio con más de 38.000 archivos pequenios, dejé disponibles los archivos 7z que contienen las descargar en bruto en <https://github.com/pachamaltese/presupuestochile/tree/master/data-7z>

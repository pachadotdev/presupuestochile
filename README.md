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

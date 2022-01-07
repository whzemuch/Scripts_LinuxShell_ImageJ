#!/usr/bin/env  Rscript

## install_R_pkgs.R: install R Packages
## $Rvisions$
## Copyright 2019-2020 Michael M. Hoffman 

options(repos = c(CRAN="https:/cloud.r-project.org/"))

ensure_package <- function(package, install = install.packages, spec = package) {
  if(!suppressWarnings(requireNamespace(package, quietly = TRUE))){
    install(spec)
  }
}


main <- function() {
  ensure_package("devtools")
  ensure_package("lintr")
  ensure_package("dplyr")
  ensure_package("forcats")
  ensure_package("ggplot2")
  ensure_package("httpuv")


library(devtools, quietly = TRUE)

ensure_package("strict", devtools::install_github, "hadley/strict")
ensure_package("googlesheets4", devtools::install_github, "tidyverse/googlesheets4")

}
  

#!/usr/bin/env Rscript
args = commandArgs(trailingOnly = TRUE)
lang <- args[1]
cat("LANG --->", lang, "\n")

source("helpers.R")

tpl <- switch(lang, 
  en = "template_main_en.Rmd",
  stop("not available")
  )
template <- readLines(tpl)
# NB by default whisker forward the parent envi and I used this

writeLines(
  whisker::whisker.render(template, list(title = "KevCaz's CV")), 
  "cv_en.Rmd"
)
out <- rmarkdown::render("cv_en.Rmd")
pagedown::chrome_print(out)

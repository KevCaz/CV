#!/usr/bin/env Rscript

# handling external arguments
args <- commandArgs(trailingOnly = TRUE)
lang <- args[1]
cat("LANG --->", lang, "\n")
type <- ifelse(is.na(args[2]), "main", args[2])
type <- switch(type,
  main = "main",
  spec = "spec",
  short = "short",
  stop("not available")
)
cat("TYPE --->", type, "\n")

# load packages and functions
source("helpers.R")

# chose template
tpl <- switch(lang,
  en = glue("template_{type}_en.Rmd"),
  fr = glue("template_{type}_fr.Rmd"),
  stop("not available")
)
tit <- switch(lang,
  en = "CV Kevin Cazelles",
  fr = "CV de Kevin Cazelles",
  stop("not available")
)
template <- readLines(tpl)
# NB by default whisker forward the parent envi and I used this

rmd_cv <- glue("cv_{type}_{lang}.Rmd")

writeLines(
  whisker::whisker.render(template, list(title = tit)),
  rmd_cv
)
html <- file_move(rmarkdown::render(rmd_cv), "../docs/")
pdf <- pagedown::chrome_print(html)
end <- file.remove(rmd_cv)

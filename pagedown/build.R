library(whisker)
library(yaml)
library(pagedown)


template <- readLines("template_cv_en.Rmd")
# NB by default whisker forward the parent envi and I used this


writeLines(whisker::whisker.render(template, list(title = "cool")), "cv_en.Rmd")
out <- rmarkdown::render("cv_en.Rmd")
if (pdf) {
  # NB pagedown can do html + pdf but I need html path
  msgInfo("generating PDF file")
  pagedown::chrome_print(out, ...)
}
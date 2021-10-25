source("helpers.R")

template <- readLines("template_cv_en.Rmd")
# NB by default whisker forward the parent envi and I used this


writeLines(
  whisker::whisker.render(template, list(title = "KevCaz's CV")), 
  "cv_en.Rmd"
)
out <- rmarkdown::render("cv_en.Rmd")
pagedown::chrome_print(out)

# Packages
library(whisker)
library(yaml)
library(glue)
library(pagedown)
library(icons)
library(kableExtra)
library(htmltools)


rfa <- function(...) fontawesome(...)


glue_href <- function(val, url) {
  glue("<a href='{ url }'>{ val }</a>")
}

# Functions 
glue_details <- function(name, icon, value, url = NULL) {
  
  ic <- rfa(icon)
  
  if (!is.null(url)) {
    nm <- glue_href(value, url)
  } else nm <- value
  HTML(glue("<li>{ ic } { nm }</li>"))
}


insert_perso_details <- function() {
  val <- lapply(
    yaml.load_file("data/perso_details.yaml"), 
    function(x) do.call(glue_details, x)
  )
  
  
  txt <- paste0("<ul>")
  for (i in seq_along(val)) {
    txt <- paste0(txt, val[[i]])
  }
  txt <- paste0(txt, "<ul/>")
  
  cat(HTML(txt))
}


glue_pubs <- function(title) {
  glue("<li>", title, "</li>")
}

glue_authors <- function(names) {
  glue_collapse(lapply(names, function(x) x$family), sep = ", ", last = " & ")
}

insert_pubs <- function() {
  pubs <- yaml.load_file("data/pubs.yaml")[[1]]
  
  # cat(HTML("<ol>"))
  for (i in seq_along(pubs)) {
    auth <- glue_authors(pubs[[i]]$author) 
    year <- substr(pubs[[i]]$issued, 1, 4)
    title <- pubs[[i]]$title
    conta <- pubs[[i]]$'container-title'
    if (is.null(conta)) conta <- "prepint"
    doi <- pubs[[i]]$doi
    cat(glue("{i}. {auth} ({year}). {title}. *{conta}*. [{doi}]({doi}).\n\n"))
    # cat(HTML(
    #   "<li>", 
    #   paste0("(", substr(pubs[[i]]$issued, 1, 4), "). "),
    #   pubs[[i]]$title, 
    #   pubs[[i]]$"container-title",
    #   pubs[[i]]$doi,
    #   "</li>")
    # )
  }
  # cat(HTML("</ol>"))
}





template <- readLines("template_cv_en.Rmd")
# NB by default whisker forward the parent envi and I used this


writeLines(
  whisker::whisker.render(template, list(title = "Kevin Cazelles's CC")), 
  "cv_en.Rmd"
)
out <- rmarkdown::render("cv_en.Rmd")
pagedown::chrome_print(out)

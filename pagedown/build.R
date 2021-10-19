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
  glue("<a href='{url}'>{val}</a>")
}

glue_href_md <- function(name, url) {
  glue("[{name}]({url})")
}


initials <- function(x) {
  paste0(toupper(substr(x, 1, 1)), ".")
}

first_let <- function(given) {
  glue_collapse(
    unlist(lapply(strsplit(given, " "), function(x) initial(x))), 
    " "
  )
}

author_focus <- function(x, focus) {
  for (i in seq_along(x)) {
    if (x[i] == focus) x[i] <- glue("**{ x[i] }**")
  }
  x
}





# Functions 
glue_details <- function(name, icon, value, url = NULL) {
  
  ic <- rfa(icon)
  
  if (!is.null(url)) {
    nm <- glue_href(value, url)
  } else nm <- value
  # HTML(glue("<li>{ ic } { nm }</li>"))
  cat(glue("* { ic } { nm }\n\n"))
}


insert_perso_details <- function() {
  val <- lapply(
    yaml.load_file("data/perso_details.yaml"), 
    function(x) do.call(glue_details, x)
  )
}


glue_pubs <- function(title) {
  glue("<li>", title, "</li>")
}


glue_authors <- function(names, focus = "Cazelles K.") {
  giv <- lapply(names, function(x) initials(x$given))
  fam <- lapply(names, function(x) x$family)
  nm <- author_focus(paste(fam, giv), focus)
  glue_collapse(nm, sep = ", ", last = " & ")
}

insert_pubs <- function() {
  pubs <- yaml.load_file("data/pubs.yaml")[[1]]
  # cat(HTML("<ol>"))
  for (i in seq_along(pubs)) {
    auth <- glue_authors(pubs[[i]]$author) 
    year <- substr(pubs[[i]]$issued, 1, 4)
    title <- pubs[[i]]$title
    conta <- pubs[[i]]$'container-title'
    if (is.null(conta)) conta <- "Preprint"
    doi <- pubs[[i]]$doi
    cat(glue("{i}. {auth} ({year}). {title}. *{conta}*. [{doi}]({doi}).\n\n"))
  }
}



insert_education <- function() {
  edu <- yaml.load_file("data/education_en.yaml")
  for (i in seq_along(edu)) {
    tmp <- edu[[i]]
    cat(glue("* {tmp$years}:  **{tmp$honour}**.  {tmp$institute}.\n\n"))
  }
} 


insert_reviewer <- function() {
  rev <- yaml.load_file("data/reviewer.yaml")
  out <- glue_collapse(
    lapply(rev, function(x) do.call(glue_href_md, x)), 
    sep = ", ", 
    last = " and "
  )
  glue("As an academic, I have been actively involved in the peer-review process and I have been a reviewer for the following journals: ", out, "I have also been a 'recommender' for [PCI Ecology](https://ecology.peercommunityin.org/) since 2019.")
}


insert_media <- function() {
  med <- yaml.load_file("data/media.yaml")
  for (i in seq_along(med)) {
    tmp <- med[[i]]
    cat(glue("* {rfa(tmp$icon)}: {glue_href_md(tmp$title, tmp$url)} -- {tmp$media} ({tmp$year}, {tmp$lang}).\n\n"))
  }
}




template <- readLines("template_cv_en.Rmd")
# NB by default whisker forward the parent envi and I used this


writeLines(
  whisker::whisker.render(template, list(title = "KevCaz's CV")), 
  "cv_en.Rmd"
)
out <- rmarkdown::render("cv_en.Rmd")
pagedown::chrome_print(out)

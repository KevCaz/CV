# Packages
library(whisker)
library(yaml)
library(glue)
library(pagedown)
library(icons)
library(kableExtra)
library(htmltools)


rfa <- function(...) fontawesome(...)

base_gh <- "https://github.com/"
base_perso <- "https://kevcaz.github.io"
base_doi <- "https://doi.org/"

glue_href <- function(val, url) {
  glue("<a href='{url}'>{val}</a>")
}

glue_href_md <- function(name, url) {
  glue("[{name}]({url})")
}

glue_gh <- function(x) {
  if (!is.null(x)) {
    out <- glue_href_md(rfa("github"), glue("{base_gh}{x}"))
  } else ""
}

glue_html <- function(x) {
  if (!is.null(x)) {
    out <- glue_href_md(rfa("html5"), x)
  } else ""
}

glue_pdf <- function(x) {
  if (!is.null(x)) {
    out <- glue_href_md(rfa("file-pdf"), glue("{base_perso}{x}"))
  } else ""
}

glue_doi <- function(x) {
  if (!is.null(x)) {
    out <- glue_href_md(x, glue("{base_doi}{x}"))
  } else ""
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
    if (x[i] == focus) x[i] <- glue("**{x[i]}**")
  }
  x
}

glue_details <- function(name, icon, value, url = NULL) {
  
  ic <- rfa(icon)
  
  if (!is.null(url)) {
    nm <- glue_href(value, url)
  } else nm <- value
  # HTML(glue("<li>{ ic } { nm }</li>"))
  cat(glue("* { ic } { nm }\n\n"))
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




insert_perso_details <- function() {
  val <- lapply(
    yaml.load_file("data/perso_details.yaml"), 
    function(x) do.call(glue_details, x)
  )
}

insert_education <- function() {
  edu <- yaml.load_file("data/education_en.yaml")
  for (i in seq_along(edu)) {
    tmp <- edu[[i]]
    cat(glue("* {tmp$years}:  **{tmp$honour}**.  {tmp$institute}.\n\n"))
  }
} 

insert_xp <- function() {
  tmp <- yaml.load_file("data/prof_xp.yaml")
  for (i in seq_along(tmp)) {
    cat(glue("#### &nbsp;&nbsp;{tmp[[i]]$date}: **{tmp[[i]]$role}** \n\n <h5>&nbsp;&nbsp;{rfa('map-marker-alt')} {tmp[[i]]$where}</h5> \n\n"))
    
    cat("<ul style='margin-top: 0.05in;'>")
    for (j in seq_along(tmp[[i]]$did)) {
      cat(glue("<li style='font-size: 0.9em;'> {tmp[[i]]$did[j]}.</li>\n"))
    }
    cat("</ul>\n\n")

  }
}

insert_teach <- function() {
  tmp <- yaml.load_file("data/teaching.yaml")
  for (i in seq_along(tmp)) {
    out <- glue("- **{tmp[[i]]$year}**: _{tmp[[i]]$description}_ {tmp[[i]]$where}, {tmp[[i]]$duration}.")
    
    gh <- glue_gh(tmp[[i]]$github)
    ht <- glue_html(tmp[[i]]$html)
    pd <- glue_pdf(tmp[[i]]$pdf)
    
    cat(glue(out, gh, ht, pd, "\n\n", .sep = " "))
  }
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
    cat(glue("{i}. {auth} ({year}). {title}. *{conta}*. doi: [{doi}]({base_doi}{doi}).\n\n"))
  }
}


insert_popu <- function() {
  tmp <- yaml.load_file("data/popularization.yaml")
  for (i in seq_along(tmp)) {
    auth <- glue_authors(tmp[[i]]$author) 
    year <- tmp[[i]]$year
    title <- tmp[[i]]$title
    conta <- tmp[[i]]$'container-title'
    cat(glue("{i}. {auth} ({year}). {title}. *{conta}*. [{rfa('link')}]({tmp[[i]]$url})\n\n"))
  }
}


insert_soft <- function() {
  tmp <- yaml.load_file("data/package.yaml")
  for (i in seq_along(tmp)) {
    out <- glue("* **{tmp[[i]]$name}** ({tmp[[i]]$role}): {tmp[[i]]$desc}.")
    
    gh <- glue_gh(tmp[[i]]$github)
    ht <- glue_html(tmp[[i]]$url)

    cat(glue(out, gh, ht, "\n\n", .sep = " "))
  }
}

insert_grants <- function() {
  tmp <- yaml.load_file("data/grants.yaml")
  for (i in seq_along(tmp)) {
    cat(glue("* **{tmp[[i]]$year}**, {tmp[[i]]$amount}. ({tmp[[i]]$title}). \n\n"))
  }
}


insert_compendia <- function() {
  tmp <- yaml.load_file("data/compendia.yaml")
  for (i in seq_along(tmp)) {
    out <- glue("* **{tmp[[i]]$name}**: {tmp[[i]]$desc} (paper's doi: {glue_doi(tmp[[i]]$doi_paper)}).")
    
    gh <- glue_gh(tmp[[i]]$github)
    ht <- glue_html(tmp[[i]]$url)
    do <- glue_doi(tmp[[i]]$doi)

    cat(glue(out, gh, ht, do, "\n\n", .sep = " "))
  }
}

insert_man <- function() {
  tmp <- yaml.load_file("data/manuals.yaml")
  for (i in seq_along(tmp)) {
    out <- glue("* {glue_authors(tmp[[i]]$author)} {tmp[[i]]$title} ({tmp[[i]]$year}) ")
    
    gh <- glue_gh(tmp[[i]]$github)
    ht <- glue_html(tmp[[i]]$url)
    do <- glue_doi(tmp[[i]]$doi)

    cat(glue(out, gh, ht, do, "\n\n", .sep = " "))
  }
}


insert_talks <- function() {
  tmp <- yaml.load_file("data/talks.yaml")
  for (i in seq_along(tmp)) {
    auth <- glue_authors(tmp[[i]]$author) 
    title <- tmp[[i]]$title
    conf <- tmp[[i]]$conference[[1]]
    
    out <- glue("{i}. {auth}. {title}. [{conf$name}]({conf$url}). {conf$where} ({conf$date}).")
    
    gh <- glue_gh(tmp[[i]]$github)
    ht <- glue_html(tmp[[i]]$html)
    pd <- glue_pdf(tmp[[i]]$pdf)
    
    cat(glue(out, gh, ht, pd, "\n\n", .sep = " "))
  }
}

insert_sems <- function() {
  tmp <- yaml.load_file("data/seminars.yaml")
  for (i in seq_along(tmp)) {
    auth <- glue_authors(tmp[[i]]$author) 
    
    out <- glue("{i}. {auth}. {tmp[[i]]$title}. [{tmp[[i]]$where}]({tmp[[i]]$url}). {tmp[[i]]$where} ({tmp[[i]]$date}).")
    
    gh <- glue_gh(tmp[[i]]$github)
    ht <- glue_html(tmp[[i]]$html)
    pd <- glue_pdf(tmp[[i]]$pdf)
    
    cat(glue(out, gh, ht, pd, "\n\n", .sep = " "))
  }
}

insert_skills <- function(what = "sci_pro") {
  tmp <- yaml.load_file("data/skills.yaml")
  id <- which(unlist(lapply(tmp, function(x) x$name)) == what)
  sk <- tmp[[id]]$skills
  for (i in seq_along(sk)) {
    out <- glue_collapse(
      c(rep("&#9632;", sk[[i]]$lvl), rep("&#9633;", 5 - sk[[i]]$lvl)), 
      sep = " ")
    
    cat(glue("*", out, sk[[i]]$name, "\n\n", .sep = " "))
  }
  
}

insert_posters <- function() {
  tmp <- yaml.load_file("data/posters.yaml")
  for (i in seq_along(tmp)) {
    auth <- glue_authors(tmp[[i]]$author) 
    title <- tmp[[i]]$title
    conf <- tmp[[i]]$conference[[1]]
    
    out <- glue("{i}. {auth}. {title}. [{conf$name}]({conf$url}). {conf$where} ({conf$date}).")
    
    gh <- glue_gh(tmp[[i]]$github)
    ht <- glue_html(tmp[[i]]$html)
    pd <- glue_pdf(tmp[[i]]$pdf)
    
    cat(glue(out, gh, ht, pd, "\n\n", .sep = " "))
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

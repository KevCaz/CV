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

insert_perso_details <- function(file = "data/en/perso_details.yaml") {
  val <- lapply(
    yaml.load_file(file), 
    function(x) do.call(glue_details, x)
  )
}

insert_education <- function(file = "data/en/education_en.yaml") {
  tmp <- yaml.load_file(file)
  for (i in seq_along(tmp)) {
    cat(glue("* {tmp[[i]]$years}:  **{tmp[[i]]$honour}**.  {tmp[[i]]$institute}.\n\n"))
  }
} 

insert_xp <- function(file = "data/en/prof_xp.yaml") {
  tmp <- yaml.load_file(file)
  for (i in seq_along(tmp)) {
    cat(glue("#### &nbsp;&nbsp;{tmp[[i]]$date}: **{tmp[[i]]$role}** \n\n <h5>&nbsp;&nbsp;{rfa('map-marker-alt')} {tmp[[i]]$where}</h5> \n\n"))
    
    cat("<ul style='margin-top: 0.05in;'>")
    for (j in seq_along(tmp[[i]]$did)) {
      cat(glue("<li style='font-size: 0.9em;'> {tmp[[i]]$did[j]}.</li>\n"))
    }
    cat("</ul>\n\n")

  }
}

insert_teach <- function(file = "data/en/teaching.yaml") {
  tmp <- yaml.load_file(file)
  for (i in seq_along(tmp)) {
    out <- glue("- **{tmp[[i]]$year}**: _{tmp[[i]]$description}_ {tmp[[i]]$where}, {tmp[[i]]$duration}.")
    
    gh <- glue_gh(tmp[[i]]$github)
    ht <- glue_html(tmp[[i]]$html)
    pd <- glue_pdf(tmp[[i]]$pdf)
    
    cat(glue(out, gh, ht, pd, "\n\n", .sep = " "))
  }
}

insert_mentor <- function(file = "data/en/mentor.yaml") {
  tmp <- yaml.load_file(file)
  for (i in seq_along(tmp)) {
    cat(glue("* {tmp[[i]]$name}, {tmp[[i]]$lvl} ({tmp[[i]]$year}). {tmp[[i]]$did}.\n\n"))
  }
}


insert_pubs <- function(file = "data/en/pubs.yaml") {
  pubs <- yaml.load_file(file)[[1]]
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


insert_popu <- function(file = "data/en/popularization.yaml") {
  tmp <- yaml.load_file(file)
  for (i in seq_along(tmp)) {
    auth <- glue_authors(tmp[[i]]$author) 
    year <- tmp[[i]]$year
    title <- tmp[[i]]$title
    conta <- tmp[[i]]$'container-title'
    cat(glue("{i}. {auth} ({year}). {title}. *{conta}*. [{rfa('link')}]({tmp[[i]]$url})\n\n"))
  }
}


insert_soft <- function(file = "data/en/package.yaml") {
  tmp <- yaml.load_file(file)
  for (i in seq_along(tmp)) {
    out <- glue("* **{tmp[[i]]$name}** ({tmp[[i]]$role}): {tmp[[i]]$desc}.")
    
    gh <- glue_gh(tmp[[i]]$github)
    ht <- glue_html(tmp[[i]]$url)

    cat(glue(out, gh, ht, "\n\n", .sep = " "))
  }
}

insert_grants <- function(file = "data/en/grants.yaml") {
  tmp <- yaml.load_file(file)
  for (i in seq_along(tmp)) {
    cat(glue("* **{tmp[[i]]$year}**, {tmp[[i]]$amount}. ({tmp[[i]]$title}). \n\n"))
  }
}


insert_compendia <- function(file = "data/en/compendia.yaml") {
  tmp <- yaml.load_file(file)
  for (i in seq_along(tmp)) {
    out <- glue("* **{tmp[[i]]$name}**: {tmp[[i]]$desc} (paper's doi: {glue_doi(tmp[[i]]$doi_paper)}).")
    
    gh <- glue_gh(tmp[[i]]$github)
    ht <- glue_html(tmp[[i]]$url)
    do <- glue_doi(tmp[[i]]$doi)

    cat(glue(out, gh, ht, do, "\n\n", .sep = " "))
  }
}

insert_man <- function(file = "data/en/manuals.yaml") {
  tmp <- yaml.load_file(file)
  for (i in seq_along(tmp)) {
    out <- glue("* {glue_authors(tmp[[i]]$author)} {tmp[[i]]$title} ({tmp[[i]]$year}) ")
    
    gh <- glue_gh(tmp[[i]]$github)
    ht <- glue_html(tmp[[i]]$url)
    do <- glue_doi(tmp[[i]]$doi)

    cat(glue(out, gh, ht, do, "\n\n", .sep = " "))
  }
}


insert_talks <- function(file = "data/en/talks.yaml") {
  tmp <- yaml.load_file(file)
  for (i in seq_along(tmp)) {
    auth <- glue_authors(tmp[[i]]$author) 
    title <- tmp[[i]]$title
    conf <- tmp[[i]]$conference[[1]]
    
    out <- glue("{i}. {auth} ({conf$date}). {title}. [{conf$name}]({conf$url}). {conf$where}.")
    
    gh <- glue_gh(tmp[[i]]$github)
    ht <- glue_html(tmp[[i]]$html)
    pd <- glue_pdf(tmp[[i]]$pdf)
    
    cat(glue(out, gh, ht, pd, "\n\n", .sep = " "))
  }
}

insert_sems <- function(file = "data/en/seminars.yaml") {
  tmp <- yaml.load_file(file)
  for (i in seq_along(tmp)) {
    auth <- glue_authors(tmp[[i]]$author) 
    
    out <- glue("{i}. {auth} ({tmp[[i]]$date}). {tmp[[i]]$title}. [{tmp[[i]]$where}]({tmp[[i]]$url}). {tmp[[i]]$where}.")
    
    gh <- glue_gh(tmp[[i]]$github)
    ht <- glue_html(tmp[[i]]$html)
    pd <- glue_pdf(tmp[[i]]$pdf)
    
    cat(glue(out, gh, ht, pd, "\n\n", .sep = " "))
  }
}

insert_skills <- function(file = "data/en/skills.yaml",  what = "sci_pro") {
  tmp <- yaml.load_file(file)
  id <- which(unlist(lapply(tmp, function(x) x$name)) == what)
  sk <- tmp[[id]]$skills
  for (i in seq_along(sk)) {
    out <- glue_collapse(
      c(rep("&#9632;", sk[[i]]$lvl), rep("&#9633;", 5 - sk[[i]]$lvl)), 
      sep = " ")
    
    cat(glue("*", out, sk[[i]]$name, "\n\n", .sep = " "))
  }
  
}

insert_posters <- function(file = "data/en/posters.yaml") {
  tmp <- yaml.load_file(file)
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



insert_reviewer <- function(file = "data/en/reviewer.yaml") {
  rev <- yaml.load_file(file)
  out <- glue_collapse(
    lapply(rev, function(x) do.call(glue_href_md, x)), 
    sep = ", ", 
    last = " and "
  )
  glue("As an academic, I have been actively involved in the peer-review process and I have been a reviewer for the following journals: ", out, " I have also been a 'recommender' for [PCI Ecology](https://ecology.peercommunityin.org/) since 2019.")
}


insert_media <- function(file = "data/en/media.yaml") {
  med <- yaml.load_file(file)
  for (i in seq_along(med)) {
    tmp <- med[[i]]
    cat(glue("* {rfa(tmp$icon)}: {glue_href_md(tmp$title, tmp$url)} -- {tmp$media} ({tmp$year}, {tmp$lang}).\n\n"))
  }
}




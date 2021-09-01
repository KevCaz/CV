# CV

This is the repository where I share the source code I've been using to create my CV. 


## XeTeX

This older version, available in folder `xetex` was created with [XeTeX](https://en.wikipedia.org/wiki/XeTeX). For this version, was strongly inspired by what
[SteveViss](https://github.com/SteveViss) did (see these
[files](https://github.com/SteveViss/steveviss.github.com/tree/dev/public/_cv)
from the sources of his website).

Note that I use Font Awesome's icons in my CV (to improve the visual grepping!)
via the [fontawesome5 Latex :package:](https://www.ctan.org/pkg/fontawesome5).
For the records, I previously used the
[fontawesome-latex](https://github.com/xdanaux/fontawesome-latex) :package:.



## pagedown

:construction:

This version uses the R package [`pagedown`](https://CRAN.R-project.org/package=pagedown).


### Installation

The following R packages are required

```R
install.package(c("pagedown", "whisker", "kableExtra"))
remotes::install_github("mitchelloharawild/icons")
```
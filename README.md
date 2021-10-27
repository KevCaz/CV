# CV

This is the repository where I share the source code I've been using to create my CV. 

## pagedown

### Installation

The following R packages are required

```R
install.package(
  c("fs", "glue", "htmltools", "pagedown", "whisker", "yaml")
)
remotes::install_github("mitchelloharawild/icons")
```

CV will be added to the`/docs/` folder. 


### Building CV 

On UNIX systems, using GNU make 

```sh
cd pagedown
# EN CV 
make build
# FR CV
make build lang='fr'
# FR CV spec 
make build lang='fr' type='spec'
```

## XeTeX

:warning: This CV will no longer be updated. 

This older version, available in folder `xetex` was created with [XeTeX](https://en.wikipedia.org/wiki/XeTeX). For this version, was strongly inspired by what
[SteveViss](https://github.com/SteveViss) did (see these
[files](https://github.com/SteveViss/steveviss.github.com/tree/dev/public/_cv)
from the sources of his website).

Note that I use Font Awesome's icons in my CV (to improve the visual grepping!)
via the [fontawesome5 Latex :package:](https://www.ctan.org/pkg/fontawesome5).
For the records, I previously used the
[fontawesome-latex](https://github.com/xdanaux/fontawesome-latex) :package:.




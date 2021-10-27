lang=en
type=main

bib2yaml: 
	pandoc data/$(lang)/works.bib -s -f biblatex -t markdown > data/$(lang)/pubs.yaml
	
build:
	Rscript build.R "$(lang)"	"$(type)"
	
open:
	firefox ../docs/cv_$(type)_$(lang).html
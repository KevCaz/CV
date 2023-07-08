lang=en
type=main
works = 'data/$(lang)/works.bib'

all: getPubs bib2yaml build open

getPubs: 
	Rscript -e "mypubs(filename = $(works))"
	sed -i "s/{\\\&}amp\\$$\\\mathsemicolon\\$$/\&/g" $(works)
	sed -i "s/\\$$\\\less\\$$\\i\\$$\\\greater\\$$/ /g" $(works)
	sed -i "s/\\$$\\\less\\$$\\/i\\$$\\\greater\\$$/ /g" $(works)

bib2yaml: 
	pandoc $(works) -s -f biblatex -t markdown > data/$(lang)/pubs.yaml
	
build:
	Rscript build.R "$(lang)" "$(type)"
	
open:
	firefox ../docs/cv_$(type)_$(lang).html

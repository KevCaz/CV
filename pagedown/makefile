lang=en

bib2yaml: 
	pandoc data/$(lang)/works.bib -s -f biblatex -t markdown > data/$(lang)/pubs.yaml
	
build:
	Rscript build.R "$(lang)"
	mv cv_en* ../docs/
	
	
open:
	firefox ../docs/cv_en.html
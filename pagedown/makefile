bib2yaml: 
	pandoc works.bib -s -f biblatex -t markdown > pubs.yaml
	
build:
	Rscript build.R
	mv cv_en* final/
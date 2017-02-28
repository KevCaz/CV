srcf = template.tex details_fr.yml publi.yml
srce = template.tex details_eng.yml publi.yml
FLAGS = --latex-engine=xelatex
pdfe = CV_KevCaz_eng.pdf
pdff = CV_KevCaz_fr.pdf


all: publi.yml $(pdfe) $(pdff)

$(pdfe) : $(srce) publi.yml
	pandoc $(filter-out $<,$^ ) -o $@ --template=$< $(FLAGS)

$(pdff) : $(srcf) publi.yml
	pandoc $(filter-out $<,$^ ) -o $@ --template=$< $(FLAGS)

publi.yml: publi.bib
	pandoc-citeproc -y $< $ > $@


.PHONY: all
clean :
	rm $(pdfe) $(pdff)

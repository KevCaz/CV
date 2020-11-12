srcf = template.tex details_fr.yml
srce = template.tex details_eng.yml
srcd = details.yml pubs.yml data/*.yml
FLAGS = --pdf-engine=xelatex
pdfe = CV_KevCaz_eng.pdf
pdff = CV_KevCaz_fr.pdf
pathws = $(HOME)/Projects/websites/KevCaz.github.io

all: pubs.yml $(pdfe) $(pdff)

$(pdfe) : $(srce) $(srcd)
	pandoc $(filter-out $<,$^ ) -o $@ --template=$< $(FLAGS)

$(pdff) : $(srcf) $(srcd)
	pandoc $(filter-out $<,$^ ) -o $@ --template=$< $(FLAGS)

pubs.yml: pubs.bib
	pandoc-citeproc -y $< $ > $@
# getpubs:
pubs.bib:
	Rscript -e "mypubs()"

towebsite:
	cp pubs.yml pubs.yaml
	sed -i 's/container-title/container/g' pubs.yaml
	mv pubs.yaml $(pathws)/data/pubs.yaml
	cp data/media.yml $(pathws)/data/press.yaml
	cp data/posters.yml $(pathws)/data/posters.yaml
	cp data/talks.yml $(pathws)/data/talks.yaml
	cp data/seminars.yml $(pathws)/data/seminars.yaml
	cp *.pdf $(pathws)/static/docs/cv

clean :
	rm $(pdfe) $(pdff) pubs.bib

srcf = template.tex details_fr.yml details.yml pubs.yml
srce = template.tex details_eng.yml details.yml pubs.yml
FLAGS = --pdf-engine=xelatex
pdfe = CV_KevCaz_eng.pdf
pdff = CV_KevCaz_fr.pdf
pathws = $(HOME)/Github/Websites/KevCaz.github.io/


all: pubs.yml $(pdfe) $(pdff)

$(pdfe) : $(srce) pubs.yml
	pandoc $(filter-out $<,$^ ) -o $@ --template=$< $(FLAGS)

$(pdff) : $(srcf) pubs.yml
	pandoc $(filter-out $<,$^ ) -o $@ --template=$< $(FLAGS)

pubs.yml: pubs.bib
	pandoc-citeproc -y $< $ > $@
# getpubs:
pubs.bib:
	Rscript -e "mypubs()"


towebsite:
	zip CV_KevCaz_eng.zip CV_KevCaz_eng.pdf
	zip CV_KevCaz_fr.zip CV_KevCaz_fr.pdf
	cp pubs.yml pubs.yaml
	sed -i 's/container-title/container/g' pubs.yaml
	mv pubs.yaml $(pathws)/data/pubs.yaml
	cp *.pdf $(pathws)/static/docs/cv
	cp *.zip $(pathws)/static/docs/cv
	rm *.zip

clean :
	rm $(pdfe) $(pdff)

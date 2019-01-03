srcf = template.tex details_fr.yml details.yml publi.yml
srce = template.tex details_eng.yml details.yml publi.yml
FLAGS = --pdf-engine=xelatex
pdfe = CV_KevCaz_eng.pdf
pdff = CV_KevCaz_fr.pdf


all: publi.yml $(pdfe) $(pdff)

$(pdfe) : $(srce) publi.yml
	pandoc $(filter-out $<,$^ ) -o $@ --template=$< $(FLAGS)

$(pdff) : $(srcf) publi.yml
	pandoc $(filter-out $<,$^ ) -o $@ --template=$< $(FLAGS)

publi.yml: publi.bib
	pandoc-citeproc -y $< $ > $@

# getpubli:

towebsite:
	zip CV_KevCaz_eng.zip CV_KevCaz_eng.pdf
	zip CV_KevCaz_fr.zip CV_KevCaz_fr.pdf
	cp publi.yml publi.yaml
	sed -i 's/container-title/container/g' publi.yaml
	mv publi.yaml ~/Github/Websites/kevcaz.github.io/data/publi.yaml
	cp *.pdf ~/Github/Websites/kevcaz.github.io/static/docs/cv
	cp *.zip ~/Github/Websites/kevcaz.github.io/static/docs/cv
	rm *.zip

clean :
	rm $(pdfe) $(pdff)

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


towebsite:
	zip CV_KevCaz_eng.zip CV_KevCaz_eng.pdf
	zip CV_KevCaz_fr.zip CV_KevCaz_fr.pdf
	cp *.pdf ~/Sites/kevcazHugoWebsite/static/pdf
	cp *.zip ~/Sites/kevcazHugoWebsite/static/zip
	rm *.zip

clean :
	rm $(pdfe) $(pdff)

HOST := cmta
DIR := /var/www/maslinsky/courses/eu2022
lectures := $(wildcard slides/*.tex)
slides := $(lectures:.tex=.pdf)
scripts := $(shell git ls-files scripts/*.Rmd)
reader := 
labs := 
data := $(wildcard data/ru_stateduma/*.csv) data/detcorpus-freqlist.csv $(wildcard data/ru_stateduma/*.txt)
SERVER := rstudio
SERVERDIR := /var/lib/rstudio-server/data/eu2022


.ONESHELL:
%.pdf: %.tex
	cd $(@D)
	xelatex $(notdir $<)
	xelatex $(notdir $<)


publish: $(slides) $(scripts) $(labs)
	scp $(slides) $(HOST):$(DIR)/slides
	scp $(scripts) $(HOST):$(DIR)/scripts
	scp $(patsubst %,reader/%,$(reader)) $(HOST):$(DIR)/reader
	scp $(labs) $(HOST):$(DIR)/

upload: $(scripts)
	rsync -avP --stats -e ssh $(scripts) $(SERVER):$(SERVERDIR)/scripts/
	rsync -avP --stats -e ssh $(data) $(SERVER):$(SERVERDIR)/data/
	ssh $(SERVER) chown -R rstudio:eu2022 $(SERVERDIR) 

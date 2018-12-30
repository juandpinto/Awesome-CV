FILES = cv coverletter
PERSON ?=

$(if ${PERSON}, $(eval SUFFIX = -${PERSON}))

# Define HOST in order to run Makefile on host machine, otherwise it will run through docker image
# make #=> run pandoc through docker
# HOST=1 make #=> run pandoc on local machine
ifndef HOST
	# If you'd like to use pandoc with docker (idea taken from https://github.com/ntfc/Awesome-CV)
	RUN = docker run -ti --rm -e PUID=`id -u` -e PGID=`id -g` -v $(shell pwd):/source silviof/docker-pandoc:latest
else
	RUN = pandoc
endif

$(FILES):
	mkdir -p results/
	$(RUN) data/details${SUFFIX}.yml data/$@${SUFFIX}.yml -o results/$@${SUFFIX}.pdf --template=$@.tex --standalone --pdf-engine=xelatex

.PHONY: $(FILES) clean

clean:
	rm *.aux *.log *.out

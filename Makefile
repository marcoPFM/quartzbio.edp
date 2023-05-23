PKG_VERSION=$(shell grep -i ^version DESCRIPTION | cut -d : -d \  -f 2)
PKG_NAME=$(shell grep -i ^package DESCRIPTION | cut -d : -d \  -f 2)
 
R_FILES := $(wildcard R/*.R)
SRC_FILES := $(wildcard src/*) $(addprefix src/, $(COPY_SRC))
PKG_FILES := DESCRIPTION NAMESPACE $(R_FILES) $(SRC_FILES)
 
.PHONY: tarball install check clean build
 
tarball:
$(PKG_NAME)_$(PKG_VERSION).tar.gz: $(PKG_FILES)
	R CMD build --no-build-vignettes .
 
check: $(PKG_NAME)_$(PKG_VERSION).tar.gz
	R CMD check $(PKG_NAME)_$(PKG_VERSION).tar.gz
	Rscript -e "devtools::check()"
 
build: $(PKG_NAME)_$(PKG_VERSION).tar.gz
	R CMD build --no-build-vignettes .
 
install: $(PKG_NAME)_$(PKG_VERSION).tar.gz
	R CMD INSTALL $(PKG_NAME)_$(PKG_VERSION).tar.gz
 
NAMESPACE: $(R_FILES)
	Rscript -e "library(roxygen2);roxygenize('.')"

test:
	Rscript -e "devtools::test()"
 
clean:
	-rm -f $(PKG_NAME)_*.tar.gz
	-rm -r -f $(PKG_NAME).Rcheck
	-rm -r -f man/*
	-rm -r -f NAMESPACE
.PHONY: list
list:
	@echo "R files:"
	@echo $(R_FILES)
	@echo "Source files:"
	@echo $(SRC_FILES)

# package has to be installed


######## functions #######################
.PHONY: _vignettes never info
PREVIEW=TRUE
QUIET=FALSE
R=R
RSCRIPT=Rscript
r_exec=$(RSCRIPT) --no-save -e '$(1)'
HTMLVIEWER=xdg-open

# hack rule to prevent previewing documents
disable_preview:
	$(eval PREVIEW=)


# rmd -> html: keep default render/output
rmd=$(call r_exec, rmarkdown::render("$(1)", quiet = $(QUIET)))

### rule to produce a html from a Rmd
%.html: %.Rmd never
	@echo '======== rendering' $$(basename $<) '==>' $$(basename $@) in $$(dirname $@) '====================='
	@$(call rmd,$<)
	@if [ -n "$(PREVIEW)" ]; then $(HTMLVIEWER) $@; fi 	# run the viewer if PREVIEW is not empty 


VIGNETTES_RMD_HTML=$(subst Rmd,html,$(wildcard _vignettes/[^_]*.Rmd))
$(VIGNETTES_RMD_HTML):

# this is needed because R CMD build --vignettes and devtools::build_vignettes() render all
# the vignettes withim the same R session
# in qbdev there is no yet the option to not build vignettes
# did not find a way to unset the environment variables in between each call to the rendering
_vignettes:
	cd _vignettes; \
	R CMD Sweave connection.Rmd ; \
	R CMD Sweave vaults_and_objects.Rmd ;\
	#R CMD Sweave Parallelisation.Rmd ;\
	mkdir -p ../docs ;\
	cp *.Rmd *.R *.html ../docs ;\
	cd ..

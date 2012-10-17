### -*- mode: makefile -*-
### Makefile

# -------------------------------------------------------------------

# ::Pos1::

# List of Author-IDs that provide a file "chapter-AUTHORID.pod"
AUTHOR_IDS_POD = commandline infrastructure preconditions reports-api synopsis tap testsuites usecases webgui

# -------------------------------------------------------------------

EXTRA_FILES = $(shell find . -mindepth 2 -exec echo "{}" \; | grep -v "\.svn\/" | grep -v "\.git\/" | grep -v "\/\.svn$$" | grep -v "\/\.git$$" )

PODAUTHOR_FILES = $(shell for a in $(AUTHOR_IDS_POD) ; do echo chapter-$${a}.tex ; done )

DIST_PODAUTHOR_FILES = $(shell for a in $(AUTHOR_IDS_POD) ; do echo chapter-$${a}.pod ; done )

LOGO_FILES = LOGOS/tapper-frontpage.eps


TITLE = tapper-manual

VERSION = 4.0

MAIN = tapper

STYLES = tapper.sty

EXTRA_DIST = $(TEXFILES) $(EXTRA_FILES)

CLEANFILES = $(addprefix $(MAIN).,aux toc log ind ilg idx) \
             $(TGZTARGET) \
             $(ZIPTARGET) \
             $(PODAUTHOR_FILES)

MAINTAINERCLEANFILES = $(MAIN).pdf $(MAIN).dvi $(MAIN).ps

MAINFILES = Makefile              \
            $(MAIN).ist           \
            $(EXTRA_FILES)        \
            $(STYLES)             \
            $(MAIN).tex           \
            $(LOGO_FILES)         \
            $(PODAUTHOR_FILES)    \
            $(PNG_AUTHOR_FILES)

DOCFILES = README

TMPBASE = tmpdistaffezomtec

TMPSUBDIR = $(TITLE)-$(VERSION)

TMPDIR = $(TMPBASE)/$(TMPSUBDIR)

DISTFILES = Makefile                  \
            $(MAIN).tex               \
            $(MAIN).ist               \
            $(EXTRA_FILES)            \
            $(STYLES)                 \
            $(DOCFILES)               \
            $(DIST_PODAUTHOR_FILES)


ZIPTARGET = $(TITLE)-$(VERSION).zip

TGZTARGET = $(TITLE)-$(VERSION).tgz


# commands
MAKEINDEX = makeindex -s $(MAIN).ist


# PerlPoint stuff
# CONVERT=PLEASE_CONFIGURE_MAKEFILE_FIRST
CONVERT=convert

# local targets
# ps pdf
all-local: pdf dvi misc
	@echo ""
	@echo "FILE OVERVIEW:"
	@echo "  extra:" $(EXTRA_FILES)
	@echo "  pod:"   $(PODAUTHOR_FILES)
	@echo "  png:"   $(PNG_AUTHOR_FILES)

clean:
	rm -f $(CLEANFILES)

mrproper: clean
	rm -f $(MAINTAINERCLEANFILES)

dist: zip

tgz:
	mkdir -p $(TMPDIR)
	tar cf - $(DISTFILES) | tar -C $(TMPDIR) -xf -
	tar -C $(TMPBASE) -czf $(TGZTARGET) $(TMPSUBDIR)
	rm -fr $(TMPBASE)

zip:
	mkdir -p $(TMPDIR)
	tar cf - $(DISTFILES) | tar -C $(TMPDIR) -xf -
	cd $(TMPBASE) ; zip -r ../$(ZIPTARGET) $(TMPSUBDIR)
	rm -fr $(TMPBASE)

pdf: $(MAIN).pdf

dvi: $(MAIN).dvi

ps: $(MAIN).ps

# XXX needed?
bb:
	ebb *png *jpg 2>/dev/null

# implicit rules

PFEIFFER/%.eps: PFEIFFER/%.png
	convert $< $@

%.eps: %.png
	convert $< $@

%.eps: %.jpg
	convert $< $@

%.eps: %.gif
	convert $< $@

%.eps: %.tif
	convert $< $@

%.pdf: %.dvi
	dvipdfm $<

%.ps: %.dvi
	dvips $<

%.zip: %.dvi
	zip $(MAIN).zip $(MAIN).pdf

%.dvi: %.tex
	latex $<
	$(MAKEINDEX) $(MAIN).idx
	latex $<
	latex $<

%.tex: %.pod
	pod2latex $<
	perl -pni -e 's,^\\subsection\*,\\subsection,g' $@
	perl -pni -e 's,^\\subsubsection\*,\\subsubsection,g' $@

# dependencies

$(MAIN).ps:  $(MAIN).dvi
$(MAIN).pdf: $(MAIN).dvi
$(MAIN).dvi: $(MAINFILES)

# -------------------------------------------------------------------
# conversions of POD/PerlPoint author articles

# ::Pos2::

# tex image dependencies

# pod
chapter-commandline.tex: chapter-commandline.pod
chapter-infrastructure.tex: chapter-infrastructure.pod
chapter-preconditions.tex: chapter-preconditions.pod
chapter-reports-api.tex: chapter-reports-api.pod
chapter-synopsis.tex: chapter-synopsis.pod
chapter-tap.tex: chapter-tap.pod
chapter-testsuites.tex: chapter-testsuites.pod
chapter-usecases.tex: chapter-usecases.pod
chapter-webgui.tex: chapter-webgui.pod

# -------------------------------------------------------------------
# misc activities

misc:

# -------------------------------------------------------------------

### Makefile ends here


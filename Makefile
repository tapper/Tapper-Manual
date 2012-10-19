### -*- mode: makefile -*-
### Makefile

# -------------------------------------------------------------------

CHAPTER_FILES = chapter-overview.tex \
                chapter-synopsis.tex \
                chapter-infrastructure.tex \
	        chapter-tap.tex \
                chapter-testsuites.tex \
                chapter-preconditions.tex \
	        chapter-commandline.tex \
                chapter-webgui.tex \
                chapter-reports-api.tex \
	        chapter-usecases.tex

EXTRA_FILES = $(shell find . -mindepth 2 -exec echo "{}" \; | grep -v "\.svn\/" | grep -v "\.git\/" | grep -v "\/\.svn$$" | grep -v "\/\.git$$" )

LOGO_FILES = LOGOS/tapper-frontpage.eps

TITLE = tapper-manual

VERSION = 4.0

MAIN = tapper

STYLES = tapper.sty

CLEANFILES = $(addprefix $(MAIN).,aux toc log ind ilg idx) \
             $(TGZTARGET) \
             $(ZIPTARGET) \
             $(CHAPTER_FILES)

MAINTAINERCLEANFILES = $(MAIN).pdf $(MAIN).dvi $(MAIN).ps

MAINFILES = Makefile              \
            $(MAIN).ist           \
            $(EXTRA_FILES)        \
            $(STYLES)             \
            $(MAIN).tex           \
            $(LOGO_FILES)         \
            $(CHAPTER_FILES)      \
            $(PNG_AUTHOR_FILES)

DOCFILES = README

TMPBASE = tmpdistaffezomtec

TMPSUBDIR = $(TITLE)-$(VERSION)

TMPDIR = $(TMPBASE)/$(TMPSUBDIR)

# commands
MAKEINDEX = makeindex -s $(MAIN).ist


# PerlPoint stuff
# CONVERT=PLEASE_CONFIGURE_MAKEFILE_FIRST
CONVERT = convert

# local targets
# ps pdf
all-local: pdf dvi

clean:
	rm -f $(CLEANFILES)

mrproper: clean
	rm -f $(MAINTAINERCLEANFILES)

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

### Makefile ends here


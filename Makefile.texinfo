### Makefile --- 

# -------------------------------------------------------------------

EXTRA_FILES = $(shell find . -mindepth 2 -exec echo "{}" \; | grep -v "\.svn\/" | grep -v "\.git\/" | grep -v "\/\.svn$$" | grep -v "\/\.git$$" )

LOGO_FILES = 

# -------------------------------------------------------------------

TITLE = tapper

VERSION = 3.0

MAIN = tapper-manual
MAIN2 = tapper-devel

CHAPTERS_POD  = $(wildcard chapter-*.pod)
CHAPTERS_TEXI = $(wildcard chapter-*.texi)

EXTRA_DIST = $(TEXFILES) $(EXTRA_FILES)

CLEANFILES = $(addprefix $(MAIN).,aux  toc log ind ilg idx vr tp pg ky fn cps cp) \
             $(addprefix $(MAIN2).,aux toc log ind ilg idx vr tp pg ky fn cps cp) \
             $(TGZTARGET)    \
             $(ZIPTARGET)

MAINTAINERCLEANFILES = $(MAIN).pdf  $(MAIN).dvi  $(MAIN).ps \
                       $(MAIN2).pdf $(MAIN2).dvi $(MAIN2).ps

# $(MAIN2).texi
MAINFILES = Makefile              \
            $(EXTRA_FILES)        \
            $(MAIN).texi          \
            $(CHAPTERS_TEXI)      \
            $(LOGO_FILES)

DOCFILES = README  

TMPBASE = tmpdistaffezomtec

TMPSUBDIR = $(TITLE)-$(VERSION)

TMPDIR = $(TMPBASE)/$(TMPSUBDIR)

# $(MAIN2).texi
DISTFILES = Makefile                  \
            $(MAIN).texi              \
            $(CHAPTERS_TEXI)          \
            $(EXTRA_FILES)            \
            $(DOCFILES)

ZIPTARGET = $(TITLE)-$(VERSION).zip

TGZTARGET = $(TITLE)-$(VERSION).tgz

all: dvi

clean:
	rm -f $(CLEANFILES)

maintainerclean: clean
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

# $(MAIN2).pdf
pdf: $(MAIN).pdf $(CHAPTERS_TEXI)

# $(MAIN2).dvi
dvi: $(MAIN).dvi $(CHAPTERS_TEXI)

# $(MAIN2).ps
ps: $(MAIN).ps

html: $(MAIN).texi $(CHAPTERS_TEXI)
	makeinfo --html --no-split --force $<

web: html
	perl -p0ni -e 's,<html.*<body>,<div class="tappermanual">,msg' $(MAIN).html
	perl -p0ni -e 's,</body>.*,</div><!-- class="tappermanual"-->,msg' $(MAIN).html
#	perl -p0ni -e 's,<div class="node">.*?</div>,,msg' $(MAIN).html
	@echo " "
	@echo "You should now copy the result into the Web subdir, like this:"
	@echo "  " cp $(MAIN).html ../../src/Tapper-Reports-Web/root/tapper/manual/index.mas
	@echo "  " cp $(MAIN).pdf  ../../src/Tapper-Reports-Web/root/tapper/static/manual/$(MAIN).pdf

# implicit rules

%.dvi: %.texi
	-texi2dvi -b $< -o $@

%.eps: %.png
	convert $< $@

%.eps: %.jpg
	convert $< $@

%.eps: %.gif
	convert $< $@

%.eps: %.tif
	convert $< $@

%.pdf: %.texi
	-texi2pdf -b $< -o $@

%.ps: %.dvi
	dvips $<

# $(MAIN2).pdf
%.zip: %.dvi
	zip $(MAIN).zip $(MAIN).pdf

# dependencies

# -------------------------------------------------------------------

$(MAIN).ps:  $(MAIN).dvi
$(MAIN).pdf: $(MAINFILES)
$(MAIN).dvi: $(MAINFILES)

$(MAIN2).ps:  $(MAIN2).dvi
$(MAIN2).pdf: $(MAINFILES)
$(MAIN2).dvi: $(MAINFILES)

# -------------------------------------------------------------------

### Makefile ends here


MANDOC = concursos
TFMDOC = metodologias
DOCS = $(wildcard *.tex)
TFMDVIFILE = $(patsubst %,%.dvi,$(TFMDOC))
TFMPSFILE = $(patsubst %,%.ps,$(TFMDOC))
TFMPDFFILE = $(patsubst %,%.pdf,$(TFMDOC))
MANDVIFILE = $(patsubst %,%.dvi,$(MANDOC))
MANPSFILE = $(patsubst %,%.ps,$(MANDOC))
MANPDFFILE = $(patsubst %,%.pdf,$(MANDOC))

TEXCODE = $(patsubst code/%.cc, code/%.tex, $(wildcard code/*.cc))

tfm:  $(TFMPDFFILE) 
man:  $(MANPDFFILE)

$(TFMDVIFILE): $(TEXCODE) ${DOCS} 
$(TFMPDFFILE): $(TEXCODE) ${DOCS} 
$(MANDVIFILE): $(TEXCODE) ${DOCS} 
$(MANPDFFILE): $(TEXCODE) ${DOCS} 


code/%.tex: code/%.cc
	cpp2latex -h -s 0 -t 4 $< > code/$*.tex 
	#lgrind -i -lc -t 4 $< > code/$*.tex

%.pdf: %.tex
	pdflatex --shell-escape $*
	bibtex $*
	pdflatex --shell-escape $*
	pdflatex --shell-escape $*

%.dvi: %.tex
	latex  $*
	bibtex $*
	latex  $*
	latex  $*

%.ps: %.dvi
	dvips $< -o $@

#%.pdf: %.ps
#	ps2pdf -dMaxSubsetPct=100 -dCompatibilityLevel=1.2 -dSubsetFonts=true -dEmbedAllFonts=true $<

clean:
	@rm -f *.bbl *.blg *.dvi *~ *.ps *.aux *.log *.pdf *.bak *.toc *.lof *.lot *.out *.tdo

.PHONY: all clean rebuild

all: presentation.pdf handout.pdf presentation-pympress.pdf presentation.pdfpc

clean:
	rm handout.pdf presentation.pdf examples/*.svg

rebuild: clean all

examples/%.svg: examples/%.typ
	typst compile --root examples --pages 1 $^ $@

SVG_FILES := $(patsubst examples/%.typ,examples/%.svg,$(wildcard examples/*.typ))

presentation.pdf: main.typ utils.typ images/* $(SVG_FILES)
	typst compile main.typ $@

presentation-pympress.pdf: main.typ utils.typ images/* $(SVG_FILES)
	typst compile main.typ $@ --input show-notes=true

presentation.pdfpc: main.typ presentation.pdf
	typst query main.typ --field value --one "<pdfpc-file>" > $@

handout.pdf: main.typ utils.typ images/* $(SVG_FILES)
	typst compile main.typ $@ --input handout=true

images/typst-talk.png: main.typ utils.typ images/* $(SVG_FILES)
	typst compile main.typ $@ --pages=1
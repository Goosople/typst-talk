.PHONY: all clean rebuild

all: presentation.pdf handout.pdf

clean:
	rm handout.pdf presentation.pdf examples/*.svg

rebuild: clean all

examples/%.svg: examples/%.typ
	typst compile --root examples --pages 1 $^ $@

SVG_FILES := $(patsubst examples/%.typ,examples/%.svg,$(wildcard examples/*.typ))

presentation.pdf: main.typ utils.typ images/* $(SVG_FILES)
	typst compile main.typ $@

handout.pdf: main.typ utils.typ images/* $(SVG_FILES)
	typst compile main.typ $@ --input handout=true
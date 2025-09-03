.PHONY: all

all: presentation.pdf handout.pdf

examples/%.svg: examples/%.typ
	typst compile --root examples --pages 1 $^ $@

SVG_FILES := $(patsubst examples/%.typ,examples/%.svg,$(wildcard examples/*.typ))

presentation.pdf: main.typ $(SVG_FILES)
	typst compile main.typ $@

handout.pdf: main.typ $(SVG_FILES)
	typst compile main.typ $@ --input handout=true
.PHONY: build clean

build:
	@mkdir -p bin
	@ocamlfind ocamlc -w A -linkpkg -package unix -o bin/curl lib/curl.ml

clean:
	@rm -rf bin
	@find \
		. \
			-name '*.o' \
		-or -name '*.cmi' \
		-or -name '*.cmo' \
		-or -name '*.cmx' \
	| xargs rm -f
